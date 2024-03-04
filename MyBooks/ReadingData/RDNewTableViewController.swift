//
//  RDNewViewController.swift
//  MyBooks
//
//  Created by Javier Rodríguez Gómez on 3/8/21.
//

import UIKit

class RDNewTableViewController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var newID = 0 {
        didSet {
            title = "Nuevo: \(newID) (\(newYearID) del \(actualYear))"
        }
    }
    var newYearID = 0 {
        didSet {
            title = "Nuevo: \(newID) (\(newYearID) del \(actualYear))"
        }
    }
    var newRDTitle: String?
    let actualYear = Year.allCases.last!.rawValue
    
    var hours = [String](), minutes = [String](), seconds = [String]()
    
    // MARK: - Outlets
    
    @IBOutlet weak var titleOutlet: UITextField!
    @IBOutlet weak var initialDateOutlet: UITextField!
    @IBOutlet weak var finalDateOutlet: UITextField!
    @IBOutlet weak var sessionsOutlet: UITextField!
    @IBOutlet weak var durationOutlet: UIButton!
    @IBOutlet weak var pagesOutlet: UITextField!
    @IBOutlet weak var plus50Outlet: UITextField!
    @IBOutlet weak var minPerPagOutlet: UIButton!
    @IBOutlet weak var minPerDayOutlet: UIButton!
    @IBOutlet weak var pagPerDayOutlet: UITextField!
    @IBOutlet weak var percentOver50Outlet: UITextField!
    @IBOutlet weak var picker:UIPickerView!
    @IBOutlet weak var synopsisOutlet: UITextView!
    @IBOutlet weak var addImageOutlet: UIButton!
    @IBOutlet weak var coverOutlet: UIImageView!
    
    // MARK: - UI view

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.picker.delegate = self
        self.picker.dataSource = self
        self.picker.tag = 0
        self.tableView.keyboardDismissMode = .onDrag
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Guardar", style: .done, target: self, action: #selector(save))
        
        newID = readingDataModel.readingDatas.count + 1
        let lastYearBook = readingDataModel.readingDatas.last!.finishedInYear.rawValue
        if lastYearBook == actualYear {
            newYearID = readingDataModel.readingDatas.last!.yearId + 1
        } else {
            newYearID = 1
        }
        
        for i in 0...59 {
            hours.append("\(i)h")
            minutes.append("\(i)min")
            seconds.append("\(i)s")
        }
                
        durationOutlet.layer.borderWidth = 1
        durationOutlet.layer.cornerRadius = 5
        durationOutlet.layer.borderColor = UIColor.systemGray5.cgColor
        minPerPagOutlet.layer.borderWidth = 1
        minPerPagOutlet.layer.cornerRadius = 5
        minPerPagOutlet.layer.borderColor = UIColor.systemGray5.cgColor
        minPerDayOutlet.layer.borderWidth = 1
        minPerDayOutlet.layer.cornerRadius = 5
        minPerDayOutlet.layer.borderColor = UIColor.systemGray5.cgColor
        synopsisOutlet.layer.borderWidth = 1
        synopsisOutlet.layer.cornerRadius = 5
        synopsisOutlet.layer.borderColor = UIColor.systemGray5.cgColor
        coverOutlet.layer.borderWidth = 1
        coverOutlet.layer.cornerRadius = 5
        coverOutlet.layer.borderColor = UIColor.systemGray5.cgColor
        
        let datePicker1 = createDatePicker(target: self, #selector(initialDateChange(datePicker:)))
        let datePicker2 = createDatePicker(target: self, #selector(finalDateChange(datePicker:)))
        initialDateOutlet.inputView = datePicker1
        finalDateOutlet.inputView = datePicker2
        
        initialData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        navigationController?.isNavigationBarHidden = false
        navigationController?.isToolbarHidden = true
    }
    
    // MARK: - Picker setup
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView.tag == 0 {
            return 3
        } else if pickerView.tag == 1 {
            return 3
        } else { return 0 }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 0 {
            if component == 0 {
                return Year.allCases.count
            } else if component == 1 {
                return Formatt.allCases.count
            } else if component == 2 {
                return Rating.allCases.count
            } else { return 0 }
        } else if pickerView.tag == 1 {
            if component == 0 {
                return hours.count
            } else if component == 1 {
                return minutes.count
            } else if component == 2 {
                return seconds.count
            } else { return 0 }
        } else { return 0 }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 0 {
            if component == 0 {
                return String(Year.allCases[row].rawValue)
            } else if component == 1 {
                return Formatt.allCases[row].rawValue
            } else if component == 2 {
                return String(Rating.allCases[row].rawValue)
            } else { return nil }
        } else if pickerView.tag == 1 {
            if component == 0 {
                return hours[row]
            } else if component == 1 {
                return minutes[row]
            } else if component == 2 {
                return seconds[row]
            } else { return nil }
        } else { return nil }
    }
    
