//
//  MainMenu.swift
//  Tunnels
//
//  Created by Glenn Chen on 7/14/17.
//  Copyright © 2017 Glenn Chen. All rights reserved.
//

import Foundation
import SpriteKit

class MainMenu: SKScene {
    
    /* UI Connections */
    var positionButton: MSButtonNode!
    var tapButton: MSButtonNode!
    var floatButton: MSButtonNode!
    var gravityButton: MSButtonNode!
    
    override func didMove(to view: SKView) {
        /* Setup your scene here */
        
        /* Set UI connections */
        positionButton = self.childNode(withName: "positionButton") as! MSButtonNode
        positionButton.selectedHandler = {
            self.loadSelection(mode: "Position")
        }
        
        tapButton = self.childNode(withName: "tapButton") as! MSButtonNode
        tapButton.selectedHandler = {
            self.loadSelection(mode: "Tap")
        }
        
        floatButton = self.childNode(withName: "floatButton") as! MSButtonNode
        floatButton.selectedHandler = {
            self.loadSelection(mode: "Float")
        }
        
        gravityButton = self.childNode(withName: "gravityButton") as! MSButtonNode
        gravityButton.selectedHandler = {
            self.loadSelection(mode: "Gravity")
        }
        
    }
    
    func loadSelection(mode: String) {
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = LevelSelection(fileNamed: "\(mode)Selection") {
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
