//
//  SearchViewController.swift
//  Gugujj
//
//  Created by Seonju Kim on 2022/05/23.
//

import UIKit
import FirebaseStorage

class SearchViewController: BaseViewController {

    // MARK: - Properties
    private let storage: Storage = Storage.storage()
    private let storagePath: String = "gs://gugujeoljeol-6f201.appspot.com/templeJSONData.json"
    
    private var allTemples: [Temple] = [Temple]()
    private var searchResultTemples: [Temple] = [Temple]()
    private var availableParkingTemples: [Temple] = [Temple]()
    private var availableCreditCardTemples: [Temple] = [Temple]()
    private var availablePetTemples: [Temple] = [Temple]()
    private var isHeritageTemples: [Temple] = [Temple]()
    
    private var isLoadedJSONData: Bool = false
    
    // MARK: - IBOutlets
    @IBOutlet weak var searchTextField: UITextField!
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.navigationController = self.navigationController
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isSwipedFlag = false
        
        if !isLoadedJSONData {
            downloadJSONData() {
                self.classifyTemplesByCategory()
            }
        }
    }
    
    // MARK: - IBActions
    @IBAction func touchUpSearchButton(_ sender: UIButton) {
        searchResultTemples.removeAll()
        
        guard let searchText = searchTextField.text, searchText.count != 0 else {
            showAlert(message: "검색어를 입력해주세요.")
            return
        }
        
        searchResultTemples = allTemples.filter { temple in
            temple.title.contains(searchText)
        }
        
        if !searchResultTemples.isEmpty {
            SearchResultViewController.temples = searchResultTemples
            CommonNavi.pushVC(sbName: "Main", vcName: "SearchResultVC")
        } else {
            showAlert(message: "검색결과가 없습니다.")
        }
    }
    
    @IBAction func touchUpCategoryButton(_ sender: UIButton) {
        switch sender.restorationIdentifier {
        case "parkingButton":
            SearchResultViewController.temples = availableParkingTemples
        case "creditCardButton":
            SearchResultViewController.temples = availableCreditCardTemples
        case "petButton":
            SearchResultViewController.temples = availablePetTemples
        case "heritageButton":
            SearchResultViewController.temples = isHeritageTemples
        default:
            break
        }
        CommonNavi.pushVC(sbName: "Main", vcName: "SearchResultVC")
    }
    
    // MARK: - Privates
    private func downloadJSONData(completion: @escaping () -> Void) {
        storage.reference(forURL: storagePath).downloadURL { url, error in
            let data = NSData(contentsOf: url!)! as Data
            do {
                self.allTemples = try JSONDecoder().decode([Temple].self, from: data)
                completion()
            } catch {
                print("decodeError: \(error)")
            }
        }
    }
    
    private func classifyTemplesByCategory() {
        availableParkingTemples = allTemples.filter { temple in
            temple.parking == 1
        }
        availableCreditCardTemples = allTemples.filter { temple in
            temple.creditcard == 1
        }
        availablePetTemples = allTemples.filter { temple in
            temple.pet == 1
        }
        isHeritageTemples = allTemples.filter { temple in
            temple.heritage == 1
        }
        isLoadedJSONData = true
        print("\(allTemples.count)개 로딩 및 분류 완료")
    }
    
    private func showAlert(message: String) {
        let action: UIAlertAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        let alert: UIAlertController = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}
