//
//  ListDetailViewController.swift
//  Reminder
//
//  Created by 황민채 on 7/2/24.
//

import UIKit


final class ReminderViewController: BaseViewController {
    
    private var repository = TodoTableRepository()
    
    var navigationTitle: String?
    var category: View.MainCategory?
    
    lazy var list: [TodoTable] = []
    
    
    lazy private var tableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ReminderTableViewCell.self,
                           forCellReuseIdentifier: ReminderTableViewCell.identifier)
        
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
        configureList()
        configureGesture()

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
        
        let configure = UIButton(type: .system)
        configure.setImage(UIImage(systemName: "ellipsis.circle"), for: .normal)
        configure.showsMenuAsPrimaryAction = true
        configure.menu = configureMenu()
        
        let configureItem = UIBarButtonItem(customView: configure)
        
        navigationItem.rightBarButtonItems = [configureItem, share]
    }
    
    private func configureList() {
        guard let category else { return }
        
        list = repository.fetchAll(category, sortType: .registerDate(asc: true))
    }
    
    private func configureGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(newReminderButtonClicked))
        view.addGestureRecognizer(tapGesture)
    }
    
    private func configureMenu() -> UIMenu {
        guard let category else { return UIMenu() }
        
        let sortActions = Sort.TypeOf.allCases.map { sortType in
            return UIAction(title: sortType.name) { [weak self] _ in
                print("너")
                switch sortType {
                case .dueDate:
                    print("어 ??????")
                    self?.list = self?.repository.fetchAll(category, sortType: .dueDate(asc: sortType.isAsc)) ?? []
                    print(self?.list)
                case .registerDate:
                    self?.list = self?.repository.fetchAll(category, sortType: .dueDate(asc: sortType.isAsc)) ?? []
                case .priority:
                    self?.list = self?.repository.fetchAll(category, sortType: .dueDate(asc: sortType.isAsc)) ?? []
                case .title:
                    self?.list = self?.repository.fetchAll(category, sortType: .dueDate(asc: sortType.isAsc)) ?? []
                }
                print("적용되냐")
                self?.tableView.reloadData()
            }
        }
        
        return UIMenu(title: "", children: sortActions)
    }
    
    @objc private func newReminderButtonClicked() {
        // 마지막 TodoTable 확인
        if let last = list.last {
            let lastIndexPath = IndexPath(row: list.count - 1, section: 0)
            if let cell = tableView.cellForRow(at: lastIndexPath) as? ReminderTableViewCell {
                if let title = cell.titleTextField.text, title.isEmpty {
                    // 마지막 cell의 텍스트 필드가 비어있으면 삭제
                    list.removeLast()
                    tableView.deleteRows(at: [lastIndexPath], with: .automatic)
                    return
                }
            }
        }

        // 새 TodoTable 추가
        let data = TodoTable(memoTitle: "",
                             memoContent: nil,
                             category: "미리 알림",
                             registerDate: Date(),
                             dueDate: nil, 
                             tag: nil,
                             priority: nil)
        list.append(data)
        
        let newIndexPath = IndexPath(row: list.count - 1, section: 0)
        tableView.insertRows(at: [newIndexPath], with: .automatic)
        tableView.scrollToRow(at: newIndexPath, at: .bottom, animated: true)
        
        // 포커스 설정
        if let cell = tableView.cellForRow(at: newIndexPath) as? ReminderTableViewCell {
            cell.titleTextField.becomeFirstResponder()
        }
    }

    
    @objc private func shareButtonClicked() {
        print("공유버튼 기능 구현")
    }
}

extension ReminderViewController: UITextFieldDelegate {
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

extension ReminderViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReminderTableViewCell.identifier, for: indexPath)
        guard let cell = cell as? ReminderTableViewCell else { return UITableViewCell() }
        
        let data = list[indexPath.row]
        
        cell.radioButton = RadioButton(style: .selected(color: .brown))
        cell.titleTextField.delegate = self
        
        var tempPriority = ""
        
        if let priority = data.priority {
            cell.priorityLabel.isHidden = false
            switch priority {
            case "낮음":
                tempPriority = "!"
            case "보통":
                tempPriority = "!!"
            case "높음":
                tempPriority = "!!!"
            default:
                tempPriority = ""
            }
        }
        
        cell.priorityLabel.text = tempPriority
        
        if let tag = data.tag {
            cell.tagLabel.isHidden = false
            cell.tagLabel.text = "#\(tag)"
        }
        
        if let dueDate = data.dueDate {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy.MM.dd"
            
            cell.dueDateLabel.isHidden = false
            cell.dueDateLabel.text = formatter.string(from: dueDate)
        }
        
        if let content = data.memoContent {
            cell.contentTextField.isHidden = false
            cell.contentTextField.text = content
        }
        
        cell.titleTextField.text = data.memoTitle
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let detail = UIContextualAction(style: .normal, title: "세부사항") { (action, view, completionHandler) in
            let vc = ReminderDetailViewController()
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
