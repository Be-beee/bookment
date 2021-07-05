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
    
    var libraryListData: [BookItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingEmptyRecordView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadEmptyView()
        setLibraryListData()
    }
    
    func settingEmptyRecordView() {
        emptyRecordView.alpha = 1
    }
    
    func setLibraryListData() {
        libraryListData = CommonData.shared.createMyLibraryList()
    }
    
    func reloadEmptyView() {
        if CommonData.shared.records.count > 0 {
            emptyRecordView.isHidden = true
        } else {
            emptyRecordView.isHidden = false
        }
    }
    
    // MARK:- Unwind Segue
    
    @IBAction func unwindToRecordList(sender: UIStoryboardSegue) {
        if let selected = self.recordView.indexPathsForSelectedItems {
            if selected.count != 0 {
                let willRemoveDatakey = libraryListData[selected[0].item].isbn
                CommonData.shared.records.removeValue(forKey: willRemoveDatakey)
//                saveData(data: self.records, at: "records")
            }
            self.recordView.reloadData()
        }
        
        
    }
    
    @IBAction func unwindToRecord(sender: UIStoryboardSegue) {
        guard let addVC = sender.source as? AddBookViewController else {
            return
        }
        
        let recordKey = addVC.selectedBookItem.isbn
        if let prevData = CommonData.shared.records[recordKey] {
            var nextData = prevData
            nextData.contents.updateValue(addVC.contents, forKey: addVC.recordDate)
            CommonData.shared.records.updateValue(nextData, forKey: recordKey)
            // 기존 책 데이터 컨테이너에 새로운 기록을 추가한다.
        } else {
            let newData = Record(bookData: addVC.selectedBookItem, contents: [addVC.recordDate: addVC.contents])
            CommonData.shared.records.updateValue(newData, forKey: recordKey)
            // 새로운 책 데이터 컨테이너와 함께 새로운 기록을 추가한다.
        }
        
//        saveData(data: self.records, at: "records")
        recordView.reloadData()
        reloadEmptyView()
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
        return libraryListData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = recordView.dequeueReusableCell(withReuseIdentifier: "recordCell", for: indexPath) as! RecordCell
        
        cell.bookImage.image = urlToImage(from: libraryListData[indexPath.row].image)
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailRecVC = UIStoryboard(name: "DetailRecVC", bundle: nil).instantiateViewController(withIdentifier: "detailRecVC") as! DetailRecViewController
        
        detailRecVC.selectedKey = libraryListData[indexPath.row].isbn
        self.navigationController?.pushViewController(detailRecVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
    }
    
}
