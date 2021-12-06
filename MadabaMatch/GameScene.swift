//
//  GameScene.swift
//  MadabaMatch
//
//  Created by James Young on 12/5/21.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var board:Board?
    
    override func didMove(to view: SKView) {
        
        board=Board.init(w: self.size.width/1.3, h: self.size.width/1.3,r:5,c:5,gs:self)
        // Get label node from scene and store it for use later
        board!.populate()
        self.addChild(board!.sn)
        for r in board!.tiles{
            for t in r{
                self.addChild(t.node)
                t.updatePosition(animated: false, 0)
            }
        }
        // Create shape node to use during mouse interaction

        
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
 
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch=touches.first
        board!.touchDown(touch: touch!)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch=touches.first
        board!.touchMoved(touch: touch!)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch=touches.first
        board!.touchUp(touch: touch!)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        var animating=false
        for c in self.children{
            if c.hasActions(){
                animating=true
            }
        }
        if !animating{
            //board!.advanceTurn()
        }
    }
}
