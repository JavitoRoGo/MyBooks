//
//  EBookTableViewController.swift
//  MyBooks
//
//  Created by Javier Rodríguez Gómez on 20/6/21.
//

import UIKit

var eBooksModel = EBooksModel()

class EBookTableViewController: UITableViewController {
    
    // MARK: - UI view

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = false
        
        let myBarButton1 = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(newEBook))
        let myBarButton2 = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchEBook))
        navigationItem.rightBarButtonItems = [myBarButton1, myBarButton2]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        navigationController?.isNavigationBarHidden = false
        navigationController?.isToolbarHidden = true
        
        tableView.reloadData()
        title = "eBooks (\(eBooksModel.totalEBooks) registros)"
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        eBooksModel.totalEBooks
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "zelda", for: indexPath)
        let eBook = eBooksModel.queryEBook(indexPath: indexPath)
        cell.textLabel?.text = eBook.bookTitle
        cell.detailTextLabel?.text = eBook.author
        cell.imageView?.image = eBooksModel.imageStatus(eBook)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            eBooksModel.deleteEBook(indexPath: indexPath)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // MARK: - Functions
    
    @objc func searchEBook() {
        if let vc = storyboard?.instantiateViewController(identifier: "SearchEBook") as? SearchEBookTableViewController {
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func newEBook() {
        if let vc = storyboard?.instantiateViewController(identifier: "AddEBook") as? NewEBookTableViewController {
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc = segue.destination as? DetailEBookTableViewController,
              let indexPath = tableView.indexPathForSelectedRow else { return }
        vc.eBookDetail = eBooksModel.queryEBook(indexPath: indexPath)
    }

}
