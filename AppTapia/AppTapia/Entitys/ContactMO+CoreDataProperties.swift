//
//  ContactMO+CoreDataProperties.swift
//  
//
//  Created by Ta-Hsiung Hu on 2016/11/23.
//
//

import Foundation
import CoreData


extension ContactMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ContactMO> {
        return NSFetchRequest<ContactMO>(entityName: "Contact");
    }

    @NSManaged public var profilePicture: String?
    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var number: String?
    @NSManaged public var state: String?

}
