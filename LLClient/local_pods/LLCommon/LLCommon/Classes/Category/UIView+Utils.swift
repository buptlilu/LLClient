//
//  UIView+Utils.swift
//  LLCommon
//
//  Created by lilu on 2022/4/1.
//

import Foundation
import Toast_Swift

extension UIView {
    public func toast(_ message: String?) {
        self.makeToast(message, duration: 2.0, position: .center)
    }
}
