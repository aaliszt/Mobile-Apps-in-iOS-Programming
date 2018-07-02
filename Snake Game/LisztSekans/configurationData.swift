//
//  configurationData.swift
//  LisztSekans
//
//  Created by Aaron Liszt on 5/5/18.
//  Copyright © 2018 Aaron Liszt. All rights reserved.
//

import Foundation
import UIKit


class dataManager{
    static let globalDataObj = dataManager(pWins: 0, cWins: 0, lSteps: 0, spd: 0.5)
    
    // Data
    var pWins: Int  // Player Wins
    var cWins: Int  // Computer Wins
    var lSteps: Int // Steps in last game
    var spd: TimeInterval // Speed of game
    
    private init(pWins: Int, cWins: Int, lSteps: Int, spd: TimeInterval){
        self.pWins = pWins
        self.cWins = cWins
        self.lSteps = lSteps
        self.spd = spd
    }
}
