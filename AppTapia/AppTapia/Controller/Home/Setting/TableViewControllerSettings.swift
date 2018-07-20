//
//  TableViewControllerSettings.swift
//  AppTapia
//
//  Created by Andy on 01/09/17.
//

import UIKit
import os.log
import RealmSwift

class TableViewControllerSettings: MJITableViewController {
    
    let settingEntries = LibraryAPI.shared.getSettingsList()
    
    /// viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("TableViewControllerSettings!")
        
        // hide nav bars
        hideNav(leftItem: true, rightItem: false)
    }
    
    //MARK: - TableViewController Delegates and datasources
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingEntries.count
    }
    
    /// tableView
    ///
    /// - Parameters:
    ///   - tableView: <#tableView description#>
    ///   - indexPath: indexPath description
    /// - Returns: <#return value description#>
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "TableViewEntry"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? TableViewEntry  else {
            fatalError("The dequeued cell is not an instance of TableViewEntry.")
        }
        
        // Fetches the appropriate tapia for the data source layout.
        let entry = settingEntries[indexPath.row]
        cell.nameLabel.text = entry.title
        cell.photoImageView.image = UIImage(named: entry.imageName)
        
        return cell
    }

    /// tableView
    ///
    /// - Parameters:
    ///   - tableView: <#tableView description#>
    ///   - indexPath: <#indexPath description#>
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let segueIdentifier = settingEntries[indexPath.row].segueIdentifier
        
        switch segueIdentifier {
            case "exit":
                print("exit")
                exit(0)
                break
            case "contact_us":
                print("contact_us")
                UIApplication.shared.openURL(NSURL(string: "http://mjirobotics.co.jp/tapia_manual/%E3%81%8A%E5%95%8F%E5%90%88%E3%81%9B")! as URL)
                break
            default:
                self.performSegue(withIdentifier: segueIdentifier, sender: nil)
        }
    }

    /// Override to support conditional editing of the table view.
    ///
    /// - Parameters:
    ///   - tableView: <#tableView description#>
    ///   - indexPath: <#indexPath description#>
    /// - Returns: <#return value description#>
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }

    //MARK: - Navigation
    
    /// In a storyboard-based application, you will often want to do a little preparation before navigation
    ///
    /// - Parameters:
    ///   - segue: <#segue description#>
    ///   - sender: <#sender description#>
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ShowRegisterTableViewController") {
            if let registerVC = segue.destination as? RegisterTableViewController {
                registerVC.displayMode = DisplayMode.DISPLAY_MODE_EDIT_PROFILE
            }
        }
    }

    //MARK: Actions
    
    /// doneButtonClicked
    ///
    /// - Parameter sender: <#sender description#>
    @IBAction func doneButtonClicked(sender: UIStoryboardSegue) {
        
        dismiss(animated: true, completion: nil)
    }

}
