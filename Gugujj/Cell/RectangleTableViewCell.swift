//
//  TempleTableViewCell.swift
//  Gugujj
//
//  Created by Seonju Kim on 2022/05/24.
//

import UIKit

class RectangleTableViewCell: UITableViewCell {

    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var imageWarning: UIView!
    
    private var currentElement: String?
    private var imageData: Data?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 20
        thumbnail.addGradient(color1: UIColor.clear, color2: UIColor.black)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageData = nil
        thumbnail.image = UIImage(named: "placeholder")
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
        imageWarning.isHidden = true

        DispatchQueue.global(qos: .userInitiated).async {
            var isNaverImage: Bool = false
            let thisRowGlobal: Int = indexPath.row
            if let imageURL = temple.imageUrl, imageURL.count != 0, let data = try? Data(contentsOf: URL(string: imageURL)!) {
                self.imageData = data
            }
            if self.imageData == nil {
                let searchText = self.editSearchText(address: temple.addr1, title: temple.title)
                CommonHttp.getNaverImage(searchText: searchText) { data in
                    if let data = data {
                        isNaverImage = true
                        self.imageData = data
                    }
                }
            }
            
            DispatchQueue.main.async {
                if let indexPath: IndexPath = tableView.indexPath(for: self),
                   thisRowGlobal == indexPath.row {
                    self.title.text = temple.title
                    self.address.text = temple.addr1
                    
                    if let imageData = self.imageData {
                        self.thumbnail.image = UIImage(data: imageData)
                        if isNaverImage {
                            self.imageWarning.isHidden = false
                        }
                    } else {
                        self.thumbnail.image = UIImage(named: "placeholder")
                    }
                }
            }
        }
    }
    
    private func editSearchText(address: String?, title: String) -> String {
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
