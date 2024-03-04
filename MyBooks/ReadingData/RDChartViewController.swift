//
//  RDChartViewController.swift
//  MyBooks
//
//  Created by Javier Rodríguez Gómez on 19/9/21.
//

import UIKit
import Charts
import TinyConstraints

class RDChartViewController: UIViewController {
    
    var yValues: [PieChartDataEntry]?
    var readingData = readingDataModel.readingDatas
    
    var meanChartButton = UIButton(frame: CGRect(x: 329, y: 767, width: 64, height: 31))
    
    // MARK: - Chart setup
    
    lazy var myChartView: PieChartView = {
        let chartView = PieChartView()
        chartView.backgroundColor = .white
        chartView.drawCenterTextEnabled = true
        chartView.drawEntryLabelsEnabled = true
        
        return chartView
    }()
    
    // MARK: - UI view

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(myChartView)
        myChartView.centerInSuperview()
        myChartView.width(to: view)
        myChartView.heightToWidth(of: view)
        
        title = "Gráfica resumen"
        setBooks()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareAction))
        
        let booksButton = UIBarButtonItem(title: "Libros", style: .plain, target: self, action: #selector(setBooks))
        let pagesButton = UIBarButtonItem(title: "Páginas", style: .plain, target: self, action: #selector(setPages))
        let pagPerDayButton = UIBarButtonItem(title: "pág/día", style: .plain, target: self, action: #selector(setPagPerDay))
        let formattButton = UIBarButtonItem(title: "Formato", style: .plain, target: self, action: #selector(setFormatt))
        let ratingButton = UIBarButtonItem(title: "Valor.", style: .plain, target: self, action: #selector(setRating))
        let spacer = UIBarButtonItem(systemItem: .flexibleSpace)
        toolbarItems = [booksButton,spacer,pagesButton,spacer,pagPerDayButton,spacer,formattButton,spacer,ratingButton]
        
        meanChartButton.addTarget(self, action: #selector(showMeanChart), for: .touchUpInside)
        meanChartButton.setTitle("Media", for: .normal)
        meanChartButton.setTitleColor(.red, for: .normal)
        meanChartButton.layer.cornerRadius = 5
        meanChartButton.backgroundColor = .systemGray6
        meanChartButton.isHidden = true
        view.addSubview(meanChartButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        navigationController?.isNavigationBarHidden = false
        navigationController?.isToolbarHidden = false
    }
    
    // MARK: - Functions and dataSet
    
    func setColors(_ num: Int) -> [UIColor] {
        var colors = [UIColor]()
        for _ in 0..<num {
            let red = Double.random(in: 0...256)
            let green = Double.random(in: 0...256)
            let blue = Double.random(in: 0...256)

            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 0.5)
            colors.append(color)
        }
        return colors
    }
    
    @objc func setBooks() {
        myChartView.centerText = "Libros leídos\n\(readingData.count)"
        yValues = statisticsModel.readBooksToChart(readingData)
        let colors = setColors(yValues!.count)
        meanChartButton.isHidden = true
        
        let set1 = PieChartDataSet(entries: yValues!, label: "")
        set1.sliceSpace = 2
        set1.yValuePosition = .insideSlice
        set1.xValuePosition = .outsideSlice
        set1.colors = colors
        set1.valueTextColor = .black
        
        let data = PieChartData(dataSet: set1)
        myChartView.data = data
        myChartView.data?.setValueFormatter(DefaultValueFormatter(formatter: noDecimalFormatter))
        myChartView.animate(yAxisDuration: 2)
        
        view.bringSubviewToFront(myChartView)
    }
    
    @objc func setPages() {
        myChartView.centerText = "Número de páginas\n\(statisticsModel.totalRDPages)"
        yValues = statisticsModel.readPagesToChart(readingData)
        let colors = setColors(yValues!.count)
        meanChartButton.isHidden = true
        
        let set1 = PieChartDataSet(entries: yValues!, label: "")
        set1.sliceSpace = 2
        set1.yValuePosition = .insideSlice
        set1.xValuePosition = .outsideSlice
        set1.colors = colors
        set1.valueTextColor = .black
        
        let data = PieChartData(dataSet: set1)
        myChartView.data = data
        myChartView.animate(yAxisDuration: 2)
        
        view.bringSubviewToFront(myChartView)
    }
    
    @objc func setPagPerDay() {
        let mean = noDecimalFormatter.string(from: NSNumber(value: readingDataModel.meanPagPerDay))
        myChartView.centerText = "Páginas por día\n" + mean!
        yValues = statisticsModel.pagPerDayToChart(readingData)
        let colors = setColors(yValues!.count)
        
        let set1 = PieChartDataSet(entries: yValues!, label: "")
        set1.sliceSpace = 2
        set1.yValuePosition = .insideSlice
        set1.xValuePosition = .outsideSlice
        set1.colors = colors
        set1.valueTextColor = .black
        
        let data = PieChartData(dataSet: set1)
        myChartView.data = data
        myChartView.data?.setValueFormatter(DefaultValueFormatter(formatter: noDecimalFormatter))
        myChartView.animate(yAxisDuration: 2)
        
        view.bringSubviewToFront(myChartView)
        view.addSubview(meanChartButton)
        meanChartButton.isHidden = false
    }
    
    @objc func setFormatt() {
        myChartView.centerText = "Número de libros\npor formato"
        yValues = statisticsModel.readFormattToChart(readingData)
        let colors = setColors(yValues!.count)
        meanChartButton.isHidden = true
        
        let set1 = PieChartDataSet(entries: yValues!, label: "")
        set1.sliceSpace = 2
        set1.yValuePosition = .insideSlice
        set1.xValuePosition = .outsideSlice
        set1.colors = colors
        set1.valueTextColor = .black
        
        let data = PieChartData(dataSet: set1)
        myChartView.data = data
        myChartView.data?.setValueFormatter(DefaultValueFormatter(formatter: noDecimalFormatter))
        myChartView.animate(yAxisDuration: 2)
        
        view.bringSubviewToFront(myChartView)
    }
    
    @objc func setRating() {
        myChartView.centerText = "Número de libros\npor valoración"
        yValues = statisticsModel.ratingToChart(readingData)
        let colors = setColors(yValues!.count)
        meanChartButton.isHidden = true
        
        let set1 = PieChartDataSet(entries: yValues!, label: "")
        set1.sliceSpace = 2
        set1.yValuePosition = .insideSlice
        set1.xValuePosition = .outsideSlice
        set1.colors = colors
        set1.valueTextColor = .black
        
        let data = PieChartData(dataSet: set1)
        myChartView.data = data
        myChartView.data?.setValueFormatter(DefaultValueFormatter(formatter: noDecimalFormatter))
        myChartView.animate(yAxisDuration: 2)
        
        view.bringSubviewToFront(myChartView)
    }
    
    @objc func showMeanChart() {
        let meanYValues1: [ChartDataEntry] = statisticsModel.meanValuesToChart(readingData).0
        let meanYValues2: [ChartDataEntry] = statisticsModel.meanValuesToChart(readingData).1
        
        let myMeanChartView: LineChartView = {
            let chartView = LineChartView()
            chartView.backgroundColor = .white
            chartView.xAxis.drawLabelsEnabled = true
            chartView.xAxis.labelPosition = .bottom
            chartView.xAxis.drawGridLinesEnabled = false
            chartView.rightAxis.drawLabelsEnabled = false
            return chartView
        }()
        view.addSubview(myMeanChartView)
        myMeanChartView.centerInSuperview()
        myMeanChartView.width(to: view)
        myMeanChartView.heightToWidth(of: view)
        
        let set1 = LineChartDataSet(entries: meanYValues1, label: "Datos por libro")
        set1.drawCirclesEnabled = false
        set1.setColor(.orange)
        set1.mode = .cubicBezier
        
        let set2 = LineChartDataSet(entries: meanYValues2, label: "Evolución")
        set2.drawCirclesEnabled = false
        set2.setColor(.red)
        set2.mode = .cubicBezier
        
        let data = LineChartData(dataSets: [set1, set2])
        myMeanChartView.data = data
        myMeanChartView.animate(xAxisDuration: 2)
    }
    
    @objc func shareAction() {
        guard let image = myChartView.getChartImage(transparent: true) else { return }
        let vc = UIActivityViewController(activityItems: [image], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    
}
