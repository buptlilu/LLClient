//
//  LoginViewController.swift
//  LLMain
//
//  Created by lilu on 2022/3/31.
//

import Foundation
import UIKit
import SnapKit

public class LoginViewController: UIViewController {
    public override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
    }
    
    func setUpViews() {
        view.addSubview(imageView)
        view.addSubview(label)
        
        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(80)
            make.top.equalToSuperview().offset(40)
            make.centerX.equalToSuperview()
        }
        
        label.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom).offset(20)
        }
    }
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView.init()
        imageView.image = .init(named: "icon-256")
        return imageView
    }()
    
    lazy var label: UILabel = {
        let l = UILabel.init()
        l.text = "请先登录"
        l.textColor = .orange
        l.font = .boldSystemFont(ofSize: 20)
        l.sizeToFit()
        return l
    }()
    
    
}
