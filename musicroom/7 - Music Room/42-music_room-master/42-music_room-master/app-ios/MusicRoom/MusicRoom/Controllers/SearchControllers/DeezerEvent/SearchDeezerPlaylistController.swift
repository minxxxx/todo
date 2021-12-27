//
//  SearchDeezerPlaylistController.swift
//  MusicRoom
//
//  Created by Etienne TRANCHIER on 12/4/18.
//  Copyright © 2018 Etienne Tranchier. All rights reserved.
//

import UIKit

class SearchDeezerPlaylistController: UITableViewController {
    var searchController : UISearchController!
    var data : [SPlaylist] = []
    var root : PlaylistsController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(white: 0.1, alpha: 1)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
        tableView.backgroundColor = UIColor(white: 0.1, alpha: 1)
        tableView.allowsMultipleSelection = true
        tableView.separatorStyle = .none
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        
        searchController.searchBar.sizeToFit()
        searchController.searchBar.showsCancelButton = false
        searchController.hidesNavigationBarDuringPresentation = false
        self.navigationItem.titleView = searchController.searchBar
        definesPresentationContext = true
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selected = data[indexPath.row]
        let id = selected.id != nil ? String(describing: selected.id!) : selected._id!
        apiManager.createPlaylist("id=" + id, self.root)
        self.navigationController?.popViewController(animated: true)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return data.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        cell.textLabel!.text = data[indexPath.row].title
        cell.textLabel?.textColor = .white
        cell.backgroundColor = UIColor(white: 0.1, alpha: 1)
        cell.selectionStyle = .none
        return cell
    }
}

extension SearchDeezerPlaylistController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            if !searchText.isEmpty {
                apiManager.searchPlaylists(searchText, completion: { res in
                    self.data = res
                    self.tableView.reloadData()
                })
                
            }
        }
    }
}

