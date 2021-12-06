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
    var timesMoved=0
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
        self.node.fillColor=getColor()
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
            self.node.run(action,completion: {self.animating=false})
            
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
            return UIColor.systemPink
        case .brown:
            return UIColor.systemBrown
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
