//
//  InfoViewController.swift
//  LisztSekans
//
//  Created by Aaron Liszt on 4/23/18.
//  Copyright © 2018 Aaron Liszt. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {

    // Statistic Labels
    @IBOutlet weak var playerWinsLabel: UILabel!
    @IBOutlet weak var cpuWinsLabel: UILabel!
    @IBOutlet weak var lastStepsLabel: UILabel!
    
    var playerWins = 0      // Refernce to playerWins for ConfigView
    var cpuWins = 0         // Reference to cpuWins for ConfigView
    var movesLastGame = 0   // Refernce to laastMoves for ConfigView

    var spd: TimeInterval = 0.0 // Refernce to delay(gameSpeed) for ConfigView
    var ranStart = false        // Refernce to randomStart val for ConfigView
    var ranBody = false         // Reference to randomColor val for ConfigView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLabels()     // Set the values for stat labels
        
        // Store data from other tabBarController to be passed back to gameVC
        let tabBarViewControllers = self.tabBarController?.viewControllers
        let configVC = tabBarViewControllers![0] as! ConfigViewController
        
        spd = configVC.gameSpeed
        ranStart = configVC.rStart
        ranBody = configVC.rColor
    }

    @IBAction func resetStats(_ sender: UIButton) {
        playerWins = 0
        cpuWins = 0
        movesLastGame = 0
        setLabels()
    }
    
    // Set the value of all statistic labels
    func setLabels(){
        playerWinsLabel.text = String(playerWins)
        cpuWinsLabel.text = String(cpuWins)
        lastStepsLabel.text = String(movesLastGame)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let gameVData = segue.destination as! GameViewController
        
        // Pass all data from both tabBar ViewControllers back to GameViewController in order to retain the data
        gameVData.playerWins = playerWins
        gameVData.cpuWins = cpuWins
        gameVData.lastMoves = movesLastGame
        gameVData.delay = spd
        gameVData.useRandomStart = ranStart
        gameVData.useRandomBody = ranBody
    }
}
