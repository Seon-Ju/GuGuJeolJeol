//
//  NearSightCollectionViewController.swift
//  Gugujj
//
//  Created by 김선주 on 2022/06/05.
//

import UIKit

class NearSightCollectionViewController: UICollectionViewController {
    
    private var nearSight: NearSight?
    private var nearSights: [NearSight] = [NearSight]()
    private var currentElement: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView.register(UINib(nibName: "SquareCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "nearSightCell")
    }
    
    func sendMapData(mapX: String, mapY: String) {
        CommonHttp.getLocationBasedList(pageNo: "1", mapX: mapX, mapY: mapY) { data in
            guard let xmlData = data else { // 통신 오류시
                DispatchQueue.main.async {
                    CustomLoading.hide()
                    self.showErrorAlert()
                }
                return
            }
            self.parseData(data: xmlData)
        }
    }
    
    // MARK: - Privates
    private func parseData(data: Data) {
        let parser = XMLParser(data: data)
        parser.delegate = self
        DispatchQueue.main.async {
            parser.parse()
            self.nearSights.removeFirst()
            self.collectionView.reloadData()
        }
    }
    
    private func showErrorAlert() {
        let action: UIAlertAction = UIAlertAction(title: "확인", style: .default)
        let alert: UIAlertController = UIAlertController(title: "알림", message: "오류가 발생했습니다. 다시 시도해주세요.", preferredStyle: .alert)
        alert.addAction(action)
        self.present(alert, animated: true)
    }

}

// MARK: - CollectionView
extension NearSightCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.nearSights.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "nearSightCell", for: indexPath) as! SquareCollectionViewCell
        
        cell.configure(nearSights: self.nearSights, collectionView: self.collectionView, indexPath: indexPath)
        
        return cell
    }
}

// MARK: - XMLParser
extension NearSightCollectionViewController: XMLParserDelegate {
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        if (elementName == "item") {
            nearSight = NearSight(title: "", dist: "")
        }
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        switch currentElement {
        case "title":
            nearSight?.title = string
        case "dist":
            let dist: Int = Int(string)!
            if dist >= 1000 {
                nearSight?.dist = "\(dist/1000).\(dist%1000)km"
            } else {
                nearSight?.dist = "\(dist)m"
            }
        case "firstimage":
            nearSight?.imageURL = string
        default:
            break
        }
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if (elementName == "item") {
            nearSights.append(nearSight!)
        }
    }
}
