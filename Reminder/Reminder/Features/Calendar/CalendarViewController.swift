//
//  CalendarViewController.swift
//  Reminder
//
//  Created by 황민채 on 7/6/24.
//

import UIKit

import FSCalendar

final class CalendarViewController: BaseViewController {
    
    // 현재 캘린더가 보여주고 있는 Page 트래킹
    lazy var currentPage = calendarView.currentPage
    
    private lazy var calendarView = {
        let calendar = FSCalendar()
        calendar.dataSource = self
        calendar.delegate = self
        
        calendar.firstWeekday = 1 // 첫열을 일요일로
        calendar.scope = .month
        
        calendar.scrollEnabled = false
        calendar.locale = Locale(identifier: "ko_KR")
        
        calendar.placeholderType = .none
        
        // 헤더뷰
        calendar.headerHeight = 50
        calendar.appearance.headerDateFormat = "M월"
        calendar.appearance.headerTitleColor = .label
        
        // 요일 UI
        calendar.appearance.weekdayFont = REFont.m12
        calendar.appearance.weekdayTextColor = .label
        
        // 날짜 UI
        calendar.appearance.titleTodayColor = .black
        calendar.appearance.titleFont = REFont.r16
        calendar.appearance.subtitleFont = REFont.r10
        calendar.appearance.subtitleTodayColor = .systemBlue
        calendar.appearance.todayColor = .white.withAlphaComponent(0.1)
        
        // 일요일 red, 토요일 blue
        calendar.calendarWeekdayView.weekdayLabels[0].textColor = .systemRed
        calendar.calendarWeekdayView.weekdayLabels.last!.textColor = .systemBlue
        
        return calendar
    }()
    
    // 이전 달로 이동 버튼
    private lazy var preButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.tintColor = .label
        button.addTarget(self, action: #selector(moveMonthButtonClicked), for: .touchUpInside)
        
        return button
    }()
    
    // 다음 달로 이동 버튼
    private lazy var postButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        button.tintColor = .label
        button.addTarget(self, action: #selector(moveMonthButtonClicked), for: .touchUpInside)
        
        return button
    }()
    
    // MARK: override 메서드
    override func configureHierarchy() {
        view.addSubview(calendarView)
        view.addSubview(preButton)
        view.addSubview(postButton)
    }
    
    override func configureLayout() {
        calendarView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.height.equalTo(300)
        }
        
        preButton.snp.makeConstraints { make in
            make.top.equalTo(calendarView.snp.top).offset(10)
            make.leading.equalTo(calendarView.snp.leading)
            make.size.equalTo(30)
        }
        
        postButton.snp.makeConstraints { make in
            make.top.equalTo(calendarView.snp.top).offset(10)
            make.trailing.equalTo(calendarView.snp.trailing)
            make.size.equalTo(30)
        }
    }
    
    override func configureView() {
        view.backgroundColor = .modalBg
    }
    
    // MARK: 사용자 정의 메서드
    @objc private func moveMonthButtonClicked(_ sender: UIButton) {
        moveMonth(next: sender == postButton)
    }
    
    // 달 이동 로직
    func moveMonth(next: Bool) {
        var dateComponents = DateComponents()
        dateComponents.month = next ? 1 : -1
        
        self.currentPage = Calendar.current.date(byAdding: dateComponents, to: self.currentPage)!
        
        calendarView.setCurrentPage(self.currentPage, animated: true)
    }
}

extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource {
    
    // 공식 레이아웃을 위해 요구하는 코드
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendar.snp.updateConstraints { make in
            make.height.equalTo(bounds.height)
        }
        
        self.view.layoutIfNeeded()
    }
    
    // 오늘 cell 에 subtitle 생성하도록 하는 코드
    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        switch dateFormatter.string(from: date) {
        case dateFormatter.string(from: Date()):
            return "오늘"
        default:
            return nil
        }
    }
}

extension CalendarViewController: FSCalendarDelegateAppearance {
    
    // 일요일에 해당하는 모든 날짜의 색상을 red로 변경
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        let day = Calendar.current.component(.weekday, from: date) - 1
        let week = Calendar.current.shortWeekdaySymbols[day]
        
        switch week {
        case "Sun":
            return .systemRed
        case "Sat":
            return .systemBlue
        default:
            return .label
        }
    }
}
