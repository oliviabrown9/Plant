//
//  ServingType.swift
//  Plant
//
//  Created by Olivia Brown on 9/15/18.
//  Copyright © 2018 Olivia Brown. All rights reserved.
//

import Foundation

class ServingType: Equatable {

    private(set) var title: String
    private(set) var key: String
    private(set) var defaultMax: Int

    init(title: String, key: String, defaultMax: Int) {
        self.title = title
        self.key = key
        self.defaultMax = defaultMax
    }

    static func == (lhs: ServingType, rhs: ServingType) -> Bool {
        return lhs.key == rhs.key
    }
}

class ServingTypes {

    lazy var leafyVegetables = {
        ServingType(title: "leafy vegetables", key: "leafyVegetables", defaultMax: 2)
    }

    lazy var otherVegetables = {
        ServingType(title: "other vegetables", key: "otherVegetables", defaultMax: 2)
    }

    lazy var berries = {
        ServingType(title: "berries", key: "berries", defaultMax: 1)
    }

    lazy var otherFruit = {
        ServingType(title: "other fruit", key: "otherFruit", defaultMax: 3)
    }

    lazy var wholeGrains = {
        ServingType(title: "whole grains", key: "wholeGrains", defaultMax: 5)
    }

    lazy var legumes = {
        ServingType(title: "legumes", key: "legumes", defaultMax: 2)
    }

    lazy var nutsAndSeeds = {
        ServingType(title: "nuts & seeds", key: "nutsAndSeeds", defaultMax: 1)
    }

}
