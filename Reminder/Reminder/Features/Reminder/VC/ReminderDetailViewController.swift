//
//  ReminderDetailViewController.swift
//  Reminder
//
//  Created by 황민채 on 7/8/24.
//

import Foundation

final class ReminderDetailViewController: BaseViewController {
    
    private var repository = TodoTableRepository()

    lazy var list: [TodoTable] = []
    
    
    override func configureHierarchy() {
        
    }
    
    override func configureLayout() {
        
    }
    
    override func configureView() {
        configureNavigationBar()
    }
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "상세 화면"
    }
    
}
 
