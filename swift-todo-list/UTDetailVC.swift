//
//  UTDetailVC.swift
//  swift-todo-list
//
//  Created by Ashish Kapoor on 29/08/17.
//  Copyright © 2017 Ashish Kapoor. All rights reserved.
//

import UIKit

class UTDetailVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var todoTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        todoTF.delegate = self
        todoTF.becomeFirstResponder()
        if self.tabBarController?.selectedIndex == 0 {
            setupDoneButton()
        }
    }
 
    func setupDoneButton() {
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(UTDetailVC.donePressed))
        self.navigationItem.rightBarButtonItem = doneButton
    }
    
    func donePressed() {
        addTaskForTodo()
    }
    
    // MARK: - Text field delegates
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        textField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        addTaskForTodo()
        return true
    }
    
    func addTaskForTodo() {
        if (todoTF.text?.isEmpty)! {
            let alertController = UIAlertController(title: "Warning", message:
                "Don't forget to enter something.", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        } else {
            let context = UTDatabaseController.getContext()
            let task = Task(context: context)
            task.todo = todoTF.text!
            task.isPending = true
            UTDatabaseController.saveContext()
            navigationController?.popViewController(animated: true)
        }
    }

}
