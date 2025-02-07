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
    
    // 데이터 패치 - 카테고리 지정 값 없으면 전체
    func fetchAll(_ category: View.MainCategory,
                  sortType: Sort.TypeOf
    ) -> [TodoTable] {
        let now = Date()
        let twentyFourHoursLater = Calendar.current.date(byAdding: .hour, value: 24, to: now)!
        
        let results: Results<TodoTable>
        
        switch category {
        case .today:
            results = realm.objects(TodoTable.self).filter("dueDate >= %@ AND dueDate <= %@", now, twentyFourHoursLater)
        case .expacted:
            results = realm.objects(TodoTable.self).filter("dueDate > %@", now)
        case .all:
            results = realm.objects(TodoTable.self)
        case .flag:
            results = realm.objects(TodoTable.self).filter("isflag == true")
        case .completed:
            results = realm.objects(TodoTable.self).filter("isCompleted == true")
        }
        
        let sortedResults = results.sorted(byKeyPath: sortType.dbName,
                                           ascending: sortType.isAsc)
        return Array(sortedResults)
    }
    
    // 데이터 패치 - 카테고리 지정 값 없으면 전체
    func fetchAllCount(_ category: View.MainCategory) -> String {
        let now = Date()
        let twentyFourHoursLater = Calendar.current.date(byAdding: .hour, value: 24, to: now)!
        
        let results: Int
        
        switch category {
        case .today:
            results = realm.objects(TodoTable.self).filter("dueDate >= %@ AND dueDate <= %@", now, twentyFourHoursLater).count
        case .expacted:
            results = realm.objects(TodoTable.self).filter("dueDate > %@", now).count
        case .all:
            results = realm.objects(TodoTable.self).count
        case .flag:
            results = realm.objects(TodoTable.self).filter("isflag == true").count
        case .completed:
            results = realm.objects(TodoTable.self).filter("isCompleted == true").count
        }

        return String(results)
    }
    
    // 특정 날짜까지의 할 일 가져오기
    func fetchTodosDueBy(date: Date) -> [TodoTable] {
        let startDay = Calendar.current.startOfDay(for: date)
        let endDay = Calendar.current.date(byAdding: .day, value: 1, to: startDay)!

        let results = realm.objects(TodoTable.self).filter("dueDate >= %@ AND dueDate < %@", startDay, endDay)
       print(results)
        return Array(results)
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
                                     target: value],
                             update:  .modified)
            }
        } catch {
            print("Realm Error")
        }
    }
    
    // 데이터 위치 출력
    func priteFileLocation() {
        print(realm.configuration.fileURL ?? "파일 위치를 찾을 수 없음")
    }
}
