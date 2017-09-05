//
//  UTTodoTVC.swift
//  swift-todo-list
//
//  Created by Ashish Kapoor on 29/08/17.
//  Copyright © 2017 Ashish Kapoor. All rights reserved.
//

import UIKit
import CoreData

class UTTodoTVC: UITableViewController {
    
    var pendingTasks: [Task] = []
    var doneTasks: [Task] = []
    
    let context = UTDatabaseController.getContext()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if navigationController?.tabBarController?.selectedIndex == 0 {
            self.navigationItem.title = kPending
        } else {
            self.navigationItem.title = kDone
        }
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = kTableRowHeight
        self.tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        tableView.reloadData()
    }
    
    func loadData() {
        do {
            let formatPendingRequest : NSFetchRequest<Task> = Task.fetchRequest()
            let predicatePending = NSPredicate(format: kPredicate, NSNumber(value: true))
            formatPendingRequest.predicate = predicatePending
            let fetchedPendingResults = try context.fetch(formatPendingRequest)
            pendingTasks = fetchedPendingResults
            
            let formatDoneRequest : NSFetchRequest<Task> = Task.fetchRequest()
            let predicateDone = NSPredicate(format: kPredicate, NSNumber(value: false))
            formatDoneRequest.predicate = predicateDone
            let fetchedDoneResults = try context.fetch(formatDoneRequest)
            doneTasks = fetchedDoneResults
        } catch {
            fatalError(kError)
        }
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if navigationController?.tabBarController?.selectedIndex == 0 {
            return pendingTasks.count
        } else {
            return doneTasks.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if navigationController?.tabBarController?.selectedIndex == 0 {
            let cellForPending = tableView.dequeueReusableCell(withIdentifier: kPendingReusableCell, for: indexPath)
            guard let todo = pendingTasks[indexPath.row].todo else { return UITableViewCell() }
            cellForPending.textLabel?.text = todo
            cellForPending.textLabel?.numberOfLines = 0
            return cellForPending
        } else {
            let cellForDone = tableView.dequeueReusableCell(withIdentifier: kDoneReusableCell, for: indexPath)
            guard let todo = doneTasks[indexPath.row].todo else { return UITableViewCell() }
            cellForDone.textLabel?.text = todo
            cellForDone.textLabel?.numberOfLines = 0
            return cellForDone
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let task: Task!
            if navigationController?.tabBarController?.selectedIndex == 0 {
                task = pendingTasks[indexPath.row]
            } else {
                task = doneTasks[indexPath.row]
            }
            context.delete(task)
            UTDatabaseController.saveContext()
            loadData()
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            if cell.isSelected {
                if self.navigationController?.tabBarController?.selectedIndex == 0 {
                    let task = self.pendingTasks[indexPath.row]
                    task.isPending = false // setState = "done"
                } else {
                    let task = self.doneTasks[indexPath.row]
                    task.isPending = true // setState = "pending"
                }
                self.save()
            }
        }
    }
    
    private func save() {
        UTDatabaseController.saveContext()
        self.loadData()
        tableView.reloadData()
        self.alertSuccess()
    }
    
    func alertSuccess() {
        var alert = UIAlertController()
        if self.navigationController?.tabBarController?.selectedIndex == 0 {
            alert = UIAlertController(title: kAlertSuccess, message: kAlertComplete, preferredStyle: .alert)
        } else {
            alert = UIAlertController(title: kAlertSuccess, message: kAlertPending, preferredStyle: .alert)
        }
        self.present(alert, animated: true, completion: nil)
        let when = DispatchTime.now() + 0.5
        DispatchQueue.main.asyncAfter(deadline: when){
            alert.dismiss(animated: true, completion: nil)
        }
    }

    @IBAction func addTaskButtonPressed(_ sender: Any) {
        guard let destination: UTDetailVC = kMainStoryboard.instantiateViewController(withIdentifier: "UTDetailVC") as? UTDetailVC else { return }
        destination.title = kAddTodo
        self.navigationController?.pushViewController(destination, animated: true)
    }
}
