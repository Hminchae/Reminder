//
//  ListDetailTableViewCell.swift
//  Reminder
//
//  Created by 황민채 on 7/3/24.
//

import UIKit

// 컴포너트 셀 : 라디오버튼과 타이틀 있는 셀
final class ReminderTableViewCell: BaseTableViewCell {
    
    var radioButton = RadioButton(style: .unselected)
    
    var priorityLabel = {
        let label = UILabel()
        label.font = REFont.m16
        label.textColor = .systemBlue
        
        return label
    }()
    
    var titleTextField = {
        let textField = UITextField()
        textField.font = REFont.m16
        textField.textColor = .label
        
        return textField
    }()
    
    var contentTextField = {
        let textField = UITextField()
        textField.font = REFont.r14
        textField.textColor = .darkGray
        
        return textField
    }()
    
    var dueDateLabel = {
        let label = UILabel()
        label.font = REFont.r14
        label.textColor = .darkGray
        
        return label
    }()
    
    var tagLabel = {
        let label = UILabel()
        label.font = REFont.r14
        label.textColor = .systemBlue.withAlphaComponent(0.7)
        
        return label
    }()
    
    override func configureHierarchy() {
        contentView.addSubview(radioButton)
        contentView.addSubview(priorityLabel)
        contentView.addSubview(titleTextField)
        contentView.addSubview(contentTextField)
        contentView.addSubview(dueDateLabel)
        contentView.addSubview(tagLabel)
    }
    
    override func configureLayout() {
        radioButton.snp.remakeConstraints { make in
            make.leading.equalTo(contentView.snp.leading).offset(10)
            make.centerY.equalTo(contentView.snp.centerY)
            make.size.equalTo(20)
        }
        
        priorityLabel.snp.remakeConstraints { make in
            make.leading.equalTo(radioButton.snp.trailing).offset(10)
            make.centerY.equalTo(contentView.snp.centerY)
            make.width.equalTo(3)
        }
        
        titleTextField.snp.remakeConstraints { make in
            make.leading.equalTo(priorityLabel.snp.trailing).offset(2)
            make.centerY.equalTo(contentView.snp.centerY)
            make.trailing.equalTo(contentView.snp.trailing).inset(10)
        }
        
        contentTextField.snp.remakeConstraints { make in
            if contentTextField.isHidden {
                make.height.equalTo(0)
            } else {
                make.leading.equalTo(priorityLabel.snp.leading)
                make.top.equalTo(titleTextField.snp.bottom).offset(8)
                make.trailing.equalTo(contentView.snp.trailing).inset(10)
            }
        }
        
        dueDateLabel.snp.remakeConstraints { make in
            if dueDateLabel.isHidden {
                make.height.equalTo(0)
            } else {
                make.leading.equalTo(priorityLabel.snp.leading)
                make.top.equalTo(contentTextField.snp.bottom).offset(5)
            }
        }
        
        tagLabel.snp.remakeConstraints { make in
            if tagLabel.isHidden {
                make.height.equalTo(0)
            } else {
                make.leading.equalTo(dueDateLabel.snp.trailing).offset(2)
                make.top.equalTo(dueDateLabel.snp.top)
                make.trailing.equalTo(contentView.snp.trailing).inset(10)
            }
        }
    }
    
    override func configureView() {
        priorityLabel.isHidden = true
        contentTextField.isHidden = true
        dueDateLabel.isHidden = true
        tagLabel.isHidden = true
    }
    
    override var isHidden: Bool {
        didSet {
            configureLayout()
        }
    }
}

