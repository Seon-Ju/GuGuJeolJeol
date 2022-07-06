//
//  SquareCollectionViewCell.swift
//  Gugujj
//
//  Created by Seonju Kim on 2022/05/26.
//

import UIKit

class SquareCell: UICollectionViewCell {

    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var distLabel: UILabel!
    @IBOutlet weak var imageWarningView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 20
        thumbnailImageView.addGradient(color1: UIColor.clear, color2: UIColor.black)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        distLabel.text = nil
        thumbnailImageView.image = UIImage(named: "placeholder")
    }
    
    func configure(nearSights: [NearSight], collectionView: UICollectionView, indexPath: IndexPath) {
        
        if !nearSights.isEmpty {
            let nearSight = nearSights[indexPath.row]
            
            titleLabel.text = nearSight.title
            distLabel.text = nearSight.dist
            imageWarningView.isHidden = true
            
            if let imageURL = nearSight.imageURL, imageURL.count != 0 {
                updateImage(collectionView: collectionView, nearSightRow: indexPath.row, imageURL: imageURL, isNaverImage: false)
            }
            
            else {
                DispatchQueue.global(qos: .userInitiated).async {
                    CommonHttp.getNaverImage(searchText: nearSight.title) { imageURL in
                        if let imageURL = imageURL, CommonVar.verifyImageURL(urlString: imageURL) {
                            self.updateImage(collectionView: collectionView, nearSightRow: indexPath.row, imageURL: imageURL, isNaverImage: true)
                        } else {
                            self.updateImage(collectionView: collectionView, nearSightRow: indexPath.row, imageURL: nil, isNaverImage: false)
                        }
                    }
                }
            }
        }
    }
    
    private func updateImage(collectionView: UICollectionView, nearSightRow: Int, imageURL: String?, isNaverImage: Bool) {
        DispatchQueue.main.async {
            if let cellIndexPath = collectionView.indexPath(for: self), cellIndexPath.row == nearSightRow {
                if let imageURL = imageURL {
                    self.thumbnailImageView.setImage(with: imageURL)
                } else {
                    self.thumbnailImageView.image = UIImage(named: "noimage_square")
                }
                self.imageWarningView.isHidden = !isNaverImage
            }
        }
    }
    
}
