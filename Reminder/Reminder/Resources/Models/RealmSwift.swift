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
    @Persisted var resisterDate: Date
    @Persisted var dueDate: Date
    @Persisted var isflag: Bool
    
    convenience init(momoTitle: String, 
                     memoContent: String?,
                     category: String,
                     resisterDate: Date,
                     dueDate: Date
    ) {
        self.init()
        self.momoTitle = momoTitle
        self.momoContent = momoContent
        self.category = category
        self.resisterDate = resisterDate
        self.dueDate = dueDate
        self.isflag = false
    }
}
