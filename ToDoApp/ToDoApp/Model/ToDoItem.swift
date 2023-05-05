//
//  ToDoItem.swift
//  ToDoApp
//
//  Created by Artyom Butorin on 12.04.23.
//

import Foundation

class ToDoItem: Codable {
    let title: String
    let dueDate: Date

    init(title: String, dueDate: Date) {
        self.title = title
        self.dueDate = dueDate
    }

    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, h:mm a"
        return formatter.string(from: dueDate)
    }
}
