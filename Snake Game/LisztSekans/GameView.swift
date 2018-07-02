//
//  GameView.swift
//  LisztSekans
//
//  Created by Aaron Liszt on 4/23/18.
//  Copyright © 2018 Aaron Liszt. All rights reserved.
//

import UIKit



class GameView: UIView {

    var initialBoard:Bool = true
    
    // Player start point = (0, 0)
    var playerX = 0                         // Snake X position
    var playerY = 0                         // Snake Y position
    var playClr: UIColor = UIColor.blue     // Snake Head Color
    
    // CPU start point = (380, 380)
    var cpuX = 380                          // CPU X position
    var cpuY = 380                          // CPU Y position
    var cpuClr: UIColor = UIColor.magenta   // Computer Head Color
    
    var snakeLW = 20    // Snake moves in intervals of 20
    
    // Background Variables
    // The background grid is broken up into 20x20 pixel squares
    var bgWidth = 400   // 20 squares(Columns)
    var bgHeight = 400  // by 20 squares(Rows) (400/20)
    var bgColor: UIColor = UIColor.lightGray
    
    // Array only holds only 2 values to represent the state of a point on the grid
    // 0 = empty square on board
    // 1 = black square on board
    var gameGrid = Array(repeating: Array(repeating: 0, count: 21), count: 21)
    // add 1 to compensate for running from 0 to 19
    
    var drawLayer: CGLayer?
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        checkDrawLayer(context)
        
        // Draw board during initial setup phase
        if(initialBoard){
            drawBoard()
            initialBoard = false
        }
        
        // Draw player and cpu snake heads
        let playerRect = CGRect(x: playerX, y: playerY, width: snakeLW, height: snakeLW)
        doDraw(rect: playerRect, usingFillColor: playClr)
        let cpuRect = CGRect(x: cpuX, y: cpuY, width: snakeLW, height: snakeLW)
        doDraw(rect: cpuRect, usingFillColor: cpuClr)
        
        context?.draw(drawLayer!, in: self.bounds)
    }
    
    func doDraw(rect theRect : CGRect, usingFillColor fillColor: UIColor){
        // Get layer context
        let layer_context = drawLayer!.context
        
        // Set context fill color
        layer_context?.setFillColor(fillColor.cgColor)
        
        // Added
        layer_context?.setStrokeColor(fillColor.cgColor)
        
        // Draw the rectangle
        layer_context!.addRect(theRect)
        layer_context!.drawPath(using: .fillStroke)
    }
    
    func checkDrawLayer(_ context: CGContext?){
        if drawLayer == nil{
            // Create a layer if we dont have one
            let size = CGSize(width: self.bounds.size.width, height: self.bounds.size.height)
            drawLayer = CGLayer(context!, size: size, auxiliaryInfo: nil)
        }
    }
    
    // Initialize the game grid to all 0's
    func initializeGrid(){
        for row in 0 ..< gameGrid.count{
            for col in 0 ..< gameGrid[row].count{
                    gameGrid[row][col] = 0
            }
        }
    }
    
    // Set a specified position on the grid to 'filled' == (1)
    // And fill in the grid square with the appropriate body color
    func fillGridPosition(row: Int, col: Int, color: UIColor){
        gameGrid[row][col] = 1
        let bodyRect = CGRect(x: col*20, y: row*20, width: snakeLW, height: snakeLW)
        doDraw(rect: bodyRect, usingFillColor: color)
    }
    
    // Returns true if the position is filled (= 1)
    // Returns false if the position is empty (= 0)
    func checkGridPosition(row: Int, col: Int) -> Bool{
        if(gameGrid[row][col] == 1){
            return true
        }
        else{
            return false
        }
    }
    
    // Draw the game board & surrounding peices
    func drawBoard(){
        let aestheticRect = CGRect(x: 0, y: 0, width: 450, height: 420)
        let aestheticBar = CGRect(x: 0, y: 420, width: 450, height: 20)
        let playBG = CGRect(x: 0, y: 0, width: bgWidth, height: bgHeight)
        
        doDraw(rect: aestheticRect, usingFillColor: UIColor.darkGray)
        doDraw(rect: aestheticBar, usingFillColor: UIColor.black)
        doDraw(rect: playBG, usingFillColor: bgColor)
    }
}
