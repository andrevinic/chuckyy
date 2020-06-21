//
//  CategoryCollectionViewCell.swift
//  Chucky
//
//  Created by Andre Nogueira on 20/06/20.
//  Copyright © 2020 Andre Nogueira. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: BaseCollectionViewCell {
    
    @IBOutlet weak var categoryName: UILabel?
    
    override func bindData<T>(_ data: T...) {
        guard let entity = data[0] as? String else { return }
        
        self.categoryName?.text = entity
        self.backgroundColor = UIColor.clear
        self.contentView.roundCorners()
    }
}
