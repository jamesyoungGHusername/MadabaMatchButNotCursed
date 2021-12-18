//
//  GameMessage.swift
//  Madaba
//
//  Created by James Young on 12/8/21.
//

import Foundation
import SpriteKit
class GameMessage:NSObject{
    private var node:SKNode
    private var text:SKLabelNode
    private var box:SKShapeNode
    init(message:String,position:CGPoint,size:CGSize){
        let attrString = NSMutableAttributedString(string: message)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let range = NSRange(location: 0, length: message.count)
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: range)
        attrString.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.white, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20)], range: range)
        self.text=SKLabelNode(attributedText: attrString)
        self.text.verticalAlignmentMode = .center
        self.text.horizontalAlignmentMode = .center
        self.box=SKShapeNode(rectOf: size, cornerRadius: 5)
        self.box.fillColor=UIColor.black
        self.text.preferredMaxLayoutWidth=self.box.frame.size.width/1.1
        self.text.numberOfLines=3
        self.text.lineBreakMode = .byWordWrapping
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
    func setMessage(s:String){
        text.text=s
    }
}
