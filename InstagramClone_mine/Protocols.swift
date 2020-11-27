//
//  Protocols.swift
//  InstagramClone_mine
//
//  Created by Steve on 12/11/2020.
//

import Foundation
import LinkPresentation

protocol showsDetailView {
    func moveToDetailView(id: UUID)
}

protocol canShareItem {
    func showShareScreen(activityVC: UIActivityViewController)
}
