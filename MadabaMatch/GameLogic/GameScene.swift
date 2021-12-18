//
//  GameScene.swift
//  MadabaMatch
//
//  Created by James Young on 12/5/21.
//
/*
 TO DO, Find and fix bug that has to do with receiving touch input while animating.
 */

import SpriteKit
import GameplayKit
import AudioToolbox
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
    var restartButton:SKNode!
    var bText:SKLabelNode!
    var bBox:SKShapeNode!
    var rText:SKLabelNode!
    var rBox:SKShapeNode!
    var openingMsg:GameMessage!
    var started:Bool!
    var colorsPresent:Int!
    var readyForNext:Bool=false
    var ub=15
    var lb=5
    var movingFromPause=false
    override func didMove(to view: SKView) {
        if(!movingFromPause){
        self.addChild(openingMsg!.getNode())
        openingMsg.getNode().zPosition=10
      
        let defaults=UserDefaults.standard
        defaults.set(level,forKey: "SurviveLevel")
        
        board=Board.init(w: self.size.width/1.3, h: self.size.height/1.3,r:boardRows,c:boardCols,gs:self,uB: ub, lB: lb)
        // Get label node from scene and store it for use later
        board!.populate()
        board!.score=sessionScore
        defaults.set(board!.score,forKey: "SurviveScore")
        self.addChild(board!.sn)
        for r in board!.tiles{
            for t in r{
                self.addChild(t.node)
                t.updatePosition(animated: false, 0)
            }
        }
        winningMessage=GameMessage(message: "YOU WIN\nTap To Continue", position: CGPoint(x:-self.size.height/3,y:self.size.width), size: CGSize(width: self.size.width/2, height: self.size.height/10))
        let invis=SKAction.fadeOut(withDuration: 0)
        
        winningMessage.getNode().run(invis)
        self.addChild(winningMessage.getNode())
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
        movesRemaining!.fontSize=30
        movesRemaining!.color=UIColor.link
        movesRemaining!.position=CGPoint(x: 0, y: self.size.height/2-self.view!.safeAreaInsets.top-15)
        self.addChild(movesRemaining!)
        // Create shape node to use during mouse interaction
        bBox=SKShapeNode(rectOf: CGSize(width: 120, height: 30),cornerRadius: 10)
        bBox?.fillColor=UIColor.systemGray2
        bText=SKLabelNode(text: "Back")
        bText!.fontName="AvenirNext-Bold"
        bText!.fontSize=30
        bText!.fontColor=UIColor.white
        bText!.zPosition=1
        bText!.verticalAlignmentMode = .center
        rBox=SKShapeNode(rectOf: CGSize(width: 120, height: 30),cornerRadius: 10)
        rBox?.fillColor=UIColor.systemGray2
        rText=SKLabelNode(text: "Restart")
        rText!.fontName="AvenirNext-Bold"
        rText!.fontSize=30
        rText!.fontColor=UIColor.white
        rText!.zPosition=1
        rText!.verticalAlignmentMode = .center
        restartButton=SKNode()
        restartButton?.addChild(rBox!)
        restartButton?.addChild(rText!)
        restartButton?.position=CGPoint(x: self.size.width/2-61, y: self.size.height/2-16-self.view!.safeAreaInsets.top)
        self.addChild(restartButton!)
        backButton=SKNode()
        backButton?.addChild(bBox!)
        backButton?.addChild(bText!)
        backButton?.position=CGPoint(x: -self.size.width/2+61, y: self.size.height/2-16-self.view!.safeAreaInsets.top)
        self.addChild(backButton!)
        }else{
            movingFromPause=false
        }
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
 
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch=touches.first
        readyForNext=true
        if(level+1==11 && readyForNext && started){
            print("in end of game block")
            let defaults=UserDefaults.standard
            defaults.set(true, forKey: "SurvivalCompleted")
            //readyForNext=false
            //started=false
            winningMessage.getNode().removeFromParent()
            winningMessage=GameMessage(message: "VICTORY\n\n\nFinal Score: \(board!.score)", position: CGPoint(x:0,y:0), size: CGSize(width: self.size.width/2, height: self.size.height/3))
            self.addChild(winningMessage.getNode())
            winningMessage.getNode().zPosition=11
            winningMessage.getNode().run(SKAction.fadeIn(withDuration: 0.5))
            if backButton!.contains(touch!.location(in: self)){
                print("back tapped")
                let transition=SKTransition.moveIn(with: .left, duration: 0.2)
                let scene = SKScene(fileNamed: "CountdownReadyScene")!
                self.view?.presentScene(scene,transition: transition)
            }
        }else if readyForNext && started{
            let transition=SKTransition.moveIn(with: .right, duration: 0.2)
            let nextScene = SKScene(fileNamed: "GameScene") as! GameScene
            if(level==10){
                let transition=SKTransition.moveIn(with: .left, duration: 0.2)
                let scene = SKScene(fileNamed: "CountdownReadyScene")!
                self.view?.presentScene(scene,transition: transition)
            }else if(level+1==10){
                nextScene.setup(level: 10, message: "FINAL LEVEL", bR: 11, bC: 7, turnGoal: 30,colorsPresent:4,score: board!.score,upperBound: 5,lowerBound: 3)
            }else if (level+1<=5){
                nextScene.setup(level: level+1, message: "Level \(level+1):\nSurvive \(5+level) turns.", bR: 10, bC: 6, turnGoal: turnGoal+1,colorsPresent:4,score: board!.score,upperBound: 15,lowerBound: 6)
            }else{
                nextScene.setup(level: level+1, message: "Level \(level+1):\nSurvive \(5+level) turns.", bR: 10, bC: 6, turnGoal: turnGoal+1,colorsPresent:4,score: board!.score,upperBound: 15-level+3,lowerBound: 3)
            }
            self.view?.presentScene(nextScene,transition: transition)
        }else if(started){
            if restartButton!.contains(touch!.location(in: self)){
                let transition=SKTransition.crossFade(withDuration: 0.5)
                let nextScene = SKScene(fileNamed: "GameScene") as! GameScene
                if(level==10){
                    nextScene.setup(level: 10, message: "FINAL LEVEL", bR: 11, bC: 7, turnGoal: 30,colorsPresent:4,score: sessionScore,upperBound: 5,lowerBound: 3)
                }else if level==1{
                    nextScene.setup(level: 1, message: "Drag to match groups of 4 tiles.\nTiles count down by one each turn.\nDo not let any reach zero.", bR: 10, bC: 6, turnGoal: 5,colorsPresent:4,score: 0,upperBound:15 ,lowerBound:6)
                }else if (level+1<=5){
                    nextScene.setup(level: level, message: "Level \(level!):\nSurvive \(4+level) turns.", bR: 10, bC: 6, turnGoal: turnGoal,colorsPresent:4,score: sessionScore,upperBound: ub,lowerBound: lb)
                }else{
                    nextScene.setup(level: level, message: "Level \(level!):\nSurvive \(4+level) turns.", bR: 10, bC: 6, turnGoal: turnGoal,colorsPresent:4,score: sessionScore,upperBound: ub,lowerBound: lb)
                }
                self.view?.presentScene(nextScene,transition: transition)
            }else if backButton!.contains(touch!.location(in: self)){
                let defaults=UserDefaults.standard
                defaults.set(false,forKey: "gamePaused")
                do{
                    let encodedBoard = try NSKeyedArchiver.archivedData(withRootObject: board, requiringSecureCoding: false)
                    defaults.set(encodedBoard, forKey: "boardToResume")
                    defaults.set(board!.score, forKey: "lastScore")
                }catch{
                    print("error saving scene")
                }
                
                
                
               
                print("back tapped")
                let transition=SKTransition.moveIn(with: .left, duration: 0.2)
                let scene = SKScene(fileNamed: "CountdownReadyScene")!
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
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    var winningMessage:GameMessage!
    var localScore=0
    override func update(_ currentTime: TimeInterval) {
        var animating=false
        for c in self.children{
            if c.hasActions(){
                animating=true
            }
        }
        scoreLabel!.text="Turn \(board!.turn)/\(turnGoal!)"
        if(localScore<board!.score){
            if(board!.score-localScore>100){
                localScore+=5
                AudioServicesPlaySystemSound(1103)
            }else{
                localScore+=1
                AudioServicesPlaySystemSound(1103)
            }
        }
        
        comboLabel!.text="SCORE: \(localScore)"
        
        if(board!.gameOver && !readyForNext){
            movesRemaining!.position=CGPoint(x: 0, y: 0)
            movesRemaining!.zPosition=20
            movesRemaining!.text="GAME OVER"
            let defaults=UserDefaults.standard
            defaults.set(level,forKey: "SurviveLevel")
            comboLabel!.position=CGPoint(x: 0, y: -50)
            comboLabel!.zPosition=20
            comboLabel!.fontSize=25
            comboLabel!.text="FINAL SCORE: \(board!.score)"
        }else{
            movesRemaining!.fontSize=30
            movesRemaining!.position=CGPoint(x: 0, y: self.size.height/2-self.view!.safeAreaInsets.top-15
            )
            movesRemaining!.zPosition=20
            movesRemaining!.text="Level \(level!)"
        }
        if(readyForNext && level != 10){
            movesRemaining!.removeFromParent()
            let reveal=SKAction.fadeIn(withDuration: 0.3)
            winningMessage.getNode().zPosition=11
            winningMessage.getNode().run(reveal)
        }
        if !animating{
            
            //board!.advanceTurn()
        }
    }
    var sessionScore=0
    public func setup(level:Int,message:String,bR:Int,bC:Int,turnGoal:Int,colorsPresent:Int,score:Int,upperBound:Int,lowerBound:Int){
        self.started=false
        self.level=level
        self.startMessage=message
        self.turnGoal=turnGoal
        boardRows=bR
        boardCols=bC
        openingMsg=GameMessage(message: message, position: CGPoint(x:-self.size.height/3,y:self.size.width), size: CGSize(width: self.size.width/2-10, height: self.size.height/10))
        self.colorsPresent=colorsPresent
        self.sessionScore=score
        self.localScore=score
        self.lb=lowerBound
        self.ub=upperBound
        
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
