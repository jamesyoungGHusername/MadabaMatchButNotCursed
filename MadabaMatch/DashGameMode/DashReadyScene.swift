//
//  DashReadyScene.swift
//  Madaba
//
//  Created by James Young on 12/14/21.
//

import Foundation
import SpriteKit
class DashReadyScene:SKScene{
    var displayHTP:Bool!
    var htpMessage:SKNode!
    var htpButton:SKNode!
    var startButton:SKNode!
    var backButton:SKNode!
    var titleNode:SKNode!
    var scoreNode:SKNode!
    var step:Double!
    override func didMove(to view: SKView) {
        self.backgroundColor=UIColor.black
        step=self.size.height/3-self.size.height/4
        displayHTP=false
        titleNode=prepTitleNode()
        self.addChild(titleNode)
        htpMessage=prepHowToPlayMessage()
        htpButton=prepHTPButton()
        self.addChild(htpButton)
        startButton=prepStartButton()
        backButton=prepBackButton()
        self.addChild(startButton)
        self.addChild(backButton)
        scoreNode=prepScoreNode()
        self.addChild(scoreNode)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch=touches.first
        if displayHTP{
            let fadeOut=SKAction.fadeOut(withDuration: 0.5)
            htpMessage.run(fadeOut, completion:{self.htpMessage.removeFromParent();self.displayHTP=false;})
        }else{
            if htpButton.contains(touch!.location(in: self)){
                displayHTP=true
                let fadeIn=SKAction.fadeIn(withDuration: 0.5)
                self.addChild(htpMessage)
                htpMessage.zPosition=2
                htpMessage.run(fadeIn)
            }
            if startButton.contains(touch!.location(in: self)){
                let transition=SKTransition.moveIn(with: .right, duration: 0.2)
                let dashScene=SKScene(fileNamed: "DashGameScene") as! DashGameScene
                dashScene.setup(level: 1, message: "Drag to match groups of 4 tiles.\nYou have 50 moves.", bR: 10, bC: 6, turnGoal: 10, colorsPresent: 4, score: 0, upperBound: 15, lowerBound: 5)
                self.view?.presentScene(dashScene,transition: transition)
            }
            if backButton.contains(touch!.location(in: self)){
                let transition=SKTransition.moveIn(with: .left, duration: 0.2)
                let scene = SKScene(fileNamed: "MainMenu")!
                self.view?.presentScene(scene,transition: transition)
            }
            
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
    func prepStartButton()->SKNode{
        let node=SKNode()
        var dashBackground:SKShapeNode
        var dashText:SKLabelNode
        dashBackground=SKShapeNode(rectOf: CGSize(width: 200, height: 50),cornerRadius: 10)
        dashBackground.fillColor=UIColor.systemBlue
        dashText=SKLabelNode(text: "Start")
        dashText.fontName="AvenirNext-Bold"
        dashText.fontSize=15
        dashText.zPosition=1
        dashText.fontColor=UIColor.black
        dashText.verticalAlignmentMode = .center
        node.addChild(dashBackground)
        node.addChild(dashText)
        node.position=CGPoint(x: 0, y: self.size.height/3-step*2)
        return node
    }
    func prepHowToPlayMessage()->SKNode{
        let node=SKNode()
        var htpBox:SKShapeNode
        var htpText:SKLabelNode
        htpBox=SKShapeNode(rectOf: CGSize(width: self.size.width-1.5*step, height:self.size.height-1.5*step),cornerRadius: 10)
        htpBox.fillColor=UIColor.systemBlue
        htpText=SKLabelNode(text: "HOW TO PLAY:\nTouch and drag a tile to move it around the board.\n\nThe tile you're dragging will switch places with tiles in its way.\n\nEach time two tiles switch places it counts as one move.\nSo, shifting a tile over by five spaces counts as five moves.\n\nMatch groups of four or more tiles of the same color to remove them and score points.\n\nYou have 50 moves to make as many combos as possible.")
        htpText.numberOfLines=7
        htpText.verticalAlignmentMode = .center
        htpText.lineBreakMode = .byWordWrapping
        htpText.preferredMaxLayoutWidth=self.size.width-1.5*step-step
        htpText.fontName="AvenirNext-Bold"
        htpText.fontSize=17
        htpText.fontColor=UIColor.black
        node.addChild(htpBox)
        node.addChild(htpText)
        return node
    }
    func prepHTPButton()->SKNode{
        let node=SKNode()
        var htpBox:SKShapeNode
        var htpText:SKLabelNode
        htpBox=SKShapeNode(rectOf: CGSize(width: 200, height: 50),cornerRadius: 10)
        htpBox.fillColor=UIColor.systemBlue
        htpText=SKLabelNode(text: "How To Play")
        htpText.fontName="AvenirNext-Bold"
        htpText.fontSize=15
        htpText.fontColor=UIColor.black
        htpText.zPosition=1
        htpText.verticalAlignmentMode = .center
        node.addChild(htpBox)
        node.addChild(htpText)
        node.position=CGPoint(x: 0, y: self.size.height/3-step*3.5)
        return node
    }
    func prepBackButton()->SKNode{
        let node=SKNode()
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
    func prepTitleNode()->SKNode{
        let node=SKNode()
        var titleLabel:SKLabelNode
        var titleShadow:SKLabelNode
        titleLabel=SKLabelNode(text: "50-Yard Dash")
        titleLabel.fontName="AvenirNext-Bold"
        titleLabel.fontSize=40
        titleLabel.fontColor=UIColor.white
        titleShadow=SKLabelNode(text: "50-Yard Dash")
        titleShadow.fontName="AvenirNext-Bold"
        titleShadow.fontSize=40
        titleShadow.fontColor=UIColor.systemGray2
        titleLabel.position=CGPoint(x: 0, y:self.size.height/3 )
        titleShadow.position=CGPoint(x: 2, y:self.size.height/3-2)
        node.addChild(titleShadow)
        titleShadow.zPosition = -1
        node.addChild(titleLabel)
        return node
    }
    func prepScoreNode()->SKNode{
        let node=SKNode()
        let defaults=UserDefaults.standard
        let hs=defaults.integer(forKey: "DashHighScore")
        var scoreLabel:SKLabelNode
        var scoreShadow:SKLabelNode
        scoreLabel=SKLabelNode(text: "High Score: \(hs)")
        scoreShadow=SKLabelNode(text: "High Score: \(hs)")
        scoreLabel.fontName="AvenirNext-Bold"
        scoreShadow.fontName="AvenirNext-Bold"
        scoreLabel.position=CGPoint(x: 0, y:self.size.height/3-step )
        scoreShadow.position=CGPoint(x: 2, y:self.size.height/3-2-step)
        scoreLabel.fontColor=UIColor.white
        scoreShadow.fontColor=UIColor.systemGray2
        node.addChild(scoreShadow)
        scoreShadow.zPosition = -1
        node.addChild(scoreLabel)
        return node
    }
}
