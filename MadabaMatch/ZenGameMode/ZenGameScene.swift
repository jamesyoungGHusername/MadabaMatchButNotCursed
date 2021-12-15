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
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
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
        rBox?.fillColor=UIColor.systemGray2
        rText=SKLabelNode(text: "Restart")
        rText!.fontName="AvenirNext-Bold"
        rText!.fontSize=30
        rText!.fontColor=UIColor.white
        rText!.zPosition=1
        rText!.verticalAlignmentMode = .center
        node.addChild(rBox)
        node.addChild(rText)
        return node
    }
}
