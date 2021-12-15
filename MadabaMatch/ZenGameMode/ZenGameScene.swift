//
//  ZenGameScene.swift
//  Madaba
//
//  Created by James Young on 12/14/21.
//

import Foundation
import SpriteKit
class ZenGameScene:SKScene{
    var board:ZenBoard!
    var startMessage:String!
    var boardRows:Int!
    var boardCols:Int!
    var backButton:SKNode!
    var restartButton:SKNode!
    var openingMsg:GameMessage!
    var started:Bool!

    override func didMove(to view: SKView) {
        started=false
        self.backgroundColor=UIColor.black
        backButton=prepBackButton()
        self.addChild(backButton)
        restartButton=prepRestartButton()
        self.addChild(restartButton)
        openingMsg=GameMessage.init(message: "Drag tiles to move them.\nGroups of 3 or more tiles lock together.\nFill the whole board with grouped tiles.",position: CGPoint(x:0,y:0), size: CGSize(width: self.size.width/1.1, height: self.size.height/3))
        self.addChild(openingMsg!.getNode())
        openingMsg.getNode().zPosition=10
        board=ZenBoard.init(w: self.size.width/1.3, h: self.size.height/1.3, r: 10, c: 6, gs: self)
        self.addChild(board!.sn)
        board!.populate()
        for r in board!.tiles{
            for t in r{
                self.addChild(t.node)
                t.updatePosition(animated: false, 0)
            }
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch=touches.first
        if(started){
            if(backButton.contains(touch!.location(in: self))){
                let transition=SKTransition.moveIn(with: .left, duration: 0.2)
                let scene = SKScene(fileNamed: "ZenReadyScene")!
                self.view?.presentScene(scene,transition: transition)
            }else if(restartButton.contains(touch!.location(in: self))){
                let transition=SKTransition.crossFade(withDuration: 0.5)
                let scene = SKScene(fileNamed: "ZenGameScene") as! ZenGameScene
                self.view?.presentScene(scene,transition: transition)
            }else if(!board!.gameOver){
                board!.touchDown(touch: touch!)
            }
        }else{
            started=true
            openingMsg.getNode().removeFromParent()
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    override func update(_ currentTime: TimeInterval) {
        
    }
    func prepBackButton()->SKNode{
        var node=SKNode()
        var bBox:SKShapeNode
        var bText:SKLabelNode
        bBox=SKShapeNode(rectOf: CGSize(width: 120, height: 30),cornerRadius: 10)
        bBox.fillColor=UIColor.systemGray2
        bText=SKLabelNode(text: "Back")
        bText.fontName="AvenirNext-Bold"
        bText.fontSize=30
        bText.fontColor=UIColor.white
        bText.zPosition=1
        bText.verticalAlignmentMode = .center
        node.addChild(bBox)
        node.addChild(bText)
        node.position=CGPoint(x: -self.size.width/2+61, y: self.size.height/2-16)
        return node
    }
    func prepRestartButton()->SKNode{
        var node=SKNode()
        var rText:SKLabelNode
        var rBox:SKShapeNode
        rBox=SKShapeNode(rectOf: CGSize(width: 120, height: 30),cornerRadius: 10)
        rBox.fillColor=UIColor.systemGray2
        rText=SKLabelNode(text: "Restart")
        rText.fontName="AvenirNext-Bold"
        rText.fontSize=30
        rText.fontColor=UIColor.white
        rText.zPosition=1
        rText.verticalAlignmentMode = .center
        node.addChild(rBox)
        node.addChild(rText)
        node.position=CGPoint(x: self.size.width/2-61, y: self.size.height/2-16)
        return node
    }
}
