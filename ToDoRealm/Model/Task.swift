//
//  Model.swift
//  ToDoRealm
//
//  Created by Игорь Сысоев on 01.12.2021.
//

import RealmSwift


class TaskList: Object {
    @objc dynamic var name = ""
    @objc dynamic var date = Date()
    let tasks = List<Task>()
    
}

class Task: Object {
    @objc dynamic var name = ""
    @objc dynamic var note = ""
    @objc dynamic var date = Date()
    @objc dynamic var isComplected = false
}
