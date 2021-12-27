//
//  SearchController.swift
//  MusicRoom
//
//  Created by jdavin on 11/14/18.
//  Copyright © 2018 Etienne Tranchier. All rights reserved.
//

import UIKit

class SearchController: UITableViewController {
    
    let manager = APIManager()
    var initialSearch = "Who"
    
    var albums: [Album] = []
    var tracks: [Track] = []
    var artists: [Artist] = []
    
    private let blankCellId = "blankCellId"
    private let searchCellId = "searchCellId"
    private let albumCellId = "albumCellId"
    private let trackCellId = "trackCellId"
    private let artistCellId = "artistCellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.backgroundColor = UIColor(white: 0.1, alpha: 1)
        tableView.separatorStyle = .none
        tableView.contentInset = .init(top: 0, left: 0, bottom: 59, right: 0)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: blankCellId)
        tableView.register(SearchBarCell.self, forCellReuseIdentifier: searchCellId)
        
        tableView.register(SearchAlbumCell.self, forCellReuseIdentifier: albumCellId)
        tableView.register(SearchTrackCell.self, forCellReuseIdentifier: trackCellId)
        tableView.register(SearchArtistCell.self, forCellReuseIdentifier: artistCellId)
        searchAll(initialSearch)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadRows(at: [IndexPath(row: 2, section: 0)], with: .none)
    }
    
    func searchAll(_ text: String) {
        manager.searchAlbums(text) { (albums) in
            self.albums = albums
            self.tableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .automatic)
            self.manager.searchTracks(text) { (tracks) in
                self.tracks = tracks
                self.tableView.reloadRows(at: [IndexPath(row: 2, section: 0)], with: .automatic)
                self.manager.searchArtists(text, completion: { (artists) in
                    self.artists = artists
                    self.tableView.reloadRows(at: [IndexPath(row: 3, section: 0)], with: .automatic)
                })
            }
        }
    }
    
    func handleSearch(_ text: String) {
        initialSearch = text
        albums.removeAll()
        tracks.removeAll()
        artists.removeAll()
        tableView.reloadData()
        searchAll(text)
    }
    
    func showPlayerForSong(_ index: Int) {
        playerController.isMasteringEvent = false
        (tabBarController as! TabBarController).showPlayerForSong(index, tracks: tracks)
    }
    
    func showAlbumContent(_ album: Album, _ albumCover: UIImage) {
        manager.getAlbumTracks(album) { (album) in
            let vc = AlbumController(album, albumCover)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func showArtistContent(_ artist: Artist, _ artistCover: UIImage) {
        print("show Artist")
    }
    
    func showTrackList() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let vc = SeeAllSongsController(tracks, "\"\(initialSearch)\" in Songs", layout: layout)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: searchCellId, for: indexPath) as! SearchBarCell
            cell.selectionStyle = .none
            cell.textField.placeholder = "artists, songs, or albums"
            cell.vc = self
            return cell
        } else if indexPath.row == 1, albums.count > 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: albumCellId, for: indexPath) as! SearchAlbumCell
            cell.rootTarget = self
            cell.selectionStyle = .none
            cell.albums = albums
            return cell
        } else if indexPath.row == 2, tracks.count > 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: trackCellId, for: indexPath) as! SearchTrackCell
            cell.rootTarget = self
            cell.selectionStyle = .none
            cell.tracks = tracks
            return cell
        } else if indexPath.row == 3, artists.count > 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: artistCellId, for: indexPath) as! SearchArtistCell
            cell.rootTarget = self
            cell.selectionStyle = .none
            cell.artists = artists
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: blankCellId, for: indexPath)
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height: CGFloat = 0
        if indexPath.row == 0 {
            height = 68
        } else if indexPath.row == 1, albums.count > 0 {
            height = 240
        } else if indexPath.row == 2, tracks.count > 0 {
            if tracks.count > 3 {
                height = 4 * 60 + 80
            } else {
                height = CGFloat(tracks.count * 60 + 80)
            }
        } else if indexPath.row == 3, artists.count > 0 {
            height = 185
        }
        return height
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
}
