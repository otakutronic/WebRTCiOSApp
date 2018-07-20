//
//  VideoChatHistoryViewController.swift
//  AppTapia
//
//  Created by Andy on 01/09/17.
//

import UIKit
import RealmSwift

class VideoChatHistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    
    var contact = Contact()
    var entries: Results<VideoHistory>?
    
    var selectedHistory = VideoHistory()
    
    override func viewDidLoad() {
        
        print("VideoChatHistoryViewController")
        
        let nib = UINib(nibName: "VideoChatHistoryTableViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "VideoChatHistoryTableViewCell")
        
        nameLabel.text = contact.id
        
        tableView.delegate = self
        tableView.dataSource = self
        
        loadData()
    }
    
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return 60
        }else {
            return 80
        }
    }
    
    /// numberOfSections
    ///
    /// - Parameter tableView: <#tableView description#>
    /// - Returns: <#return value description#>
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    /// tableView
    ///
    /// - Parameters:
    ///   - tableView: <#tableView description#>
    ///   - section: <#section description#>
    /// - Returns: <#return value description#>
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.entries!.count
    }
    
    /// tableView
    ///
    /// - Parameters:
    ///   - tableView: <#tableView description#>
    ///   - indexPath: <#indexPath description#>
    /// - Returns: <#return value description#>
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "TableViewEntry"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? TableViewEntryHistory  else {
            fatalError("The dequeued cell is not an instance of TableViewEntry.")
        }
        
        // Fetches the appropriate contacts for the data source layout.
        let history:VideoHistory = entries![indexPath.row]
        
        //time
        let callDate = NSDate(timeIntervalSince1970:(history.date as NSString).doubleValue)
        
        if callDate.ToDateString() == NSDate().ToDateString() { //check if date is today
            cell.timeLabel.text = callDate.ToHMTimeString()
            
        } else {
            cell.timeLabel.text = callDate.ToMDTimeString()
        }
        
        // state
        switch history.state {
        case VideoHistory.CallType.CALL_TYPE_NOREPLY.rawValue:
            cell.typeLabel.text = NSLocalizedString("MESSAGE_VIDEO_CHAT_NOREPLY", comment: "")
        case VideoHistory.CallType.CALL_TYPE_MISSED.rawValue:
            cell.typeLabel.text = NSLocalizedString("MESSAGE_VIDEO_CHAT_MISSED", comment: "")
        case VideoHistory.CallType.CALL_TYPE_INCOMINGSUCCESS.rawValue:
            cell.typeLabel.text = NSLocalizedString("MESSAGE_VIDEO_CHAT_INCOMING", comment: "")
        case VideoHistory.CallType.CALL_TYPE_INCOMINGFAILED.rawValue:
            cell.typeLabel.text = NSLocalizedString("MESSAGE_VIDEO_CHAT_INCOMING_FAILED", comment: "")
        case VideoHistory.CallType.CALL_TYPE_OUTCOMINGSUCCESS.rawValue:
            cell.typeLabel.text = NSLocalizedString("MESSAGE_VIDEO_CHAT_OUTCOMING", comment: "")
        case VideoHistory.CallType.CALL_TYPE_OUTCOMINGFAILED.rawValue:
            cell.typeLabel.text = NSLocalizedString("MESSAGE_VIDEO_CHAT_OUTCOMING_FAILED", comment: "")
        case VideoHistory.CallType.CALL_TYPE_MISSED_NOTIFIED.rawValue:
            cell.typeLabel.text = NSLocalizedString("MESSAGE_VIDEO_CHAT_MISSED", comment: "")
        default:
            fatalError("Unexpected state: \(history.state)")
        }
        
        return cell
    }
    
    /// tableView
    ///
    /// - Parameters:
    ///   - tableView: <#tableView description#>
    ///   - indexPath: <#indexPath description#>
    private func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedHistory = self.entries![indexPath.row]
    }
    
    //    // MARK: - Get History List
    //    func getHistoryList(){
    //        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    //
    //        historyArray = VideoHistoryDao.sharedDao.getAllVideoHistory()
    //
    //        DispatchQueue.main.async(execute: { () -> Void in
    //            self.tableView.reloadData()
    //        })
    //
    //        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    //
    //    }
    
    /// loadData
    public func loadData() {
        
        // MARK: - Properties
        
        entries = LibraryAPI.shared.getVideoHistory(id: contact.id)
        
        DispatchQueue.main.async(execute: { () -> Void in
            self.tableView.reloadData()
        })
    }
}

