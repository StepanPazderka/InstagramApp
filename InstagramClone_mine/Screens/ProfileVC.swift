//
//  CameraVC.swift
//  InstagramClone_mine
//
//  Created by Steve on 13/10/2020.
//

import UIKit

class ProfileVC: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "ProfileCell", bundle: nil)
        self.collectionView.register(nib, forCellWithReuseIdentifier: "ProfileCell")
        
        let layout = UICollectionViewLayout()
        collectionView.collectionViewLayout = layout
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}

extension ProfileVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileCell", for: indexPath) as! ProfileCell
        return cell
    }
}

extension ProfileVC: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
////        let totalHeight: CGFloat = (self.view.frame.width / 3)
////        let totalWidth: CGFloat = (self.view.frame.width / 3)
////
////        return CGSize(width: ceil(totalWidth), height: ceil(totalHeight))
//    }
}
