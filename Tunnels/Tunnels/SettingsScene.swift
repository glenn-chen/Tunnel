//
//  Settings.swift
//  Tunnels
//
//  Created by Glenn Chen on 7/31/17.
//  Copyright © 2017 Glenn Chen. All rights reserved.
//

import Foundation
import SpriteKit

class SettingsScene: SKScene {
    
    /* UI Connections */
    var backButton: MSButtonNode!
    var leftButton: MSButtonNode!
    var rightButton: MSButtonNode!
    var locationLabel: SKLabelNode!
    
    let arr = ["Lower Left", "Upper Left", "Upper Right", "Lower Right"]
    var index = 0 {
        didSet {
            locationLabel.text = arr[index]
        }
    }
    
    override func didMove(to view: SKView) {
        /* Setup your scene here */

        locationLabel = childNode(withName: "locationLabel") as! SKLabelNode
        let defaults = UserDefaults.standard
        index = defaults.integer(forKey: defaultsKeys.buttonLocationIndex)
        
        leftButton = childNode(withName: "leftButton") as! MSButtonNode
        leftButton.selectedHandler = { [unowned self] in
            if self.index > 0 {
                self.index -= 1
            }
            else {
                self.index = self.arr.count - 1
            }
        }
        
        rightButton = childNode(withName: "rightButton") as! MSButtonNode
        rightButton.selectedHandler = { [unowned self] in
            if self.index < self.arr.count - 1 {
                self.index += 1
            }
            else {
                self.index = 0
            }
        }
        
        backButton = self.childNode(withName: "backButton") as! MSButtonNode
        backButton.selectedHandler = { [unowned self] in
            // Setting
            let defaults = UserDefaults.standard
            defaults.set(String(self.index), forKey: defaultsKeys.buttonLocationIndex)
            
            self.loadMainMenu()
        }
    }
    
    func loadMainMenu() {
        if let view = self.view {
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
