//
//  ToDoListController.swift
//  ToDoApp
//
//  Created by Artyom Butorin on 12.04.23.
//

import UIKit
import SnapKit

class ToDoListController: UIViewController {
    
    // MARK: - Properties
    
    private let tableView = UITableView()
    private var tasks = [String]()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Список задач"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
        setupTableView()
        loadTasks()
    }
    
    // MARK: - Selectors
    
    @objc private func didTapAdd() {
        let addTaskController = AddTaskController()
        addTaskController.delegate = self
        addTaskController.onSave = { [weak self] task in
            self?.tasks.append(task)
            self?.saveTasks()
            self?.tableView.reloadData()
        }
        navigationController?.pushViewController(addTaskController, animated: true)
    }
    
    // MARK: - Helpers
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ToDoItemCell.self, forCellReuseIdentifier: "ToDoItemCell")
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func loadTasks() {
        if let savedTasks = UserDefaults.standard.stringArray(forKey: "tasks") {
            tasks = savedTasks
        } else {
            tasks = [] // добавить эту строку
        }
    }
    
    private func saveTasks() {
        UserDefaults.standard.set(tasks, forKey: "tasks")
    }
    
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension ToDoListController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath) as! ToDoItemCell
        cell.taskLabel.text = tasks[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let addTaskController = AddTaskController()
        addTaskController.delegate = self
        addTaskController.task = tasks[indexPath.row]
        addTaskController.onSave = { [weak self] task in
            self?.tasks[indexPath.row] = task
            self?.saveTasks()
            self?.tableView.reloadData()
        }
        navigationController?.pushViewController(addTaskController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tasks.remove(at: indexPath.row)
            saveTasks()
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

    
}

// MARK: - AddTaskDelegate

extension ToDoListController: AddTaskDelegate {
    
    func didAddTask(_ task: String) {
        // Проверяем, нет ли уже такой задачи в массиве
        if !tasks.contains(task) {
            tasks.append(task)
            saveTasks()
            tableView.reloadData()
        }
    }
    
    func didUpdateTask(_ task: String, at indexPath: IndexPath) {
        tasks[indexPath.row] = task
        saveTasks()
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
