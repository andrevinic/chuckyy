//
//  UIView+Extension.swift
//  Chucky
//
//  Created by Andre Nogueira on 20/06/20.
//  Copyright © 2020 Andre Nogueira. All rights reserved.
//

import UIKit

extension UIView {
    
    func roundCorners() {
        let viewRadius = bounds.maxX / 6
        layer.cornerRadius = viewRadius
        layer.masksToBounds = true
    }
    
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
    
    
}
