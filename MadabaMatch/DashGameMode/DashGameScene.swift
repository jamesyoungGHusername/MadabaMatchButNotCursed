//
//  DashGameScene.swift
//  Madaba
//
//  Created by James Young on 12/11/21.
//


import SpriteKit
import GameplayKit
import AudioToolbox

class DashGameScene: SKScene {
    
    var board:DashBoard!
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
        self.backgroundColor=UIColor.black
        if(!movingFromPause){
        self.addChild(openingMsg!.getNode())
        openingMsg.getNode().zPosition=10
      
        //let defaults=UserDefaults.standard
        //defaults.set(level,forKey: "SurviveLevel")
        
        board=DashBoard.init(w: self.size.width/1.3, h: self.size.height/1.3,r:boardRows,c:boardCols,gs:self,uB: ub, lB: lb)
        // Get label node from scene and store it for use later
        board!.populate()
        board!.score=sessionScore
        //defaults.set(board!.score,forKey: "SurviveScore")
        self.addChild(board!.sn)
        for r in board!.tiles{
            for t in r{
                self.addChild(t.node)
                t.updatePosition(animated: false, 0)
            }
        }
        winningMessage=GameMessage(message: "YOU WIN", position: CGPoint(x:-self.size.height/3,y:self.size.width), size: CGSize(width: self.size.width/2, height: self.size.height/10))
        let invis=SKAction.fadeOut(withDuration: 0)
        
        winningMessage.getNode().run(invis)
        self.addChild(winningMessage.getNode())
        
        comboLabel=SKLabelNode(text:"MAX COMBO: \(board!.maxCombo)")
        comboLabel!.fontName="AvenirNext-Bold"
        comboLabel!.color=UIColor.link
        comboLabel!.position=CGPoint(x: 0, y: -board!.h/1.75)
        //self.addChild(scoreLabel!)
        self.addChild(comboLabel!)
        movesRemaining=SKLabelNode(text:"")
        movesRemaining!.fontName="AvenirNext-Bold"
        movesRemaining!.fontSize=80
        movesRemaining!.color=UIColor.link
        movesRemaining!.position=CGPoint(x: 0, y: self.size.height/2-70)
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
        restartButton?.position=CGPoint(x: self.size.width/2-61, y: self.size.height/2-16)
        self.addChild(restartButton!)
        backButton=SKNode()
        backButton?.addChild(bBox!)
        backButton?.addChild(bText!)
        backButton?.position=CGPoint(x: -self.size.width/2+61, y: self.size.height/2-16)
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
        
        if(started){
            if backButton!.contains(touch!.location(in: self)){
                let transition=SKTransition.moveIn(with: .left, duration: 0.2)
                let scene = SKScene(fileNamed: "DashReadyScene")!
                self.view?.presentScene(scene,transition: transition)
            }else if restartButton!.contains(touch!.location(in: self)){
                
                let transition=SKTransition.crossFade(withDuration: 0.5)
                let scene = SKScene(fileNamed: "DashGameScene") as! DashGameScene
                scene.setup(level: 1, message: "Drag to match groups of 4 tiles.\nYou have 50 moves.", bR: 10, bC: 6, turnGoal: 10, colorsPresent: 4, score: 0, upperBound: 15, lowerBound: 5)
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
        if(localScore<board!.score){
            localScore+=1
            AudioServicesPlaySystemSound(1103)
        }
        comboLabel!.text="SCORE: \(localScore)"
        movesRemaining!.text="\(board!.movesRemaining)"
        if(board!.gameOver){
            //let defaults=UserDefaults.standard
            comboLabel!.text=""
            let defaults=UserDefaults.standard
            if board!.score>defaults.integer(forKey: "DashHighScore"){
                defaults.set(board!.score, forKey: "DashHighScore")
            }
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
