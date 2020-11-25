//
//  HomeTableViewCell.swift
//  InstagramClone_mine
//
//  Created by Steve on 22/10/2020.
//

import UIKit
import CoreData
import LinkPresentation

protocol moveToDetailView {
    func MoveToDetailView(id: UUID, sender: CustomCommentButton)
}

class HomeTableViewCell: UITableViewCell {
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var commentButton: CustomCommentButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var postLabel: UILabel!
    @IBOutlet weak var tapGestureRecognizer: UITapGestureRecognizer?
    @IBOutlet weak var textViewHeight: NSLayoutConstraint!
    @IBOutlet weak var bookmarkButton: UIButton!
    @IBAction func ShareButtonTapped(_ sender: Any) {
        let image = self.postImage.image!
        let imageToShare: UIImage =  image 
        
        let activityViewController = UIActivityViewController(activityItems: [imageToShare, ShareItemDetails(URL: imageFileURL)], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = delegate.view

//        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]

        delegate.present(activityViewController, animated: true, completion: nil)
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

class ShareItemDetails: NSObject {
    var URL: URL?
    var image: UIImage?
    
    init(URL: URL) {
        self.URL = URL
    }
}

extension ShareItemDetails: UIActivityItemSource {
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return ""
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        return nil
    }
    
    func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
        let image = UIImage(contentsOfFile: URL!.path)!
        let imageProvider = NSItemProvider(object: image)
        let metadata = LPLinkMetadata()
        metadata.imageProvider = imageProvider
        return metadata
    }
}
