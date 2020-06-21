//
//  UIImageView.swift
//  Chucky
//
//  Created by Andre Nogueira on 20/06/20.
//  Copyright © 2020 Andre Nogueira. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

extension UIImageView {
    
    func loadFrom(url imageUrl: String?, placeHolder: String = "nouser") {
        let placeHolder = UIImage(named: placeHolder)
        guard let imageUrl = imageUrl else {
            self.image = placeHolder
            return
        }
        self.kf.indicatorType = .activity
        self.kf.setImage(with: URL(string: imageUrl),
                         placeholder: placeHolder,
                         options: nil, progressBlock: nil) { result in
            switch result {
            case .success: break
            case .failure(let error):
                print("Job failed: \(error.localizedDescription)")
            }
        }
    }
}
