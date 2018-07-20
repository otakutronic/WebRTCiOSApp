//
//  GalleryItem.swift
//  tapiamobile
//
//  Created by Ta-Hsiung Hu on 2016/10/11.
//  Copyright © 2016年 com.mji.tapia. All rights reserved.
//

import Foundation
import UIKit

class GalleryItem: NSObject {

    var image: UIImage!
    var name = ""
    var date = NSDate()
    var isSync = false
    var isDownloaded = false
    
    
    //public func stringToNSDate() -> NSDate {
        //String to NSDate
        
//        var dateString = "02-03-2017"
//        var dateFormatter = DateFormatter()
//        // This is important - we set our input date format to match our input string
//        // if the format doesn't match you'll get nil from your string, so be careful
//        dateFormatter.dateFormat = "dd-MM-yyyy"
//        var dateFromString = dateFormatter.date(from: dateString)
//       
//        //NSDate to String
//        
//        var formatter = DateFormatter()
//        formatter.dateFormat = "dd-MM-yyyy"
//        let stringDate: String = formatter.string(from: dateFromString)
    //}

    
    public func NSDateToString(dateString: String) {
        //let dateFormatter = DateFormatter()
        //dateFormatter.dateFormat = /* date_format_you_want_in_string from
        // * http://userguide.icu-project.org/formatparse/datetime
        // */
        //let date = dateFormatter.date(from: /* your_date_string */)
    }
}

