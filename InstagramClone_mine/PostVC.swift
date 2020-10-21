//
//  PostVC.swift
//  InstagramClone_mine
//
//  Created by Steve on 12/10/2020.
//

import UIKit

class PostVC: UITableViewCell {    
    @IBOutlet var postLabel: UILabel!
    @IBOutlet var postImage: UIImageView!
    @IBOutlet weak var commentButton: CustomCommentButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

