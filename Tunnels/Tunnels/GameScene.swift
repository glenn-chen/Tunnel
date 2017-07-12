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
        case position, accel, tap
    }
    var controlState: ControlScheme = .position
    var currentLevel: String = "PositionTutorial"
    var nextLevel: String = "Level_1"
    
    var reversalFactor: CGFloat = 1
    
    var hero: SKReferenceNode!
    var velocityY: CGFloat = 1.3
    var accelFactor: CGFloat = 0
    
    var goal: SKSpriteNode!
    var restartButton: MSButtonNode!
    var cameraNode:SKCameraNode!
    
    override func didMove(to view: SKView) {
        hero = childNode(withName: "//hero") as! SKReferenceNode
        
        physicsWorld.contactDelegate = self
        
        cameraNode = childNode(withName: "cameraNode") as! SKCameraNode
        self.camera = cameraNode
        
        if controlState == .accel || controlState == .position {
            velocityY = 0
        }
        
        currentGameState = .active
        
        goal = childNode(withName: "goal") as! SKSpriteNode
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
    }

 
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if currentGameState == .dead {
            loadLevel(currentLevel)
        }
        
        if controlState == .position {
            hero.position.y = touches.first!.location(in: self).y * reversalFactor
        }
        else if controlState == .accel {
            let touchLocation = touches.first!.location(in: self)
            accelFactor = touchLocation.y * 0.0005
            
        }
        else if controlState == .tap {
            reversalFactor *= -1
            print(hero.position.y)
        }
        
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if currentGameState == .dead || controlState == .tap {
            return
        }
        
        if controlState == .position {
            hero.position.y = touches.first!.location(in: self).y * reversalFactor
        }
        else if controlState == .accel {
            let touchLocation = touches.first!.location(in: self)
            accelFactor = touchLocation.y * 0.0005
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
    
    
    override func update(_ currentTime: TimeInterval) {
        
        // Called before each frame is rendered
        
        if currentGameState == .dead {
            return
        }
        else if currentGameState == .transition {
            loadLevel(nextLevel)
        }

        hero.position.x += 2
        
        if controlState == .tap {
            hero.position.y += velocityY * reversalFactor
        }
        else {
            velocityY += accelFactor
            hero.position.y += velocityY * reversalFactor
        }
        
        cameraNode.position.x = hero.position.x
    }
    
    func loadLevel(_ level: String) {
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
        
        scene?.setNextLevel()
    }
    
    func setNextLevel() {
        if currentLevel == "PositionTutorial" {
            nextLevel = "Level_1"
        }
        else {
            //6 is the length of "Level_"
            let index = currentLevel.index(currentLevel.startIndex, offsetBy: 6)
            let levelNumber = Int(currentLevel.substring(from: index))
            nextLevel = "Level_\(levelNumber! + 1)"
        }
        
    }
}
