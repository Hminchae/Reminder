//
//  TagViewController.swift
//  Reminder
//
//  Created by 황민채 on 7/4/24.
//

import UIKit

final class TagViewController: BaseViewController {
    
    var tagWrited: ((String) -> Void)?
    var tempTag = ""
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "태그를 입력하게요"
        textField.addTarget(self, action: #selector(tagChanged(_:)), for: .editingChanged)
        
        return textField
    }()
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print(#function)
        print(tempTag)
        tagWrited?(tempTag)
    }
    
    override func configureHierarchy() {
        view.addSubview(textField)
    }
    
    override func configureLayout() {
        textField.snp.makeConstraints { make in
            make.center.equalTo(view.snp.center)
        }
    }
    
    override func configureView() {
        view.backgroundColor = .modalBg
    }
    
    @objc private func tagChanged(_ sender: UITextField) {
        guard let text = sender.text, !text.isEmpty else { return }
        tempTag = text
        print("에에에ㅔ엥??ㅋ")
    }
}
