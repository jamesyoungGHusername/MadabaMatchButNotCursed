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
    var scoreLabel:SKLabelNode?
    var comboLabel:SKLabelNode?
    override func didMove(to view: SKView) {
        
        board=Board.init(w: self.size.width/1.3, h: self.size.height/1.3,r:10,c:6,gs:self)
        // Get label node from scene and store it for use later
        board!.populate()
        
        self.addChild(board!.sn)
        for r in board!.tiles{
            for t in r{
                self.addChild(t.node)
                t.updatePosition(animated: false, 0)
            }
        }
        scoreLabel=SKLabelNode(text:"SCORE: \(board!.score)")
        scoreLabel!.fontName="AvenirNext-Bold"
        scoreLabel!.color=UIColor.link
        scoreLabel!.position=CGPoint(x: 0, y: -board!.h/1.75)
        comboLabel=SKLabelNode(text:"MAX COMBO: \(board!.maxCombo)")
        comboLabel!.fontName="AvenirNext-Bold"
        comboLabel!.color=UIColor.link
        comboLabel!.position=CGPoint(x: 0, y: board!.h/2+2)
        self.addChild(scoreLabel!)
        self.addChild(comboLabel!)
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
        scoreLabel!.text="SCORE: \(board!.score)"
        comboLabel!.text="MAX COMBO: \(board!.maxCombo)"
        if !animating{
            
            //board!.advanceTurn()
        }
    }
    func spawnComboLabel(at:CGPoint,type:ComboID){
        let label=SKLabelNode()
        let labelShadow=SKLabelNode()
        label.fontName="AvenirNext-Bold"
        labelShadow.fontName="AvenirNext-Bold"
        label.fontSize=40
        labelShadow.fontSize=40
        //let grow=SKAction.scale(by: 2, duration: 0.2)
        //let shrink=SKAction.scale(by: 0.1, duration: 0.2)
        let fadeIn=SKAction.fadeIn(withDuration: 0.5)
        let fadeOut=SKAction.fadeOut(withDuration: 2)
        let sequence=SKAction.sequence([fadeIn,fadeOut])
        let node=SKNode()
        node.addChild(labelShadow)
        node.addChild(label)
        switch type{
            case .single:
                label.text=""
            case .duo:
                label.text="DOUBLE! 2X"
                labelShadow.text="DOUBLE! 2X"
                label.fontColor=UIColor.white
                labelShadow.fontColor=UIColor.black
                label.position=at
                labelShadow.position.x=at.x-2
                labelShadow.position.y=at.y-2
                self.addChild(node)
                node.run(sequence,completion: {node.removeFromParent()})
            case .tri:
            label.text="TRIPLE! 3X"
            labelShadow.text="TRIPLE! 3X"
            label.fontColor=UIColor.white
            labelShadow.fontColor=UIColor.black
            label.position=at
            labelShadow.position.x=at.x-2
            labelShadow.position.y=at.y-2
            self.addChild(node)
            node.run(sequence,completion: {node.removeFromParent()})
            case .quad:
            label.text="QUADRA! 4X"
            labelShadow.text="QUADRA! 4X"
            label.fontColor=UIColor.white
            labelShadow.fontColor=UIColor.black
            label.position=at
            labelShadow.position.x=at.x-2
            labelShadow.position.y=at.y-2
            self.addChild(node)
            node.run(sequence,completion: {node.removeFromParent()})
            case .penta:
            label.text="PENTA! 5X"
            labelShadow.text="PENTA! 5X"
            label.fontColor=UIColor.white
            labelShadow.fontColor=UIColor.black
            label.position=at
            labelShadow.position.x=at.x-2
            labelShadow.position.y=at.y-2
            self.addChild(node)
            node.run(sequence,completion: {node.removeFromParent()})
            case .sexta:
            label.text="SEXTA! 6X"
            labelShadow.text="SEXTA! 6X"
            label.fontColor=UIColor.white
            labelShadow.fontColor=UIColor.black
            label.position=at
            labelShadow.position.x=at.x-2
            labelShadow.position.y=at.y-2
            self.addChild(node)
            node.run(sequence,completion: {node.removeFromParent()})
            case .sept:
            label.text="FANTASTC!"
            labelShadow.text="FANTASTIC!"
            label.fontColor=UIColor.white
            labelShadow.fontColor=UIColor.black
            label.position=at
            labelShadow.position.x=at.x-2
            labelShadow.position.y=at.y-2
            self.addChild(node)
            node.run(sequence,completion: {node.removeFromParent()})
            case .octo:
            label.text="GODLIKE"
            labelShadow.text="GODLIKE"
            label.fontColor=UIColor.white
            labelShadow.fontColor=UIColor.black
            label.position=at
            labelShadow.position.x=at.x-2
            labelShadow.position.y=at.y-2
            self.addChild(node)
            node.run(sequence,completion: {node.removeFromParent()})
        }
    }
    
    
}
enum ComboID:CaseIterable{
    case single
    case duo
    case tri
    case quad
    case penta
    case sexta
    case sept
    case octo
}
