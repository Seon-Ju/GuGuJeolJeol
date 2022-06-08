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
    private var temple: Temple?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 20
        thumbnail.addGradient(color1: UIColor.clear, color2: UIColor.black)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
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
        
        temple = templeList[indexPath.row]
        DispatchQueue.main.async {
            self.title.text = self.temple!.title
            self.address.text = self.temple!.addr1
            if self.temple!.imageUrl == nil || self.temple!.imageUrl == "" {
                self.thumbnail.image = UIImage(named: "placeholder")
            }
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            if let imageURL = self.temple!.imageUrl, imageURL.count != 0, let data = try? Data(contentsOf: URL(string: imageURL)!) {
                DispatchQueue.main.async {
                    self.thumbnail.image = UIImage(data: data)
                }
            }
            else {
                CommonHttp.getDetailImage(contentId: self.temple!.id) { data in
                    let parser = XMLParser(data: data)
                    parser.delegate = self
                    parser.parse()
                }
            }
        }
    }
}

extension RectangleTableViewCell: XMLParserDelegate {
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        switch currentElement {
        case "originimgurl":
            if self.temple!.imageUrl == nil, let data = try? Data(contentsOf: URL(string: string)!) {
                self.temple!.imageUrl = string
                DispatchQueue.main.async {
                    self.thumbnail.image = UIImage(data: data)
                }
            }
        default:
            break
        }
    }
}
