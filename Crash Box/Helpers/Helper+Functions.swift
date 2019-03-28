//
//  Helper+Functions.swift
//  Crash Box
//
//  Created by Sarvad shetty on 3/28/19.
//  Copyright © 2019 Sarvad shetty. All rights reserved.
//

import UIKit

extension UIColor{
    convenience init(_ r: Float,_ g: Float,_ b: Float,_ a: Float) {
        self.init(red: CGFloat(r/255), green: CGFloat(g/255), blue: CGFloat(b/255), alpha: CGFloat(a))
    }
}
