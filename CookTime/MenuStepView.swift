//
//  MenuStepView.swift
//  CookTime
//
//  Created by Reagan Wood on 7/21/18.
//  Copyright © 2018 RW Software. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class MenuStepView: UIView {
    private var instructions: [String] = ["0", "1", "2", "3", "4"]
    private var nextIndex = 1
    private var displayingLabel = UILabel()
    private var nextLabel = UILabel()
    
    public required init() {
        super.init(frame: CGRect.zero)
        commonInit()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        backgroundColor = .white
        initializeUI()
        createConstraints()
    }

    override open func layoutSubviews() {
        super.layoutSubviews()
    }
    
    public func animateNext() -> Bool {
        guard nextIndex < instructions.count else { return false }
        
        nextLabel.text = instructions[nextIndex]
        nextIndex += 1
        animateNextElement()
        animateCurrentElementOffScreen()
        return true
    }
    
    private func animateNextElement() {
        layoutSubviews()
        self.nextLabel.snp.remakeConstraints({ [weak self] (make) in
            guard let `self` = self else { return }
            make.centerX.equalTo(self.snp.left)
            make.centerY.equalToSuperview()
        })
        self.layoutIfNeeded()
        self.nextLabel.isHidden = false
        UIView.animate(withDuration: 1, animations: { [weak self] in
            self?.nextLabel.snp.remakeConstraints({ (make) in
                make.centerX.equalToSuperview()
                make.centerY.equalToSuperview()
            })
            self?.layoutIfNeeded()
        })
    }
    
    private func animateCurrentElementOffScreen() {
        layoutSubviews()
        UIView.animate(withDuration: 1.0, animations: { [weak self] in
            self?.displayingLabel.snp.remakeConstraints({ [weak self] (make) in
                guard let `self` = self else { return }
                make.centerX.equalTo(self.snp.right)
                make.centerY.equalToSuperview()
            })
            self?.layoutIfNeeded()
        }) { [weak self] (_)
            in
            self?.displayingLabel.isHidden = true
            var label = self?.nextLabel
            self?.nextLabel = self?.displayingLabel ?? UILabel()
            self?.displayingLabel = label ?? UILabel()
        }
    }
    
    private func animateNextElementBack() {
        layoutSubviews()
        self.nextLabel.snp.remakeConstraints { (make) in
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        self.layoutIfNeeded()
        self.nextLabel.isHidden = false
        UIView.animate(withDuration: 1, animations: { [weak self] in
            self?.nextLabel.snp.remakeConstraints({ (make) in
                make.centerX.equalToSuperview()
                make.centerY.equalToSuperview()
            })
            self?.layoutIfNeeded()
        })
    }
    
    private func animateCurrentElementOffScreenBack() {
        layoutSubviews()
        UIView.animate(withDuration: 1.0, animations: { [weak self] in
            self?.displayingLabel.snp.remakeConstraints({ [weak self] (make) in
                guard let `self` = self else { return }
                make.centerX.equalTo(self.snp.left)
                make.centerY.equalToSuperview()
            })
            self?.layoutIfNeeded()
        }) { [weak self] (_)
            in
            self?.displayingLabel.isHidden = true
            var label = self?.nextLabel
            self?.nextLabel = self?.displayingLabel ?? UILabel()
            self?.displayingLabel = label ?? UILabel()
        }
    }
    
    

    public func animatePrevious() -> Bool {
        guard nextIndex > 0 else { return false }
        
        nextIndex -= 1
        nextLabel.text = instructions[nextIndex]
        animateNextElementBack()
        animateCurrentElementOffScreenBack()
        return true
    }
    
    private func initializeUI() {
        addSubview(displayingLabel)
        addSubview(nextLabel)
        nextLabel.isHidden = true
        displayingLabel.text = instructions[0]
    }
    
    private func createConstraints() {
        displayingLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        nextLabel.snp.makeConstraints { [weak self] (make) in
            guard let `self` = self else { return }
            make.centerX.equalTo(self.snp.left)
            make.centerY.equalToSuperview()
        }
    }
}
