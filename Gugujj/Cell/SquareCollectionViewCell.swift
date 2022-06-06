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
    
    var imageData: Data?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 20
        
        image.addGradient(color1: UIColor.clear, color2: UIColor.black)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageData = nil
        image.image = UIImage(named: "placeholder")
    }
    
    func configure(nearSights: [NearSight], collectionView: UICollectionView, indexPath: IndexPath) {
        
        if !nearSights.isEmpty {
            let nearSight = nearSights[indexPath.row]
            
            DispatchQueue.global(qos: .userInitiated).async {
                if let imageUrl = nearSight.imageURL, let data = try? Data(contentsOf: URL(string: imageUrl)!) {
                    self.imageData = data
                }
                DispatchQueue.main.async {
                    self.title.text = nearSight.title
                    self.dist.text = "\(nearSight.dist)m"
                    if let imageData = self.imageData {
                        self.image.image = UIImage(data: imageData)
                    } else {
                        self.image.image = UIImage(named: "placeholder")
                    }
                }
            }
        }
    }
    
}
