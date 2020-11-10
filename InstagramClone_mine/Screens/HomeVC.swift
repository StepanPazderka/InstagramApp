//
//  HomeVCTableViewController.swift
//  InstagramClone_mine
//
//  Created by Steve on 12/10/2020.
//

import UIKit
import CoreData

class HomeVC: UIViewController, moveToDetailView {
    lazy var appDelegate = (UIApplication.shared.delegate as! AppDelegate)
    lazy var context = appDelegate.persisentContainer.viewContext
    public var selectedID: String = "None"
    
    @IBOutlet var tableView: UITableView!
    @IBAction func AddPostButtonPressed(_ sender: Any) {
        let vc = AddPostScreenVC(nibName: "AddScreenVC", bundle: nil)
        vc.modalPresentationStyle = .popover
        self.present(vc, animated: true) {
            vc.delegate = self
        }
    }
    @IBAction func commentButtonClicked(_ sender: CustomCommentButton) {
        
    }
    
    func MoveToDetailView(id: UUID, sender: CustomCommentButton) {
        self.selectedID = sender.id!.uuidString
        
        let VC1 = DetailScreenVC()
        VC1.delegate = self
        self.navigationController!.pushViewController(VC1, animated: true)
    }
    
    var postsArray: [Post] = [] // Holds array of Post objects from DB
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        fetchData()
        
        for imageName in sharedImageManager.listSavedImages() {
            print(imageName)
        }
        
        let nib = UINib(nibName: "HomeTableViewCell", bundle: Bundle.main)
        self.tableView.register(nib, forCellReuseIdentifier: "Post")
    }
    
    func reloadDataAndViews() {
        self.fetchData()
        self.tableView.reloadData()
        print("Reloading data")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        reloadDataAndViews()
    }

    func fetchData() {
        postsArray = DatabaseManager().loadAllPosts()
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        postsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // MARK: Handles creation of new rows in TableView
        let cell = tableView.dequeueReusableCell(withIdentifier: "Post", for: indexPath) as! HomeTableViewCell
        cell.delegate = self
        cell.postLabel.text = self.postsArray[indexPath.row].label
        let imageName: String = self.postsArray[indexPath.row].image!
        cell.postImage.image = UIImage(contentsOfFile: sharedImageManager.galleryPath.appendingPathComponent(imageName).appendingPathExtension("jpg").path)
        cell.commentButton.id = self.postsArray[indexPath.row].id!
        cell.id = self.postsArray[indexPath.row].id!
        
        if self.postsArray[indexPath.row].liked == true {
            cell.likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            cell.likeButton.tintColor = .red
        } else {
            cell.likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
            cell.likeButton.tintColor = .systemBlue
        }
        
        cell.selectionStyle = .none
        return cell
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("touched \(indexPath.row)")
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        // MARK: Handles editing of rows in TableView
        if editingStyle == .delete {
            guard let imageName: String = postsArray[indexPath.row].image else {
                return
            }
            sharedImageManager.deleteImage(name: imageName)
            context.delete(postsArray[indexPath.row] as Post)
            try? self.context.save()
            self.postsArray.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            self.tableView.reloadData()
        }
    }
}

class CustomCommentButton: UIButton {
    var id: UUID?
}
