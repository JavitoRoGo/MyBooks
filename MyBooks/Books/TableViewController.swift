//
//  TableViewController.swift
//  MyBooks
//
//  Created by Javier Rodríguez Gómez on 2/5/21.
//

import UIKit

// Conecta el Modelo con ViewController
var booksModel = BooksModel()

class TableViewController: UITableViewController {
    
    // MARK: - UI view
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Biblioteca (\(booksModel.totalBooks) registros)"
        navigationController?.navigationBar.prefersLargeTitles = false
        
        let myBarButton1 = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(newBook))
        let myBarButton2 = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchBook))
        navigationItem.rightBarButtonItems = [myBarButton1, myBarButton2]
        
        // esto crea un botón de edición en la propia barra de navegación (comentado porque no interesa de momento)
        //self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        navigationController?.isNavigationBarHidden = false
        navigationController?.isToolbarHidden = true
        
        title = "Biblioteca (\(booksModel.totalBooks) registros)"
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        booksModel.numOfPlaces()
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "zelda", for: indexPath)
        let num = booksModel.numBooksAtPlace(indexPath: indexPath)
        cell.textLabel?.text = booksModel.placeName(indexPath: indexPath)
        cell.detailTextLabel?.text = "\(num) libros"
        return cell
    }
    
    // MARK: - Functions
    
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
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc = segue.destination as? PlaceDetailTableViewController,
              let indexPath = tableView.indexPathForSelectedRow else { return }
        let place = Place.allCases.reversed()[indexPath.row]
        vc.place = place
        vc.booksInPlace = booksModel.booksInPlace(place: place)
    }

}
