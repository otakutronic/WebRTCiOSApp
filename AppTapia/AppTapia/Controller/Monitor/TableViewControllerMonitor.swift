//
//  TableViewControllerMonitor.swift
//  AppTapia
//
//  Created by Andy on 01/09/17.
//

import UIKit
import os.log

class TableViewControllerMonitor: MJITableViewController {
    
    /// viewDidLoad
    override func viewDidLoad() {
        
        print("TableViewControllerMonitor!")
        
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
        return true
    }
    
    //MARK: - Navigation
    
    /// In a storyboard-based application, you will often want to do a little preparation before navigation
    ///
    /// - Parameters:
    ///   - segue: <#segue description#>
    ///   - sender: <#sender description#>
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch(segue.identifier ?? "") {
            
            case "MonitoringControlViewController":
                os_log("Adding a new Entry.", log: OSLog.default, type: .debug)
                
            default:
                fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
    
    /// loadData
    public override func loadData() {

        os_log("loadData.", log: OSLog.default, type: .debug)

        // MARK: - Properties
        entries = LibraryAPI.shared.getMonitorList()
    }
}
