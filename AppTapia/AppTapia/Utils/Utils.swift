//
//  Utils.swift
//  CyberhoodEIP
//
//  Created by user on 2014/10/1.
//  Copyright (c) 2014年 kinghood. All rights reserved.
//

import Foundation
import UIKit


let mailReceiveDateLocalDateTimeFormatter = "yyyy-MM-dd HH:mm";


// MARK: - Alert utils


public func showWarningAlert(viewController: UIViewController, Message msg:String, OkAction okAction:UIAlertAction?){
    let alert = UIAlertController(title: msg, message: nil, preferredStyle: UIAlertControllerStyle.alert)
    
    if let okAction = okAction {
        alert.addAction(okAction)
    } else {
        alert.addAction(UIAlertAction(title: NSLocalizedString("BACK", comment: ""), style: UIAlertActionStyle.default, handler: nil))
    }
    
    viewController.present(alert, animated: true, completion: nil)
}


public func showConfirmAlert(viewController: UIViewController, Message msg:String, OkAction okAction:UIAlertAction?, CancelAction cancelAction:UIAlertAction?){
    let alert = UIAlertController(title: msg, message: nil, preferredStyle: UIAlertControllerStyle.alert)
    
    // Create the actions.
    //    let cancelAction = UIAlertAction(title: NSLocalizedString("CANCEL", comment: ""), style: UIAlertActionStyle.Cancel) {
    //        UIAlertAction in
    //        NSLog("Cancel Pressed")
    //    }
    
    // Add the actions.
    if let cancelAction = cancelAction {
        alert.addAction(cancelAction)
    }
    if let okAction = okAction {
        alert.addAction(okAction)
    }
    
    viewController.present(alert, animated: true, completion: nil)
}


// MARK: - String utils

extension String {
    func isEmail() -> Bool {
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
}

// MARK: - String HMAC encrypt utils
enum CryptoAlgorithm {
    case MD5, SHA1, SHA224, SHA256, SHA384, SHA512
    
    var HMACAlgorithm: CCHmacAlgorithm {
        var result: Int = 0
        switch self {
        case .MD5:      result = kCCHmacAlgMD5
        case .SHA1:     result = kCCHmacAlgSHA1
        case .SHA224:   result = kCCHmacAlgSHA224
        case .SHA256:   result = kCCHmacAlgSHA256
        case .SHA384:   result = kCCHmacAlgSHA384
        case .SHA512:   result = kCCHmacAlgSHA512
        }
        return CCHmacAlgorithm(result)
    }
    
    var digestLength: Int {
        var result: Int32 = 0
        switch self {
        case .MD5:      result = CC_MD5_DIGEST_LENGTH
        case .SHA1:     result = CC_SHA1_DIGEST_LENGTH
        case .SHA224:   result = CC_SHA224_DIGEST_LENGTH
        case .SHA256:   result = CC_SHA256_DIGEST_LENGTH
        case .SHA384:   result = CC_SHA384_DIGEST_LENGTH
        case .SHA512:   result = CC_SHA512_DIGEST_LENGTH
        }
        return Int(result)
    }
}

extension String  {
    var md5: String! {
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = CC_LONG(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        CC_MD5(str!, strLen, result)
        return stringFromBytes(bytes: result, length: digestLen)
    }
    
    var sha1: String! {
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = CC_LONG(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_SHA1_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        CC_SHA1(str!, strLen, result)
        return stringFromBytes(bytes: result, length: digestLen)
    }
    
    var sha256String: String! {
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = CC_LONG(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_SHA256_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        CC_SHA256(str!, strLen, result)
        return stringFromBytes(bytes: result, length: digestLen)
    }
    
//    var sha512String: String! {
//        let str = self.cString(using: String.Encoding.utf8)
//        let strLen = CC_LONG(self.lengthOfBytes(using: String.Encoding.utf8))
//        let digestLen = Int(CC_SHA512_DIGEST_LENGTH)
//        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
//        CC_SHA512(str!, strLen, result)
//        return stringFromBytes(bytes: result, length: digestLen)
//    }
    
    func stringFromBytes(bytes: UnsafeMutablePointer<CUnsignedChar>, length: Int) -> String{
        let hash = NSMutableString()
        for i in 0..<length {
            hash.appendFormat("%02x", bytes[i])
        }
        bytes.deallocate(capacity: length)
        return String(format: hash as String)
    }
    
//    func hmac(algorithm: CryptoAlgorithm, key: String) -> String {
//        let str = self.cStringUsingEncoding(NSUTF8StringEncoding)
//        let strLen = Int(self.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
//        let digestLen = algorithm.digestLength
//        let result = UnsafeMutablePointer<CUnsignedChar>.alloc(digestLen)
//        let keyStr = key.cStringUsingEncoding(NSUTF8StringEncoding)
//        let keyLen = Int(key.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
//        
//        CCHmac(algorithm.HMACAlgorithm, keyStr!, keyLen, str!, strLen, result)
//        
//        let digest = stringFromResult(result, length: digestLen)
//        
//        result.dealloc(digestLen)
//        
//        return digest
//    }
    
    private func stringFromResult(result: UnsafeMutablePointer<CUnsignedChar>, length: Int) -> String {
        let hash = NSMutableString()
        for i in 0..<length {
            hash.appendFormat("%02x", result[i])
        }
        return String(hash)
    }
}



// MARK: - Date utils

//func UTC2Date(utc: String) -> NSDate {
//    let dateFormatter = NSDateFormatter()
//    //get utc date
//    dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss Z"
//    dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC")
//    let date = dateFormatter.dateFromString(utc)
//    return date!
//}

func UTCDateTime2Date(dateTimeString: String) -> NSDate {
    let dateFormatter = DateFormatter()
    dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC") as TimeZone!
    
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
    if let date = dateFormatter.date(from: dateTimeString) {
        return date as NSDate
    }
    
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    if let date = dateFormatter.date(from: dateTimeString) {
        return date as NSDate
    }
    
    dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss Z"
    if let date = dateFormatter.date(from: dateTimeString) {
        return date as NSDate
    }
    
    return NSDate()
}



extension NSDate {
    
    
//    //NSDate(dateString:"2014-06-06")
//    convenience init(dateString:String) {
//        let dateStringFormatter = DateFormatter()
//        dateStringFormatter.dateFormat = "yyyy-MM-dd"
//        dateStringFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale!
//        let d = dateStringFormatter.date(from: dateString)
//        self.init(timeInterval:0, sinceDate:d!)
//    }
//    //NSDate(dateTimeString:"2014-06-06 08:11:22")
//    convenience init(dateTimeString:String) {
//        let dateStringFormatter = DateFormatter()
//        dateStringFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        let d = dateStringFormatter.date(from: dateTimeString)
//        self.init(timeInterval:0, sinceDate:d!)
//    }
    
    func ToCalendarMenuViewString() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy / MM"
        dateFormatter.timeZone = NSTimeZone.local
        return dateFormatter.string(from: self as Date)
    }
    
    func ToDateString() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = NSTimeZone.local
        return dateFormatter.string(from: self as Date)
    }
    
    func ToMDTimeString() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd"
        dateFormatter.timeZone = NSTimeZone.local
        return dateFormatter.string(from: self as Date)
    }
    
