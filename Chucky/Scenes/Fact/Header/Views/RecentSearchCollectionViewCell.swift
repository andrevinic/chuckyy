//
//  RecentSearchCollectionViewCell.swift
//  Chucky
//
//  Created by Andre Nogueira on 20/06/20.
//  Copyright © 2020 Andre Nogueira. All rights reserved.
//

import UIKit

class RecentSearchCollectionViewCell: BaseCollectionViewCell {

    @IBOutlet weak var title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.roundCorners()
    }
    
    override func bindData<T>(_ data: T...) {
        guard let recent = data[0] as? String else { return }
        
        self.title.text = recent
    }

}
