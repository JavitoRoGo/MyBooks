//
//  CollectionViewController.swift
//  MyBooks
//
//  Created by Javier Rodríguez Gómez on 3/6/21.
//

import UIKit

class CollectionViewController: UICollectionViewController {
        
    // MARK: - UI view

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Lecturas (\(readingDataModel.totalReadingDatas) registros)"
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Menú", style: .plain, target: self, action: #selector(optionMenu))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        navigationController?.isNavigationBarHidden = false
        navigationController?.isToolbarHidden = true
        
        collectionView.reloadData()
    }

    // MARK: - UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return readingDataModel.numSections
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return readingDataModel.numBooksPerYear(section: section)
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "zelda", for: indexPath) as? BookCell else { fatalError() }
        
        let book = readingDataModel.queryReadingData(indexPath: indexPath)
        let coverName = book.cover
        cell.coverOutlet.image = readingDataModel.getCoverImage(cover: coverName)
        return cell
    }
    
    // MARK:- Functions
    
    @objc func optionMenu() {
        let ac = UIAlertController(title: "Elige una opción:", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        ac.addAction(UIAlertAction(title: "Buscar", style: .default) { _ in self.searchButton() })
        ac.addAction(UIAlertAction(title: "Añadir nuevo", style: .default) { _ in self.addNew() })
        ac.addAction(UIAlertAction(title: "Ver gráfica resumen", style: .default) { _ in self.showChart() })
        present(ac, animated: true)
    }
    
    func searchButton() {
        if let vc = storyboard?.instantiateViewController(identifier: "SearchGridReadingData") as? SearchCollectionViewController {
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func addNew() {
        if let vc = storyboard?.instantiateViewController(identifier: "AddReadingData") as? RDNewTableViewController {
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func showChart() {
        if let vc = storyboard?.instantiateViewController(identifier: "RDCharts") as? RDChartViewController {
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeader", for: indexPath) as? HeaderForCollection {
            sectionHeader.sectionHeaderLabel.text = "\(readingDataModel.sectionName(section: indexPath.section))"
            return sectionHeader
        }
        return UICollectionReusableView()
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc = segue.destination as? RDDetailTableViewController,
              let indexPath = collectionView.indexPathsForSelectedItems else { return }
        
        vc.readingDataDetail = readingDataModel.queryReadingData(indexPath: indexPath[0])
    }
}
