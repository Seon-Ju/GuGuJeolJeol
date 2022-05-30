//
//  DetailIntro.swift
//  Gugujj
//
//  Created by Seonju Kim on 2022/05/30.
//

import Foundation

// 소개정보
struct DetailIntro {
    var contentid: Int // 콘텐츠ID
    var contenttypeid: Int // 콘텐츠타입ID
    var accomcount: Int? // 수용인원
    var chkbabycarriage: Int? // 유모차대여 가능 여부
    var chkcreditcard: Int? // 신용카드 가능 여부
    var chkpet: Int? // 애완동물 동반 가능 여부
    var expguide: String? // 체험안내
    var heritage1: Int? // 세계 문화유산 유무
    var heritage2: Int? // 세계 자연유산 유무
    var heritage3: Int? // 세계 기록유산 유무
    var infocenter: String? // 문의 및 안내
    var parking: String? // 주차시설
    var restdate: String? // 쉬는날
    var usetime: String? // 이용시간
}
