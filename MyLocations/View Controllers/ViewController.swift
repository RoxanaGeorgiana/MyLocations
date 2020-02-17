//
//  ViewController.swift
//  MyLocations
//
//  Created by Puf, Roxana on 15/02/2020.
//  Copyright © 2020 Puf, Roxana. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController, LocationDetailsProtocol {
    
    let tableview: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = UIColor.white
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "My Locations"
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont.boldSystemFont(ofSize: 20)
        lbl.textAlignment = .center
        return lbl
    }()
    
    private let addButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Add new location", for: .normal)
        btn.titleLabel?.textAlignment = .center
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        btn.addTarget(self, action: #selector(addNewLocation(_:)), for: .touchUpInside)
        return btn
    }()
    
    private var locations = [Object]()
    private let cellIdentifier = "LocationCell"
    private let cellHeight: CGFloat = 90.0
    let backgroundColor = UIColor(red: 235/255, green: 96/255, blue: 91/255, alpha: 1)
    
    var realmManager : RealmManager = RealmManager()
    var headerHeightConstraint:NSLayoutConstraint!
    
    override func loadView() {
      
        super.loadView()
        view.backgroundColor = backgroundColor
        tableview.backgroundColor = backgroundColor
        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(LocationCell.self, forCellReuseIdentifier: cellIdentifier)
        
        view.addSubview(tableview)
        view.addSubview(titleLabel)
        view.addSubview(addButton)
        setupSubviewsConstraints()

        locations = realmManager.fetchAllObjects(Location.self)
    }
    
    func setupSubviewsConstraints() {
        let constraints:[NSLayoutConstraint] = [
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 40),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 30),
            
            addButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            addButton.heightAnchor.constraint(equalToConstant: 40),
            
            tableview.topAnchor.constraint(equalTo: addButton.bottomAnchor),
            tableview.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableview.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableview.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func showDetailsViewController(_ location: Location?, isEditable: Bool, isNewLocation: Bool) {
        let locationDetails = LocationDetailsViewController(editable: isEditable, newLocation: isNewLocation)
        locationDetails.location = location
        locationDetails.delegate = self
        show(locationDetails, sender: tableview)
    }
    
    @objc func addNewLocation(_ sender: UIButton) {
        showDetailsViewController(nil, isEditable: false, isNewLocation: true)
    }
    
    func updateLocationChanges() {
        locations = realmManager.fetchAllObjects(Location.self)
        tableview.reloadData()
    }
}

// UITableView delegates

extension ViewController: UITableViewDelegate,  UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
 
        let cell: LocationCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! LocationCell
        cell.location = locations[indexPath.row] as? Location
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showDetailsViewController(locations[indexPath.row] as? Location, isEditable:false, isNewLocation: false)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteItem = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
            self.realmManager.delete(self.locations[indexPath.row])
            self.locations.remove(at: indexPath.row)
            self.tableview.beginUpdates()
            self.tableview.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
            self.tableview.endUpdates()
        }
        
        let editItem = UIContextualAction(style: .normal, title: "Edit") { _, _, _ in
            self.showDetailsViewController(self.locations[indexPath.row] as? Location, isEditable: true, isNewLocation: false)
        }
        
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteItem, editItem])

        return swipeActions
    }
}
