//
//  Location.swift
//  Gugujj
//
//  Created by EunTak.Oh on 2022/06/02.
//

/// 서울 1
/// 인천 2
/// 대전 3
/// 대구 4
/// 광주 5
/// 부산 6
/// 울산 7
/// 세종특별자치시 8
/// 경기도 31
/// 강원도 32
/// 충청북도 33
/// 충청남도 34
/// 경상북도 35
/// 경상남도 36
/// 전라북도 37
/// 전라남도 38
/// 제주도 39
import Foundation

enum Location {
    case SEOUL, INCHEON, DAEJEON, DAEGU, GWANGJU, BUSAN, ULSAN, SEJONG, GYUNGGI, GANGWON, CHOONGCHUNG_NORTH, CHOONGCHUNG_SOUTH ,GYUNGSANG_NORTH, GYUNGSANG_SOUTH, JEOLA_NORTH, JEOLA_SOUTH, JEJU
    
    var name: String {
        switch self {
            case .SEOUL: return "서울"
            case .INCHEON: return "인천"
            case .DAEJEON: return "대전"
            case .DAEGU: return "대구"
            case .GWANGJU: return "광주"
            case .BUSAN: return "부산"
            case .ULSAN: return "울산"
            case .SEJONG: return "세종"
            case .GYUNGGI: return "경기"
            case .GANGWON: return "강원"
            case .CHOONGCHUNG_NORTH: return "충청북도"
            case .CHOONGCHUNG_SOUTH: return "충청남도"
            case .GYUNGSANG_NORTH: return "경상북도"
            case .GYUNGSANG_SOUTH: return "경상남도"
            case .JEOLA_NORTH: return "전라북도"
            case .JEOLA_SOUTH: return "전라북도"
            case .JEJU: return "제주"
        }
    }
    
    var areaCode: String {
        switch self {
            case .SEOUL: return "1"
            case .INCHEON: return "2"
            case .DAEJEON: return "3"
            case .DAEGU: return "4"
            case .GWANGJU: return "5"
            case .BUSAN: return "6"
            case .ULSAN: return "7"
            case .SEJONG: return "8"
            case .GYUNGGI: return "31"
            case .GANGWON: return "32"
            case .CHOONGCHUNG_NORTH: return "33"
            case .CHOONGCHUNG_SOUTH: return "34"
            case .GYUNGSANG_NORTH: return "35"
            case .GYUNGSANG_SOUTH: return "36"
            case .JEOLA_NORTH: return "37"
            case .JEOLA_SOUTH: return "38"
            case .JEJU: return "39"
        }
    }
    
    func getLocation(index: Int) -> Location {
        switch index {
        case 0: return .SEOUL
        case 1: return .INCHEON
        case 2: return .DAEJEON
        case 3: return .DAEGU
        case 4: return  .GWANGJU
        case 5: return .BUSAN
        case 6: return .ULSAN
        case 7: return .SEJONG
        case 8: return .GYUNGGI
        case 9: return .GANGWON
        case 10: return .CHOONGCHUNG_NORTH
        case 11: return .CHOONGCHUNG_SOUTH
        case 12: return .GYUNGSANG_NORTH
        case 13: return .GYUNGSANG_SOUTH
        case 14: return .JEOLA_NORTH
        case 15: return .JEOLA_SOUTH
        case 16: return .JEJU
        default:
            return .SEOUL
        }
    }
    
    static var totalCount: Int = 17
}
