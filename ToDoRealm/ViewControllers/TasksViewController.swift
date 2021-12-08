//
//  TasksViewController.swift
//  ToDoRealm
//
//  Created by Игорь Сысоев on 01.12.2021.
//

import RealmSwift
import Foundation


class TasksViewController: UITableViewController {
    var tasksList: TaskList!
    
    private var currentTask: Results<Task>!
    private var complectedTask: Results<Task>!

    override func viewDidLoad() {
        super.viewDidLoad()
        currentTask = tasksList.tasks.filter("isComplected = false")
        complectedTask = tasksList.tasks.filter("isComplected = true")
        
        title = tasksList.name
        
        let addButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                            target: self,
                                            action: #selector(addButtonPresset))
        navigationItem.rightBarButtonItem = addButtonItem

    }
    @objc private func addButtonPresset() {
        showAlert()
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 0 ? currentTask.count : complectedTask.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        section == 0 ? "CURRENT TASKS" : "COMPLETED TASKS"
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        let task = indexPath.section == 0 ? currentTask[indexPath.row] : complectedTask[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = task.name
        content.secondaryText = task.note
        cell.contentConfiguration = content
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let task = indexPath.section == 0 ? self.currentTask[indexPath.row] : self.complectedTask[indexPath.row]
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
            StorageManager.shared.delete(task)
            self.tableView.reloadData()
        }
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") { _, _, isDone in
            self.showAlert(task: task) {
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
            isDone(true)
        }
        
        let doneTitel = indexPath.section == 0 ? "Done" : "Undone"
        
        let doneAction = UIContextualAction(style: .normal, title: doneTitel) { _, _, isDone in
            StorageManager.shared.done(task)
            let indexPathCurrentTask = IndexPath(row: self.currentTask.count - 1, section: 0)
            let indexPathComplectedTask = IndexPath(row: self.complectedTask.count - 1, section: 1)
            let indexPathDestanation = indexPath.section == 0 ? indexPathComplectedTask : indexPathCurrentTask
            self.tableView.moveRow(at: indexPath, to: indexPathDestanation)
            
            isDone(true)
        }
        
        editAction.backgroundColor = .orange
        doneAction.backgroundColor = .green
        
        return UISwipeActionsConfiguration(actions: [doneAction, editAction, deleteAction])
    }

//MARK: - Alert
    
    private func showAlert(task: Task? = nil, complection: (() -> Void)? = nil) {
        let titel = task == nil ? "New task" : "Edit task"
        
        let alert = UIAlertController.createAlert(titel, andMessage: "Please set title and note for new task")
        
        alert.createActionAlert(task: task) { newTask, note in
            if let task = task, let complection = complection {
                StorageManager.shared.edit(task, newName: newTask, newNote: note)
                complection()
            } else {
                self.save(name: newTask, note: note)
            }
        }
        present(alert, animated: true)
    }
    
    private func save(name: String, note: String) {
        let task = Task(value: [name, note])
        StorageManager.shared.save(task, and: self.tasksList)
        let rowIndex = IndexPath(row: self.currentTask.index(of: task) ?? 0, section: 0)
        tableView.insertRows(at: [rowIndex], with: .automatic)
    }
}
