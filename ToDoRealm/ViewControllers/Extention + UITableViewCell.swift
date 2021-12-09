//
//  Extention + UITableViewCell.swift
//  ToDoRealm
//
//  Created by Игорь Сысоев on 09.12.2021.
//

import UIKit

extension UITableViewCell {
    func configurate(_ tasklist: TaskList) {
        let currentTaskList = tasklist.tasks.filter("isComplected = false")
        var content = defaultContentConfiguration()
        
        content.text = tasklist.name
        
        if tasklist.tasks.isEmpty {
            content.secondaryText = "0"
            accessoryType = .none
        } else if currentTaskList.isEmpty {
            content.secondaryText = nil
            accessoryType = .checkmark
        } else {
            content.secondaryText = "\(currentTaskList.count)"
        }
        contentConfiguration = content
    }
}
