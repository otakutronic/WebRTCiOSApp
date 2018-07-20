//
//  BioAuthenticationHelper.swift
//  AppTapia
//
//  Created by octto on 2017/11/20.
//  Copyright © 2017 Apple Inc. All rights reserved.
//

import Foundation
import BiometricAuthentication

class BioAuthenticationHelper {
    
    func hasBioID() -> Bool {
        return BioMetricAuthenticator.canAuthenticate()
    }
    
    func hasPasscodeInKeyChain() -> Bool {
        //TODO:
        return true
    }
    
    func savePasscodeToKeyChain(passcode: String) {
        do {
            let passcodeItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName,
                                                    account: DataManager.currentUser.id,
                                                    accessGroup: KeychainConfiguration.accessGroup)
            
            try passcodeItem.savePassword(passcode)
        } catch {
            fatalError("Error updating keychain \(error)")
        }
    }
    
    func readPasscodeFromKeyChain() -> String {
        let passcodeItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName,
                                                account: DataManager.currentUser.id,
                                                accessGroup: KeychainConfiguration.accessGroup)
        
        do {
            let passcode = try passcodeItem.readPassword()
            return passcode
        } catch {
            return ""
        }
    }
    
}
