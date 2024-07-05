//
//  NewReminderDetailTableViewCell.swift
//  Reminder
//
//  Created by 황민채 on 7/3/24.
//

import UIKit

// 컴포넌트 셀 : [ title        result ]
final class TitleTableViewCell: BaseTableViewCell {
    
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
    
    override func configureHierarchy() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(resultLabel)
    }
    
    override func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(contentView.snp.leading).offset(10)
            make.verticalEdges.equalTo(contentView.snp.verticalEdges).inset(5)
        }
        
        resultLabel.snp.makeConstraints { make in
            make.trailing.equalTo(contentView.snp.trailing).inset(10)
            make.verticalEdges.equalTo(contentView.snp.verticalEdges).inset(5)
        }
    }
}
