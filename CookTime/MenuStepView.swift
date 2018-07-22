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
    private var displayingInstruction = RecipeView()
    private var nextInstruction = RecipeView()
    
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
                for (index, recipe) in recipes.enumerated() {
                    guard let recipeJSON = recipe as? [String : AnyObject] else { continue }
                    let recipe = parseRecipeJSON(json: recipeJSON, number: index)
                    instructions.append(recipe)
                }
                renderFirstRecipe()
            }
        }
    }
    
    private func parseRecipeJSON(json: [String: AnyObject], number: Int) -> RecipeInstruction {
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
        return RecipeInstruction(title: title, description: description, imageLink: imageLink, step: number)
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
        let instruction = instructions[currentIndex]
        nextInstruction.setRecipe(recipe: instruction)
        animateNextElementTopToMiddle()
        animateCurrentElementOffScreen()
        return true
    }
    
    private func animateNextElementTopToMiddle() {
        placeNextElementAgainstTopWall()
        self.nextInstruction.isHidden = false
        UIView.animate(withDuration: 1, animations: { [weak self] in
            self?.nextInstruction.snp.remakeConstraints({ (make) in
                make.centerX.equalToSuperview()
                make.centerY.equalToSuperview()
            })
            self?.layoutIfNeeded()
        })
    }
    
    private func placeNextElementAgainstTopWall() {
        self.nextInstruction.snp.remakeConstraints({ [weak self] (make) in
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
        displayingInstruction.snp.remakeConstraints({ [weak self] (make) in
            guard let `self` = self else { return }
            make.centerX.equalToSuperview()
            make.top.equalTo(self.snp.bottom)
        })
        layoutIfNeeded()
    }
    
    private func animateNextElementBack() {
        placeNextElementAgainstBottomWall()
        shownextInstruction()
        animateNextElementBottomToMiddle()
    }
    
    private func shownextInstruction() {
        self.nextInstruction.isHidden = false
    }
    
    private func animateNextElementBottomToMiddle() {
        UIView.animate(withDuration: 1, animations: { [weak self] in
            guard let `self` = self else { return }
            self.nextInstruction.snp.remakeConstraints({ (make) in
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
        let instruction = instructions[currentIndex]
        nextInstruction.setRecipe(recipe: instruction)
        animateNextElementBack()
        animateCurrentElementOffScreenBack()
        return true
    }
    
    private func placeNextElementAgainstBottomWall() {
        self.nextInstruction.snp.remakeConstraints { [weak self] (make) in
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
        displayingInstruction.snp.remakeConstraints({ [weak self] (make) in
            guard let `self` = self else { return }
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.snp.top)
        })
        layoutIfNeeded()
    }

    private func swapDisplayAndCurrentLabels(_: Bool) {
        displayingInstruction.isHidden = true
        let label = nextInstruction
        nextInstruction = displayingInstruction
        displayingInstruction = label
        delegate?.didEndAnimatingViewSuccessfully(success: true)
    }
    
    private func initializeUI() {
        addSubview(displayingInstruction)
        addSubview(nextInstruction)
        nextInstruction.isHidden = true
    }
    
    private func createConstraints() {
        displayingInstruction.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        nextInstruction.snp.makeConstraints { [weak self] (make) in
            guard let `self` = self else { return }
            make.centerX.equalTo(self.snp.left)
            make.centerY.equalToSuperview()
        }
    }
    
    private func renderFirstRecipe() {
        guard instructions.count > 0 else {
            print("no recipes in the list, how they be added to the view")
            return
        }
        let instruction = instructions[0]
        displayingInstruction.setRecipe(recipe: instruction)
    }
}
