//
//  HomeTableViewCell.swift
//  InstagramClone_mine
//
//  Created by Steve on 22/10/2020.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    var delegate: HomeVC!
    
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var commentButton: CustomCommentButton!
    @IBOutlet weak var postLabel: UILabel!
    @IBAction func commentButtonClicked(_ sender: UIButton) {
        delegate.MoveToDetailView(id: commentButton.id!, sender: commentButton)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
