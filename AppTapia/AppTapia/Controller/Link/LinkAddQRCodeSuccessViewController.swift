//
//  LinkAddQRCodeSuccessViewController.swift
//  AppTapia
//
//  Created by Andy on 01/09/17.
//

import UIKit

class LinkAddQRCodeSuccessViewController: UIViewController {
    
    @IBOutlet var textLabel: UITextView!
    @IBOutlet var homeButton: UIButton!
    var newContactName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("LinkAddQRCodeSuccessViewController")
        
        textLabel.text = String(format: NSLocalizedString("LINK_QRCODE_SUCCESS_TEXT", comment: ""), newContactName)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
