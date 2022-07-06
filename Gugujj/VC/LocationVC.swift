//
//  ViewController.swift
//  Gugujj
//
//  Created by Seonju Kim on 2022/05/23.
//

import UIKit

class LocationVC: UIViewController {
    
    // MARK: - Properties
    let pickerView: UIPickerView = UIPickerView()
    var focusedRow: Int = 0
    var selectedRow: Int = 0
    var selectedLocation: String = "전국"
    var selectedAreaCode: String? = nil
    var selectedArrange: String = "B"
    
    var currentElement: String = ""
    var currentPage: String = "1"
    
    var temple: Temple = Temple(id: 0, title: "")
    var temples: [Temple] = [Temple]()
    var templeTotalCount: Int = 0
    var isResetTemple: Bool = false

    // MARK: IBOutlets
    @IBOutlet weak var locationText: UIButton!
    @IBOutlet weak var arrangeButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var scrollUpButton: UIButton!
    
    // MARK: - IBActions
    @IBAction func touchUpAreaButton(_ sender: UIButton) {
        pickerView.frame = CGRect(x: 0, y: 50, width: 270, height: 130)
        pickerView.delegate = self
        pickerView.dataSource = self
        
        let alert = UIAlertController(title: "지역 선택", message: "\n\n\n\n\n\n\n\n", preferredStyle: .alert)
        alert.view.addSubview(pickerView)
        alert.addAction(UIAlertAction(title: "취소", style: .cancel) { _ in
            self.pickerView.selectRow(self.selectedRow, inComponent: 0, animated: true)
        })
        alert.addAction(UIAlertAction(title: "확인", style: .default) { _ in
            self.currentPage = "1"
            
            self.selectedRow = self.focusedRow
            self.selectedLocation = Location.allCases[self.selectedRow].rawValue
            self.selectedAreaCode = Location.allCases[self.selectedRow].code
            self.locationText.setTitle(self.selectedLocation, for: .normal)
            
            self.temples = [Temple]()
            self.isResetTemple = true
            self.loadData()
        })
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func touchUpScrollUpButton(_ sender: UIButton) {
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }
        
    @IBAction func touchUpSearchButton(_ sender: UIButton) {
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
        setArrangeFilter()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "RectangleCell", bundle: nil), forCellReuseIdentifier: "templeRectangleCell")
        
        scrollUpButton.isHidden = true
        loadData()
    }
    
    // MARK: - Privates
    private func loadData() {
        CustomLoading.show()
        CommonHttp.getAreaBasedList(areaCode: selectedAreaCode, pageNo: currentPage, arrange: selectedArrange) { data in
            guard let xmlData = data else { // 통신 오류시
                DispatchQueue.main.async {
                    CustomLoading.hide()
                    self.showErrorAlert()
                }
                return
            }
            let parser = XMLParser(data: xmlData)
            parser.delegate = self
            parser.parse()
            DispatchQueue.main.async {
                self.tableView.reloadData()
                if self.isResetTemple {
                    self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
                    self.isResetTemple = false
                }
                CustomLoading.hide()
            }
        }
    }
    
    private func setArrangeFilter() {
        let arrangeByTitle = UIAction(title: "이름순") { _ in
            self.selectedArrange = "A"
            self.currentPage = "1"
            self.temples = [Temple]()
            self.isResetTemple = true
            self.loadData()
        }
        let arrangeByReadCount = UIAction(title: "인기순") { _ in
            self.selectedArrange = "B"
            self.currentPage = "1"
            self.temples = [Temple]()
            self.isResetTemple = true
            self.loadData()
        }
        arrangeButton.menu = UIMenu(title: "정렬 기준", children: [arrangeByTitle, arrangeByReadCount])
        arrangeButton.showsMenuAsPrimaryAction = true
    }
    
    private func changeScrollUpButtonState(row: Int) {
        if row > 5 && scrollUpButton.isHidden {
            scrollUpButton.setHiddenAnimation(hiddenFlag: false)
        } else if row == 0 {
            scrollUpButton.setHiddenAnimation(hiddenFlag: true)
        }
    }
    
    private func showErrorAlert() {
        let action: UIAlertAction = UIAlertAction(title: "확인", style: .default)
        let alert: UIAlertController = UIAlertController(title: "알림", message: "오류가 발생했습니다. 다시 시도해주세요.", preferredStyle: .alert)
        alert.addAction(action)
        self.present(alert, animated: true)
    }
    
}

// MARK: - XMLParser
extension LocationVC: XMLParserDelegate {
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        if (elementName == "item") {
            temple = Temple(id: 0, title: "")
        }
    }

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

    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if (elementName == "item") {
            temples.append(temple)
        }
    }
}

// MARK: - PickerView
extension LocationVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
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
        focusedRow = row
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat
    {
        return 30
    }
    
}

// MARK: - TableView
extension LocationVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return temples.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        changeScrollUpButtonState(row: indexPath.row)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "templeRectangleCell", for: indexPath) as! RectangleCell
        let temple = temples[indexPath.row]
        cell.configure(temple: temple, tableView: tableView, indexPath: indexPath)
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.clear
        cell.selectedBackgroundView = backgroundView
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        CustomLoading.show()
        CommonNavi.pushVC(sbName: "Main", vcName: "TempleVC")
        TempleVC.contentId = temples[indexPath.row].id
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == temples.count && temples.count < templeTotalCount {
            currentPage = "\(Int(currentPage)! + 1)"
            loadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? RectangleCell {
            let pressDownTransform = CGAffineTransform(scaleX: 0.98, y: 0.98)
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 3, options: [.curveEaseOut], animations: { cell.transform = pressDownTransform })
        }
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? RectangleCell {
            let originalTransform = CGAffineTransform(scaleX: 1, y: 1)
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 3, options: [.curveEaseInOut], animations: { cell.transform = originalTransform })
        }
    }
}
