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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingEmptyRecordView()
//        if let loadedRecords = loadData(at: "records") {
//            self.records = loadedRecords as! [RecordModel]
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadEmptyView()
    }
    
    func settingEmptyRecordView() {
        emptyRecordView.alpha = 1
    }
    
    func reloadEmptyView() {
        if CommonData.shared.records.count > 0 {
            emptyRecordView.isHidden = true
        } else {
            emptyRecordView.isHidden = false
        }
    }
    
    // MARK:- Unwind Segue (기록 삭제 시 캘린더 책 삭제 같이 되도록 구현 해야 함)
    
    @IBAction func unwindToRecordList(sender: UIStoryboardSegue) {
        if let selected = self.recordView.indexPathsForSelectedItems {
            if selected.count != 0 {
                CommonData.shared.records.remove(at: selected[0].item)
//                CommonData.calendarModel.removeValue(forKey: <#T##String#>)
                // 삭제 구현 덜 됨
//                saveData(data: self.records, at: "records")
            }
            self.recordView.reloadData()
        }
        
        
    }
    
    @IBAction func unwindToRecord(sender: UIStoryboardSegue) {
        guard let addVC = sender.source as? AddBookViewController else {
            return
        }
        guard let selected = self.recordView.indexPathsForSelectedItems else {
            return
        }
        
        if addVC.editmode {
            CommonData.shared.records[selected[0].item] = addVC.recordModel
        } else {
            // MARK: - 이미 서재에 등록된 도서가 중복 추가되는 이슈가 발생할 수 있음
            CommonData.shared.records.append(addVC.recordModel)
            
            let df = DateFormatter()
            df.locale = Locale(identifier: "ko_KR")
            df.dateFormat = "yyyy-MM-dd"
            
            let key = df.string(from: addVC.recordModel.date)
            
            var calValue = CommonData.shared.calendarModel[key] ?? []
            // MARK: - 이슈 : 같은 책 정보가 여러번 추가되는 이슈가 발생할 수 있음
            calValue.append(addVC.recordModel.bookData) // < 이부분
            
            CommonData.shared.calendarModel.updateValue(calValue, forKey: key)
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
        return CommonData.shared.records.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = recordView.dequeueReusableCell(withReuseIdentifier: "recordCell", for: indexPath) as! RecordCell
        
        cell.bookImage.image = urlToImage(from: CommonData.shared.records[indexPath.row].bookData.image)
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailRecVC = UIStoryboard(name: "DetailRecVC", bundle: nil).instantiateViewController(withIdentifier: "detailRecVC") as! DetailRecViewController
        
        detailRecVC.selectedIndex = indexPath.row
//        detailRecVC.selectedItem = CommonData.shared.records[indexPath.row]
        self.navigationController?.pushViewController(detailRecVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
    }
    
}
