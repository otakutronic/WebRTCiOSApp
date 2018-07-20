//
//  TableViewEntryVideoChat.swift
//  AppTapia
//
//  Created by Andy on 01/09/17.
//

import UIKit

class TableViewEntryVideoChat: TableViewEntry {
    
    //MARK: Properties
    @IBOutlet weak var historyImageView: UIImageView!
    
    weak var tableView: VideoChatTableViewController!
    
    /// didMoveToSuperview
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if superview != nil {
            // image listener set up
            let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(imageContactTapped(tapGestureRecognizer:)))
            photoImageView.isUserInteractionEnabled = true
            photoImageView.addGestureRecognizer(tapGestureRecognizer1)
            
            let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(imagePhoneTapped(tapGestureRecognizer:)))
            historyImageView.isUserInteractionEnabled = true
            historyImageView.addGestureRecognizer(tapGestureRecognizer2)
        }
    }
    
    /// imagePhoneTapped
    ///
    /// - Parameter tapGestureRecognizer: <#tapGestureRecognizer description#>
    func imagePhoneTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        print(tappedImage.image!)
        let id = "VideoChatCallingViewController"
        callBackToParent(ID: id)
    }
    
    /// imageContactTapped
    ///
    /// - Parameter tapGestureRecognizer: <#tapGestureRecognizer description#>
    func imageContactTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        print(tappedImage.image!)
        let id = "VideoChatHistoryViewController"
        callBackToParent(ID: id)
    }
    
    /// callBackToParent
    ///
    /// - Parameter tapGestureRecognizer: <#tapGestureRecognizer description#>
    func callBackToParent(ID: String) {
        let sender = self
        tableView.onSelectedCellImage(ID: ID, sender: sender)
    }
}

