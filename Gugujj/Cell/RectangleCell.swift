//
//  TempleTableViewCell.swift
//  Gugujj
//
//  Created by Seonju Kim on 2022/05/24.
//

import UIKit

class RectangleCell: UITableViewCell {

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
            updateImage(tableView: tableView, templeRow: indexPath.row, imageURL: imageURL, isNaverImage: false)
        }
        
        else {
            let searchText = CommonUtil.generateSearchText(address: temple.addr1, title: temple.title)
            DispatchQueue.global(qos: .userInitiated).async {
                CommonHttp.getNaverImage(searchText: searchText) { imageURL in
                    if let imageURL = imageURL, CommonUtil.verifyImageURL(urlString: imageURL) {
                        self.updateImage(tableView: tableView, templeRow: indexPath.row, imageURL: imageURL, isNaverImage: true)
                    } else {
                        self.updateImage(tableView: tableView, templeRow: indexPath.row, imageURL: nil, isNaverImage: false)
                    }
                }
            }
        }
    }
    
    private func updateImage(tableView: UITableView, templeRow: Int, imageURL: String?, isNaverImage: Bool) {
        DispatchQueue.main.async {
            if let cellIndexPath = tableView.indexPath(for: self), cellIndexPath.row == templeRow {
                if let imageURL = imageURL {
                    self.thumbnailImageView.setImage(with: imageURL)
                } else {
                    self.thumbnailImageView.image = UIImage(named: "noimage_up")
                }
                self.imageWarningView.isHidden = !isNaverImage
            }
        }
    }

}
