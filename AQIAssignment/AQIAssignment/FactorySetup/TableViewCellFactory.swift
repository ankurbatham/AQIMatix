//
//  TableViewCellFactory.swift
//  AQIAssignment
//
//  Created by Ankur Batham on 24/11/21.
//

import UIKit

protocol TableViewCellFactory {
    associatedtype T
    func createTableViewCell(_ tableView: UITableView, for indexPath: IndexPath) -> T
}

class AQIInforCellFactory: TableViewCellFactory {
    typealias T = AQIInfoTableViewCell
    
    func createTableViewCell(_ tableView: UITableView, for indexPath: IndexPath) -> T {
        let cell: AQIInfoTableViewCell = tableView.dequeueReusableCell(withIdentifier: "AQIInfoTableViewCell", for: indexPath) as! AQIInfoTableViewCell
        return cell
    }
}
