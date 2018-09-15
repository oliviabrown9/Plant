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
        static let defaultGreen = #colorLiteral(red: 0.2980392157, green: 0.8509803922, blue: 0.3921568627, alpha: 1)
        static let disabledGreen = #colorLiteral(red: 0.2862745098, green: 0.7294117647, blue: 0.3607843137, alpha: 1)
//            UIColor(red:0.29, green:0.73, blue:0.36, alpha:1.0)
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
