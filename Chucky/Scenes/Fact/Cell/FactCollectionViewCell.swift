//
//  FactCollectionViewCell.swift
//  Chucky
//
//  Created by Andre Nogueira on 16/06/20.
//  Copyright © 2020 Andre Nogueira. All rights reserved.
//

import UIKit
import Cartography

class FactCollectionViewCell: UICollectionViewCell {
    
    private let name: UILabel = {
          let label = UILabel(frame: .zero)
          label.textAlignment = .center
          return label
    }()
      
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setup()
    }
    
    private func setup() {
        name.text = "TEST"
        
        self.contentView.addSubview(name)
        
        constrain(contentView, name) { (contentView, name) in
            name.center == contentView.center
            name.height == 25
            name.width == 25
        }
    }

}
