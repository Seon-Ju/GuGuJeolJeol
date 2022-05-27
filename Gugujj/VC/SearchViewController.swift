//
//  SearchViewController.swift
//  Gugujj
//
//  Created by Seonju Kim on 2022/05/23.
//

import UIKit

class SearchViewController: UIViewController {

    // MARK: - Properties
    var isSwipedFlag: Bool = false
    
    // MARK: IBOutlets
    @IBOutlet weak var templeTableView: UITableView!
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

        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.navigationController = self.navigationController
        }
        
        screenEdgePanGesture.edges = .left
        
        templeTableView.delegate = self
        templeTableView.dataSource = self
        templeTableView.register(UINib(nibName: "RectangleTableViewCell", bundle: nil), forCellReuseIdentifier: "templeRectangleCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isSwipedFlag = false
    }
    
}

// MARK: - TableView
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
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
