//
//  LoginInputView.swift
//  LLMain
//
//  Created by lilu on 2022/4/1.
//

import Foundation
import LLCommon
import SnapKit

class LoginInputView: UIView {
    init() {
        super.init(frame:.zero)
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpUI() {
        addSubview(spaceView)
        addSubview(inputTextField)
        
        spaceView.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
        inputTextField.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(-0.5)
        }
    }
    
    lazy var spaceView: UIView = {
        let v = UIView()
        v.backgroundColor = .init(hex: 0x000000, alpha: 0.1)
        self.inputView
        return v
    }()
    
    lazy var inputTextField: UITextField = {
        let inputTextField = UITextField.init()
        inputTextField.textAlignment = .left
        inputTextField.font = .systemFont(ofSize: 16)
        inputTextField.clearButtonMode = .whileEditing
        inputTextField.textColor = .init(hex: 0x333333)
        return inputTextField
    }()
}
