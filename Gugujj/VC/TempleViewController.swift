//
//  TempleViewController.swift
//  Gugujj
//
//  Created by Seonju Kim on 2022/05/24.
//

import UIKit

class TempleViewController: BaseViewController {

    // MARK: - Properties
    public static var contentId: String = "" // shared
    
    private var currentElement: String = ""
    private var infoName: String = ""
    private var homepageUrl: String = ""
    
    private var nearSightVC: NearSightCollectionViewController?
    private var mapX: String = ""
    private var mapY: String = ""
    
    // MARK: IBOutlets
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var homepageButton: UIButton!
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var telLabel: UILabel!
    @IBOutlet weak var restDateLabel: UILabel!
    @IBOutlet weak var useTimeLabel: UILabel!
    @IBOutlet weak var parkingLabel: UILabel!
    @IBOutlet weak var toiletLabel: UILabel!
    @IBOutlet weak var creditCardLabel: UILabel!
    @IBOutlet weak var petLabel: UILabel!
    
    @IBOutlet weak var descTitleLabel: UILabel!
    @IBOutlet weak var descTextView: UITextView!
    
    // MARK: - IBActions
    @IBAction func touchUpHomepageButton(_ sender: UIButton) {
        if let url = URL(string: homepageUrl) {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = true
        
        thumbnailImageView.addGradient(color1: UIColor.clear, color2: UIColor.black)
        homepageButton.layer.isHidden = true
        
        nearSightVC = children.last as? NearSightCollectionViewController
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isSwipedFlag = false
        
        CommonHttp.getDetailCommon(contentId: TempleViewController.contentId) { data in
            self.parseData(data: data)
        }
    
        CommonHttp.getDetailIntro(contentId: TempleViewController.contentId) { data in
            self.parseData(data: data)
        }
        
        CommonHttp.getDetailInfo(contentId: TempleViewController.contentId) { data in
            self.parseData(data: data)
        }
    }
    
    // MARK: - Privates
    private func parseData(data: Data) {
        let parser = XMLParser(data: data)
        parser.delegate = self
        DispatchQueue.main.async {
            parser.parse()
        }
    }
    
}

// MARK: - XMLParser
extension TempleViewController: XMLParserDelegate {
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        switch currentElement {
            
        case "title":
            titleLabel.text = string
            descTitleLabel.text = "\(string) 이야기"
            
        case "firstimage":
            let data = try? Data(contentsOf: URL(string: string)!)
            thumbnailImageView.image = UIImage(data: data!)
            
        case "homepage":
            if string.contains("http") && homepageUrl.isEmpty {
                homepageUrl = string
                DispatchQueue.main.async {
                    self.homepageButton.layer.isHidden = false
                }
            }
            
        case "addr1":
            addressLabel.text = "\(string) "
        
        case "addr2":
            addressLabel.text! += string
            
        case "infocenter":
            telLabel.text = string
            
        case "restdate":
            restDateLabel.text = string
            
        case "usetime":
            if useTimeLabel.text == "정보 없음" {
                useTimeLabel.text = string
            } else if let useTimeText = useTimeLabel.text, useTimeText.count > 0 {
                useTimeLabel.text! += string
            }
            
        case "parking":
            if parkingLabel.text == "정보 없음" {
                parkingLabel.text = string
            } else if let parkingText = parkingLabel.text, parkingText.count > 0 {
                parkingLabel.text! += string
            }
            
        case "chkcreditcard":
            if string == "없음" {
                break
            } else {
                creditCardLabel.text = string
            }
            
        case "chkpet":
            if string == "없음" {
                 break
            } else {
                petLabel.text = string
            }
            
        case "infoname":
            infoName = string
            
        case "infotext":
            if infoName == "화장실" {
                toiletLabel.text = string
            }
            
        case "mapx":
            mapX = string
            
        case "mapy":
            mapY = string
            self.nearSightVC?.sendMapData(mapX: mapX, mapY: mapY)
            
        case "overview":
            if string.contains("<") || string.contains(">") || string.contains("strong") {
                break
            } else if string.contains("br") {
                descTextView.text += "\n"
            } else if descTextView.text.count > 0 {
                descTextView.text += string
            } else {
                descTextView.text = string
            }
            
        default:
            break
        }
    }

}
