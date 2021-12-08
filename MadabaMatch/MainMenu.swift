//
//  MainMenu.swift
//  Madaba
//
//  Created by James Young on 12/7/21.
//

import Foundation
import SpriteKit
class MainMenu:SKScene{
    var titleLabel:SKLabelNode!
    var titleShadow:SKLabelNode!
    var titleNode:SKNode!
    var buttonBackground:SKShapeNode!
    var buttonText:SKLabelNode!
    var button:SKNode!
    var gm:SKLabelNode!
    var scene1:GameScene!
    override func didMove(to view: SKView) {
        titleLabel=SKLabelNode(text: "Madaba Match")
        titleLabel!.fontName="AvenirNext-Bold"
        titleLabel!.fontSize=40
        titleShadow=SKLabelNode(text: "Madaba Match")
        titleShadow!.fontName="AvenirNext-Bold"
        titleShadow!.fontSize=40
        titleShadow!.fontColor=UIColor.systemGray2
        titleLabel!.position=CGPoint(x: 0, y:self.size.height/3 )
        titleShadow!.position=CGPoint(x: 2, y:self.size.height/3-2)
        let step=self.size.height/3-self.size.height/4
        titleShadow!.zPosition = -1
        titleNode=SKNode()
        titleNode!.addChild(titleShadow!)
        titleNode!.addChild(titleLabel!)
        self.addChild(titleNode!)
        buttonBackground=SKShapeNode(rectOf: CGSize(width: 150, height: 50),cornerRadius: 10)
        buttonBackground?.fillColor=UIColor.systemGray4
        buttonText=SKLabelNode(text: "SURVIVE")
        buttonText!.fontName="AvenirNext-Bold"
        buttonText!.fontSize=15
        buttonText!.zPosition=1
        buttonText!.verticalAlignmentMode = .center
        button=SKNode()
        button!.addChild(buttonBackground!)
        button!.addChild(buttonText!)
        button.position=CGPoint(x: 0, y:self.size.height/4-step )
        self.addChild(button!)
        self.backgroundColor=UIColor.black
        gm=SKLabelNode(text: "Game Mode:")
        gm.fontSize=30
        gm.fontColor=UIColor.white
        gm.position=CGPoint(x: 0, y:self.size.height/4 )
        self.addChild(gm)
       
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch=touches.first
        if button!.contains(touch!.location(in: self)){
            print("Start tapped")
            let transition=SKTransition.moveIn(with: .right, duration: 0.2)
            scene1 = SKScene(fileNamed: "GameScene") as? GameScene
            scene1.setup(level: 1, message: "Level 1: Survive 6 turns", bR: 10, bC: 6, turnGoal: 6,colorsPresent:4)
            self.view?.presentScene(scene1,transition: transition)
               
        }
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
