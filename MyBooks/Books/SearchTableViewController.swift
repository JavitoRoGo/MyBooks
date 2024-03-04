//
//  SearchTableViewController.swift
//  MyBooks
//
//  Created by Javier Rodríguez Gómez on 7/5/21.
//

import UIKit

class SearchTableViewController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate {
    
    var booksToShow = [Books]()
    
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
        "\(booksToShow.count) encontrados"
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        booksToShow.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "zelda", for: indexPath)
        let book = booksToShow[indexPath.row]
        cell.textLabel?.text = book.bookTitle
        cell.detailTextLabel?.text = book.author
        cell.imageView?.image = booksModel.imageStatus(book)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            booksModel.deleteBook(booksArray: booksToShow, indexPath: indexPath)
            booksToShow.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // MARK: - Functions
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text?.lowercased() else { return }
        let scope = searchController.searchBar.selectedScopeButtonIndex
        booksToShow = booksModel.searchBook(text: text, scope: scope)
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        // devuelve selectedScope como Int, 0 para Título, 1 para Autor y 2 para Situación
        // se accede a este Int dentro de la función anterior con searchController.searchBar.selectedScopeButtonIndex
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc = segue.destination as? DetailTableViewController,
              let indexPath = tableView.indexPathForSelectedRow else { return }
        vc.bookDetail = booksToShow[indexPath.row]
    }

}
