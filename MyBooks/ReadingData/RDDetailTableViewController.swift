//
//  RDDetailTableViewController.swift
//  MyBooks
//
//  Created by Javier Rodríguez Gómez on 11/5/21.
//

import UIKit

class RDDetailTableViewController: UITableViewController {
    
    var readingDataDetail: ReadingData?
    
    // MARK: - Outlets
    
    @IBOutlet weak var titleOutlet: UILabel!
    @IBOutlet weak var dateOutlet: UILabel!
    @IBOutlet weak var sessionsOutlet: UILabel!
    @IBOutlet weak var durationOutlet: UILabel!
    @IBOutlet weak var pagesOutlet: UILabel!
    @IBOutlet weak var over50Outlet: UILabel!
    @IBOutlet weak var minPerPagOutlet: UILabel!
    @IBOutlet weak var meanMinPerPagOutlet: UILabel!
    @IBOutlet weak var minPerPagArrowOutlet: UIImageView!
    @IBOutlet weak var minPerDayOutlet: UILabel!
    @IBOutlet weak var meanMinPerDayOutlet: UILabel!
    @IBOutlet weak var minPerDayArrowOutlet: UIImageView!
    @IBOutlet weak var pagPerDayOutlet: UILabel!
    @IBOutlet weak var meanPagPerDayOutlet: UILabel!
    @IBOutlet weak var pagPerDayArrowOutlet: UIImageView!
    @IBOutlet weak var percentOver50Outlet: UILabel!
    @IBOutlet weak var meanPercentOver50Outlet: UILabel!
    @IBOutlet weak var percentOver50ArrowOutlet: UIImageView!
    @IBOutlet weak var typeOutlet: UILabel!
    @IBOutlet var star1Image: UIImageView!
    @IBOutlet var star2Image: UIImageView!
    @IBOutlet var star3Image: UIImageView!
    @IBOutlet var star4Image: UIImageView!
    @IBOutlet var star5Image: UIImageView!
    @IBOutlet weak var detailButtonOutlet: UIButton!
    @IBOutlet weak var sliderOutlet: UISlider!
    
    // MARK: - UI view

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
        //tabBarController?.tabBar.isHidden = false
        
