//
//  HomeVCTableViewController.swift
//  InstagramClone_mine
//
//  Created by Steve on 12/10/2020.
//

import UIKit

class HomeVC: UIViewController {
    @IBOutlet var tableView: UITableView!
    
    var postsArray: [Post] = [] // Holds array of Post objects from DB
    
    lazy var appDelegate = (UIApplication.shared.delegate as! AppDelegate)
    lazy var context = appDelegate.persisentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        fetchData()
        
        print(ImageManager())
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        fetchData()
        
    }

    func fetchData() {
        do {
            self.postsArray = try context.fetch(Post.fetchRequest())
            
            DispatchQueue.main.async { //Making sure this reloads is happening on main thread
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "Post", for: indexPath) as! PostVC
        cell.textLabel?.text = self.postsArray[indexPath.row].label
        let imageName: String = self.postsArray[indexPath.row].image!
        cell.imageView?.image = UIImage(contentsOfFile: sharedImageManager.galleryPath.appendingPathComponent(imageName).path)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.postsArray.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            self.tableView.reloadData()
        }
    }
}
