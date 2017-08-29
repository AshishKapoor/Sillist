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
            // TODO: - Refactor this later...
            let formatRequest : NSFetchRequest<Task> = Task.fetchRequest()
            let predicate = NSPredicate(format: "isPending == %@", NSNumber(value: true))
            formatRequest.predicate = predicate
            let fetchedResults = try context.fetch(formatRequest)
            pendingTasks = fetchedResults
            
            let formatDoneRequest : NSFetchRequest<Task> = Task.fetchRequest()
            let predicateDone = NSPredicate(format: "isPending == %@", NSNumber(value: false))
            formatDoneRequest.predicate = predicateDone
            let fetchedDoneResults = try context.fetch(formatDoneRequest)
            doneTasks = fetchedDoneResults
        } catch {
            fatalError("Oops! Error at loading data...")
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "pendingReuseIdentifier", for: indexPath)
            guard let todo = pendingTasks[indexPath.row].todo else { return UITableViewCell() }
            cell.textLabel?.text = todo
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "doneReuseIdentifier", for: indexPath)
            guard let todo = doneTasks[indexPath.row].todo else {return UITableViewCell()}
            cell.textLabel?.text = todo
            return cell
        }
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
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
                    }
                }
            }
        }
    }

    @IBAction func addTaskButtonPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let destination: UTDetailVC = storyboard.instantiateViewController(withIdentifier: "UTDetailVC") as! UTDetailVC
        destination.title = "Add Todo"
        self.navigationController?.pushViewController(destination, animated: true)
    }
}
