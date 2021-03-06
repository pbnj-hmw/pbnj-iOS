//
//  RecipeView.swift
//  Alamofire
//
//  Created by Reagan Wood on 7/22/18.
//

import Foundation
import SnapKit

class RecipeView: UIView {
    var recipe: RecipeInstruction?
    private let container = UIView()
    private let title = UILabel()
    private let step = UILabel()
    
    
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
        addItemsToView()
    }
    
    private func createConstraints() {
        setRecipeTitleConstraint()
    }
    
    private func setRecipeTitleConstraint() {
        title.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(step.snp.bottom)
            make.right.equalToSuperview()
            make.left.equalToSuperview()
        }
        
        step.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.centerX.equalTo(title.snp.centerX)
        }
        
        container.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
    }
    
    private func initializeUI() {
        setRecipeTitle()
        setRecipeStep()
    }
    
    private func setRecipeTitle () {
        title.text = recipe?.title
        title.font = UIFont.italicSystemFont(ofSize: 13)
        title.textAlignment = .center
        title.numberOfLines = 0
        title.lineBreakMode = NSLineBreakMode.byWordWrapping
    }
    
    private func setRecipeStep() {
        guard let stepNumber = recipe?.step else {
            print("Could not parse the step number")
            return
        }
        let stepNumberInt = String(stepNumber)
        step.text = "Step " + String(stepNumberInt)
        step.font = UIFont.boldSystemFont(ofSize: 15)
    }
    
    private func addItemsToView(){
        container.addSubview(title)
        container.addSubview(step)
        addSubview(container)
    }
    
    public func setRecipe(recipe: RecipeInstruction) {
        self.recipe = recipe
        initializeUI()
        createConstraints()
    }
}
