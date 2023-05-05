//
//  UserDefaultsManager.swift
//  ToDoApp
//
//  Created by Artyom Butorin on 12.04.23.
//

import Foundation

class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    
    private let taskKey = "tasks"
    
    func getTasks() -> [String] {
        return UserDefaults.standard.stringArray(forKey: taskKey) ?? []
    }
    
    func saveTasks(_ tasks: [String]) {
        UserDefaults.standard.set(tasks, forKey: taskKey)
    }
    
}
