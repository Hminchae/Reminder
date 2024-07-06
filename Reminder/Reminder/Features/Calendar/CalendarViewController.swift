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
    
    private var repository = TodoTableRepository()
    lazy var list: [TodoTable] = []

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
    
    lazy private var tableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ReminderTableViewCell.self,
                           forCellReuseIdentifier: ReminderTableViewCell.identifier)
        
        return tableView
    }()
    
    // MARK: override 메서드
    override func configureHierarchy() {
        view.addSubview(calendarView)
        view.addSubview(tableView)
    }
    
    override func configureLayout() {
        calendarView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.height.equalTo(300)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(calendarView.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.height.equalTo(200)
        }
    }
    
    override func configureView() {
        view.backgroundColor = .modalBg
        
        configureSwipeGestures()
        
        list = repository.fetchTodosDueBy(date: Date())
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
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        list = repository.fetchTodosDueBy(date: date)
        tableView.reloadData()
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

extension CalendarViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let cell = textField.superview?.superview as? ReminderTableViewCell,
              let indexPath = tableView.indexPath(for: cell) else {
            return
        }

        let data = list[indexPath.row] // 현재 편집 중인 데이터
        if let text = textField.text, !text.isEmpty {
            // 텍스트 필드에 내용이 있는 경우
            data.memoTitle = text
            repository.createItem(data)
        } else {
            // 텍스트 필드가 비어 있는 경우
            list.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

extension CalendarViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReminderTableViewCell.identifier, for: indexPath)
        guard let cell = cell as? ReminderTableViewCell else { return UITableViewCell() }
        
        let data = list[indexPath.row]
        
        cell.radioButton = RadioButton(style: .selected(color: .brown))
        cell.titleTextField.delegate = self
        cell.titleTextField.text = data.memoTitle
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let detail = UIContextualAction(style: .normal, title: "세부사항") { (action, view, completionHandler) in
            let vc = UINavigationController(rootViewController:  NewReminderViewController())
            self.present(vc, animated: true)
            
            completionHandler(true)
        }
        
        let flag = UIContextualAction(style: .normal, title: "깃발") { (action, view, completionHandler) in
            // TODO: 깃발 기능 구현
            completionHandler(true)
        }
        
        let delete = UIContextualAction(style: .destructive, title: "삭제") { [weak self] (action, view, completionHandler) in
            
            guard let data = self?.list[indexPath.row] else { return }
            
            self?.removeImageFromDocument(filename: "\(data.id)")
            self?.repository.deleteItem(data)
            
            self?.list.remove(at: indexPath.row) // <- 리스트 삭제가 필요함
            
            tableView.reloadData()
            
            completionHandler(true)
        }
        
        detail.backgroundColor = .systemGray
        flag.backgroundColor = .systemOrange
        
        let config = UISwipeActionsConfiguration(actions: [delete, flag, detail])
        
        return config
    }
}
