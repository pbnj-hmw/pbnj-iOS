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
        setViewDelegates()
    }
    
    private func addAllElementsToView() {
        view.addSubview(bambuserView.view)
        view.addSubview(broadcastButton)
        view.addSubview(backButton)
        view.addSubview(nextButton)
        view.addSubview(menuStepView)
        view.sendSubview(toBack: menuStepView)
        view.sendSubview(toBack: bambuserView.view)
    }
    
    override func viewWillLayoutSubviews() {
        
        bambuserView.view.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(backButton.snp.left)
            make.width.equalTo(menuStepView.snp.width)
            make.height.equalToSuperview()
            make.left.equalToSuperview()
        }
        
        broadcastButton.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-15)
            make.centerX.equalTo(bambuserView.view.snp.centerX)
        }

        backButton.snp.makeConstraints { (make) in
            make.right.equalTo(nextButton.snp.left)
            make.height.equalToSuperview().multipliedBy(0.5)
            make.width.equalToSuperview().multipliedBy(0.25)
            make.bottom.equalToSuperview()
        }
        
        nextButton.snp.makeConstraints { (make) in
            make.right.equalTo(view.snp.right)
            make.height.equalToSuperview().multipliedBy(0.50)
            make.width.equalToSuperview().multipliedBy(0.25)
            make.bottom.equalToSuperview()
        }

        menuStepView.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.left.equalTo(bambuserView.view.snp.right)
            make.height.equalToSuperview().multipliedBy(0.50)
            make.top.equalToSuperview()
        }
    }
    
    private func setUIElements() {
        setBackButton()
        setNextButton()
        setBambuserView()
        setBroadcastButton()
        setViewOrientation()
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
        bambuserView.orientation = UIInterfaceOrientation.landscapeRight
        bambuserView.applicationId = "C2i37bAE4rpiQbIEll9tXA"
        bambuserView.delegate = self;
    }
    
    private func setBroadcastButton() {
        broadcastButton.addTarget(self, action: #selector(ViewController.broadcast), for: UIControlEvents.touchUpInside)
        broadcastButton.setTitle("Broadcast", for: UIControlState.normal)
    }
    
    private func setViewOrientation() {
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
    
    private func bindUIElements() {
        bindNextButton()
        bindBackButton()
    }
    
    private func bindNextButton() {
        nextButton.reactive.tap.skip(first: 1).bind(to: self) { me in
            me.disableButtons()
            me.menuStepView.animateNext()
        }
    }
    
    private func bindBackButton() {
        backButton.reactive.tap.skip(first: 1).bind(to: self) { me in
            me.disableButtons()
            me.menuStepView.animatePrevious()
        }
    }
    
    private func disableButtons() {
        backButton.isEnabled = false
        nextButton.isEnabled = false
    }
    
    private func enableButtons() {
        backButton.isEnabled = true
        nextButton.isEnabled = true
    }
    
    private func setViewDelegates() {
        menuStepView.delegate = self
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
        return .landscapeRight
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
}

extension ViewController: MenuStepViewDelegate {
    func didEndAnimatingView() {
        enableButtons()
    }
    
    
}

