//
//  CameraVC.swift
//  InstagramClone_mine
//
//  Created by Steve on 13/10/2020.
//

import UIKit

class ProfileVC: UIViewController, showsDetailView {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var postsCount: UILabel!
    @IBOutlet weak var likedPostsCount: UILabel!
    @IBOutlet weak var savedPostsCount: UILabel!
    
    var postsArray: [Post] = []
    var selectedID: UUID!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "ProfileCell", bundle: nil)
        self.collectionView.register(nib, forCellWithReuseIdentifier: "ProfileCell")
        
        let layout = UICollectionViewFlowLayout()
        layout.invalidateLayout()
        collectionView.collectionViewLayout = layout
        collectionView.delegate = self
        collectionView.dataSource = self

        profileImageView.layer.cornerRadius = profileImageView.frame.size.height / 2;
        profileImageView.layer.masksToBounds = true;
        profileImageView.layer.borderWidth = 0;
    }
    
    func MoveToDetailView(id: UUID) {
        let VC1 = DetailScreenVC()
        VC1.delegate = self
        VC1.selectedID = id
        self.navigationController!.pushViewController(VC1, animated: true)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        postsArray = DatabaseManager().loadPostsWithPredicate(predicate: NSPredicate(format: "saved == true"))
        collectionView.reloadData()
        
        let allPosts = DatabaseManager().loadAllPosts()
        postsCount.text = ("\(allPosts.count)")
        
        let savedPosts = DatabaseManager().loadPostsWithPredicate(predicate: NSPredicate(format: "saved == true"))
        savedPostsCount.text = ("\(savedPosts.count)")
        
        let likedPosts = DatabaseManager().loadPostsWithPredicate(predicate: NSPredicate(format: "liked == true"))
        likedPostsCount.text = ("\(likedPosts.count)")
    }
}

extension ProfileVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        postsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileCell", for: indexPath) as! ProfileCell
        print("Cell being created")
        let image = self.postsArray[indexPath.row].image!
        let resultedImage = ImageManager().loadImage(image: image)
        cell.image.image = resultedImage
        cell.id = self.postsArray[indexPath.row].id
        cell.delegate = self
        cell.image.contentMode = .scaleAspectFill
        print(resultedImage)
        return cell
    }
}

extension ProfileVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.frame.size.width/3) - 1, height: (view.frame.size.width/3) - 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    
}
