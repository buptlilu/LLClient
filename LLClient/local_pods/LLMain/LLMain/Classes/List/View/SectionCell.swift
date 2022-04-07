//
//  SectionCell.swift
//  LLMain
//
//  Created by lilu on 2022/4/7.
//

import Foundation

class SectionCell: BaseCell {
    required init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(label)
        addSubview(spaceView)
        addSubview(arrowView)
        
        arrowView.snp.makeConstraints { make in
            make.height.width.equalTo(12)
            make.right.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
        }
        
        spaceView.snp.makeConstraints { make in
            make.bottom.right.equalToSuperview()
            make.height.equalTo(0.5)
            make.left.equalToSuperview().offset(20)
        }
        
        label.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.top.bottom.equalToSuperview()
            make.right.lessThanOrEqualTo(arrowView.snp.left)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var label: UILabel = {
        let v = UILabel.init()
        v.textColor = .titleColor
        v.textAlignment = .left
        v.font = .systemFont(ofSize: 17)
        return v
    }()
}
