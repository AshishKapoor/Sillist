//
//  UTTodoTVC.swift
//  swift-todo-list
//
//  Created by Ashish Kapoor on 29/08/17.
//  Copyright © 2017 Ashish Kapoor. All rights reserved.
//

import UIKit

class UTTodoTVC: UITableViewController {
    
    var tasks: [Task] = []
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
        tableView.reloadData()
    }
    
    func loadData() {
        do {
            tasks = try context.fetch(Task.fetchRequest())
        } catch {
            fatalError("Some error at loading data")
        }
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if navigationController?.tabBarController?.selectedIndex == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "pendingReuseIdentifier", for: indexPath)
            let todo = tasks[indexPath.row].todo
            cell.textLabel?.text = "\(String(indexPath.row + 1)). \(String(describing: todo!))"
            
            return cell
        } else if navigationController?.tabBarController?.selectedIndex == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "doneReuseIdentifier", for: indexPath)
            guard let todo = tasks[indexPath.row].todo else {return UITableViewCell()}
            cell.textLabel?.text = todo
            
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let task = tasks[indexPath.row]
            context.delete(task)
            UTDatabaseController.saveContext()
            loadData()
            tableView.deleteRows(at: [indexPath], with: .fade) // Some Animation :D
        }
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if navigationController?.tabBarController?.selectedIndex == 0 {
            print("should change state of the task to \"done\"")
        } else {
            // Do nothing.
        }
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
    }

    @IBAction func addTaskButtonPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let destination: UTDetailVC = storyboard.instantiateViewController(withIdentifier: "UTDetailVC") as! UTDetailVC
        destination.title = "Add Todo"
        self.navigationController?.pushViewController(destination, animated: true)
    }

}



