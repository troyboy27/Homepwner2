//
//  Item.swift
//  Homepwner
//
//  Created by Christian Keur on 10/6/14.
//  Copyright (c) 2014 Big Nerd Ranch. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class Item: NSManagedObject {
    
    @NSManaged var name: String?
    @NSManaged var serialNumber: String?
    @NSManaged var valueInDollars: Int
    @NSManaged var dateCreated: NSDate
    @NSManaged var itemKey: String
    @NSManaged var thumbnail: UIImage?
    @NSManaged var orderingValue: Double
    @NSManaged var assetType: NSManagedObject?
    
    override func awakeFromInsert() {
        super.awakeFromInsert()
        
        dateCreated = NSDate()
        
        // Create an NSUUID object and get its string representation
        let uuid = NSUUID()
        let key = uuid.UUIDString
        itemKey = key
        
        
        let randomAdjectiveList = ["Fluffy", "Rusty", "Shiny"]
        //
        let randomNounList = ["Bear", "Spork", "Mac"]
        //
        let adjectiveIndex = Int(arc4random_uniform(UInt32(randomAdjectiveList.count)))
        let nounIndex = Int(arc4random_uniform(UInt32(randomNounList.count)))
        valueInDollars = Int(arc4random_uniform(100))
        
        name = "\(randomAdjectiveList[adjectiveIndex]) \(randomNounList[nounIndex])"
        
        var tmpSerialNumber = ""
        
        // Add three letters
        let letters = ["N", "E", "R", "D"]
        for _ in 0..<4 {
            let randomIndex = Int(arc4random_uniform(UInt32(letters.count)))
            tmpSerialNumber = tmpSerialNumber + letters[randomIndex]
        }
        
        // And six numbers
        for _ in 0..<7 {
            tmpSerialNumber = tmpSerialNumber + "\(arc4random_uniform(10))"
        }
        self.serialNumber = tmpSerialNumber
    }
    
    func setThumbnailFromImage(image: UIImage) {
        let origImageSize = image.size
        
        let newRect = CGRect(x: 0, y: 0, width: 40, height: 40)
        
        let ratio = max(newRect.size.width / origImageSize.width, newRect.size.height / origImageSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newRect.size, false, 0.0)
        
        let path = UIBezierPath(roundedRect: newRect, cornerRadius: 5.0)
        path.addClip()
        
        var projectRect = CGRectZero
        projectRect.size.width = ratio * origImageSize.width
        projectRect.size.height = ratio * origImageSize.height
        projectRect.origin.x = (newRect.size.width - projectRect.size.width) / 2.0
        projectRect.origin.y = (newRect.size.height - projectRect.size.height) / 2.0
        
        image.drawInRect(projectRect)
        
        let smallImage = UIGraphicsGetImageFromCurrentImageContext()
        thumbnail = smallImage
        
        UIGraphicsEndImageContext()
        
    }
    
}
