//
//  LinkAddViewController.swift
//  AppTapia
//
//  Created by Andy on 01/11/17.
//


import UIKit

class LinkAddViewController: UIViewController {

    /// viewDidLoad
    override func viewDidLoad() {
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    /// didReceiveMemoryWarning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// doneButtonClicked
    ///
    /// - Parameter sender: <#sender description#>
    @IBAction func doneButtonClicked(_ sender: Any) {
        print("doneButtonClicked")
        self.dismiss(animated: true, completion: nil)
        
    }
}