    func ToHMSTimeString() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone.local
        return dateFormatter.string(from: self as Date)
    }
    
    func ToHMTimeString() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.timeZone = NSTimeZone.local
        return dateFormatter.string(from: self as Date)
    }
    
    func ToYMDHMString() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        dateFormatter.timeZone = NSTimeZone.local
        return dateFormatter.string(from: self as Date)
    }
    
    func ToLocalDateTimeString() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone.local
        return dateFormatter.string(from: self as Date)
    }
    func ToUTCDateTimeString() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC") as TimeZone!
        return dateFormatter.string(from: self as Date)
    }
}


// MARK: - File utils
func getImageIconForFilename(fileName: String) -> UIImage{
    let ext =  NSURL(fileURLWithPath: fileName).pathExtension
    switch ext!.lowercased() {
    case "xls",  "xlsx":
        return UIImage(named: "FileTypeExcel")!
    case "doc","docx":
        return UIImage(named: "FileTypeDoc")!
    case "ppt","pptx":
        return UIImage(named: "FileTypePpt")!
    case "pdf":
        return UIImage(named: "FileTypePdf")!
    case "mp3":
        return UIImage(named: "FileTypeAudio")!
    case "jpg", "jpeg", "png", "gif":
        return UIImage(named: "FileTypeImage")!
    case "txt":
        return UIImage(named: "FileTypeTxt")!
    case "zip":
        return UIImage(named: "FileTypeZip")!
    case "mov","mp4", "3gp", "mpeg":
        return UIImage(named: "FileTypeVideo")!
    case "rar":
        return UIImage(named: "FileTypeRar")!
    default:
        return UIImage(named: "FileTypeUnknow")!
    }
    
}

func isFileStreamable(fileName: String) -> Bool{
    let ext =  NSURL(fileURLWithPath: fileName).pathExtension
    switch ext!.lowercased() {
    case "mp3":
        return true
    case "mov","mp4", "3gp", "mpeg", "avi", "wmv", "mkv", "rmvb", "wma", "wav", "webm":
        return true
    default:
        return false
    }
    
}

func getFormattedFileSize(size: Double) -> String{
    
    var result = ""
    if size == 0 {
        result = "0 bytes"
    }else if (size > 0) && (size < 1024)  {
        result = String(format: "%.0f bytes", size)
    }else if (size >= 1024) && (size < pow(1024.0,2.0))  {
        result = String(format: "%.1f KB", (size / 1024.0))
    }else if (size >= pow(1024.0,2.0)) && (size < pow(1024.0,3.0))  {
        result = String(format: "%.2f MB", (size / pow(1024.0, 2.0)))
    }else { //fileSize >= pow(1024,3)
        result = String(format: "%.3f GB", (size / pow(1024.0, 3.0)))
    }
    
    return result
}


// MARK: - Color utils
extension UIColor {
    
    public convenience init?(hexString: String) {
        let r, g, b, a: CGFloat
        
        if hexString.hasPrefix("#") {
            let start = hexString.index(hexString.startIndex, offsetBy: 1)
            let hexColor = hexString.substring(from: start)
            
            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255
                    
                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }
        
        return nil
    }
}


