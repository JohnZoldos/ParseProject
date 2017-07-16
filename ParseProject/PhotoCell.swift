//
//  PhotoCell.swift
//  ParseProject
//
//  Created by John Zoldos on 7/15/17.
//  Copyright © 2017 John Zoldos. All rights reserved.
//

import UIKit
import Parse

class PhotoCell: UITableViewCell {
    
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var caption: UILabel!
    
    
    var post: Post!{
        didSet{
            photo.image = post.image
            caption.text = post.caption
            
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
            }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
