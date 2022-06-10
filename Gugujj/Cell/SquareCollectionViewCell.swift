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
    @IBOutlet weak var imageWarningView: UIView!
    
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
            self.imageWarningView.isHidden = true
            
            DispatchQueue.global(qos: .userInitiated).async {
                if let imageURL = nearSight.imageURL, let data = try? Data(contentsOf: URL(string: imageURL)!) {
                    self.imageData = data
                }
                
                DispatchQueue.main.async {
                    self.title.text = nearSight.title
                    self.dist.text = nearSight.dist
                    
                    if self.imageData == nil {
                        CommonHttp.getNaverImage(searchText: nearSight.title) { data in
                            DispatchQueue.main.async {
                                if data != nil {
                                    print(nearSight.title)
                                    self.image.image = UIImage(data: data!)
                                    self.imageWarningView.isHidden = false
                                } else {
                                    self.image.image = UIImage(named: "placeholder")
                                }
                            }
                        }
                    } else {
                        self.image.image = UIImage(data: self.imageData!)
                    }
                }
            }
        }
    }
    
}
