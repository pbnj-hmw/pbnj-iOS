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
    private let title = UILabel()
    
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
    }
    
    private func createConstraints() {
        setRecipeTitleConstraint()
    }
    
    private func setRecipeTitleConstraint() {
        title.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
    }
    
    private func initializeUI() {
        setRecipeTitle()
    }
    
    private func setRecipeTitle () {
        title.text = recipe?.title
        addSubview(title)
    }
    
    public func setRecipe(recipe: RecipeInstruction) {
        self.recipe = recipe
        initializeUI()
        createConstraints()
    }
}
