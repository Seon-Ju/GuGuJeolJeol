//
//  File.swift
//  Gugujj
//
//  Created by Seonju Kim on 2022/06/22.
//

import Foundation
import UIKit

class ImageCacheManager {
    static let shared = NSCache<NSString, NSData>()
    private init(){}
}
