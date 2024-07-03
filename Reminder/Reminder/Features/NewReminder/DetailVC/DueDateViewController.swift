//
//  DueDateViewController.swift
//  Reminder
//
//  Created by 황민채 on 7/4/24.
//

import UIKit

class DueDateViewController: BaseViewController {

    var dateSelected: ((Date) -> Void)?
    var tempDate = Date()
    
    private lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        picker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
       
        return picker
    }()
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print(#function)
        print(tempDate)
        dateSelected?(tempDate)
    }
    
    override func configureHierarchy() {
        view.addSubview(datePicker)
    }
    
    override func configureLayout() {
        datePicker.snp.makeConstraints { make in
            make.center.equalTo(view.snp.center)
        }
    }
    
    override func configureView() {
        view.backgroundColor = .modalBg
    }
    
    @objc private func dateChanged(_ sender: UIDatePicker) {
        tempDate = sender.date
        print("에에에ㅔ엥??ㅋ")
    }
}
