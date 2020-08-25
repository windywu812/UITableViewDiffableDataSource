//
//  ViewController.swift
//  UITableViewDiffableDataSource
//
//  Created by Windy on 20/08/20.
//  Copyright © 2020 Windy. All rights reserved.
//

import UIKit

enum SectionType {
    case main
}

struct Contact: Hashable, Identifiable {
    let id = UUID()
    let name: String?
    let number: String?
}

class ViewController: UITableViewController, UISearchResultsUpdating {

    private var dataSource: UITableViewDiffableDataSource<SectionType, Contact>!
    
    typealias DataSnapshot = NSDiffableDataSourceSnapshot<SectionType, Contact>
    
    var contacts = [
        Contact(name: "Rudi Hartono", number: "+62-823-5554-44"),
        Contact(name: "Jono Situmorang", number: "+62-843-5421-60"),
        Contact(name: "Zamira Andriani", number: "+62-865-8446-07"),
        Contact(name: "Ramanta Susfa", number: "+62-897-8324-24"),
        Contact(name: "Mohamad Riahdita", number: "+62-864-7425-55"),
        Contact(name: "Finaldi Tobing", number: "+62-835-8765-14"),
        Contact(name: "Anas Pasha", number: "+62-832-4824-44"),
        Contact(name: "Yosafat Sobirin", number: "+62-812-4723-63"),
        Contact(name: "Satrya Fudhail", number: "+62-867-3456-82"),
        Contact(name: " Gusti Saury", number: "+62-878-6273-24")
    ]
    
    var filter: [Contact] = []
    
    var searchController: UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.title = "Contacts"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "cell")
        configureDataSource()
        applySnapshot()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleAdd))
        navigationItem.leftBarButtonItem = editButtonItem
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            if !searchText.isEmpty {
                contacts.forEach { (contact) in
                    if contact.name?.contains(searchText) == true {
                        filter.append(contact)
                    }
                }
                var dataSnapshot = DataSnapshot()
                dataSnapshot.appendSections([.main])
                dataSnapshot.appendItems(filter)
                dataSource.apply(dataSnapshot, animatingDifferences: true)
                filter.removeAll()
            } else {
                applySnapshot()
            }
        }
    }
    
    @objc private func handleAdd() {
        contacts.append(Contact(name: "Test", number: "Test"))
        applySnapshot()
    }
    
    private func configureDataSource() {
        dataSource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { (tableView, indexpath, user) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexpath) as UITableViewCell
            cell.textLabel?.text = user.name
            cell.detailTextLabel?.text = user.number
            return cell
        })
    }
    
    private func applySnapshot() {
        var dataSnapshot = DataSnapshot()
        dataSnapshot.appendSections([.main])
        dataSnapshot.appendItems(contacts)
        dataSource.apply(dataSnapshot, animatingDifferences: true)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

class CustomTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
