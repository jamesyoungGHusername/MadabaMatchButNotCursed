//
//  GameMessage.swift
//  Madaba
//
//  Created by James Young on 12/8/21.
//

import Foundation
import SpriteKit
class GameMessage{
    private var node:SKNode
    private var text:SKLabelNode
    private var box:SKShapeNode
    init(message:String,position:CGPoint,size:CGSize){
        self.text=SKLabelNode(text: message)
        self.text.fontColor=UIColor.white
        self.text.fontName="AvenirNext-Bold"
        self.text.fontSize=20
        self.text.verticalAlignmentMode = .center
        self.box=SKShapeNode(rectOf: size, cornerRadius: 5)
        self.box.fillColor=UIColor.black
        self.box.strokeColor=UIColor.white
        self.box.lineWidth=5
        self.node=SKNode()
        self.node.addChild(text)
        self.node.addChild(box)
        self.box.zPosition=0
        self.text.zPosition=1
    }
    
    func getNode()->SKNode{
        return node
    }
}
