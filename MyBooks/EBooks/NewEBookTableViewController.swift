//
//  NewEBookViewController.swift
//  MyBooks
//
//  Created by Javier Rodríguez Gómez on 22/7/21.
//

import UIKit

class NewEBookTableViewController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var newID: Int = 0 {
        didSet {
            title = "Nuevo: \(newID)"
        }
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var AuthorTextOutlet: UITextField!
    @IBOutlet weak var TitleTextOutlet: UITextField!
    @IBOutlet weak var OriginalTextOutlet: UITextField!
    @IBOutlet weak var YearTextOutlet: UITextField!
    @IBOutlet weak var PagesTextOutlet: UITextField!
    @IBOutlet weak var picker: UIPickerView!
    
    // MARK:- UI view
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.picker.delegate = self
        self.picker.dataSource = self
        self.tableView.keyboardDismissMode = .onDrag
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Guardar", style: .done, target: self, action: #selector(save))
        
        newID = eBooksModel.totalEBooks + 1
        initialData()
     
    }
    
    // MARK: - Picker setup
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        ReadingStatus.allCases.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        ReadingStatus.allCases[row].rawValue
    }

    // MARK: - Functions
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func initialData() {
        AuthorTextOutlet.text = ""
        TitleTextOutlet.text = ""
        OriginalTextOutlet.text = ""
        YearTextOutlet.text = ""
        PagesTextOutlet.text = ""
        
        AuthorTextOutlet.placeholder = "Apellidos, Nombre"
        TitleTextOutlet.placeholder = "título, El"
        OriginalTextOutlet.placeholder = "original title, The"
        YearTextOutlet.placeholder = "Año"
        PagesTextOutlet.placeholder = "XXX"
    }
    
    @objc func save() {
        let bookTitle = TitleTextOutlet.text ?? "vacío"
        
        let ac = UIAlertController(title: "¿Deseas guardar este ebook?", message: bookTitle, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "No", style: .cancel))
        ac.addAction(UIAlertAction(title: "Sí", style: .default) {_ in
            let id = self.newID
            let author = self.AuthorTextOutlet.text ?? "vacío"
            let originalTitle = self.OriginalTextOutlet.text ?? "vacío"
            let year = Int(self.YearTextOutlet.text ?? "0") ?? 0
            let pages = Int(self.PagesTextOutlet.text ?? "0") ?? 0
            let status = ReadingStatus.allCases[self.picker.selectedRow(inComponent: 0)]
            
            let newEBook = EBooks(id: id, author: author, bookTitle: bookTitle, originalTitle: originalTitle, year: year, pages: pages, status: status)
            eBooksModel.eBooks.append(newEBook)
            self.newID += 1
            self.initialData()
        })
        present(ac, animated: true)
    }
    
    // MARK: - TextField setup
    
    @IBAction func authorAction(_ sender: Any) {
        guard let text = AuthorTextOutlet.text else { return }
        
        let results = eBooksModel.compareExistingAuthors(text: text).num
        let authors = eBooksModel.compareExistingAuthors(text: text).authorSet
        switch results {
        case 6...:
            let ac = UIAlertController(title: "Se han encontrado \(results) coincidencias.", message: "Realiza una nueva búsqueda para acotar los resultados.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Aceptar", style: .default))
            present(ac, animated: true)
        case 2...5:
            let ac = UIAlertController(title: "\(results) coincidencias.", message: "Elige un resultado:", preferredStyle: .actionSheet)
            ac.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
            for author in authors {
                ac.addAction(UIAlertAction(title: author, style: .default) { _ in self.AuthorTextOutlet.text = author })
            }
            present(ac, animated: true)
        case 1:
            AuthorTextOutlet.text = authors.first
        case 0:
            let ac = UIAlertController(title: "No se han encontrado coincidencias.", message: "Pulsa para continuar.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Continuar", style: .cancel))
            present(ac, animated: true, completion: nil)
        default: ()
        }
    }
    
}
