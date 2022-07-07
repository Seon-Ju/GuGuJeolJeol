//
//  TempleViewController.swift
//  Gugujj
//
//  Created by Seonju Kim on 2022/05/24.
//

import UIKit
import GoogleMaps

class TempleVC: BaseVC {

    // MARK: - Properties
    public static var contentId: Int = 0 // shared
    
    private var currentElement: String = ""
    private var infoName: String = ""
    private var homepageUrl: String = ""
    private var address: String?
    
    private var nearSightVC: TempleNearSightVC?
    private var mapX: String = ""
    private var mapY: String = ""
    
    private var isImageLoad: Bool = false
    
    private let dispatchGroup = DispatchGroup()
    private let dispatchQueue = DispatchQueue(label: "queue", qos: .userInitiated, attributes: .concurrent)
    
    // MARK: IBOutlets
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var imageWarningView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var homepageButton: UIButton!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var mapView: UIView!
    
    @IBOutlet weak var detailStackView: UIStackView!
    @IBOutlet weak var telTextView: UITextView!
    @IBOutlet weak var restDateLabel: UILabel!
    @IBOutlet weak var useTimeLabel: UILabel!
    @IBOutlet weak var parkingLabel: UILabel!
    @IBOutlet weak var toiletLabel: UILabel!
    @IBOutlet weak var petLabel: UILabel!
    
    @IBOutlet weak var descTitleLabel: UILabel!
    @IBOutlet weak var descTextView: UITextView!
    
