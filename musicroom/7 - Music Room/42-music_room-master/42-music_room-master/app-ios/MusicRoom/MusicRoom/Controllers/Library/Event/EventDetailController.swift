//
//  EventDetailController.swift
//  MusicRoom
//
//  Created by Jonathan DAVIN on 12/11/18.
//  Copyright © 2018 Etienne Tranchier. All rights reserved.
//

import UIKit

class EventDetailController: UITableViewController {
    
    var currentEvent : Event
    var headerView: AlbumHeaderView?
    
    private let descriptionCellId = "descriptionCellId"
    private let dateCellId = "dateCellId"
    private let libraryCellId = "libraryCellId"
    
    var root : EventsController?
    var rootMap : MapController?
    var type : EventType = .others
    var saveButton = UIButton()
    var iAmMember : Bool = false
    var iAmAdmin : Bool = false
    var me : User?
    
    private let headerHeight: CGFloat = 225
    
    
    init(_ event : Event) {
        currentEvent = event
        eventID = currentEvent._id!
        super.init(nibName: nil, bundle: nil)
        apiManager.getImgEvent(event.picture!) { (img) in
            guard let image = img else { return }
            if let crea = event.creator {
                self.headerView = AlbumHeaderView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.headerHeight), albumCover: image, title: "\(event.title) by \(crea.login)")
            } else {
                self.headerView = AlbumHeaderView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.headerHeight), albumCover: image, title: "\(event.title)")
            }
            self.setupView()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let navi = navigationController as? CustomNavigationController
        if currentTrack != nil && currentTrack?.album != nil { playerController.handlePause() }
        (UIApplication.shared.keyWindow?.rootViewController as? TabBarController)?.minimizedPlayer.isUserInteractionEnabled = false
        playerController.view.isUserInteractionEnabled = false
        (UIApplication.shared.keyWindow?.rootViewController as? TabBarController)?.minimizedPlayer.titleLabel.text = "live event"
        (UIApplication.shared.keyWindow?.rootViewController as? TabBarController)?.minimizedPlayer.authorLabel.text = "\(currentEvent.title)"
        
        navi?.animatedHideNavigationBar()
        navigationController?.navigationBar.topItem?.title = ""
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        tableView.backgroundColor = UIColor(white: 0.1, alpha: 1)
        tableView.separatorStyle = .none
        tableView.register(EventDescriptionCell.self, forCellReuseIdentifier: descriptionCellId)
        tableView.register(EventInteractionCell.self, forCellReuseIdentifier: libraryCellId)
        likedTracks.removeAll()
        loadMe()
        print(currentEvent.hasStarted)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row - 2 {
        case 0:
            let vc = SearchMemberController()
            vc.root = self
            vc.event = currentEvent
            vc.admins = false
            vc.members = currentEvent.members
            self.navigationController?.pushViewController(vc, animated: true)
        case 1:
            let vc = SearchMemberController()
            vc.root = self
            vc.event = currentEvent
            vc.admins = true
            vc.members = currentEvent.adminMembers
            self.navigationController?.pushViewController(vc, animated: true)
        case 2:
            guard let tracks = currentEvent.playlist?.tracks, tracks.data.count > 0, let album =  tracks.data[0].album, let cover = album.cover_big else {
                guard currentEvent.playlist != nil else {
                    ToastView.shared.short(self.view, txt_msg: "The playlist is empty.", color: UIColor.red)
                    return
                }
                let vc = PlaylistDetailController(currentEvent.playlist!, headerView!.albumCover, isInEvent: true, iAmMember, iAmAdmin, type)
                vc.event = currentEvent
                self.navigationController?.pushViewController(vc, animated: true)
                return
            }
            UIImageView().getImageUsingCacheWithUrlString(urlString: cover, completion: { (image) in
                let vc = PlaylistDetailController(self.currentEvent.playlist!, image, isInEvent: true, self.iAmMember, self.iAmAdmin, self.type)
                vc.event = self.currentEvent
                self.navigationController?.pushViewController(vc, animated: true)
            })
        case 3:
            if type == .mine {
                apiManager.deleteEventById(currentEvent._id!, completion: {
                    if self.root != nil {
                        self.root?.reloadEvent()
                    } else {
                        self.rootMap?.getAllEvents()
                    }
                    self.navigationController?.popViewController(animated: true)
                })
            } else{
                ToastView.shared.short(self.tableView, txt_msg: "This event is not yours", color: UIColor.red)
            }
        default:
            return
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row > 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: libraryCellId, for: indexPath) as! EventInteractionCell
            switch indexPath.row - 2 {
            case 0:
                cell.titleLabel.text = "Members"
                cell.iconView0.image = #imageLiteral(resourceName: "songs_icon")
            case 1:
                cell.titleLabel.text = "Admins"
                cell.iconView0.image = #imageLiteral(resourceName: "playlists_icon")
            case 2 :
                cell.titleLabel.text = "Playlist"
                cell.iconView0.image = #imageLiteral(resourceName: "play_icon")
            case 3 :
                cell.titleLabel.text = "Delete"
                cell.iconView1.image = nil
                cell.iconView0.image = #imageLiteral(resourceName: "trash")
            default:
                cell.titleLabel.text = "Omg... wtf.."
            }
            cell.selectionStyle = .none
            return cell
        }
        if indexPath.row == 1 {
            let cell =  tableView.dequeueReusableCell(withIdentifier: descriptionCellId, for: indexPath) as! EventDescriptionCell
            cell.message = currentEvent.date != nil ? "\(formatTheDate(origin: currentEvent.date!))" : "No date set..."
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: descriptionCellId, for: indexPath) as! EventDescriptionCell
        cell.message = "Creator message:\n\n\(currentEvent.description)"
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 6
    }
    
    func setupView() {
        setupHeader()
    }
    
    func updateHeaderView() {
        var headerRect = CGRect(x: 0, y: -headerHeight, width: tableView.bounds.width, height: headerHeight)
        headerRect.origin.y = tableView.contentOffset.y
        headerRect.size.height = -tableView.contentOffset.y
        headerView?.frame = headerRect
        headerView?.titleBottomConstraint?.constant = -10 - headerRect.height + 288
    }
    
    fileprivate func setupHeader() {
        headerView?.isUserInteractionEnabled = true
//        headerView.playlistDetailController = self
//        headerView.playlist = playlist
//        headerView.isEditable = isEditable
        view.addSubview(headerView!)
        headerView?.layer.zPosition = -1
        tableView.contentInset = UIEdgeInsets(top: headerHeight, left: 0, bottom: 45, right: 0)
        tableView.contentOffset = CGPoint(x: 0, y: -headerHeight)
        updateHeaderView()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return estimateFrameForText(text: "Creator message:\n\n\(currentEvent.description)\n")
        }
        if indexPath.row == 1 {
            return 44
        }
        return 44
    }
    
    private func    estimateFrameForText(text: String) -> CGFloat
    {
        let         size = CGSize(width: view.bounds.width - 28, height: 1000)
        let         options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let         rect = NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 16)], context: nil)
        
        return rect.height + 30
    }
    
    private func formatTheDate(origin: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.date(from: origin)
        dateFormatter.dateFormat = "MMM d, h:mm a"
        return date != nil ? dateFormatter.string(from: date!) : origin
    }

    func loadMe() {
        apiManager.getMe(userManager.currentUser!.token!) { (me) in
            self.me = me
            self.iAmMember = self.currentEvent.members.contains(where: { (user) -> Bool in
                if user.id == me.id {
                    return true
                }
                return false
            })
            self.iAmAdmin = self.currentEvent.adminMembers.contains(where: { (user) -> Bool in
                if user.id == me.id {
                    return true
                }
                return false
            })
            self.saveButton.setAttributedTitle(NSAttributedString(string: "Save", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white]), for: .normal)
            self.saveButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
            self.saveButton.addTarget(self, action: #selector(self.updateEvent), for: .touchUpInside)
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.saveButton)
            if (!self.iAmMember && !self.iAmAdmin && self.type != .mine) {
                self.saveButton.isHidden = true
            }
        }
    }
    
    @objc func updateEvent() {
        apiManager.putEvent(currentEvent) { (res) in
            if (res) {
                ToastView.shared.short(self.view, txt_msg: "Event Updated", color: UIColor.green)
                apiManager.getEventById(self.currentEvent._id!) { (res) in
                    self.currentEvent = res
                    if self.root != nil {
                        self.root!.reloadEvent()
                    } else {
                        self.rootMap?.getAllEvents()
                    }
                }
            }
        }
        
    }

    func addMembersAdmins(_ event: Event) {
        if iAmAdmin || type == .mine {
            currentEvent = event
            if root != nil {
                root!.reloadEvent()
            } else {
                rootMap?.getAllEvents()
            }
        }
    }
}
