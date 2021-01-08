//
//  HomeTableViewCell.swift
//  InstagramClone_mine
//
//  Created by Steve on 22/10/2020.
//

import UIKit
import CoreData
import RxSwift

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
        DatabaseManager().shareItem(delegateVC: delegate, image: postImage.image!, url: imageFileURL)
    }
    
    @IBAction func commentButtonClicked(_ sender: UIButton) {
//        delegate.moveToDetailView(id: commentButton.id!)
        coordinator?.showDetailScreen(id: commentButton.id!)
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
    var coordinator: HomeCoordinator?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.textViewTapped(sender:)))
        tap.numberOfTouchesRequired = 1
        postLabel!.isUserInteractionEnabled = true
        postLabel!.addGestureRecognizer(tap)
        postLabel.lineBreakMode = .byTruncatingTail
        self.textViewHeight.constant = 0
        postImage.isUserInteractionEnabled = true
        
//        let pinchRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(self.pinchGesture))
//        postImage.addGestureRecognizer(pinchRecognizer)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @objc func pinchGesture(sender: UIPinchGestureRecognizer) {
        let defaultZoom = sender.view?.transform
        
        if (sender.state == .began || sender.state == .changed)
        {
            sender.view?.transform = (sender.view?.transform.scaledBy(x: sender.scale, y: sender.scale))!
            sender.scale = 1.0
        } else {
            sender.view?.transform = defaultZoom!
        }
    }
}
