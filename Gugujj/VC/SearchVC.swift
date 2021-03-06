//
//  SearchViewController.swift
//  Gugujj
//
//  Created by Seonju Kim on 2022/05/23.
//

import UIKit
import FirebaseStorage

class SearchVC: BaseVC {

    // MARK: - Properties
    private let storage: Storage = Storage.storage()
    private let storagePath: String = "gs://gugujeoljeol-6f201.appspot.com/templeJSONData.json"
    
    private var allTemples: [Temple] = [Temple]()
    private var searchResultTemples: [Temple] = [Temple]()
    private var availableParkingTemples: [Temple] = [Temple]()
    private var availablePetTemples: [Temple] = [Temple]()
    private var isHeritageTemples: [Temple] = [Temple]()
    
    private let userDefaults: UserDefaults = UserDefaults.standard
    
    // MARK: - IBOutlets
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBAction func touchUpBackButton(_ sender: UIButton) {
        CommonNavi.popVC()
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.navigationController = self.navigationController
        }
        
        searchTextField.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isSwipedFlag = false
        
        if let data = userDefaults.value(forKey: "Temples") as? Data {
            allTemples = try! PropertyListDecoder().decode([Temple].self, from: data)
            classifyTemplesByCategory()
        } else {
            downloadJSONData()
        }
    }
    
    // MARK: - IBActions
    @IBAction func touchUpSearchButton(_ sender: UIButton) {
        loadSearchResult()
        searchTextField.resignFirstResponder()
    }
    
    @IBAction func touchUpCategoryButton(_ sender: UIButton) {
        switch sender.restorationIdentifier {
        case "parkingButton":
            SearchResultVC.temples = availableParkingTemples
        case "petButton":
            SearchResultVC.temples = availablePetTemples
        case "heritageButton":
            SearchResultVC.temples = isHeritageTemples
        default:
            break
        }
        CommonNavi.pushVC(sbName: "Main", vcName: "SearchResultVC")
    }
    
    // MARK: - Privates
    private func loadSearchResult() {
        guard let searchText = searchTextField.text, searchText.count != 0 else {
            showAlert(title: "?????? ??????", message: "???????????? ??????????????????.")
            return
        }
        
        searchResultTemples.removeAll()
        allTemples.forEach { temple in
            if temple.title.contains(searchText) {
                searchResultTemples.append(temple)
            } else if let addr1 = temple.addr1, addr1.contains(searchText) {
                searchResultTemples.append(temple)
            }
        }
        
        if !searchResultTemples.isEmpty {
            SearchResultVC.temples = searchResultTemples
            CommonNavi.pushVC(sbName: "Main", vcName: "SearchResultVC")
        } else {
            showAlert(title: "?????? ??????", message: "??????????????? ????????????.")
        }
    }
    
    private func downloadJSONData() {
        storage.reference(forURL: storagePath).downloadURL { url, error in
            let data = NSData(contentsOf: url!)! as Data
            do {
                self.allTemples = try JSONDecoder().decode([Temple].self, from: data)
                self.userDefaults.setValue(try? PropertyListEncoder().encode(self.allTemples), forKey: "Temples")
                self.classifyTemplesByCategory()
            } catch {
                print("decodeError: \(error)")
                self.showAlert(title: "?????? ??????", message: "????????? ??????????????????. ?????? ??????????????????.")
            }
        }
    }
    
    private func classifyTemplesByCategory() {
        availableParkingTemples = allTemples.filter { temple in
            temple.parking == 1
        }
        availablePetTemples = allTemples.filter { temple in
            temple.pet == 1
        }
        isHeritageTemples = allTemples.filter { temple in
            temple.heritage == 1
        }
        CustomLoading.hide()
        print("\(allTemples.count)??? ?????? ??? ?????? ??????")
    }
    
    private func showAlert(title: String, message: String) {
        let sb = UIStoryboard.init(name: "Main", bundle: nil)
        guard let popupVC = sb.instantiateViewController(withIdentifier: "PopupVC") as? PopupVC else {
            return
        }
        popupVC.popupTitle = title
        popupVC.popupMessage = message
        popupVC.modalPresentationStyle = .overFullScreen
        present(popupVC, animated: false, completion: nil)
    }
    
}

extension SearchVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == searchTextField {
            loadSearchResult()
        }
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
