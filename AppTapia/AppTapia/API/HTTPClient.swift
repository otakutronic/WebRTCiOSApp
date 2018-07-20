//
//  HTTPClient.swift
//  AppTapia
//
//  Created by Andy 01/09/17.
//

import UIKit

class HTTPClient {
    
    /// getRequest
    ///
    /// - Parameter url: <#url description#>
    /// - Returns: <#return value description#>
    @discardableResult func getRequest(_ url: String) -> AnyObject {
        return Data() as AnyObject
    }
    
    /// postRequest
    ///
    /// - Parameters:
    ///   - url: <#url description#>
    ///   - body: <#body description#>
    /// - Returns: <#return value description#>
    @discardableResult func postRequest(_ url: String, body: String) -> AnyObject {
        return Data() as AnyObject
    }
    
    /// downloadImage
    ///
    /// - Parameter url: <#url description#>
    /// - Returns: <#return value description#>
    func downloadImage(_ url: String) -> UIImage? {
        let aUrl = URL(string: url)
        guard let data = try? Data(contentsOf: aUrl!),
            let image = UIImage(data: data) else {
                return nil
        }
        return image
    }
    
}
