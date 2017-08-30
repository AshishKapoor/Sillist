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
        self.tableView.estimatedRowHeight = 50
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
            let cellIdentifier = "pendingReuseIdentifier"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
            guard let todo = pendingTasks[indexPath.row].todo else { return UITableViewCell() }
            cell.textLabel?.text = todo
            cell.textLabel?.numberOfLines = 0
            return cell
        } else {
            let cellIdentifier = "doneReuseIdentifier"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
            guard let todo = doneTasks[indexPath.row].todo else { return UITableViewCell() }
            cell.textLabel?.text = todo
            cell.textLabel?.numberOfLines = 0
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if navigationController?.tabBarController?.selectedIndex == 0 {
            if editingStyle == .delete {
                let task = pendingTasks[indexPath.row]
                context.delete(task)
                UTDatabaseController.saveContext()
                loadData()
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            tableView.reloadData()
        } else {
            if editingStyle == .delete {
                let task = doneTasks[indexPath.row]
                context.delete(task)
                UTDatabaseController.saveContext()
                loadData()
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if navigationController?.tabBarController?.selectedIndex == 0 {
            if let cell = tableView.cellForRow(at: indexPath) {
                if cell.isSelected {
                    DispatchQueue.main.async {
                        let task = self.pendingTasks[indexPath.row]
                        task.isPending = false // setState = "done"
                        UTDatabaseController.saveContext()
                        self.loadData()
                        tableView.reloadData()
                        
                        let alert = UIAlertController(title: "", message: kAlertComplete, preferredStyle: .alert)
                        self.present(alert, animated: true, completion: nil)
                        
                        let when = DispatchTime.now() + 0.5
                        DispatchQueue.main.asyncAfter(deadline: when){
                            alert.dismiss(animated: true, completion: nil)
                        }
                    }
                }
            }
        } else {
            if let cell = tableView.cellForRow(at: indexPath) {
                if cell.isSelected {
                    DispatchQueue.main.async {
                        let task = self.doneTasks[indexPath.row]
                        task.isPending = true // setState = "pending"
                        UTDatabaseController.saveContext()
                        self.loadData()
                        tableView.reloadData()
                        
                        let alert = UIAlertController(title: "", message: kAlertPending, preferredStyle: .alert)
                        self.present(alert, animated: true, completion: nil)
                        
                        let when = DispatchTime.now() + 0.5
                        DispatchQueue.main.asyncAfter(deadline: when) {
                            alert.dismiss(animated: true, completion: nil)
                        }
                    }
                }
            }
        }
    }

    @IBAction func addTaskButtonPressed(_ sender: Any) {
        guard let destination: UTDetailVC = kMainStoryboard.instantiateViewController(withIdentifier: "UTDetailVC") as? UTDetailVC else { return }
        destination.title = "Add Todo"
        self.navigationController?.pushViewController(destination, animated: true)
    }
}
