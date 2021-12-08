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
        
        let addBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                               target: self,
                                               action: #selector(addButtonPressed))
        
        navigationItem.rightBarButtonItem = addBarButtonItem
        navigationItem.leftBarButtonItem = editButtonItem
        
        createTempData()
        
        tasksLists = StorageManager.shared.realm.objects(TaskList.self)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    

    @objc func addButtonPressed() {
        showAlert()
    }
    
    private func createTempData() {
        DataManager.shared.createTempData {
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tasksLists.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskListCell", for: indexPath)
        
        let taskList = tasksLists[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = taskList.name
        content.secondaryText = "\(taskList.tasks.filter("isComplected = false").count)"
        print("\(taskList.tasks)")
        cell.contentConfiguration = content
    

        return cell
   
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let taskList = tasksLists[indexPath.row]
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
            StorageManager.shared.delete(taskList)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") { _, _, isDone in
            self.showAlert(taskList) {
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
            isDone(true)
        }
        
        let doneAction = UIContextualAction(style: .normal, title: "Done") { _, _, isDone in
            StorageManager.shared.done(taskList)
            

            
            tableView.reloadRows(at: [indexPath], with: .automatic)
            isDone(true)
        }
        editAction.backgroundColor = .orange
        return UISwipeActionsConfiguration(actions: [doneAction, editAction, deleteAction])
    }
    
//MARK: - Segue

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        
        guard let tasksVC = segue.destination as? TasksViewController else { return }
        let tasklist = tasksLists[indexPath.row]
        
        tasksVC.tasksList = tasklist
    }


    
//MARK: - Alert
    private func showAlert(_ taskList: TaskList? = nil, completion: (() -> Void)? = nil) {
        let titel = taskList != nil ? "Edit List" : "New List"
        
        let alert = UIAlertController.createAlert(titel, andMessage: "Please set title for new task list")
        
        alert.createActionAlert(taskList: taskList) { newValue in
            if let taskList = taskList, let completion = completion {
                StorageManager.shared.edit(taskList, newValue: newValue)
                completion()
            } else {
                self.save(taskList: newValue)
            }
        }
        
        present(alert, animated: true)
    }
    
    private func save(taskList: String) {
        let tasklist = TaskList(value: [taskList])
        StorageManager.shared.save(tasklist)
        let indexPath = IndexPath(row: tasksLists.index(of: tasklist ) ?? 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        
    }
}




