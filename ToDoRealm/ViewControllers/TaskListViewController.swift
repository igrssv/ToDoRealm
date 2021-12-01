//
//  TaskListViewController.swift
//  ToDoRealm
//
//  Created by Игорь Сысоев on 01.12.2021.
//

import UIKit
import RealmSwift

class TaskListViewController: UITableViewController {
    private var tasksLists: Results<TaskList>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Task List"
        createTempData()
        
        tasksLists = StorageManager.shared.realm.objects(TaskList.self)
    }
    
    private func createTempData() {
        DataManager.shared.createTempData {
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        tasksLists.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskListCell", for: indexPath)
        
        let taskList = tasksLists[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = taskList.name
        content.secondaryText = "\(taskList.tasks.count)"
        cell.contentConfiguration = content

        return cell
    }


}
