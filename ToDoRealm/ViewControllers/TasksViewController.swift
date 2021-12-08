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
        
        let addButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(createAlert))
        navigationItem.rightBarButtonItem = addButtonItem

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
            self.editAlert(task, and: indexPath)
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
    
    @objc private func createAlert() {
        let alert = UIAlertController(title: "Add task", message: "New task", preferredStyle: .alert)
        alert.addTextField()
        alert.addTextField()
        
        
        let alertAction = UIAlertAction(title: "Save", style: .default) { _ in
            guard let newValue = alert.textFields?.first?.text else { return }
            print(newValue)
            guard let note = alert.textFields?.last?.text else { return }
            
            let task = Task(value: [newValue, note])
            StorageManager.shared.save(task, and: self.tasksList)
            
            let indexPath = IndexPath(row: self.currentTask.index(of: task) ?? 0, section: 0)
            self.tableView.insertRows(at: [indexPath], with: .automatic)
        }
        let cancelAlert = UIAlertAction(title: "Cancel", style: .destructive)
        
        alert.addAction(alertAction)
        alert.addAction(cancelAlert)
        present(alert, animated: true)
    }
    
    
    private func editAlert(_ task: Task, and indexPath: IndexPath) {
        let alert = UIAlertController(title: "Edit", message: "You edit task?", preferredStyle: .alert)
        alert.addTextField { oldName in
            oldName.text = task.name
        }
        alert.addTextField { oldValue in
            oldValue.text = task.note
        }
        let alertAction = UIAlertAction(title: "Save", style: .default) { _ in
            guard let newName = alert.textFields?.first?.text else { return }
            guard let newNote = alert.textFields?.last?.text else { return }
            StorageManager.shared.edit(task, newName: newName, newNote: newNote)
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        alert.addAction(alertAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    

}
