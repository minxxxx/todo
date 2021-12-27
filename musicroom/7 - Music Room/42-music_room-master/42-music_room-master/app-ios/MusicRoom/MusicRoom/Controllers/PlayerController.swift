//
//  PlayerController.swift
//  MusicRoom
//
//  Created by jdavin on 11/3/18.
//  Copyright © 2018 Etienne Tranchier. All rights reserved.
//

import UIKit

class PlayerController: UIViewController, DZRPlayerDelegate {
    
    var tracks: [Track]
    var index: Int
    var rootViewController: TabBarController?
    var minimizedPlayer: MinimizedPlayerView?
    var isMasteringEvent = false
    
    init(_ tracks: [Track], _ index: Int) {
        self.tracks = tracks
        self.index = index
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var hasPaused = false
    var isChangingMusic = false
    var isPlaying = true
    var firstPlay = true
    
    let request = DZRRequestManager.default().sub()
    var cancelable: DZRCancelable?
    var track: DZRTrack?
    
    var coverContainerView: CoverContainerView?
    var backgroundCoverView: BackgroundCoverView?
    var playerButtonView: PlayerButtonsView?
    
    let titleLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 14, weight: .heavy)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let authorLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 14, weight: .heavy)
        label.textColor = .lightGray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let downButton: UIButton = {
        let button = UIButton(type: .system)
        let icon = #imageLiteral(resourceName: "down_icon")
        let tintedIcon = icon.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedIcon, for: .normal)
        button.tintColor = UIColor(white: 1, alpha: 1)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = true
        return button
    }()
    
    private lazy var player: DZRPlayer? = {
        let me = userManager.currentUser
        if me != nil {
            DeezerManager.sharedInstance.deezerConnect?.accessToken = me!.deezer_token
            DeezerManager.sharedInstance.deezerConnect?.appId = APP_ID
            if DeezerManager.sharedInstance.deezerConnect!.isSessionValid() {
                var _player = DZRPlayer(connection: DeezerManager.sharedInstance.deezerConnect)
                _player!.shouldUpdateNowPlayingInfo = true
                _player!.delegate = self
                _player!.networkType = .wifiAnd3G
                _player!.shouldUpdateNowPlayingInfo = true
                return _player
            }
        }
        guard let deezerConnect = DeezerManager.sharedInstance.deezerConnect,
            var _player = DZRPlayer(connection: deezerConnect) else { return nil }
        _player.shouldUpdateNowPlayingInfo = true
        _player.delegate = self
        _player.networkType = .wifiAnd3G
        _player.shouldUpdateNowPlayingInfo = true
        return _player
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func linkPlayerWithDeezer() {
        let me = userManager.currentUser
        if me != nil {
            DeezerManager.sharedInstance.deezerConnect?.accessToken = me!.deezer_token
            DeezerManager.sharedInstance.deezerConnect?.appId = APP_ID
            if DeezerManager.sharedInstance.deezerConnect!.isSessionValid() {
                player = DZRPlayer(connection: DeezerManager.sharedInstance.deezerConnect)
                player!.shouldUpdateNowPlayingInfo = true
                player!.delegate = self
                player!.networkType = .wifiAnd3G
                player!.shouldUpdateNowPlayingInfo = true
            }
        }
        player = DZRPlayer(connection:  DeezerManager.sharedInstance.deezerConnect)
        guard player != nil else { return }
        player!.shouldUpdateNowPlayingInfo = true
        player!.delegate = self
        player!.networkType = .wifiAnd3G
        player!.shouldUpdateNowPlayingInfo = true
    }
    
    func player(_ player: DZRPlayer!, didPlay playedBytes: Int64, outOf totalBytes: Int64) {
        guard totalBytes > 0 else { return }
        let progress = CGFloat(playedBytes) / CGFloat(totalBytes)
        if isChangingMusic == false {
            playerButtonView?.progressCircle?.updateProgress(progress)
        } else {
            playerButtonView?.progressCircle?.updateProgress(0)
        }
        if progress > 0.999 {
            handleNext(false)
        }
    }
    
    func viewDidPop() {
        guard index >= 0 else { return }
        setupTrack(indexOffset: index)
        playerButtonView?.handlePlay()
    }
    
    func handleNext(_ byGesture: Bool) {
        if index + 1 < tracks.count, isChangingMusic == false {
            isChangingMusic = true
            index += 1
            loadTrackInplayer()
            if byGesture == false {
                backgroundCoverView?.handleNextAnimation()
                coverContainerView?.handleNextAnimation()
            }
        }
    }
    
    func handlePrevious(_ byGesture: Bool) {
        if index - 1 >= 0, isChangingMusic == false {
            index -= 1
            loadTrackInplayer()
            isChangingMusic = true
            if byGesture == false {
                backgroundCoverView?.handlePreviousAnimation()
                coverContainerView?.handlePreviousAnimation()
            }
        }
    }
    
    func setupTrack(indexOffset: Int) {
        backgroundCoverView?.removeFromSuperview()
        coverContainerView?.removeFromSuperview()
        titleLabel.removeFromSuperview()
        authorLabel.removeFromSuperview()
        playerButtonView?.removeFromSuperview()
        setupUI()
        hasPaused = false
        self.isChangingMusic = false
        if isPlaying {
            playerButtonView?.handlePlay()
        }
    }
    
    func handlePlay() {
        playerButtonView?.playButton.removeTarget(playerButtonView, action: #selector(playerButtonView?.handlePlay), for: .touchUpInside)
        playerButtonView?.playButton.addTarget(playerButtonView, action: #selector(playerButtonView?.handlePause), for: .touchUpInside)
        playerButtonView?.setPauseIcon()
        isPlaying = true
        if firstPlay {
            self.player?.play(track)
            firstPlay = false
        } else {
            self.player?.play()
        }
        minimizedPlayer?.update(isPlaying: true, title: tracks[index].title, artist: tracks[index].artist!.name!)
    }
    
    func handlePause() {
        playerButtonView?.playButton.removeTarget(playerButtonView, action: #selector(playerButtonView?.handlePause), for: .touchUpInside)
        playerButtonView?.playButton.addTarget(playerButtonView, action: #selector(playerButtonView?.handlePlay), for: .touchUpInside)
        playerButtonView?.setPlayIcon()
        self.player?.pause()
        isPlaying = false
        hasPaused = true
        firstPlay = false
        minimizedPlayer?.update(isPlaying: false, title: tracks[index].title, artist: tracks[index].artist!.name!)
    }
    
    
    
    func loadTrackInplayer() {
        cancelable = DZRTrack.object(withIdentifier: String(tracks[index].id), requestManager: request, callback: { (response, err) in
            if err != nil {
                print(err!)
                return
            }
            DispatchQueue.main.async {
                self.player?.stop()
                guard let res = response as? DZRTrack else { return }
                self.track = res
                self.hasPaused = true
                if res.isPlayable() {
                    self.view.isUserInteractionEnabled = true
                    self.minimizedPlayer?.isUserInteractionEnabled = true
                    self.player?.play(res)
                    if self.isPlaying == true {
                        self.playerButtonView?.handlePlay()
                    }
                    if self.isMasteringEvent {
                        print(self.tracks[self.index]._id!)
                        SocketIOManager.sharedInstance.updateCurrentTrack(trackID: self.tracks[self.index]._id!)
                    }
                    self.minimizedPlayer?.update(isPlaying: self.isPlaying, title: self.tracks[self.index].title, artist: self.tracks[self.index].artist!.name!)
                    currentTrack = self.tracks[self.index]
                }
                self.reloadView()
            }
        })
        
    }
    
    fileprivate func reloadView() {
        if let cu = (UIApplication.shared.keyWindow?.rootViewController as? TabBarController)?.selectedViewController as? CustomNavigationController {
            if let co = cu.topViewController as? UICollectionViewController {
                co.collectionView?.reloadData()
            }
            if let ta = cu.topViewController as? UITableViewController {
                ta.tableView.reloadData()
            }
        }
    }
    
    @objc func handleHide() {
        rootViewController?.animatedHidePlayer()
    }
    
    
    
    fileprivate func setupUI() {
        if firstPlay {
            cancelable?.cancel()
            linkPlayerWithDeezer()
        }
        let size = view.bounds.height
        let bestConstant: CGFloat = size > 800 ? 50 : 25
        let bestMult: CGFloat = size > 800 ? 0.17 : 0.1
        
        backgroundCoverView = setupBackgroudView()
        coverContainerView = setupCoverContainer()
        playerButtonView = PlayerButtonsView(target: self, isPlaying)
        downButton.addTarget(self, action: #selector(handleHide), for: .touchUpInside)
        playerButtonView?.translatesAutoresizingMaskIntoConstraints = false
        if index != -2 {
            titleLabel.text = tracks[index].title
            authorLabel.text = tracks[index].artist!.name
        }
        view.addSubview(backgroundCoverView!)
        view.addSubview(coverContainerView!)
        view.addSubview(titleLabel)
        view.addSubview(authorLabel)
        view.addSubview(playerButtonView!)
        view.addSubview(downButton)
        
        NSLayoutConstraint.activate([
            backgroundCoverView!.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundCoverView!.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundCoverView!.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundCoverView!.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            downButton.topAnchor.constraint(equalTo: view.topAnchor, constant: bestConstant),
            downButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 7),
            downButton.widthAnchor.constraint(equalToConstant: 27),
            downButton.heightAnchor.constraint(equalToConstant: 26),
            
            coverContainerView!.topAnchor.constraint(equalTo: downButton.bottomAnchor, constant: 10),
            coverContainerView!.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -5),
            coverContainerView!.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            coverContainerView!.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            titleLabel.heightAnchor.constraint(equalToConstant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: authorLabel.topAnchor, constant: -5),
            
            authorLabel.bottomAnchor.constraint(equalTo: playerButtonView!.topAnchor, constant: -20),
            authorLabel.heightAnchor.constraint(equalToConstant: 20),
            authorLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            authorLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            playerButtonView!.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            playerButtonView!.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            playerButtonView!.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -size * bestMult),
            playerButtonView!.heightAnchor.constraint(equalToConstant: 120)
            ])
    }
}

extension PlayerController {
    fileprivate func setupCoverContainer() -> CoverContainerView {
        var underPreviousTrack: Track? = nil
        var previousTrack: Track? = nil
        var nextTrack: Track? = nil
        var overNextTrack: Track? = nil
        if index - 2 >= 0 {
            underPreviousTrack = tracks[index - 2]
        }
        if index - 1 >= 0 {
            previousTrack = tracks[index - 1]
        }
        let currentTrack = tracks[index]
        if index + 1 < tracks.count {
            nextTrack = tracks[index + 1]
        }
        if index + 2 < tracks.count {
            overNextTrack = tracks[index + 2]
        }
        let ccv = CoverContainerView(target: self, underPreviousTrack, previousTrack, currentTrack, nextTrack, overNextTrack)
        ccv.translatesAutoresizingMaskIntoConstraints = false
        ccv.clipsToBounds = true
        return ccv
    }
    
    fileprivate func setupBackgroudView() -> BackgroundCoverView {
        var previousTrack: Track? = nil
        var nextTrack: Track? = nil
        if index - 1 >= 0 {
            previousTrack = tracks[index - 1]
        }
        let currentTrack = tracks[index]
        if index + 1 < tracks.count {
            nextTrack = tracks[index + 1]
        }
        let bcv = BackgroundCoverView(previousTrack, currentTrack, nextTrack)
        bcv.translatesAutoresizingMaskIntoConstraints = false
        bcv.clipsToBounds = true
        return bcv
    }
}
