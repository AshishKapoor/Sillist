//
//  UTDetailVC.swift
//  swift-todo-list
//
//  Created by Ashish Kapoor on 29/08/17.
//  Copyright © 2017 Ashish Kapoor. All rights reserved.
//

import UIKit

class UTDetailVC: UIViewController {

    @IBOutlet weak var todoTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func viewWillDisappear(_ animated: Bool) {
        print(todoTF.text ?? "nothing")
    }
    
}
