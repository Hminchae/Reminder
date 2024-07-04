//
//  Enums.swift
//  Reminder
//
//  Created by 황민채 on 7/3/24.
//

import UIKit

enum View {
    enum NewREList: String, CaseIterable {
        case dueDate = "마감일"
        case tag = "태그"
        case priority = "우선순위"
        case addImage = "이미지 추가"
    }
    
    enum MainCategory: String, CaseIterable {
        case today = "오늘"
        case expacted = "예정"
        case all = "전체"
        case flag = "깃발 표시"
        case completed = "완료됨"
        
        var icon: String {
            switch self {
            case .today:
                return "megaphone.fill"
            case .completed:
                return "checkmark"
            case .expacted:
                return "calendar"
            case .all:
                return "tray.fill"
            case .flag:
                return "flag.fill"
            }
        }
        
        var iconColor: UIColor {
            switch self {
            case .today:
                return UIColor.systemBlue
            case .completed:
                return UIColor.systemGray2
            case .expacted:
                return UIColor.systemRed
            case .all:
                return UIColor.systemGray4
            case .flag:
                return UIColor.systemOrange
            }
        }
    }
    
    enum Radio {
        case selected(color: UIColor)
        case unselected
        
        var backgroundColor: UIColor {
            switch self {
            case .selected(let color):
                return color
            case .unselected:
                return .lightGray
            }
        }
    }
    enum CustomCategory: String, CaseIterable { // 이거 나중엔 추가되도록 해야하는데..
        case reminder = "미리 알림"
        case toDo = "할일"
    }
}

enum Sort {
    enum TypeOf {
        case dueDate(asc: Bool)
        case registerDate(asc: Bool)
        case priority(asc: Bool)
        case title(asc: Bool)
        
        var name: String {
            switch self {
            case .dueDate:
                return "마감일"
            case .registerDate:
                return "생성일"
            case .priority:
                return "우선 순위"
            case .title:
                return "제목"
            }
        }
        
        var way: String {
            switch self {
                
            case .dueDate(let asc):
                switch asc {
                case true:
                    return "늦은 항목 순으로"
                case false:
                    return "이른 항목 순으로"
                }
                
            case .registerDate(let asc):
                switch asc {
                case true:
                    return "최신 항목 순으로"
                case false:
                    return "오래된 항목 순으로"
                }
                
            case .priority(let asc):
                switch asc {
                case true:
                    return "낮은 우선 순위로"
                case false:
                    return "높은 우선 순위로"
                }
                
            case .title(let asc):
                switch asc {
                case true:
                    return "늦은 항목 순으로"
                case false:
                    return "이른 항목 순으로"
                }
            }
        }
    }
}

