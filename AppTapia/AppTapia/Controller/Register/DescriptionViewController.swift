//
//  DescriptionViewController.swift
//  AppTapia
//
//  Created by Andy 05/09/17.
//

import UIKit

class DescriptionViewController: UIViewController {

    /// On next button clicked
    ///
    /// - Parameter sender: <#sender description#>
    @IBAction func nextButtonClicked(_ sender: Any) {
        self.performSegue(withIdentifier: "TermsViewController", sender: nil)
    }
}
