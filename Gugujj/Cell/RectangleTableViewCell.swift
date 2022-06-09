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
    
    func configure(templeList: [Temple], tableView: UITableView, indexPath: IndexPath) {
        
        let temple = templeList[indexPath.row]
        
        DispatchQueue.global(qos: .userInitiated).async {
            if let imageURL = temple.imageUrl, imageURL.count != 0, let data = try? Data(contentsOf: URL(string: imageURL)!) {
                self.imageData = data
            }
            
            DispatchQueue.main.async {
                self.title.text = temple.title
                self.address.text = temple.addr1
                
                // 이미지 검색어 세팅
                // ex) 가평 + 대원사
                var editedAddr: String = ""
                var editedTitle: String = temple.title
                
                // addr1에서 시군구 추출
                if let address = temple.addr1, address != "NA" {
                    let siGunGu = String(address.split(separator: " ")[1])
                    editedAddr = String(siGunGu.dropLast())
                }
                
                // title에서 괄호 이하 제거
                if let firstIndex = temple.title.firstIndex(of: "(") {
                    let range = temple.title.startIndex..<firstIndex
                    editedTitle = String(temple.title[range])
                }
                
                let searchText = "\(editedAddr) \(editedTitle)"
                
                if self.imageData == nil {
                    print(searchText)
                    CommonHttp.getNaverImage(searchText: searchText) { data in
                        DispatchQueue.main.async {
                            if data != nil {
                                self.thumbnail.image = UIImage(data: data!)
                            } else {
                                self.thumbnail.image = UIImage(named: "placeholder")
                            }
                        }
                    }
                } else {
                    self.thumbnail.image = UIImage(data: self.imageData!)
                }
            }
            
        }
    }
}
