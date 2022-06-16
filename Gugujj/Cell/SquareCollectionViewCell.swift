//
//  SquareCollectionViewCell.swift
//  Gugujj
//
//  Created by Seonju Kim on 2022/05/26.
//

import UIKit

class SquareCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var distLabel: UILabel!
    @IBOutlet weak var imageWarningView: UIView!
    
    private var imageData: Data?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 20
        thumbnailImageView.addGradient(color1: UIColor.clear, color2: UIColor.black)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageData = nil
        titleLabel.text = nil
        distLabel.text = nil
        thumbnailImageView.image = UIImage(named: "placeholder")
    }
    
    func configure(nearSights: [NearSight], collectionView: UICollectionView, indexPath: IndexPath) {
        
        if !nearSights.isEmpty {
            let nearSight = nearSights[indexPath.row]
            self.imageWarningView.isHidden = true
            
            DispatchQueue.global(qos: .userInitiated).async {
                var isNaverImage: Bool = false
                
                if let imageURL = nearSight.imageURL, imageURL.count != 0, let data = try? Data(contentsOf: URL(string: imageURL)!) {
                    self.imageData = data
                }
                
                if self.imageData == nil {
                    CommonHttp.getNaverImage(searchText: nearSight.title) { data in
                        if let data = data {
                            isNaverImage = true
                            self.imageData = data
                            self.updateUI(collectionView: collectionView, nearSight: nearSight, nearSightIndexPath: indexPath, isNaverImage: isNaverImage)
                        }
                    }
                }
                else {
                    self.updateUI(collectionView: collectionView, nearSight: nearSight, nearSightIndexPath: indexPath, isNaverImage: isNaverImage)
                }
            }
        }
    }
    
    private func updateUI(collectionView: UICollectionView, nearSight: NearSight, nearSightIndexPath: IndexPath, isNaverImage: Bool) {
        DispatchQueue.main.async {
            if let cellIndexPath: IndexPath = collectionView.indexPath(for: self), cellIndexPath.row == nearSightIndexPath.row {
                self.titleLabel.text = nearSight.title
                self.distLabel.text = nearSight.dist
                
                if let imageData = self.imageData {
                    self.thumbnailImageView.image = UIImage(data: imageData)
                    if isNaverImage {
                        self.imageWarningView.isHidden = false
                    }
                } else {
                    self.thumbnailImageView.image = UIImage(named: "placeholder")
                }
            }
        }
    }
    
}
