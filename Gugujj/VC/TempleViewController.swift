//
//  TempleViewController.swift
//  Gugujj
//
//  Created by Seonju Kim on 2022/05/24.
//

import UIKit
import GoogleMaps

class TempleViewController: BaseViewController {

    // MARK: - Properties
    public static var contentId: Int = 0 // shared
    
    private var currentElement: String = ""
    private var infoName: String = ""
    private var homepageUrl: String = ""
    private var address: String?
    
    private var nearSightVC: NearSightCollectionViewController?
    private var mapX: String = ""
    private var mapY: String = ""
    
    private var isMapLoad: Bool = false
    private var isImageLoad: Bool = false
    
    // MARK: IBOutlets
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var imageWarningView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var homepageButton: UIButton!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var mapView: UIView!
    
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
        imageWarningView.isHidden = true
        
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
    
    private func addMapView() {
        let camera = GMSCameraPosition.camera(withLatitude: Double(mapY)!, longitude: Double(mapX)!, zoom: 15.0)
        let map = GMSMapView.map(withFrame: self.mapView.frame, camera: camera)
        self.mapView.addSubview(map)
        map.translatesAutoresizingMaskIntoConstraints = false
        map.topAnchor.constraint(equalTo: mapView.topAnchor).isActive = true
        map.leftAnchor.constraint(equalTo: mapView.leftAnchor).isActive = true
        map.bottomAnchor.constraint(equalTo: mapView.bottomAnchor).isActive = true
        map.rightAnchor.constraint(equalTo: mapView.rightAnchor).isActive = true

        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: Double(mapY)!, longitude: Double(mapX)!)
        marker.map = map
        
        isMapLoad = true
        checkLoadingEnd(checkImage: isImageLoad, checkMap: isMapLoad)
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
    
    private func checkLoadingEnd(checkImage: Bool, checkMap: Bool) {
        if checkImage && checkMap {
            CustomLoading.hide()
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
            if !isImageLoad {
                let searchText = editSearchText(address: address, title: string)
                CommonHttp.getNaverImage(searchText: searchText) { data in
                    DispatchQueue.main.async {
                        if data != nil {
                            self.thumbnailImageView.image = UIImage(data: data!)
                            self.imageWarningView.isHidden = false
                        } else {
                            self.thumbnailImageView.image = UIImage(named: "placeholder")
                        }
                        self.isImageLoad = true
                        self.checkLoadingEnd(checkImage: self.isImageLoad, checkMap: self.isMapLoad)
                    }
                }
            }
            
        case "firstimage":
            let data = try? Data(contentsOf: URL(string: string)!)
            thumbnailImageView.image = UIImage(data: data!)
            isImageLoad = true
            checkLoadingEnd(checkImage: isImageLoad, checkMap: isMapLoad)
            
        case "homepage":
            if string.contains("http") && homepageUrl.isEmpty {
                homepageUrl = string
                DispatchQueue.main.async {
                    self.homepageButton.layer.isHidden = false
                }
            }
            
        case "addr1":
            address = string
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
            nearSightVC?.sendMapData(mapX: mapX, mapY: mapY)
            addMapView()
            
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
