//
//  SearchListViewController.swift
//  WiseBookLife
//
//  Created by 서보경 on 2020/08/19.
//  Copyright © 2020 서보경. All rights reserved.
//

import UIKit

class SearchListViewController: UIViewController {

    var selected = SearchConditionModel()
    @IBOutlet var conditionView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        if let loadedData = loadData(at: "conditions") {
            conditionList = loadedData as! [SearchConditionModel]
        }
    }
    @IBAction func dismissList(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
// MARK:- Extesions/TableView
extension SearchListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
extension SearchListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conditionList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = conditionView.dequeueReusableCell(withIdentifier: "conditionCell", for: indexPath) as! ConditionCell
        
        cell.conditionTitle.text = conditionList[indexPath.row].conditionTitle
        
        cell.searchBtn.tag = indexPath.row
        cell.searchBtn.addTarget(self, action: #selector(searchWithCondition), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            conditionList.remove(at: indexPath.row)
            conditionView.deleteRows(at: [indexPath], with: .automatic)
//            saveData(data: conditionList, at: "conditions")
        }
    }
    
}


// MARK:- Extensions/Cell Button Action Method
extension SearchListViewController {
    @objc func searchWithCondition(_ sender: UIButton!) {
        selected = conditionList[sender.tag]
        self.performSegue(withIdentifier: "toDetailSearch", sender: self)
    }
}
