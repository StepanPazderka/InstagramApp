//
//  HomeTableViewCell.swift
//  InstagramClone_mine
//
//  Created by Steve on 22/10/2020.
//

import UIKit
import CoreData
import RxSwift
import Stevia

protocol moveToDetailView {
    func MoveToDetailView(id: UUID, sender: CustomCommentButton)
}

class HomeCell: UITableViewCell {
    lazy var postImageView = UIImageView()
    var postImage: UIImage! {
        didSet {
            let imageAspectRatio = postImage.size.height / postImage.size.width
            postImageView.image = postImage
            print("Image width \(postImage.size.width) and image height \(postImage.size.height)")
            print(imageAspectRatio)
            postImageView.height(postImageView.frame.size.width * imageAspectRatio)
            print(postImageView.frame.width)
        }
    }
    lazy var commentButton = CustomCommentButton()
    lazy var likeButton = UIButton()
    lazy var shareButton = UIButton()
    lazy var postLabel = UILabel()
    lazy var tapGestureRecognizer = UITapGestureRecognizer()
    lazy var textViewHeight: CGFloat! = 0
    lazy var bookmarkButton = UIButton()
    var imageAspectRatio: CGFloat = 0.0
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let stackView = UIStackView()
        stackView.addArrangedSubview(likeButton)
        stackView.addArrangedSubview(commentButton)
        stackView.addArrangedSubview(shareButton)
        stackView.addArrangedSubview(bookmarkButton)
        
        subviews(postImageView,
                 stackView,
                 postLabel)
        
        commentButton.setImage(UIImage(systemName: "message"), for: .normal)
        shareButton.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        
        likeButton.addTarget(self, action: #selector(likeButtonPressed), for: .touchUpInside)
        commentButton.addTarget(self, action: #selector(commentButtonClicked), for: .touchUpInside)
        shareButton.addTarget(self, action: #selector(ShareButtonTapped), for: .touchUpInside)
        bookmarkButton.addTarget(self, action: #selector(bookmarkButtonTapped), for: .touchUpInside)

        commentButton.size(20)
        likeButton.size(20)
        layout(0,
               |postImageView.fillHorizontally()|,
               10,
               |-stackView.fillHorizontally().height(50)-|,
               postLabel.fillHorizontally().height(100),
               0)
                
        stackView.distribution = .fillProportionally
        stackView.spacing = 10.0
        stackView.axis = .horizontal
        stackView.Top == postImageView.Bottom + 150
        postLabel.Top == stackView.Bottom
        postLabel.numberOfLines = 0
        postLabel.sizeToFit()

        postLabel.textAlignment = .natural
        
        postImageView.heightEqualsWidth()
        postImageView.contentMode = .scaleAspectFit
    }
//
//    override func didMoveToSuperview() {
//        super.didMoveToSuperview()
//        if superview != nil {
//            if let image = postImageView.image {
//                imageAspectRatio = image.size.width / image.size.height
//            } else {
//                imageAspectRatio = 0
//            }
//
//            print(imageAspectRatio)
//
////            postImage.height(postImage.frame.size.width*imageAspectRatio)
//            print("Sirka view \(postImageView.frame.size.width)")
//        }
//    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func ShareButtonTapped(_ sender: Any) {
        DatabaseManager().shareItem(delegateVC: delegate, image: postImage, url: imageFileURL)
    }
    
    @objc func commentButtonClicked(_ sender: UIButton) {
//        delegate.moveToDetailView(id: commentButton.id!)
        coordinator?.showDetailScreen(id: commentButton.id!)
    }
    @objc func likeButtonPressed(_ sender: UIButton) {
        DatabaseManager().likePost(id: id) {
            self.delegate.reloadDataAndViews()
        }
    }
    
    @objc func bookmarkButtonTapped(_ sender: Any) {
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
        postLabel.isUserInteractionEnabled = true
        postLabel.addGestureRecognizer(tap)
        postLabel.lineBreakMode = .byTruncatingTail
        self.textViewHeight = 0
        postImageView.isUserInteractionEnabled = true
        
        let pinchRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(self.pinchGesture))
        postImageView.addGestureRecognizer(pinchRecognizer)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @objc func pinchGesture(sender: UIPinchGestureRecognizer) {
//        let defaultZoom = sender.view?.transform
        
        if (sender.state == .began || sender.state == .changed)
        {
            let currentScale = self.postImageView.frame.size.width / self.postImageView.bounds.size.width
            let newScale = currentScale*sender.scale
//
//            if newScale < 1 {
//            newScale = 1
//            }
//
//            if newScale > 6 {
//            newScale = 6
//            }
            
            let transform = CGAffineTransform(scaleX: newScale, y: newScale)
            self.postImageView.transform = transform
            sender.scale = 1
            
//            sender.view?.transform = (sender.view?.transform.scaledBy(x: sender.scale, y: sender.scale))!
//            sender.scale = 1.0
//
//            if sender.scale < 1 {
//                sender.scale = 1
//            }
            
        } else {
//            sender.view?.transform = defaultZoom!
            
            let currentScale = self.postImageView.frame.size.width / self.postImageView.bounds.size.width
            var newScale = currentScale*sender.scale

            newScale = 1
            
            let transform = CGAffineTransform(scaleX: newScale, y: newScale)
            self.postImageView.transform = transform
            sender.scale = 1
        }
    }
}
