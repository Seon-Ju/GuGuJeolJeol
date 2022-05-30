//
//  DetailCommon.swift
//  Gugujj
//
//  Created by Seonju Kim on 2022/05/30.
//

import Foundation

// 공통정보
struct DetailCommon {
    var contentid: Int // 콘텐츠ID
    var contenttypeid: Int? // 콘텐츠타입ID
    var title: String // 제목
    var addr1: String? // 주소
    var addr2: String? // 상세주소
    var areacode: Int? // 지역코드
    var sigungucode: Int? // 시군구코드
    var zipcode: Int? // 우편번호
    var booktour: Int? // 교과서 여행지 여부
    var cat1: String? // 대분류
    var cat2: String? // 중분류
    var cat3: String? // 소분류
    var createdtime: Int // 등록일
    var modifiedtime: Int // 수정일
    var firstimage: String? // 대표이미지(원본)
    var firstimage2: String? // 대표이미지(썸네일)
    var mapx: String? // GPS X좌표
    var mapy: String? // GPS Y좌표
    var mlevel: Int? // Map Level
    var overview: String? // 설명
}
