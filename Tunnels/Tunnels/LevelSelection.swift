//
//  LevelSelection.swift
//  Tunnels
//
//  Created by Glenn Chen on 7/24/17.
//  Copyright © 2017 Glenn Chen. All rights reserved.
//

import Foundation

import SpriteKit

class LevelSelection: SKScene {
    
    var levelButtons: [MSButtonNode?]! // index 0 will be empty
    var backButton: MSButtonNode!
    
    override func didMove(to view: SKView) {
        let levelLabel = childNode(withName: "levelLabel") as! SKLabelNode
        let levelType = levelLabel.text
        
        backButton = childNode(withName: "backButton") as! MSButtonNode
        backButton.selectedHandler = {
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
        
        levelButtons = Array(repeating: nil, count: 11)
        for index in 1...10 {
            levelButtons[index] = childNode(withName: "button\(index)") as! MSButtonNode
            levelButtons[index]?.selectedHandler = {
                self.loadGame(level: "\(levelType!)_\(index)")
            }
        }
    }
    
    func loadGame(level: String) {
        print(level)
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
