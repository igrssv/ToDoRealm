//
//  Extension + UIAlertController.swift
//  ToDoRealm
//
//  Created by Игорь Сысоев on 08.12.2021.
//

import UIKit


extension UIAlertController {
    
    static func createAlert(_ titel: String, andMessage message: String) -> UIAlertController {
        UIAlertController(title: titel, message: message , preferredStyle: .alert)
    }
    
    func createActionAlert(taskList: TaskList?, complection: @escaping (String) -> Void) {
        let titel = taskList == nil ? "Save" : "Update"
        
        let saveAction = UIAlertAction(title: titel, style: .default) { _ in
            guard let newValue = self.textFields?.first?.text else { return }
            guard !newValue.isEmpty else { return }
            complection(newValue)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .destructive)
        addAction(saveAction)
        addAction(cancel)
        addTextField { textFields in
            textFields.placeholder = "Add name"
            textFields.text = taskList?.name
        }
        
    }
    
    func createActionAlert(task: Task?, complection: @escaping (String, String) -> Void) {
        let titel = task == nil ? "Save" : "Update"
        
        let saveAction = UIAlertAction(title: titel, style: .default) { _Arg in
            guard let newTask = self.textFields?.first?.text else { return }
            guard !newTask.isEmpty else { return }
            
            if let note = self.textFields?.last?.text, !note.isEmpty {
                complection(newTask, note)
            } else {
                complection(newTask, "")
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        addAction(saveAction)
        addAction(cancelAction)
        
        addTextField { textFields in
            textFields.placeholder = "New task"
            textFields.text = task?.name
        }
        addTextField { textFields in
            textFields.placeholder = "Add note"
            textFields.text = task?.note
        }
        
        
    }
}
