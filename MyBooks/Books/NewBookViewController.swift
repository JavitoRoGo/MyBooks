//
//  NewBookViewController.swift
//  MyBooks
//
//  Created by Javier Rodríguez Gómez on 13/8/21.
//

import UIKit

class NewBookViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var newID: Int = 0 {
        didSet {
            title = "Nuevo (en LP): \(newID)"
        }
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var authorOutlet: UITextField!
    @IBOutlet weak var titleOutlet: UITextField!
    @IBOutlet weak var originalTitleOutlet: UITextField!
    @IBOutlet weak var publisherOutlet: UITextField!
    @IBOutlet weak var cityOutlet: UITextField!
    @IBOutlet weak var editionOutlet: UITextField!
    @IBOutlet weak var yearOutlet: UITextField!
    @IBOutlet weak var writingYearOutlet: UITextField!
    @IBOutlet weak var isbn1Outlet: UITextField!
    @IBOutlet weak var isbn2Outlet: UITextField!
    @IBOutlet weak var isbn3Outlet: UITextField!
    @IBOutlet weak var isbn4Outlet: UITextField!
    @IBOutlet weak var isbn5Outlet: UITextField!
    @IBOutlet weak var pagesOutlet: UITextField!
    @IBOutlet weak var priceOutlet: UITextField!
    @IBOutlet weak var weightOutlet: UITextField!
    @IBOutlet weak var heightOutlet: UITextField!
    @IBOutlet weak var widthOutlet: UITextField!
    @IBOutlet weak var thicknessOutlet: UITextField!
    @IBOutlet weak var picker: UIPickerView!
    
    // MARK: - UI view

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Guardar", style: .done, target: self, action: #selector(save))
        
        self.picker.dataSource = self
        self.picker.delegate = self
        
