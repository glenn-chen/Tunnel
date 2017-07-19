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
    
    override func didMove(to view: SKView) {
        /* Setup your scene here */
        
        /* Set UI connections */
        positionButton = self.childNode(withName: "positionButton") as! MSButtonNode
        positionButton.selectedHandler = {
            self.loadGame(level: "Position_7")
        }
        
        tapButton = self.childNode(withName: "tapButton") as! MSButtonNode
        tapButton.selectedHandler = {
            self.loadGame(level: "TapTutorial")
        }
        
        floatButton = self.childNode(withName: "floatButton") as! MSButtonNode
        floatButton.selectedHandler = {
            self.loadGame(level: "FloatTutorial")
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
