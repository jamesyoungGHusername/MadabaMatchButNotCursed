//
//  GameScene.swift
//  MadabaMatch
//
//  Created by James Young on 12/5/21.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var board:Board!
    var scoreLabel:SKLabelNode!
    var comboLabel:SKLabelNode!
    var movesRemaining:SKLabelNode!
    var level:Int!
    var startMessage:String!
    var turnGoal:Int!
    var boardRows:Int!
    var boardCols:Int!
    var backButton:SKNode!
    var bText:SKLabelNode!
    var bBox:SKShapeNode!
    var openingMsg:GameMessage!
    var started:Bool!
    var colorsPresent:Int!
    var readyForNext:Bool=false
    override func didMove(to view: SKView) {
        self.addChild(openingMsg!.getNode())
        openingMsg.getNode().zPosition=10
        board=Board.init(w: self.size.width/1.3, h: self.size.height/1.3,r:boardRows,c:boardCols,gs:self)
        // Get label node from scene and store it for use later
        board!.populate()
        
        self.addChild(board!.sn)
        for r in board!.tiles{
            for t in r{
                self.addChild(t.node)
                t.updatePosition(animated: false, 0)
            }
        }
        scoreLabel=SKLabelNode(text:"Turn \(board!.turn+1)")
        scoreLabel!.fontName="AvenirNext-Bold"
        scoreLabel!.color=UIColor.link
        scoreLabel!.position=CGPoint(x: 0, y: board!.h/2+2)
        comboLabel=SKLabelNode(text:"MAX COMBO: \(board!.maxCombo)")
        comboLabel!.fontName="AvenirNext-Bold"
        comboLabel!.color=UIColor.link
        comboLabel!.position=CGPoint(x: 0, y: -board!.h/1.75)
        self.addChild(scoreLabel!)
        self.addChild(comboLabel!)
        movesRemaining=SKLabelNode(text:"")
        movesRemaining!.fontName="AvenirNext-Bold"
        movesRemaining!.fontSize=60
        movesRemaining!.color=UIColor.link
        movesRemaining!.position=CGPoint(x: 0, y: board!.h/1.8+2)
        self.addChild(movesRemaining!)
        // Create shape node to use during mouse interaction
        bBox=SKShapeNode(rectOf: CGSize(width: 100, height: 30),cornerRadius: 10)
        bBox?.fillColor=UIColor.systemGray2
        bText=SKLabelNode(text: "Back")
        bText!.fontName="AvenirNext-Bold"
        bText!.fontSize=30
        bText!.fontColor=UIColor.white
        bText!.zPosition=1
        bText!.verticalAlignmentMode = .center
        backButton=SKNode()
        backButton?.addChild(bBox!)
        backButton?.addChild(bText!)
        backButton?.position=CGPoint(x: -self.size.width/2+51, y: self.size.height/2-16)
        self.addChild(backButton!)
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
 
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if readyForNext{
            let transition=SKTransition.moveIn(with: .right, duration: 0.2)
            let nextScene = SKScene(fileNamed: "GameScene") as! GameScene
            nextScene.setup(level: level+1, message: "Level \(level+1): Survive \(turnGoal+1) turns", bR: 10, bC: 6, turnGoal: turnGoal+1,colorsPresent:4)
            self.view?.presentScene(nextScene,transition: transition)
        }
        if(started){
            let touch=touches.first
            if backButton!.contains(touch!.location(in: self)){
                print("back tapped")
                let transition=SKTransition.moveIn(with: .left, duration: 0.2)
                let scene = SKScene(fileNamed: "MainMenu")!
                self.view?.presentScene(scene,transition: transition)
            }
            if(!board!.gameOver){
                board!.touchDown(touch: touch!)
                movesRemaining!.zPosition=2
            }
            //movesRemaining!.position=CGPoint(x: touch!.location(in: self).x, y: touch!.location(in: self).y+50)
        }else{
            started=true
            openingMsg.getNode().removeFromParent()
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch=touches.first
        board!.touchMoved(touch: touch!)
        //movesRemaining!.position=CGPoint(x: touch!.location(in: self).x, y: touch!.location(in: self).y+50)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch=touches.first
        board!.touchUp(touch: touch!)
        if(board!.turn+1==turnGoal && !board!.gameOver){
            movesRemaining!.removeFromParent()
            let winningMessage=GameMessage(message: "GREAT!", position: CGPoint(x:-self.size.height/3,y:self.size.width), size: CGSize(width: self.size.width/2-10, height: self.size.height/10))
            let invis=SKAction.fadeOut(withDuration: 0)
            let reveal=SKAction.fadeIn(withDuration: 0.3)
            winningMessage.getNode().run(invis)
            self.addChild(winningMessage.getNode())
            winningMessage.getNode().zPosition=11
            winningMessage.getNode().run(reveal)
            readyForNext=true
        }
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
        scoreLabel!.text="Turn \(board!.turn+1)/\(turnGoal!)"
        if(board!.turn+1==turnGoal){
            board!.gameOver=true
        }
        comboLabel!.text="SCORE: \(board!.score)/250"
        
        if(board!.gameOver){
            movesRemaining!.position=CGPoint(x: 0, y: 0)
            movesRemaining!.zPosition=20
            movesRemaining!.text="GAME OVER"
        }else{
            movesRemaining!.text=""
        }
        if !animating{
            
            //board!.advanceTurn()
        }
    }
    public func setup(level:Int,message:String,bR:Int,bC:Int,turnGoal:Int,colorsPresent:Int){
        self.started=false
        self.level=level
        self.startMessage=message
        self.turnGoal=turnGoal
        boardRows=bR
        boardCols=bC
        openingMsg=GameMessage(message: message, position: CGPoint(x:-self.size.height/3,y:self.size.width), size: CGSize(width: self.size.width/2-10, height: self.size.height/10))
        self.colorsPresent=colorsPresent
    }
    func getPointLabel(at:CGPoint,points:Int)->SKNode{
        let score=SKLabelNode(text:"\(points) POINTS")
        let scoreShadow=SKLabelNode(text:"\(points) POINTS")
        score.fontName="AvenirNext-Bold"
        scoreShadow.fontName="AvenirNext-Bold"
        score.fontColor=UIColor.white
        scoreShadow.fontColor=UIColor.black
        score.fontSize=35
        scoreShadow.fontSize=35
        score.position=at
        scoreShadow.position.x=at.x-5
        scoreShadow.position.y=at.y-5
        let node=SKNode()
        
        node.addChild(scoreShadow)
        node.addChild(score)
        score.zPosition=1
        scoreShadow.zPosition = -1
        return node
    }
    func getComboLabel(at:CGPoint,type:ComboID)->SKNode{
        let label=SKLabelNode()
        let labelShadow=SKLabelNode()
        label.fontName="AvenirNext-Bold"
        labelShadow.fontName="AvenirNext-Bold"
        
        //let grow=SKAction.scale(by: 2, duration: 0.2)
        //let shrink=SKAction.scale(by: 0.1, duration: 0.2)
        let node=SKNode()
        node.addChild(labelShadow)
        node.addChild(label)
        label.zPosition=1
        labelShadow.zPosition = -1
        switch type{
            case .single:
                label.text=""
            case .duo:
                label.text="DOUBLE! 2X"
                labelShadow.text="DOUBLE! 2X"
                label.fontColor=UIColor.yellow
                labelShadow.fontColor=UIColor.black
            label.fontSize=25
            labelShadow.fontSize=25
                label.position=at
                labelShadow.position.x=at.x-5
                labelShadow.position.y=at.y-5
            
            case .tri:
            label.text="TRIPLE! 3X"
            labelShadow.text="TRIPLE! 3X"
            label.fontColor=UIColor.yellow
            labelShadow.fontColor=UIColor.black
            label.fontSize=30
            labelShadow.fontSize=30
            label.position=at
            labelShadow.position.x=at.x-5
            labelShadow.position.y=at.y-5
            
            case .quad:
            label.text="QUADRA! 4X"
            labelShadow.text="QUADRA! 4X"
            label.fontColor=UIColor.yellow
            labelShadow.fontColor=UIColor.black
            label.fontSize=35
            labelShadow.fontSize=35
            label.position=at
            labelShadow.position.x=at.x-5
            labelShadow.position.y=at.y-5
           
            case .penta:
            label.text="PENTA! 5X"
            labelShadow.text="PENTA! 5X"
            label.fontColor=UIColor.yellow
            labelShadow.fontColor=UIColor.black
            label.fontSize=40
            labelShadow.fontSize=40
            label.position=at
            labelShadow.position.x=at.x-5
            labelShadow.position.y=at.y-5
            
            case .sexta:
            label.text="SEXTA! 6X"
            labelShadow.text="SEXTA! 6X"
            label.fontColor=UIColor.yellow
            labelShadow.fontColor=UIColor.black
            label.fontSize=45
            labelShadow.fontSize=45
            label.position=at
            labelShadow.position.x=at.x-5
            labelShadow.position.y=at.y-5
          
            case .sept:
            label.text="FANTASTC!"
            labelShadow.text="FANTASTIC!"
            label.fontColor=UIColor.yellow
            labelShadow.fontColor=UIColor.black
            label.fontSize=50
            labelShadow.fontSize=50
            label.position=at
            labelShadow.position.x=at.x-5
            labelShadow.position.y=at.y-5
            
            case .octo:
            label.text="GODLIKE"
            labelShadow.text="GODLIKE"
            label.fontColor=UIColor.yellow
            labelShadow.fontColor=UIColor.black
            label.fontSize=60
            labelShadow.fontSize=60
            label.position=at
            labelShadow.position.x=at.x-5
            labelShadow.position.y=at.y-5
           
        }
        return node
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
