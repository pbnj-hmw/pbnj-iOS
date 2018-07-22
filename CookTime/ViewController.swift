//
//  ViewController.swift
//  CookTime
//
//  Created by Reagan Wood on 7/21/18.
//  Copyright © 2018 RW Software. All rights reserved.
//

import UIKit
import SnapKit
import Bond

class ViewController: UIViewController, BambuserViewDelegate {

//    var videoPlayer: BambuserPlayer = BambuserPlayer.init()
    var bambuserView: BambuserView
    var broadcastButton : UIButton
    let menuStepView = MenuStepView()
    
    let nextButton = UIButton()
    let backButton = UIButton()
    
//    var playButton: UIButton = UIButton()
//    var pauseButton: UIButton = UIButton()
//    var viewMenuButton: UIButton = UIButton()
    
    required init?(coder aDecoder: NSCoder) {
        bambuserView = BambuserView(preset: kSessionPresetAuto)
        broadcastButton = UIButton(type: UIButtonType.system)
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        videoPlayer.applicationId = "C2i37bAE4rpiQbIEll9tXA"
//        bambuserView.orientation = UIApplication.shared.statusBarOrientation
        bambuserView.orientation = UIInterfaceOrientation.landscapeLeft
        self.view.addSubview(bambuserView.view)
//        videoPlayer.playVideo("https://cdn.bambuser.net/broadcasts/ec968ec1-2fd9-f8f3-4f0a-d8e19dccd739?da_signature_method=HMAC-SHA256&da_id=432cebc3-4fde-5cbb-e82f-88b013140ebe&da_timestamp=1456740399&da_static=1&da_ttl=0&da_signature=8e0f9b98397c53e58f9d06d362e1de3cb6b69494e5d0e441307dfc9f854a2479")
        bambuserView.applicationId = "C2i37bAE4rpiQbIEll9tXA"
        bambuserView.delegate = self;
        
        
        broadcastButton.addTarget(self, action: #selector(ViewController.broadcast), for: UIControlEvents.touchUpInside)
        broadcastButton.setTitle("Broadcast", for: UIControlState.normal)
        self.view.addSubview(broadcastButton)
        self.view.addSubview(backButton)
        addAllElementsToView()
        setUIElements()
        bindUIElements()
//        videoPlayer.delegate = self;
//
//        view.addSubview(videoPlayer)
//
//
//        playButton.setTitle("Play", for: UIControlState.normal)
//        playButton.addTarget(videoPlayer, action: #selector(BambuserPlayer.playVideo as (BambuserPlayer) -> () -> Void), for: UIControlEvents.touchUpInside)
//        self.view.addSubview(playButton)
//        pauseButton.setTitle("Pause", for: UIControlState.normal)
//        pauseButton.addTarget(videoPlayer, action: #selector(BambuserPlayer.pauseVideo as (BambuserPlayer) -> () -> Void), for: UIControlEvents.touchUpInside)
//        self.view.addSubview(pauseButton)
//        viewMenuButton.setTitle("View Menu", for: UIControlState.normal)
//        viewMenuButton.addTarget(self, action: #selector(ViewController.viewMenu), for: UIControlEvents.touchUpInside)
//        self.view.addSubview(viewMenuButton)
//        // Do any additional setup after loading the view, typically from a nib.
        
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
    
    private func addAllElementsToView() {
        view.addSubview(bambuserView.view)
        view.addSubview(broadcastButton)
        view.addSubview(backButton)
        view.addSubview(nextButton)
        view.addSubview(menuStepView)
    }
    
//    override func viewWillLayoutSubviews() {
//        let statusBarOffset = self.topLayoutGuide.length
//        videoPlayer.frame = CGRect(x: 0, y: 0 + statusBarOffset, width: self.view.bounds.size.width, height: self.view.bounds.size.height - statusBarOffset)
//
//        playButton.frame = CGRect(x: 20, y: 20 + statusBarOffset, width: 100, height: 40)
//        pauseButton.frame = CGRect(x: 20, y: 80 + statusBarOffset, width: 100, height: 40)
//        viewMenuButton.frame = CGRect(x: 20, y: 140 + statusBarOffset, width: 100, height: 40)
//    }
    
    override func viewWillLayoutSubviews() {
        var statusBarOffset : CGFloat = 0.0
        statusBarOffset = CGFloat(self.topLayoutGuide.length)
//        bambuserView.previewFrame = CGRect(x: 0.0, y: 0.0 + statusBarOffset, width: self.view.bounds.size.width, height: self.view.bounds.size.height - statusBarOffset)
        bambuserView.view.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.00)
            make.height.equalToSuperview()
        }
        
//        broadcastButton.frame = CGRect(x: 0.0, y: 0.0 + statusBarOffset, width: 100.0, height: 50.0);
        broadcastButton.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-15)
            make.right.equalToSuperview().multipliedBy(0.80)
        }
        
        backButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.5)
            make.width.equalToSuperview().multipliedBy(0.25)
            make.bottom.equalToSuperview()
        }
        
        nextButton.snp.makeConstraints { (make) in
            make.left.equalTo(backButton.snp.right)
            make.height.equalToSuperview().multipliedBy(0.50)
            make.width.equalToSuperview().multipliedBy(0.25)
            make.bottom.equalToSuperview()
        }
        
        menuStepView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalTo(bambuserView.view.snp.left)
            make.height.equalToSuperview().multipliedBy(0.50)
            make.top.equalToSuperview()
        }
    }
    
    private func setUIElements() {
        setBackButton()
        setNextButton()
    }
    
    private func setBackButton() {
        backButton.setTitle("Back", for: .normal)
        backButton.backgroundColor = UIColor.red
    }
    
    private func setNextButton() {
        nextButton.setTitle("Next", for: .normal)
        nextButton.backgroundColor = UIColor.green
    }
    
    private func bindUIElements() {
        bindNextButton()
        bindBackButton()
    }
    
    private func bindNextButton() {
        nextButton.reactive.tap.bind(to: self) { me in
            me.menuStepView.animateNext()
        }
    }
    
    private func bindBackButton() {
        backButton.reactive.tap.bind(to: self) { me in
            me.menuStepView.animatePrevious()
        }
    }
    
    @objc func broadcast() {
        NSLog("Starting broadcast")
        broadcastButton.setTitle("Connecting", for: UIControlState.normal)
        broadcastButton.removeTarget(nil, action: nil, for: UIControlEvents.touchUpInside)
        broadcastButton.addTarget(bambuserView, action: #selector(bambuserView.stopBroadcasting), for: UIControlEvents.touchUpInside)
        bambuserView.startBroadcasting()
    }
    
    @objc func viewMenu() {
//        videoPlayer.seek(to: 0.0);
        let mainStorybaord = UIStoryboard.init(name: "Main", bundle: nil)
        let menuVC = mainStorybaord.instantiateViewController(withIdentifier: "Menu")
        present(menuVC, animated: true, completion: nil)
    }
    
    func broadcastStarted() {
        NSLog("Received broadcastStarted signal")
        broadcastButton.setTitle("Stop", for: UIControlState.normal)
        broadcastButton.removeTarget(nil, action: nil, for: UIControlEvents.touchUpInside)
        broadcastButton.addTarget(bambuserView, action: #selector(bambuserView.stopBroadcasting), for: UIControlEvents.touchUpInside)
    }
    
    func broadcastStopped() {
        NSLog("Received broadcastStopped signal")
        broadcastButton.setTitle("Broadcast", for: UIControlState.normal)
        broadcastButton.removeTarget(nil, action: nil, for: UIControlEvents.touchUpInside)
        broadcastButton.addTarget(self, action: #selector(ViewController.broadcast), for: UIControlEvents.touchUpInside)
    }
}

//extension ViewController {
//    func playbackStarted() {
//        playButton.isEnabled = false
//        pauseButton.isEnabled = true
//    }
//
//    func playbackPaused() {
//        playButton.isEnabled = true
//        pauseButton.isEnabled = false
//    }
//
//    func playbackStopped() {
//        playButton.isEnabled = true
//        pauseButton.isEnabled = false
//    }
//
//    func videoLoadFail() {
//        NSLog("Failed to load video for %@", videoPlayer.resourceUri);
//    }
//}

extension ViewController {
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeLeft
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
}

