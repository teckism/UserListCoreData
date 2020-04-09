//
//  Constants.swift
//  StockList
//
//  Created by Pankaj Teckchandani on 08/04/20.
//  Copyright © 2020 Pankaj Teckchandani. All rights reserved.
//

import UIKit


public struct Constants {
    static let mainStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
    struct Alerts {
        static let kUnableToReachServer = "Unable to reach server"
        static let kErrorKey = "Error"
        
        static let kNoInternetConnection = "No Internet Connection"
        
    }
    
    struct WebServices {
        static let kGetListOfUsers = "5e8dcf95753e041b892bbefb"
        static let kLogin = ""
    }
    
    struct CellIdentifiers {
        static let kUserListItemCell = "userListItemCell"
        
    }
    struct Images {
        static let imageForUserPlaceholder = UIImage(named : "user")!
        static let imageForTick = UIImage(named : "tick")!
        static let imageForCross = UIImage(named : "close")!
    }
    
    struct StaticStrings {
        static let kStringForUserListTitle = "User Listing"
        
    }
    
    struct Colors {
        static let kSaveColor = UIColor(hex: "#F2B42CFF")
        static let kRemoveColor = UIColor.black
    }
}
