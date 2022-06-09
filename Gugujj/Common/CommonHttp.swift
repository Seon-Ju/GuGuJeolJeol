//
//  CommonHttp.swift
//  Gugujj
//
//  Created by EunTak Oh on 2022/05/27.
//

import Foundation

class CommonHttp {
    
    // 지역기반 관광정보
    // http://api.visitkorea.or.kr/openapi/service/rest/KorService/areaBasedList?serviceKey=A9SNzq25jbRcOZjQbyQJDJ0%2FBj7XHXlyRYCj9zZ0QiXhu9uK8AK8NxRagU7ocRKlZ83jLsvZ1q%2BxoAQinn3pIQ%3D%3D&pageNo=1&numOfRows=10&MobileApp=AppTest&MobileOS=ETC&arrange=P&cat1=A02&contentTypeId=12&cat2=A0201&cat3=A02010800&listYN=Y
    static func getAreaBasedList(areaCode: String?, pageNo: String, arrange: String, completion: @escaping (Data) -> (Void)) {
        var params: [String:String] = getCommonParams(pageNo: pageNo)
        params.updateValue(arrange, forKey: "arrange")
        params.updateValue("A02", forKey: "cat1")
        params.updateValue("12", forKey: "contentTypeId")
        params.updateValue("A0201", forKey: "cat2")
        params.updateValue("A02010800", forKey: "cat3")
        params.updateValue("Y", forKey: "listYN")
        
        if let areaCode = areaCode {
            params.updateValue(areaCode, forKey: "areaCode")
        }

        dataTask(baseURL: CommonURL.AREA_BASED_URL, params: params) { passingData in
            completion(passingData)
        }
    }
    
    // 공통정보
    // http://api.visitkorea.or.kr/openapi/service/rest/KorService/detailCommon?ServiceKey=A9SNzq25jbRcOZjQbyQJDJ0%2FBj7XHXlyRYCj9zZ0QiXhu9uK8AK8NxRagU7ocRKlZ83jLsvZ1q%2BxoAQinn3pIQ%3D%3D&contentTypeId=12&contentId=294452&MobileOS=ETC&MobileApp=AppTest&defaultYN=Y&firstImageYN=Y&areacodeYN=Y&catcodeYN=Y&addrinfoYN=Y&mapinfoYN=Y&overviewYN=Y&transGuideYN=Y
    static func getDetailCommon(contentId: Int, completion: @escaping (Data) -> (Void)) {
        var params: [String:String] = getCommonParams()
        params.updateValue("\(contentId)", forKey: "contentId")
        params.updateValue("12", forKey: "contentTypeId")
        params.updateValue("Y", forKey: "defaultYN")
        params.updateValue("Y", forKey: "firstImageYN")
        params.updateValue("Y", forKey: "areacodeYN")
        params.updateValue("Y", forKey: "catcodeYN")
        params.updateValue("Y", forKey: "addrinfoYN")
        params.updateValue("Y", forKey: "mapinfoYN")
        params.updateValue("Y", forKey: "overviewYN")
        params.updateValue("Y", forKey: "transGuideYN")
        
        dataTask(baseURL: CommonURL.DETAIL_COMMON_URL, params: params) { passingData in
            completion(passingData)
        }
    }
    
    // 소개정보
    // 유모차 대여 여부, 신용카드 가능 여부, 애완동물 동반 가능 여부, 문의 및 안내 전화번호, 주차시설, 쉬는 날, 이용시간
    // http://api.visitkorea.or.kr/openapi/service/rest/KorService/detailIntro?serviceKey=o4SsZp9tZ%2FCG9GvxPJQ796Ngnou51GsLKBzW6c8UMjmOr1RexN%2BZGdzpJOCjozZYBVLx92BAm3xyZFvQ2eOl5Q%3D%3D&numOfRows=10&pageNo=1&MobileOS=ETC&MobileApp=AppTest&contentId=294452&contentTypeId=12
    static func getDetailIntro(contentId: Int, completion: @escaping (Data) -> (Void)) {
        var params: [String:String] = getCommonParams()
        params.updateValue("\(contentId)", forKey: "contentId")
        params.updateValue("12", forKey: "contentTypeId")
        
        dataTask(baseURL: CommonURL.DETAIL_INTRO_URL, params: params) { passingData in
            completion(passingData)
        }
        
    }
    
    // 반복정보
    // 입장료, 화장실, 외국어 안내서비스 등
    // http://api.visitkorea.or.kr/openapi/service/rest/KorService/detailInfo?serviceKey=o4SsZp9tZ%2FCG9GvxPJQ796Ngnou51GsLKBzW6c8UMjmOr1RexN%2BZGdzpJOCjozZYBVLx92BAm3xyZFvQ2eOl5Q%3D%3D&numOfRows=10&pageNo=1&MobileOS=ETC&MobileApp=AppTest&contentId=294452&contentTypeId=12
    static func getDetailInfo(contentId: Int, completion: @escaping (Data) -> (Void)) {
        var params: [String:String] = getCommonParams()
        params.updateValue("\(contentId)", forKey: "contentId")
        params.updateValue("12", forKey: "contentTypeId")
        
        dataTask(baseURL: CommonURL.DETAIL_INFO_URL, params: params) { passingData in
            completion(passingData)
        }
    }
    
