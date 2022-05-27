//
//  CommonHttp.swift
//  Gugujj
//
//  Created by EunTak Oh on 2022/05/27.
//

import Foundation

class CommonHttp {
    static func getAreaBasedList() {
        var params: [String:String] = [:]
        params.updateValue(CommonURL.API_KEY, forKey: "serviceKey")
        params.updateValue("1", forKey: "pageNo")
        params.updateValue("10", forKey: "numOfRows")
        params.updateValue("AppTest", forKey: "MobileApp")
        params.updateValue("ETC", forKey: "MobileOS")
        params.updateValue("P", forKey: "arrange")
        params.updateValue("A02", forKey: "cat1")
        params.updateValue("12", forKey: "contentTypeId")
        params.updateValue("A0201", forKey: "cat2")
        params.updateValue("A02010800", forKey: "cat3")
        params.updateValue("Y", forKey: "listYN")

        dataTask(baseUrl: CommonURL.AREA_BASED_URL, params: params)
    }
    
    static private func dataTask(baseUrl: String, params: [String:String]) {
        //http://api.visitkorea.or.kr/openapi/service/rest/KorService/areaBasedList?serviceKey=A9SNzq25jbRcOZjQbyQJDJ0%2FBj7XHXlyRYCj9zZ0QiXhu9uK8AK8NxRagU7ocRKlZ83jLsvZ1q%2BxoAQinn3pIQ%3D%3D&pageNo=1&numOfRows=10&MobileApp=AppTest&MobileOS=ETC&arrange=P&cat1=A02&contentTypeId=12&cat2=A0201&cat3=A02010800&listYN=Y
        var fullUrl = "http://api.visitkorea.or.kr/openapi/service/rest/KorService/areaBasedList\(getParameterString(params: params))";
        print(fullUrl)
        
        URLSession.shared.dataTask(with: URLRequest(url: URL(string: fullUrl)!)) { data, response, error in
            var dataString = String(data: data!, encoding: .utf8) ?? ""
            print(dataString)
            print(response?.description)
            print(error)
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
        //result.dropLast()
        return result
    }
}
