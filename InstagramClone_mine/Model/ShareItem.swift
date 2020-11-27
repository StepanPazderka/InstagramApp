//
//  ShareItem.swift
//  InstagramClone_mine
//
//  Created by Steve on 27/11/2020.
//

import Foundation
import UIKit
import LinkPresentation

class ShareItemDetails: NSObject {
    var URL: URL?
    var image: UIImage?
    
    init(URL: URL) {
        self.URL = URL
    }
}

extension ShareItemDetails: UIActivityItemSource {
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return ""
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        return nil
    }
    
    func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
        let image = UIImage(contentsOfFile: URL!.path)!
        let imageProvider = NSItemProvider(object: image)
        let metadata = LPLinkMetadata()
        metadata.imageProvider = imageProvider
        return metadata
    }
}
