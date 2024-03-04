//
//  PlaceDetailTableViewController.swift
//  MyBooks
//
//  Created by Javier Rodríguez Gómez on 2/8/21.
//

import UIKit

class PlaceDetailTableViewController: UITableViewController {
    
    var booksInPlace = [Books]()
    var place: Place?
    
    // MARK: - UI view

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = false
        let myBarButton1 = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(newBook))
        let myBarButton2 = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchBook))
        navigationItem.rightBarButtonItems = [myBarButton1, myBarButton2]
        
        setTitle()
        
        let nextButton = UIBarButtonItem(title: "Sig.", style: .plain, target: self, action: #selector(showNextPlace))
        let prevButton = UIBarButtonItem(title: "Ant.", style: .plain, target: self, action: #selector(showPrevPlace))
        let statistics = UIBarButtonItem(title: "Estadísticas", style: .plain, target: self, action: #selector(showStatistcs))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbarItems = [prevButton, spacer, statistics, spacer, nextButton]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        navigationController?.isNavigationBarHidden = false
        navigationController?.isToolbarHidden = false
        
        setTitle()
        tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        booksInPlace.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "zelda", for: indexPath)
        let bookToShow = booksInPlace.reversed()[indexPath.row]
        cell.textLabel?.text = "\(bookToShow.bookTitle)"
        cell.detailTextLabel?.text = "\(bookToShow.author)"
        cell.imageView?.image = booksModel.imageStatus(bookToShow)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            booksModel.deleteBook(booksArray: booksInPlace.reversed(), indexPath: indexPath)
            booksInPlace.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            setTitle()
        }
    }
    
    // MARK: - Functions
    
    func setTitle() {
        if let place = place {
            title = "\(place.rawValue) (\(booksInPlace.count) registros)"
        }
    }
    
    @objc func searchBook() {
        if let vc = storyboard?.instantiateViewController(identifier: "SearchTable") as? SearchTableViewController {
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func newBook() {
        if let vc = storyboard?.instantiateViewController(identifier: "NewBook") as? NewBookViewController {
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func showNextPlace() {
        guard let place = place,
              let index = Place.allCases.firstIndex(of: place) else { return }
        if (index + 1) < Place.allCases.count {
            self.place = Place.allCases[index + 1]
            booksInPlace = booksModel.booksInPlace(place: self.place!)
            setTitle()
            tableView.reloadData()
        }
    }
    
    @objc func showPrevPlace() {
        guard let place = place,
              let index = Place.allCases.firstIndex(of: place) else { return }
        if (index - 1) >= 0 {
            self.place = Place.allCases[index - 1]
            booksInPlace = booksModel.booksInPlace(place: self.place!)
            setTitle()
            tableView.reloadData()
        }
    }
    
    @objc func showStatistcs() {
        if let vc = storyboard?.instantiateViewController(identifier: "Statistics") as? StatisticsViewController {
            vc.placeToShow = place
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc = segue.destination as? DetailTableViewController,
              let indexPath = tableView.indexPathForSelectedRow,
              let place = place else { return }
        
        vc.bookDetail = booksModel.queryBook(place: place, indexPath: indexPath)
    }

    
}
