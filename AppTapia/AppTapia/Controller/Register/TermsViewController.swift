//
//  TermsViewController.swift
//  AppTapia
//
//  Created by Andy 05/09/17.
//

import UIKit

class TermsViewController: UIViewController {

    /// On agree button clicked
    ///
    /// - Parameter sender: <#sender description#>
    @IBAction func agreeButtonClicked(_ sender: Any) {
        self.performSegue(withIdentifier: "RegisterTableViewController", sender: nil)
    }
    
    /// On disagree button clicked
    ///
    /// - Parameter sender: <#sender description#>
    @IBAction func disagreeButtonClicked(_ sender: Any) {

        // ok action
        let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertActionStyle.default) {
            UIAlertAction in
            
        }
        
        showConfirmAlert(viewController: self, Message: NSLocalizedString("ERROR_MESSAGE_DISAGREE_THE_TERM", comment: ""), OkAction: okAction, CancelAction:  nil)
    }
    
    // MARK: - Navigation
    /// prepare
    ///
    /// - Parameters:
    ///   - segue: <#segue description#>
    ///   - sender: <#sender description#>
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        /*if (segue.identifier == REGISTER_SCREEN_ID) {
            if let videoPlayerVC = segue.destination as? RegisterTableViewController {
               videoPlayerVC.displayMode = DisplayMode.DISPLAY_MODE_NEW
            }
        }*/
    }
}
