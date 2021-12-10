//
//  MainMenu.swift
//  Madaba
//
//  Created by James Young on 12/7/21.
//
/*
 TO DO: add restart level function. save score and board position upon back?
 */
import Foundation
import SpriteKit
import SceneKit
class MainMenu:SKScene{
    var titleLabel:SKLabelNode!
    var titleShadow:SKLabelNode!
    var titleNode:SKNode!
    var buttonBackground:SKShapeNode!
    var buttonText:SKLabelNode!
    var button:SKNode!
    var gm:SKLabelNode!
    var scene1:GameScene!
    var lastLevel:Int!
    override func didMove(to view: SKView) {
        let defaults=UserDefaults.standard
        defaults.set(false, forKey: "SurvivalCompleted")
        lastLevel=defaults.integer(forKey:"SurviveLevel")
        titleLabel=SKLabelNode(text: "Madaba Match")
        titleLabel!.fontName="AvenirNext-Bold"
        titleLabel!.fontSize=40
        titleLabel!.fontColor=getColor(color: getRandomColor())
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
        buttonBackground=SKShapeNode(rectOf: CGSize(width: 200, height: 50),cornerRadius: 10)
        buttonBackground?.fillColor=getColor(color: getRandomColor())
        if(lastLevel==0){
            buttonText=SKLabelNode(text: "Countdown LV:1")
        }else{
            buttonText=SKLabelNode(text: "Countdown Lv:\(lastLevel!)")
        }
        if(defaults.bool(forKey: "SurvivalCompleted")){
            buttonText=SKLabelNode(text: "Countdown Completed")
            buttonText.lineBreakMode = .byWordWrapping
            buttonText.numberOfLines=2
            buttonText.preferredMaxLayoutWidth=150
        }
        
        buttonText!.fontName="AvenirNext-Bold"
        buttonText!.fontSize=15
        buttonText!.zPosition=1
        buttonText!.fontColor=UIColor.black
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
        let defaults=UserDefaults.standard
        let score=defaults.integer(forKey: "SurviveScore")
        let completedSurvival=defaults.bool(forKey: "SurvivalCompleted")
    
        print(completedSurvival)
        print(lastLevel!)
        lastLevel=6
        if button!.contains(touch!.location(in: self)){
            if(!completedSurvival){
                defaults.set(false, forKey: "gamePaused")
                if(defaults.bool(forKey: "gamePaused")){
                    
                    do{
                        let transition=SKTransition.moveIn(with: .right, duration: 0.2)
                        let codedBoard = defaults.object(forKey: "boardToResume") as! Data
                        var board = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(codedBoard) as! Board
                        scene1 = SKScene(fileNamed: "GameScene") as? GameScene
                        scene1.board=board
                        scene1.movingFromPause=true
                        if(lastLevel<=5){
                            scene1.setup(level: lastLevel, message: "Level \(lastLevel!):\nSurvive \(4+lastLevel) turns.", bR: 10, bC: 6, turnGoal: 4+lastLevel,colorsPresent:4,score: defaults.integer(forKey: "lastScore"),upperBound: 15,lowerBound:6)
                        }else{
                            scene1.setup(level: lastLevel, message: "Level \(lastLevel!)", bR: 10, bC: 6, turnGoal: 4+lastLevel,colorsPresent:4,score: score,upperBound: 15-lastLevel+4,lowerBound:3)
                        }
                        self.view?.presentScene(scene1,transition: transition)
                    }catch{
                        print("error loading last game")
                    }
                }else if lastLevel==10{
                    let transition=SKTransition.moveIn(with: .right, duration: 0.2)
                    scene1 = SKScene(fileNamed: "GameScene") as? GameScene
                    scene1.setup(level: 10, message: "FINAL LEVEL", bR: 11, bC: 7, turnGoal: 30,colorsPresent:4,score: score,upperBound: 5,lowerBound: 3)
                    self.view?.presentScene(scene1,transition: transition)
                }else if(lastLevel==0 || lastLevel==1){
                    print("Start tapped")
                    let transition=SKTransition.moveIn(with: .right, duration: 0.2)
                    scene1 = SKScene(fileNamed: "GameScene") as? GameScene
                    scene1.setup(level: 1, message: "Connect groups of 4 tiles.\nDo not let tiles count down to 0.\nSurvive 5 turns.", bR: 10, bC: 6, turnGoal: 5,colorsPresent:4,score: 0,upperBound:15 ,lowerBound:6)
                    self.view?.presentScene(scene1,transition: transition)
                }else{
                    let transition=SKTransition.moveIn(with: .right, duration: 0.2)
                    scene1 = SKScene(fileNamed: "GameScene") as? GameScene
                    if(lastLevel<=5){
                        scene1.setup(level: lastLevel, message: "Level \(lastLevel!):\nSurvive \(4+lastLevel) turns.", bR: 10, bC: 6, turnGoal: 4+lastLevel,colorsPresent:4,score: score,upperBound: 15,lowerBound:6)
                    }else{
                        scene1.setup(level: lastLevel, message: "Level \(lastLevel!)", bR: 10, bC: 6, turnGoal: 4+lastLevel,colorsPresent:4,score: score,upperBound: 15-lastLevel+4,lowerBound:3)
                    }
                    self.view?.presentScene(scene1,transition: transition)
                }
            }else{
                
            }
               
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
