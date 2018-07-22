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
    var instructions: [String] = []
    var displayingLabel = UILabel()
    var nextLabel = UILabel()
    
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
        displayingLabel.text = "PoooOnYou"
        return false
    }

    public func animatePrevious() -> Bool {
        return false
    }
    
    private func initializeUI() {
        addSubview(displayingLabel)
        addSubview(nextLabel)
        nextLabel.isHidden = true
        displayingLabel.text = "Poo"
    }
    
    private func createConstraints() {
        displayingLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
}
