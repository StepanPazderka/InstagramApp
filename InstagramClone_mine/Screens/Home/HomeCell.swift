//
//  HomeTableViewCell.swift
//  InstagramClone_mine
//
//  Created by Steve on 22/10/2020.
//

import UIKit
import CoreData


protocol moveToDetailView {
    func MoveToDetailView(id: UUID, sender: CustomCommentButton)
}

class HomeCell: UITableViewCell {
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var commentButton: CustomCommentButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var postLabel: UILabel!
    @IBOutlet weak var tapGestureRecognizer: UITapGestureRecognizer?
    @IBOutlet weak var textViewHeight: NSLayoutConstraint!
    @IBOutlet weak var bookmarkButton: UIButton!
    @IBAction func ShareButtonTapped(_ sender: Any) {


//        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]

        DatabaseManager().shareItem(delegateVC: delegate, image: postImage.image!, url: imageFileURL)
    }
    
    @IBAction func commentButtonClicked(_ sender: UIButton) {
        delegate.moveToDetailView(id: commentButton.id!)
    }
    @IBAction func likeButtonPressed(_ sender: UIButton) {
        DatabaseManager().likePost(id: id) {
            self.delegate.reloadDataAndViews()
        }
    }
    
    @IBAction func bookmarkButtonTapped(_ sender: Any) {
        postLabel.numberOfLines = 0
        awakeFromNib()
        print("Tapped bookmark button")
        DatabaseManager().bookmarkPost(id: id) {
            self.delegate.reloadDataAndViews()
        }
    }

    @objc func textViewTapped(sender: UITapGestureRecognizer? = nil) {
        postLabel.numberOfLines = 0
        delegate.reloadDataAndViews()
        awakeFromNib()
        print("Text label tapped")
    }
    
    var delegate: HomeVC!
    var id: UUID!
    var imageFileURL: URL!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.textViewTapped(sender:)))
        tap.numberOfTouchesRequired = 1
        postLabel!.isUserInteractionEnabled = true
        postLabel!.addGestureRecognizer(tap)
        postLabel.lineBreakMode = .byTruncatingTail
        self.textViewHeight.constant = 0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
