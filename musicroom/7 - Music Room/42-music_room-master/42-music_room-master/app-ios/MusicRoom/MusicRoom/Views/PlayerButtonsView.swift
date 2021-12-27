//
//  PlayerButtonsView.swift
//  MusicRoom
//
//  Created by jdavin on 11/8/18.
//  Copyright © 2018 Etienne Tranchier. All rights reserved.
//

import UIKit

class PlayerButtonsView: UIView {
    let playerController: PlayerController
    let isPlaying: Bool
    
    init(target: PlayerController, _ isPlaying: Bool) {
        self.playerController = target
        self.isPlaying = isPlaying
        super.init(frame: .zero)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var progressCircle: ProgressCircle?
    
    let playButton: UIButton = {
        let button = UIButton(type: .system)
        let playIcon = UIImage(named: "play_icon")
        let tintedIcon = playIcon?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedIcon, for: .normal)
        button.tintColor = UIColor(white: 1, alpha: 1)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    let nextButton: UIButton = {
        let button = UIButton(type: .system)
        let playIcon = UIImage(named: "nextTrack_icon")
        let tintedIcon = playIcon?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedIcon, for: .normal)
        button.tintColor = UIColor(white: 1, alpha: 1)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    let previousButton: UIButton = {
        let button = UIButton(type: .system)
        let playIcon = UIImage(named: "previousTrack_icon")
        let tintedIcon = playIcon?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedIcon, for: .normal)
        button.tintColor = UIColor(white: 1, alpha: 1)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    func setPlayIcon() {
        let playIcon = UIImage(named: "play_icon")
        
        let tintedIcon = playIcon?.withRenderingMode(.alwaysTemplate)
        playButton.setImage(tintedIcon, for: .normal)
    }
    
    func setPauseIcon() {
        let playIcon = UIImage(named: "pause_icon")
        let tintedIcon = playIcon?.withRenderingMode(.alwaysTemplate)
        playButton.setImage(tintedIcon, for: .normal)
    }
    
    @objc func handlePrevious() {
        playerController.handlePrevious(false)
    }
    
    @objc func handleNext() {
        playerController.handleNext(false)
    }
    
    @objc func handlePlay() {
        playerController.handlePlay()
        
    }
    
    @objc func handlePause() {
        playerController.handlePause()
        playButton.removeTarget(self, action: #selector(handlePause), for: .touchUpInside)
        playButton.addTarget(self, action: #selector(handlePlay), for: .touchUpInside)
    }
    
    fileprivate func setupView() {
        previousButton.addTarget(self, action: #selector(handlePrevious), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(handleNext), for: .touchUpInside)
        isPlaying ? handlePlay() : handlePause()
        addSubview(previousButton)
        addSubview(playButton)
        addSubview(nextButton)
        NSLayoutConstraint.activate([
            previousButton.centerXAnchor.constraint(equalTo: centerXAnchor, constant: -85),
            previousButton.centerYAnchor.constraint(equalTo: playButton.centerYAnchor),
            previousButton.widthAnchor.constraint(equalToConstant: 35),
            previousButton.heightAnchor.constraint(equalToConstant: 35),
            playButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            playButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            playButton.widthAnchor.constraint(equalToConstant: 95),
            playButton.heightAnchor.constraint(equalToConstant: 95),
            nextButton.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 85),
            nextButton.centerYAnchor.constraint(equalTo: playButton.centerYAnchor),
            nextButton.widthAnchor.constraint(equalToConstant: 35),
            nextButton.heightAnchor.constraint(equalToConstant: 35)
            ])
        setupProgressCircle()
    }
    
    fileprivate func setupProgressCircle() {
        progressCircle = ProgressCircle(frame: CGRect(x: -0.5, y: -0.5, width: 90, height: 90))
        addSubview(progressCircle!)
        progressCircle!.translatesAutoresizingMaskIntoConstraints = false
        progressCircle!.isUserInteractionEnabled = false
        progressCircle!.layer.zPosition = playButton.layer.zPosition
        NSLayoutConstraint.activate([
            progressCircle!.centerXAnchor.constraint(equalTo: centerXAnchor),
            progressCircle!.centerYAnchor.constraint(equalTo: playButton.centerYAnchor),
            progressCircle!.widthAnchor.constraint(equalToConstant: 90),
            progressCircle!.heightAnchor.constraint(equalToConstant: 90)
            ])
    }
}




