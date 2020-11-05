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
    
    func retrieveFullImagePath(imageName: String) -> String {
        return sharedImageManager.galleryPath.appendingPathComponent(imageName).appendingPathExtension("jpg").path
    }
    
    func saveImage(image: UIImage, name: String) {
        if let data = image.jpegData(compressionQuality: 0.9) {
            do {
                let fullPathWithFilename: URL = galleryPath.appendingPathComponent(name).appendingPathExtension("jpg")
                print("Writing data to \(fullPathWithFilename)")
                try data.write(to: fullPathWithFilename)
            } catch {
                print("Could not write to document directory")
            }
        }
    }
    
    func loadImage(image: String) -> UIImage {
        let loadedImage: UIImage!
        print("Trying to load image from: \(retrieveFullImagePath(imageName: image))")
        loadedImage = UIImage(contentsOfFile: retrieveFullImagePath(imageName: image))
        return loadedImage
    }
    
    func deleteImage(name: String) {
        let fullPath = retrieveFullImagePath(imageName: name)
        
        do {
            try FileManager.default.removeItem(at: URL(fileURLWithPath: fullPath))
        } catch {
            print("Couldnt delete image")
        }
    }
    
    func listSavedImages() -> [String] {
        let fm = FileManager.default
        var fullPathImages: [String] = []
        let listedImages = try! fm.contentsOfDirectory(atPath: sharedImageManager.galleryPath.path)
        
        for imageName in listedImages {
            var newPath: URL = URL(fileURLWithPath: sharedImageManager.galleryPath.absoluteString)
            newPath = newPath.appendingPathComponent(imageName)
            fullPathImages.append(newPath.absoluteString)
        }
        
        return fullPathImages
    }
}
