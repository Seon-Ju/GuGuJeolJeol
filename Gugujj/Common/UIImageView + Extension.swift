//
//  UIImageView + Extension.swift
//  Gugujj
//
//  Created by Seonju Kim on 2022/07/05.
//

import UIKit
import Kingfisher

extension UIImageView {
    func setImage(with urlString: String) {
        let cache = ImageCache.default
        cache.retrieveImage(forKey: urlString) { result in
            switch result {
            case .success(let response):
                // 캐시가 있다면
                if response.image != nil {
                    self.image = response.image
                }
                // 캐시가 없다면
                else {
                    self.kf.setImage(with: URL(string: urlString), placeholder: UIImage(named: "placeholder"))
                }
            case .failure(let err):
                print("Kingfisher error >> \(err.errorCode)")
            }
        }
    }
}
