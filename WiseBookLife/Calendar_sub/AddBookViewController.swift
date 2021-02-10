//
//  AddBookViewController.swift
//  WiseBookLife
//
//  Created by 서보경 on 2021/02/10.
//  Copyright © 2021 서보경. All rights reserved.
//

import UIKit

class AddBookViewController: UIViewController {

    var booklist: [BookItem] = []
    @IBOutlet weak var todayBookTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        todayBookTableView.register(UINib(nibName: "CommonCell", bundle: nil), forCellReuseIdentifier: "commonCell")
    }
    
    @IBAction func addBook(_ sender: Any) {
        print("add book")
    }
    
    
}

extension AddBookViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 135
    }
}
extension AddBookViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return booklist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = todayBookTableView.dequeueReusableCell(withIdentifier: "commonCell") as? CommonCell else { return UITableViewCell() }
        let item = booklist[indexPath.row]
        cell.bookCover.image = urlToImage(from: item.image)
        cell.titleLabel.text = item.title
        cell.authorLabel.text = item.author
        
        
        return cell
    }
    
    
}
