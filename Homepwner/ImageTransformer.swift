//
//  ImageTransformer.swift
//  Homepwner
//
//  Created by Christian Keur on 10/6/14.
//  Copyright (c) 2014 Big Nerd Ranch. All rights reserved.
//

import UIKit

@objc(ImageTransformer) class ImageTransformer: NSValueTransformer {
   
    override class func transformedValueClass() -> AnyClass {
        return NSData.self
    }
    
    override func transformedValue(value: AnyObject?) -> AnyObject? {
        if value == nil {
            return nil
        }
        
        if value is NSData {
            return value
        }
        else {
            return UIImagePNGRepresentation(value as UIImage)
        }
    }
    
    override func reverseTransformedValue(value: AnyObject?) -> AnyObject? {
        return UIImage(data: value as NSData)
    }
}
