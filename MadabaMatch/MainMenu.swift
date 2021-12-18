//
//  MainMenu.swift
//  Madaba
//
//  Created by James Young on 12/7/21.
//
/*
 TO DO:
 Dash: add persistent high score. Implement restart button.
 
 countdown: examine messages displayed when combos appear. Make restart button ask whether you want to start from the beginning or just restart the level. Make it more obvious that tiles are counting down (maybe only make some jiggle? Or change the shadow? or add a ticking sound when one reaches 1? fade the others? some combination?)
 
 add third game mode (but what type)
 add combo sound
 make it so the score counts up every frame. have a second score variable stored in the game scene and while it's below the board score, increment it.
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
    var dashButton:SKNode!
    var dashBackground:SKShapeNode!
    var dashText:SKLabelNode!
    var gm:SKLabelNode!
    var scene1:GameScene!
    var lastLevel:Int!
    var zenButton:SKNode!
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
            buttonText=SKLabelNode(text: "Countdown")
        }else{
            buttonText=SKLabelNode(text: "Countdown")
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
        button.position=CGPoint(x: 0, y:self.size.height/4-2*step )
        self.addChild(button!)
        self.backgroundColor=UIColor.black
        dashBackground=SKShapeNode(rectOf: CGSize(width: 200, height: 50),cornerRadius: 10)
        dashBackground?.fillColor=getColor(color: getRandomColor())
        dashText=SKLabelNode(text: "50-Yard Dash")
        dashText!.fontName="AvenirNext-Bold"
        dashText!.fontSize=15
        dashText!.zPosition=1
        dashText!.fontColor=UIColor.black
        dashText!.verticalAlignmentMode = .center
        dashButton=SKNode()
        dashButton!.addChild(dashBackground!)
        dashButton!.addChild(dashText!)
        dashButton!.position=CGPoint(x: 0, y:self.size.height/4-step )
        self.addChild(dashButton!)
        gm=SKLabelNode(text: "Game Mode:")
        gm.fontSize=30
        gm.fontColor=UIColor.white
        gm.position=CGPoint(x: 0, y:self.size.height/4 )
        self.addChild(gm)
        //zenButton=prepZenButton()
        //self.addChild(zenButton)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch=touches.first
        let defaults=UserDefaults.standard
        let score=defaults.integer(forKey: "SurviveScore")
        let completedSurvival=defaults.bool(forKey: "SurvivalCompleted")
    
        print(completedSurvival)
        print(lastLevel!)
        
        if dashButton!.contains(touch!.location(in: self)){
            let transition=SKTransition.moveIn(with: .right, duration: 0.2)
            let dashScene=SKScene(fileNamed: "DashReadyScene") as! DashReadyScene
            self.view?.presentScene(dashScene,transition: transition)
        }else if button!.contains(touch!.location(in: self)){
            let transition=SKTransition.moveIn(with: .right, duration: 0.2)
            let cdReadyScene=SKScene(fileNamed: "CountdownReadyScene") as! CountdownReadyScene
            self.view?.presentScene(cdReadyScene,transition: transition)
        }
        /*
        if zenButton!.contains(touch!.location(in: self)){
            let transition=SKTransition.moveIn(with: .right, duration: 0.2)
            let zenScene=SKScene(fileNamed: "ZenReadyScene") as! ZenReadyScene
            self.view?.presentScene(zenScene,transition: transition)
        }
         */
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
    func prepZenButton()->SKNode{
        let node=SKNode()
        var zenBackground:SKShapeNode
        var zenText:SKLabelNode
        zenBackground=SKShapeNode(rectOf: CGSize(width: 200, height: 50),cornerRadius: 10)
        zenBackground.fillColor=getColor(color: getRandomColor())
        zenText=SKLabelNode(text: "Mosaic")
        zenText.fontName="AvenirNext-Bold"
        zenText.fontSize=15
        zenText.zPosition=1
        zenText.fontColor=UIColor.black
        zenText.verticalAlignmentMode = .center
        node.addChild(zenBackground)
        node.addChild(zenText)
        node.position=CGPoint(x: 0, y: self.size.height/4-3*(self.size.height/3-self.size.height/4))
        return node
    }
}
