//
//  GameViewController.swift
//  LisztSekans
//
//  Created by Aaron Liszt on 4/23/18.
//  Copyright © 2018 Aaron Liszt. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    @IBOutlet weak var startButton: UIButton!
    @IBOutlet var gameView: GameView!
    @IBOutlet weak var gameStatusLabel: UILabel!
    @IBOutlet weak var gameStepsLabel: UILabel!
    @IBOutlet weak var playerDirectionLabel: UILabel!
    
    var initialSetup = true // Is this the first time running the game?
    var pause = false       // Is the timer on?
    var gameOver = false    // Is the game over?
    var numMoves = 0        // Number of moves in the current game
    var lastMoves = 0       // Number of moves in the last game (for stats)
    
    var useRandomStart = false  // Starts the player and CPU in a random location
    var useRandomBody = false   // Each part of the snakes body is a random color
    
    //                  up = 2
    // Directions left = 0 | right = 1
    //                  down = 3
    var playerDir = 1
    var cpuDir = 0
    
    var playerWins = 0      // Number of wins for player
    var cpuWins = 0         // Number of wins for cpu
    
    var playerBodyColor = UIColor.black
    var cpuBodyColor = UIColor.black
    
    var timer: Timer!
    var delay: TimeInterval = 0.5   // Controls game speed
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        resetGame()
        gameView.setNeedsDisplay()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        stopGame()
        resetGame()
    }
    
    func stopGame(){
        // Stop the timer
        if let timer = timer{
            timer.invalidate()
        }
        // Remove reference to timer
        self.timer = nil
        initialSetup = true     // Must go through initial setup after leaving view
    }
    
    @IBAction func startGame(_ sender: UIButton) {
        // Update status
        pause = false
        
        // Set text labels
        gameStatusLabel.text = "Begin!"
        gameStepsLabel.text = "Moves 0"
        playerDirectionLabel.text = "Player Direction - Right"
        
        startButton.isEnabled = false   // Turn off start game button
        playerDir = 1
        
        // Start the timer
        if(initialSetup){
            self.timer = Timer.scheduledTimer(timeInterval: delay, target: self, selector: #selector(self.gameLoop), userInfo: nil, repeats: true)
            gameView.initializeGrid()   // setup the game grid
        }
        initialSetup = false    // We have completed initial setup
    }
    
    // Main game loop called every delay cycle by the timer
    @objc func gameLoop(){
        if(!pause){
            if(!gameOver){
                gameView.setNeedsDisplay()      // Update the view
                movePlayer()                    // Move the player
                moveCPU()                       // Move the cpu
                numMoves += 1                   // update number of moves
                gameStepsLabel.text = "Moves " + String(numMoves)
                checkGameStatus()               // check for if anyone won/lost
            }
            else{ // If the game ended
                lastMoves = numMoves    // store last movse
                resetGame()             // reset game values
            }
        }
    }
    
    // Look at the squares around computer and test if they are valid
    // Then choose a valid square at random
    func moveCPU(){
        //Check all grid suares around the computer
        let left = checkMove(xVal: gameView.cpuX - 20, yVal: gameView.cpuY)
        let right = checkMove(xVal: gameView.cpuX + 20, yVal: gameView.cpuY)
        let up = checkMove(xVal: gameView.cpuX, yVal: gameView.cpuY - 20)
        let down = checkMove(xVal: gameView.cpuX, yVal: gameView.cpuY + 20)
        
        if(useRandomBody){
            cpuBodyColor = getRandomColor()
        }
        else{
            cpuBodyColor = UIColor.black
        }
        
        
        // If all possible move are invalid the cpu is trapped and must lose
        if(!left && !right && !up && !down){
            playerWins += 1
            gameStatusLabel.text = "Human Wins!"
            gameOver = true
        }
        else{ // Otherwise choose a random valid grid space to move to
            var moved = false
            while(!moved){
                let randDir = Int(arc4random_uniform(4)) // 'Roll' the dice
                // Use the random number (0-3) to chose the computer direction
                if(randDir == 0 && left){
                    gameView.cpuX -= 20
                    moved = true
                    checkGameStatus()
                    if(!gameOver){
                        gameView.fillGridPosition(row: gameView.cpuY / 20, col: (gameView.cpuX+20)/20, color: cpuBodyColor)
                    }
                    else{
                        gameView.cpuX += 20
                    }
                }
                else if(randDir == 1 && right){
                    gameView.cpuX += 20
                    moved = true
                    checkGameStatus()
                    if(!gameOver){
                        gameView.fillGridPosition(row: gameView.cpuY / 20, col: (gameView.cpuX-20)/20, color: cpuBodyColor)
                    }
                    else{
                        gameView.cpuX -= 20
                    }
                }
                else if(randDir == 2 && up){
                    gameView.cpuY -= 20
                    moved = true
                    checkGameStatus()
                    if(!gameOver){
                        gameView.fillGridPosition(row: (gameView.cpuY+20)/20, col: gameView.cpuX / 20, color: cpuBodyColor)
                    }
                    else{
                        gameView.cpuY += 20
                    }
                }
                else if(randDir == 3 && down){
                    gameView.cpuY += 20
                    moved = true
                    checkGameStatus()
                    if(!gameOver){
                        gameView.fillGridPosition(row: (gameView.cpuY-20)/20, col: gameView.cpuX / 20, color: cpuBodyColor)
                    }
                    else{
                        gameView.cpuY -= 20
                    }
                }
                else{
                    // continue looping until a valid square is chosen
                }
            }
        }
    }
    
    // Check if the next move is to a valid position
    // Return true if the move is valid and false otherwise
    func checkMove(xVal: Int, yVal: Int) -> Bool{
        // If the position is out of bounds or to a black square it is invalid
        if(xVal < 0 || yVal < 0 || xVal >= gameView.bgWidth || yVal >= gameView.bgHeight || gameView.checkGridPosition(row: yVal / 20, col: xVal / 20) == true){
            return false;
        }
        // Otherwise the move is valid
        else{
            return true;
        }
    }
    
    // Move the players snakehead based on the current direction
    func movePlayer(){
        if(useRandomBody){
            playerBodyColor = getRandomColor()
        }
        else{
            playerBodyColor = UIColor.black
        }
        
        switch(playerDir){
        case 0: // LEFT
            gameView.playerX -= 20
            checkGameStatus()
            if(!gameOver){
                gameView.fillGridPosition(row: gameView.playerY / 20, col: (gameView.playerX+20)/20, color: playerBodyColor)
            }
            else{
                gameView.playerX += 20
            }
            break
        case 1: // RIGHT
            gameView.playerX += 20
            checkGameStatus()
            if(!gameOver){
                gameView.fillGridPosition(row: gameView.playerY / 20, col: (gameView.playerX-20)/20, color: playerBodyColor)
            }
            else{
                gameView.playerX -= 20
            }
            break
        case 2: // UP
            gameView.playerY -= 20
            checkGameStatus()
            if(!gameOver){
                gameView.fillGridPosition(row: (gameView.playerY+20)/20, col: gameView.playerX / 20, color: playerBodyColor)
            }
            else{
                gameView.playerY += 20
            }
            break
        case 3: // DOWN
            gameView.playerY += 20
            checkGameStatus()
            if(!gameOver){
                gameView.fillGridPosition(row: (gameView.playerY-20)/20, col: gameView.playerX / 20, color: playerBodyColor)
            }
            else{
                gameView.playerY -= 20
            }
            break
        default:
            print("Player direction error - Invalid Direction Value")
            break
        }
    }
    
    // Check if either CPU or Player has won or lost the game
    func checkGameStatus(){
        if(!gameOver){
            //If player went out of bound on the left/right
            if(gameView.playerX >= gameView.bgWidth || gameView.playerX < 0){
                cpuWins += 1
                gameStatusLabel.text = "Computer Wins!"
                gameOver = true
            }
                //If player went out of bounds on the top/bottom
            else if(gameView.playerY >= gameView.bgHeight || gameView.playerY < 0){
                cpuWins += 1
                gameStatusLabel.text = "Computer Wins!"
                gameOver = true
            }
                // If the player collides with a body
            else if(gameView.checkGridPosition(row: gameView.playerY / 20, col: gameView.playerX / 20) == true){
                cpuWins += 1
                gameStatusLabel.text = "Computer Wins!"
                gameOver = true
            }
                // If the player and cpu collide head to head
            else if(gameView.playerX == gameView.cpuX && gameView.playerY == gameView.cpuY){
                gameStatusLabel.text = "Tie! Everyone Loses!"
                gameOver = true
            }
            else{
                // Do Nothing
                // No one has won or lost
            }
        }
    }
    
    // Set the players direction corresponding to the swipe gestures input by user
    @IBAction func upSwipe(_ sender: Any) {
        if(playerDir != 3){ // Snake cant run over itself
            playerDir = 2
        }
        playerDirectionLabel.text = "Player Direction - Up"
    }
    
    @IBAction func downSwipe(_ sender: UISwipeGestureRecognizer) {
        if(playerDir != 2){
            playerDir = 3
        }
        playerDirectionLabel.text = "Player Direction - Down"
    }
    
    @IBAction func leftSwipe(_ sender: Any) {
        if(playerDir != 1){
            playerDir = 0
        }
        playerDirectionLabel.text = "Player Direction - Left"
    }
    
    @IBAction func rightSwipe(_ sender: Any) {
        if(playerDir != 0){
            playerDir = 1
        }
        playerDirectionLabel.text = "Player Direction - Right"
    }
    
    // Reset the game board when a game ends
    func resetGame(){
        // Position Values
        if(!useRandomStart){
            gameView.playerX = 0
            gameView.playerY = 0
            gameView.cpuX = 380
            gameView.cpuY = 380
        }
        else{
            generateRandomStart()
        }
        
        // Direction Values
        playerDir = 1
        cpuDir = 0
        
        numMoves = 0    // Current Moves
        startButton.isEnabled = true    // Turn on start game button
        gameOver = false                // game is no longer over
        gameView.drawBoard()            // draw the game board again
        gameView.initializeGrid()       // reset the game grid
        pause = true        // pause the timer & wait for the player
    }
    
    // Generate random starting x and y values for both the player and cpu
    func generateRandomStart(){
        let randPX = Int(arc4random_uniform(10) + 1)
        let randPY = Int(arc4random_uniform(10) + 1)
        let randCX = Int(arc4random_uniform(18) + 1)
        let randCY = Int(arc4random_uniform(18) + 1)
        gameView.playerX = randPX * 20
        gameView.playerY = randPY * 20
        gameView.cpuY = randCX * 20
        gameView.cpuX = randCY * 20
    }
    
    // Returns a randomly generated color
    func getRandomColor() -> UIColor{
        // Generate random color values
        let randR = getRandomFrom(min: 0.1, thruMax: 1.0)
        let randG = getRandomFrom(min: 0.1, thruMax: 1.0)
        let randB = getRandomFrom(min: 0.1, thruMax: 1.0)
        let alpha: CGFloat = 100.0
        
        // Create color
        let color = UIColor (red:randR, green:randG, blue:randB, alpha:alpha)
        
        return color
    }
    
    // Uses values between 0 and 1 and generate random numbers
    func getRandomFrom(min:CGFloat, thruMax max:CGFloat)->CGFloat{
        // Avoid division by zero
        guard max >= min else{
            return max
        }
        // Allow for 3 decimal places
        let accuracy: CGFloat = 1000.0
        
        // Left shift 3 digits
        let scaledMin: CGFloat = min * accuracy
        let scaledMax: CGFloat = max * accuracy
        
        // Get value within set range
        let randomNum = Int(arc4random_uniform(UInt32(scaledMax - scaledMin)))
        
        // Right shift
        let randomResult = CGFloat(randomNum) / accuracy + min
        
        return randomResult
    }
    
    override var prefersStatusBarHidden: Bool{
        get{
            return true
        }
    }
    
    // Send all relevant data to the tabbar controllers viewcontrollers
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let tabBarControllerArray = segue.destination as? UITabBarController else {
            return
        }
        guard let configDataView = tabBarControllerArray.viewControllers![0] as? ConfigViewController else{return}
        guard let infoDataView = tabBarControllerArray.viewControllers![1] as? InfoViewController else{return}
        
        //Data for ConfigViewControler
        configDataView.gameSpeed = delay
        configDataView.rStart = useRandomStart
        configDataView.rColor = useRandomBody
        
        //Data for InfoViewController
        infoDataView.playerWins = playerWins
        infoDataView.cpuWins = cpuWins
        infoDataView.movesLastGame = lastMoves
    }
}
