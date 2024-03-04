//
//  DetailTableViewController.swift
//  MyBooks
//
//  Created by Javier Rodríguez Gómez on 2/5/21.
//

import UIKit

class DetailTableViewController: UITableViewController {
    
    var bookDetail: Books?
    
    // MARK: - Outlets

    @IBOutlet weak var authorOutlet: UILabel!
    @IBOutlet weak var titleOutlet: UILabel!
    @IBOutlet weak var originalOutlet: UILabel!
    @IBOutlet weak var publisherOutlet: UILabel!
    @IBOutlet weak var cityOutlet: UILabel!
    @IBOutlet weak var editionOutlet: UILabel!
    @IBOutlet weak var edYearOutlet: UILabel!
    @IBOutlet weak var writingYearOutlet: UILabel!
    @IBOutlet weak var typeOutlet: UILabel!
    @IBOutlet weak var isbnOutlet: UILabel!
    @IBOutlet weak var pagesOutlet: UILabel!
    @IBOutlet weak var priceOutlet: UILabel!
    @IBOutlet weak var weightOutlet: UILabel!
    @IBOutlet weak var heightOutlet: UILabel!
    @IBOutlet weak var widthOutlet: UILabel!
    @IBOutlet weak var thicknessOutlet: UILabel!
    @IBOutlet weak var statusOutlet: UIButton!
    
    // MARK: - UI view
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Modificar", style: .plain, target: self, action: #selector(editBook))
        
        let nextButton = UIBarButtonItem(title: "Sig.", style: .plain, target: self, action: #selector(showNextBook))
        let previousButton = UIBarButtonItem(title: "Ant.", style: .plain, target: self, action: #selector(showPrevBook))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbarItems = [previousButton, spacer, nextButton]
                        
        showDataBook()
        setTitles()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        navigationController?.isNavigationBarHidden = false
        navigationController?.isToolbarHidden = false
    }
    
    // MARK: - Button action
    
    @IBAction func statusAction(_ sender: Any) {
        let title: String
        var message = "Pulsa para volver."
        var handler = { (action: UIAlertAction) in }
        guard let book = bookDetail else { return }
        
        switch book.status {
        case .registered:
            title = "Libro leído y con registro de lectura."
            message = "Pulsa \"Aceptar\" para ver los datos."
            handler = { (action: UIAlertAction) in
                if let vc = self.storyboard?.instantiateViewController(identifier: "DetailReadingData") as? RDDetailTableViewController {
                    vc.readingDataDetail = readingDataModel.readingDatas.filter { $0.bookTitle == book.bookTitle }.first
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        case .read:
            title = "Libro leído pero sin registro de lectura."
        case .notRead:
            title = "Libro sin leer o pendiente."
        case .consulting:
            title = "Libro de consulta."
        case .noStatus:
            title = "Libro en estado desconocido."
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        if book.status == .registered {
            alert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: handler))
        }
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let book = bookDetail else { return "" }
        return "\(book.owner.rawValue) - \(book.place.rawValue)"
    }
    
    // MARK: - Functiones
    
    func showDataBook() {
        guard let book = bookDetail else { return }
        
        authorOutlet.text = "\(book.author)"
        titleOutlet.text = "\(book.bookTitle)"
        originalOutlet.text = "\(book.originalTitle)"
        publisherOutlet.text = "\(book.publisher)"
        cityOutlet.text = "\(book.city)"
        editionOutlet.text = "\(book.edition)"
        edYearOutlet.text = "\(book.editionYear)"
        writingYearOutlet.text = "\(book.writingYear)"
        typeOutlet.text = "\(book.type.rawValue)"
        isbnOutlet.text = "\(book.isbn1)-\(book.isbn2)-\(book.isbn3)-\(book.isbn4)-\(book.isbn5)"
        pagesOutlet.text = "\(book.pages)"
        priceOutlet.text = priceFormatter.string(from: NSNumber(value: book.price))
        weightOutlet.text = "\(book.weight)"
        heightOutlet.text = measureFormatter.string(from: NSNumber(value: book.height))
        widthOutlet.text = measureFormatter.string(from: NSNumber(value: book.width))
        thicknessOutlet.text = measureFormatter.string(from: NSNumber(value: book.thickness))
        statusOutlet.setImage(booksModel.imageStatus(book), for: .normal)
    }
    
    func setTitles() {
        guard let book = bookDetail else { return }
        navigationItem.title = "Detalle (\(book.id) de \(booksModel.totalBooks))"
        tableView.reloadData()
    }
    
    @objc func editBook() {
        if let vc = storyboard?.instantiateViewController(identifier: "EditBook") as? EditBookViewController {
            vc.editingBook = bookDetail
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func showNextBook() {
        guard let index = booksModel.books.firstIndex(where: {$0.id == bookDetail?.id} ) else { return }
        let newIndex = index + 1
        if newIndex < booksModel.totalBooks {
            bookDetail = booksModel.books[newIndex]
            showDataBook()
            setTitles()
        } else {
            return
        }
    }
    
    @objc func showPrevBook() {
        guard let index = booksModel.books.firstIndex(where: {$0.id == bookDetail?.id } ) else { return }
        let newIndex = index - 1
        if newIndex >= 0 {
            bookDetail = booksModel.books[newIndex]
            showDataBook()
            setTitles()
        } else {
            return
        }
    }

}
