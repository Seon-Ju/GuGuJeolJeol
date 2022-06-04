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
        
        // 셀간 간격 설정
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0))
        
        // 셀 radius 설정
        contentView.layer.cornerRadius = 20
    }
    
    func configure(templeList: [Temple], tableView: UITableView, indexPath: IndexPath) {
        
        let temple = templeList[indexPath.row]
        
        /// Image Data Download가 MainThread에서 진행되고 있어서 스크롤 시 끊김현상이 많이 발생하고 있습니다.
        /// 그래서 이미지 다운로드는 백그라운드에서 처리 후 메인스레드에서만 다운로드된 이미지를 가져와 ImageView에 셋팅하도록 했습니다.
        /// 아래 주석된 원래 코드도 실행해보시면서 스크롤 시 끊김현상이 사라지는 걸 체감해보시면 좋은 공부가 될 것 같아요.
              
        DispatchQueue.global(qos: .userInitiated).async {   // Multi Thread Scope Create
            if let imageUrl = temple.imageUrl, let data = try? Data(contentsOf: URL(string: imageUrl)!) {
                self.imageData = data
            }
            DispatchQueue.main.async {  // View 변경 작업은 Main Thread Scope 내 선언.
                self.title.text = temple.title
                self.address.text = temple.addr1
                if let imageData = self.imageData {
                    self.thumbnail.image = UIImage(data: imageData)
                } else {
                    self.thumbnail.image = UIImage(named: "placeholder")
                }
            }
        }
        
//        DispatchQueue.main.async {
//            self.title.text = temple.title
//            self.address.text = temple.addr1
//
//            if let imageUrl = temple.imageUrl {
//                let data = try? Data(contentsOf: URL(string: imageUrl)!)
//                self.thumbnail.image = UIImage(data: data!)
//            } else {
//                self.thumbnail.image = UIImage(named: "placeholder")
//            }
//        }
    }
    
}
