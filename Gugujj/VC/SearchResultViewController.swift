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
    @IBOutlet weak var scrollUpButton: UIButton!
    
    @IBAction func touchUpBackButton(_ sender: Any) {
        CommonNavi.popVC()
    }
    
    @IBAction func touchUpScrollUpButton(_ sender: UIButton) {
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("사찰 수: \(SearchResultViewController.temples.count)")
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "RectangleTableViewCell", bundle: nil), forCellReuseIdentifier: "templeRectangleCell")
        
        scrollUpButton.isHidden = true
    }
    
    private func changeScrollUpButtonState(row: Int) {
        if row > 5 && scrollUpButton.isHidden {
            scrollUpButton.setHiddenAnimation(hiddenFlag: false)
        } else if row == 0 {
            scrollUpButton.setHiddenAnimation(hiddenFlag: true)
        }
    }
}

extension SearchResultViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SearchResultViewController.temples.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        changeScrollUpButtonState(row: indexPath.row)
        
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
