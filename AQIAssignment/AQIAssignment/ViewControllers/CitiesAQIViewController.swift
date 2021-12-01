//
//  CitiesAQIViewController.swift
//  AQIAssignment
//
//  Created by Ankur Batham on 24/11/21.
//

import UIKit

class CitiesAQIViewController: UIViewController {
    @IBOutlet weak var citiesDataTableView: UITableView!
    
    var viewModel: CityAQIViewModel = CityAQIViewModel()
    var selectedIndex: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        self.title = "AQI Matrix"
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let index = self.selectedIndex {
            let element = viewModel.cityData[index.row]
            let graphViewModel = GraphAQIViewModel(with: element)
            if let controller = segue.destination as? CityGraphViewController {
                controller.viewModel = graphViewModel
            }
        }
        
    }
}

extension CitiesAQIViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(inSection: section)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSection()
    }
}

extension CitiesAQIViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: AQIInfoTableViewCell = AQIInforCellFactory().createTableViewCell(tableView, for: indexPath)
        cell.configurView(with: viewModel.cityData[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath
        self.performSegue(withIdentifier: "aqiGraphplot", sender: self)
    }
}

extension CitiesAQIViewController: AQIViewModelDelegate {
    func onDataDidupdate() {
        citiesDataTableView.reloadData()
    }
    
    func onDataUpdateFailed(error: Error) {
        
    }
}
