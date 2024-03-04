//
//  ViewController.swift
//  MyBooks
//
//  Created by Javier Rodríguez Gómez on 21/5/21.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var button1Outlet: UIButton?
    @IBOutlet weak var button2Outlet: UIButton?
    @IBOutlet weak var button3Outlet: UIButton?
    
    // MARK: - UI view
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        button1Outlet?.setTitle("Biblioteca", for: .normal)
        button2Outlet?.setTitle("Registros de lectura", for: .normal)
        button3Outlet?.setTitle("eBooks", for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        navigationController?.isNavigationBarHidden = true
        navigationController?.isToolbarHidden = true
    }
    
    
    @IBAction func button2Action(_ sender: Any) {
        let ac = UIAlertController(title: "Elige un modo de vista:", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        ac.addAction(UIAlertAction(title: "Listado", style: .default) { _ in
            if let vc = self.storyboard?.instantiateViewController(identifier: "ReadingData") as? RDTableViewController {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        })
        ac.addAction(UIAlertAction(title: "Portadas", style: .default) { _ in
            if let vc = self.storyboard?.instantiateViewController(identifier: "GridReadingData") as? CollectionViewController {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        })
        present(ac, animated: true)
    }
    @IBAction func prueba(_ sender: Any) {
        if let vc = storyboard?.instantiateViewController(identifier: "RDCharts") as? RDChartViewController {
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
