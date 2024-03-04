//
//  RDSearchTableViewController.swift
//  MyBooks
//
//  Created by Javier Rodríguez Gómez on 11/5/21.
//

import UIKit

class RDSearchTableViewController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate {
    
    var readingDataToShow = [ReadingData]()
    
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
        
        search.searchBar.scopeButtonTitles = ["Título", "Formato", "Valoración"]
        search.searchBar.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
                
        navigationController?.isNavigationBarHidden = false
        navigationController?.isToolbarHidden = true
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "\(readingDataToShow.count) encontrados"
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        readingDataToShow.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "zelda", for: indexPath)
        cell.textLabel?.text = readingDataToShow[indexPath.row].bookTitle
        return cell
    }
    
    // MARK: - Functions
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text?.lowercased() else { return }
        let scope = searchController.searchBar.selectedScopeButtonIndex
        readingDataToShow = readingDataModel.searchReadingData(text: text, scope: scope)
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc = segue.destination as? RDDetailTableViewController,
              let indexPath = tableView.indexPathForSelectedRow else { return }
        
        vc.readingDataDetail = readingDataToShow[indexPath.row]
    }
    
}
