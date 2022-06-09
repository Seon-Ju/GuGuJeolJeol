//
//  ImageResponse.swift
//  Gugujj
//
//  Created by Seonju Kim on 2022/06/09.
//

import Foundation

struct ImageResponse: Codable {
    var lastBuildDate: String
    var total: Int
    var start: Int
    var display: Int
    var items: [Image]
}

struct Image: Codable {
    var title: String
    var link: String
    var thumbnail: String
    var sizeheight: String
    var sizewidth: String
}
