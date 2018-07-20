//
//  VideoChatTableViewController.swift
//  AppTapia
//
//  Created by Andy on 01/09/17.
//

import UIKit
import os.log

class VideoChatTableViewController: MJITableViewController {
    
    /// viewDidLoad
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // hide nav bars
        hideNav(leftItem: true, rightItem: true)
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
        
        switch(segue.identifier ?? "") {
            
        case "VideoChatCallingViewController":
            
            let nav = segue.destination as! UINavigationController
            
            guard let tapiaChatViewController = nav.topViewController as? VideoChatCallingViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedCell = sender as? TableViewEntry else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedContact = entries![indexPath.row]
            tapiaChatViewController.contact = selectedContact
            print("selectedContact")
            print(selectedContact)
            //tapiaChatViewController.room =
            
            break
            
        case "VideoChatHistoryViewController":
            
            guard let tapiaHistoryViewController = segue.destination as? VideoChatHistoryViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedCell = sender as? TableViewEntry else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedContact = entries![indexPath.row]
            tapiaHistoryViewController.contact = selectedContact
            
            break
            
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
    
    // MARK: - Unwind segue event
    @IBAction func unwindToVideoChatTableViewController(_ segue: UIStoryboardSegue) {
        
        //      socketIO_Disconnect()
        
    }
    
    /// on cell image Selected
    ///
    /// - Parameters:
    ///   - ID: <#ID description#>
    ///   - sender: <#sender description#>
    public func onSelectedCellImage(ID: String, sender: Any?) {
        self.performSegue(withIdentifier: ID, sender: sender)
    }
    
    /// tableView
    ///
    /// - Parameters:
    ///   - tableView: <#tableView description#>
    ///   - indexPath: <#indexPath description#>
    /// - Returns: <#return value description#>
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "TableViewEntry"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? TableViewEntryVideoChat  else {
            fatalError("The dequeued cell is not an instance of TableViewEntry.")
        }
        
        // Fetches the appropriate contacts for the data source layout.
        let entry = entries![indexPath.row]
        
        cell.nameLabel.text = entry.id
        //cell.photoImageView.image = entry.photo
        cell.tableView = self
        
        return cell
    }
}

