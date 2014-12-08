//
//  ADIconCell.swift
//  alldayDO
//
//  Created by Fábio Nogueira  on 07/12/14.
//  Copyright (c) 2014 F√°bio Nogueira . All rights reserved.
//

import UIKit

@objc
class ADIconCell: UICollectionViewCell {
    
    var iconImageView: UIImageView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.iconImageView = UIImageView(frame: self.bounds)
        self.initialize()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func initialize() {
        self.addSubview(self.iconImageView!)
    }

}
