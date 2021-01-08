//
//  CommentTableViewCell.swift
//  InstagramClone_mine
//
//  Created by Steve on 09/11/2020.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    @IBOutlet weak var commentContent: UITextView!
    @IBOutlet weak var userImage: UIImageView!
    static public let identifier: String = "CommentCell"
    static public let nib = UINib(nibName: "CommentTableViewCell", bundle: Bundle.main)
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
