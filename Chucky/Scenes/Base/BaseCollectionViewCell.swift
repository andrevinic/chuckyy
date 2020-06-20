//
//  BaseCollectionViewCell.swift
//  Chucky
//
//  Created by Andre Nogueira on 20/06/20.
//  Copyright © 2020 Andre Nogueira. All rights reserved.
//

import Foundation
import UIKit

class BaseCollectionViewCell: UICollectionViewCell {
    func bindData<T: Any>(_ data: T...) {}
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes)
        -> UICollectionViewLayoutAttributes {
            super.setNeedsLayout()
            super.layoutIfNeeded()
            layoutAttributes.bounds.size.height
                = systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
            return layoutAttributes
    }
}
