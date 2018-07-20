//
//  TableViewControllerLink.swift
//  AppTapia
//
//  Created by Andy on 01/09/17.
//

import UIKit
import os.log
import SwiftyJSON

class TapiaLinkTableViewController: MJITableViewController {
    
    /// viewDidLoad
    override func viewDidLoad() {
        
        print("TapiaLinkTableViewController")
        
        super.viewDidLoad()
        
        hideNav(leftItem: true, rightItem: false)
    }
    
    /// In a storyboard-based application, you will often want to do a little preparation before navigation
    ///
    /// - Parameters:
    ///   - segue: <#segue description#>
    ///   - sender: <#sender description#>
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch(segue.identifier ?? "") {

            case "LinkEditViewController":

                let nav = segue.destination as! UINavigationController

                guard let tapiaContactEditViewController = nav.topViewController as? LinkEditViewController else {
                    fatalError("Unexpected destination: \(segue.destination)")
                }

                tapiaContactEditViewController.contact = sender as! Contact
                
                break
    
            case "LinkAddViewController":

                os_log("Adding a new Contact.", log: OSLog.default, type: .debug)
                
            break

            default:
                fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
    
    /// tableView
    ///
    /// - Parameters:
    ///   - tableView: <#tableView description#>
    ///   - indexPath: <#indexPath description#>
    /// - Returns: <#return value description#>
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {

        // action one
        let deleteAction = UITableViewRowAction(style: .default, title: "Erase", handler: { (action, indexPath) in
            print("Delete tapped: \(indexPath)")
            
            // cancel action
            let daialogCancelAction = UIAlertAction(title: NSLocalizedString("CANCEL", comment: ""), style: UIAlertActionStyle.cancel) { UIAlertAction in
                self.tableView.setEditing(false, animated: true)
            }
            
            // ok action
            let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertActionStyle.default) { UIAlertAction in
                
                self.deleteLink(indexPath: indexPath)
                //self.HUD = MBProgressHUD.showAdded(to: self.navigationController!.view, animated: true)
                //self.HUD.mode = MBProgressHUDMode.indeterminate
                //self.HUD.label.text = NSLocalizedString("LOADING", comment: "")
            }
            
            showConfirmAlert(viewController: self, Message: NSLocalizedString("CONFIRM_MESSAGE_CANCEL", comment: ""), OkAction: okAction, CancelAction:  daialogCancelAction)
        })
        deleteAction.backgroundColor = UIColor.orange
        
        // action two
        let editAction = UITableViewRowAction(style: .default, title: "Edit", handler: { (action, indexPath) in
            
            self.editLink(indexPath: indexPath)
        })
        editAction.backgroundColor = UIColor.lightGray
        
        return [deleteAction, editAction]
    }
    
    /// Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //Delete the row from the data source
            //entries.remove(at: indexPath.row)
            //saveTable()
            //tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    /// deleteLink
    ///
    /// - Parameter itemIndex: <#itemIndex description#>
    private func deleteLink(indexPath: IndexPath) {
        
        print("Delete contact: \(indexPath)")
        
//        LibraryAPI.shared.deleteContact(uuid: id, phoneNumber: formattedNumber) {
//            (responseString: String, responseData: [AnyObject]) in
//
//            print("Deleted item result: \(responseString)")
//
//            if (responseString == SOCKETIO_EVENT_ADD_REQUEST_SUCCESS_TAG) {
//
//            } else { //SOCKETIO_EVENT_ADD_REQUEST_FAIL_TAG
//
//            }
//        }
    }
    
    /// editLink
    ///
    /// - Parameter itemIndex: <#itemIndex description#>
    private func editLink(indexPath: IndexPath) {
        
        print("Edit contact: \(indexPath)")
        //self.tableView.setEditing(false, animated: true)
        let entry = self.entries![indexPath.row]
        self.performSegue(withIdentifier: "LinkEditViewController", sender: entry)
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
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? TableViewEntryLink  else {
            fatalError("The dequeued cell is not an instance of TableViewEntry.")
        }
        
        // Fetches the appropriate contacts for the data source layout.
        let entry = entries![indexPath.row]
        
        cell.nameLabel.text = entry.id
        //cell.tableView = self
        
        if(entry.profilePicture != "") {
            let imageDecoded:UIImage = entry.decodeImage(stringImage: entry.profilePicture)
            cell.photoImageView.image = imageDecoded
        }
        
        return cell
    }
    
    // MARK: - Unwind segue event
    @IBAction func unwindToLinkTableViewController(_ segue: UIStoryboardSegue) {
        self.viewDidLoad()
    }
    
    /// loadData
    public override func loadData() {

        os_log("loadData.", log: OSLog.default, type: .debug)

        // MARK: - Properties
        entries = LibraryAPI.shared.getLinksList()
    }
}