        let nextButton = UIBarButtonItem(title: "Sig.", style: .plain, target: self, action: #selector(showNext))
        let previousButton = UIBarButtonItem(title: "Ant.", style: .plain, target: self, action: #selector(showPrev))
        let synopsisButton = UIBarButtonItem(title: "Sinopsis", style: .plain, target: self, action: #selector(showSynopsis))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbarItems = [previousButton, spacer, synopsisButton, spacer, nextButton]
        
        detailButtonOutlet?.setTitle("Ver detalle", for: .normal)
        showData()
        configSlider()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        navigationController?.isNavigationBarHidden = false
        navigationController?.isToolbarHidden = false
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Nº \(readingDataDetail!.yearId) del año \(readingDataDetail!.finishedInYear.rawValue)"
    }
    
    // MARK: - Functions
    
    func showData() {
        guard let data = readingDataDetail else { return }
        
        titleOutlet.text = data.bookTitle
        dateOutlet.text = "\(data.startDate) - \(data.finishDate)"
        sessionsOutlet.text = "\(data.sessions)"
        durationOutlet.text = data.duration
        pagesOutlet.text = "\(data.pages)"
        over50Outlet.text = "\(data.over50)"
        
        let value1 = minPerPagInMinutes(data.minPerPag)
        let mean1 = readingDataModel.meanMinPerPag
        let compare1 = compareWithMean(value: mean1, mean: value1)
        minPerPagOutlet.text = data.minPerPag
        minPerPagOutlet.textColor = compare1.color
        meanMinPerPagOutlet.text = minPerPagDoubleToString(mean1)
        minPerPagArrowOutlet.image = UIImage(systemName: compare1.image)
        minPerPagArrowOutlet.tintColor = compare1.color
        
        let value2 = minPerDayInHours(data.minPerDay)
        let mean2 = readingDataModel.meanMinPerDay
        let compare2 = compareWithMean(value: value2, mean: mean2)
        minPerDayOutlet.text = data.minPerDay
        minPerDayOutlet.textColor = compare2.color
        meanMinPerDayOutlet.text = minPerDayDoubleToString(mean2)
        minPerDayArrowOutlet.image = UIImage(systemName: compare2.image)
        minPerDayArrowOutlet.tintColor = compare2.color
        
        let value3 = data.pagPerDay
        let mean3 = readingDataModel.meanPagPerDay
        let compare3 = compareWithMean(value: value3, mean: mean3)
        pagPerDayOutlet.text = noDecimalFormatter.string(from: NSNumber(value: value3))
        pagPerDayOutlet.textColor = compare3.color
        meanPagPerDayOutlet.text = noDecimalFormatter.string(from: NSNumber(value: mean3))
        pagPerDayArrowOutlet.image = UIImage(systemName: compare3.image)
        pagPerDayArrowOutlet.tintColor = compare3.color
        
        let value4 = data.percentOver50
        let mean4 = readingDataModel.meanOver50
        let compare4 = compareWithMean(value: value4, mean: mean4)
        percentOver50Outlet.text = noDecimalFormatter.string(from: NSNumber(value: value4))! + " %"
        percentOver50Outlet.textColor = compare4.color
        meanPercentOver50Outlet.text = noDecimalFormatter.string(from: NSNumber(value: mean4))! + " %"
        percentOver50ArrowOutlet.image = UIImage(systemName: compare4.image)
        percentOver50ArrowOutlet.tintColor = compare4.color
        
        typeOutlet.text = data.formatt.rawValue
        showRatingImage(data.rating)
        
        sliderOutlet.value = Float(data.id - 1)
        
        title = "Detalle (\(data.id) de \(readingDataModel.totalReadingDatas))"
        tableView.reloadData()
    }
    
    func showRatingImage(_ rating: Rating) {
        let emptyStar = UIImage(systemName: "star")?.withTintColor(.systemGray4).withRenderingMode(.alwaysOriginal)
        let fullStar = UIImage(systemName: "star.fill")?.withTintColor(.systemYellow).withRenderingMode(.alwaysOriginal)
        
        switch rating {
        case .oneStar:
            star1Image.image = fullStar
            star2Image.image = emptyStar
            star3Image.image = emptyStar
            star4Image.image = emptyStar
            star5Image.image = emptyStar
        case .twoStars:
            star1Image.image = fullStar
            star2Image.image = fullStar
            star3Image.image = emptyStar
            star4Image.image = emptyStar
            star5Image.image = emptyStar
        case .threeStars:
            star1Image.image = fullStar
            star2Image.image = fullStar
            star3Image.image = fullStar
            star4Image.image = emptyStar
            star5Image.image = emptyStar
        case .fourStars:
            star1Image.image = fullStar
            star2Image.image = fullStar
            star3Image.image = fullStar
            star4Image.image = fullStar
            star5Image.image = emptyStar
        case .fiveStars:
            star1Image.image = fullStar
            star2Image.image = fullStar
            star3Image.image = fullStar
            star4Image.image = fullStar
            star5Image.image = fullStar
        }
    }
    
    func configSlider() {
        guard let data = readingDataDetail else { return }
        sliderOutlet.minimumValue = 0
        sliderOutlet.maximumValue = Float(readingDataModel.totalReadingDatas - 1)
        sliderOutlet.value = Float(data.id - 1)
    }
    
    @objc func showNext() {
        guard let index = readingDataModel.readingDatas.firstIndex(where: { $0.id == readingDataDetail?.id } ) else { return }
        let newIndex = index + 1
        if newIndex < readingDataModel.totalReadingDatas {
            readingDataDetail = readingDataModel.readingDatas[newIndex]
            showData()
        } else {
            return
        }
    }
    
    @objc func showPrev() {
        guard let index = readingDataModel.readingDatas.firstIndex(where: { $0.id == readingDataDetail?.id } ) else { return }
        let newIndex = index - 1
        if newIndex >= 0 {
            readingDataDetail = readingDataModel.readingDatas[newIndex]
            showData()
        } else {
            return
        }
    }
    
    @objc func showSynopsis() {
        if let vc = storyboard?.instantiateViewController(identifier: "SynopsisRD") as? RDSynopsisViewController {
            vc.synopsisReadingData = readingDataDetail
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    // MARK: - Button action
    
    @IBAction func detailButtonAction(_ sender: Any) {
        if readingDataDetail?.formatt == .paper {
            if let vc = storyboard?.instantiateViewController(identifier: "DetailView") as? DetailTableViewController {
                vc.bookDetail = booksModel.books.filter { $0.bookTitle == readingDataDetail?.bookTitle }.first
                navigationController?.pushViewController(vc, animated: true)
            }
        } else {
            if let vc = storyboard?.instantiateViewController(identifier: "DetailEBook") as? DetailEBookTableViewController {
                vc.eBookDetail = eBooksModel.eBooks.filter { $0.bookTitle == readingDataDetail?.bookTitle }.first
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    @IBAction func sliderAction(_ sender: Any) {
        readingDataDetail = readingDataModel.readingDatas[Int(sliderOutlet.value)]
        showData()
    }
    
}
