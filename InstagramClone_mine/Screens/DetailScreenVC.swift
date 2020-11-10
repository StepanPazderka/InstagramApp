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
    weak var delegate: HomeVC!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var commentsTableView: SelfSizedTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let LoadedPost: Post = DatabaseManager().loadPost(id: UUID(uuidString: delegate.selectedID)!)
        
        imageView.image = ImageManager().loadImage(image: LoadedPost.image!)
        textView.text = LoadedPost.label
        let nib = UINib(nibName: "CommentTableViewCell", bundle: Bundle.main)
        commentsTableView.register(nib, forCellReuseIdentifier: "CommentCell")
    }

    init() {
        super.init(nibName: "DetailScreenVC", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
}

extension DetailScreenVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentTableViewCell
        cell.commentContent.text = "Ahoj"
        return cell
    }
    
    
}
