//
//  RDSynopsisViewController.swift
//  MyBooks
//
//  Created by Javier Rodríguez Gómez on 25/5/21.
//

import UIKit

class RDSynopsisViewController: UIViewController {
    
    var synopsisReadingData: ReadingData?
    @IBOutlet weak var coverOutlet: UIImageView!
    @IBOutlet weak var textOutlet: UITextView!
    
    // MARK: - UI view
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let previousButton = UIBarButtonItem(title: "Ant.", style: .plain, target: self, action: #selector(showPrevious))
        let nextButton = UIBarButtonItem(title: "Sig.", style: .plain, target: self, action: #selector(showNext))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbarItems = [previousButton, spacer, nextButton]
        
        textOutlet.isEditable = false
        
        showData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        navigationController?.isNavigationBarHidden = false
        navigationController?.isToolbarHidden = false
    }
    
    // MARK: - Functions
    
    func showData() {
        if let data = synopsisReadingData {
            title = data.bookTitle
            textOutlet.text = data.synopsis
            coverOutlet.image = readingDataModel.getCoverImage(cover: data.cover)
        }
    }
    
    @objc func showNext() {
        guard let index = readingDataModel.readingDatas.firstIndex(where: { $0.id == synopsisReadingData?.id } ) else { return }
        let newIndex = index + 1
        if newIndex < readingDataModel.totalReadingDatas {
            synopsisReadingData = readingDataModel.readingDatas[newIndex]
            showData()
        } else {
            return
        }
    }
    
    @objc func showPrevious() {
        guard let index = readingDataModel.readingDatas.firstIndex(where: { $0.id == synopsisReadingData?.id } ) else { return }
        let newIndex = index - 1
        if newIndex >= 0 {
            synopsisReadingData = readingDataModel.readingDatas[newIndex]
            showData()
        } else {
            return
        }
    }
    
}
