//
//  Extensions.swift
//  Drona
//
//  Created by Adhithyan Vijayakumar on 12/09/18.
//  Copyright © 2018 Adhithyan Vijayakumar. All rights reserved.
//

import UIKit

extension UIFont {
    class func proximaNovaRegular(size: CGFloat) -> UIFont {
        return UIFont(name: "ProximaNova-Regular", size: size)!
    }
    
    class func proximaNovaBold(size: CGFloat) -> UIFont {
        return UIFont(name: "ProximaNova-Bold", size: size)!
    }
}

extension UIColor {
    class func hexcodeToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

extension UIApplication {
    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }
}