//    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
//        let namesArray = ["oneStar", "twoStars", "threeStars", "fourStars", "fiveStars"]
//        let imageName = namesArray[row]
//        let image = UIImageView(frame: CGRect(x: 0, y: 0, width: 80, height: 55))
//        image.image = UIImage(named: imageName)
//        if pickerView.tag == 0 {
//            if component == 2 {
//                return image
//            } else { return UIView() }
//        } else { return UIView() }
//    }
    
    // MARK: - Functions
    
    func initialData() {
        titleOutlet.text = newRDTitle
        initialDateOutlet.text = ""
        finalDateOutlet.text = ""
        sessionsOutlet.text = ""
        pagesOutlet.text = ""
        plus50Outlet.text = ""
        pagPerDayOutlet.text = ""
        percentOver50Outlet.text = ""
        picker.selectRow(Year.allCases.count - 1, inComponent: 0, animated: true)
        picker.selectRow(0, inComponent: 1, animated: true)
        picker.selectRow(0, inComponent: 2, animated: true)
        synopsisOutlet.text = ""
        coverOutlet.image = UIImage()
        
        titleOutlet.placeholder = "título, El"
        initialDateOutlet.placeholder = "dd/mm/aaaa"
        finalDateOutlet.placeholder = "dd/mm/aaaa"
        sessionsOutlet.placeholder = "Sesiones"
        durationOutlet.setTitle("0h 01min", for: .normal)
        durationOutlet.setTitleColor(.systemGray4, for: .normal)
        pagesOutlet.placeholder = "Páginas"
        plus50Outlet.placeholder = ">50"
        minPerPagOutlet.setTitle("0min 01s", for: .normal)
        minPerPagOutlet.setTitleColor(.systemGray4, for: .normal)
        minPerDayOutlet.setTitle("0h 01min", for: .normal)
        minPerDayOutlet.setTitleColor(.systemGray4, for: .normal)
        pagPerDayOutlet.placeholder = "XX"
        percentOver50Outlet.placeholder = "XX"
        
        addImageOutlet.setTitle("Añadir portada", for: .normal)
        addImageOutlet.setTitleColor(UIColor.systemBlue, for: .normal)
    }
    
    @objc func save() {
        let bookTitle = titleOutlet.text ?? "vacío"
        
        let ac = UIAlertController(title: "¿Deseas crear el registro?", message: bookTitle, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "No", style: .cancel))
        ac.addAction(UIAlertAction(title: "Sí", style: .default) { _ in
            if let newRD = self.addNewRD() {
                readingDataModel.readingDatas.append(newRD)
                
                self.newID += 1
                self.newYearID += 1
                self.newRDTitle = ""
                self.initialData()
            }
        })
        present(ac, animated: true)
    }
    
    func addNewRD() -> ReadingData? {
        let id = newID
        let yearID = newYearID
        let bookTitle = titleOutlet.text ?? "vacío"
        let startDate = initialDateOutlet.text ?? "vacío"
        let finishDate = finalDateOutlet.text ?? "vacío"
        let finishedInYear = Year.allCases[picker.selectedRow(inComponent: 0)]
        let sessions = Int(sessionsOutlet.text ?? "1") ?? 1
        let duration = durationOutlet.title(for: .normal) ?? "0h 01min"
        let pages = Int(pagesOutlet.text ?? "1") ?? 1
        let over50 = Int(plus50Outlet.text ?? "0") ?? 0
        let minPerPag = minPerPagOutlet.title(for: .normal) ?? "0min 01s"
        let minPerDay = minPerDayOutlet.title(for: .normal) ?? "0h 01min"
        let pagPerDay = Double(pagPerDayOutlet.text ?? "0") ?? 1
        let percentOver50 = Double(percentOver50Outlet.text ?? "0") ?? 0
        let formatt = Formatt.allCases[picker.selectedRow(inComponent: 1)]
        let rating = Rating.allCases[picker.selectedRow(inComponent: 2)]
        let synopsis = synopsisOutlet.text ?? "vacío"
        let cover = "cover" + "\(newID)"
        
        let newRD = ReadingData(id: id, yearId: yearID, bookTitle: bookTitle, startDate: startDate, finishDate: finishDate, finishedInYear: finishedInYear, sessions: sessions, duration: duration, pages: pages, over50: over50, minPerPag: minPerPag, minPerDay: minPerDay, pagPerDay: pagPerDay, percentOver50: percentOver50, formatt: formatt, rating: rating, synopsis: synopsis, cover: cover)
        
        return newRD
    }
    
    @objc func initialDateChange(datePicker: UIDatePicker) {
        initialDateOutlet.text = formatDate(date: datePicker.date)
    }
    
    @objc func finalDateChange(datePicker: UIDatePicker) {
        finalDateOutlet.text = formatDate(date: datePicker.date)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        let imageName = "cover" + "\(newID)"
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName).appendingPathExtension("jpg")
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
            print(imagePath.absoluteString)
            print("Se guardó la imagen \(imageName)")
            addImageOutlet.setTitle("Imagen añadida", for: .normal)
            addImageOutlet.setTitleColor(UIColor.systemGray4, for: .normal)
            coverOutlet.image = image
        }
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - TextField & button setup
    
    @IBAction func titleAction(_ sender: Any) {
        guard let text = titleOutlet.text else { return }
        let formatt = Formatt.allCases[picker.selectedRow(inComponent: 1)]
        
        let results = readingDataModel.compareExistingData(formatt: formatt, text: text).num
        let datas = readingDataModel.compareExistingData(formatt: formatt, text: text).dataSet
        switch results {
        case 6...:
            let ac = UIAlertController(title: "Se han encontrado \(results) coincidencias.", message: "Realiza una nueva búsqueda para acotar los resultados.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Aceptar", style: .default))
            present(ac, animated: true)
        case 2...5:
            let ac = UIAlertController(title: "\(results) coincidencias.", message: "Elige un resultado:", preferredStyle: .actionSheet)
            ac.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
            for data in datas {
                ac.addAction(UIAlertAction(title: data, style: .default) { _ in self.titleOutlet.text = data })
            }
            present(ac, animated: true)
        case 1:
            titleOutlet.text = datas.first
        case 0:
            let ac = UIAlertController(title: "No se han encontrado coincidencias.", message: "Pulsa para continuar.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Continuar", style: .cancel))
            present(ac, animated: true, completion: nil)
        default: ()
        }
    }
    
    @IBAction func durationAction(_ sender: UIButton) {
        let screenWidth = UIScreen.main.bounds.width - 10
        let screenHeight = UIScreen.main.bounds.height / 6
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: screenWidth, height: screenHeight)
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.tag = 1
        
        vc.view.addSubview(pickerView)
        pickerView.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor).isActive = true
        pickerView.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor).isActive = true
        
        var selectedHourRow = 0, selectedMinuteRow = 0, selectedSecondRow = 0
        var hour = "", minute = "", second = ""
        var title: String
        var handler = { (_: UIAlertAction) in }
        
        switch sender.tag {
        case 0:
            title = "Duración"
            handler = { (_: UIAlertAction) in
                selectedHourRow = pickerView.selectedRow(inComponent: 0)
                selectedMinuteRow = pickerView.selectedRow(inComponent: 1)
                hour = self.hours[selectedHourRow]
                minute = self.minutes[selectedMinuteRow]
                self.durationOutlet.setTitle("\(hour) \(minute)", for: .normal)
                self.durationOutlet.setTitleColor(.black, for: .normal)
            }
        case 1:
            title = "min/pág"
            handler = { (_: UIAlertAction) in
                selectedMinuteRow = pickerView.selectedRow(inComponent: 1)
                selectedSecondRow = pickerView.selectedRow(inComponent: 2)
                minute = self.minutes[selectedMinuteRow]
                second = self.seconds[selectedSecondRow]
                self.minPerPagOutlet.setTitle("\(minute) \(second)", for: .normal)
                self.minPerPagOutlet.setTitleColor(.black, for: .normal)
            }
        case 2:
            title = "min/día"
            handler = { (_: UIAlertAction) in
                selectedHourRow = pickerView.selectedRow(inComponent: 0)
                selectedMinuteRow = pickerView.selectedRow(inComponent: 1)
                hour = self.hours[selectedHourRow]
                minute = self.minutes[selectedMinuteRow]
                self.minPerDayOutlet.setTitle("\(hour) \(minute)", for: .normal)
                self.minPerDayOutlet.setTitleColor(.black, for: .normal)
            }
        default:
            return
        }
        
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        alert.popoverPresentationController?.sourceView = durationOutlet
        alert.popoverPresentationController?.sourceRect = durationOutlet.bounds
        alert.setValue(vc, forKey: "contentViewController")
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        alert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: handler))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func addCoverImage(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
    
}
