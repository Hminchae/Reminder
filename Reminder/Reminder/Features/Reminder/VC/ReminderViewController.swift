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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureList()
    }
    
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
    
    // 화면에 들어와서 리스트를 업데이트 해줄까..
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
        print("새로운 미리 알림 기능 구현")
    }
    
    @objc private func shareButtonClicked() {
        print("공유버튼 기능 구현")
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
