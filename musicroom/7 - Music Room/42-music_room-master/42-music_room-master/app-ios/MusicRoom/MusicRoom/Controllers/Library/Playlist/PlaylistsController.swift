//
//  PlaylistsController.swift
//  MusicRoom
//
//  Created by Etienne TRANCHIER on 12/7/18.
//  Copyright © 2018 Etienne Tranchier. All rights reserved.
//

import UIKit

class PlaylistsController: UITableViewController {
    var playlists : DataPlaylist?
    var firstLoad = true
    var isAddingSong = false
    var track: Track?
    var globalCount = 2
    private let playlistCellId = "playlistCellId"
    private let createCellId = "createCellId"
    private let defaultCellId = "defaultCellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(white: 0.1, alpha: 1)
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.register(ListPlaylistCell.self, forCellReuseIdentifier: playlistCellId)
        tableView.register(CreateButtonCell.self, forCellReuseIdentifier: createCellId)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: defaultCellId)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        title = ""
        navigationController?.navigationBar.topItem?.title = ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        title = "Playlists"
        navigationController?.navigationBar.topItem?.title = ""
        playlists?.myPlaylists?.removeAll()
        playlists?.friendPlaylists?.removeAll()
        tableView.reloadData()
        reloadPlaylists()
    }
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 2
        if let pl = playlists {
            if pl.myPlaylists?.count != 0  {
                count += 1
            }
            if pl.friendPlaylists?.count != 0 {
                count += 1
            }
        }
        globalCount = count
        return count
    }

    func reloadPlaylists() {
        apiManager.getPlaylists { (playlists) in
            self.playlists = playlists
            self.tableView.reloadData()
        }
    }
    
    func addSongToPlaylist(_ playlist: Playlist) {
        if let song = track {
            apiManager.addTrackToPlaylist(playlist._id!, song)
        }
        handleCancel()
    }
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    func createPlaylistPopUp() {
        let alert = UIAlertController(title: "Playlist creation", message: "What's your playlist's name?", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "playlist's name"
        }
        
        alert.addAction(UIAlertAction(title: "Create", style: .default, handler: { [weak alert] (_) in
            let textField = alert!.textFields![0]
            if let text = textField.text, text != "" {
                apiManager.createPlaylist("title=" + text, self)
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 && globalCount >= 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: playlistCellId, for: indexPath) as! ListPlaylistCell
            cell.isEditable = true
            cell.rootTarget = self
            cell.type = playlists?.myPlaylists?.count != 0 ? .mine : .friends
            cell.isAddingSong = isAddingSong
            cell.title = playlists?.myPlaylists?.count != 0 ? "My Playlists" : "Friends Playlists"
            cell.playlist = playlists?.myPlaylists?.count != 0 ? playlists?.myPlaylists : playlists?.friendPlaylists
            return cell
        } else if indexPath.row == 1 && globalCount == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: playlistCellId, for: indexPath) as! ListPlaylistCell
            cell.isEditable = false
            cell.rootTarget = self
            cell.type = .friends
            cell.isAddingSong = isAddingSong
            cell.title = "Friends Playlists"
            cell.playlist = playlists?.friendPlaylists
            return cell
        } else if indexPath.row == globalCount - 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: createCellId, for: indexPath) as! CreateButtonCell
            cell.isCreating = true
            cell.root = self
            cell.backgroundColor = UIColor(white: 0.1, alpha: 1)
            cell.createButton.backgroundColor = UIColor(red: 40 / 255, green: 180 / 255, blue: 40 / 255, alpha: 1)
            cell.title = "CREATE PLAYLIST"
            return cell
        }
        else if indexPath.row == globalCount - 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: createCellId, for: indexPath) as! CreateButtonCell
            cell.isCreating = false
            cell.root = self
            cell.backgroundColor = UIColor(white: 0.1, alpha: 1)
            cell.createButton.backgroundColor = UIColor(red: 100 / 255, green: 100 / 255, blue: 140 / 255, alpha: 1)
            cell.title = "IMPORT PLAYLIST"
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: defaultCellId, for: indexPath) as UITableViewCell
            cell.textLabel?.text = "DEFAULT"
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row >= globalCount - 2 {
            return 60
        }
        return 240
    }
}
