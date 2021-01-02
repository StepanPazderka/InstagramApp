//
//  DetailVC.swift
//  InstagramClone_mine
//
//  Created by Steve on 15/10/2020.
//

import UIKit
import CoreData

protocol DetailDelegate {
    func didSelectRow()
}

class DetailScreenVC: UIViewController, canShareItem {
    func showShareScreen(activityVC: UIActivityViewController) {
        activityVC.popoverPresentationController?.sourceView = self.view
        self.present(activityVC, animated: true, completion: nil)
    }
    
    var delegate: showsDetailView!
    @IBOutlet weak var postScreenImageView: UIImageView!
    @IBOutlet weak var postScrenDescriptionLabel: UITextView!
    @IBOutlet weak var commentsTableView: SelfSizedTableView!
    @IBOutlet weak var newCommentTextView: UITextView!
    @IBOutlet weak var descriptionHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var coommentsTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var profilePictureImageView: UIImageView!
    
    @IBAction func newCommentPublishButtonClicked(_ sender: Any) {
        if (self.newCommentTextView.text.isEmpty) || (self.newCommentTextView.text.contains("Type your comment")) {
            let alert = UIAlertController(title: "Comment cant be empty", message: "Please add your comment", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        DatabaseManager().addComment(parentPost: parentPost!, commentContent: newCommentTextView.text)
        loadComments()
        self.commentsTableView.reloadData()
        recalculateCommentsSize()
        self.newCommentTextView.text = ("Type your comment")
        self.newCommentTextView.endEditing(true)
    }
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var DetailScreenBottomConstraint: NSLayoutConstraint!
    @IBAction func shareButtonTapped(_ sender: Any) {
        let imagePath = ImageManager().retrieveFullImagePath(imageName: selectedID!.uuidString)
        
        DatabaseManager().shareItem(delegateVC: self, image: postScreenImageView.image!, url: URL(fileURLWithPath: imagePath))
    }
    
    var selectedID: UUID?
    var parentPost: Post?
    var commentsArray: [Comment] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        profilePictureImageView.layer.cornerRadius = self.profilePictureImageView.frame.size.height / 2;
        profilePictureImageView.layer.masksToBounds = true;
        profilePictureImageView.layer.borderWidth = 0;
        
        do {
            try self.profilePictureImageView.image = ImageManager().loadImage(image: "profile")
        } catch {
            print("Profile not found")
        }
        
        
        // Setting up delegates
        newCommentTextView.delegate = self
        commentsTableView.delegate = self
        
        let LoadedPost: Post = DatabaseManager().loadPost(id: selectedID!)
        
        do {
            postScreenImageView.image = try ImageManager().loadImage(image: LoadedPost.image!)
        } catch {
            print(error.localizedDescription)
        }

        layoutPostDescription(label: LoadedPost.label)
        
        parentPost = DatabaseManager().loadPost(id: selectedID!)

        
        loadComments()
        setupCommentsTableView()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupNewCommentTextView()
    }
    
    fileprivate func setupCommentsTableView() {
        commentsTableView.dataSource = self
        commentsTableView.register(CommentTableViewCell.nib, forCellReuseIdentifier: "CommentCell")
        commentsTableView.reloadData()
        commentsTableView.rowHeight = 50
    }
    
    fileprivate func setupNewCommentTextView() {
        newCommentTextView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        newCommentTextView.textColor = .darkGray
        newCommentTextView.layer.cornerRadius = 10;
        newCommentTextView.layer.masksToBounds = true;
        newCommentTextView.layer.borderWidth = 0;
        newCommentTextView.text = ("Type your comment")
    }
    
    func recalculateCommentsSize () {
        coommentsTableViewHeightConstraint.constant = commentsTableView.contentSize.height
    }
    
    fileprivate func layoutPostDescription(label: String!) {
        postScrenDescriptionLabel.text = label
        
        if postScrenDescriptionLabel.text.isEmpty {
            print("Nothing in post description")
            descriptionHeightConstraint.constant = 0
        } else {
            let newSize = postScrenDescriptionLabel.sizeThatFits(CGSize(width: postScrenDescriptionLabel.frame.size.width, height: .infinity))
            postScrenDescriptionLabel.frame.size = CGSize(width: max(newSize.width, postScrenDescriptionLabel.frame.size.width), height: newSize.height)
            descriptionHeightConstraint.constant = newSize.height
        }
    }
    
    func loadComments() {
        commentsArray = DatabaseManager().loadCommentsWithPredicate(predicate: NSPredicate(format: "parentPost == %@", parentPost!))
        print("Comments loaded: \(commentsArray)")
        print("Comments array now contains: \(commentsArray)")
    }
    
    init() {
        super.init(nibName: "DetailScreenVC", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        postScrenDescriptionLabel.sizeToFit()
        recalculateCommentsSize()
    }
}

extension DetailScreenVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        commentsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = commentsTableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentTableViewCell
        cell.commentContent.text = self.commentsArray[indexPath.row].text
        cell.userImage.contentMode = .scaleAspectFill
        
        cell.userImage.layer.cornerRadius = cell.userImage.frame.size.height / 2;
        cell.userImage.layer.masksToBounds = true;
        cell.userImage.layer.borderWidth = 0;
        
        do {
            try cell.userImage.image = ImageManager().loadImage(image: "profile")
        } catch {
            print(error.localizedDescription)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // MARK: Handles editing of rows in TableView
        if editingStyle == .delete {
            let selectedComment = commentsArray[indexPath.row] as Comment
            DatabaseManager().delete(comment: selectedComment)
            self.commentsArray.remove(at: indexPath.row)
            self.commentsTableView.deleteRows(at: [indexPath], with: .fade)
            self.commentsTableView.reloadData()
            recalculateCommentsSize()
        }
    }
}

extension DetailScreenVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text.removeAll()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.textColor = .darkGray
            textView.text = "Type your comment"
        }
    }
}
