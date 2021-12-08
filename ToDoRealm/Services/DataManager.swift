//
//  DataManager.swift
//  ToDoRealm
//
//  Created by Игорь Сысоев on 01.12.2021.
//

import RealmSwift

class DataManager {
    static let shared = DataManager()
    
    private init() {}
    
    func createTempData(_ complection: @escaping() -> Void) {
        if !UserDefaults.standard.bool(forKey: "done") {

            let shoppingList = TaskList()
            shoppingList.name = "Shopping List"
            
            let appels = Task(value: ["Appels", "2Kg"])
            let orages = Task(value: ["Oranges", "4Kg"])
            let beer = Task(value: ["name": "Beer", "note": "milk stout!", "isComplected": true])
            
            shoppingList.tasks.insert(contentsOf: [appels, orages, beer], at: 0)
            
            let filmsList = TaskList()
            filmsList.name = "Film List"
            
            let comicsFilm = Task(value: ["Spider-Man", "Sam Raimy"])
            let series = Task(value: ["name": "Silicon Vally","note": "F#ck Gavin Balson!", "isComplected": true])
            let comedy = Task(value: ["Hanover", "2007"])
            filmsList.tasks.insert(contentsOf: [comicsFilm, series, comedy], at: 0)
            
            DispatchQueue.main.async {
                StorageManager.shared.save([shoppingList, filmsList])
                UserDefaults.standard.set(true, forKey: "done")
                complection()
            }
            
            
        }
    }
    
    
    
}
