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

class DetailScreenVC: UIViewController {
    var delegate: showsDetailView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var commentsTableView: SelfSizedTableView!
    @IBOutlet weak var newCommentTextView: UITextView!
    @IBOutlet weak var descriptionHeight: NSLayoutConstraint!
    
    
    @IBAction func newCommentPublishButtonClicked(_ sender: Any) {
        DatabaseManager().postComment(parentPost: parentPost!, commentContent: newCommentTextView.text)
        loadComments()
        self.commentsTableView.reloadData()
    }
    var selectedID: UUID?
    var parentPost: Post?
    var commentsArray: [Comment] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let LoadedPost: Post = DatabaseManager().loadPost(id: selectedID!)
        
        do {
            imageView.image = try ImageManager().loadImage(image: LoadedPost.image!)
        } catch {
            print(error.localizedDescription)
        }
        textView.text = LoadedPost.label
        let nib = UINib(nibName: "CommentTableViewCell", bundle: Bundle.main)
        commentsTableView.register(nib, forCellReuseIdentifier: "CommentCell")
        commentsTableView.delegate = self
        commentsTableView.dataSource = self
        
        if textView.text.isEmpty {
            print("Nothing in post description")
            descriptionHeight.constant = 0
        } else {
            let newSize = textView.sizeThatFits(CGSize(width: textView.frame.size.width, height: .infinity))
            textView.frame.size = CGSize(width: max(newSize.width, textView.frame.size.width), height: newSize.height)
            descriptionHeight.constant = newSize.height
        }
        
        parentPost = DatabaseManager().loadPost(id: selectedID!)
        loadComments()
        self.commentsTableView.reloadData()
        self.commentsTableView.rowHeight = 50
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
        textView.sizeToFit()
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
}
