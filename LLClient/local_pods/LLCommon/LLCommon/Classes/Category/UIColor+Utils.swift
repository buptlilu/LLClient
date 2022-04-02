//
//  UIColor+Utils.swift
//  LLMain
//
//  Created by lilu on 2022/4/1.
//

import UIKit

extension UIColor {
    public class var theme: UIColor {
        return .orange
    }
    
    public convenience init(hex: UInt, alpha: CGFloat = 1.0) {
        self.init(red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((hex & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(hex & 0x0000FF) / 255.0,
                  alpha: alpha)
    }
    
    @objc public convenience init?(hex hexStr: String?) {
        guard let colorStr = hexStr,
            colorStr.count >= 6,
            let colorVal = UInt(String(colorStr.suffix(6)), radix: 16) else {
            return nil
        }
        self.init(hex: colorVal)
    }
    
    public class func isDarkColor(withRead r : CGFloat, g : CGFloat, b: CGFloat) -> Bool {
        return r * 0.299 + g * 0.578 + b * 0.114 < 192
    }
    
    public class func isDarkColor(rgbValue : Int) -> Bool {
        let r = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let b = CGFloat(rgbValue & 0x0000FF) / 255.0
        return isDarkColor(withRead: r, g: g, b: b)
    }
    
    public func isDarkColor() -> Bool {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        return UIColor.isDarkColor(withRead: r, g: g, b: b)
    }
    
}
