//
//  CommentCell.swift
//  CyberBites
//
//  Created by Anthony Ronca on 3/9/19.
//  Copyright © 2019 Anthony Ronca. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {
    
    //  OUTLETS
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var commentLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
