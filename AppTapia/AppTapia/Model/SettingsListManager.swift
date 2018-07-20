//
//  SettingsListManager.swift
//  AppTapia
//
//  Created by Andy 05/09/17.
//

import Foundation
import UIKit
import SwiftyJSON
import PhoneNumberKit
import RealmSwift

class SettingsListManager : ListManager {
    
    /// init
    override init(realm: Realm) {
        
        super.init(realm: realm)
        
        // settings list
        let list = [
            Setting(id: 0, title: "Login", imageName: "Table_setting", subTitle: "", segueIdentifier: "ShowRegisterTableViewController"),
            Setting(id: 1, title: "Version", imageName: "Table_refresh", subTitle: "", segueIdentifier: "ShowSettingVersionTableViewController"),
            Setting(id: 2, title: "Contact us", imageName: "Table_mail", subTitle: "", segueIdentifier: "contact_us"),
            Setting(id: 3, title: "Terms of service", imageName: "Table_doc", subTitle: "", segueIdentifier: "ShowSettingTermsOfServiceViewController"),
            Setting(id: 4, title: "Privacy policy", imageName: "Table_lock", subTitle: "", segueIdentifier: "ShowSettingPrivacyPolicyViewController"),
            Setting(id: 5, title: "Delete account", imageName: "Table_delete", subTitle: "", segueIdentifier: "ShowSettingDeleteAccountViewController"),
            Setting(id: 6, title: "Logout", imageName: "Table_logout", subTitle: "", segueIdentifier: "exit"),
            ]
        
        list.forEach { addOrUpdateEntry(entry: $0) }
    }
    
    /// filter the contacts list for links
    ///
    /// - Returns: a setting list ordered by id
    func getSettingList() -> Results<Setting> {
        return getList(Setting.self).sorted(byKeyPath: "id")
    }
    
}
