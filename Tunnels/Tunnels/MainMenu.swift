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
    var playButton: MSButtonNode!
    var settingsButton: MSButtonNode!
    
    override func didMove(to view: SKView) {
        /* Setup your scene here */
        
        /* Set UI connections */
        playButton = self.childNode(withName: "playButton") as! MSButtonNode
        playButton.selectedHandler = { [unowned self] in
            self.loadModeSelection()
        }
        
        settingsButton = self.childNode(withName: "settingsButton") as! MSButtonNode
        settingsButton.selectedHandler = { [unowned self] in
            self.loadSettingsScene()
        }
        
    }
    
    func loadSettingsScene() {
        if let view = self.view {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SettingsScene(fileNamed: "SettingsScene") {
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
    
    func loadModeSelection() {
        if let view = self.view {
            // Load the SKScene from 'GameScene.sks'
            if let scene = ModeSelection(fileNamed: "ModeSelection") {
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
    
 /*   func loadGame(level: String) {
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
    }*/
}
