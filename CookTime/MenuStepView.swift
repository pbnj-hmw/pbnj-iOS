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
        guard currentIndex < instructions.count else { return false }
        
        displayingLabel.text = instructions[currentIndex]
        currentIndex += 1
        return true
    }

    public func animatePrevious() -> Bool {
        guard currentIndex > 0 else { return false }
        
        currentIndex -= 1
        displayingLabel.text = instructions[currentIndex]
        return true
    }
    
    private func initializeUI() {
        addSubview(displayingLabel)
        addSubview(nextLabel)
        nextLabel.isHidden = true
        displayingLabel.text = instructions[currentIndex]
    }
    
    private func createConstraints() {
        displayingLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
}
