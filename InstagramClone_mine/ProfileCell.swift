//
//  ProfileCell.swift
//  InstagramClone_mine
//
//  Created by Steve on 07/11/2020.
//

import UIKit

class ProfileCell: UICollectionViewCell {
    @IBOutlet weak var image: UIImageView!
    var delegate: ProfileVC!
    var id: UUID?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped(_:)))
        tapGesture.numberOfTapsRequired = 1
        image.isUserInteractionEnabled = true
        image.addGestureRecognizer(tapGesture)
    }

    @objc func imageViewTapped(_: Any) {
        print("User tapped image")
        delegate.MoveToDetailView(id: id!)
    }
}
