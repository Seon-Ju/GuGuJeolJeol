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
        
        downloadJSONData() { allTemples in
            self.classifyTemplesByCategory(allTemples: allTemples)
        }
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
            } else if temple.creditcard == 1 {
                availableCreditCardTemples.append(temple)
            } else if temple.pet == 1 {
                availablePetTemples.append(temple)
            } else if temple.heritage == 1 {
                isHeritageTemples.append(temple)
            }
        }

        print(availableCreditCardTemples)
    }
    
}
