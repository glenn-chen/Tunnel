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
        backButton.selectedHandler = { [unowned self] in
            self.loadModeSelection()
        }
        
        levelButtons = Array(repeating: nil, count: 13)
        
        var numLevels: Int!
        if levelType == "Float" {
            numLevels = 12
        }
        else {
            numLevels = 10
        }
        
        levelButtons[1] = childNode(withName: "button1") as! MSButtonNode
        levelButtons[1]?.selectedHandler = { [unowned self] in
            self.loadGame(level: "\(levelType!)Tutorial")
        }
        for index in 2...numLevels {
            levelButtons[index] = childNode(withName: "button\(index)") as! MSButtonNode
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
