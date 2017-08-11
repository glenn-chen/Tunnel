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
    var leftPosButton: MSButtonNode!
    var rightPosButton: MSButtonNode!
    var leftSoundButton: MSButtonNode!
    var rightSoundButton: MSButtonNode!
    var locationLabel: SKLabelNode!
    var soundLabel: SKLabelNode!
    
    let posArr = ["Lower Left", "Upper Left", "Upper Right", "Lower Right"]
    var posIndex = 0 {
        didSet {
            locationLabel.text = posArr[posIndex]
        }
    }
    
    let soundArr = ["On", "Off"]
    var soundIndex = 0 {
        didSet {
            soundLabel.text = soundArr[soundIndex]
        }
    }
    
    override func didMove(to view: SKView) {
        /* Setup your scene here */

        locationLabel = childNode(withName: "locationLabel") as! SKLabelNode
        soundLabel = childNode(withName: "soundLabel") as! SKLabelNode
        let defaults = UserDefaults.standard
        posIndex = defaults.integer(forKey: defaultsKeys.buttonLocationIndex)
        soundIndex = defaults.integer(forKey: defaultsKeys.soundSettingsIndex)
        
        
        leftPosButton = childNode(withName: "leftPosButton") as! MSButtonNode
        leftPosButton.selectedHandler = { [unowned self] in
            if self.posIndex > 0 {
                self.posIndex -= 1
            }
            else {
                self.posIndex = self.posArr.count - 1
            }
        }
        
        rightPosButton = childNode(withName: "rightPosButton") as! MSButtonNode
        rightPosButton.selectedHandler = { [unowned self] in
            if self.posIndex < self.posArr.count - 1 {
                self.posIndex += 1
            }
            else {
                self.posIndex = 0
            }
        }
        
        leftSoundButton = childNode(withName: "leftSoundButton") as! MSButtonNode
        leftSoundButton.selectedHandler = { [unowned self] in
            if self.soundIndex == 0 {
                self.soundIndex = 1
            }
            else {
                self.soundIndex = 0
            }
        }
        
        rightSoundButton = childNode(withName: "rightSoundButton") as! MSButtonNode
        rightSoundButton.selectedHandler = leftSoundButton.selectedHandler
        
        backButton = self.childNode(withName: "backButton") as! MSButtonNode
        backButton.selectedHandler = { [unowned self] in
            // Setting
            let defaults = UserDefaults.standard
            defaults.set(String(self.posIndex), forKey: defaultsKeys.buttonLocationIndex)
            defaults.set(String(self.soundIndex), forKey: defaultsKeys.soundSettingsIndex)
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
}
