//
//  SearchEBookTableViewController.swift
//  MyBooks
//
//  Created by Javier Rodríguez Gómez on 20/6/21.
//

import UIKit

class SearchEBookTableViewController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate {
    
    var eBooksToShow = [EBooks]()
    
    // MARK: - UI view

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Resultados de la búsqueda"
        navigationItem.largeTitleDisplayMode = .never
        
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.searchBar.placeholder = "Escribe el texto a buscar"
        navigationItem.searchController = search
        
        navigationItem.hidesSearchBarWhenScrolling = false
        search.obscuresBackgroundDuringPresentation = false
        
        search.searchBar.scopeButtonTitles = ["Título", "Autor", "Estado"]
        search.searchBar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        navigationController?.isNavigationBarHidden = false
        navigationController?.isToolbarHidden = true
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "\(eBooksToShow.count) encontrados"
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        eBooksToShow.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "zelda", for: indexPath)
        let eBook = eBooksToShow[indexPath.row]
        cell.textLabel?.text = eBook.bookTitle
        cell.detailTextLabel?.text = eBook.author
        cell.imageView?.image = eBooksModel.imageStatus(eBook)
        return cell
    }
    
    // MARK: - Functions
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text?.lowercased() else { return }
        let scope = searchController.searchBar.selectedScopeButtonIndex
        eBooksToShow = eBooksModel.searchEBook(text: text, scope: scope)
        tableView.reloadData()
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc = segue.destination as? DetailEBookTableViewController,
              let indexPath = tableView.indexPathForSelectedRow else { return }
        vc.eBookDetail = eBooksToShow[indexPath.row]
    }
    
}
