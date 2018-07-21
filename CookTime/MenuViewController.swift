//
//  MenuViewController.swift
//  CookTime
//
//  Created by Reagan Wood on 7/21/18.
//  Copyright © 2018 RW Software. All rights reserved.
//

import Foundation

class MenuViewController: UIViewController {
    
    @IBOutlet weak var dismissButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.green
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dismissButton.isHidden = false
    }
    override func viewDidLayoutSubviews() {
        
    }
}
