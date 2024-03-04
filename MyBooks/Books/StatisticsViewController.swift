//
//  StatisticsViewController.swift
//  MyBooks
//
//  Created by Javier Rodríguez Gómez on 12/9/21.
//

import UIKit

var statisticsModel = StatisticsModel()

class StatisticsViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var placeToShow: Place?
    var books = [Books]()
    
    // MARK: - Outlets
    
    @IBOutlet weak var selectorOutlet: UIButton!
    @IBOutlet weak var numOfBooksOutlet: UILabel!
    @IBOutlet weak var pagesOutlet: UILabel!
    @IBOutlet weak var totalPagesAtPlaceOutlet: UILabel!
    @IBOutlet weak var meanPagesAtPlaceOutlet: UILabel!
    @IBOutlet weak var globalMeanPagesOutlet: UILabel!
    @IBOutlet weak var priceOutlet: UILabel!
    @IBOutlet weak var totalPriceAtPlaceOutlet: UILabel!
    @IBOutlet weak var meanPriceAtPlaceOutlet: UILabel!
    @IBOutlet weak var globalMeanPriceOutlet: UILabel!
    @IBOutlet weak var thicknessOutlet: UILabel!
    @IBOutlet weak var totalThicknessAtPlaceOutlet: UILabel!
    @IBOutlet weak var meanThicknessAtPlaceOutlet: UILabel!
    @IBOutlet weak var globalMeanThicknessOutlet: UILabel!
    @IBOutlet weak var weightOutlet: UILabel!
    @IBOutlet weak var totalWeightAtPlaceOutlet: UILabel!
    @IBOutlet weak var meanWeightAtPlaceOutlet: UILabel!
    @IBOutlet weak var globalMeanWeightOutlet: UILabel!
    
    // MARK: - UI view

    override func viewDidLoad() {
        super.viewDidLoad()
        
        books = booksModel.books
        navigationController?.navigationBar.prefersLargeTitles = false
        title = "Estadísticas"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Gráficas", style: .done, target: self, action: #selector(showCharts))
        
        selectorOutlet.layer.cornerRadius = 10
        numOfBooksOutlet.layer.borderWidth = 1
        numOfBooksOutlet.layer.borderColor = UIColor.systemGray4.cgColor
        numOfBooksOutlet.layer.cornerRadius = 10
        numOfBooksOutlet.backgroundColor = .white
        pagesOutlet.layer.borderWidth = 1
        pagesOutlet.layer.borderColor = UIColor.systemGray4.cgColor
        pagesOutlet.layer.cornerRadius = 5
        priceOutlet.layer.borderWidth = 1
        priceOutlet.layer.borderColor = UIColor.systemGray4.cgColor
        priceOutlet.layer.cornerRadius = 5
        thicknessOutlet.layer.borderWidth = 1
        thicknessOutlet.layer.borderColor = UIColor.systemGray4.cgColor
        thicknessOutlet.layer.cornerRadius = 5
        weightOutlet.layer.borderWidth = 1
        weightOutlet.layer.borderColor = UIColor.systemGray4.cgColor
        weightOutlet.layer.cornerRadius = 5
        
        let pages = noDecimalFormatter.string(from: NSNumber(value: statisticsModel.globalPages(books).total))!
        pagesOutlet.text = "Número de páginas: \(pages)"
        let price = priceFormatter.string(from: NSNumber(value: statisticsModel.globalPrice(books).total))!
        priceOutlet.text = "Precio: \(price)"
        let thickness = measureFormatter.string(from: NSNumber(value: statisticsModel.globalThickness(books).total))!
        thicknessOutlet.text = "Grosor (cm): \(thickness)"
        let weight = noDecimalFormatter.string(from: NSNumber(value: statisticsModel.globalWeight(books).total))!
        weightOutlet.text = "Peso (g): \(weight)"
        
        showData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        navigationController?.isNavigationBarHidden = false
        navigationController?.isToolbarHidden = true
    }
    
    // MARK: - Picker setup
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        Place.allCases.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        Place.allCases[row].rawValue
    }
    
    // MARK: - Functions and actions
    
    func showData() {
        guard let place = placeToShow else { return }
        
        selectorOutlet.setTitle(place.rawValue, for: .normal)
        
        let numOfBooks = statisticsModel.booksInPlace(place).count
        numOfBooksOutlet.text = "\(numOfBooks)"
        numOfBooksOutlet.backgroundColor = numColor(numOfBooks)
        
        totalPagesAtPlaceOutlet.text = noDecimalFormatter.string(from: NSNumber(value: statisticsModel.pagesAtPlace(place).total))
        meanPagesAtPlaceOutlet.text =  "\(statisticsModel.pagesAtPlace(place).mean)"
        globalMeanPagesOutlet.text = "\(statisticsModel.globalPages(books).mean)"
        
        totalPriceAtPlaceOutlet.text = priceFormatter.string(from: NSNumber(value: statisticsModel.priceAtPlace(place).total))
        meanPriceAtPlaceOutlet.text = priceFormatter.string(from: NSNumber(value: statisticsModel.priceAtPlace(place).mean))
        globalMeanPriceOutlet.text = priceFormatter.string(from: NSNumber(value: statisticsModel.globalPrice(books).mean))
        
        totalThicknessAtPlaceOutlet.text = measureFormatter.string(from: NSNumber(value: statisticsModel.thicknessAtPlace(place).total))
        meanThicknessAtPlaceOutlet.text = measureFormatter.string(from: NSNumber(value: statisticsModel.thicknessAtPlace(place).mean))
        globalMeanThicknessOutlet.text = measureFormatter.string(from: NSNumber(value: statisticsModel.globalThickness(books).mean))
        
        totalWeightAtPlaceOutlet.text = noDecimalFormatter.string(from: NSNumber(value: statisticsModel.weightAtPlace(place).total))
        meanWeightAtPlaceOutlet.text = "\(statisticsModel.weightAtPlace(place).mean)"
        globalMeanWeightOutlet.text = "\(statisticsModel.globalWeight(books).mean)"
    }
    
    func numColor(_ num: Int) -> UIColor {
        if num >= 50 {
            return UIColor(red: 145/255, green: 0/255, blue: 0/255, alpha: 1)
        } else if num >= 40 {
            return UIColor.red
        } else if num >= 30 {
            return UIColor.orange
        } else if num >= 20 {
            return UIColor.yellow
        } else if num >= 10 {
            return UIColor.green
        } else {
            return UIColor.white
        }
    }
    
    @objc func showCharts() {
        if let vc = storyboard?.instantiateViewController(identifier: "Charts") as? ChartsViewController {
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func placeSelector(_ sender: Any) {
        let screenWidth = UIScreen.main.bounds.width - 10
        let screenHeight = UIScreen.main.bounds.height / 6
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: screenWidth, height: screenHeight)
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        pickerView.dataSource = self
        pickerView.delegate = self
        if let index = Place.allCases.firstIndex(of: placeToShow!) {
            pickerView.selectRow(index, inComponent: 0, animated: true)
        }
        
        vc.view.addSubview(pickerView)
        pickerView.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor).isActive = true
        pickerView.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor).isActive = true
        
        let alert = UIAlertController(title: "Elige una ubicación para mostrar:", message: nil, preferredStyle: .actionSheet)
        alert.popoverPresentationController?.sourceView = selectorOutlet
        alert.popoverPresentationController?.sourceRect = selectorOutlet.bounds
        alert.setValue(vc, forKey: "contentViewController")
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        alert.addAction(UIAlertAction(title: "Aceptar", style: .default) { _ in
            let selectedRow = pickerView.selectedRow(inComponent: 0)
            self.placeToShow = Place.allCases[selectedRow]
            self.showData()
        })
        self.present(alert, animated: true, completion: nil)
    }
    
}
