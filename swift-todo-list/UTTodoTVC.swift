//
//  UTTodoTVC.swift
//  swift-todo-list
//
//  Created by Ashish Kapoor on 29/08/17.
//  Copyright © 2017 Ashish Kapoor. All rights reserved.
//

import UIKit

class UTTodoTVC: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if navigationController?.tabBarController?.selectedIndex == 0 {
            self.navigationItem.title = kPending
        } else {
            self.navigationItem.title = kDone
        }
        self.tableView.tableFooterView = UIView()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if navigationController?.tabBarController?.selectedIndex == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "pendingReuseIdentifier", for: indexPath)
            cell.textLabel?.text = "Something Pending"
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "doneReuseIdentifier", for: indexPath)
            cell.textLabel?.text = "Something Done"
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
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if navigationController?.tabBarController?.selectedIndex == 0 {
            print("should change state of the task to \"done\"")
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let destination: UTDetailVC = storyboard.instantiateViewController(withIdentifier: "UTDetailVC") as! UTDetailVC
            destination.title = String(indexPath.row)
            self.navigationController?.pushViewController(destination, animated: true)
        }
    }

    @IBAction func addTaskButtonPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let destination: UTDetailVC = storyboard.instantiateViewController(withIdentifier: "UTDetailVC") as! UTDetailVC
        destination.title = "Add Todo"
        self.navigationController?.pushViewController(destination, animated: true)
    }

}
