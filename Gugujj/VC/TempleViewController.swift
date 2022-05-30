//
//  TempleViewController.swift
//  Gugujj
//
//  Created by Seonju Kim on 2022/05/24.
//

import UIKit

class TempleViewController: BaseViewController {

    // MARK: - Properties
    
    // MARK: IBOutlets
    @IBOutlet var nearSightCollectionView: UICollectionView!

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = true
        
        nearSightCollectionView.delegate = self
        nearSightCollectionView.dataSource = self
        nearSightCollectionView.register(UINib(nibName: "SquareCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "templeSquareCell")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isSwipedFlag = false
    }
    
}

// MARK: - CollectionView
extension TempleViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "templeSquareCell", for: indexPath)
        return cell
    }
    
}
