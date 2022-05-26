//
//  TabBarViewController.swift
//  Gugujj
//
//  Created by Seonju Kim on 2022/05/26.
//

import UIKit

class CustomTabBar: UIViewController {

    @IBOutlet weak var LocationBtn: UIButton!
    @IBOutlet weak var SearchBtn: UIButton!
    @IBOutlet weak var UserBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.navigationController = self.navigationController
        }
        
    }
    @IBAction func touchUpLocationBtn(_ sender: UIButton) {
        print("touchUpLocationBtn")
        CommonNavi.pushVC(sbName: "Main", vcName: "LocationVC")
    }
    
    @IBAction func touchUpSearchBtn(_ sender: UIButton) {
        print("touchUpSearchBtn")
        CommonNavi.pushVC(sbName: "Main", vcName: "SearchVC")
    }
    
    @IBAction func touchUpUserBtn(_ sender: UIButton) {
        print("touchUpUserBtn")
        CommonNavi.pushVC(sbName: "Main", vcName: "UserVC")
    }
    
    
}
