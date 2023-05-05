//
//  AddTaskController.swift
//  ToDoApp
//
//  Created by Artyom Butorin on 12.04.23.
//

import UIKit
import SnapKit

class AddTaskController: UIViewController {
    
    // MARK: - Properties
    
    var onSave: ((String) -> Void)?
    
    var task: String?
    
    weak var delegate: AddTaskDelegate?
    
    var indexPath: IndexPath?
    
    private let textField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Введите задачу"
        return textField
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Сохранить", for: .normal)
        button.addTarget(self, action: #selector(handleSave), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.text = task
        
        view.backgroundColor = .white
        
        view.addSubview(textField)
        textField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        
        view.addSubview(saveButton)
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
    }
    
    // MARK: - Selectors
    
    // FIXME: - Returning to the main screen
    @objc private func handleSave() {
        guard let task = textField.text, !task.isEmpty else { return }
        onSave?(task)
        if let indexPath = indexPath {
            delegate?.didUpdateTask(task, at: indexPath)
        } else {
            delegate?.didAddTask(task)
        }
        dismiss(animated: true, completion: nil)
    }
    
}

protocol AddTaskDelegate: AnyObject {
    func didAddTask(_ task: String)
    func didUpdateTask(_ task: String, at indexPath: IndexPath)
}
