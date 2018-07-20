//
//  SettingVersionTableViewController.swift
//  tapiamobile
//
//  Created by Ta-Hsiung Hu on 2016/10/5.
//  Copyright © 2016年 com.mji.tapia. All rights reserved.
//

import UIKit

class SettingVersionTableViewController: UITableViewController {

    
    @IBOutlet var versionNowLabel: UILabel!
    @IBOutlet var versionLastLabel: UILabel!
    
    
    override func viewDidLoad() {
        
        title = NSLocalizedString("TITLE_VERSION", comment: "")
        let nsObject: AnyObject? = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as AnyObject?
        let version = nsObject as! String
        versionNowLabel.text = "\(version)"
        
        versionLastLabel.text = "Unknow"
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        socketIO_GetLastAppVersion() { (responseString, responseData) in
            print("@@@@@ socketIO_GetLastAppVersion:\(responseString)")
            
            if responseString == SOCKETIO_EVENT_GET_LAST_APP_VERSION_SUCCESS_TAG {
                let lastVersion = responseData[0] as! String
                DispatchQueue.main.async(execute: { () -> Void in
                    self.versionLastLabel.text = lastVersion
                })
                
                
            }
        }

    }
    
}
