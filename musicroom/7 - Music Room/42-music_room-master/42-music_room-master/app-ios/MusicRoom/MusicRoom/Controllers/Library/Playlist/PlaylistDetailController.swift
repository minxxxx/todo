//
//  PlaylistDetailController.swift
//  MusicRoom
//
//  Created by Jonathan DAVIN on 11/21/18.
//  Copyright © 2018 Etienne Tranchier. All rights reserved.
//

import UIKit
import CoreLocation


var likedTracks : [String] = []
class PlaylistDetailController: UITableViewController {
    var locationManager : CLLocationManager?
    var playlist: Playlist
    var tracks: [Track]
    let playlistCover: UIImage
    var isUnlocked = true
    var isEditable = false
    var headerView: AlbumHeaderView!
    let songCellId = "SongCellId"
    var iAmMember : Bool = false
    var iAmAdmin : Bool = false
    var type : EventType = .others
    var isInEvent : Bool = false
    var event: Event?
    
    private let headerHeight: CGFloat = 225
    
    init(_ playlist: Playlist, _ playlistCover: UIImage) {
        self.playlist = playlist
        self.playlistCover = playlistCover
        self.tracks = playlist.tracks != nil ? playlist.tracks!.data : []
        super.init(nibName: nil, bundle: nil)
    }
    
    init(_ playlist: Playlist, _ playlistCover: UIImage, isInEvent: Bool, _ iAmMember: Bool, _ iAmAdmin: Bool, _ type: EventType) {
        self.isInEvent = isInEvent
        self.iAmMember = iAmMember
        self.iAmAdmin = iAmAdmin
        self.type = type
        self.playlist = playlist
        self.playlistCover = playlistCover
        self.tracks = playlist.tracks != nil ? playlist.tracks!.data : []
        super.init(nibName: nil, bundle: nil)
    }
    
