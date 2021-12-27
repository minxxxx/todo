//
//  SearchMemberController.swift
//  MusicRoom
//
//  Created by Etienne TRANCHIER on 11/28/18.
//  Copyright © 2018 Etienne Tranchier. All rights reserved.
//

import UIKit

class SearchMemberController: UITableViewController{
    var searchController : UISearchController!
    
    var dataUsers : [(User,Bool)] = []
    var filteredData : [(User,Bool)] = []
    var root : EventDetailController?
    var admins : Bool?
    var event : Event? {
        didSet {
            if let _ = event {
                apiManager.getAllUsers("", completion: { (res) in
                    
                        res.forEach({ (user) in
                            if (self.members != nil && (self.members?.index(where: { (ur) -> Bool in
                                return user.id == ur.id
                            })) != nil) {
                                self.dataUsers.append((user, true))
                            } else {
                                self.dataUsers.append((user, false))
                            }
                        })
                        self.filteredData = self.dataUsers
                        self.tableView.reloadData()
                })
            }
        }
    }
    var members : [User]?
    
    @objc func updateEvent() {
        let ret = dataUsers.filter({ (user, bool) -> Bool in
            return bool
        })
        let bis : [User] = ret.map({ (user, bool) -> User in
            return user
        })
        if admins! {
            event!.adminMembers = bis
        } else {
            event!.members = bis
        }
        root!.addMembersAdmins(event!)
        self.navigationController?.popViewController(animated: true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(white: 0.1, alpha: 1)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
        tableView.backgroundColor = UIColor(white: 0.1, alpha: 1)
        tableView.allowsMultipleSelection = true
        tableView.separatorStyle = .none
        let button = UIButton()
        button.setAttributedTitle(NSAttributedString(string: "Save", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white]), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        button.addTarget(self, action: #selector(updateEvent), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        
        searchController.searchBar.sizeToFit()
        searchController.searchBar.showsCancelButton = false
        searchController.hidesNavigationBarDuringPresentation = false
        self.navigationItem.titleView = searchController.searchBar
        definesPresentationContext = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        cell.textLabel!.text = filteredData[indexPath.row].0.login
        cell.textLabel?.textColor = .white
        cell.selectionStyle = .none
        cell.isSelected = filteredData[indexPath.row].1
        if cell.isSelected {
            cell.backgroundColor = UIColor.green
        } else {
            cell.backgroundColor = UIColor(white: 0.1, alpha: 1)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        let userSelected = filteredData[indexPath.row].0
        cell?.isSelected = true
        cell?.backgroundColor = UIColor.green
        let toChange = dataUsers.index { (user, bool) -> Bool in
            if user.id == userSelected.id {
                return true
            }
            return false
        }
        if toChange != nil {
            dataUsers[toChange!].1 = true
            filteredData[indexPath.row].1 = true
        }
    }
    
    override func tableView(_ tableView : UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        let userSelected = filteredData[indexPath.row].0
        cell?.isSelected = false
        cell?.backgroundColor = UIColor(white: 0.1, alpha: 1)
        let toChange = dataUsers.index { (user, bool) -> Bool in
            if user.id == userSelected.id {
                return true
            }
            return false
        }
        if toChange != nil {
            dataUsers[toChange!].1 = false
            filteredData[indexPath.row].1 = false
        }
    }
}

extension SearchMemberController : UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.updateSearchResults(for: self.searchController)
    }
}

extension SearchMemberController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            if !searchText.isEmpty {
                apiManager.getAllUsers(searchText, completion: { (res) in
                    self.filteredData = []
                    res.forEach({ (user) in
                        if (self.members != nil && (self.members?.index(where: { (ur) -> Bool in
                            return user.id == ur.id
                        })) != nil) {
                            self.filteredData.append((user, true))
                        } else {
                            self.filteredData.append((user, false))
                        }
                    })
                    self.tableView.reloadData()
                })
            }
            else {
                filteredData = dataUsers
                tableView.reloadData()
            }
        }
    }
}

