//
//  MonitorViewController.swift
//  AppTapia
//
//  Created by Andy on 01/09/17.
//

import UIKit
import os.log

class MonitorViewController: UIViewController {
    
    //MARK: Properties
    //@IBOutlet weak var nameTextField: UITextField!
    //@IBOutlet weak var photoImageView: UIImageView!
    //@IBOutlet weak var saveButton: UIBarButtonItem!
    
    // This value is either passed by `TapiaTableViewController` in `prepare(for:sender:)`
    // or constructed as part of adding a new tapia.
 
    var entry: Contact?
    
    /// <#Description#>
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        print("MonitorViewController")
        
        // Set up views if editing an existing Entry.
        //if let entry = entry {
            //navigationItem.title = entry.name
            //nameTextField.text = entry.name
            //photoImageView.image = entry.photo
        //}
        
        // update stuff
        updateState()
    }
    
    //MARK: Private Methods
    /// updateState
    private func updateState() {

    }
  
    //MARK: Navigation
    /// done
    ///
    /// - Parameter sender: <#sender description#>
    @IBAction func done(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}

