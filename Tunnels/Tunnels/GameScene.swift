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
        case active, dead, transition
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
    
    var goal: SKSpriteNode!
    var restartButton: MSButtonNode!
    var cameraNode:SKCameraNode!
    
    class func loadGameScene(level: String) -> GameScene? {
        guard let scene = GameScene(fileNamed: level) else {
            return nil
        }
        scene.scaleMode = .aspectFit
        
        scene.currentLevel = level
        scene.setNextLevel()
        
      /* if level == "PositionTutorial" {
            scene.controlState = .position
            scene.velocityX = 2
            scene.velocityY = 0
        }
        else if level == "TapTutorial" {
            scene.controlState = .tap
            scene.velocityX = 2
            scene.velocityY = 1.3
        }
        else {
            scene.controlState = .float
            scene.velocityY = 0
            scene.velocityX = 3
        }*/
        
        scene.setSettings()
        
        return scene
    }
    
    override func didMove(to view: SKView) {
        print("beginning " + currentLevel)
        
        hero = self.childNode(withName: "//hero") as! SKReferenceNode
        
        physicsWorld.contactDelegate = self
        
        cameraNode = childNode(withName: "cameraNode") as! SKCameraNode
        self.camera = cameraNode
        
    /*    if controlState == .position {
            velocityY = 0
        }*/
        
        currentGameState = .active
        
        goal = childNode(withName: "goal") as! SKSpriteNode
        
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
        
        if nodeA.name == "goal" || nodeB.name == "goal" {
            currentGameState = .transition
            return
        }
        
        if nodeA.name == "hero" || nodeB.name == "hero" {
            currentGameState = .dead
        }
        
        //hero.texture = SKTexture(imageNamed: "player1")
    }
 
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if currentGameState == .dead {
            print("I'm dead in \(currentLevel)")
            loadLevel(currentLevel)
            return
        }
        else if currentGameState == .transition {
            loadLevel(nextLevel)
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
        if currentGameState == .dead || controlState != .position {
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
        
        if currentGameState == .dead || currentGameState == .transition {
            return
        }

        hero.position.x += velocityX
        hero.position.y += velocityY * reversalFactor
        
        if controlState == .gravity {
            velocityY -= fallSpeed
        }
        
    /*    if controlState == .tap {
            hero.position.y += velocityY * reversalFactor
        }*/
   /*     else {
            velocityY += accelFactor
            hero.position.y += velocityY * reversalFactor
        } */
        
        /* Change camera position */
        if controlState == .float {
            cameraNode.position = hero.position
        }
        else {
            cameraNode.position.x = hero.position.x
        }
    }
    
    func loadLevel(_ level: String) {
        
        print("Loading...." + level)
        
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
        print("AOIUFPOA " + (scene?.currentLevel)!)
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
            case "TapTutorial", "Tap_1", "Tap_2", "Tap_3":
                velocityX = 2
                velocityY = 1.3
            case "Tap_4", "Tap_5":
                velocityX = 2
                velocityY = 2
            case "Tap_6":
                velocityX = 2.5
                velocityY = 2.5
            default:
                velocityX = 2
                velocityY = 1.3
            }
            controlState = .tap
            self.physicsWorld.gravity.dy = 0
        }
        else if currentLevel.indexOf("P") == 0 {
            //position
            switch currentLevel {
            case "Position_8":
                velocityX = 2.5
            default:
                velocityX = 2
            }
            velocityY = 0
            controlState = .position
            self.physicsWorld.gravity.dy = 0
        }
        else if currentLevel.indexOf("F") == 0 {
            //float
            switch currentLevel {
            case "Float_6":
                velocityX = 3.5
                velocityY = 0
            case "Float_7":
                velocityX = 4
                velocityY = 0
            case "Float_8":
                velocityX = 0
                velocityY = 4
            default:
                velocityX = 3
                velocityY = 0
            }
            controlState = .float
            self.physicsWorld.gravity.dy = 0
        }
        else if currentLevel.indexOf("G") == 0 {
            //swipe
            switch currentLevel {
            default:
                velocityX = 3
                velocityY = 1
                break;
            }
            controlState = .gravity
            self.physicsWorld.gravity.dy = 0
            
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
