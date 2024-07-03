//
//  ListDetailViewController.swift
//  Reminder
//
//  Created by 황민채 on 7/2/24.
//

import UIKit

import RealmSwift

class ListDetailViewController: BaseViewController {
    
    var navigationTitle: String?
    private var list: Results<TodoTable>!
    private let realm = try! Realm()
    
    lazy private var tableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ListDetailTableViewCell.self,
                           forCellReuseIdentifier: ListDetailTableViewCell.identifier)
        
        return tableView
    }()
    
    private lazy var newReminderButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.plain()
        
        configuration.title = "새로운 미리 알림"
        configuration.image = UIImage(systemName: "plus.circle.fill")
        configuration.imagePadding = 5
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 10)
        configuration.baseForegroundColor = .systemBlue
        
        button.configuration = configuration
        
        button.addTarget(self, action: #selector(newReminderButtonClicked), for: .touchUpInside)
        
        return button
    }()
    
    override func configureHierarchy() {
        view.addSubview(tableView)
        view.addSubview(newReminderButton)
    }
    
    override func configureLayout() {
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.snp.bottom)
        }
        
        newReminderButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalTo(view.snp.leading).offset(10)
            make.height.equalTo(40)
        }
    }
    
    override func configureView() {
        configureNavigationBar()
        
        list = realm.objects(TodoTable.self)
    }
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        
        if let navigationTitle {
            title = navigationTitle
        }
        let share = UIBarButtonItem(
            image: UIImage(systemName: "square.and.arrow.up"),
            style: .plain,
            target: self,
            action: #selector(shareButtonClicked))
        
        let configure = UIBarButtonItem(
            image: UIImage(systemName: "ellipsis.circle"),
            style: .plain,
            target: self,
            action: #selector(configureButtonClicked))
        
        navigationItem.rightBarButtonItems = [configure, share]
    }
    
    @objc private func newReminderButtonClicked() {
        print("새로운 미리 알림 기능 구현")
    }
    
    @objc private func shareButtonClicked() {
        print("공유버튼 기능 구현")
    }
    
    @objc private func configureButtonClicked() {
        print("구성버튼 기능 구현")
    }
}

extension ListDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ListDetailTableViewCell.identifier, for: indexPath)
        guard let cell = cell as? ListDetailTableViewCell else { return UITableViewCell() }
        
        let data = list[indexPath.row]
        
        cell.radioButton = RadioButton(style: .selected(color: .brown))
        cell.titleTextField.text = data.momoTitle
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let detail = UIContextualAction(style: .normal, title: "세부사항") { (action, view, completionHandler) in
            // TODO: 디테일 vc 구현
            completionHandler(true)
        }
        
        let flag = UIContextualAction(style: .normal, title: "깃발") { (action, view, completionHandler) in
            // TODO: 깃발 기능 구현
            completionHandler(true)
        }
        
        let delete = UIContextualAction(style: .destructive, title: "삭제") { [weak self] (action, view, completionHandler) in
            
            guard let itemToDelete = self?.realm.object(ofType: TodoTable.self, forPrimaryKey: self?.list[indexPath.row].id) else {
                completionHandler(false)
                return
            }
            
            try? self?.realm.write {
                self?.realm.delete(itemToDelete)
            }
            
            tableView.reloadData()
            completionHandler(true)
        }
        
        detail.backgroundColor = .systemGray
        flag.backgroundColor = .systemOrange

        let config = UISwipeActionsConfiguration(actions: [delete, flag, detail])
        
        return config
    }
}
