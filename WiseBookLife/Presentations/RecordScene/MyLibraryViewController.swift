//
//  RecordViewController.swift
//  WiseBookLife
//
//  Created by 서보경 on 2020/06/22.
//  Copyright © 2020 서보경. All rights reserved.
//

import UIKit

class MyLibraryViewController: UIViewController {

    @IBOutlet weak var recordView: UICollectionView!
    @IBOutlet weak var emptyRecordView: UIView!
    
    var myBooks: [BookInfoLocalDTO] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingEmptyRecordView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setLibraryListData()
        refreshLibraryView()
    }
    
    func settingEmptyRecordView() {
        emptyRecordView.alpha = 1
    }
    
    func setLibraryListData() {
        myBooks = getThumbnailList()
    }
    
    func reloadEmptyView() {
        if myBooks.count > 0 {
            emptyRecordView.isHidden = true
        } else {
            emptyRecordView.isHidden = false
        }
    }
    
    // MARK:- Unwind Segue
    
    @IBAction func unwindToRecordList(sender: UIStoryboardSegue) {
        if let selected = self.recordView.indexPathsForSelectedItems {
            if selected.count != 0 {
                let willDeleteISBN = myBooks[selected[0].item].isbn
                let deleteItems = DatabaseManager.shared.loadRecords().filter { $0.isbn == willDeleteISBN }
                DatabaseManager.shared.deleteRecord(Array(deleteItems))
            }
            self.recordView.reloadData()
        }
        
        
    }
    
    @IBAction func unwindToRecord(sender: UIStoryboardSegue) {
        guard let addVC = sender.source as? AddBookViewController else {
            return
        }
        DatabaseManager.shared.addRecordToDB(addVC.newRecordContent, addVC.selectedBookInfo)
        self.refreshLibraryView()
    }
}


// MARK:- Extensions

extension MyLibraryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = UIScreen.main.bounds.width/3 - 25
        let height: CGFloat = width*40/27
        return CGSize(width: width, height: height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
}

extension MyLibraryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myBooks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = recordView.dequeueReusableCell(withReuseIdentifier: "recordCell", for: indexPath) as! RecordCell
        let imagePath = myBooks[indexPath.row].image
        Task {
            cell.bookImage.image = await ImageDownloader.urlToImage(from: imagePath)
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailRecVC = UIStoryboard(name: "DetailRecVC", bundle: nil).instantiateViewController(withIdentifier: "detailRecVC") as! DetailRecViewController
        
        detailRecVC.selectedISBN = myBooks[indexPath.row].isbn
        self.navigationController?.pushViewController(detailRecVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
    }
    
}

extension MyLibraryViewController {
    // MARK: Refresh View
    func refreshLibraryView() {
        recordView.reloadData()
        reloadEmptyView()
    }
}

extension MyLibraryViewController {
    // MARK: DatabaseManager
    
    func getThumbnailList() -> [BookInfoLocalDTO] {
        // 아카이빙 되어 있는 책 정보
        let loaded = DatabaseManager.shared.loadRecords().distinct(by: ["isbn"]).map{ $0.isbn }
        var list: [BookInfoLocalDTO] = []
        for isbn_item in loaded {
            guard let bookinfo = DatabaseManager.shared.findBookInfo(isbn: isbn_item) else { continue }
            list.append(bookinfo)
        }
        return list
    }
}
