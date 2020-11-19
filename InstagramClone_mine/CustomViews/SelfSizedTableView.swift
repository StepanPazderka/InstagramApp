//
//  SelfSizingTableView.swift
//  InstagramClone_mine
//
//  Created by Steve on 09/11/2020.
//

import Foundation
import UIKit

class SelfSizedTableView: UITableView {
    var maxHeight: CGFloat = UIScreen.main.bounds.size.height
    
    override func reloadData() {
        super.reloadData()
        self.invalidateIntrinsicContentSize()
        self.layoutIfNeeded()
    }
    
    override var intrinsicContentSize: CGSize {
//        setNeedsLayout()
//        layoutIfNeeded()
        let height = min(contentSize.height, maxHeight)
        return CGSize(width: contentSize.width, height: height)
    }
}