    // MARK: - IBActions
    @IBAction func touchUpHomepageButton(_ sender: UIButton) {
        if let url = URL(string: homepageUrl) {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    @IBAction func touchUpBackButton(_ sender: UIButton) {
        CommonNavi.popVC()
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = true
        
        thumbnailImageView.addGradient(color1: UIColor.clear, color2: UIColor.black)
        homepageButton.layer.isHidden = true
        
        nearSightVC = children.last as? TempleNearSightVC
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isSwipedFlag = false
        imageWarningView.isHidden = true
        
        dispatchQueue.async(group: dispatchGroup) {
            self.dispatchGroup.enter()
            CommonHttp.getDetailCommon(contentId: TempleVC.contentId) { data in
                guard let xmlData = data else { // 통신 오류시
                    self.handleHttpfailure()
                    return
                }
                self.parseData(data: xmlData)
            }
            
            self.dispatchGroup.enter()
            CommonHttp.getDetailIntro(contentId: TempleVC.contentId) { data in
                guard let xmlData = data else { // 통신 오류시
                    self.handleHttpfailure()
                    return
                }
                self.parseData(data: xmlData)
            }
            
            self.dispatchGroup.enter()
            CommonHttp.getDetailInfo(contentId: TempleVC.contentId) { data in
                guard let xmlData = data else { // 통신 오류시
                    self.handleHttpfailure()
                    return
                }
                self.parseData(data: xmlData)
            }
        }
        
        dispatchGroup.notify(queue: dispatchQueue) {
            print("통신 끝")
            DispatchQueue.main.async {
                self.setLineSpacing()
                self.hideNonDetailSection()
                CustomLoading.hide()
            }
        }
        
    }
    
    // MARK: - Privates
    private func parseData(data: Data) {
        let parser = XMLParser(data: data)
        parser.delegate = self
        DispatchQueue.main.async {
            parser.parse()
            print("파싱 끝")
            self.dispatchGroup.leave()
        }
    }
    
    private func addMapView() {
        dispatchGroup.enter()
        
        let camera = GMSCameraPosition.camera(withLatitude: Double(mapY)!, longitude: Double(mapX)!, zoom: 15.0)
        let map = GMSMapView.map(withFrame: self.mapView.frame, camera: camera)
        mapView.addSubview(map)
        map.translatesAutoresizingMaskIntoConstraints = false
        map.topAnchor.constraint(equalTo: mapView.topAnchor).isActive = true
        map.leftAnchor.constraint(equalTo: mapView.leftAnchor).isActive = true
        map.bottomAnchor.constraint(equalTo: mapView.bottomAnchor).isActive = true
        map.rightAnchor.constraint(equalTo: mapView.rightAnchor).isActive = true

        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: Double(mapY)!, longitude: Double(mapX)!)
        marker.map = map
        
        let button = UIButton(frame: self.mapView.frame)
        button.addTarget(self, action: #selector(launchGoogleMap(_:)), for: .touchUpInside)
        mapView.addSubview(button)
        
        print("맵뷰 끝")
        dispatchGroup.leave()
    }
    
    @objc private func launchGoogleMap(_ sender: UIButton) {
        if UIApplication.shared.canOpenURL(URL(string: "comgooglemaps:")!) {
            if let url = URL(string: "comgooglemaps://?ll=\(mapY),\(mapX)"), !url.absoluteString.isEmpty {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        } else {
            if let url = URL(string: "http://maps.google.com/maps?ll=\(mapY),\(mapX)"), !url.absoluteString.isEmpty {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    private func fillImageView(searchText: String) {
        dispatchGroup.enter()
        CommonHttp.getNaverImage(searchText: searchText) { imageURL in
            if let imageURL = imageURL, CommonUtil.verifyImageURL(urlString: imageURL) {
                self.updateImage(imageURL: imageURL, isNaverImage: true)
            } else {
                self.updateImage(imageURL: nil, isNaverImage: false)
            }
            print("이미지 끝")
            self.dispatchGroup.leave()
        }
    }
    
    private func updateImage(imageURL: String?, isNaverImage: Bool) {
        DispatchQueue.main.async {
            if let imageURL = imageURL {
                self.thumbnailImageView.setImage(with: imageURL)
            } else {
                self.thumbnailImageView.image = UIImage(named: "noimage")
            }
            self.imageWarningView.isHidden = !isNaverImage
        }
    }
    
    private func appendText(on label: UILabel, string: String) {
        label.textColor = UIColor.black
        if label.text == "아직 정보가 없어요 T_T" {
            label.text = string
        } else if !string.contains("<") && !string.contains(">") && !string.contains("strong") && !string.contains("br") {
            label.text! += string
        }
    }
    
    private func appendText(on textView: UITextView, string: String) {
        textView.textColor = UIColor.black
        if textView.text == "아직 정보가 없어요 T_T" {
            textView.text = string
        } else if string.contains("br") && textView == descTextView {
            textView.text += "\n"
        } else if !string.contains("<") && !string.contains(">") && !string.contains("strong") && !string.contains("br") {
            textView.text += string
        }
    }
    
    private func setLineSpacing() {
        telTextView.setLineSpacing(text: telTextView.text!)
        restDateLabel.setLineSpacing(text: restDateLabel.text!)
        useTimeLabel.setLineSpacing(text: useTimeLabel.text!)
        parkingLabel.setLineSpacing(text: parkingLabel.text!)
        descTextView.setLineSpacing(text: descTextView.text)
    }
    
    private func hideNonDetailSection() {
        detailStackView.arrangedSubviews.forEach { section in
            section.subviews.forEach { view in
                section.isHidden = false
                if let label = view as? UILabel, label.text == "아직 정보가 없어요 T_T" {
                    section.isHidden = true
                } else if let textView = view as? UITextView, textView.text == "아직 정보가 없어요 T_T" {
                    section.isHidden = true
                }
            }
        }
    }
    
    private func handleHttpfailure() {
        DispatchQueue.main.async {
            CustomLoading.hide()
            let action: UIAlertAction = UIAlertAction(title: "확인", style: .default)
            let alert: UIAlertController = UIAlertController(title: "알림", message: "오류가 발생했습니다. 다시 시도해주세요.", preferredStyle: .alert)
            alert.addAction(action)
            self.present(alert, animated: true)
        }
    }
    
}

// MARK: - XMLParser
extension TempleVC: XMLParserDelegate {
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        switch currentElement {
            
        case "title":
            if !isImageLoad {
                let searchText = CommonUtil.generateSearchText(address: address, title: string)
                fillImageView(searchText: searchText)
            }
            titleLabel.text = string
            descTitleLabel.text = "\(string) 이야기"
            
        case "firstimage":
            thumbnailImageView.setImage(with: string)
            isImageLoad = true
            
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
            appendText(on: telTextView, string: string)
            
        case "restdate":
            appendText(on: restDateLabel, string: string)
            
        case "usetime":
            appendText(on: useTimeLabel, string: string)
            
        case "parking":
            appendText(on: parkingLabel, string: string)
            
        case "chkpet":
            if string != "없음" {
                petLabel.textColor = UIColor.black
                petLabel.text = string
            }
            
        case "infoname":
            infoName = string
            
        case "infotext":
            if infoName == "화장실" {
                toiletLabel.textColor = UIColor.black
                toiletLabel.text = string
            }
            
        case "mapx":
            mapX = string
            
        case "mapy":
            mapY = string
            nearSightVC?.sendMapData(mapX: mapX, mapY: mapY)
            addMapView()
            
        case "overview":
            appendText(on: descTextView, string: string)
            
        default:
            break
        }
    }

}
