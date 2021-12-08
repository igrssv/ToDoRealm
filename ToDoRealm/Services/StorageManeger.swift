//
//  StorageManeger.swift
//  ToDoRealm
//
//  Created by Игорь Сысоев on 01.12.2021.
//

import RealmSwift

class StorageManager {
    static let shared = StorageManager()
    let realm = try! Realm()
    
    init() {}
    
    func save(_ tasklists: [TaskList]) {
        write {
            realm.add(tasklists)
        }
        
    }
//MARK: - TaskLists
    
    func save(_ tasklist: TaskList) {
        write {
            realm.add(tasklist)
        }
    }
    
    func delete(_ taskList: TaskList) {
        write {
            realm.delete(taskList)
        }
    }
    
    func edit(_ tasklist: TaskList, newValue: String) {
        write {
            tasklist.name = newValue
        }
    }
    
    func done(_ taskList: TaskList) {
        write {
            taskList.tasks.setValue(true, forKey: "isComplected")
        }
    }
    
    
//MARK: - Task
    
    func save(_ task: Task, and tasklist: TaskList) {
        write {
            tasklist.tasks.append(task)
        }
    }
    
    func delete(_ task: Task) {
        write {
            realm.delete(task)
        }
    }
    
    func edit(_ task: Task, newName: String, newNote: String) {
        write {
            task.name = newName
            task.note = newNote
            
        }
    }
    
    func done(_ task: Task) {
        write {
            task.isComplected.toggle()
        }
    }
    
    private func write(compliction: () -> ()) {
        do {
            try realm.write({compliction()})
        } catch let error{
            print(error)
        }
    }
}
