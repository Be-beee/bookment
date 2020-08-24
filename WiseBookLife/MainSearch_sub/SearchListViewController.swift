//
//  SearchListViewController.swift
//  WiseBookLife
//
//  Created by 서보경 on 2020/08/19.
//  Copyright © 2020 서보경. All rights reserved.
//

import UIKit

class SearchListViewController: UIViewController {

    @IBOutlet var conditionView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    
}


// MARK:- Extensions/Cell Button Action Method
extension SearchListViewController {
    @objc func searchWithCondition(_ sender: UIButton!) {
//        conditionList[sender.tag]
//        선택된 셀의 검색 조건을 DetailSearchViewController로 보낸 후 (여기서 수행)
//        DetailSearchViewContoller에서 MainSearchResultViewController로 이동 (DetailSearchViewController의 unwind에서 수행)
        self.dismiss(animated: true, completion: nil)
    }
}
