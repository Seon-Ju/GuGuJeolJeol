//
//  SearchResultViewController.swift
//  Gugujj
//
//  Created by Seonju Kim on 2022/06/08.
//

import UIKit

class SearchResultVC: BaseVC {
    
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

        print("사찰 수: \(SearchResultVC.temples.count)")
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "RectangleCell", bundle: nil), forCellReuseIdentifier: "templeRectangleCell")
        
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

extension SearchResultVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SearchResultVC.temples.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        changeScrollUpButtonState(row: indexPath.row)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "templeRectangleCell", for: indexPath) as! RectangleCell
        let temple = SearchResultVC.temples[indexPath.row]
        cell.configure(temple: temple, tableView: self.tableView, indexPath: indexPath)
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.clear
        cell.selectedBackgroundView = backgroundView
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        CustomLoading.show()
        CommonNavi.pushVC(sbName: "Main", vcName: "TempleVC")
        TempleVC.contentId = SearchResultVC.temples[indexPath.row].id
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? RectangleCell {
            let pressDownTransform = CGAffineTransform(scaleX: 0.98, y: 0.98)
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 3, options: [.curveEaseOut], animations: { cell.transform = pressDownTransform })
        }
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? RectangleCell {
            let originalTransform = CGAffineTransform(scaleX: 1, y: 1)
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 3, options: [.curveEaseInOut], animations: { cell.transform = originalTransform })
        }
    }
}
