//
//  CameraVC.swift
//  InstagramClone_mine
//
//  Created by Steve on 13/10/2020.
//

import UIKit

class CameraVC: UIViewController {
    
    private var pickerView: UIImagePickerController?

    override func viewDidLoad() {
        super.viewDidLoad()

        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            pickerView = {
                let picker = UIImagePickerController()
                picker.sourceType = .camera
                picker.allowsEditing = true
                return picker
            }()
        } else {
            let labelView = UILabel()
            labelView.text = "There is no camera on the device, perhaps you are in simulator?"
            //labelView.lineBreakMode = .byCharWrapping
            labelView.numberOfLines = 2
            labelView.textAlignment = .center
            labelView.frame = CGRect(x:0, y: 0, width: view.frame.width, height: view.frame.height)
            view.addSubview(labelView)
        }
    }
}

extension CameraVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
}
