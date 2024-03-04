//
//  RDTableViewController.swift
//  MyBooks
//
//  Created by Javier Rodríguez Gómez on 10/5/21.
//

import UIKit

var readingDataModel = ReadingDataModel()

class RDTableViewController: UITableViewController {
    
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
        
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        readingDataModel.numSections
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        readingDataModel.sectionName(section: section)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        readingDataModel.numBooksPerYear(section: section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "zelda", for: indexPath)
        let dataToShow = readingDataModel.queryReadingData(indexPath: indexPath)
        cell.textLabel?.text = dataToShow.bookTitle
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            readingDataModel.deleteReadingData(indexPath: indexPath)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
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
        if let vc = storyboard?.instantiateViewController(identifier: "SearchReadingData") as? RDSearchTableViewController {
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

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc = segue.destination as? RDDetailTableViewController,
              let indexPath = tableView.indexPathForSelectedRow else { return }
        
        vc.readingDataDetail = readingDataModel.queryReadingData(indexPath: indexPath)
    }

}
