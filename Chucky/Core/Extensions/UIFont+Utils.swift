//
//  UIFont+Utils.swift
//  Chucky
//
//  Created by Andre Nogueira on 21/06/20.
//  Copyright © 2020 Andre Nogueira. All rights reserved.
//

import Foundation
import UIKit

extension UIFont {
    
    class func mediumAirbnbFontOfSize(size: CGFloat) -> UIFont {
        return UIFont(name: "AirbnbCerealApp-Medium", size: size)!
    }
    
    class func blackAirbnbFontOfSize(size: CGFloat) -> UIFont {
        return UIFont(name: "AirbnbCerealApp-Black", size: size)!
    }
    
    class func boldAirbnbFontOfSize(size: CGFloat) -> UIFont {
        return UIFont(name: "AirbnbCerealApp-Bold", size: size)!
    }
    
    class func extraBoldAirbnbFontOfSize(size: CGFloat) -> UIFont {
        return UIFont(name: "AirbnbCerealApp-Extra", size: size)!
    }
    
    class func systemFontOfSize(size: CGFloat) -> UIFont {
        return UIFont(name: "HelveticaNeue", size: size)!
    }
    
    class func italicSystemFontOfSize(size: CGFloat) -> UIFont {
        return UIFont(name: "HelveticaNeue-Italic", size: size)!
    }
    
    class func boldSystemFontOfSize(size: CGFloat) -> UIFont {
        return UIFont(name: "HelveticaNeue-Bold", size: size)!
    }
    
    class func mediumSystemFontOfSize(size: CGFloat) -> UIFont {
        return UIFont(name: "HelveticaNeue-Medium", size: size)!
    }
    
    class func lightSystemFontOfSize(size: CGFloat) -> UIFont {
        return UIFont(name: "HelveticaNeue-Light", size: size)!
    }
    
    class func thinSystemFontOfSize(size: CGFloat) -> UIFont {
        return UIFont(name: "HelveticaNeue-Thin", size: size)!
    }
    
    class func ultraLightSystemFontOfSize(size: CGFloat) -> UIFont {
        return UIFont(name: "HelveticaNeue-UltraLight", size: size)!
    }
    
}
