//
//  NewReminderViewController.swift
//  Reminder
//
//  Created by 황민채 on 7/2/24.
//

import UIKit

import PhotosUI

protocol NewReminderContentsDelegate {
    func passTitle(_ text: String)
    func passMemo(_ text: String)
}

class NewReminderViewController: BaseViewController {
    
    private var selectedDate = Date()
    private var writedTag = String()
    private let topItemView = UIView()
    private let repository = TodoTableRepository()
    private var tempPhotoImage: UIImage?
    
    private lazy var tableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NewReminderContentsTableViewCell.self,
                           forCellReuseIdentifier: NewReminderContentsTableViewCell.identifier)
        tableView.register(TitleTableViewCell.self,
                           forCellReuseIdentifier: TitleTableViewCell.identifier)
        
        return tableView
    }()
    
    private var tempReminder: Reminder?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tempReminder = Reminder(title: "", category: .reminder)
    }
    
    override func configureHierarchy() {
        view.addSubview(tableView)
    }
    
    override func configureLayout() {
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.snp.bottom)
        }
    }
    
    override func configureView() {
        configureNavigationItem()
    }
    
    func configureNavigationItem() {
        let cancel = UIBarButtonItem(
            title: "취소",
            style: .plain,
            target: self,
            action: #selector(cancelButtonClicked))
        
        let add = UIBarButtonItem(
            title: "추가",
            style: .plain,
            target: self,
            action: #selector(addButtonClicked))
        
        navigationItem.title = "새로운 미리 알림"
        navigationItem.leftBarButtonItem = cancel
        navigationItem.rightBarButtonItem = add
        navigationController?.navigationBar.backgroundColor = .modalBg
    }
    
    @objc private func addButtonClicked() {
        guard let reminder = tempReminder, !reminder.title.isEmpty else { // 알럿 메니저 만들기
            let alert = UIAlertController(title: "제목이 비어 있습니다", message: "제목을 입력해주세요.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default))
            present(alert, animated: true)
            
            return
        }
        
        let data = TodoTable(memoTitle: reminder.title,
                             memoContent: reminder.memo,
                             category: "미리 알림",
                             registerDate: Date(),
                             dueDate: Date().addingTimeInterval(10000),
                             priority: 1)
        
        repository.createItem(data)
        
        // 이미지 저장
        if let image = tempPhotoImage {
            saveImageToDocument(image: image, filename: "\(data.id)")
        }
        
        dismiss(animated: true)
    }
    
    @objc private func cancelButtonClicked() {
        dismiss(animated: true)
    }
}

extension NewReminderViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 4
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: NewReminderContentsTableViewCell.identifier, for: indexPath)
            guard let cell = cell as? NewReminderContentsTableViewCell else { return UITableViewCell() }
            
            cell.delegate = self
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath)
            guard let cell = cell as? TitleTableViewCell else { return UITableViewCell() }
            
            cell.titleLabel.text = View.NewREList.allCases[indexPath.row].rawValue
            cell.accessoryType = .disclosureIndicator
            
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 200
        case 1:
            return UITableView.automaticDimension
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
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
            navigationController?.pushViewController(vc, animated: true)
        case 1:
            let vc = TagViewController()
            vc.tagWrited = { [weak self] tag in
                self?.writedTag = tag
                
                if let cell = tableView.cellForRow(at: indexPath) as? TitleTableViewCell {
                    cell.resultLabel.text = tag
                }
            }
            navigationController?.pushViewController(vc, animated: true)
        case 2:
            let vc = PriorityViewController()
            vc.priorityChanged = { priority in
                if let cell = tableView.cellForRow(at: indexPath) as? TitleTableViewCell {
                    cell.resultLabel.text = priority
                }
            }
            navigationController?.pushViewController(vc, animated: true)
        case 3:
            addImageButtonClicked()
        default:
            print("ㅜㅜㅜ")
        }
    }
    
    private func addImageButtonClicked() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .any(of: [.images, .depthEffectPhotos])
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        
        present(picker, animated: true)
    }
}

extension NewReminderViewController: NewReminderContentsDelegate {
    func passTitle(_ text: String) {
        print(#function, text)
        tempReminder?.title = text
    }
    
    func passMemo(_ text: String) {
        tempReminder?.memo = text
    }
}

extension NewReminderViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            dismiss(animated: true)
            guard let itemProvider = results.first?.itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) else { return }

            itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                guard let self = self, let image = image as? UIImage else { return }

                DispatchQueue.main.async {
                    let indexPath = IndexPath(row: 3, section: 1)
                    if let cell = self.tableView.cellForRow(at: indexPath) as? TitleTableViewCell {
                        cell.isContainImage = true
                        
                        cell.photoImageView.image = image
                        cell.photoImageView.isHidden = false
                        
                        self.tempPhotoImage = image
                        self.tableView.reloadRows(at: [indexPath], with: .none)
                    }
                }

            }
        }
}
