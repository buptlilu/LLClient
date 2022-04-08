//
//  BoardArticleCell.swift
//  LLMain
//
//  Created by lilu on 2022/4/8.
//

import Foundation
import Kingfisher

class BoardArticleCell:BaseCell {
    required init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(userIcomImageView)
        addSubview(titleLabel)
        addSubview(userNameLabel)
        addSubview(timeLabel)
        addSubview(replyCountLabel)
        addSubview(spaceView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateData(article: Article?) {
//        userIcomImageView.kf.setImage(with: article.user?.face_url)
        userNameLabel.text = article?.user?.user_name ?? ""
        titleLabel.text = article?.title
        timeLabel.text = "\(article?.post_time ?? 0)"
        replyCountLabel.text = "\(article?.reply_count ?? 0)"
        
        userIcomImageView.snp.remakeConstraints { make in
            make.height.width.equalTo(36)
            make.left.top.equalToSuperview().offset(20)
        }
        
        titleLabel.snp.remakeConstraints { make in
            make.left.equalTo(userIcomImageView.snp.right).offset(10)
            make.top.equalTo(userIcomImageView)
            make.right.equalToSuperview().offset(-20)
        }

        userNameLabel.snp.remakeConstraints { make in
            make.left.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        replyCountLabel.snp.remakeConstraints { make in
            make.right.equalToSuperview().offset(-20)
            make.width.equalTo(60)
            make.bottom.equalTo(userNameLabel)
        }
        
        timeLabel.snp.remakeConstraints { make in
            make.right.equalTo(replyCountLabel.snp.left).offset(-10)
            make.width.equalTo(60)
            make.bottom.equalTo(userNameLabel)
        }
        
        spaceView.snp.remakeConstraints { make in
            make.bottom.right.equalToSuperview()
            make.height.equalTo(0.5)
            make.left.equalToSuperview().offset(20)
        }
    }
    
    lazy var userIcomImageView: UIImageView = {
        let v = UIImageView()
        v.clipsToBounds = true
        v.layer.cornerRadius = 18.0
        return v
    }()
    
    lazy var titleLabel: UILabel = {
        let v = UILabel()
        v.font = .systemFont(ofSize: 15)
        v.textAlignment = .left
        v.numberOfLines = 0
        return v
    }()
    
    lazy var userNameLabel: UILabel = {
        let v = UILabel()
        v.font = .systemFont(ofSize: 12)
        v.textAlignment = .left
        v.numberOfLines = 0
        return v
    }()
    
    lazy var timeLabel: UILabel = {
        let v = UILabel()
        v.textAlignment = .right
        v.textColor = .lightGray
        v.numberOfLines = 1
        return v
    }()
    
    lazy var replyCountLabel: UILabel = {
        let v = UILabel()
        v.font = .systemFont(ofSize: 12)
        v.textAlignment = .right
        v.textColor = .lightGray
        v.numberOfLines = 1
        return v
    }()
}
