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

class HomeTableViewCell: UITableViewCell {
    var delegate: HomeVC!
    var id: UUID!
    
    lazy var appDelegate = (UIApplication.shared.delegate as! AppDelegate)
    lazy var context = appDelegate.persisentContainer.viewContext
    
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var commentButton: CustomCommentButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var postLabel: UILabel!
    @IBAction func commentButtonClicked(_ sender: UIButton) {
        delegate.MoveToDetailView(id: commentButton.id!, sender: commentButton)
    }
    @IBAction func likeButtonPressed(_ sender: UIButton) {
        do {
            let fetchRequest = NSFetchRequest<Post>(entityName: "Post")
            fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            
            var selectedPost: [Post]
            
            selectedPost = try context.fetch(fetchRequest)
            guard selectedPost.first != nil else {
                return
            }
            let editedPost: Post = selectedPost.first!
            editedPost.liked.toggle()
            try self.context.save()
            delegate.reloadDataAndViews()
        }
        catch {
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
