//
//  BaseCell.swift
//  LLMain
//
//  Created by lilu on 2022/4/7.
//

import Foundation
import UIKit

class BaseCell: UITableViewCell {
    public class func cellWithTableView(_ tableView: UITableView)-> Self? {
        let identifier = NSStringFromClass(self)
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        if cell == nil {
            cell = Self.self.init(style: .default, reuseIdentifier: identifier)
        }
        return cell as? Self
    }
    
    required override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let bgColorView = UIView.init()
        bgColorView.backgroundColor = .init(hex: 0xDEDEDE)
        self.selectedBackgroundView = bgColorView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
