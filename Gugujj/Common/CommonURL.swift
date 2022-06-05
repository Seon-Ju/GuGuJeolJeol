//
//  CommonURL.swift
//  Gugujj
//
//  Created by EunTak Oh on 2022/05/27.
//

import Foundation

class CommonURL {
    static let API_KEY = "A9SNzq25jbRcOZjQbyQJDJ0%2FBj7XHXlyRYCj9zZ0QiXhu9uK8AK8NxRagU7ocRKlZ83jLsvZ1q%2BxoAQinn3pIQ%3D%3D"
    //static let API_KEY = "A9SNzq25jbRcOZjQbyQJDJ0/Bj7XHXlyRYCj9zZ0QiXhu9uK8AK8NxRagU7ocRKlZ83jLsvZ1q+xoAQinn3pIQ=="
    
    static let DOMAIN = "http://api.visitkorea.or.kr/openapi/service/rest/KorService"
    
    static let AREA_BASED_URL = DOMAIN + "/areaBasedList"
    static let LOCATION_BASED_URL = DOMAIN + "/locationBasedList"
    static let DETAIL_COMMON_URL = DOMAIN + "/detailCommon"
    static let DETAIL_INTRO_URL = DOMAIN + "/detailIntro"
    static let DETAIL_INFO_URL = DOMAIN + "/detailInfo"
    static let DETAIL_IMAGE_URL = DOMAIN + "/detailImage"
}
