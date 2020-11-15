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
    var selectedID: UUID?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let LoadedPost: Post = DatabaseManager().loadPost(id: selectedID!)
        
        imageView.image = ImageManager().loadImage(image: LoadedPost.image!)
        textView.text = LoadedPost.label
        let nib = UINib(nibName: "CommentTableViewCell", bundle: Bundle.main)
        commentsTableView.register(nib, forCellReuseIdentifier: "CommentCell")
        commentsTableView.maxHeight = 372
        commentsTableView.delegate = self
        commentsTableView.dataSource = self
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
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = commentsTableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentTableViewCell
        cell.commentContent.text = "Ahoj"
        return cell
    }
}
