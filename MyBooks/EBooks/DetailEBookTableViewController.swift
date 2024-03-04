//
//  DetailEBookTableViewController.swift
//  MyBooks
//
//  Created by Javier Rodríguez Gómez on 20/6/21.
//

import UIKit

class DetailEBookTableViewController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var eBookDetail: EBooks?
    
    // MARK:- Outlets
    
    @IBOutlet weak var authorOutlet: UILabel!
    @IBOutlet weak var titleOutlet: UILabel!
    @IBOutlet weak var originalOutlet: UILabel!
    @IBOutlet weak var yearOutlet: UILabel!
    @IBOutlet weak var pagesOutlet: UILabel!
    @IBOutlet weak var statusOutlet: UIButton!
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var sliderOutlet: UISlider!
    
    // MARK: - UI view

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.picker.delegate = self
        self.picker.dataSource = self
        
        navigationItem.largeTitleDisplayMode = .never
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Guardar", style: .done, target: self, action: #selector(updateEBook))
        
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
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        ReadingStatus.allCases.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        ReadingStatus.allCases[row].rawValue
    }
    
    // MARK: - Functions
    
    func showData() {
        guard let eBook = eBookDetail else { return }
        
        authorOutlet.text = eBook.author
        titleOutlet.text = eBook.bookTitle
        originalOutlet.text = eBook.originalTitle
        yearOutlet.text = "\(eBook.year)"
        pagesOutlet.text = "\(eBook.pages)"
        statusOutlet.setImage(eBooksModel.imageStatus(eBook), for: .normal)
        sliderOutlet.value = Float(eBook.id - 1)
        
        let row: Int = ReadingStatus.allCases.firstIndex(of: eBook.status)!
        picker.selectRow(row, inComponent: 0, animated: true)
        
        title = "Detalle (\(eBook.id) de \(eBooksModel.totalEBooks))"
    }
    
    func configSlider() {
        guard let eBook = eBookDetail else { return }
        sliderOutlet.minimumValue = 0
        sliderOutlet.maximumValue = Float(eBooksModel.totalEBooks - 1)
        sliderOutlet.value = Float(eBook.id - 1)
    }
    
    @objc func showNext() {
        guard let index = eBooksModel.eBooks.firstIndex(where: { $0.id == eBookDetail?.id } ) else { return }
        let newIndex = index + 1
        if newIndex < eBooksModel.totalEBooks {
            eBookDetail = eBooksModel.eBooks[newIndex]
            showData()
        } else {
            return
        }
    }
    
    @objc func showPrev() {
        guard let index = eBooksModel.eBooks.firstIndex(where: { $0.id == eBookDetail?.id } ) else { return }
        let newIndex = index - 1
        if newIndex >= 0 {
            eBookDetail = eBooksModel.eBooks[newIndex]
            showData()
        } else {
            return
        }
    }
    
    @objc func updateEBook() {
        let ac = UIAlertController(title: "Se va a modificar este registro.", message: "¿Deseas continuar?", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "No", style: .cancel))
        ac.addAction(UIAlertAction(title: "Sí", style: .default) {_ in
            self.setNewValues()
        })
        present(ac, animated: true)
    }
    
    func setNewValues() {
        guard var newEBook = eBookDetail else { return }
        let newStatus = ReadingStatus.allCases[picker.selectedRow(inComponent: 0)]
        newEBook.status = newStatus
        eBooksModel.updateEBook(eBook: newEBook)
        
        if newStatus == .registered {
            let ac = UIAlertController(title: "¿Deseas agregar el nuevo registro?", message: "Se abrirá el formulario para introducir los datos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ahora no", style: .cancel))
            ac.addAction(UIAlertAction(title: "Vale", style: .default) {_ in
                if let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddReadingData") as? RDNewTableViewController {
                    vc.newRDTitle = newEBook.bookTitle
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            })
            self.present(ac, animated: true)
        }
    }
    
    // MARK: - Button and slider action
    
    @IBAction func statusAction(_ sender: Any) {
        let title: String
        var message = "Pulsa para volver"
        var handler = { (_: UIAlertAction) in }
        
        switch eBookDetail!.status {
        case .registered:
            title = "Libro leído y con registro de lectura."
            message = "Pulsa \"Aceptar\" para ver los datos."
            
            handler = { (_: UIAlertAction) in
                if let vc = self.storyboard?.instantiateViewController(identifier: "DetailReadingData") as? RDDetailTableViewController {
                    vc.readingDataDetail = readingDataModel.readingDatas.filter { $0.bookTitle == self.eBookDetail?.bookTitle }.first
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
        
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        if eBookDetail!.status == .registered {
            ac.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: handler))
        }
        present(ac, animated: true)
    }
    
    @IBAction func sliderAction(_ sender: Any) {
        eBookDetail = eBooksModel.eBooks[Int(sliderOutlet.value)]
        showData()
    }
    
}
