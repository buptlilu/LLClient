//
//  LoginViewController.swift
//  LLMain
//
//  Created by lilu on 2022/3/31.
//

import Foundation
import UIKit
import SnapKit
import LLCommon
import LLNetwork
import LLAccount

public class LoginViewController: UIViewController, UITextFieldDelegate {
    public override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
    }
    
    func setUpViews() {
        view.addSubview(imageView)
        view.addSubview(label)
        view.addSubview(usernameView)
        view.addSubview(passwordView)
        view.addSubview(loginBtn)
        
        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(80)
            make.top.equalToSuperview().offset(40)
            make.centerX.equalToSuperview()
        }
        
        label.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom).offset(20)
        }
        
        usernameView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(200)
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview().offset(-40)
            make.height.equalTo(60)
        }
        
        passwordView.snp.makeConstraints { make in
            make.top.equalTo(usernameView.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview().offset(-40)
            make.height.equalTo(60)
        }
        
        loginBtn.snp.makeConstraints { make in
            make.top.equalTo(passwordView.snp.bottom).offset(32)
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview().offset(-40)
            make.height.equalTo(48)
        }
        
        checkLoginBtnStatus()
    }
    
    @objc func checkLoginBtnStatus() {
        if let username = usernameView.inputTextField.text, let password = passwordView.inputTextField.text, username.count > 0 && password.count > 0 {
            loginBtn.isUserInteractionEnabled = true
            loginBtn.setTitleColor(.white, for: .normal)
        } else {
            loginBtn.isUserInteractionEnabled = false
            loginBtn.setTitleColor(.init(hex: 0xffffff, alpha: 0.5), for: .normal)
        }
    }
    
    @objc func login() {
        guard let username = usernameView.inputTextField.text, let password = passwordView.inputTextField.text, username.count > 0, password.count > 0  else {
            self.toast("请正确输入用户名和密码")
            return
        }
        
        usernameView.inputTextField.resignFirstResponder()
        passwordView.inputTextField.resignFirstResponder()
        
        let req = Api.Login.Request()
        req.params["username"] = username.data(using: .utf8)?.base64EncodedString()
        req.params["password"] = password.data(using: .utf8)?.base64EncodedString()
        HttpClient.send(req: req) { [weak self] success, response in
            guard let self = self else { return }
            if let res = response.data {
                if let token = res.access_token, let date = res.expires_in, token.count > 0 {
                    Logger.info("login success token:\(token)")
                    let account = Account.init(res, username)
                    AccountManager.shared.saveAccount(account)
                    ControllerManager.shared.setUpRootViewController()
                    self.toast("登录成功")
                } else if let msg = res.msg, msg.count > 0 {
                    self.toast("\(msg)")
                } else {
                    self.toast("接口出错")
                }
            } else {
                self.toast("请检查网络")
            }
        }
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        if let v = textField.superview as? LoginInputView {
            v.spaceView.backgroundColor = .init(hex: 0x000000, alpha: 0.1)
        }
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        if let v = textField.superview as? LoginInputView {
            v.spaceView.backgroundColor = .theme
        }
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if 1 == range.length {
            return true
        }
        
        if string == "\n"{
            textField.resignFirstResponder()
            return false
        } else {
            if textField.text?.count ?? 0 < 140  {
                return true
            }
        }
        
        return false
    }
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView.init()
        imageView.image = .init(named: "icon-256")
        return imageView
    }()
    
    lazy var label: UILabel = {
        let l = UILabel.init()
        l.text = "请先登录"
        l.textColor = .theme
        l.font = .boldSystemFont(ofSize: 20)
        l.sizeToFit()
        return l
    }()
    
    lazy var usernameView: LoginInputView = {
        let v = LoginInputView.init()
        v.inputTextField.placeholder = "论坛ID"
        v.inputTextField.keyboardType = .URL
        v.inputTextField.delegate = self
        v.inputTextField.addTarget(self, action: #selector(checkLoginBtnStatus), for: .editingChanged)
        return v
    }()
    
    lazy var passwordView: LoginInputView = {
        let v = LoginInputView.init()
        v.inputTextField.placeholder = "论坛密码"
        v.inputTextField.returnKeyType = .done
        v.inputTextField.isSecureTextEntry = true
        v.inputTextField.delegate = self
        v.inputTextField.addTarget(self, action: #selector(checkLoginBtnStatus), for: .editingChanged)
        return v
    }()
    
    lazy var loginBtn: UIButton = {
        let v = UIButton.init(type: .custom)
        v.clipsToBounds = true
        v.setBackgroundImage(.imageWithColor(.theme), for: .normal)
        v.setTitle("登录", for: .normal)
        v.setTitleColor(.white, for: .normal)
        v.titleLabel?.font = .systemFont(ofSize: 16)
        v.addTarget(self, action: #selector(login), for: .touchUpInside)
        v.layer.cornerRadius = 24
        return v
    }()
    
}

extension Account {
    convenience init(_ res: LoginResult, _ username: String) {
        self.init(res.access_token, res.expires_in, username)
    }
}
