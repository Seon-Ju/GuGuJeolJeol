//
//  SquareCollectionViewCell.swift
//  Gugujj
//
//  Created by Seonju Kim on 2022/05/26.
//

import UIKit

class SquareCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var dist: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 20
        
        image.addGradient(color1: UIColor.clear, color2: UIColor.black)
    }
    
}
