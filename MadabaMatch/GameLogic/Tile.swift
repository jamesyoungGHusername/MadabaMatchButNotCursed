//
//  Tile.swift
//  MadabaMatch
//
//  Created by James Young on 12/5/21.
//

import Foundation
import SpriteKit
class Tile{
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
        self.moves=20 //Int.random(in: 0...5)
        self.node.fillColor=getColor()
        self.moveLabel.verticalAlignmentMode = .center
        if(moves != 0){
            self.moveLabel.text="\(moves)"
        }else{
            self.moveLabel.text=""
        }
        
        self.moveLabel.fontColor=UIColor.black
        self.moveLabel.fontSize=20
        self.moveLabel.fontName="AvenirNext-Bold"
        node.addChild(moveLabel)
    }
    convenience init(copy:Tile) {
        self.init(row: copy.row, col: copy.col, w: copy.w, h: copy.h, position: copy.position, node: copy.node, color: copy.color)
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

        if selected{
            node.lineWidth=5
            node.strokeColor=UIColor.white
        }else{
            node.lineWidth=3
            node.strokeColor=UIColor.black
        }
        if finalGrouped{
            node.lineWidth=5
            node.strokeColor=UIColor.blue
        }
        if animated{
            animating=true
            let action=SKAction.move(to: position, duration: duration)
            self.node.zPosition=2
            self.node.run(action,completion: {self.animating=false;self.node.zPosition=0})
            
        }else{
            self.node.position=self.position
        }
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
enum TileColor:CaseIterable{
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
