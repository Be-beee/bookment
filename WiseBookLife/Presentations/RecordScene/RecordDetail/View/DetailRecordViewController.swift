//
//  DetailRecordViewController.swift
//  WiseBookLife
//
//  Created by 서보경 on 2020/07/16.
//  Copyright © 2020 서보경. All rights reserved.
//

import UIKit

final class DetailRecordViewController: UIViewController {
    
    // MARK: - UI Properties
    
    @IBOutlet var bookInfoView: SelectView!
    @IBOutlet weak var bookRecordsView: UITableView!
    
    // MARK: - Properties
    
    var viewModel: DetailRecordViewModel?
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindToViewModel()
        configureDeleteBarButtonItem()
        configureBookInfoView()
        configureAddRecordButtonFooter()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshRecordList()
    }
    
    // MARK: - Bind, Configure Functions
    
    private func  bindToViewModel() {
        viewModel?.delegate = self
    }
    
    private func configureDeleteBarButtonItem() {
        navigationItem.largeTitleDisplayMode = .never
        
        let deleteButton = UIBarButtonItem(
            title: StringLiteral.recordDeleteButtonName,
            style: .done,
            target: self,
            action: #selector(deleteCurrentBookInfo)
        )
        navigationItem.rightBarButtonItem = deleteButton
        navigationController?.navigationBar.tintColor = .primary
    }
    
    private func configureBookInfoView() {
        guard let viewModel else { return }
        bookInfoView.configure(viewModel.bookInfo)
    }
    
    private func configureAddRecordButtonFooter() {
        let tableFooter = UIView(frame: Metric.footerSize)
        settingFooterForTableView(
            for: tableFooter,
            action: #selector(presentAddRecordView),
            title: nil,
            image: UIImage(systemName: StringLiteral.footerTitleImageName),
            bgColor: .primary
        )
        
        bookRecordsView.tableFooterView = tableFooter
    }
    
    // MARK: - Refresh Function
    
    private func refreshRecordList() {
        self.bookRecordsView.reloadData()
    }
    
    // MARK: - objc Functions
    
    @objc func presentAddRecordView() {
        let viewName = AddRecordViewController.name
        guard let addRecordView = UIStoryboard(
            name: viewName,
            bundle: nil
        ).instantiateViewController(withIdentifier: viewName) as? AddRecordViewController
        else { return }
        
        self.present(addRecordView, animated: true)
    }
    
    /// 현재 화면에 보여지고 있는 책 데이터와 관련된 기록 데이터를 모두 삭제한다.
    @objc func deleteCurrentBookInfo() {
        presentActionAlert(
            with: StringLiteral.deleteCautionMessage,
            using: StringLiteral.recordDeleteButtonName
        ) { action in
            self.performSegue(withIdentifier: StringLiteral.unwindSegueID, sender: self)
            return
        }
    }
    
    // MARK: - Unwind segue Function
    
    // TODO: Delegate 패턴 적용으로 변경..?
    @IBAction func saveRecordsToLibrary(sender: UIStoryboardSegue) {
        guard let addRecordView = sender.source as? AddRecordViewController,
              let viewModel
        else { return }
        
        addRecordView.newRecordContent.isbn = viewModel.bookInfo.isbn
        viewModel.addRecord(addRecordView.newRecordContent)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension DetailRecordViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.recordsCount ?? .zero
    }
    
    /// 테이블 뷰 셀에 표시할 값 설정
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellName = RecordContentCell.name
        guard let cell = bookRecordsView.dequeueReusableCell(
            withIdentifier: cellName, for: indexPath
        ) as? RecordContentCell,
              let records = viewModel?.records
        else { return UITableViewCell() }
        
        cell.configure(with: records[indexPath.row])
        return cell
    }
    
    /// 테이블 뷰의 섹션 타이틀 표시
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return StringLiteral.sectionTitle
    }
    
    /// 하나의 기록을 삭제하기 위해 셀을 길게 스와이프 하거나 스와이프 후 나오는 삭제 버튼을 터치했을 때, 해당 기록을 삭제한다.
    func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ) {
        guard editingStyle == .delete else { return }
        viewModel?.deleteRecord(at: indexPath.row)
    }
}

// MARK: - DetailRecordViewModelDelegate

extension DetailRecordViewController: DetailRecordViewModelDelegate {
    func recordDetailDidChange() {
        refreshRecordList()
    }
}

// MARK: - Namespaces

extension DetailRecordViewController {
    
    enum Metric {
        static let footerSize = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50)
    }
    
    enum StringLiteral {
        static let footerTitleImageName = "plus"
        
        static let sectionTitle = "독서 기록"
        
        static let recordDeleteButtonName = "삭제"
        static let deleteCautionMessage = "정말 삭제하시겠습니까?\n삭제된 책정보와 기록은 복구할 수 없습니다."
        
        static let unwindSegueID = "toRecordListByDeleting"
    }
}
