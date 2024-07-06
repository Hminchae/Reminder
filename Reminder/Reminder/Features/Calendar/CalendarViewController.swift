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
        
        calendar.scrollEnabled = true
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
    
    // MARK: override 메서드
    override func configureHierarchy() {
        view.addSubview(calendarView)
    }
    
    override func configureLayout() {
        calendarView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.height.equalTo(300)
        }
    }
    
    override func configureView() {
        view.backgroundColor = .modalBg
        configureSwipeGestures()
    }
    
    // MARK: 사용자 정의 메서드
    private func configureSwipeGestures() {
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeUp.direction = .up
        swipeUp.delegate = self
        calendarView.addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeDown.direction = .down
        swipeDown.delegate = self
        calendarView.addGestureRecognizer(swipeDown)
    }

    @objc private func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        switch gesture.direction {
        case .up:
            // 주별 보기로 변경
            if calendarView.scope != .week {
                calendarView.setScope(.week, animated: true)
            }
        case .down:
            // 월별 보기로 변경
            if calendarView.scope != .month {
                calendarView.setScope(.month, animated: true)
            }
        default:
            break
        }
    }
}

extension CalendarViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        // 모달의 내장 스와이프와 동시에 인식되도록 허용
        return true
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
