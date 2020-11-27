//
//  HomeVCTableViewController.swift
//  InstagramClone_mine
//
//  Created by Steve on 12/10/2020.
//

import UIKit
import CoreData

class HomeVC: UIViewController, showsDetailView {
    @IBOutlet var tableView: UITableView!
    
    var postsArray: [Post] = [] // Holds array of Post objects from DB
    public var selectedID: String = "None"

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        reloadDataAndViews()
        
        for imageName in ImageManager().listSavedImages() {
            print("Saved image in DB: \(imageName)")
        }
        
        let nib = UINib(nibName: "HomeCell", bundle: Bundle.main)
        self.tableView.register(nib, forCellReuseIdentifier: "Post")
    }
    
    func moveToDetailView(id: UUID) {
        let DetailScreen = DetailScreenVC()
        DetailScreen.selectedID = id
        DetailScreen.delegate = self
        self.navigationController!.pushViewController(DetailScreen, animated: true)
    }

    func reloadDataAndViews() {
        postsArray = DatabaseManager().loadAllPosts()
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        print("Reloading data")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        reloadDataAndViews()
        if postsArray.isEmpty {
            let alertDialog = UIAlertController(title: "This app seems empty", message: nil, preferredStyle: .actionSheet)
            let addSampleData = UIAlertAction(title: "Add sample data", style: .default) {_ in
                DatabaseManager().addSampleData()
                self.reloadDataAndViews()
            }
            let cancelButton = UIAlertAction(title: "Cancel", style: .cancel)
            alertDialog.addAction(addSampleData)
            alertDialog.addAction(cancelButton)
            self.present(alertDialog, animated: true, completion: nil)
        }
    }
}

extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        postsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // MARK: Handles creation of new rows in TableView
        let cell = tableView.dequeueReusableCell(withIdentifier: "Post", for: indexPath) as! HomeCell
        cell.delegate = self
        cell.postLabel.text = self.postsArray[indexPath.row].label
        let imageName: String = self.postsArray[indexPath.row].image!
        cell.postImage.image = UIImage(contentsOfFile: ImageManager().galleryPath.appendingPathComponent(imageName).appendingPathExtension("jpg").path)
        cell.commentButton.id = self.postsArray[indexPath.row].id!
        cell.id = self.postsArray[indexPath.row].id!
        
        cell.imageFileURL = URL(fileURLWithPath: ImageManager().retrieveFullImagePath(imageName: imageName))
        
        if self.postsArray[indexPath.row].liked == true {
            cell.likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            cell.likeButton.tintColor = .red
        } else {
            cell.likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
            cell.likeButton.tintColor = .systemBlue
        }
        
        if self.postsArray[indexPath.row].saved == true {
            cell.bookmarkButton.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
        } else {
            cell.bookmarkButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
        }
//        cell.postLabel.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        cell.selectionStyle = .none
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("touched \(indexPath.row)")
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // MARK: Handles editing of rows in TableView
        if editingStyle == .delete {
            guard let imageName: String = postsArray[indexPath.row].image else {
                return
            }
            ImageManager().deleteImage(name: imageName)
            DatabaseManager().delete(post: postsArray[indexPath.row] as Post)
            self.postsArray.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            self.tableView.reloadData()
        }
    }
}

class CustomCommentButton: UIButton {
    var id: UUID?
}
