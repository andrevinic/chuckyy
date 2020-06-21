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

class FactCollectionViewCell: BaseCollectionViewCell {
    
    weak var shareDelegate: ShareDelegate?
    @IBOutlet weak var shareButton: UIButton!
    
    @IBOutlet weak var contentFeedView: UIView? { didSet {
        contentFeedView?.backgroundColor = .black
        }
    }
    
    private let backgroundImage: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        return imageView
    }()
    
    @IBOutlet weak var categoriesText: UILabel!
    
    private let title: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setup()
    }
    
    override func bindData<T>(_ data: T...) {
        guard let fact = data[0] as? Fact else { return }
        self.title.text = fact.value
        self.categoriesText.text = fact.categories.joined(separator: ",")
        self.title.font = fact.value.count > 80 ? UIFont.mediumAirbnbFontOfSize(size: 15) : UIFont.mediumAirbnbFontOfSize(size: 32)
    }
    
    private func setup() {
        self.backgroundColor = .black
        self.contentFeedView?.addSubview(backgroundImage)
        self.contentFeedView?.addSubview(title)
        
        guard let contentFeedView = self.contentFeedView else { return }
        constrain(contentFeedView, title, backgroundImage) { (contentView, title, backgroundImage) in
            title.center == contentView.center
            title.leading == contentView.leading + 20
            title.trailing == contentView.trailing - 20
            backgroundImage.center == contentView.center
            backgroundImage.leading == contentView.leading
            backgroundImage.trailing == contentView.trailing
            backgroundImage.top == contentView.top
            backgroundImage.bottom == contentView.bottom
    
        }
        
        self.shareButton
        .rx
        .tap
        .bind {
            self.shareDelegate?.share(image: self.asImage())
        }.disposed(by: disposeBag)
    }
    
}
