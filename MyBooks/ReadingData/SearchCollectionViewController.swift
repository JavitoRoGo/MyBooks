//
//  SearchCollectionViewController.swift
//  MyBooks
//
//  Created by Javier Rodríguez Gómez on 6/6/21.
//

import UIKit

class SearchCollectionViewController: UICollectionViewController, UISearchResultsUpdating, UISearchBarDelegate {
    
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
    
    // MARK: - UI collection view data source
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return readingDataToShow.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "zelda", for: indexPath) as? BookCell else { fatalError() }
        
        let book = readingDataToShow[indexPath.item]
        cell.coverOutlet.image = UIImage(named: book.cover)
        return cell
    }
    
    // MARK: - Functions
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text?.lowercased() else { return }
        let scope = searchController.searchBar.selectedScopeButtonIndex
        readingDataToShow = readingDataModel.searchReadingData(text: text, scope: scope)
        collectionView.reloadData()
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeader", for: indexPath) as? HeaderForCollection {
            sectionHeader.sectionHeaderLabel.text = "\(readingDataToShow.count) encontrados"
            return sectionHeader
        }
        return UICollectionReusableView()
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc = segue.destination as? RDDetailTableViewController,
              let indexPath = collectionView.indexPathsForSelectedItems else { return }
        
        vc.readingDataDetail = readingDataToShow[indexPath[0].item]
    }

    
}
