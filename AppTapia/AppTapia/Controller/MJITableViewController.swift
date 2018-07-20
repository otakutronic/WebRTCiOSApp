//
//  TableViewController.swift
//  AppTapia
//
//  Created by Andy on 01/09/17.
//

import UIKit
import os.log
import RealmSwift

/// TableViewController
class MJITableViewController: UITableViewController {
    
    //MARK: Properties
    
    let realm = try! Realm()
    var entries: Results<Contact>?
    var notificationToken: NotificationToken? = nil
    var clearData = false
    
    /// didReceiveMemoryWarning
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("TableViewController!")
        
        loadData()
        guard let entries = self.entries else {
            fatalError("Please loadData()")
        }
        
        // Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem
        
        
        // Observe Results Notifications
        notificationToken = entries.observe { [weak self] (changes: RealmCollectionChange) in
            guard let tableView = self?.tableView else { return }
            switch changes {
            case .initial:
                // Results are now populated and can be accessed without blocking the UI
                tableView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                // Query results have changed, so apply them to the UITableView
                tableView.beginUpdates()
                tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }),
                                     with: .automatic)
                tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}),
                                     with: .automatic)
                tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
                                     with: .automatic)
                tableView.endUpdates()
            case .error(let error):
                // An error occurred while opening the Realm file on the background worker thread
                fatalError("\(error)")
            }
        }
    }
    
    /// didReceiveMemoryWarning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Table view data source
    
    /// numberOfSections
    ///
    /// - Parameter tableView: <#tableView description#>
    /// - Returns: <#return value description#>
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    /// tableView
    ///
    /// - Parameters:
    ///   - tableView: <#tableView description#>
    ///   - section: <#section description#>
    /// - Returns: <#return value description#>
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries!.count
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
//        if let entries = entries {
//            let entry = entries[indexPath.row]
//            cell.nameLabel.text = entry.name
//        }
        
        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            // Delete the row from the data source
//            entries.remove(at: indexPath.row)
//            saveTable()
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        } else if editingStyle == .insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//        }
//    }


    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    //MARK: - Navigation
    
    /// In a storyboard-based application, you will often want to do a little preparation before navigation
    ///
    /// - Parameters:
    ///   - segue: <#segue description#>
    ///   - sender: <#sender description#>
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        print("segue.identifier..................\(segue.identifier)")
        
        switch(segue.identifier ?? "") {
            
            case "AddItem":
                os_log("Adding a new Entry.", log: OSLog.default, type: .debug)
                
            case "ShowDetail":
                guard let tapiaDetailViewController = segue.destination as? EntryViewController else {
                    fatalError("Unexpected destination: \(segue.destination)")
                }
                
                guard let selectedTapiaCell = sender as? TableViewEntry else {
                    fatalError("Unexpected sender: \(String(describing: sender))")
                }
                
                guard let indexPath = tableView.indexPath(for: selectedTapiaCell) else {
                    fatalError("The selected cell is not being displayed by the table")
                }
                
                let selectedContact = entries![indexPath.row]
                tapiaDetailViewController.contact = selectedContact
                
            default:
                fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
            }
    }
    
    //MARK: Actions
    
    /// unwindToList
    ///
    /// - Parameter sender: <#sender description#>
//    @IBAction func unwindToList(sender: UIStoryboardSegue) {
//        print("unwindToList!")
//
//        if let sourceViewController = sender.source as? EntryViewController, let contact = sourceViewController.contact {
//
//            if let selectedIndexPath = tableView.indexPathForSelectedRow {
//                // Update an existing entry.
//                entries[selectedIndexPath.row] = contact
//                tableView.reloadRows(at: [selectedIndexPath], with: .none)
//            }
//            else {
//                // Add a new tapia.
//                let newIndexPath = IndexPath(row: entries.count, section: 0)
//
//                entries.append(contact)
//                tableView.insertRows(at: [newIndexPath], with: .automatic)
//            }
//
//            // Save the table.
//            saveTable()
//        }
//    }
    
    //MARK: Private Methods
    
    /// loadData
    public func loadData() {
        
        os_log("loadData.", log: OSLog.default, type: .debug)

        // MARK: - Properties
        
        entries = LibraryAPI.shared.getVideoChatList()
    }
    
    /// saveTable
    private func saveTable() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(entries, toFile: Contact.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Table successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save table...", log: OSLog.default, type: .error)
        }
    }
    
    /// loadSavedData
    ///
    /// - Returns: <#return value description#>
    private func loadSavedData() -> [Contact]?  {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Contact.ArchiveURL.path) as? [Contact]
    }

    /// hideNav
    ///
    /// - Parameters:
    ///   - leftItem: left bar Item
    ///   - rightItem: right bar Item
    public func hideNav(leftItem: Bool, rightItem: Bool) {
        
        // disable left nav item
        if (self.navigationItem.leftBarButtonItem != nil && leftItem) {
            self.navigationItem.leftBarButtonItem = nil
        }
        
        // disable right nav item
        if (self.navigationItem.rightBarButtonItem != nil && rightItem) {
            self.navigationItem.rightBarButtonItem = nil
        }
    }
}
