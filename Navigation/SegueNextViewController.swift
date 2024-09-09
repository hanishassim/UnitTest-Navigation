//
//  SegueNextViewController.swift
//  Navigation
//
//  Created by Hassim, Muhammad Hanis on 09/09/2024.
//

import UIKit

class SegueNextViewController: UIViewController {
    
    var labelText: String?
    
    @IBOutlet private(set) var label: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        label.text = labelText
    }

}
