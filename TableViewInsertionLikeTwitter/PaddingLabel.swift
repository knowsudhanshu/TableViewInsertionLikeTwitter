//
//  PaddingLabel.swift
//  TableViewInsertionLikeTwitter
//
//  Created by Sudhanshu Sudhanshu on 17/05/19.
//  Copyright © 2019 Sudhanshu Sudhanshu. All rights reserved.
//

import UIKit

class PaddingLabel: UILabel {
    var topInset: CGFloat = 5.0
    var bottomInset: CGFloat = 5.0
    var leftInset: CGFloat = 5.0
    var rightInset: CGFloat = 5.0
    
    
    override func drawText(in rect: CGRect) {
        let inset = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: inset))
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset, height: size.height + topInset + bottomInset)
    }

}
