//
//  SearchResultViewController.swift
//  Gugujj
//
//  Created by Seonju Kim on 2022/06/08.
//

import UIKit

class SearchResultViewController: BaseViewController {
    
    static var temples: [Temple] = [Temple]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("사찰 수: \(SearchResultViewController.temples.count)")
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "RectangleTableViewCell", bundle: nil), forCellReuseIdentifier: "templeRectangleCell")
    }
    
}

extension SearchResultViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SearchResultViewController.temples.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "templeRectangleCell", for: indexPath) as! RectangleTableViewCell
        let temple = SearchResultViewController.temples[indexPath.row]
        
        cell.configure(temple: temple, tableView: self.tableView, indexPath: indexPath)
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.clear
        cell.selectedBackgroundView = backgroundView

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        CustomLoading.show()
        CommonNavi.pushVC(sbName: "Main", vcName: "TempleVC")
        TempleViewController.contentId = SearchResultViewController.temples[indexPath.row].id
    }
}
