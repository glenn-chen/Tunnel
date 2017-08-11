//
//  GameScene.swift
//  Tunnels
//
//  Created by Glenn Chen on 7/10/17.
//  Copyright © 2017 Glenn Chen. All rights reserved.
//

import SpriteKit
import GameplayKit
import Foundation
import AVFoundation

struct defaultsKeys {
    static let buttonLocationIndex: String = "backLocation"
    static let soundSettingsIndex: String = "soundSettings"
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    enum GameState {
        case active, dead, justDied, transition, end
    }
    var currentGameState: GameState!
    
    enum ControlScheme {
        case position, tap, float, gravity
        //trace, flight, reverse/turn/flip
    }
    var controlState: ControlScheme = .position
    var currentLevel: String = "Position_Tutorial"
    var nextLevel: String = "Position_1"
    
    var hero: SKReferenceNode!
    var velocityY: CGFloat = 2
    var velocityX: CGFloat = 2
    var fallSpeed: CGFloat = 0.1
    var reversalFactor: CGFloat = 1
    
    var homeButton: MSButtonNode!
    var cameraNode: SKCameraNode!
    
    var deathTimer: CGFloat = 0
    
    let defaults = UserDefaults.standard
    
    var deathSound = URL(fileURLWithPath: Bundle.main.path(forResource: "pop1", ofType: "caf")!)
    var audioPlayer = AVAudioPlayer()
    
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
        hero = self.childNode(withName: "hero") as! SKReferenceNode
        hero.zPosition = 4
        
        physicsWorld.contactDelegate = self
        
