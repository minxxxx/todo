//
//  TabBarController.swift
//  MusicRoom
//
//  Created by Jonathan DAVIN on 10/30/18.
//  Copyright © 2018 Etienne Tranchier. All rights reserved.
//

import UIKit

let playerController = PlayerController([], -2)
let songDetail = SongDetailView(frame: UIApplication.shared.keyWindow!.screen.bounds)
var currentTrack: Track?
var lovedTracksId: [Int] = []

class TabBarController: UITabBarController {
    
    var offsetY: CGFloat = 0.0
    let imageInsets = UIEdgeInsets(top: 10, left: 0, bottom: -10, right: 0)
    let tabViewController0 = LibraryController()
    let tabViewController1 = SearchController()
    let tabViewController2 = MapController()
    let minimizedPlayer = MinimizedPlayerView()
    let playerView = playerController.view!
    var isPlayerOpened = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        view.backgroundColor = UIColor(white: 0.2, alpha: 1)
        setupBlurTabBar()
        setupTabBarController()
        let size = view.bounds.height
        offsetY = size > 800 ? tabBar.frame.size.height + 44 + 35 : tabBar.frame.size.height + 44
    }
    
    fileprivate func setupBlurTabBar() {
        tabBar.tintColor = .white
        tabBar.backgroundImage = UIImage()
        tabBar.backgroundColor = UIColor(white: 0.4, alpha: 0.8)
        let bounds = tabBar.bounds
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        visualEffectView.isUserInteractionEnabled = false
        visualEffectView.frame = bounds
        visualEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tabBar.addSubview(visualEffectView)
        visualEffectView.layer.zPosition = -4
    }
    
    func showPlayerFromMinimized() {
        animatedShowPlayer()
    }
    
    func showPlayerForSong(_ index: Int, tracks: [Track]) {
        if currentTrack?.id == tracks[index].id {
            playerController.handlePlay()
            return
        }
        playerController.tracks = tracks
        playerController.index = index
        playerController.viewDidPop()
        playerController.loadTrackInplayer()
        playerController.handlePlay()
        AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
    }
    
    fileprivate func setupTabBarController() {
        updateLovedTrackList()
        songDetail.root = self
        playerController.rootViewController = self
        playerController.minimizedPlayer = minimizedPlayer
        
        addChildViewController(playerController)
        tabBar.removeFromSuperview()
        view.addSubview(playerView)
        view.addSubview(minimizedPlayer)
        view.addSubview(tabBar)
        view.addSubview(songDetail)
        playerView.translatesAutoresizingMaskIntoConstraints = false
        songDetail.translatesAutoresizingMaskIntoConstraints = false
        minimizedPlayer.backgroundColor = UIColor(white: 0.3, alpha: 0.5)
        NSLayoutConstraint.activate([
            minimizedPlayer.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -44),
            minimizedPlayer.trailingAnchor.constraint(equalTo: tabBar.trailingAnchor),
            minimizedPlayer.leadingAnchor.constraint(equalTo: tabBar.leadingAnchor),
            minimizedPlayer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -43),
            
            playerView.topAnchor.constraint(equalTo: view.topAnchor),
            playerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            playerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            playerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
            songDetail.topAnchor.constraint(equalTo: view.topAnchor),
            songDetail.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            songDetail.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            songDetail.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            ])
        
        playerView.transform = CGAffineTransform(translationX: 0, y: view.bounds.height - offsetY)
        tabViewController0.title = "Your Library"
        tabViewController1.title = "Search"
        tabViewController2.title = "Map"
        
        tabViewController0.tabBarItem = UITabBarItem(title: "", image: #imageLiteral(resourceName: "library_icon"), tag: 1)
        tabViewController1.tabBarItem = UITabBarItem(title: "", image: #imageLiteral(resourceName: "search_icon"), tag: 2)
        tabViewController2.tabBarItem = UITabBarItem(title: "", image: #imageLiteral(resourceName: "map"), tag: 3)
        tabViewController0.tabBarItem.imageInsets = imageInsets
        tabViewController1.tabBarItem.imageInsets = imageInsets
        tabViewController2.tabBarItem.imageInsets = imageInsets
        
        let navi0 = CustomNavigationController(rootViewController: tabViewController0)
        let navi1 = CustomNavigationController(rootViewController: tabViewController1)
        let navi2 = CustomNavigationController(rootViewController: tabViewController2)
        
        minimizedPlayer.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan)))
        playerController.view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan)))
        playerController.downButton.alpha = 0
        viewControllers = [navi0, navi1, navi2]
    }
    
    func updateLovedTrackList() {
        apiManager.getLibraryTracks { (tracks) in
            lovedTracksId.removeAll()
            tracks.forEach({ (track) in
                lovedTracksId.append(track.id)
            })
        }
    }
    
    func animatedShowPlayer() {
        animatedHideTabBar()
        isPlayerOpened = true
        UIView.animate(withDuration: 0.25, delay: 0.1, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            playerController.downButton.alpha = 1
            self.minimizedPlayer.alpha = 0
        })
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.playerView.transform = .identity
            self.minimizedPlayer.transform = CGAffineTransform(translationX: 0, y: -self.view.bounds.height + self.offsetY)
            
        })
    }
    
    func animatedHidePlayer() {
        isPlayerOpened = false
        UIView.animate(withDuration: 0.3, delay: 0.1, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            playerController.downButton.alpha = 0
            self.minimizedPlayer.alpha = 1
        })
        animatedShowTabBar()
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.playerView.transform = CGAffineTransform(translationX: 0, y: self.view.bounds.height - self.offsetY)
            self.minimizedPlayer.transform = .identity
        })
    }
    
    func animatedShowTabBar() {
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.tabBar.transform = .identity
        })
    }
    
    func animatedHideTabBar() {
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.tabBar.transform = CGAffineTransform(translationX: 0, y: self.offsetY)
        })
    }
    
    //pan gesture
    let                 menuHeight = UIScreen.main.bounds.height
    @objc func          handlePan(gesture: UIPanGestureRecognizer) {
        guard currentTrack != nil else { return }
        let             translation = gesture.translation(in: view)
        var             y = translation.y
        let             max = self.view.bounds.height - self.offsetY
        
        if isPlayerOpened {
            y = y < 0 ? 0 : y
            y = y > max ? max : y
            playerView.transform = CGAffineTransform(translationX: 0, y: y)
            minimizedPlayer.transform = CGAffineTransform(translationX: 0, y: -max + y)
            tabBar.transform = CGAffineTransform(translationX: 0, y: self.offsetY - (y / max) * self.offsetY)
            var malpha: CGFloat = 0
            var dalpha: CGFloat = 1
            if y >= max - 100 {
                let a = max - y
                if a > 50 {
                    dalpha = (a - 50) / 50
                } else {
                    malpha = 1 - a / 50
                    dalpha = 0
                }
            }
            minimizedPlayer.alpha = malpha
            playerController.downButton.alpha = dalpha
        } else {
            y = y > 0 ? 0 : y
            y = y < -(self.view.bounds.height - self.offsetY) ? -max : y
            playerView.transform = CGAffineTransform(translationX: 0, y: max + y)
            tabBar.transform = CGAffineTransform(translationX: 0, y: -y * 0.1)
            minimizedPlayer.transform = CGAffineTransform(translationX: 0, y: y)
            minimizedPlayer.alpha = y >= -50 ? 1 + y / 50 : 0
            playerController.downButton.alpha = y >= -100 && y < -50 ? -(y + 50) / 50 : playerController.downButton.alpha
        }
        if gesture.state == .ended {
            handleEnded(gesture)
        }
    }
    
    fileprivate func    handleEnded(_ gesture: UIPanGestureRecognizer) {
        let             translation = gesture.translation(in: view)
        let             velocity = gesture.velocity(in: view)
        if isPlayerOpened {
            if velocity.y > 700 {
                animatedHidePlayer()
                return
            }
            if abs(translation.y) > menuHeight * 0.1 {
                animatedHidePlayer()
            } else {
                animatedShowPlayer()
            }
        } else {
            if velocity.y < -700 {
                animatedShowPlayer()
                return
            }
            if abs(translation.y) > menuHeight * 0.1 {
                animatedShowPlayer()
            } else {
                animatedHidePlayer()
            }
        }
    }
}


extension TabBarController: UITabBarControllerDelegate  {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        guard let fromView = selectedViewController?.view, let toView = viewController.view else {
            return false
        }
        
        if fromView != toView {
            UIView.transition(from: fromView, to: toView, duration: 0.3, options: [.transitionCrossDissolve], completion: nil)
        }
        (viewController as? CustomNavigationController)?.popToRootViewController(animated: true)
        
        return true
    }
}
