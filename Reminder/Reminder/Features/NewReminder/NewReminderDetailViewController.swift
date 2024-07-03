//
//  NewReminderDetailViewController.swift
//  Reminder
//
//  Created by 황민채 on 7/4/24.
//

import UIKit

class NewRemindeNewReminderDetailViewControllerrViewController: BaseViewController {
    
    private var selectedDate = Date()
    private let topItemView = UIView()
    
    private let modalTitleLabel = {
        let label = UILabel()
        label.font = REFont.m17
        label.textColor = .label
        label.textAlignment = .center
        label.text = "세부사항"
        
        return label
    }()
    
    private lazy var addButton = {
        let button = UIButton()
        button.setTitle("추가", for: .normal)
        button.addTarget(self, action: #selector(addButtonClicked), for: .touchUpInside)
        button.setTitleColor(.label, for: .normal)
        
        return button
    }()
    
    private lazy var tableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(TitleTableViewCell.self,
                           forCellReuseIdentifier: TitleTableViewCell.identifier)
        
        return tableView
    }()
    
    override func configureHierarchy() {
        view.addSubview(topItemView)
        view.addSubview(tableView)
    }
    
    override func configureLayout() {
        topItemView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(50)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(topItemView.snp.bottom)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.snp.bottom)
        }
    }
    
    override func configureView() {
        setupTopItemView()
    }
    
    private func setupTopItemView() {
        topItemView.backgroundColor = .modalBg
        
        topItemView.addSubview(modalTitleLabel)
        topItemView.addSubview(addButton)
        
        modalTitleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(topItemView.snp.centerX)
            make.centerY.equalTo(addButton.snp.centerY)
        }
        
        addButton.snp.makeConstraints { make in
            make.top.equalTo(topItemView.snp.top).offset(10)
            make.trailing.equalTo(topItemView.snp.trailing).inset(10)
            make.width.equalTo(50)
            make.height.equalTo(20)
        }
    }
    
    @objc private func addButtonClicked() {
        
    }
}

extension NewRemindeNewReminderDetailViewControllerrViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return 1
        case 3:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath)
        guard let cell = cell as? TitleTableViewCell else { return UITableViewCell() }
        cell.titleLabel.text = View.NewREList.allCases[indexPath.section].rawValue
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            let vc = DueDateViewController()
            vc.dateSelected = { [weak self] date in
                self?.selectedDate = date
                
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy.MM.dd"
                
                if let cell = tableView.cellForRow(at: indexPath) as? TitleTableViewCell {
                    cell.resultLabel.text = formatter.string(from: date)
                }
            }
            vc.modalTransitionStyle = .coverVertical
            present(vc, animated: true)
        case 1:
            let vc = TagViewController()
            vc.modalTransitionStyle = .coverVertical
            present(vc, animated: true)
        case 2:
            let vc = PriorityViewController()
            vc.modalTransitionStyle = .coverVertical
            present(vc, animated: true)
        case 3:
            print("호엥?")
        default:
            print("호엥?")
        }
    }
}
