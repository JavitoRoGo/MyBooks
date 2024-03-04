//
//  ChartsViewController.swift
//  MyBooks
//
//  Created by Javier Rodríguez Gómez on 17/9/21.
//

import UIKit
import Charts
import TinyConstraints

class ChartsViewController: UIViewController, ChartViewDelegate {
    
    var label: String?
    var yValues: [BarChartDataEntry]?
    var xAxisTitles: [String] {
        var temp = [String]()
        for place in Place.allCases {
            temp.append(place.rawValue)
        }
        return temp
    }
    
    // MARK: - Chart setup
        
    lazy var myChartView: HorizontalBarChartView = {
        let chartView = HorizontalBarChartView()
        chartView.backgroundColor = .systemGray6
        chartView.rightAxis.enabled = false
        
        let yAxis = chartView.leftAxis
        yAxis.labelFont = .boldSystemFont(ofSize: 12)
        yAxis.setLabelCount(6, force: false)
        yAxis.labelTextColor = .black
        yAxis.axisLineColor = .black
        yAxis.labelPosition = .outsideChart
        yAxis.axisMinimum = 0
        
        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .boldSystemFont(ofSize: 12)
        xAxis.setLabelCount(29, force: false)
        xAxis.labelTextColor = .black
        xAxis.axisLineColor = .black
        xAxis.drawGridLinesEnabled = false
        xAxis.valueFormatter = IndexAxisValueFormatter(values: xAxisTitles)
        
        return chartView
    }()
    
    // MARK: - UI view

    override func viewDidLoad() {
        super.viewDidLoad()
                
        view.addSubview(myChartView)
        myChartView.centerInSuperview()
        myChartView.width(to: view)
        myChartView.height(700)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareAction))
        
        let booksButton = UIBarButtonItem(title: "Libros", style: .plain, target: self, action: #selector(setBooks))
        let pagesButton = UIBarButtonItem(title: "Páginas", style: .plain, target: self, action: #selector(setPages))
        let priceButton = UIBarButtonItem(title: "Precio", style: .plain, target: self, action: #selector(setPrice))
        let thickButton = UIBarButtonItem(title: "Grosor", style: .plain, target: self, action: #selector(setThickness))
        let weightButton = UIBarButtonItem(title: "Peso", style: .plain, target: self, action: #selector(setWeight))
        let spacer = UIBarButtonItem(systemItem: .flexibleSpace)
        toolbarItems = [booksButton,spacer,pagesButton,spacer,priceButton,spacer,thickButton,spacer,weightButton]
        
        setBooks()
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
            let red = CGFloat.random(in: 0...255)
            let green = CGFloat.random(in: 0...255)
            let blue = CGFloat.random(in: 0...255)
            
            let color = UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 0.5)
            colors.append(color)
        }
        return colors
    }
    
    @objc func setBooks() {
        title = "Número de libros"
        yValues = statisticsModel.booksToChart()
        label = "Libros"
        let colors = setColors(yValues!.count)
        
        let set1 = BarChartDataSet(entries: yValues!, label: label!)
        set1.colors = colors
        set1.barBorderWidth = 1
        
        let data = BarChartData(dataSet: set1)
        myChartView.data = data
        myChartView.data?.setValueFormatter(DefaultValueFormatter(formatter: noDecimalFormatter))
        myChartView.animate(yAxisDuration: 2)
    }
    
    @objc func setPages() {
        title = "Número de páginas"
        yValues = statisticsModel.pagesToChart()
        label = "Páginas"
        let colors = setColors(yValues!.count)
        
        let set1 = BarChartDataSet(entries: yValues!, label: label!)
        set1.colors = colors
        set1.barBorderWidth = 1

        let data = BarChartData(dataSet: set1)
        myChartView.data = data
        myChartView.animate(yAxisDuration: 2)
    }
    
    @objc func setPrice() {
        title = "Precio (€)"
        yValues = statisticsModel.priceToChart()
        label = "Precio"
        let colors = setColors(yValues!.count)
        
        let set1 = BarChartDataSet(entries: yValues!, label: label!)
        set1.colors = colors
        set1.barBorderWidth = 1

        let data = BarChartData(dataSet: set1)
        myChartView.data = data
        myChartView.data?.setValueFormatter(DefaultValueFormatter(formatter: priceFormatter))
        myChartView.animate(yAxisDuration: 2)
    }
    
    @objc func setThickness() {
        title = "Grosor (cm)"
        yValues = statisticsModel.thicknessToChart()
        label = "Grosor (cm)"
        let colors = setColors(yValues!.count)
        
        let set1 = BarChartDataSet(entries: yValues!, label: label!)
        set1.colors = colors
        set1.barBorderWidth = 1

        let data = BarChartData(dataSet: set1)
        myChartView.data = data
        myChartView.data?.setValueFormatter(DefaultValueFormatter(formatter: measureFormatter))
        myChartView.animate(yAxisDuration: 2)
    }
    
    @objc func setWeight() {
        title = "Peso (kg)"
        yValues = statisticsModel.weightToChart()
        label = "Peso (kg)"
        let colors = setColors(yValues!.count)
        
        let set1 = BarChartDataSet(entries: yValues!, label: label!)
        set1.colors = colors
        set1.barBorderWidth = 1
        
        let data = BarChartData(dataSet: set1)
        myChartView.data = data
        myChartView.data?.setValueFormatter(DefaultValueFormatter(formatter: measureFormatter))
        myChartView.animate(yAxisDuration: 2)
    }
    
    @objc func shareAction() {
        guard let image = myChartView.getChartImage(transparent: true) else { return }
        let vc = UIActivityViewController(activityItems: [image], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
        print("Se guardó la gráfica")
    }
    
}
