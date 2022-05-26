//
//  SearchViewController.swift
//  Gugujj
//
//  Created by Seonju Kim on 2022/05/23.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var templeTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.navigationController = self.navigationController
        }
        
        templeTableView.delegate = self
        templeTableView.dataSource = self
        templeTableView.register(UINib(nibName: "RectangleTableViewCell", bundle: nil), forCellReuseIdentifier: "templeRectangleCell")
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
