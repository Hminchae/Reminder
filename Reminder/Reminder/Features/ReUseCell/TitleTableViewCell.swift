//
//  NewReminderDetailTableViewCell.swift
//  Reminder
//
//  Created by 황민채 on 7/3/24.
//

import UIKit

// 컴포넌트 셀 : [ title        result ]
final class TitleTableViewCell: BaseTableViewCell {
    
    var isContainImage = false
    
    let titleLabel = {
        let label = UILabel()
        label.font = REFont.m16
        label.textColor = .label
        
        return label
    }()
    
    var resultLabel = {
        let label = UILabel()
        label.font = REFont.m16
        label.textColor = .label
        
        return label
    }()
    
    let photoImageView = UIImageView()
    
    override func configureHierarchy() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(resultLabel)
    }
    
    override func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(contentView.snp.leading).offset(10)
            make.verticalEdges.equalTo(contentView.snp.verticalEdges).inset(15)
        }
        
        resultLabel.snp.makeConstraints { make in
            make.trailing.equalTo(contentView.snp.trailing).inset(10)
            make.verticalEdges.equalTo(contentView.snp.verticalEdges).inset(15)
        }
    }
    
    override func configureView() {
        configureImageView()
    }
    
    func configureImageView() {
        contentView.addSubview(photoImageView)
        
        photoImageView.isHidden = true
        
        photoImageView.snp.makeConstraints { make in
            make.centerY.equalTo(contentView.snp.centerY)
            make.trailing.equalTo(contentView.snp.trailing).offset(-15)
            make.size.equalTo(25)
        }
    }
}
