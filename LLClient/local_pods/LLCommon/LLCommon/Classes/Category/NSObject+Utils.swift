//
//  NSObject+Utils.swift
//  LLCommon
//
//  Created by lilu on 2022/4/1.
//

import Foundation
import Toast_Swift

extension NSObject {
    public func toast(_ message: String?) {
        if let window = UIApplication.shared.delegate?.window {
            window?.makeToast(message, duration: 2.0, position: .center)
        }
    }
}
