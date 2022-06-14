//
//  ViewController.swift
//  Gugujj
//
//  Created by Seonju Kim on 2022/05/23.
//

import UIKit

class LocationViewController: UIViewController {
    
    // MARK: - Properties
    let pickerView: UIPickerView = UIPickerView()
    var selectedLocation: String = "전국"
    var selectedAreaCode: String? = nil
    var selectedArrange: String = "B"
    
    var currentElement: String = ""
    var currentPage: String = "1"
    
    var temple: Temple = Temple(id: 0, title: "")
    var templeList: [Temple] = [Temple]()
    var templeTotalCount: Int = 0
    var templeCurrentCount: Int = 0

    // MARK: IBOutlets
    @IBOutlet weak var locationText: UIButton!
    @IBOutlet weak var arrangeButton: UIButton!
    @IBOutlet weak var templeTableView: UITableView!
    @IBOutlet weak var goUpButton: UIButton!
    
    // MARK: - IBActions
    @IBAction func touchUpAreaBtn(_ sender: UIButton) {
        let alert = UIAlertController(title: "지역 선택", message: "\n\n\n\n\n\n\n\n", preferredStyle: .alert)
            
        pickerView.frame = CGRect(x: 0, y: 50, width: 270, height: 130)
        pickerView.delegate = self
        pickerView.dataSource = self
        alert.view.addSubview(pickerView)
            
        alert.addAction(UIAlertAction(title: "확인", style: .default) { _ in
            self.currentPage = "1"
            
            self.locationText.setTitle(self.selectedLocation, for: .normal)
            self.selectedAreaCode = Location(rawValue: self.selectedLocation)?.code
            
            self.templeList = [Temple]()
            self.templeCurrentCount = 0
            self.loadData()
        })
                            
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func touchUpGoUpButton(_ sender: UIButton) {
        templeTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }
        
    @IBAction func touchUpSearchBtn(_ sender: UIButton) {
        CustomLoading.show()
        CommonNavi.pushVC(sbName: "Main", vcName: "SearchVC")
    }

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.navigationController = self.navigationController
        }
        
        locationText.setTitle("전국", for: .normal)
        
        let arrangeByTitle = UIAction(title: "이름순") { _ in
            self.selectedArrange = "A"
            self.currentPage = "1"
            self.templeList = [Temple]()
            self.loadData()
        }
        let arrangeByReadCount = UIAction(title: "조회순") { _ in
            self.selectedArrange = "B"
            self.currentPage = "1"
            self.templeList = [Temple]()
            self.loadData()
        }
        arrangeButton.menu = UIMenu(title: "정렬 기준", children: [arrangeByTitle, arrangeByReadCount])
        arrangeButton.showsMenuAsPrimaryAction = true
        
        templeTableView.delegate = self
        templeTableView.dataSource = self
        templeTableView.register(UINib(nibName: "RectangleTableViewCell", bundle: nil), forCellReuseIdentifier: "templeRectangleCell")
        
        goUpButton.isHidden = true
        
        loadData()
    }
    
    // MARK: - Privates
    private func loadData() {
        CustomLoading.show()
        CommonHttp.getAreaBasedList(areaCode: selectedAreaCode, pageNo: currentPage, arrange: selectedArrange) { xmlData in
            let parser = XMLParser(data: xmlData)
            parser.delegate = self
            parser.parse()
            DispatchQueue.main.async {
                self.templeTableView.reloadData()
                CustomLoading.hide()
            }
        }
    }
    
}

// MARK: - XMLParser
extension LocationViewController: XMLParserDelegate {
    
    // parser가 시작 태그를 만나면 호출 Ex) <name>
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        if (elementName == "item") {
            temple = Temple(id: 0, title: "")
        }
    }

    // 현재 태그에 담겨있는 string이 전달됨
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        switch currentElement {
        case "contentid":
            temple.id = Int(string)!
        case "title":
            temple.title = string
        case "addr1":
            temple.addr1 = string
        case "addr2":
            if temple.addr2 != nil {
                temple.addr2! += string
            } else {
                temple.addr2 = string
            }
        case "areacode":
            temple.areacode = Int(string)
        case "firstimage":
            temple.imageUrl = string
        case "readcount":
            temple.readcount = Int(string)
        case "totalCount":
            templeTotalCount = Int(string)!
        default:
            break
        }
    }

    // parser가 종료 태그를 만나면 호출 Ex) </name>
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if (elementName == "item") {
            templeList.append(temple)
            templeCurrentCount += 1
        }
    }
}

// MARK: - PickerView
extension LocationViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Location.totalCount
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let locations: [Location] = Location.allCases
        let location: Location = locations[row]
        
        return location.rawValue
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let locations: [Location] = Location.allCases
        let location: Location = locations[row]
        
        selectedLocation = location.rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat
    {
        return 30
    }
    
}

// MARK: - TableView
extension LocationViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.templeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "templeRectangleCell", for: indexPath) as! RectangleTableViewCell
        let temple = templeList[indexPath.row]
        
        cell.configure(temple: temple, tableView: self.templeTableView, indexPath: indexPath)
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.clear
        cell.selectedBackgroundView = backgroundView
        
        if indexPath.row > 5 && goUpButton.isHidden {
            goUpButton.setHiddenAnimation(hiddenFlag: false)
        } else if indexPath.row == 0 {
            goUpButton.setHiddenAnimation(hiddenFlag: true)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        CustomLoading.show()
        CommonNavi.pushVC(sbName: "Main", vcName: "TempleVC")
        TempleViewController.contentId = templeList[indexPath.row].id
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == templeList.count && templeCurrentCount < templeTotalCount {
            currentPage = "\(Int(currentPage)! + 1)"
            loadData()
        }
    }
    
}
