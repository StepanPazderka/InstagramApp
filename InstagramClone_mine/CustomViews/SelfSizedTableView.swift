//
//  SelfSizingTableView.swift
//  InstagramClone_mine
//
//  Created by Steve on 09/11/2020.
//

import Foundation
import UIKit

class SelfSizedTableView: UITableView {
    override func reloadData() {
        super.reloadData()
        self.invalidateIntrinsicContentSize()
        self.layoutIfNeeded()
    }
    
    override var intrinsicContentSize: CGSize {
        let height = min(contentSize.height, .infinity)
        return CGSize(width: contentSize.width, height: height)
    }
}
