//
//  Location.swift
//  Gugujj
//
//  Created by Seonju Kim on 2022/06/02.
//

import Foundation

enum Location: String, CaseIterable {
    case All = "전국"
    case Seoul = "서울"
    case Incheon = "인천"
    case Daejeon = "대전"
    case Daegu = "대구"
    case Gwangju = "광주"
    case Busan = "부산"
    case Ulsan = "울산"
    case Sejong = "세종"
    case Gyeonggi = "경기도"
    case Gangwon = "강원도"
    case Chungbuk = "충청북도"
    case Chungnam = "충청남도"
    case Gyeongbuk = "경상북도"
    case Gyeongnam = "경상남도"
    case Jeonbuk = "전라북도"
    case Jeonnam = "전라남도"
    case Jeju = "제주도"
    
    var code: String? {
        switch self {
        case .All: return nil
        case .Seoul: return "1"
        case .Incheon: return "2"
        case .Daejeon: return "3"
        case .Daegu: return "4"
        case .Gwangju: return "5"
        case .Busan: return "6"
        case .Ulsan: return "7"
        case .Sejong: return "8"
        case .Gyeonggi: return "31"
        case .Gangwon: return "32"
        case .Chungbuk: return "33"
        case .Chungnam: return "34"
        case .Gyeongbuk: return "35"
        case .Gyeongnam: return "36"
        case .Jeonbuk: return "37"
        case .Jeonnam: return "38"
        case .Jeju: return "39"
        }
    }
    
    static var totalCount: Int = 18
}
