//
//  AddItemVC.swift
//  InstagramClone_mine
//
//  Created by Steve on 14/10/2020.
//

import UIKit
import Foundation

class AddItemVC: UIViewController {
    lazy var appDelegate = (UIApplication.shared.delegate as! AppDelegate)
    lazy var context = appDelegate.persisentContainer.viewContext
    
    var id = UUID()
    var fm = FileManager.default
    
    @IBOutlet weak var textField: UITextView!
    @IBOutlet weak var debugLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBAction func tappedPost(_ sender: Any) {
        let post = Post(context: context)
        post.date = Date()
        post.id = id
        post.label = textField.text
        post.image = id.uuidString // Just stores name of the image
        sharedImageManager.saveImage(image: imageView.image!, name: self.id.uuidString)
        
        do {
            try self.context.save()
            print("Saved Post to Core Data")
        } catch {
            
        }
    }
    
    var mainBundlePath = Bundle.main.resourcePath!
    
    @IBAction func AddImage(_ sender: Any) {
        let picker = UIImagePickerController()
            picker.allowsEditing = true
            picker.delegate = self
            present(picker, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = sharedImageManager.loadImage(image: "MyName.jpg")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        id = UUID() //Generuje unikatni UUID
    }
}

extension AddItemVC: UIImagePickerControllerDelegate & UINavigationControllerDelegate  {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage {
//            sharedImageManager.saveImage(image: image, name: "MyName.jpg")
            imageView.image = image
        } else {
            print("None image selected")
        }
        let localURL: NSURL = info[.imageURL] as! NSURL
        
        print("Selected Image filename: \(localURL.lastPathComponent!)")
        dismiss(animated: true, completion: nil)
    }
}