    func toggleLike(id : String)  {
        
        guard locationManager!.location != nil else { return }
        let exist = likedTracks.first { (tid) -> Bool in
            return tid == id ? true : false
        }
        if exist != nil {
            likedTracks.remove(at: likedTracks.index(of: exist!)!)
            likeTrack(trackID: id, points: -1)
        } else {
            likedTracks.append(id)
            
            likeTrack(trackID: id, points: 1)
        }
        tableView.reloadData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupSocket() {
        SocketIOManager.sharedInstance.joinPlayList(playlist._id!)
        SocketIOManager.sharedInstance.listenToTracksChanges { (tracks) in
            if let t = tracks {
                self.tracks = t
                self.tableView.reloadData()
            }
        }
        SocketIOManager.sharedInstance.listenToPlaylistChanges(playlist._id!) { (resp, playlist, tracks, id) in
            if id != nil {
                guard let track = self.tracks.first(where: { (tr) -> Bool in
                    return tr._id! == id!
                }) else { return }
                if currentTrack != nil {
                    currentTrack?.id = track.id
                    
                } else {
                    let track = Track(id: track.id, _id: track._id != nil ? track._id : "", readable: true, link: "plapla", album: nil, status: 0, artist: nil, title: "bite", duration: 111)
                    currentTrack = track
                }
                self.tableView.reloadData()
                return
            }
            else if tracks != nil {
                print("hellow!")
                self.tracks = tracks!
                self.playlist.tracks?.data = tracks!
                self.tableView.reloadData()
                if self.isUnlocked == false {
                    self.unlockPlaylist(playlist)
                }
                return
            }
            else if playlist != nil {
                self.playlist = playlist!
                self.tracks = playlist!.tracks!.data
                self.tableView.reloadData()
                return
            }
            else if resp == 0 {
                self.lockPlaylist()
            } else {
                self.unlockPlaylist(playlist)
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let navi = navigationController as? CustomNavigationController
        navi?.animatedHideNavigationBar()
        navigationController?.navigationBar.topItem?.title = ""
        if playlist._id == nil {
            apiManager.getDeezerPlaylistById(playlist.id!, completion: { (playlist) in
                self.playlist = playlist
                self.tracks = playlist.tracks!.data
                self.tableView.reloadData()
            })
        }
        else {
            setupSocket()
        }
        
    }
    
    private func lockPlaylist() {
        isUnlocked = false
        tableView.reloadData()
    }
    
    private func unlockPlaylist(_ playlist: Playlist?) {
        guard self.tracks.count > 0, let album = self.tracks[0].album, let imageURL = album.cover_medium else { return }
        UIImageView().getImageUsingCacheWithUrlString(urlString: imageURL) { (image) in
            self.headerView.albumImageBackground.image = image
            self.headerView.albumImageView.image = image
        }
        isUnlocked = true
        tableView.isEditing = false
        tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isInEvent {
            currentTrack = nil
        }
        let navi = navigationController as? CustomNavigationController
        navi?.animatedShowNavigationBar()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        updateHeaderView()
        let navi = navigationController as? CustomNavigationController
        if tableView.contentOffset.y < -90 {
            navi?.animatedHideNavigationBar()
        } else {
            navi?.animatedShowNavigationBar()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateHeaderView()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let vc = MapController()
        addChildViewController(vc)
        vc.setupLocation()
        locationManager = vc.locationManager
        tableView.separatorStyle = .none
        
        tableView.backgroundColor = UIColor(white: 0.1, alpha: 1)
        tableView.alwaysBounceVertical = false
        
        setupHeader()
        if type == .mine && event != nil {
            event?.hasStarted = true
            apiManager.putEvent(event!, completion: { (true) in
                print("event started")
            })
        }
    }
    
    @objc func edit() {
        tableView.isEditing = isUnlocked
        tableView.reloadData()
        SocketIOManager.sharedInstance.lockPlaylist(playlist._id != nil ? playlist._id! : String(playlist.id!))
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .none
    }

    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObject = self.tracks[sourceIndexPath.row]
        tracks.remove(at: sourceIndexPath.row)
        tracks.insert(movedObject, at: destinationIndexPath.row)
        tableView.isEditing = false
        tableView.reloadData()
        playlist.tracks?.data = tracks
        SocketIOManager.sharedInstance.unlockPlaylist(playlist._id != nil ? playlist._id! : String(playlist.id!), playlist: playlist)
        tableView.reloadData()
        guard tracks.count > 0, let album = tracks[0].album, let imageURL = album.cover_medium else { return }
        UIImageView().getImageUsingCacheWithUrlString(urlString: imageURL) { (image) in
            self.headerView.albumImageBackground.image = image
            self.headerView.albumImageView.image = image
        }
        
    }
    
    func updateHeaderView() {
        var headerRect = CGRect(x: 0, y: -headerHeight, width: tableView.bounds.width, height: headerHeight)
        headerRect.origin.y = tableView.contentOffset.y
        headerRect.size.height = -tableView.contentOffset.y
        headerView.frame = headerRect
        headerView.titleBottomConstraint?.constant = -10 - headerRect.height + 288
    }
    
    fileprivate func setupHeader() {
        headerView = AlbumHeaderView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: headerHeight), albumCover: playlistCover, title: playlist.title)
        headerView.isUserInteractionEnabled = true
        headerView.playlistDetailController = self
        headerView.playlist = playlist
        headerView.isEditable = isEditable
        tableView.register(AlbumTrackListCell.self, forCellReuseIdentifier: songCellId)
        view.addSubview(headerView)
        headerView.layer.zPosition = -1
        tableView.contentInset = UIEdgeInsets(top: headerHeight, left: 0, bottom: 45, right: 0)
        tableView.contentOffset = CGPoint(x: 0, y: -headerHeight)
        updateHeaderView()
    }
    
    func displayFriendsList() {
        let vc = ListFriendsToAdd(playlist: playlist, root: self)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: songCellId, for: indexPath) as! AlbumTrackListCell
        cell.iAmAdmin = iAmAdmin
        cell.iAmMember = iAmMember
        cell.type = type
        cell.isInPlaylist = true
        cell.backgroundColor = UIColor(white: 0.1, alpha: 1)
        cell.rootController = self
        cell.track = tracks[indexPath.row]
        cell.authorLabel.text = tracks[indexPath.row].artist?.name
        cell.selectionStyle = .none
        
        
        
        
        cell.indexPath = indexPath
        cell.dotsLabel.isHidden = true
        cell.dotsLabel.isUserInteractionEnabled = false
        cell.lockedIcon.isHidden = true
        if iAmAdmin || type == .mine {
            cell.dotsLabel.isUserInteractionEnabled = true
            cell.dotsLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(edit)))
            if tableView.isEditing {
                cell.dotsLabel.isHidden = true
            } else if isUnlocked == false {
                cell.dotsLabel.isHidden = true
                cell.lockedIcon.isHidden = false
            } else {
                cell.dotsLabel.isHidden = false
                cell.lockedIcon.isHidden = true
            }
        }
        return cell
    }
    
    func likeTrack(trackID: String, points: Int) {
        apiManager.getEventById(eventID) { (event) in
            guard let location = self.locationManager!.location else { return }
            let coord = Coord(lat: location.coordinate.latitude, lng: location.coordinate.longitude)
            let like = TrackLike(trackId: trackID, userCoord : coord)
            apiManager.likeTracksEvent(eventID, like, completion: { ret in
                if ret {
                    SocketIOManager.sharedInstance.updateTrackScore(roomID: eventID, userCoord: coord)
                } else {
                    likedTracks.removeAll()
                    self.tableView.reloadData()
                }
            })
        }
        
        
    }
    
    func deleteTrackFromPlaylist(track: Track, index: IndexPath) {
        if !isInEvent || (type == .mine || iAmAdmin) {
            if playlist._id != nil {
                apiManager.deleteTrackFromPlaylist(String(describing: playlist._id!), track, target: self)
                tracks.remove(at: index.row)
                tableView.deleteRows(at: [index], with: .fade)
            } else {
                ToastView.shared.short(self.view, txt_msg: "Can't modify deezer playlist", color: UIColor.red)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard isInEvent == false || type == .mine else { return }
        if isInEvent {
            playerController.isMasteringEvent = true
        } else {
            playerController.isMasteringEvent = false
        }
        (tabBarController as? TabBarController)?.showPlayerForSong(indexPath.row, tracks: tracks)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
}
