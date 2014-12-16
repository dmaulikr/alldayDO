//
//  ADBadgeImageView.swift
//  alldayDO
//
//  Created by Fábio Nogueira  on 07/12/14.
//  Copyright (c) 2014 F√°bio Nogueira . All rights reserved.
//

import UIKit

@objc
class ADBadgeImageView: UIImageView {

    var badgeIconImageView : UIImageView?

    override init(frame: CGRect) {
        super.init(frame: frame);
        self.image = UIImage(named: "Hexacon")
        self.initBadgeIconImageView()
        
        if let badgeIconImageView = self.badgeIconImageView {
            self.addSubview(badgeIconImageView)
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    internal func initBadgeIconImageView() {
        self.badgeIconImageView = UIImageView()
        self.badgeIconImageView?.frame = CGRectMake(0, 0, 34, 34)
        self.badgeIconImageView?.center = self.center;
    }
}
