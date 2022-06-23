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
                
                // 캐싱할 객체의 키값 생성
                let cachedKey = NSString(string: nearSight.title)
                
                // 캐싱된 한국관광공사 이미지데이터가 있을 경우
                if let cachedImageData = ImageCacheManager.shared.object(forKey: cachedKey) {
                    self.imageData = cachedImageData as Data?
                    self.updateUI(collectionView: collectionView, nearSight: nearSight, nearSightIndexPath: indexPath, isNaverImage: false)
                }
                
                // 캐싱된 네이버 이미지데이터가 있을 경우
                else if let cachedImageData = ImageCacheManager.shared.object(forKey: NSString(string: "naver\(cachedKey)")) {
                    self.imageData = cachedImageData as Data?
                    self.updateUI(collectionView: collectionView, nearSight: nearSight, nearSightIndexPath: indexPath, isNaverImage: true)
                }
                
                // 캐싱된 이미지데이터가 없고 한국관광공사 imageURL값이 있을 경우
                else if let imageURL = nearSight.imageURL, imageURL.count != 0, let data = try? Data(contentsOf: URL(string: imageURL)!) {
                    self.imageData = data
                    self.updateUI(collectionView: collectionView, nearSight: nearSight, nearSightIndexPath: indexPath, isNaverImage: false)
                    ImageCacheManager.shared.setObject(self.imageData! as NSData, forKey: cachedKey)
                }
                
                // 캐싱된 이미지데이터가 없고 네이버 이미지데이터가 있을 경우
                else if self.imageData == nil {
                    CommonHttp.getNaverImage(searchText: nearSight.title) { data in
                        if let data = data {
                            self.imageData = data
                            ImageCacheManager.shared.setObject(self.imageData! as NSData, forKey: NSString(string: "naver\(cachedKey)"))
                        }
                        self.updateUI(collectionView: collectionView, nearSight: nearSight, nearSightIndexPath: indexPath, isNaverImage: true)
                    }
                }
                
                // 아무것도 없을 경우
                else {
                    self.updateUI(collectionView: collectionView, nearSight: nearSight, nearSightIndexPath: indexPath, isNaverImage: false)
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
                    self.thumbnailImageView.image = UIImage(named: "noimage_square")
                }
            }
        }
    }
    
}
