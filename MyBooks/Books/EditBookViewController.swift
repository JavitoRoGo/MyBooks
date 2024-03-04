//
//  EditBookViewController.swift
//  MyBooks
//
//  Created by Javier Rodríguez Gómez on 5/8/21.
//

import UIKit

class EditBookViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var editingBook: Books?
    
    // MARK: - Outlets
    
    @IBOutlet weak var idOutlet: UILabel!
    @IBOutlet weak var authorOutlet: UILabel!
    @IBOutlet weak var titleOutlet: UITextField!
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var sliderOutlet: UISlider!
    
    
    // MARK: - UI view

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.picker.dataSource = self
        self.picker.delegate = self
        
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Guardar", style: .done, target: self, action: #selector(saveBook))
        
        title = "Modificar el registro"
        
        let nextButton = UIBarButtonItem(title: "Sig.", style: .plain, target: self, action: #selector(showNext))
        let previousButton = UIBarButtonItem(title: "Ant.", style: .plain, target: self, action: #selector(showPrev))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbarItems = [previousButton, spacer, nextButton]
                      
        showData()
        configSlider()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        navigationController?.isNavigationBarHidden = false
        navigationController?.isToolbarHidden = false
    }
    
    // MARK: - Picker setup
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return ReadingStatus.allCases.count
        } else if component == 1 {
            return Place.allCases.count
        } else {
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return ReadingStatus.allCases[row].rawValue
        } else if component == 1 {
            return Place.allCases[row].rawValue
        } else {
            return nil
        }
    }
    
    // MARK: - Functions
    
    func configSlider() {
        guard let book = editingBook else { return }
        sliderOutlet.minimumValue = 1
        sliderOutlet.maximumValue = Float(booksModel.totalBooks)
        sliderOutlet.setValue(Float(book.id), animated: true)
    }
    
    func showData() {
        guard let book = editingBook else { return }
        idOutlet.text = "\(book.id)"
        authorOutlet.text = book.author
        titleOutlet.text = book.bookTitle
        sliderOutlet.setValue(Float(book.id), animated: true)
        
        let statusRow = ReadingStatus.allCases.firstIndex(of: book.status)!
        let placeRow = Place.allCases.firstIndex(of: book.place)!
        picker.selectRow(statusRow, inComponent: 0, animated: true)
        picker.selectRow(placeRow, inComponent: 1, animated: true)
    }
    
    @objc func saveBook() {
        let ac = UIAlertController(title: "Se va a modificar este registro.", message: "¿Deseas continuar?", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "No", style: .cancel))
        ac.addAction(UIAlertAction(title: "Sí", style: .default) { _ in
            let newStatus = ReadingStatus.allCases[self.picker.selectedRow(inComponent: 0)]
            let newPlace = Place.allCases[self.picker.selectedRow(inComponent: 1)]
            guard var book = self.editingBook, let newBookTitle = self.titleOutlet.text else { return }
            book.bookTitle = newBookTitle
            book.status = newStatus
            book.place = newPlace
            booksModel.updateBook(book: book)
            
            if newStatus == .registered {
                let ac = UIAlertController(title: "¿Deseas agregar el nuevo registro?", message: "Se abrirá el formulario para introducir los datos.", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Ahora no", style: .cancel))
                ac.addAction(UIAlertAction(title: "Vale", style: .default) {_ in
                    if let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddReadingData") as? RDNewTableViewController {
                        vc.newRDTitle = newBookTitle
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                })
                self.present(ac, animated: true)
            }
        })
        present(ac, animated: true)
    }
 
    @objc func showNext() {
        guard let index = booksModel.books.firstIndex(where: { $0.id == editingBook?.id} ) else { return }
        let newIndex = index + 1
        if newIndex < booksModel.totalBooks {
            editingBook = booksModel.books[newIndex]
            showData()
        } else {
            return
        }
    }
    
    @objc func showPrev() {
        guard let index = booksModel.books.firstIndex(where: {$0.id == editingBook?.id} ) else { return }
        let newIndex = index - 1
        if newIndex >= 0 {
        editingBook = booksModel.books[newIndex]
        showData()
        } else {
            return
        }
    }
    
    // MARK: - Actions
    
    @IBAction func sliderAction(_ sender: Any) {
        editingBook = booksModel.books[Int(sliderOutlet.value - 1)]
        showData()
    }
    
}
