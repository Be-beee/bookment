//
//  RecordViewController.swift
//  WiseBookLife
//
//  Created by 서보경 on 2020/06/22.
//  Copyright © 2020 서보경. All rights reserved.
//

import UIKit

class RecordViewController: UIViewController {

    var records: [RecordModel] = []
    @IBOutlet var recordView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    

    @IBAction func toAddView(_ sender: UIBarButtonItem) {
        let addRecordVC = UIStoryboard(name: "AddRecordVC", bundle: nil).instantiateViewController(withIdentifier: "addRecordVC") as! AddRecordViewController
        
//        self.navigationController?.pushViewController(addRecordVC, animated: true)
        addRecordVC.modalPresentationStyle = .fullScreen
        present(addRecordVC, animated: true, completion: nil)
    }
    
    @IBAction func unwindToRecord(sender: UIStoryboardSegue) {
        guard let addRecordVC = sender.source as? AddRecordViewController else {
            return
        }
        records.append(addRecordVC.recordModel)
        recordView.reloadData()
    }
    

}

extension RecordViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width/3 - 25, height: 160)
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
        
//        if let url = URL(string: records[indexPath.row].bookData.TITLE_URL) {
//            if let imgData = try? Data(contentsOf: url) {
//                cell.bookImage.image = UIImage(data: imgData)
//            } else {
//                cell.bookImage.image = UIImage(named: "No_Img.png")
//            }
//        } else {
//            cell.bookImage.image = UIImage(named: "No_Img.png")
//        }
        
        cell.bookImage.image = urlToImage(from: records[indexPath.row].bookData.TITLE_URL)
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailRecVC = UIStoryboard(name: "DetailRecVC", bundle: nil).instantiateViewController(withIdentifier: "detailRecVC") as! DetailRecViewController
        
        detailRecVC.selectedItem = records[indexPath.row]
        self.navigationController?.pushViewController(detailRecVC, animated: true)
    }
    
}
