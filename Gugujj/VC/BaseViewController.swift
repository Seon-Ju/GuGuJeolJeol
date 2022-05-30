//
//  BaseViewController.swift
//  Gugujj
//
//  Created by EunTak Oh on 2022/05/30.
//

import UIKit

/// 화면에서 공통으로 쓰이는 변수, 메소드, 이벤트 콜백 처리를 위한 BaseViewController
class BaseViewController: UIViewController {
    
    // MARK: - Properties
    var isSwipedFlag: Bool = false
    var screenLeftEdgeRecognizer: UIScreenEdgePanGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setScreenEdgePanGestureRecognizer()
    }
    
    private func setScreenEdgePanGestureRecognizer() {
        screenLeftEdgeRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(rotateBall(_:)))
        screenLeftEdgeRecognizer.edges = .left
        view.addGestureRecognizer(screenLeftEdgeRecognizer)
    }
    
    @objc func rotateBall(_ sender: UIScreenEdgePanGestureRecognizer) {
        if !isSwipedFlag {
            CommonNavi.popVC()
            isSwipedFlag = true
        }
    }
}
