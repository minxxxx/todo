//
//  ListFriendsToAdd.swift
//  MusicRoom
//
//  Created by Jonathan DAVIN on 12/10/18.
//  Copyright © 2018 Etienne Tranchier. All rights reserved.
//

import UIKit

class ListFriendsToAdd: UITableViewController {
    var searchController : UISearchController!
    
    var dataUsers : [(User,Bool)] = []
    var filteredData : [(User,Bool)] = []
    let root : PlaylistDetailController
    var playlist: Playlist
    var members: [User] = []
    
    @objc func updatePlaylist() {
        members.removeAll()
        dataUsers.forEach { (user, bool) in
            if bool == true {
                members.append(user)
            }
        }
        playlist.members = members
        apiManager.updatePlaylist(playlist) { (err) in
            self.root.playlist = self.playlist
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    init(playlist: Playlist, root: PlaylistDetailController) {
        self.playlist = playlist
        self.root = root
        self.members = playlist.members != nil ? playlist.members! : []
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        apiManager.getAllUsers("", completion: { (res) in
            res.forEach({ (user) in
                if ((self.members.index(where: { (ur) -> Bool in
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
        
        view.backgroundColor = UIColor(white: 0.1, alpha: 1)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
        tableView.backgroundColor = UIColor(white: 0.1, alpha: 1)
        tableView.allowsMultipleSelection = true
        tableView.separatorStyle = .none
        let button = UIButton()
        button.setAttributedTitle(NSAttributedString(string: "Save", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white]), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        button.addTarget(self, action: #selector(updatePlaylist), for: .touchUpInside)
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
        cell.setSelected(filteredData[indexPath.row].1, animated: true)
        if cell.isSelected {
            cell.backgroundColor = UIColor(red: 40 / 255, green: 210 / 255, blue: 40 / 255, alpha: 1)
        } else {
            cell.backgroundColor = UIColor(white: 0.1, alpha: 1)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        let userSelected = filteredData[indexPath.row].0
        cell?.setSelected(true, animated: true)
        cell?.backgroundColor = UIColor(red: 40 / 255, green: 210 / 255, blue: 40 / 255, alpha: 1)
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
        cell?.setSelected(false, animated: true)
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


extension ListFriendsToAdd : UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.updateSearchResults(for: self.searchController)
    }
}

extension ListFriendsToAdd : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            if !searchText.isEmpty {
                apiManager.getAllUsers(searchText, completion: { (res) in
                    self.filteredData = []
                    res.forEach({ (user) in
                        if ((self.members.index(where: { (ur) -> Bool in
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


