//
//  RecordViewController.swift
//  WiseBookLife
//
//  Created by 서보경 on 2020/06/22.
//  Copyright © 2020 서보경. All rights reserved.
//

import UIKit

class RecordViewController: UIViewController {

    var records: [Record] = []
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
        if records.count > 0 {
            emptyRecordView.isHidden = true
        } else {
            emptyRecordView.isHidden = false
        }
    }
    
    // MARK:- Unwind Segue (기록 삭제 시 캘린더 책 삭제 같이 되도록 구현 해야 함)
    
    @IBAction func unwindToRecordList(sender: UIStoryboardSegue) {
        if let selected = self.recordView.indexPathsForSelectedItems {
            if selected.count != 0 {
                records.remove(at: selected[0].item)
//                CommonData.calendarModel.removeValue(forKey: <#T##String#>)
                // 삭제 구현 덜 됨
//                saveData(data: self.records, at: "records")
            }
            self.recordView.reloadData()
        }
        
        
    }
    
    @IBAction func unwindToRecord(sender: UIStoryboardSegue) {
        guard let addRecordVC = sender.source as? AddRecordViewController else {
            return
        }
        guard let selected = self.recordView.indexPathsForSelectedItems else {
            return
        }
        
        if addRecordVC.editmode {
            records[selected[0].item] = addRecordVC.recordModel
        } else {
            records.append(addRecordVC.recordModel)
            
            let df = DateFormatter()
            df.locale = Locale(identifier: "ko_KR")
            df.dateFormat = "yyyy-MM-dd"
            
            let key = df.string(from: addRecordVC.recordModel.date)
            
            var calValue = CommonData.calendarModel[key] ?? []
            // MARK: - 이슈 : 같은 책 정보가 여러번 추가되는 이슈가 발생할 수 있음
            calValue.append(addRecordVC.recordModel.bookData) // < 이부분
            
            CommonData.calendarModel.updateValue(calValue, forKey: key)
        }
//        saveData(data: self.records, at: "records")
        recordView.reloadData()
        reloadEmptyView()
    }
}


// MARK:- Extensions

extension RecordViewController: UICollectionViewDelegateFlowLayout {
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

extension RecordViewController: UICollectionViewDelegate { }

extension RecordViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return records.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = recordView.dequeueReusableCell(withReuseIdentifier: "recordCell", for: indexPath) as! RecordCell
        
        cell.bookImage.image = urlToImage(from: records[indexPath.row].bookData.image)
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailRecVC = UIStoryboard(name: "DetailRecVC", bundle: nil).instantiateViewController(withIdentifier: "detailRecVC") as! DetailRecViewController
        
        detailRecVC.selectedItem = records[indexPath.row]
        self.navigationController?.pushViewController(detailRecVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
    }
    
}
