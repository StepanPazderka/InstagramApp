//
//  UITableView+Cell.swift
//  InstagramClone_mine
//
//  Created by Štěpán Pazderka on 20.01.2021.
//

import Foundation
import UIKit

extension UITableView {
    func dequeueCell<T: UITableViewCell>(cellType: T.Type,
                                         for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: T.identifier,
                                   for: indexPath) as? T ?? T.init()
    }
    func registerCell<T: UITableViewCell>(_ cellType: T.Type) {
        register(T.self, forCellReuseIdentifier: T.identifier)
    }
}

extension UITableViewCell {
    static var identifier: String {
        return String(describing: type(of: self))
    }
}
