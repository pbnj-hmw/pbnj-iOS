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
    
    required init?(coder aDecoder: NSCoder) {
        bambuserView = BambuserView(preset: kSessionPresetAuto)
        broadcastButton = UIButton(type: UIButtonType.system)
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addAllElementsToView()
        setUIElements()
        bindUIElements()
        
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
    
    override func viewWillLayoutSubviews() {
        var statusBarOffset : CGFloat = 0.0
        statusBarOffset = CGFloat(self.topLayoutGuide.length)
        
        bambuserView.view.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.00)
            make.height.equalToSuperview()
        }
        
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
        setBambuserView()
        setBroadcastButton()
    }
    
    private func setBackButton() {
        backButton.setTitle("Back", for: .normal)
        backButton.backgroundColor = UIColor.red
    }
    
    private func setNextButton() {
        nextButton.setTitle("Next", for: .normal)
        nextButton.backgroundColor = UIColor.green
    }
    
    private func setBambuserView() {
        bambuserView.orientation = UIInterfaceOrientation.landscapeLeft
        bambuserView.applicationId = "C2i37bAE4rpiQbIEll9tXA"
        bambuserView.delegate = self;
    }
    
    private func setBroadcastButton() {
        broadcastButton.addTarget(self, action: #selector(ViewController.broadcast), for: UIControlEvents.touchUpInside)
        broadcastButton.setTitle("Broadcast", for: UIControlState.normal)
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

extension ViewController {
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeLeft
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
}

