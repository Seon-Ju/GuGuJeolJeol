//
//  ViewController.swift
//  Gugujj
//
//  Created by Seonju Kim on 2022/05/23.
//

import UIKit

class LocationViewController: UIViewController {
    
    // MARK: - Properties
    let location = ["서울", "인천", "대전", "대구", "광주", "부산", "울산", "세종", "경기도", "강원도", "충청북도", "충청남도", "경상북도", "경상남도", "전라북도", "전라남도", "제주도"]
    let pickerView = UIPickerView()
    var selectedLocation = ""

    // MARK: IBOutlets
    @IBOutlet weak var locationText: UIButton!
    @IBOutlet weak var searchBar: UIView!
    @IBOutlet weak var templeTableView: UITableView!
    
    // MARK: - IBActions
    @IBAction func touchUpAreaBtn(_ sender: UIButton) {
        let alert = UIAlertController(title: "지역 선택", message: "\n\n\n\n\n\n\n\n", preferredStyle: .alert)
            
        pickerView.frame = CGRect(x: 0, y: 50, width: 270, height: 130)
        pickerView.delegate = self
        pickerView.dataSource = self
        alert.view.addSubview(pickerView)
            
        alert.addAction(UIAlertAction(title: "확인", style: .default) { _ in
            self.locationText.setTitle(self.selectedLocation, for: .normal)
        })
                            
        self.present(alert, animated: true, completion: nil)
    }
        
    @IBAction func touchUpSearchBtn(_ sender: UIButton) {
        CommonNavi.pushVC(sbName: "Main", vcName: "SearchVC")
    }
        
    @IBAction func touchUpUserBtn(_ sender: UIButton) {
        CommonNavi.pushVC(sbName: "Main", vcName: "UserVC")
    }

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.navigationController = self.navigationController
        }
        
        locationText.setTitle("서울", for: .normal)
        
        searchBar.layer.cornerRadius = 20
        
        templeTableView.delegate = self
        templeTableView.dataSource = self
        templeTableView.register(UINib(nibName: "RectangleTableViewCell", bundle: nil), forCellReuseIdentifier: "templeRectangleCell")
        
        CommonHttp.getDetailIntro()
    }

}

// MARK: - PickerView
extension LocationViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return location.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return location[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedLocation = location[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat
    {
        return 30
    }
    
}

// MARK: - TableView
extension LocationViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "templeRectangleCell", for: indexPath)
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.clear
        cell.selectedBackgroundView = backgroundView
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
        CommonNavi.pushVC(sbName: "Main", vcName: "TempleVC")
    }
    
}
