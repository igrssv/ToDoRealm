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
    
    func save(_ tasklist: [TaskList]) {
        write {
            realm.add(tasklist)
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
