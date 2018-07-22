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
    private var currentIndex = 0
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
        guard currentIndex < instructions.count - 1 else { return false }
        currentIndex += 1
        nextLabel.text = instructions[currentIndex]
        animateNextElementLeftToRight()
        animateCurrentElementOffScreen()
        return true
    }
    
    private func animateNextElementLeftToRight() {
        placeNextElementAgainstLeftWall()
        self.nextLabel.isHidden = false
        UIView.animate(withDuration: 1, animations: { [weak self] in
            self?.nextLabel.snp.remakeConstraints({ (make) in
                make.centerX.equalToSuperview()
                make.centerY.equalToSuperview()
            })
            self?.layoutIfNeeded()
        })
    }
    
    private func placeNextElementAgainstLeftWall() {
        self.nextLabel.snp.remakeConstraints({ [weak self] (make) in
            guard let `self` = self else { return }
            make.centerX.equalTo(self.snp.left)
            make.centerY.equalToSuperview()
        })
        self.layoutIfNeeded()
    }
    
    private func animateCurrentElementOffScreen() {
        UIView.animate(withDuration: 1.0, animations: animateDisplayLabelToRight, completion: swapDisplayAndCurrentLabels)
    }
    
    private func animateDisplayLabelToRight() {
        displayingLabel.snp.remakeConstraints({ [weak self] (make) in
            guard let `self` = self else { return }
            make.centerX.equalTo(self.snp.right)
            make.centerY.equalToSuperview()
        })
        layoutIfNeeded()
    }
    
    private func animateNextElementBack() {
        placeNextElementAgainstRightWall()
        showNextLabel()
        animateNextElementMiddleToLeft()
    }
    
    private func showNextLabel() {
        self.nextLabel.isHidden = false
    }
    
    private func animateNextElementMiddleToLeft() {
        UIView.animate(withDuration: 1, animations: { [weak self] in
            self?.nextLabel.snp.remakeConstraints({ (make) in
                make.centerX.equalToSuperview()
                make.centerY.equalToSuperview()
            })
            self?.layoutIfNeeded()
        })
    }
    
    private func placeNextElementAgainstRightWall() {
        self.nextLabel.snp.remakeConstraints { (make) in
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        self.layoutIfNeeded()
    }
    
    private func animateCurrentElementOffScreenBack() {
        UIView.animate(withDuration: 1.0, animations: animateDisplayLabelToMiddle, completion: swapDisplayAndCurrentLabels)
    }
    
    private func animateDisplayLabelToMiddle() {
        displayingLabel.snp.remakeConstraints({ [weak self] (make) in
            guard let `self` = self else { return }
            make.centerX.equalTo(self.snp.left)
            make.centerY.equalToSuperview()
        })
        layoutIfNeeded()
    }
    
    private func swapDisplayAndCurrentLabels(_: Bool) {
        displayingLabel.isHidden = true
        let label = nextLabel
        nextLabel = displayingLabel
        displayingLabel = label
    }

    public func animatePrevious() -> Bool {
        guard currentIndex > 0 else { return false }
        
        currentIndex -= 1
        nextLabel.text = instructions[currentIndex]
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
