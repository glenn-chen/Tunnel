//
//  ModeSelection.swift
//  Tunnels
//
//  Created by Glenn Chen on 7/28/17.
//  Copyright © 2017 Glenn Chen. All rights reserved.
//

import Foundation
import SpriteKit

class ModeSelection: SKScene {
    
    /* UI Connections */
    var positionButton: MSButtonNode!
    var tapButton: MSButtonNode!
    var floatButton: MSButtonNode!
    var gravityButton: MSButtonNode!
    var backButton: MSButtonNode!
    
    var positionHero: SKReferenceNode!
    var tapHero: SKReferenceNode!
    var floatHero: SKReferenceNode!
    var gravityHero: SKReferenceNode!

    override func didMove(to view: SKView) {
        let hide = SKAction.hide()
        let unhide = SKAction.unhide()
        let moveRight = SKAction.move(by: CGVector(dx: 125, dy: 0), duration: 1.9)
        let moveLeft = SKAction.move(by: CGVector(dx: -125, dy: 0), duration: 0.05)
        let horizontalSequence = SKAction.sequence([moveRight, hide, moveLeft, unhide])
        
        /* Animate position preview */
        positionHero = childNode(withName: "positionHero") as! SKReferenceNode
        
        let posUp = SKAction.move(by: CGVector(dx: 0, dy: 29), duration: 0.4)
        let posWait = SKAction.wait(forDuration: 0.15)
        let posDown = SKAction.move(by: CGVector(dx: 0, dy: -47), duration: 0.05)
        let posWait2 = SKAction.wait(forDuration: 0.65)
        let posUp2 = SKAction.move(by: CGVector(dx: 0, dy: 50), duration: 0.05)
        let posDown2 = SKAction.move(by: CGVector(dx: 0, dy: -32), duration: 0.65)
        let posVerticalSequence = SKAction.sequence([posUp, posWait, posDown, posWait2, hide, posUp2, unhide, posDown2])
        
        positionHero.run(SKAction.repeatForever(posVerticalSequence))
        positionHero.run(SKAction.repeatForever(horizontalSequence))
        
        /* Animate tap preview */
        tapHero = childNode(withName: "tapHero") as! SKReferenceNode
        
        let tapUp = SKAction.move(by: CGVector(dx: 0, dy: 25), duration: 0.375)
        let tapDown = SKAction.move(by: CGVector(dx: 0, dy: -50), duration: 0.75)
        let tapUp2 = SKAction.move(by: CGVector(dx: 0, dy: 40), duration: 0.6)
        let tapDown2 = SKAction.move(by: CGVector(dx: 0, dy: -15), duration: 0.225)
        let tapVerticalSequence = SKAction.sequence([tapUp, tapDown, tapUp2, tapDown2])
        
        tapHero.run(SKAction.repeatForever(tapVerticalSequence))
        tapHero.run(SKAction.repeatForever(horizontalSequence))
        
        /* Animate float preview */
        floatHero = childNode(withName: "floatHero") as! SKReferenceNode
        
        let floatRight = SKAction.move(by: CGVector(dx: 40, dy: 0), duration: 0.42)
        let floatUp = SKAction.move(by: CGVector(dx: 0, dy: 28), duration: 0.29)
        let floatRight2 = SKAction.move(by: CGVector(dx: 55, dy: 0), duration: 0.58)
        let floatRight3 = SKAction.move(by: CGVector(dx: 30, dy: 0), duration: 0.31)
        let floatReset = SKAction.move(to: CGPoint(x: 58, y: -113), duration: 0.06)
        let floatSequence = SKAction.sequence([floatRight, floatUp, floatRight2, floatUp, floatRight3, hide, floatReset, unhide])
        
        floatHero.run(SKAction.repeatForever(floatSequence))
        
        /* Animate gravity preview */
        gravityHero = childNode(withName: "gravityHero") as! SKReferenceNode
        
        let gravityDown = SKAction.move(by: CGVector(dx: 0, dy: -6), duration: 0.22)
        let gravityDown2 = SKAction.move(by: CGVector(dx: 0, dy: -10), duration: 0.18)
        let gravityDown3 = SKAction.move(by: CGVector(dx: 0, dy: -16), duration: 0.2)
        let gravityDown4 = SKAction.move(by: CGVector(dx: 0, dy: -22), duration: 0.28)
        let gravityUp = SKAction.move(by: CGVector(dx: 0, dy: 4), duration: 0.255)
        let gravityDown5 = SKAction.move(by: CGVector(dx: 0, dy: -4), duration: 0.255)
        let gravityReset = SKAction.moveTo(y: -57, duration: 0.05)
        let gravityHorizontalSequence = SKAction.sequence([gravityDown, gravityDown2, gravityDown3, gravityDown4, gravityUp, gravityDown5, gravityUp, gravityDown5, gravityReset])
        
        gravityHero.run(SKAction.repeatForever(gravityHorizontalSequence))
        gravityHero.run(SKAction.repeatForever(horizontalSequence))
        
        /* Set Button Functions */
        let defaults = UserDefaults.standard
        
        positionButton = self.childNode(withName: "positionButton") as! MSButtonNode
        if defaults.string(forKey: "Position_Tutorial") == "done" {
            positionButton.selectedHandler = { [unowned self] in
                self.loadSelection(mode: "Position")
            }
        }
        else {
            positionButton.selectedHandler = { [unowned self] in
                self.loadGame(level: "Position_Tutorial")
            }
        }
        
        tapButton = self.childNode(withName: "tapButton") as! MSButtonNode
        if defaults.string(forKey: "Tap_Tutorial") == "done" {
            tapButton.selectedHandler = { [unowned self] in
                self.loadSelection(mode: "Tap")
            }
        }
        else {
            tapButton.selectedHandler = { [unowned self] in
                self.loadGame(level: "Tap_Tutorial")
            }
        }
        
        floatButton = self.childNode(withName: "floatButton") as! MSButtonNode
        if defaults.string(forKey: "Float_Tutorial") == "done" {
            floatButton.selectedHandler = { [unowned self] in
                self.loadSelection(mode: "Float")
            }
        }
        else {
            floatButton.selectedHandler = { [unowned self] in
                self.loadGame(level: "Float_Tutorial")
            }
        }
        
        gravityButton = self.childNode(withName: "gravityButton") as! MSButtonNode
        if defaults.string(forKey: "Gravity_Tutorial") == "done" {
            gravityButton.selectedHandler = { [unowned self] in
                self.loadSelection(mode: "Gravity")
            }
        }
        else {
            gravityButton.selectedHandler = { [unowned self] in
                self.loadGame(level: "Gravity_Tutorial")
            }
        }
        
        backButton = self.childNode(withName: "backButton") as! MSButtonNode
        backButton.selectedHandler = { [unowned self] in
            self.loadMainMenu()
        }
    }
    
    func loadMainMenu() {
        if let view = self.view {
            // Load the SKScene from 'GameScene.sks'
            if let scene = MainMenu(fileNamed: "MainMenu") {
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
    
    func loadSelection(mode: String) {
        if let view = self.view {
            // Load the SKScene from 'GameScene.sks'
            if let scene = LevelSelection(fileNamed: "\(mode)Selection") {
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
    
    func loadGame(level: String) {
        /* 1) Grab reference to our SpriteKit view */
        guard let skView = self.view as SKView! else {
            print("Could not get Skview")
            return
        }
        
        /* 2) Load Game scene */
        guard let scene = GameScene.loadGameScene(level: level) else {
            print("Could not load GameScene")
            return
        }
        
        /* 3) Ensure correct aspect mode */
        scene.scaleMode = .aspectFit
        
        /* Show debug */
        /* skView.showsPhysics = true
         skView.showsDrawCount = true*/
        //skView.showsFPS = true
        
        /* 4) Start game scene */
        skView.presentScene(scene)
    }
}
