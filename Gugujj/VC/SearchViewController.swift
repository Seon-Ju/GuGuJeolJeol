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
    
    private var availableParkingTemples: [Temple] = [Temple]()
    private var availableCreditCardTemples: [Temple] = [Temple]()
    private var availablePetTemples: [Temple] = [Temple]()
    private var isHeritageTemples: [Temple] = [Temple]()
    
    private var isLoadedJSONData: Bool = false
    
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
            downloadJSONData() { allTemples in
                self.classifyTemplesByCategory(allTemples: allTemples)
            }
        }
    }
    
    // MARK: - IBActions
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
    private func downloadJSONData(completion: @escaping ([Temple]) -> Void) {
        storage.reference(forURL: storagePath).downloadURL { url, error in
            let data = NSData(contentsOf: url!)! as Data
            var allTemples = [Temple]()
            do {
                allTemples = try JSONDecoder().decode([Temple].self, from: data)
                completion(allTemples)
            } catch {
                print("decodeError: \(error)")
            }
        }
    }
    
    private func classifyTemplesByCategory(allTemples: [Temple]) {
        for temple in allTemples {
            if temple.parking == 1 {
                availableParkingTemples.append(temple)
            }
            if temple.creditcard == 1 {
                availableCreditCardTemples.append(temple)
            }
            if temple.pet == 1 {
                availablePetTemples.append(temple)
            }
            if temple.heritage == 1 {
                isHeritageTemples.append(temple)
            }
        }
        isLoadedJSONData = true
        print("\(allTemples.count)개 로딩 및 분류 완료")
    }
    
}
