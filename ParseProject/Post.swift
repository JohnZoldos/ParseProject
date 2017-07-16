//
//  Post.swift
//  ParseProject
//
//  Created by John Zoldos on 7/15/17.
//  Copyright © 2017 John Zoldos. All rights reserved.
//

import UIKit
import Parse

class Post: NSObject {
    
    var image: UIImage?
    var caption: String?
    
    init(image: UIImage, caption: String){
        self.image = image
        self.caption = caption
    }
    
    /*init(parseObject: PFObject){
        self.caption = parseObject["caption"] as? String
        let file = parseObject["media"] as? PFFile
        if let file = file {
            file.getDataInBackground({ (imageData: Data?, error: Error?) -> Void in
                let image = UIImage(data: imageData!)
                if image != nil {
                    self.image = image
                }
            })
        }


        
    }*/
    
    
    func postUserImage(withCompletion completion: PFBooleanResultBlock?) {
        // Create Parse object PFObject
        let post = PFObject(className: "Post")
        
        // Add relevant fields to the object
        if let image = self.image {
            let imageData: Data? = UIImagePNGRepresentation(image)
            let file = PFFile(name: "image.png", data: imageData!)
            post["media"] = file
        }
        post["author"] = PFUser.current() // Pointer column type that points to PFUser
        post["caption"] = self.caption
        post["likesCount"] = 0
        post["commentsCount"] = 0
        
        // Save object (following function will save the object in Parse asynchronously)
        post.saveInBackground(block: completion)
    }
}