        cameraNode = childNode(withName: "cameraNode") as! SKCameraNode
        self.camera = cameraNode
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: deathSound)
            audioPlayer.prepareToPlay()
        }
        catch {
            // handle error
        }
        
        currentGameState = .active
        
        setSettings()
        
        // Setting
        
        /*        defaults.set("Some String Value", forKey: defaultsKeys.keyOne)
         defaults.set("Another String Value", forKey: defaultsKeys.keyTwo) */
        
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
        else if nodeA.name == "switcher" || nodeB.name == "switcher" {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15, execute: { [unowned self] in
                self.reverseVelocities()
            })
        }
        else if nodeA.name == "goal" || nodeB.name == "goal" {
            saveLevelComplete(currentLevel)
            
            currentGameState = .transition
        }
        else if nodeA.name == "finalGoal" || nodeB.name == "finalGoal" {
            saveLevelComplete(currentLevel)
            
            currentGameState = .end
        }
        else if nodeA.name == "hero" || nodeB.name == "hero" {
            if defaults.integer(forKey: defaultsKeys.soundSettingsIndex) == 0 {
                DispatchQueue.global(qos: .background).async {
                    self.audioPlayer.play()
                    /* DispatchQueue.main.async { [unowned self] in
                     self.audioPlayer.play()
                     }*/
                }
            }
            self.currentGameState = .justDied
        }
    }
    
    func reverseVelocities() {
        let temp = velocityX
        velocityX = velocityY
        velocityY = temp
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if currentGameState == .justDied {
            return
        }
        
        if currentGameState == .dead {
            self.loadLevel(self.currentLevel)
            return
        }
        else if currentGameState == .transition {
            loadLevel(nextLevel)
            return
        }
        else if currentGameState == .end {
            loadLevelSelection()
            return
        }
        
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
            if currentGameState == .justDied {
                deathTimer += 1.0 / 60.0 // 60 fps
            }
            if deathTimer > 0.35 {
                deathTimer = 0
                currentGameState = .dead
            }
            
            
            if currentLevel.index(of: "Tutorial") == nil {
                homeButton.state = .MSButtonNodeStateActive
            }
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
    
    func saveLevelComplete(_ level: String) {
        defaults.set("done", forKey: currentLevel)
    }
    
    func loadLevel(_ level: String) {
        
        currentGameState = .active
        
        /* Grab reference to our SpriteKit view */
        let skView = self.view as SKView!
        
        /* Load Game scene */
        let scene = GameScene(fileNamed: level) as GameScene!
        
        /* Ensure correct aspect mode */
        scene?.scaleMode = .aspectFit
        
        /* Restart game scene */
        skView?.presentScene(scene)
        
        scene?.currentLevel = level
        scene?.setNextLevel()
        scene?.setSettings()
        currentLevel = level
    }
    
    func setNextLevel() {
        
        // no next level after tutorial
        if currentLevel.index(of: "Tutorial") != nil {
            return
        }
        
        let index: Int = currentLevel.indexOf("_")
        let realIndex = currentLevel.index(currentLevel.startIndex, offsetBy: index)
        
        
        let levelNumber = Int(currentLevel.substring(from: currentLevel.index(currentLevel.startIndex, offsetBy: index + 1)))
        
        let beginning = currentLevel.substring(to: realIndex)
        
        nextLevel = beginning + "_\(levelNumber! + 1)"
        
        
    }
    
    func setSettings() {
        if currentLevel.indexOf("T") == 0 {
            //tap
            switch currentLevel {
            case "Tap_Tutorial", "Tap_1", "Tap_2":
                velocityX = 1.75
                velocityY = 1.75
            case "Tap_3", "Tap_4", "Tap_5":
                velocityX = 2
                velocityY = 2
            case "Tap_6":
                velocityX = 2.25
                velocityY = 2.25
            case "Tap_7", "Tap_8", "Tap_9":
                velocityX = 2.5
                velocityY = 2.5
            case "Tap_10", "Tap_11", "Tap_12":
                velocityX = 2.75
                velocityY = 2.75
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
                velocityX = 3.25
                velocityY = 0
            case "Float_9":
                velocityX = 0
                velocityY = 3.25
            case "Float_10", "Float_11":
                velocityX = 0
                velocityY = 3.5
            case "Float_12":
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
            default:
                velocityX = 3
                velocityY = 1
                break;
            }
            controlState = .gravity
        }
        
      /*  let index: Int = currentLevel.indexOf("_")
        let realIndex = currentLevel.index(currentLevel.startIndex, offsetBy: index)
        let levelType = currentLevel.substring(to: realIndex)*/
        let realIndex = currentLevel.index(of: "_")
        let levelType = currentLevel.substring(to: realIndex!)
        
        homeButton = childNode(withName: "//homeButton") as! MSButtonNode
        homeButton.texture = SKTexture(imageNamed: "button_back")
        homeButton.state = .MSButtonNodeStateHidden
        homeButton.size = CGSize(width: 70.4, height: 32)
        homeButton.zPosition = 5
        
        // set home button location
        let positionIndex = defaults.integer(forKey: defaultsKeys.buttonLocationIndex)
        switch positionIndex {
        case 0: // Lower Left
            homeButton.position = CGPoint(x: -230, y: -130)
        case 1: // Upper Left
            homeButton.position = CGPoint(x: -230, y: 130)
        case 2: // Upper Right
            homeButton.position = CGPoint(x: 230, y: 130)
        case 3: // Lower Right
            homeButton.position = CGPoint(x: 230, y: -130)
        default: // Default Lower Left
            break;
        }
        
        homeButton.selectedHandler = { [unowned self] in
            if let view = self.view {
                // Load the SKScene from 'GameScene.sks'
                if let scene = LevelSelection(fileNamed: "\(levelType)Selection") {
                    // Set the scale mode to scale to fit the window
                    scene.scaleMode = .aspectFit
                    
                    // Present the scene
                    view.presentScene(scene)
                }
                
                view.ignoresSiblingOrder = true
                view.showsPhysics = false
                view.showsFPS = false
                view.showsNodeCount = false
            }
        }
    }
    
    func loadLevelSelection() {
     //   let index: Int = currentLevel.indexOf("_")
      //  let realIndex = currentLevel.index(currentLevel.startIndex, offsetBy: index)
        
        let realIndex = currentLevel.index(of: "_")
        let levelType = currentLevel.substring(to: realIndex!)
        
        if let view = self.view {
            // Load the SKScene from 'GameScene.sks'
            if let scene = LevelSelection(fileNamed: "\(levelType)Selection") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFit
                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            view.showsPhysics = false
            view.showsFPS = false
            view.showsNodeCount = false
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
    
    func index(of string: String, options: CompareOptions = .literal) -> Index? {
        return range(of: string, options: options)?.lowerBound
    }
}
