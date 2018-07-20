//
//  SettingTermsOfServiceViewController.swift
//  tapiamobile
//
//  Created by Ta-Hsiung Hu on 2016/10/5.
//  Copyright © 2016年 com.mji.tapia. All rights reserved.
//

import UIKit

class SettingTermsOfServiceViewController: UIViewController {

    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var contentTextView: UITextView!
    
    override func viewDidLoad() {
        titleLabel.text = NSLocalizedString("TITLE_TERMS_CONTENT", comment: "")
        contentTextView.text = NSLocalizedString("TERMS_CONTENT_TEXT", comment: "")
        
    }
    
    
    
    
}
