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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 20
        
        thumbnail.addGradient(color1: UIColor.clear, color2: UIColor.black)
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
        print(temple)
        
        DispatchQueue.main.async {
            self.title.text = temple.title
            self.address.text = "\(temple.addr1 ?? "") \(temple.addr2 ?? "")"
            
            let data = try? Data(contentsOf: URL(string: temple.firstimage!)!)
            self.thumbnail.image = UIImage(data: data!)
        }
    }
    
}
