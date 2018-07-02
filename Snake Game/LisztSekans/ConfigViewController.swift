//
//  ConfigViewController.swift
//  LisztSekans
//
//  Created by Aaron Liszt on 4/23/18.
//  Copyright © 2018 Aaron Liszt. All rights reserved.
//

import UIKit

class ConfigViewController: UIViewController {
    
    @IBOutlet weak var speedSlider: UISlider!
    @IBOutlet weak var randStart: UISwitch!
    @IBOutlet weak var randStartStatusLabel: UILabel!
    @IBOutlet weak var randBody: UISwitch!
    @IBOutlet weak var randBodyStatusLabel: UILabel!
    
    var gameSpeed: TimeInterval = 0.5   // Reference to gameSpeed for configView
    var rStart = false                  // Reference to randomStart for configView
    var rColor = false                  // Reference to randomColor for configView
    var pWins = 0                       // Reference to player wins for configView
    var cWins = 0                       // Reference to computer wins for configView
    var lMove = 0                       // Reference to lastMoves for configView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //randStart.isOn = UserDefaults.standard.bool(forKey: "randStart")
        //randBody.isOn = UserDefaults.standard.bool(forKey: "randBody")
        //speedSlider.value = UserDefaults.standard.float(forKey: "speedSlider")
        
        // Update Sliders & Switchs to have appropriate values
        speedSlider.value = Float(gameSpeed)
        speedSliderValue.text = String(gameSpeed)
        randStart.isOn = rStart
        setRStartLabel()
        randBody.isOn = rColor
        setRColorLabel()
        
        // Store data from other tabBarController to be passed back to gameVC
        let tabBarViewControllers = self.tabBarController?.viewControllers
        let dataVC = tabBarViewControllers![1] as! InfoViewController
        
        pWins = dataVC.playerWins
        cWins = dataVC.cpuWins
        lMove = dataVC.movesLastGame
    }
    
    @IBOutlet weak var speedSliderValue: UILabel!
    @IBAction func speedSlider(_ sender: UISlider) {
        let newSpeed = TimeInterval(sender.value)
        gameSpeed = newSpeed
        speedSliderValue.text = String(sender.value)
        
        //Save State
        //let sliderState = speedSlider.value
        //UserDefaults.standard.set(sliderState, forKey: "speedSlider")
        //UserDefaults.standard.synchronize()
    }
    
    @IBAction func useRandomStart(_ sender: UISwitch) {
        rStart = sender.isOn
        setRStartLabel()
        
        //Save State
        //let switchState = randStart.isOn
        //UserDefaults.standard.set(switchState, forKey: "randStart")
        //UserDefaults.standard.synchronize()
    }
    
    @IBAction func useRandomBody(_ sender: UISwitch) {
        rColor = sender.isOn
        setRColorLabel()
        
        //Save State
        //let switchState = randBody.isOn
        //UserDefaults.standard.set(switchState, forKey: "randBody")
        //UserDefaults.standard.synchronize()
    }
    
    func setRStartLabel(){
        if(rStart){
            randStartStatusLabel.text = "On"
        }
        else{
            randStartStatusLabel.text = "Off"
        }
    }
    
    func setRColorLabel(){
        if(rColor){
            randBodyStatusLabel.text = "On"
        }
        else{
            randBodyStatusLabel.text = "Off"
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let gameViewData = segue.destination as! GameViewController
        
        // Pass all data from both tabBar ViewControllers back to GameViewController in order to retain the data
        gameViewData.delay = gameSpeed
        gameViewData.playerWins = pWins
        gameViewData.cpuWins = cWins
        gameViewData.lastMoves = lMove
        gameViewData.useRandomStart = rStart
        gameViewData.useRandomBody = rColor
    }
}
