//
//  FileManager.swift
//  InstagramClone_mine
//
//  Created by Steve on 14/10/2020.
//

import Foundation
import UIKit

let sharedImageManager = ImageManager()

class ImageManager {
    public var galleryPath: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    init() {
        
    }
    
    func saveImage(image: UIImage, name: String) {
        if let data = image.jpegData(compressionQuality: 0.9) {
            do {
                let fullPathWithFilename = galleryPath.appendingPathComponent(name)
                print("Writing data to \(fullPathWithFilename)")
                try data.write(to: fullPathWithFilename)
            } catch {
                print("Could not write to document directory")
            }
        }
    }
    
    func loadImage(image: String) -> UIImage {
        let loadedImage: UIImage!
        let documentDirectory = sharedImageManager.galleryPath
        let fullFilePath = documentDirectory.appendingPathComponent(image)
        print("Trying to load image from: \(fullFilePath)")
        loadedImage = UIImage(contentsOfFile: fullFilePath.path)
        return loadedImage
    }
    
    func listSavedImages() -> [String] {
        let fm = FileManager.default
        let listedImages = try! fm.contentsOfDirectory(atPath: sharedImageManager.galleryPath.path)
//        for image in listedImages {
//            print("Found image: \(image)")
//        }
        return listedImages
    }
}
