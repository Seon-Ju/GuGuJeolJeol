//
//  TempleTableViewCell.swift
//  Gugujj
//
//  Created by Seonju Kim on 2022/05/24.
//

import UIKit

class TempleRectangleCell: UITableViewCell {

    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var imageWarningView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 20
        thumbnailImageView.addGradient(color1: UIColor.clear, color2: UIColor.black)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
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
        titleLabel.text = temple.title
        addressLabel.text = temple.addr1
        imageWarningView.isHidden = true
        
        if let imageURL = temple.imageUrl, imageURL.count != 0 {
            self.updateImage(imageURL: imageURL, isNaverImage: false)
        }
        
        else {
            let searchText = self.generateSearchText(address: temple.addr1, title: temple.title)
            DispatchQueue.global(qos: .userInitiated).async {
                CommonHttp.getNaverImage(searchText: searchText) { imageURL in
                    if let imageURL = imageURL, self.verifyImageURL(urlString: imageURL) {
                        self.updateImage(imageURL: imageURL, isNaverImage: true)
                    } else {
                        self.updateImage(imageURL: nil, isNaverImage: false)
                    }
                }
            }
        }
        
    }
    
    private func updateImage(imageURL: String?, isNaverImage: Bool) {
        DispatchQueue.main.async {
            if let imageURL = imageURL {
                self.thumbnailImageView.setImage(with: imageURL)
            } else {
                self.thumbnailImageView.image = UIImage(named: "noimage_up")
            }
            self.imageWarningView.isHidden = !isNaverImage
        }
    }
    
    private func verifyImageURL (urlString: String) -> Bool {
        return NSData(contentsOf: URL(string: urlString)!) == nil ? false : true
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
