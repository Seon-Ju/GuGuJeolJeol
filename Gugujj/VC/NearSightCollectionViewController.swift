//
//  NearSightCollectionViewController.swift
//  Gugujj
//
//  Created by 김선주 on 2022/06/05.
//

import UIKit

class NearSightCollectionViewController: UICollectionViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView.register(UINib(nibName: "SquareCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "templeSquareCell")
    }

}

// MARK: - CollectionView
extension NearSightCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "templeSquareCell", for: indexPath) as! SquareCollectionViewCell
        return cell
    }
}
