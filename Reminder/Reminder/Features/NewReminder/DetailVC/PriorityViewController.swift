//
//  PriorityViewController.swift
//  Reminder
//
//  Created by 황민채 on 7/4/24.
//

import UIKit

final class PriorityViewController: BaseViewController {
    
    private lazy var segmentedControl: UISegmentedControl = {
        let items = ["높음", "보통", "낮음"]
        let control = UISegmentedControl(items: items)
        control.selectedSegmentIndex = 1
        control.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)
        return control
    }()
    
    var priorityChanged: ((String) -> Void)?
    var tempPriority = ""
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print(#function)
        print(tempPriority)
        priorityChanged?(tempPriority)
    }
    
    override func configureHierarchy() {
        view.addSubview(segmentedControl)
    }
    
    override func configureLayout() {
        segmentedControl.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(300)
            make.height.equalTo(40)
        }
    }
    
    override func configureView() {
        view.backgroundColor = .modalBg
    }
    
    @objc private func segmentChanged(_ sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        let priority = sender.titleForSegment(at: index) ?? "보통"
        tempPriority = priority
    }
}
