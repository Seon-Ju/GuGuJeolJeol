//
//  UserViewController.swift
//  Gugujj
//
//  Created by Seonju Kim on 2022/05/23.
//

import UIKit

class UserViewController: UIViewController {
    
    // MARK: - Properties
    var isSwipedFlag: Bool = false
    
    // MARK: IBOutlets
    @IBOutlet weak var starredCollectionView: UICollectionView!
    @IBOutlet weak var recentCollectionView: UICollectionView!
    @IBOutlet var screenEdgePanGesture: UIScreenEdgePanGestureRecognizer!
    
    // MARK: - IBActions
    @IBAction func executeScreenEdgePanGesture(_ sender: UIScreenEdgePanGestureRecognizer) {
        if !isSwipedFlag {
            CommonNavi.popVC()
            isSwipedFlag = true
        }
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        screenEdgePanGesture.edges = .left

        starredCollectionView.delegate = self
        starredCollectionView.dataSource = self
        starredCollectionView.register(UINib(nibName: "SquareCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "templeCell")
        
        recentCollectionView.delegate = self
        recentCollectionView.dataSource = self
        recentCollectionView.register(UINib(nibName: "SquareCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "templeCell")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isSwipedFlag = false
    }
    
}

// MARK: - CollectionView
extension UserViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "templeCell", for: indexPath)
        return cell
    }
    
}

