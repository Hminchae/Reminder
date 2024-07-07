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
    @Persisted(indexed: true) var memoTitle: String
    @Persisted var memoContent: String?
    @Persisted var category: String
    @Persisted var registerDate: Date
    @Persisted var dueDate: Date?
    @Persisted var isflag: Bool
    @Persisted var isCompleted: Bool
    @Persisted var tag: String?
    @Persisted var priority: String? // 상: 3, 중: 2, 하: 1
    
    convenience init(memoTitle: String,
                     memoContent: String?,
                     category: String,
                     registerDate: Date,
                     dueDate: Date?,
                     tag: String?,
                     priority: String?
    ) {
        self.init()
        self.memoTitle = memoTitle
        self.memoContent = memoContent
        self.category = category
        self.registerDate = registerDate
        self.dueDate = dueDate
        self.isflag = false
        self.isCompleted = false
        self.tag = tag
        self.priority = priority
    }
}
