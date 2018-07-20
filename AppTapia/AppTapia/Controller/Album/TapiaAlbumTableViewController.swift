//
//  TableViewControllerAlbum.swift
//  AppTapia
//
//  Created by Andy on 01/09/17.
//

import UIKit
import os.log

class TapiaAlbumTableViewController: MJITableViewController {
    
    /// viewDidLoad
    override func viewDidLoad() {
        print("TableViewControllerAlbum!")
        super.viewDidLoad()
        
        // hide nav bars
        hideNav(leftItem: true, rightItem                                      : true)
    }
    
    //MARK: - Navigation
    
    /// In a storyboard-based application, you will often want to do a little preparation before navigation
    ///
    /// - Parameters:
    ///   - segue: <#segue description#>
    ///   - sender: <#sender description#>
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch(segue.identifier ?? "") {
            
            case "AlbumTableViewController":
                os_log("Showing an Album Entry.", log: OSLog.default, type: .debug)
                
                //guard let tapiaDetailViewController = segue.destination as? AlbumTableViewController else {
                //fatalError("Unexpected destination: \(segue.destination)")
                //}
                
                //            guard let selectedTapiaCell = sender as? TableViewEntryVideoChat else {
                //                fatalError("Unexpected sender: \(sender)")
                //            }
                //
                //            guard let indexPath = tableView.indexPath(for: selectedTapiaCell) else {
                //                fatalError("The selected cell is not being displayed by the table")
                //            }
                
                //let selectedTapia = entries[indexPath.row]
                //tapiaDetailViewController.entry = selectedTapia
                
            default:
                fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
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
    
    /// loadData
    public override func loadData() {

        os_log("loadData.", log: OSLog.default, type: .debug)

        // MARK: - Properties
        entries = LibraryAPI.shared.getAlbumList()
    }
}
