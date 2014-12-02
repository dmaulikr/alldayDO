//
//  ADStyleSheet.swift
//  alldayDO
//
//  Created by Fábio Almeida on 12/2/14.
//  Copyright (c) 2014 F√°bio Nogueira . All rights reserved.
//

import UIKit

@objc
class ADStyleSheet: NSObject {
    class func initStyles() {
        let navigation_bg = UIImage(named: "navigation_bg")
        
        UINavigationBar.appearance().setBackgroundImage(navigation_bg, forBarMetrics: UIBarMetrics.Default)
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
    }
}