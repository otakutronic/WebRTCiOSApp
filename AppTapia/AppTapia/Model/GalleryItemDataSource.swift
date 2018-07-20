//
//  GalleryItemDataSource.swift
//  tapiamobile
//
//  Created by Ta-Hsiung Hu on 2016/11/1.
//  Copyright © 2016年 com.mji.tapia. All rights reserved.
//

import Foundation
import UIKit


class GalleryItemDataSource {
    
    var images:[GalleryItem] = []
    var groups:[String] = []
    
    ////func numbeOfRowsInEachGroup(index: Int) -> Int {
        ////return ImagesInGroup(gorupIndex: index).count
    ////}
    
    ////func numberOfGroups() -> Int {
        ////return groups.count
    ////}
    
    ////func gettGroupLabelAtIndex(index: Int) -> String {
        ////return groups[index]
    ////}
    
    // MARK:- Add item
    
    func addNewItem(item: GalleryItem) {

        ////if !groups.contains(item.date.ToDateString()!){
            ////groups.append(item.date.ToDateString()!)
        ////}
        
        images.append(item)
    }
    
    // MARK:- Delete items
    
    func deleteItems(items: [GalleryItem]) {
        
        for item in items {
            // remove item
            let index = images.indexOfObject(item: item)
            if index != -1 {
                images.remove(at: index)
            }
        }
    }
    

    ////func ImagesInGroup(gorupIndex: Int) -> [GalleryItem] {
        
        ////if groups.count == 0 {
            ////return images
            
        ////} else {
            ////let item = groups[gorupIndex]
            ////let filteredImages = images.filter {(image: GalleryItem) -> Bool in
                ////return image.date.ToDateString() == item
            ////}
            ////return filteredImages
       //// }
   //// }

    

    ////func getImage(gorupIndex: Int, imageIndex: Int) -> GalleryItem {
       //// let item = groups[gorupIndex]
        ////let filteredImages = images.filter {(image: GalleryItem) -> Bool in
            ////return image.date.ToDateString() == item
        ////}
        
        
        ////return filteredImages[imageIndex]
   //// }

}

extension Array {
    func indexOfObject<T:AnyObject>(item:T) -> Int {
        var index = -1
        for element in self {
            index += 1
            if item === element as? T {
                return index
            }
        }
        return index
    }
}
