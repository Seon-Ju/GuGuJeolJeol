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
    }
    
}
