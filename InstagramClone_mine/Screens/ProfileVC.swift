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
    @objc func ProfilePictureTapped(_ sender: UITapGestureRecognizer? = nil) {
        let alertDialog = UIAlertController(title: "Please select photo source", message: nil, preferredStyle: .actionSheet)
        let galleryButton = UIAlertAction(title: "Select photo from photo library", style: .default) { action in
            let picker = UIImagePickerController()
                picker.allowsEditing = true
                picker.delegate = self
                self.present(picker, animated: true)
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertDialog.addAction(cancelButton)
        alertDialog.addAction(galleryButton)
        self.present(alertDialog, animated: true, completion: nil)
        print("User tapped image")
    }
    
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
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.ProfilePictureTapped(_:)))
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(tapRecognizer)
        
        showData()
    }

    func moveToDetailView(id: UUID) {
        let VC1 = DetailScreenVC()
        VC1.delegate = self
        VC1.selectedID = id
        self.navigationController!.pushViewController(VC1, animated: true)
    }

    fileprivate func showData() {
        postsArray = DatabaseManager().loadPostsWithPredicate(predicate: NSPredicate(format: "saved == true"))
        collectionView.reloadData()
        
        let allPosts = DatabaseManager().loadAllPosts()
        postsCount.text = ("\(allPosts.count)")
        
        let savedPosts = DatabaseManager().loadPostsWithPredicate(predicate: NSPredicate(format: "saved == true"))
        savedPostsCount.text = ("\(savedPosts.count)")
        
        let likedPosts = DatabaseManager().loadPostsWithPredicate(predicate: NSPredicate(format: "liked == true"))
        likedPostsCount.text = ("\(likedPosts.count)")
        
        do {
            try profileImageView.image = ImageManager().loadImage(image: "profile")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        showData()
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
        
        do {
            try cell.image.image = ImageManager().loadImage(image: image)
        } catch {
            print(error.localizedDescription)
        }
        
        print("Asking for file \(image)")
        cell.id = self.postsArray[indexPath.row].id
        cell.delegate = self
        cell.image.contentMode = .scaleAspectFill
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

extension ProfileVC: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage {
            ImageManager().saveImage(image: image, name: "profile")
            profileImageView!.image = image
        } else {
            print("None image selected")
        }
        let localURL: NSURL = info[.imageURL] as! NSURL
        
        print("Selected Image filename: \(localURL.lastPathComponent!)")
        dismiss(animated: true, completion: nil)
    }
}
