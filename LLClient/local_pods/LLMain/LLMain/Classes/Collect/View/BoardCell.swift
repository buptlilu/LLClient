//
//  BoardCell.swift
//  LLMain
//
//  Created by lilu on 2022/4/7.
//

import Foundation

class BoardCell: BaseCell {
    var board: Board? {
        didSet {
            label.text = board?.description
            arrowView.isHidden = board?.is_favorite ?? false
            likeBtn.isHidden = !arrowView.isHidden
            likeBtn.isSelected = board?.is_favorite ?? false
        }
    }
    
    required init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(label)
        addSubview(spaceView)
        addSubview(arrowView)
        addSubview(likeBtn)
        
        arrowView.snp.makeConstraints { make in
            make.height.width.equalTo(12)
            make.right.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
        }
        
        likeBtn.snp.makeConstraints { make in
            make.height.width.equalTo(44)
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
    
    @objc func likeBtnClick() {
        
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
    
    lazy var likeBtn: UIButton = {
        let v = UIButton.init()
        v.setImage(.init(named: "star_normal"), for: .normal)
        v.setImage(.init(named: "star_selected"), for: .selected)
        v.addTarget(self, action: #selector(likeBtnClick), for: .touchUpInside)
        return v
    }()
}