    // 이미지정보
    // http://api.visitkorea.or.kr/openapi/service/rest/KorService/detailImage?serviceKey=o4SsZp9tZ%2FCG9GvxPJQ796Ngnou51GsLKBzW6c8UMjmOr1RexN%2BZGdzpJOCjozZYBVLx92BAm3xyZFvQ2eOl5Q%3D%3D&numOfRows=10&pageNo=1&MobileOS=ETC&MobileApp=AppTest&contentId=1250461&imageYN=Y&subImageYN=Y
    static func getDetailImage(contentId: Int, completion: @escaping (Data) -> (Void)) {
        var params: [String:String] = getCommonParams()
        params.updateValue("\(contentId)", forKey: "contentId")
        params.updateValue("Y", forKey: "imageYN")
        params.updateValue("Y", forKey: "subImageYN")
        
        dataTask(baseURL: CommonURL.DETAIL_IMAGE_URL, params: params) { passingData in
            completion(passingData)
        }
    }
    
    // 위치기반 관광정보
    // http://api.visitkorea.or.kr/openapi/service/rest/KorService/locationBasedList?serviceKey=A9SNzq25jbRcOZjQbyQJDJ0%2FBj7XHXlyRYCj9zZ0QiXhu9uK8AK8NxRagU7ocRKlZ83jLsvZ1q%2BxoAQinn3pIQ%3D%3D&pageNo=1&numOfRows=10&MobileApp=AppTest&MobileOS=ETC&arrange=E&listYN=Y&mapX=127.9827574248&mapY=34.7518848204&radius=10000
    static func getLocationBasedList(pageNo: String, mapX: String, mapY: String, completion: @escaping (Data) -> (Void)) {
        var params: [String:String] = getCommonParams(pageNo: pageNo)
        params.updateValue("12", forKey: "contentTypeId")
        params.updateValue("E", forKey: "arrange")
        params.updateValue("Y", forKey: "listYN")
        params.updateValue(mapX, forKey: "mapX")
        params.updateValue(mapY, forKey: "mapY")
        params.updateValue("10000", forKey: "radius")
        
        dataTask(baseURL: CommonURL.LOCATION_BASED_URL, params: params) { passingData in
            completion(passingData)
        }
    }
    
    // 네이버 이미지검색
    static func getNaverImage(searchText: String, completion: @escaping (Data?) -> Void) {
        var params: [String:String] = [String:String]()
        let encodedText = searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        params.updateValue(encodedText, forKey: "query")
        
        dataTask(baseURL: CommonURL.NAVER_IMAGE_URL, params: params) { passingData in
            do {
                let imageResponse = try JSONDecoder().decode(ImageResponse.self, from: passingData)
                if imageResponse.total > 0 {
                    let imageURL = imageResponse.items[0].link
                    let imageData = try Data(contentsOf: URL(string: imageURL)!)
                    completion(imageData)
                } else {
                    completion(nil)
                }
            } catch {
                print("decodeError: \(error)")
            }
        }
    }
    
    static private func dataTask(baseURL: String, params: [String:String], completion: @escaping (Data) -> (Void)) {
        let fullURL = "\(baseURL)\(getParameterString(params: params))"
        
        var request: URLRequest = URLRequest(url: URL(string: fullURL)!)
        
        if baseURL == CommonURL.NAVER_IMAGE_URL {
            request.httpMethod = "GET"
            request.setValue("ID", forHTTPHeaderField: "X-Naver-Client-Id")
            request.setValue("SECRET", forHTTPHeaderField: "X-Naver-Client-Secret")
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("error: \(error.localizedDescription)")
            }
            if let data = data {
                completion(data)
            }
        }.resume()
    }
    
    static private func getParameterString(params: [String:String]) -> String {
        var result: String = ""
        params.keys.forEach { key in
            if let value = params[key] {
                if result.count == 0 {
                    result += "?"
                }
                result += "\(key)=\(value)&"
            }
        }
        return result
    }
    
    static private func getCommonParams(pageNo: String = "1") -> [String:String] {
            var params: [String:String] = [:]
            params.updateValue(CommonURL.API_KEY, forKey: "serviceKey")
            params.updateValue("10", forKey: "numOfRows")
            params.updateValue(pageNo, forKey: "pageNo")
            params.updateValue("ETC", forKey: "MobileOS")
            params.updateValue("AppTest", forKey: "MobileApp")
            return params
        }
}
