//
//  UIImageView+Utils.swift
//  LLCommon
//
//  Created by lilu on 2022/4/7.
//

import Foundation

extension UIImageView {
    public class func arrowView() -> UIView {
        let v = UIImageView()
        v.image = .init(named: "common_icon_arrow")
        return v
    }
}
