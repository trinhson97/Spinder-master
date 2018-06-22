//
//  CacheImage.swift
//  Spinder
//
//  Created by NgocAnh on 4/27/18.
//  Copyright © 2018 NgocAnh. All rights reserved.
//

import Foundation
class CacheImage {
    static let images: NSCache<NSString, AnyObject> = {
        let result = NSCache<NSString, AnyObject>()
        result.countLimit = 15
        result.totalCostLimit = 10 * 1024 * 1024
        return result
    }()
}
