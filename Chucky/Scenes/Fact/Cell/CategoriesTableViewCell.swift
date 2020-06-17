//
//  CategoriesTableViewCell.swift
//  Chucky
//
//  Created by Andre Nogueira on 16/06/20.
//  Copyright © 2020 Andre Nogueira. All rights reserved.
//

import UIKit
import Cartography

class CategoriesTableViewCell: UITableViewCell {
    
     private let title: UILabel = {
         let label = UILabel(frame: .zero)
         label.textAlignment = .left
         label.lineBreakMode = .byWordWrapping
         label.numberOfLines = 0
         label.textColor = .white
         label.font = UIFont.boldSystemFont(ofSize: 15)
         return label
     }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setup()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    private func setup() {
        self.backgroundColor = .black
        self.contentView.addSubview(title)
        
        constrain(contentView, title) { (contentView, title) in
            title.center == contentView.center
            title.leading == contentView.leading + 20
            title.trailing == contentView.trailing - 20
        }
    }
    
    public func set(with category: String) {
        self.title.text = category
    }
    
}
