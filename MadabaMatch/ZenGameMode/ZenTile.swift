//
//  ZenTile.swift
//  Madaba
//
//  Created by James Young on 12/14/21.
//

import Foundation
import SpriteKit
import AudioToolbox
class ZenTile{
    var row:Int
    var col:Int
    var node:SKShapeNode
    var w:Double
    var h:Double
    var position:CGPoint
    var color:TileColor
    var selected=false
    var animating=false
    var grouped=false
    var finalGrouped=false
    var placeable=true
    init(row:Int,col:Int,w:Double,h:Double,position:CGPoint,node:SKShapeNode,color:TileColor){
        
        self.row=row
        self.col=col
        self.w=w
        self.h=h
        self.position=position
        self.node=node
        self.node.position=self.position
        self.color=color
        switch color {
        case .red:
            self.node.fillColor = UIColor.systemRed
        case .blue:
            self.node.fillColor=UIColor.systemBlue
        case .purple:
            self.node.fillColor=UIColor.systemPurple
        case .green:
            self.node.fillColor=UIColor.systemGreen
        case .yellow:
            self.node.fillColor=UIColor.systemYellow
        case .orange:
            self.node.fillColor=UIColor.systemOrange
        case .pink:
            self.node.fillColor=UIColor.systemTeal
        case .brown:
            self.node.fillColor=UIColor.green
        case .magenta:
            self.node.fillColor=UIColor.magenta
        }
        
  
    }
    convenience init(copy:ZenTile) {
        self.init(row: copy.row, col: copy.col, w: copy.w, h: copy.h, position: copy.position, node: copy.node, color: copy.color)
    }
   
    func copy()->ZenTile{
        return ZenTile.init(copy: self)
    }
    func copyPosition(of tile:ZenTile){
        self.position=tile.position
    }
    func switchPosition(with tile:ZenTile){
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
        }else {
            node.lineWidth=3
            node.strokeColor=UIColor.black
        }
        
        if animated{
            animating=true
            let action=SKAction.move(to: position, duration: duration)
            
            self.node.run(action,completion: {self.animating=false})
            
        }else{
            self.node.position=self.position
        }
    }
    func updatePositionWithSound(_ duration:Double){
        
        if selected{
            node.lineWidth=5
            node.strokeColor=UIColor.white
        }else{
            node.lineWidth=3
            node.strokeColor=UIColor.black
        }
        let generator = UISelectionFeedbackGenerator()
        
        animating=true
        let action=SKAction.move(to: position, duration: duration)
        self.node.run(action,completion: {self.animating=false;generator.selectionChanged();AudioServicesPlaySystemSound (1306)})
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
