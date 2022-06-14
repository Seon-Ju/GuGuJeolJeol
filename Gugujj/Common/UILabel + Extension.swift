//
//  UITextView + Extension.swift
//  Gugujj
//
//  Created by Seonju Kim on 2022/06/14.
//

import UIKit

extension UILabel {
    func setLineSpacing(text: String) {
        let style = NSMutableParagraphStyle()
        let fontSize: CGFloat = 15
        style.lineSpacing = 5
        
        self.attributedText = NSMutableAttributedString(string: text, attributes: [.paragraphStyle: style])
        self.font = UIFont(name: "SpoqaHanSansNeo-Regular", size: fontSize)
    }
}
