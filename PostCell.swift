//
//  PostCell.swift
//  
//
//  Created by Anthony Ronca on 3/7/19.
//
// ASDFGHJFSDKHJFKJAHFSDKHJDFFHADKDFHAFKKNBF

import UIKit

class PostCell: UITableViewCell {

    @IBOutlet var photoView: UIImageView!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var captionLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
