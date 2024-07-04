//
//  TodoTableRepository.swift
//  Reminder
//
//  Created by 황민채 on 7/4/24.
//

import Foundation

import RealmSwift

final class TodoTableRepository {
    
    private let realm = try! Realm()
    
    // 데이터 패치
    func fetchAll(type: Sort.TypeOf, asc: Bool) -> [TodoTable] {
        let value = realm.objects(TodoTable.self).sorted(byKeyPath: type.name,
                                                         ascending: asc)
        return Array(value)
    }
    
    // 데이터 생성
    func createItem(_ data: TodoTable) {
        do {
            try realm.write {
                realm.add(data)
                print("Realm Create Succeed")
            }
        } catch {
            print("Realm Error")
        }
    }
    
    // 데이터 삭제
    func deleteItem(_ data: TodoTable) {
        do {
            try realm.write {
                realm.delete(data)
            }
        } catch {
            print("Realm Error")
        }
    }
    
    // 데이터 수정
    func updateItem(_ data: TodoTable,
                    target: String,
                    value: Any
    ) {
        do {
            try realm.write {
                realm.create(TodoTable.self,
                             value: ["id": data.id,
                                     "money": 1000000000000000000],
                             update:  .modified)
            }
        } catch {
            print("Realm Error")
        }
    }
}
