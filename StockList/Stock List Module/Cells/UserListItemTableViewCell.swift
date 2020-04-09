//
//  UserListItemTableViewCell.swift
//  StockList
//
//  Created by Pankaj Teckchandani on 08/04/20.
//  Copyright © 2020 Pankaj Teckchandani. All rights reserved.
//

import UIKit
import SDWebImage

class UserListItemTableViewCell: UITableViewCell {

    @IBOutlet weak var imageViewForProfilePicture: UIImageView!
    @IBOutlet weak var labelForUsername: UILabel!
    @IBOutlet weak var labelForFullname: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    
    func loadUser(user : SLUser){
        
        self.labelForUsername.text = "@\(user.username ?? "")"
        self.labelForFullname.text = user.displayName ?? ""
        
        self.imageViewForProfilePicture.sd_setImage(with: URL(string: user.avatarUrl ?? ""), placeholderImage: Constants.Images.imageForUserPlaceholder, options: .scaleDownLargeImages, completed:{ (image, error, cacheType, imageURL) in
        })
        
    }
}

