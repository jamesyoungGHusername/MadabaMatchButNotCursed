//
//  LoadingScene.swift
//  Madaba
//
//  Created by James Young on 12/7/21.
//

import Foundation
import SpriteKit
class LoadingScene:SKScene{
    override func didMove(to view: SKView) {
        let scene = SKScene(fileNamed: "MainMenu")!
        self.view?.presentScene(scene)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch=touches.first
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch=touches.first
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch=touches.first
       
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
       
    }
    
    
    override func update(_ currentTime: TimeInterval) {
       
    }
}
