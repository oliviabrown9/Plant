//
//  UIConstants.swift
//  Plant
//
//  Created by Olivia Brown on 8/19/18.
//  Copyright © 2018 Olivia Brown. All rights reserved.
//

import Foundation
import UIKit

class UIConstants {

    struct colors {
        static let defaultGreen = UIColor(red:0.30, green:0.87, blue:0.40, alpha:1.0)
        static let disabledGreen = #colorLiteral(red: 0.2862745098, green: 0.7294117647, blue: 0.3607843137, alpha: 1)
        static let enabledGreen = UIColor(red:0.21, green:0.48, blue:0.26, alpha:1.0)
    }

    struct layout {
        static let tableViewHeight: CGFloat = 87
        static let tableViewTopInset: CGFloat = 25
        static let tableViewBottomInset: CGFloat = -15
        static let leafBottomOffset: CGFloat = 21
        static let sideButtonEdgeInset: CGFloat = 15
        static let sideButtonBottomInset: CGFloat = 50
    }
}
