//
//  CountdownReadyScene.swift
//  Madaba
//
//  Created by James Young on 12/14/21.
//

import Foundation
import SpriteKit
class CountdownReadyScene:SKScene{
    var displayHTP:Bool!
    var htpMessage:SKNode!
    var htpButton:SKNode!
    var startButton:SKNode!
    var backButton:SKNode!
    var titleNode:SKNode!
    var levelNode:SKNode!
    var restartNode:SKNode!
    var step:Double!
    var scoreLabel:SKNode!
    let generator = UISelectionFeedbackGenerator()
    override func didMove(to view: SKView) {
        let defaults=UserDefaults.standard
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
        levelNode=prepLevelNode()
        self.addChild(levelNode)
        restartNode=prepRestartButton()
        self.addChild(restartNode)
        scoreLabel=prepScoreLabel()
        self.addChild(scoreLabel)
        if defaults.bool(forKey: "SurvivalCompleted"){
            startButton.removeFromParent()
        }else{
            scoreLabel.removeFromParent()
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch=touches.first
        if displayHTP{
            let fadeOut=SKAction.fadeOut(withDuration: 0.5)
            htpMessage.run(fadeOut, completion:{self.htpMessage.removeFromParent();self.displayHTP=false;})
        }else{
            if htpButton.contains(touch!.location(in: self)){
                generator.selectionChanged()
                displayHTP=true
                let fadeIn=SKAction.fadeIn(withDuration: 0.5)
                self.addChild(htpMessage)
                htpMessage.zPosition=2
                htpMessage.run(fadeIn)
            }
            if startButton.contains(touch!.location(in: self)){
                generator.selectionChanged()
                transitionToGame()
            }
            if backButton.contains(touch!.location(in: self)){
                generator.selectionChanged()
                let transition=SKTransition.moveIn(with: .left, duration: 0.2)
                let scene = SKScene(fileNamed: "MainMenu")!
                self.view?.presentScene(scene,transition: transition)
            }
            if restartNode.contains(touch!.location(in: self)){
                generator.selectionChanged()
                let defaults=UserDefaults.standard
                defaults.set(false, forKey: "SurvivalCompleted")
                let transition=SKTransition.moveIn(with: .right, duration: 0.2)
                var scene1 = SKScene(fileNamed: "GameScene") as! GameScene
                scene1.setup(level: 1, message: "Drag to match groups of 4 tiles.\nTiles count down by one each turn.\nDo not let any reach zero.", bR: 10, bC: 6, turnGoal: 5,colorsPresent:4,score: 0,upperBound:15 ,lowerBound:6)
                self.view?.presentScene(scene1,transition: transition)
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
    func transitionToGame(){
        let defaults=UserDefaults.standard
        let score=defaults.integer(forKey: "SurviveScore")
        let completedSurvival=defaults.bool(forKey: "SurvivalCompleted")
        var lastLevel=defaults.integer(forKey:"SurviveLevel")
        if lastLevel==0{
            lastLevel=1
        }
        var scene1:GameScene
        if(!completedSurvival){
            if lastLevel==10{
                let transition=SKTransition.moveIn(with: .right, duration: 0.2)
                scene1 = SKScene(fileNamed: "GameScene") as! GameScene
                scene1.setup(level: 10, message: "FINAL LEVEL", bR: 11, bC: 7, turnGoal: 30,colorsPresent:4,score: score,upperBound: 5,lowerBound: 3)
                self.view?.presentScene(scene1,transition: transition)
            }else if(lastLevel==0 || lastLevel==1){
                print("Start tapped")
                let transition=SKTransition.moveIn(with: .right, duration: 0.2)
                scene1 = SKScene(fileNamed: "GameScene") as! GameScene
                scene1.setup(level: 1, message: "Drag to match groups of 4 tiles.\nTiles count down by one each turn.\nDo not let any reach zero.", bR: 10, bC: 6, turnGoal: 5,colorsPresent:4,score: 0,upperBound:15 ,lowerBound:6)
                self.view?.presentScene(scene1,transition: transition)
            }else{
                let transition=SKTransition.moveIn(with: .right, duration: 0.2)
                scene1 = SKScene(fileNamed: "GameScene") as! GameScene
                if(lastLevel<=5){
                    scene1.setup(level: lastLevel, message: "Level \(lastLevel):\nSurvive \(4+lastLevel) turns.", bR: 10, bC: 6, turnGoal: 4+lastLevel,colorsPresent:4,score: score,upperBound: 15,lowerBound:6)
                }else{
                    scene1.setup(level: lastLevel, message: "Level \(lastLevel)", bR: 10, bC: 6, turnGoal: 4+lastLevel,colorsPresent:4,score: score,upperBound: 15-lastLevel+4,lowerBound:3)
                }
                self.view?.presentScene(scene1,transition: transition)
            }
        }
    }
    func prepScoreLabel()->SKNode{
        let node=SKNode()
        let defaults=UserDefaults.standard
        var scoreLabel:SKLabelNode
        var scoreShadow:SKLabelNode
        scoreLabel=SKLabelNode(text: "Score: \(defaults.integer(forKey: "SurviveScore"))")
        scoreLabel.fontName="AvenirNext-Bold"
        scoreLabel.fontSize=30
        scoreLabel.fontColor=getColor(color: getRandomColor())
        scoreLabel.horizontalAlignmentMode = .center
        scoreShadow=SKLabelNode(text: "Score: \(defaults.integer(forKey: "SurviveScore"))")
        scoreShadow.horizontalAlignmentMode = .center
        scoreShadow.fontName="AvenirNext-Bold"
        scoreShadow.fontSize=30
        scoreShadow.fontColor=UIColor.systemGray2
        scoreLabel.position=CGPoint(x: 0, y:self.size.height/3-step*2 )
        scoreShadow.position=CGPoint(x: 2, y:self.size.height/3-step*2-2)
        node.addChild(scoreShadow)
        scoreShadow.zPosition = -1
        node.addChild(scoreLabel)
        return node
    }
    func prepStartButton()->SKNode{
        let node=SKNode()
        var dashBackground:SKShapeNode
        var dashText:SKLabelNode
        dashBackground=SKShapeNode(rectOf: CGSize(width: 200, height: 50),cornerRadius: 10)
        dashBackground.fillColor=getColor(color: getRandomColor())
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
    func prepRestartButton()->SKNode{
        let node=SKNode()
        var dashBackground:SKShapeNode
        var restartText:SKLabelNode
        dashBackground=SKShapeNode(rectOf: CGSize(width: 200, height: 50),cornerRadius: 10)
        dashBackground.fillColor=getColor(color: getRandomColor())
        restartText=SKLabelNode(text: "Reset Progress")
        restartText.fontName="AvenirNext-Bold"
        restartText.fontSize=15
        restartText.zPosition=1
        restartText.fontColor=UIColor.black
        restartText.verticalAlignmentMode = .center
        node.addChild(dashBackground)
        node.addChild(restartText)
        node.position=CGPoint(x: 0, y: self.size.height/3-step*3)
        return node
    }
    func prepHowToPlayMessage()->SKNode{
        let node=SKNode()
        var htpBox:SKShapeNode
        var htpText:SKLabelNode
        htpBox=SKShapeNode(rectOf: CGSize(width: self.size.width-1.5*step, height:self.size.height-1.5*step),cornerRadius: 10)
        htpBox.fillColor=getColor(color: getRandomColor())
        htpText=SKLabelNode(text: "HOW TO PLAY:\nTouch and drag a tile to move it around the board.\n\nThe tile you're dragging will switch places with tiles in its way.\n\nTouching a tile, moving it, and then letting go of it counts as one turn.\nAt the end of each turn, every tile left on the board counts down by one.\n\nMatch groups of four or more tiles of the same color to remove them and score points.\nIf any tiles count down to zero, it's game over.")
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
        htpBox.fillColor=getColor(color: getRandomColor())
        htpText=SKLabelNode(text: "How To Play")
        htpText.fontName="AvenirNext-Bold"
        htpText.fontSize=15
        htpText.fontColor=UIColor.black
        htpText.zPosition=1
        htpText.verticalAlignmentMode = .center
        node.addChild(htpBox)
        node.addChild(htpText)
        node.position=CGPoint(x: 0, y: self.size.height/3-step*4)
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
        node.position=CGPoint(x: -self.size.width/2+61+self.view!.safeAreaInsets.left
                              , y: self.size.height/2-16-self.view!.safeAreaInsets.top)
        return node
    }
    func prepTitleNode()->SKNode{
        let node=SKNode()
        var titleLabel:SKLabelNode
        var titleShadow:SKLabelNode
        titleLabel=SKLabelNode(text: "Countdown")
        titleLabel.fontName="AvenirNext-Bold"
        titleLabel.fontSize=40
        titleLabel.fontColor=getColor(color: getRandomColor())
        titleShadow=SKLabelNode(text: "Countdown")
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
    func prepLevelNode()->SKNode{
        let node=SKNode()
        let defaults=UserDefaults.standard
        let completedSurvival=defaults.bool(forKey: "SurvivalCompleted")
        if !(completedSurvival){
            var lastLevel=defaults.integer(forKey:"SurviveLevel")
            if lastLevel==0{
                lastLevel=1
            }
            var scoreLabel:SKLabelNode
            var scoreShadow:SKLabelNode
            scoreLabel=SKLabelNode(text: "Level: \(lastLevel)")
            scoreShadow=SKLabelNode(text: "Level: \(lastLevel)")
            scoreLabel.fontName="AvenirNext-Bold"
            scoreShadow.fontName="AvenirNext-Bold"
            scoreLabel.position=CGPoint(x: 0, y:self.size.height/3-step )
            scoreShadow.position=CGPoint(x: 2, y:self.size.height/3-2-step)
            scoreLabel.fontColor=getColor(color: getRandomColor())
            scoreShadow.fontColor=UIColor.systemGray2
            node.addChild(scoreShadow)
            scoreShadow.zPosition = -1
            node.addChild(scoreLabel)
        }else{
            var scoreLabel:SKLabelNode
            var scoreShadow:SKLabelNode
            scoreLabel=SKLabelNode(text: "COMPLETE")
            scoreShadow=SKLabelNode(text: "COMPLETE")
            scoreLabel.fontName="AvenirNext-Bold"
            scoreShadow.fontName="AvenirNext-Bold"
            scoreLabel.position=CGPoint(x: 0, y:self.size.height/3-step )
            scoreShadow.position=CGPoint(x: 2, y:self.size.height/3-2-step)
            scoreLabel.fontColor=getColor(color: getRandomColor())
            scoreShadow.fontColor=UIColor.systemGray2
            node.addChild(scoreShadow)
            scoreShadow.zPosition = -1
            node.addChild(scoreLabel)
        }
        return node
    }
    func getRandomColor()->TileColor{
        return TileColor.allCases.randomElement()!
    }
    func getColor(color:TileColor)->UIColor{
        switch color {
        case .red:
            return UIColor.systemRed
        case .blue:
            return UIColor.systemBlue
        case .purple:
            return UIColor.systemPurple
        case .green:
            return UIColor.systemGreen
        case .yellow:
            return UIColor.systemYellow
        case .orange:
            return UIColor.systemOrange
        case .pink:
            return UIColor.systemTeal
        case .brown:
            return UIColor.green
        case .magenta:
            return UIColor.magenta
        }
    }
}