        newID = booksModel.totalBooks + 1
        initialData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        navigationController?.isNavigationBarHidden = false
        navigationController?.isToolbarHidden = true
    }
    
    // MARK: - Picker setup
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return Type.allCases.count
        } else if component == 1 {
            return Owner.allCases.count
        } else {
            return ReadingStatus.allCases.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return Type.allCases[row].rawValue
        } else if component == 1 {
            return Owner.allCases[row].rawValue
        } else {
            return ReadingStatus.allCases[row].rawValue
        }
    }
    
    // MARK: - Functions
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func initialData() {
        authorOutlet.text = ""
        titleOutlet.text = ""
        originalTitleOutlet.text = ""
        publisherOutlet.text = ""
        cityOutlet.text = ""
        editionOutlet.text = ""
        yearOutlet.text = ""
        writingYearOutlet.text = ""
        isbn1Outlet.text = "978"
        isbn2Outlet.text = "84"
        isbn3Outlet.text = ""
        isbn4Outlet.text = ""
        isbn5Outlet.text = ""
        pagesOutlet.text = ""
        priceOutlet.text = ""
        weightOutlet.text = ""
        heightOutlet.text = ""
        widthOutlet.text = ""
        thicknessOutlet.text = ""
        picker.selectRow(0, inComponent: 0, animated: true)
        picker.selectRow(0, inComponent: 1, animated: true)
        picker.selectRow(0, inComponent: 2, animated: true)
        
        authorOutlet.placeholder = "Apellidos, Nombre"
        titleOutlet.placeholder = "título, El"
        originalTitleOutlet.placeholder = "original title, The"
        publisherOutlet.placeholder = "Editorial, S.A."
        cityOutlet.placeholder = "Ciudad"
        editionOutlet.placeholder = "Nº"
        yearOutlet.placeholder = "xxxx"
        writingYearOutlet.placeholder = "xxxx"
        pagesOutlet.placeholder = "xxx"
        priceOutlet.placeholder = "0.00"
        weightOutlet.placeholder = "xxx"
        heightOutlet.placeholder = "0.0"
        widthOutlet.placeholder = "0.0"
        thicknessOutlet.placeholder = "0.0"
    }
    
    @objc func save() {
        let bookTitle = titleOutlet.text ?? "vacío"
        
        let ac = UIAlertController(title: "¿Deseas guardar este libro?", message: bookTitle, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "No", style: .cancel))
        ac.addAction(UIAlertAction(title: "Sí", style: .default) { _ in
            if let newBook = self.addNewBook() {
                booksModel.books.append(newBook)
                self.newID += 1
                self.initialData()
            }
        })
        present(ac, animated: true)
    }
    
    func addNewBook() -> Books? {
        let id = newID
        let author = authorOutlet.text ?? "vacío"
        let bookTitle = titleOutlet.text ?? "vacío"
        let originalTitle = originalTitleOutlet.text ?? "vacío"
        let publisher = publisherOutlet.text ?? "vacío"
        let city = cityOutlet.text ?? "vacío"
        let edition = Int(editionOutlet.text ?? "0") ?? 0
        let editionYear = Int(yearOutlet.text ?? "0") ?? 0
        let writingYear = Int(writingYearOutlet.text ?? "0") ?? 0
        let type = Type.allCases[picker.selectedRow(inComponent: 0)]
        let isbn1 = Int(isbn1Outlet.text ?? "978") ?? 978
        let isbn2 = Int(isbn2Outlet.text ?? "84") ?? 84
        let isbn3 = Int(isbn3Outlet.text ?? "0") ?? 0
        let isbn4 = Int(isbn4Outlet.text ?? "0") ?? 0
        let isbn5 = Int(isbn5Outlet.text ?? "0") ?? 0
        let pages = Int(pagesOutlet.text ?? "0") ?? 0
        let height = Double(heightOutlet.text ?? "0.0") ?? 0.0
        let width = Double(widthOutlet.text ?? "0.0") ?? 0.0
        let thickness = Double(thicknessOutlet.text ?? "0.0") ?? 0.0
        let weight = Int(weightOutlet.text ?? "0") ?? 0
        let price = Double(priceOutlet.text ?? "0.00") ?? 0.00
        let place = Place.lp
        let owner = Owner.allCases[picker.selectedRow(inComponent: 1)]
        let status = ReadingStatus.allCases[picker.selectedRow(inComponent: 2)]
        
        let newBook = Books(id: id, author: author, bookTitle: bookTitle, originalTitle: originalTitle, publisher: publisher, city: city, edition: edition, editionYear: editionYear, writingYear: writingYear, type: type, isbn1: isbn1, isbn2: isbn2, isbn3: isbn3, isbn4: isbn4, isbn5: isbn5, pages: pages, height: height, width: width, thickness: thickness, weight: weight, price: price, place: place, owner: owner, status: status)
        
        return newBook
    }
    
    func searchForExistingData(tag: Int, text: String) {
        let results: Int
        let datas: Set<String>
        results = booksModel.compareExistingData(tag: tag, text: text).num
        datas = booksModel.compareExistingData(tag: tag, text: text).dataSet
        
        switch results {
        case 6...:
            let ac = UIAlertController(title: "Se han encontrado \(results) coincidencias.", message: "Realiza una nueva búsqueda para acotar los resultados", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Aceptar", style: .default))
            present(ac, animated: true)
        case 2...5:
            let ac = UIAlertController(title: "\(results) coincidencias.", message: "Elige un resultado:", preferredStyle: .actionSheet)
            ac.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
            for data in datas {
                ac.addAction(UIAlertAction(title: data, style: .default) { _ in
                    if tag == 0 {
                        self.authorOutlet.text = data
                    } else if tag == 1 {
                        self.publisherOutlet.text = data
                    } else {
                        self.cityOutlet.text = data
                    }
                })
            }
            present(ac, animated: true)
        case 1:
            if tag == 0 {
                authorOutlet.text = datas.first
            } else if tag == 1 {
                publisherOutlet.text = datas.first
            } else {
                cityOutlet.text = datas.first
            }
        case 0:
            let ac = UIAlertController(title: "No se han encontrado coincidencias.", message: "Pulsa para continuar.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Continuar", style: .cancel))
            present(ac, animated: true, completion: nil)
        default: ()
        }
    }
    
    // MARK: - TextField setup
    
    @IBAction func searchForExistingAction(_ sender: UITextField) {
        guard let text = sender.text else { return }
        let tag = sender.tag
        searchForExistingData(tag: tag, text: text)
    }
    
}
