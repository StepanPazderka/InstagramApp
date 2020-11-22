//
//  AddItemVC.swift
//  InstagramClone_mine
//
//  Created by Steve on 14/10/2020.
//

import UIKit
import Foundation

class AddPostScreenVC: UIViewController {
    lazy var appDelegate = (UIApplication.shared.delegate as! AppDelegate)
    lazy var context = appDelegate.persisentContainer.viewContext
    
    var id = UUID()
    var fm = FileManager.default
    var delegate: HomeVC?
    @IBOutlet weak var textView: UITextView?
    @IBOutlet weak var imageView: UIImageView?
    @IBOutlet weak var AddImageButton: UIButton!
    @IBAction func imageTapped(_ sender: Any) {
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
    
    @IBAction func tappedPost(_ sender: Any) {
        guard (imageView!.image != nil) else {
            let alert = UIAlertController(title: "Can't post", message: "You have to pick an image", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
         // Just stores name of the image
        if imageView?.image != nil {
            DatabaseManager().addPost(id: self.id, label: (textView?.text)!, image: imageView!.image!)
        }

        guard delegate != nil else {
            print("Delegate not found")
            return
        }

        self.delegate!.reloadDataAndViews()
        
        self.dismiss(animated: true, completion: nil)
    }
    
    var mainBundlePath = Bundle.main.resourcePath!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textView?.delegate = self
        textView?.textColor = .darkGray
        
        textView!.layer.cornerRadius = 10;
        textView!.layer.masksToBounds = true;
        textView!.layer.borderWidth = 0;
        textView!.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        textView!.textColor = UIColor.label
    }
    
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        id = UUID() //Generuje unikatni UUID
        if delegate != nil {
            print("Delegate set to: \(delegate!)")
        }
        if (imageView?.image == nil) {
            //AddImageButton.isHidden = false
        }
    }
}

extension AddPostScreenVC: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage {
            imageView!.image = image
            AddImageButton.isHidden = true
        } else {
            print("None image selected")
        }
        let localURL: NSURL = info[.imageURL] as! NSURL
        
        print("Selected Image filename: \(localURL.lastPathComponent!)")
        dismiss(animated: true, completion: nil)
    }
}

extension AddPostScreenVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text.removeAll()
        textView.textColor = .black
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.textColor = .darkGray
            textView.text = "Please enter text"
        }
    }
}

