//
//  RealmSwift.swift
//  Reminder
//
//  Created by 황민채 on 7/3/24.
//

import Foundation

import RealmSwift

class TodoTable: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted(indexed: true) var momoTitle: String
    @Persisted var momoContent: String?
    @Persisted var category: String
    @Persisted var registerDate: Date
    @Persisted var dueDate: Date
    @Persisted var isflag: Bool
    @Persisted var isCompleted: Bool
    @Persisted var priority: Int // 상: 3, 중: 2, 하: 1
    
    convenience init(momoTitle: String,
                     memoContent: String?,
                     category: String,
                     registerDate: Date,
                     dueDate: Date,
                     priority: Int
    ) {
        self.init()
        self.momoTitle = momoTitle
        self.momoContent = momoContent
        self.category = category
        self.registerDate = registerDate
        self.dueDate = dueDate
        self.isflag = false
        self.isCompleted = false
        self.priority = priority
    }
}
