//
//  GameScene.swift
//  Tunnels
//
//  Created by Glenn Chen on 7/10/17.
//  Copyright © 2017 Glenn Chen. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    enum GameState {
        case active, dead, transition, end
    }
    var currentGameState: GameState!
    
    enum ControlScheme {
        case position, tap, float, gravity
        //trace, flight, reverse/turn/flip
    }
    var controlState: ControlScheme = .position
    var currentLevel: String = "a"
    var nextLevel: String = "a"
    
    var reversalFactor: CGFloat = 1
    
    var hero: SKReferenceNode!
    var velocityY: CGFloat = 1.3
    var velocityX: CGFloat = 2
    var accelFactor: CGFloat = 0
    var fallSpeed: CGFloat = 0.1
    
    var cloak: SKSpriteNode!
    var goal: SKSpriteNode!
    var homeButton: MSButtonNode!
    var cameraNode:SKCameraNode!
    
    class func loadGameScene(level: String) -> GameScene? {
        guard let scene = GameScene(fileNamed: level) else {
            return nil
        }
        scene.scaleMode = .aspectFit
        
        scene.currentLevel = level
        scene.setNextLevel()
        scene.setSettings()
        
        return scene
    }
    
    override func didMove(to view: SKView) {
        hero = self.childNode(withName: "//hero") as! SKReferenceNode
        hero.zPosition = 3
        
        physicsWorld.contactDelegate = self
        
        cameraNode = childNode(withName: "cameraNode") as! SKCameraNode
        self.camera = cameraNode
        
        homeButton = childNode(withName: "//homeButton") as! MSButtonNode
        homeButton.selectedHandler = {
            if let view = self.view as! SKView? {
                // Load the SKScene from 'GameScene.sks'
                if let scene = MainMenu(fileNamed: "MainMenu") {
                    // Set the scale mode to scale to fit the window
                    scene.scaleMode = .aspectFill
                    
                    // Present the scene
                    view.presentScene(scene)
                }
                
                view.ignoresSiblingOrder = true
                view.showsPhysics = false
                view.showsFPS = true
                view.showsNodeCount = true
            }
        }
        homeButton.state = .MSButtonNodeStateHidden
        homeButton.position = CGPoint(x: -236, y: 133)
        homeButton.xScale = 0.9
        homeButton.yScale = 0.9
        homeButton.zPosition = 4
        
        currentGameState = .active
        
        setSettings()
        
        print(controlState)
        print("Level at end of didmove: \(currentLevel)")

    }
    
    func didBegin(_ contact: SKPhysicsContact) {

        /* Get references to bodies involved in collision */
        let contactA = contact.bodyA
        let contactB = contact.bodyB
        
        /* Get references to the physics body parent nodes */
        let nodeA = contactA.node!
        let nodeB = contactB.node!
        
        if nodeA.name == "cloak" || nodeB.name == "cloak" {
            hero.isHidden = !hero.isHidden
        }
        else if nodeA.name == "goal" || nodeB.name == "goal" {
            currentGameState = .transition
        }
        else if nodeA.name == "finalGoal" || nodeB.name == "finalGoal" {
            //self.loadMainMenu()
            currentGameState = .end
        }
        else if nodeA.name == "hero" || nodeB.name == "hero" { // contacts with goal and cloak will have already been detected
            currentGameState = .dead
        }
        
        //hero.texture = SKTexture(imageNamed: "player1")
    }
 
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if currentGameState == .dead {
            loadLevel(currentLevel)
            return
        }
        else if currentGameState == .transition {
            loadLevel(nextLevel)
            return
        }
        else if currentGameState == .end {
            loadMainMenu()
            return
        }
        
    //    print(controlState)
        
        if controlState == .position {
            hero.position.y = touches.first!.location(in: self).y * reversalFactor
        }
        else if controlState == .float {
            let temp = velocityX
            velocityX = velocityY
            velocityY = temp
        }
        else if controlState == .tap {
            reversalFactor *= -1
        }
        else if controlState == .gravity {
            velocityY += 2.5
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if controlState != .position || currentGameState != .active  {
            return
        }
        
        if controlState == .position {
            hero.position.y = touches.first!.location(in: self).y * reversalFactor
        }
    /*    else if controlState == .accel {
            let touchLocation = touches.first!.location(in: self)
            accelFactor = touchLocation.y * 0.0005
        }*/
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if controlState == .float {
            let temp = velocityX
            velocityX = velocityY
            velocityY = temp
        }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        
        // Called before each frame is rendered
        
        if currentGameState != .active {
            homeButton.state = .MSButtonNodeStateActive
            hero.isHidden = false
            return
        }

        hero.position.x += velocityX
        hero.position.y += velocityY * reversalFactor
        
        if controlState == .gravity {
            velocityY -= fallSpeed
        }
        
        /* Change camera position */
        if controlState == .float {
            cameraNode.position = hero.position
        }
        else {
            cameraNode.position.x = hero.position.x
        }
    }
    
    func loadLevel(_ level: String) {
        
    //    print("Loading...." + level)
        
        currentGameState = .active
        
        /* Grab reference to our SpriteKit view */
        let skView = self.view as SKView!
        
        /* Load Game scene */
        let scene = GameScene(fileNamed: level) as GameScene!
        
        /* Ensure correct aspect mode */
        scene?.scaleMode = .aspectFill
        
        /* Restart game scene */
        skView?.presentScene(scene)
        
        scene?.currentLevel = level
 //       print("AOIUFPOA " + (scene?.currentLevel)!)
        scene?.setNextLevel()
        scene?.setSettings()
        currentLevel = level
    }
    
    func setNextLevel() {
        print("Setting inext level")
        if currentLevel == "PositionTutorial" {
            nextLevel = "Position_1"
        }
        else if currentLevel == "TapTutorial" {
            nextLevel = "Tap_1"
        }
        else if currentLevel == "FloatTutorial" {
            nextLevel = "Float_1"
        }
        else if currentLevel == "GravityTutorial" {
            nextLevel = "Gravity_1"
        }
        else {
            let index: Int = currentLevel.indexOf("_")
            let realIndex = currentLevel.index(currentLevel.startIndex, offsetBy: index)

            let levelNumber = Int(currentLevel.substring(from: currentLevel.index(currentLevel.startIndex, offsetBy: index + 1)))
            
            let beginning = currentLevel.substring(to: realIndex)
            
            nextLevel = beginning + "_\(levelNumber! + 1)"

        }
        
    }
    
    func setSettings() {
        
        if currentLevel.indexOf("T") == 0 {
            //tap
            switch currentLevel {
            case "Tap_Tutorial", "Tap_1", "Tap_2":
                velocityX = 1.5
                velocityY = 1.5
            case "Tap_3", "Tap_4", "Tap_5":
                velocityX = 2
                velocityY = 2
            case "Tap_6":
                velocityX = 2.5
                velocityY = 2.5
            case "Tap_7", "Tap_8":
                velocityX = 2.5
                velocityY = 2.5
            default:
                velocityX = 2
                velocityY = 2
            }
            controlState = .tap
        }
        else if currentLevel.indexOf("P") == 0 {
            //position
            switch currentLevel {
            case "Position_8", "Position_9", "Position_10":
                velocityX = 2.25
            default:
                velocityX = 2
            }
            velocityY = 0
            controlState = .position
        }
        else if currentLevel.indexOf("F") == 0 {
            //float
            switch currentLevel {
            case "Float_7", "Float_8":
                velocityX = 3.5
                velocityY = 0
            case "Float_9":
                velocityX = 0
                velocityY = 3.5
            case "Float_10":
                velocityX = 0
                velocityY = 3.75
            default:
                velocityX = 3
                velocityY = 0
            }
            controlState = .float
        }
        else if currentLevel.indexOf("G") == 0 {
            //swipe
            switch currentLevel {
            case "Gravity_6":
                velocityY = 2 // start off with bigger boost
            default:
                velocityX = 3
                velocityY = 1
                break;
            }
            controlState = .gravity
            
        }
        
    }
    
    func loadMainMenu() {
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = MainMenu(fileNamed: "MainMenu") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            view.showsPhysics = false
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
}

public extension String {
    
    public func indexOf(_ letter: Character) -> Int {
        for index in 0..<self.characters.count {
            let realIndex = self.index(self.startIndex, offsetBy: index)
            let c = self[realIndex]
            if c == letter {
                return index
            }
        }
        
        // placeholder
        return -1
    }
}
