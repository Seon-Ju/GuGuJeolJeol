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
    private var mapx: String = ""
    private var mapy: String = ""
    
    // MARK: IBOutlets
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var call: UILabel!
    @IBOutlet weak var restDate: UILabel!
    @IBOutlet weak var useTime: UILabel!
    @IBOutlet weak var parking: UILabel!
    @IBOutlet weak var creditCard: UILabel!
    @IBOutlet weak var pet: UILabel!
    @IBOutlet weak var toilet: UILabel!
    @IBOutlet weak var overviewTitle: UILabel!
    @IBOutlet weak var overview: UITextView!
    @IBOutlet var nearSightCollectionView: UICollectionView!

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = true
        
        nearSightCollectionView.delegate = self
        nearSightCollectionView.dataSource = self
        nearSightCollectionView.register(UINib(nibName: "SquareCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "templeSquareCell")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isSwipedFlag = false
        
        print(TempleViewController.contentId)
        
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
            name.text = string
            overviewTitle.text = "\(string) 이야기"
        case "firstimage":
            let data = try? Data(contentsOf: URL(string: string)!)
            thumbnail.image = UIImage(data: data!)
        case "addr1":
            address.text = string
        case "infocenter":
            call.text = string
        case "restdate":
            restDate.text = string
        case "usetime":
            useTime.text = string
        case "parking":
            if parking.text == "정보 없음" {
                parking.text = string
            } else if let parkingText = parking.text, parkingText.count > 0 {
                parking.text! += string
            }
        case "chkcreditcard":
            creditCard.text = string
        case "chkpet":
            pet.text = string
        case "infoname":
            infoName = string
        case "infotext":
            if infoName == "화장실" {
                toilet.text = string
            }
        case "overview":
            if string.contains("<") || string.contains(">") || string.contains("strong") {
                break
            } else if string.contains("br") {
                overview.text += "\n"
            } else if overview.text.count > 0 {
                overview.text += string
            } else {
                overview.text = string
            }
        case "mapx":
            mapx = string
        case "mapy":
            mapy = string
        default:
            break
        }
    }

}

// MARK: - CollectionView
extension TempleViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "templeSquareCell", for: indexPath)
        return cell
    }
    
}
