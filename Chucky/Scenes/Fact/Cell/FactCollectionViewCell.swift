//
//  FactCollectionViewCell.swift
//  Chucky
//
//  Created by Andre Nogueira on 16/06/20.
//  Copyright © 2020 Andre Nogueira. All rights reserved.
//
import Foundation
import UIKit
import Cartography

class FactCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var contentFeedView: UIView? { didSet {
            contentFeedView?.backgroundColor = .black
        }
    }
    
    private let title: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 32)
        return label
    }()
      
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setup()
    }
    
    func set(with item: Fact) {
        title.text = item.value
    }
    
    private func setup() {
        self.backgroundColor = .black
        self.contentFeedView?.addSubview(title)
        
        guard let contentFeedView = self.contentFeedView else { return }
        constrain(contentFeedView, title) { (contentView, title) in
            title.center == contentView.center
            title.leading == contentView.leading
            title.trailing == contentView.trailing
        }
    }

}
