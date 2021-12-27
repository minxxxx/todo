//
//  CoverContainerView.swift
//  MusicRoom
//
//  Created by jdavin on 11/4/18.
//  Copyright © 2018 Etienne Tranchier. All rights reserved.
//

import UIKit

class CoverContainerView: UIView {
    
    let underPreviousTrack: Track?
    let previousTrack: Track?
    let currentTrack: Track?
    let nextTrack: Track?
    let overNextTrack: Track?
    let playerController: PlayerController
    
    let zoomingEffect: CGFloat = 40.0
    let transparencyEffect: CGFloat = 0.4
    let animationTime = 0.4
    var pan: UIPanGestureRecognizer?
    
    init(target: UIViewController, _ underPreviousTrack: Track?, _ previousTrack: Track?, _ currentTrack: Track?, _ nextTrack: Track?, _ overNextTrack: Track?) {
        self.playerController = target as! PlayerController
        self.underPreviousTrack = underPreviousTrack
        self.previousTrack = previousTrack
        self.currentTrack = currentTrack
        self.nextTrack = nextTrack
        self.overNextTrack = overNextTrack
        super.init(frame: .zero)
        
        if currentTrack != nil {
            pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
            addGestureRecognizer(pan!)
            setupView()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let underPreviousCoverImageView: UIImageView = {
        let iv = UIImageView()
        
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let previousCoverImageView: UIImageView = {
        let iv = UIImageView()
        
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let currentCoverImageView: UIImageView = {
        let iv = UIImageView()
        
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let nextCoverImageView: UIImageView = {
        let iv = UIImageView()
        
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let overNextCoverImageView: UIImageView = {
        let iv = UIImageView()
        
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let                 menuHeight = UIScreen.main.bounds.height
    @objc func          handlePan(gesture: UIPanGestureRecognizer) {
        guard currentTrack != nil else { return }
        let             translation = gesture.translation(in: self)
        var             x = translation.x
        let             max = offset
        x = (abs(x) > max ? x < 0 ? -max : max : x) / max
        if previousTrack == nil && x > 0 { return }
        if nextTrack == nil && x < 0 { return }
        if x < 0 {
            currentLeadingAnchor?.constant = 25 + (offset - 30) * x
            currentTrailingAnchor?.constant = -25 + (offset + 5) * x
            nextTrailingAnchor?.constant = (offset - 30) + 35 * -x
            nextCoverImageView.alpha = transparencyEffect + (1 - transparencyEffect) * -x
            currentCoverImageView.alpha = 1 - (1 - transparencyEffect) * -x
            playerController.backgroundCoverView?.previousImageView.alpha = 0
            playerController.backgroundCoverView?.nextImageView.alpha = 1
            playerController.backgroundCoverView?.currentImageView.alpha = 1 + x
        } else {
            currentLeadingAnchor?.constant = 25 + (offset + 5) * x
            currentTrailingAnchor?.constant = -25 + (offset - 30) * x
            previousLeadingAnchor?.constant = (-offset + 30) - 35 * x
            previousCoverImageView.alpha = transparencyEffect + (1 - transparencyEffect) * x
            currentCoverImageView.alpha = 1 - (1 - transparencyEffect) * x
            playerController.backgroundCoverView?.previousImageView.alpha = 1
            playerController.backgroundCoverView?.nextImageView.alpha = 0
            playerController.backgroundCoverView?.currentImageView.alpha = 1 - x
        }
        if gesture.state == .ended {
            handleEnded(x: x)
        }
    }
    
    func backToCurrentTrack(_ x: CGFloat) {
        if x < 0 {
            currentLeadingAnchor?.constant = 25
            currentTrailingAnchor?.constant = -25
            nextTrailingAnchor?.constant = offset - 30
        } else {
            currentLeadingAnchor?.constant = 25
            currentTrailingAnchor?.constant = -25
            previousLeadingAnchor?.constant = -offset + 30
        }
        let iv = x < 0 ? nextCoverImageView : previousCoverImageView
        UIView.animate(withDuration: animationTime, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.currentCoverImageView.alpha = 1
            self.playerController.backgroundCoverView?.currentImageView.alpha = 1
            iv.alpha = self.transparencyEffect
            self.layoutIfNeeded()
        }){ (finished) in
            self.pan = UIPanGestureRecognizer(target: self, action: #selector(self.handlePan))
            self.addGestureRecognizer(self.pan!)
        }
    }
    
    func handleEnded(x: CGFloat) {
        removeGestureRecognizer(pan!)
        if x < 0.5 && x > -0.5 {
            backToCurrentTrack(x)
            return
        }
        if x < 0 {
            currentLeadingAnchor?.constant = 25 + (offset - 30) * -1
            currentTrailingAnchor?.constant = -25 + (offset + 5) * -1
            nextTrailingAnchor?.constant = (offset - 30) + 35
            playerController.backgroundCoverView?.handleNextAnimation()
            playerController.handleNext(true)
        } else {
            currentLeadingAnchor?.constant = 25 + (offset + 5)
            currentTrailingAnchor?.constant = -25 + (offset - 30)
            previousLeadingAnchor?.constant = (-offset + 30) - 35
            playerController.backgroundCoverView?.handlePreviousAnimation()
            playerController.handlePrevious(true)
        }
        let iv = x < 0 ? nextCoverImageView : previousCoverImageView
        UIView.animate(withDuration: animationTime, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            iv.alpha = 1
            self.currentCoverImageView.alpha = self.transparencyEffect
            self.layoutIfNeeded()
        }) { (finished) in self.playerController.setupTrack(indexOffset: x < 0 ? 1 : -1) }
    }
    
    func handleAnimation(iv: UIImageView, isNext: Bool) {
        if isNext {
            currentLeadingAnchor?.constant -= offset - 30
            currentTrailingAnchor?.constant -= offset + 5
            nextTrailingAnchor?.constant += 35
        } else {
            currentLeadingAnchor?.constant += offset + 5
            currentTrailingAnchor?.constant += offset - 30
            previousLeadingAnchor?.constant -= 35
        }
        
        UIView.animate(withDuration: animationTime, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            iv.alpha = 1
            self.currentCoverImageView.alpha = self.transparencyEffect
            self.layoutIfNeeded()
        }) { (finished) in self.playerController.setupTrack(indexOffset: isNext ? 1 : -1) }
    }
    
    func handleNextAnimation() {
        handleAnimation(iv: nextCoverImageView, isNext: true)
    }
    
    func handlePreviousAnimation() {
        handleAnimation(iv: previousCoverImageView, isNext: false)
    }
    
    var previousLeadingAnchor: NSLayoutConstraint?
    var previousTrailingAnchor: NSLayoutConstraint?
    var currentLeadingAnchor: NSLayoutConstraint?
    var currentTrailingAnchor: NSLayoutConstraint?
    var nextLeadingAnchor: NSLayoutConstraint?
    var nextTrailingAnchor: NSLayoutConstraint?
    let offset = UIApplication.shared.keyWindow!.bounds.width - 50
    
    
    
    func setupView() {
        downLoadImagesIfNeeded()
        
        addSubview(underPreviousCoverImageView)
        addSubview(previousCoverImageView)
        addSubview(currentCoverImageView)
        addSubview(nextCoverImageView)
        addSubview(overNextCoverImageView)
        
        underPreviousCoverImageView.alpha = transparencyEffect
        previousCoverImageView.alpha = transparencyEffect
        nextCoverImageView.alpha = transparencyEffect
        overNextCoverImageView.alpha = transparencyEffect
        
        previousLeadingAnchor = previousCoverImageView.leadingAnchor.constraint(equalTo: currentCoverImageView.leadingAnchor, constant: -offset + 30)
        previousTrailingAnchor = previousCoverImageView.trailingAnchor.constraint(equalTo: currentCoverImageView.leadingAnchor, constant: -5)
        currentLeadingAnchor = currentCoverImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25)
        currentTrailingAnchor = currentCoverImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25)
        nextLeadingAnchor = nextCoverImageView.leadingAnchor.constraint(equalTo: currentCoverImageView.trailingAnchor, constant: 5)
        nextTrailingAnchor = nextCoverImageView.trailingAnchor.constraint(equalTo: currentCoverImageView.trailingAnchor, constant: offset - 30)
        
        NSLayoutConstraint.activate([
            underPreviousCoverImageView.topAnchor.constraint(equalTo: topAnchor),
            underPreviousCoverImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            underPreviousCoverImageView.leadingAnchor.constraint(equalTo: previousCoverImageView.leadingAnchor, constant: -offset + 30),
            underPreviousCoverImageView.trailingAnchor.constraint(equalTo: previousCoverImageView.leadingAnchor, constant: -5),
            
            previousCoverImageView.topAnchor.constraint(equalTo: topAnchor),
            previousCoverImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            currentCoverImageView.topAnchor.constraint(equalTo: topAnchor),
            currentCoverImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            nextCoverImageView.topAnchor.constraint(equalTo: topAnchor),
            nextCoverImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            overNextCoverImageView.topAnchor.constraint(equalTo: topAnchor),
            overNextCoverImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            overNextCoverImageView.leadingAnchor.constraint(equalTo: nextCoverImageView.trailingAnchor, constant: 5),
            overNextCoverImageView.trailingAnchor.constraint(equalTo: nextCoverImageView.trailingAnchor, constant: offset - 30)
            ])
        
        NSLayoutConstraint.activate([
            previousLeadingAnchor!, previousTrailingAnchor!,
            currentLeadingAnchor!, currentTrailingAnchor!,
            nextLeadingAnchor!, nextTrailingAnchor!
            ])
    }
    
    func downLoadImagesIfNeeded() {
        if let underPrevious = underPreviousTrack {
            if let upb = underPrevious.album!.cover_big {
                underPreviousCoverImageView.loadImageUsingCacheWithUrlString(urlString: upb)
            } else {
                underPreviousCoverImageView.image = #imageLiteral(resourceName: "album_placeholder")
            }
        }
        if let previous = previousTrack {
            if let pb = previous.album!.cover_big {
                previousCoverImageView.loadImageUsingCacheWithUrlString(urlString: pb)
            } else {
                previousCoverImageView.image = #imageLiteral(resourceName: "album_placeholder")
            }
        }
        if let cb = currentTrack!.album!.cover_big {
            currentCoverImageView.loadImageUsingCacheWithUrlString(urlString: cb)
        } else {
            currentCoverImageView.image = #imageLiteral(resourceName: "album_placeholder")
        }
        if let next = nextTrack {
            if let nb = next.album!.cover_big {
                nextCoverImageView.loadImageUsingCacheWithUrlString(urlString: nb)
            } else {
                nextCoverImageView.image = #imageLiteral(resourceName: "album_placeholder")
            }
        }
        if let overNext = overNextTrack {
            if let onb = overNext.album!.cover_big {
                overNextCoverImageView.loadImageUsingCacheWithUrlString(urlString: onb)
            } else {
                overNextCoverImageView.image = #imageLiteral(resourceName: "album_placeholder")
            }
            
        }
    }
}

