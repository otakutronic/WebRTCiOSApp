//
//  Setting.swift
//  AppTapia
//
//  Created by octto on 2017/10/18.
//  Copyright © 2017 Apple Inc. All rights reserved.
//

//
//  User.swift
//  tapiamobile
//
//  Created by Andy 01/09/17.
//

import Foundation
import RealmSwift

class Setting: Object {
    
    //MARK: - Properties
    @objc dynamic var id: Int = -1
    @objc dynamic var title = ""
    @objc dynamic var imageName = ""
    @objc dynamic var subTitle = ""
    @objc dynamic var segueIdentifier = ""
    
    
    //MARK: - Initializer
    convenience init(id: Int, title: String, imageName: String, subTitle: String, segueIdentifier: String) {
        self.init()
        self.id = id
        self.title = title
        self.imageName = imageName
        self.subTitle = subTitle
        self.segueIdentifier = segueIdentifier
    }
    
    //MARK: -
    override static func primaryKey() -> String? {
        return "id"
    }
    
}

