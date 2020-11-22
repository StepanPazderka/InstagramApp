//
//  DatabaseManager.swift
//  InstagramClone_mine
//
//  Created by Steve on 08/11/2020.
//

import Foundation
import UIKit
import CoreData

class DatabaseManager: UIView {
    lazy var appDelegate = (UIApplication.shared.delegate as! AppDelegate)
    lazy var context = appDelegate.persisentContainer.viewContext
    
    func loadAllPosts() -> [Post] {
        var postsArray: [Post] = []
        
        do {
            let fetchRequest = NSFetchRequest<Post>(entityName: "Post")
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
            postsArray = try context.fetch(fetchRequest)
        }
        catch {
            print(error.localizedDescription)
        }
        
        return postsArray
    }
    
    func loadPostsWithPredicate(predicate: NSPredicate) -> [Post] {
        var postsArray: [Post] = []
        
        do {
            let fetchRequest = NSFetchRequest<Post>(entityName: "Post")
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
            fetchRequest.predicate = predicate
            postsArray = try context.fetch(fetchRequest)
        }
        catch {
            
        }
        
        return postsArray
    }
    
    func loadCommentsWithPredicate(predicate: NSPredicate) -> [Comment] {
        var postsArray: [Comment] = []
        
        do {
            let fetchRequest = NSFetchRequest<Comment>(entityName: "Comment")
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
            fetchRequest.predicate = predicate
            postsArray = try context.fetch(fetchRequest)
        }
        catch {
            
        }
        
        return postsArray
    }
    
    func loadPost(id: UUID) -> Post {
        var loadedPost: Post
        
        let fetchRequest = NSFetchRequest<Post>(entityName: "Post")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        loadedPost = try! context.fetch(fetchRequest).first!
        
        return loadedPost
    }
    
    func addComment(parentPost: Post, commentContent: String) {
        let newComment = Comment(context: context)
        newComment.date = Date()
        newComment.parentPost = parentPost
        newComment.text = commentContent
        
        do {
            try self.context.save()
            print("Saved Comment to Core Data")
        } catch {
            print("Error while saving to Core Data")
        }
    }
    
    func addPost(id: UUID, label: String, image: UIImage) {
        let post = Post(context: context)
        post.date = Date()
        post.id = id
        post.image = id.uuidString
        
        if label.contains("Please enter text") {
            post.label = nil
        } else {
            post.label = label
        }
        
        do {
            try self.context.save()
            print("Saved Post to Core Data")
            sharedImageManager.saveImage(image: image, name: id.uuidString)
        } catch {
            print("Error while saving to Core Data")
        }
    }
}
