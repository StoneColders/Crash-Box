//
//  CustomTabbarHeader.swift
//  Crash Box
//
//  Created by Sarvad shetty on 3/28/19.
//  Copyright © 2019 Sarvad shetty. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let containerView = UIView()
        containerView.backgroundColor = flashyRed
        view.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containerView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        // anchor your view right above the tabBar
        containerView.bottomAnchor.constraint(equalTo: tabBar.topAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 5).isActive = true
    }
}
