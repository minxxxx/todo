//
//  EventsController.swift
//  MusicRoom
//
//  Created by Etienne TRANCHIER on 11/27/18.
//  Copyright © 2018 Etienne Tranchier. All rights reserved.
//

import UIKit

class EventsController: UITableViewController {
    let sections = ["My Events", "Friend's Event"]
    var events : DataEvent?
    private let eventCellId = "eventCellId"
    private let createCellId = "createCellId"
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        title = ""
        navigationController?.navigationBar.topItem?.title = ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        title = "Events"
        navigationController?.navigationBar.topItem?.title = ""
        events?.myEvents.removeAll()
        events?.friendEvents.removeAll()
        tableView.reloadData()
        reloadEvent()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(white: 0.1, alpha: 1)
        title = "Events"
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.register(SearchEventsCell.self, forCellReuseIdentifier: eventCellId)
        tableView.register(CreateButtonCell.self, forCellReuseIdentifier: createCellId)
        apiManager.getEvents { (res) in
            self.events = res
            self.tableView.reloadData()
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.sections.count + 1
    }

    func reloadEvent() {
        apiManager.getEvents { (res) in
            self.events = res
            self.tableView.reloadData()
        }
    }
    
    func presentSelectedEvent(_ event : Event, img : UIImage, type : EventType) {
        let vc = EventDetailController(event)
        vc.root = self
        vc.type = type
        guard event.playlist != nil
            else {
                ToastView.shared.short(self.view, txt_msg: "Can't open this event, there is no playlist inside", color: UIColor.red)
                return
            }
        apiManager.getMe(userManager.currentUser!.token!) { (user) in
            SocketIOManager.sharedInstance.createEventRoom(roomID: event._id!, userID: user.id)
            userID = user.id
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 && events?.myEvents != nil {
            let cell = tableView.dequeueReusableCell(withIdentifier: eventCellId, for: indexPath) as! SearchEventsCell
            cell.rootTarget = self
            cell.type = .mine
            cell.title = sections[indexPath.row]
            cell.event = events?.myEvents
            return cell
        } else if indexPath.row == 1 && events?.friendEvents != nil {
            let cell = tableView.dequeueReusableCell(withIdentifier: eventCellId, for: indexPath) as! SearchEventsCell
            cell.rootTarget = self
            cell.title = sections[indexPath.row]
            cell.type = .friends
            cell.event = events?.friendEvents
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: createCellId, for: indexPath) as! CreateButtonCell
            cell.isCreating = true
            cell.rootEvents = self
            cell.backgroundColor = UIColor(white: 0.1, alpha: 1)
            cell.createButton.backgroundColor = UIColor(red: 40 / 255, green: 180 / 255, blue: 40 / 255, alpha: 1)
            cell.title = "CREATE EVENT"
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height: CGFloat = 0
        if indexPath.row == 0 && (events?.myEvents.count == 0 || events?.myEvents == nil){
            return height
        } else if indexPath.row == 1 && (events?.friendEvents.count == 0 || events?.friendEvents == nil){
            return height
        } else if (indexPath.row == sections.count) {
            return 60
        }
        return 240
    }
}
