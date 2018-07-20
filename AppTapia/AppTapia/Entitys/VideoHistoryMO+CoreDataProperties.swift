//
//  VideoHistoryMO+CoreDataProperties.swift
//  
//
//  Created by Ta-Hsiung Hu on 2016/11/23.
//
//

import Foundation
import CoreData


extension VideoHistoryMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<VideoHistoryMO> {
        return NSFetchRequest<VideoHistoryMO>(entityName: "VideoHistory");
    }

    @NSManaged public var contactID: String?
    @NSManaged public var date: String?
    @NSManaged public var id: String?
    @NSManaged public var length: String?
    @NSManaged public var state: String?

}
