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
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if let loadedRecords = loadData(at: "records") {
//            self.records = loadedRecords as! [RecordModel]
//        }
    }
    
    // MARK:- Unwind Segue
    
    @IBAction func unwindToRecordList(sender: UIStoryboardSegue) {
        if let selected = self.recordView.indexPathsForSelectedItems {
            if selected.count != 0 {
                records.remove(at: selected[0].item)
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
        }
//        saveData(data: self.records, at: "records")
        recordView.reloadData()
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
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let footer = recordView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "recordFooter", for: indexPath) as? RecordFooter else { return UICollectionReusableView() }
        footer.addBtn.addTarget(self, action: #selector(addBook), for: .touchUpInside)
        return footer
    }
    
    @objc func addBook() {
        let addRecordVC = UIStoryboard(name: "AddRecordVC", bundle: nil).instantiateViewController(withIdentifier: "addRecordVC") as! AddRecordViewController
        
        addRecordVC.modalPresentationStyle = .fullScreen
        self.present(addRecordVC, animated: true, completion: nil)
    }
    
}

class RecordFooter: UICollectionReusableView {
    @IBOutlet weak var addBtn: UIButton!
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}
