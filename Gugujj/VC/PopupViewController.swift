//
//  PopupViewController.swift
//  Gugujj
//
//  Created by 김선주 on 2022/07/02.
//

import UIKit

class PopupViewController: UIViewController {
    
    @IBOutlet var popupView: UIView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var messageLabel: UILabel!
    
    var popupTitle: String?
    var popupMessage: String?
    
    @IBAction func touchupOkButton() {
        self.dismiss(animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        titleLabel.text = popupTitle
        messageLabel.text = popupMessage
        
        popupView.transform = CGAffineTransform(scaleX: 0.8, y: 1.2)
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0.8,
                       options: [],
                       animations: { self.popupView.transform = .identity })
    }
}
