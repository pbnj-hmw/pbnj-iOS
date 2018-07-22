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
import Alamofire

protocol MenuStepViewDelegate: class {
    func didEndAnimatingViewSuccessfully(success: Bool)
}

class MenuStepView: UIView {
    public var delegate: MenuStepViewDelegate?
    
    private var instructions: [RecipeInstruction] = []
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
        getRecipeItems()
    }
    
    private func getRecipeItems() {
        Alamofire.request("https://api.homecooked.live/api/items").responseJSON { [weak self] response in
            guard let `self` = self else { return }
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
            
            if let json = response.result.value {
                print("JSON: \(json)") // serialized json response
            }
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)") // original server data as UTF8 string
                self.parseRecipeData(data: response.data ?? Data())
            }
        }
    }
    
    private func parseRecipeData(data: Data) {
        do {
            let json = try? JSONSerialization.jsonObject(with: data, options: [])
            if let recipes = json as? [AnyObject] {
                for recipe in recipes {
                    guard let recipeJSON = recipe as? [String : AnyObject] else { continue }
                    var recipe = parseRecipeJSON(json: recipeJSON)
                    instructions.append(recipe)
                }
            }
        } catch {
            
        }
    }
    
    private func parseRecipeJSON(json: [String: AnyObject]) -> RecipeInstruction {
        var title = ""
        var description = ""
        var imageLink = ""
        
        if let titleFromJSON = json["title"] as? String {
            title = titleFromJSON
        }
        if let descriptionFromJSON = json["description"] as? String {
            description = descriptionFromJSON
        }
        if let imageLinkFromJSON = json["image_link"] as? String {
            imageLink = imageLinkFromJSON
        }
        return RecipeInstruction(title: title, description: description, imageLink: imageLink)
    }

    override open func layoutSubviews() {
        super.layoutSubviews()
    }
    
    public func animateNext() -> Bool {
        guard currentIndex < instructions.count - 1 else {
            delegate?.didEndAnimatingViewSuccessfully(success: false)
            return false
        }
        currentIndex += 1
        nextLabel.text = instructions[currentIndex].title
        animateNextElementTopToMiddle()
        animateCurrentElementOffScreen()
        return true
    }
    
    private func animateNextElementTopToMiddle() {
        placeNextElementAgainstTopWall()
        self.nextLabel.isHidden = false
        UIView.animate(withDuration: 1, animations: { [weak self] in
            self?.nextLabel.snp.remakeConstraints({ (make) in
                make.centerX.equalToSuperview()
                make.centerY.equalToSuperview()
            })
            self?.layoutIfNeeded()
        })
    }
    
    private func placeNextElementAgainstTopWall() {
        self.nextLabel.snp.remakeConstraints({ [weak self] (make) in
            guard let `self` = self else { return }
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.snp.top)
        })
        self.layoutIfNeeded()
    }
    
    private func animateCurrentElementOffScreen() {
        UIView.animate(withDuration: 1.0, animations: animateDisplayMiddleToBottom, completion: swapDisplayAndCurrentLabels)
    }
    
    private func animateDisplayMiddleToBottom() {
        displayingLabel.snp.remakeConstraints({ [weak self] (make) in
            guard let `self` = self else { return }
            make.centerX.equalToSuperview()
            make.top.equalTo(self.snp.bottom)
        })
        layoutIfNeeded()
    }
    
    private func animateNextElementBack() {
        placeNextElementAgainstBottomWall()
        showNextLabel()
        animateNextElementBottomToMiddle()
    }
    
    private func showNextLabel() {
        self.nextLabel.isHidden = false
    }
    
    private func animateNextElementBottomToMiddle() {
        UIView.animate(withDuration: 1, animations: { [weak self] in
            guard let `self` = self else { return }
            self.nextLabel.snp.remakeConstraints({ (make) in
                make.centerX.equalToSuperview()
                make.centerY.equalToSuperview()
            })
            self.layoutIfNeeded()
        })
    }
    
    public func animatePrevious() -> Bool {
        guard currentIndex > 0 else {
            delegate?.didEndAnimatingViewSuccessfully(success: false)
            return false
        }
        
        currentIndex -= 1
        nextLabel.text = instructions[currentIndex].description
        animateNextElementBack()
        animateCurrentElementOffScreenBack()
        return true
    }
    
    private func placeNextElementAgainstBottomWall() {
        self.nextLabel.snp.remakeConstraints { [weak self] (make) in
            guard let `self` = self else { return }
            make.centerX.equalToSuperview()
            make.top.equalTo(self.snp.bottom)
        }
        self.layoutIfNeeded()
    }
    
    private func animateCurrentElementOffScreenBack() {
        UIView.animate(withDuration: 1.0, animations: animateDisplayLabelToTop, completion: swapDisplayAndCurrentLabels)
    }
    
    private func animateDisplayLabelToTop() {
        displayingLabel.snp.remakeConstraints({ [weak self] (make) in
            guard let `self` = self else { return }
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.snp.top)
        })
        layoutIfNeeded()
    }
    
    private func swapDisplayAndCurrentLabels(_: Bool) {
        displayingLabel.isHidden = true
        let label = nextLabel
        nextLabel = displayingLabel
        displayingLabel = label
        delegate?.didEndAnimatingViewSuccessfully(success: true)
    }
    
    private func initializeUI() {
        addSubview(displayingLabel)
        addSubview(nextLabel)
        nextLabel.isHidden = true
//        displayingLabel.text = instructions[0].description
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
