//
//  RecordViewController.swift
//  WiseBookLife
//
//  Created by 서보경 on 2020/06/22.
//  Copyright © 2020 서보경. All rights reserved.
//

import UIKit

final class RecordViewController: UIViewController {

    // MARK: - UI Properties
    
    @IBOutlet weak var recordView: UICollectionView!
    @IBOutlet weak var emptyRecordView: UIView!
    
    // MARK: - Properties
    
    private let viewModel = RecordViewModel()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindToViewModel()
        configureEmptyView()
    }
    
    // MARK: - Configure Functions
    
    private func configureEmptyView() {
        emptyRecordView.isHidden = viewModel.count > .zero
    }
    
    // MARK: - Bind Function
    
    private func bindToViewModel() {
        viewModel.delegate = self
    }
    
    // MARK: - Refresh Functions
    
    private func refreshRecordView() {
        recordView.reloadData()
        configureEmptyView()
    }
    
    // MARK: - Unwind Segue
    
    @IBAction func unwindToRecordList(sender: UIStoryboardSegue) {
        guard let selected = recordView.indexPathsForSelectedItems
        else { return }
        
        if selected.count != .zero {
            viewModel.delete(at: selected[0].item)
        }
    }
    
    @IBAction func unwindToRecord(sender: UIStoryboardSegue) {
        guard let addVC = sender.source as? AddBookViewController
        else { return }
        
        let willAddBookInfo = addVC.selectedBookInfo
        viewModel.add(
            record: addVC.newRecordContent,
            bookInfo: willAddBookInfo
        )
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension RecordViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width
        let width: CGFloat = screenWidth / Metric.recordRows - Metric.rowSpacing
        let height: CGFloat = width * Metric.bookImageRatio
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Metric.gridSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Metric.gridSpacing
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension RecordViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = recordView.dequeueReusableCell(
            withReuseIdentifier: "recordCell",
            for: indexPath
        ) as? RecordCell
        else { return UICollectionViewCell() }
        
        let imagePath = viewModel[indexPath.row].image
        Task {
            cell.bookImage.image = await ImageDownloader.urlToImage(from: imagePath)
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let detailRecVC = UIStoryboard(name: "DetailRecVC", bundle: nil).instantiateViewController(withIdentifier: "detailRecVC") as? DetailRecViewController
        else { return }
        
        detailRecVC.selectedISBN = viewModel[indexPath.row].isbn
        self.navigationController?.pushViewController(detailRecVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return Metric.sectionInset
    }
    
}

// MARK: - RecordViewModelDelegate

extension RecordViewController: RecordViewModelDelegate {
    func recordsDidChange() {
        refreshRecordView()
    }
}

// MARK: - Namespaces

extension RecordViewController {
    enum Metric {
        static let recordRows: CGFloat = 3
        
        static let rowSpacing: CGFloat = 25
        static let gridSpacing: CGFloat = 15
        static let sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        
        static let bookImageRatio: CGFloat = 40 / 27
    }
}
