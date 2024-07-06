//
//  CalendarViewController.swift
//  Reminder
//
//  Created by 황민채 on 7/6/24.
//

import UIKit

import FSCalendar

final class CalendarViewController: BaseViewController {
    
    private let calendar = {
        let calendar = FSCalendar()
        
        return calendar
    }()
    
    override func configureHierarchy() {
        view.addSubview(calendar)
    }
    
    override func configureLayout() {
        calendar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
    }
    
    override func configureView() {
        view.backgroundColor = .modalBg
    }
}
