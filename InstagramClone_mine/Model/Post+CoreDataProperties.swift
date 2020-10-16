//
//  Post+CoreDataProperties.swift
//  InstagramClone_mine
//
//  Created by Steve on 15/10/2020.
//
//

import Foundation
import CoreData


extension Post {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Post> {
        return NSFetchRequest<Post>(entityName: "Post")
    }

    @NSManaged public var date: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var image: String?
    @NSManaged public var label: String?
    @NSManaged public var comment: NSSet?

}

// MARK: Generated accessors for comment
extension Post {

    @objc(addCommentObject:)
    @NSManaged public func addToComment(_ value: Comment)

    @objc(removeCommentObject:)
    @NSManaged public func removeFromComment(_ value: Comment)

    @objc(addComment:)
    @NSManaged public func addToComment(_ values: NSSet)

    @objc(removeComment:)
    @NSManaged public func removeFromComment(_ values: NSSet)

}

extension Post : Identifiable {

}
