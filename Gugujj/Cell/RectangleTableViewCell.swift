//
//  TempleTableViewCell.swift
//  Gugujj
//
//  Created by Seonju Kim on 2022/05/24.
//

import UIKit

class RectangleTableViewCell: UITableViewCell {

    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
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
        addressLabel.text = nil
        thumbnailImageView.image = UIImage(named: "placeholder")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0))
        contentView.layer.cornerRadius = 20
    }
    
    func configure(temple: Temple, tableView: UITableView, indexPath: IndexPath) {
        imageWarningView.isHidden = true

        DispatchQueue.global(qos: .userInitiated).async {
            
            // 캐싱할 객체의 키값 생성
            let cachedKey = NSString(string: temple.title)
            
            // 캐싱된 한국관광공사 이미지데이터가 있을 경우
            if let cachedImageData = ImageCacheManager.shared.object(forKey: cachedKey) {
                self.imageData = cachedImageData as Data?
                self.updateUI(tableView: tableView, temple: temple, templeIndexPath: indexPath, isNaverImage: false)
            }
            
            // 캐싱된 네이버 이미지데이터가 있을 경우
            else if let cachedImageData = ImageCacheManager.shared.object(forKey: NSString(string: "naver\(cachedKey)")) {
                self.imageData = cachedImageData as Data?
                self.updateUI(tableView: tableView, temple: temple, templeIndexPath: indexPath, isNaverImage: true)
            }
            
            // 캐싱된 이미지데이터가 없고 한국관광공사 imageURL값이 있을 경우
            else if let imageURL = temple.imageUrl, imageURL.count != 0, let data = try? Data(contentsOf: URL(string: imageURL)!) {
                self.imageData = data
                self.updateUI(tableView: tableView, temple: temple, templeIndexPath: indexPath, isNaverImage: false)
                ImageCacheManager.shared.setObject(self.imageData! as NSData, forKey: cachedKey)
            }
            
            // 캐싱된 이미지데이터가 없고 네이버 이미지데이터가 있을 경우
            else if self.imageData == nil {
                let searchText = self.generateSearchText(address: temple.addr1, title: temple.title)
                CommonHttp.getNaverImage(searchText: searchText) { data in
                    if let data = data { self.imageData = data }
                    self.updateUI(tableView: tableView, temple: temple, templeIndexPath: indexPath, isNaverImage: true)
                    ImageCacheManager.shared.setObject(self.imageData! as NSData, forKey: NSString(string: "naver\(cachedKey)"))
                }
            }
            
            // 아무것도 없을 경우
            else {
                self.updateUI(tableView: tableView, temple: temple, templeIndexPath: indexPath, isNaverImage: false)
            }
        }
    }
    
    private func updateUI(tableView: UITableView, temple: Temple, templeIndexPath: IndexPath, isNaverImage: Bool) {
        DispatchQueue.main.async {
            if let cellIndexPath: IndexPath = tableView.indexPath(for: self), cellIndexPath.row == templeIndexPath.row {
                self.titleLabel.text = temple.title
                self.addressLabel.text = temple.addr1
                
                if let imageData = self.imageData {
                    self.thumbnailImageView.image = UIImage(data: imageData)
                    if isNaverImage {
                        self.imageWarningView.isHidden = false
                    }
                } else {
                    self.thumbnailImageView.image = UIImage(named: "noimage_up")
                }
            }
        }
    }
    
    private func generateSearchText(address: String?, title: String) -> String {
        // 이미지 검색어 세팅
        // ex) 가평 + 대원사
        var editedAddr: String = ""
        var editedTitle: String = title
        
        // addr1에서 시군구 추출
        if let address = address, address != "NA" {
            let siGunGu = String(address.split(separator: " ")[1])
            if siGunGu.count > 2 {
                editedAddr = String(siGunGu.dropLast())
            } else { // 시군구가 2자 이하인 경우 (ex. 동구, 북구) 도/시로 추출 (ex. 부산 성암사)
                editedAddr = String(address.split(separator: " ")[0][0...1])
            }
        }
        
        // title에서 괄호 이하 제거
        if let firstIndex = title.firstIndex(of: "(") {
            let range = title.startIndex..<firstIndex
            editedTitle = String(title[range])
        }
        
        let searchText = "\(editedAddr) \(editedTitle)"
        print(searchText)
        
        return searchText
    }
}
