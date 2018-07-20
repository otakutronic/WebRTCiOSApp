//
//  TableViewEntry.swift
//  AppTapia
//
//  Created by Andy on 01/09/17.
//

import UIKit

class TableViewEntry: UITableViewCell {
    
    //MARK: Properties
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    
    /// awakeFromNib
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    /// setSelected
    ///
    /// - Parameters:
    ///   - selected: <#selected description#>
    ///   - animated: <#animated description#>
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
