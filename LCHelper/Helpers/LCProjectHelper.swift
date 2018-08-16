//
//  LCProjectHelper.swift
//  LCHelper
//
//  Created by Hassam Solano-Morel on 5/24/18.
//  Copyright © 2018 SolanoSoftwareSolutionsLLC. All rights reserved.
//

import Foundation

public class LCProjectHelper{
    private let helper:LCHelper
    private let group:DispatchGroup = DispatchGroup()
    init(HelperRoot root:LCHelper) {
        self.helper = root
    }
}
