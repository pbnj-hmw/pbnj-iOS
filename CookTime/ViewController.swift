//
//  ViewController.swift
//  CookTime
//
//  Created by Reagan Wood on 7/21/18.
//  Copyright © 2018 RW Software. All rights reserved.
//

import UIKit

class ViewController: UIViewController, BambuserPlayerDelegate {

    var videoPlayer: BambuserPlayer = BambuserPlayer.init()
    
    var playButton: UIButton = UIButton()
    var pauseButton: UIButton = UIButton()
    var viewMenuButton: UIButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        videoPlayer.applicationId = "C2i37bAE4rpiQbIEll9tXA"
        videoPlayer.playVideo("https://cdn.bambuser.net/broadcasts/ec968ec1-2fd9-f8f3-4f0a-d8e19dccd739?da_signature_method=HMAC-SHA256&da_id=432cebc3-4fde-5cbb-e82f-88b013140ebe&da_timestamp=1456740399&da_static=1&da_ttl=0&da_signature=8e0f9b98397c53e58f9d06d362e1de3cb6b69494e5d0e441307dfc9f854a2479")
        videoPlayer.delegate = self;
        
        view.addSubview(videoPlayer)
        
        
        playButton.setTitle("Play", for: UIControlState.normal)
        playButton.addTarget(videoPlayer, action: #selector(BambuserPlayer.playVideo as (BambuserPlayer) -> () -> Void), for: UIControlEvents.touchUpInside)
        self.view.addSubview(playButton)
        pauseButton.setTitle("Pause", for: UIControlState.normal)
        pauseButton.addTarget(videoPlayer, action: #selector(BambuserPlayer.pauseVideo as (BambuserPlayer) -> () -> Void), for: UIControlEvents.touchUpInside)
        self.view.addSubview(pauseButton)
        viewMenuButton.setTitle("View Menu", for: UIControlState.normal)
        viewMenuButton.addTarget(self, action: #selector(ViewController.viewMenu), for: UIControlEvents.touchUpInside)
        self.view.addSubview(viewMenuButton)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        let statusBarOffset = self.topLayoutGuide.length
        videoPlayer.frame = CGRect(x: 0, y: 0 + statusBarOffset, width: self.view.bounds.size.width, height: self.view.bounds.size.height - statusBarOffset)
        
        playButton.frame = CGRect(x: 20, y: 20 + statusBarOffset, width: 100, height: 40)
        pauseButton.frame = CGRect(x: 20, y: 80 + statusBarOffset, width: 100, height: 40)
        viewMenuButton.frame = CGRect(x: 20, y: 140 + statusBarOffset, width: 100, height: 40)
    }
    
    @objc func viewMenu() {
//        videoPlayer.seek(to: 0.0);
        let mainStorybaord = UIStoryboard.init(name: "Main", bundle: nil)
        let menuVC = mainStorybaord.instantiateViewController(withIdentifier: "Menu")
        present(menuVC, animated: true, completion: nil)
    }
}

extension ViewController {
    func playbackStarted() {
        playButton.isEnabled = false
        pauseButton.isEnabled = true
    }
    
    func playbackPaused() {
        playButton.isEnabled = true
        pauseButton.isEnabled = false
    }
    
    func playbackStopped() {
        playButton.isEnabled = true
        pauseButton.isEnabled = false
    }
    
    func videoLoadFail() {
        NSLog("Failed to load video for %@", videoPlayer.resourceUri);
    }
}

