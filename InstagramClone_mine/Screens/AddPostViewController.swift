//
//  AddItemVC.swift
//  InstagramClone_mine
//
//  Created by Steve on 14/10/2020.
//

import UIKit
import Foundation
import Stevia

class AddPostViewController: UIViewController {
    var textView = UITextView()
    var imageView = UIImageView()
    var selectImageButton = UIButton()
    var postButton = UIButton()
    var closeButton = UIButton()
    @objc func imageTapped(_ sender: Any) {
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
    @IBAction func closeButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func tappedPost(_ sender: Any) {
        guard (imageView.image != nil) else {
            let alert = UIAlertController(title: "Can't post", message: "You have to pick an image", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
         // Just stores name of the image
        if imageView.image != nil {
            DatabaseManager().addPost(id: self.id, label: (textView.text)!, image: imageView.image!)
        }

        guard delegate != nil else {
            print("Delegate not found")
            return
        }

        self.delegate!.reloadDataAndViews()
        self.dismiss(animated: true, completion: nil)
    }
    
    var originalPostButtonColor = UIColor.white
    var id = UUID()
    var fm = FileManager.default
    var delegate: HomeVC?
    var mainBundlePath = Bundle.main.resourcePath!
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        let closeIcon = UIImage(systemName: "xmark")
        closeButton.imageEdgeInsets = UIEdgeInsets(top: 0,left: 0,bottom: 0,right: 0)
        closeButton.setImage(closeIcon, for: .normal)
        closeButton.imageView?.contentMode = .scaleAspectFill
        view.subviews(closeButton,
                      imageView,
                      selectImageButton,
                      postButton,
                      textView)
                
        selectImageButton.backgroundColor = .systemBlue
        postButton.backgroundColor = .systemBlue
        view.layout(50,
                    closeButton.left(0).height(100).width(100).top(0),
                    10,
                    |-10-imageView.fillHorizontally().heightEqualsWidth()-10-|,
                    |-selectImageButton.fillHorizontally().height(60)-|,
                    10,
                    |-textView.fillHorizontally().height(200)-|,
                    40,
                    |-20-postButton.fillHorizontally().height(60)-20-|,
                    50)
        
        selectImageButton.Top == view.Top/2
        selectImageButton.setTitle("Select Image", for: .normal)
        postButton.setTitle("Post", for: .normal)
        selectImageButton.addTarget(self, action: #selector(imageTapped(_:)), for: UIControl.Event.touchUpInside)
        closeButton.addTarget(self, action: #selector(closeButtonTapped(_:)), for: UIControl.Event.touchUpInside)
        postButton.addTarget(self, action: #selector(tappedPost(_:)), for: UIControl.Event.touchUpInside)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped(_:)))
        imageView.addGestureRecognizer(tapGesture)
        originalPostButtonColor = postButton.backgroundColor!
        super.viewDidLoad()
        self.configureAddCommentTextView()
        textView.text = "Please enter text"
        textView.font = UIFont.systemFont(ofSize: 19.0)
        
        postButton.isEnabled = false
        print("barva: \(postButton.backgroundColor ?? UIColor.red)")
        postButton.backgroundColor = .gray
        selectImageButton.layer.cornerRadius = 15;
    }
    
    override func viewDidAppear(_ animated: Bool) {
        id = UUID() //Generuje unikatni UUID
        if delegate != nil {
            print("Delegate set to: \(delegate!)")
        }
        if (imageView.image == nil) {
            //AddImageButton.isHidden = false
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        postButton.layer.cornerRadius = 15
    }
    
    func configureAddCommentTextView() {
        self.textView.delegate = self
        textView.textColor = .darkGray
        textView.layer.cornerRadius = 15;
        textView.layer.masksToBounds = true;
        textView.layer.borderWidth = 0;
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        textView.textColor = UIColor.label
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor(red: 0, green: 0.5, blue: 1, alpha: 1).cgColor
    }
}

extension AddPostViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage {
            imageView.image = image
            postButton.backgroundColor = originalPostButtonColor
            postButton.isEnabled = true
            selectImageButton.isHidden = true
        } else {
            print("None image selected")
        }
        let localURL: NSURL = info[.imageURL] as! NSURL
        
        print("Selected Image filename: \(localURL.lastPathComponent!)")
        dismiss(animated: true, completion: nil)
    }
}

extension AddPostViewController: UITextViewDelegate {
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
