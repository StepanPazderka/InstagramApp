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

class DetailVC: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    
    lazy var appDelegate = (UIApplication.shared.delegate as! AppDelegate)
    lazy var context = appDelegate.persisentContainer.viewContext
    var dataArray: [Post] = []
    var id: String = "None"
    weak var HomeVC: HomeVC!

    
    @IBOutlet weak var image: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    func fetchData() {
        id = HomeVC.selectedID
        do {
            let fetchRequest = NSFetchRequest<Post>(entityName: "Post")
            fetchRequest.predicate = NSPredicate(format: "id == %@", id)
            
            self.dataArray = try context.fetch(fetchRequest)
            self.imageView.image = sharedImageManager.loadImage(image: id)
            self.label.text = dataArray.first?.label
        }
        catch {
            
        }
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
