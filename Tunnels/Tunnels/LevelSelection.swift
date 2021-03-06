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
        
        let defaults = UserDefaults.standard
        
        backButton = childNode(withName: "backButton") as! MSButtonNode
        backButton.selectedHandler = { [unowned self] in
            self.loadModeSelection()
        }
        
        levelButtons = Array(repeating: nil, count: 13)
        
        var numLevels: Int!
        if levelType == "Float" || levelType == "Tap" {
            numLevels = 12
        }
        else {
            numLevels = 10
        }

        for index in 1...numLevels {
            levelButtons[index] = childNode(withName: "button\(index)") as! MSButtonNode
            
            if defaults.string(forKey: "\(levelType!)_\(index)") == "done" {
                if index < 10 {
                    levelButtons[index]?.texture = SKTexture(imageNamed: "button_0\(index)b")
                }
                else {
                    levelButtons[index]?.texture = SKTexture(imageNamed: "button_\(index)b")
                }
                
                // border size is 4, need to increase button size
                levelButtons[index]?.size.height += 8
                levelButtons[index]?.size.width += 8
            }
            
            levelButtons[index]?.selectedHandler = { [unowned self] in
                self.loadGame(level: "\(levelType!)_\(index)")
            }
        }
    }
    
    func loadModeSelection() {
        if let view = self.view as! SKView? {
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
