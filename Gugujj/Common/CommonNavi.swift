//
//  CommonNavi.swift
//  Gugujj
//
//  Created by Seonju Kim on 2022/05/24.
//

import Foundation
import UIKit

class CommonNavi {
    static func pushVC(sbName: String, vcName: String) {
        if let delegate = UIApplication.shared.delegate as? AppDelegate,
           let navigationController = delegate.navigationController {
            let sb = UIStoryboard(name: sbName, bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: vcName)
            navigationController.pushViewController(vc, animated: true)
        }
    }
    
    static func popVC() {
        if let delegate = UIApplication.shared.delegate as? AppDelegate,
           let navigationController = delegate.navigationController {
            navigationController.popViewController(animated: true)
        }
    }
    
    static func popToRootVC() {
        if let delegate = UIApplication.shared.delegate as? AppDelegate,
           let navigationController = delegate.navigationController {
            navigationController.popToRootViewController(animated: true)
        }
    }
}
