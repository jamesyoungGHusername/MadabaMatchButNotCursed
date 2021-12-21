//
//  Tile.swift
//  MadabaMatch
//
//  Created by James Young on 12/5/21.
//

import Foundation
import SpriteKit
import AudioToolbox
class Tile:NSObject, NSSecureCoding{
    static var supportsSecureCoding=true
    
    
    var row:Int
    var col:Int
    var node:SKShapeNode
    var w:Double
    var h:Double
    var position:CGPoint
    var color:TileColor
    var selected=false
    var animating=false
    var moves=0
    var moveLabel=SKLabelNode(text: "")
    var moveShadow=SKLabelNode(text: "")
    var movesNode=SKNode()
    var grouped=false
    var finalGrouped=false
    init(row:Int,col:Int,w:Double,h:Double,position:CGPoint,node:SKShapeNode,color:TileColor){
        
        self.row=row
        self.col=col
        self.w=w
        self.h=h
        self.position=position
        self.node=node
        self.node.position=self.position
        self.color=color
        self.moves=15 //Int.random(in: 0...5)
        
        self.moveLabel.verticalAlignmentMode = .center
        self.moveShadow.verticalAlignmentMode = .center
        if(moves != 0){
            self.moveLabel.text="\(moves)"
            self.moveShadow.text="\(moves)"
        }else{
            self.moveLabel.text=""
            self.moveShadow.text=""
        }
        self.moveLabel.fontColor=UIColor.white
        self.moveLabel.fontSize=20
        self.moveLabel.fontName="AvenirNext-Bold"
        self.moveShadow.fontColor=UIColor.black
        
        self.moveShadow.fontSize=20
        self.moveShadow.fontName="AvenirNext-Bold"
        self.moveShadow.position=CGPoint(x: self.moveLabel.position.x+1, y: self.moveLabel.position.y-1)
        self.movesNode.addChild(moveLabel)
        self.movesNode.addChild(moveShadow)
        moveLabel.zPosition = 3
        moveShadow.zPosition = 2
        node.addChild(movesNode)
  
    }
    convenience init(copy:Tile) {
        self.init(row: copy.row, col: copy.col, w: copy.w, h: copy.h, position: copy.position, node: copy.node, color: copy.color)
    }
    convenience required init?(coder aDecoder: NSCoder) {
        
        let row=aDecoder.decodeInteger(forKey: "Row")
        let col=aDecoder.decodeInteger(forKey: "Col")
        let w=aDecoder.decodeDouble(forKey: "W")
        let h=aDecoder.decodeDouble(forKey: "H")
        let position=aDecoder.decodeObject(forKey: "TilePosition") as! CGPoint
        let color=aDecoder.decodeObject(forKey: "TileColorEnum") as! TileColor
        self.init(row: row, col: col, w: w, h: h, position: position, node: SKShapeNode(rectOf: CGSize(width: w, height: h)), color: color)
        self.moves=aDecoder.decodeInteger(forKey: "Moves")
    }
    func encode(with coder: NSCoder) {
        coder.encode(row, forKey: "Row")
        coder.encode(col, forKey: "Col")
        coder.encode(w, forKey: "W")
        coder.encode(h, forKey: "H")
        coder.encode(position, forKey: "TilePosition")
        coder.encode(color, forKey: "TileColorEnum")
        coder.encode(moves, forKey: "Moves")
      }
    func copy()->Tile{
        return Tile.init(copy: self)
    }
    func copyPosition(of tile:Tile){
        self.position=tile.position
    }
    func switchPosition(with tile:Tile){
        if(!animating){
            let ph=tile.position
            tile.position=self.position
            self.position=ph
            
        }
    }
    func updatePosition(animated:Bool,_ duration:Double){
        if(moves != 0){
            self.moveLabel.text="\(moves)"
            self.moveShadow.text="\(moves)"
        }else{
            self.moveLabel.text="X"
            self.moveShadow.text="X"
        }
        if selected{
            node.lineWidth=5
            node.strokeColor=UIColor.white
        }else if moves<=5{
            node.lineWidth=5
            node.strokeColor=UIColor.red
            self.moveLabel.color=UIColor.red
        }else{
            node.lineWidth=3
            node.strokeColor=UIColor.black
        }
        
        if animated{
            animating=true
            let action=SKAction.move(to: position, duration: duration)
            if(moves>5){
                self.node.zPosition=2
            }
            self.node.run(action,completion: {self.animating=false;if self.moves>5{self.node.zPosition=0}})
            
        }else{
            self.node.position=self.position
        }
    }
    func updatePositionWithSound(_ duration:Double){
        if(moves != 0){
            self.moveLabel.text="\(moves)"
            self.moveShadow.text="\(moves)"
        }else{
            self.moveLabel.text="X"
            self.moveShadow.text="X"
        }
        if selected{
            node.lineWidth=5
            node.strokeColor=UIColor.white
        }else if moves<=5{
            node.lineWidth=5
            node.strokeColor=UIColor.red
            self.moveLabel.color=UIColor.red
        }else{
            node.lineWidth=3
            node.strokeColor=UIColor.black
        }
        let generator = UISelectionFeedbackGenerator()
        
        animating=true
        let action=SKAction.move(to: position, duration: duration)
        if(moves>5){
            self.node.zPosition=2
        }
        self.node.run(action,completion: {self.animating=false;if self.moves>5{self.node.zPosition=0};generator.selectionChanged();AudioServicesPlaySystemSound (1306)})
    }
    func getColor()->UIColor{
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
enum TileColor:CaseIterable,Codable{
    case red
    case blue
    case purple
    case green
    case yellow
    case orange
    case pink
    case brown
    case magenta
}
