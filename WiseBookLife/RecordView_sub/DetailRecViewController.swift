//
//  DetailRecViewController.swift
//  WiseBookLife
//
//  Created by 서보경 on 2020/07/16.
//  Copyright © 2020 서보경. All rights reserved.
//

import UIKit

class DetailRecViewController: UIViewController {

    var selectedItem: RecordModel = RecordModel()
    @IBOutlet var recTitle: UILabel!
    @IBOutlet var recContents: UITextView!
    @IBOutlet var bookInfoView: SelectView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = selectedItem.date
        self.navigationItem.largeTitleDisplayMode = .never
        
        presentData()
    }
    
    func presentData() {
        recTitle.text = selectedItem.recordTitle
        recContents.text = selectedItem.recordContents
        
        // book data 가져오기
        bookInfoView.bookCoverView.image = urlToImage(from: selectedItem.bookData.TITLE_URL)
        bookInfoView.bookTitle.text = selectedItem.bookData.TITLE
        bookInfoView.bookAuthor.text = selectedItem.bookData.AUTHOR
        bookInfoView.bookDate.text = selectedItem.bookData.PUBLISH_PREDATE
        bookInfoView.bookPublisher.text = selectedItem.bookData.PUBLISHER
        bookInfoView.bookISBN.text = selectedItem.bookData.EA_ISBN
    }
}
