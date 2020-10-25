//
//  HomeVCTableViewController.swift
//  InstagramClone_mine
//
//  Created by Steve on 12/10/2020.
//

import UIKit
import CoreData

protocol PostSelectionDelegate {
    
}

class HomeVC: UIViewController {
    @IBOutlet var tableView: UITableView!
    @IBAction func commentButtonClicked(_ sender: CustomCommentButton) {
        
    }
    
    func MoveToDetailView(id: UUID, sender: CustomCommentButton) {
        performSegue(withIdentifier: "showDetail", sender: sender)
        self.selectedID = sender.id!.uuidString
        print("Selected ID: \(sender.id!)")
    }
    
    var postsArray: [Post] = [] // Holds array of Post objects from DB
    
    lazy var appDelegate = (UIApplication.shared.delegate as! AppDelegate)
    lazy var context = appDelegate.persisentContainer.viewContext
    var selectedID: String = "None"
    
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
        
        print(ImageManager())
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchData()
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let vc = segue.destination as! DetailVC
            vc.HomeVC = self
        }
        if segue.identifier == "addItemSegue" {
            let vc = segue.destination as! AddItemVC
            vc.delegate = self
        }
    }

    func fetchData() {
        do {
            let fetchRequest = NSFetchRequest<Post>(entityName: "Post")
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
            
            self.postsArray = try context.fetch(fetchRequest)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        catch {
            
        }
    }

    // MARK: - Table view data source
}

extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        postsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Post", for: indexPath) as! HomeTableViewCell
        cell.delegate = self
        cell.postLabel.text = self.postsArray[indexPath.row].label
        let imageName: String = self.postsArray[indexPath.row].image!
        cell.postImage.image = UIImage(contentsOfFile: sharedImageManager.galleryPath.appendingPathComponent(imageName).appendingPathExtension("jpg").path)
        cell.commentButton.id = self.postsArray[indexPath.row].id!
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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
