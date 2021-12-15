//
//  ZenBoard.swift
//  Madaba
//
//  Created by James Young on 12/14/21.
//

import Foundation
import SpriteKit
import AudioToolbox

class ZenBoard{
    var tiles:[[ZenTile]]
    var r:Int
    var c:Int
    var w:Double
    var h:Double
    var sn:SKShapeNode
    var tileSelected:Bool=false
    var selectedTile:ZenTile?
    var tf:ZenTileFactory?
    var gs:ZenGameScene
    var lastTouch:UITouch?
    var gameOver=false
    var moved=false
    var boardAnimating=false
    typealias GroupsRemoved = (_ progress:Int)->Void
    var score:Int=0
    var maxCombo:Int=0
    var groups:[[ZenTile]]=[[]]
    var group:[ZenTile]=[]
    var combo:Int = -1
    var groupNode:SKNode?
    var groupPlaceable=true
    var lastValidBoard:ZenBoard?
    init(w:Double,h:Double,r:Int,c:Int,gs:ZenGameScene){
        self.w=w
        self.h=h
        self.r=r
        self.c=c
        self.sn=SKShapeNode(rectOf: CGSize(width: w, height: h))
        self.tiles=Array(repeating:[ZenTile](), count: r)
        self.gs=gs
    }
    convenience init(copy:ZenBoard){
        self.init(w: copy.w, h: copy.h, r: copy.r, c: copy.c, gs: copy.gs)
        self.tiles.removeAll()
        for r in copy.tiles{
            var row:[ZenTile]=[]
            for t in r{
                row.append(t.copy())
            }
            self.tiles.append(row)
        }
    }
    func populate(){
    }
    func touchDown(touch:UITouch){
        if !boardAnimating{
            lastValidBoard=ZenBoard.init(copy: self)
            lastTouch=touch
            for r in tiles{
                for t in r{
                    if t.node.contains(touch.location(in: gs)){
                        t.selected=true
                        t.node.zPosition=3
                        selectedTile=t
                        tileSelected=true
                    }
                }
            }
            floodFill(rPos: selectedTile!.row, cPos: selectedTile!.col, target: selectedTile!.color)
            print(group)
            groupNode?.removeAllChildren()
            groupNode?.removeFromParent()
            for t in group{
                t.selected=true
                t.finalGrouped=true
                t.node.removeFromParent()
                groupNode?.addChild(t.node)
            }
            gs.addChild(groupNode!)
        }
    }
    func touchMoved(touch:UITouch){
        let drag=SKAction.move(to: touch.location(in: gs), duration: 0)
        groupNode!.run(drag)
        for st in group{
            for r in tiles{
                for t in r{
                    for i in group{
                        if t.node.contains(i.position) && !t.selected && !t.finalGrouped{
                            switchIndices(r1: t.row, c1: t.col, r2: i.row, c2: i.col)
                            t.switchPosition(with: i)
                            t.updatePositionWithSound(0.1)
                        }
                    }
                    if (t.node.contains(st.position) && !t.selected && t.finalGrouped) || (!sn.contains(st.position)){
                        groupPlaceable=false
                    }
                }
            }
        }
        if !groupPlaceable{
            for t in group{
                t.placeable=false
            }
        }
        
    }
    func touchUp(touch:UITouch){
        if(groupPlaceable){
            for t in group{
                t.grouped=false
                t.selected=false
                t.node.removeFromParent()
                gs.addChild(t.node)
            }
            group.removeAll()
            if tileSelected{
                selectedTile?.selected=false
                selectedTile?.node.zPosition=0
                tileSelected=false
                selectedTile=nil
                for r in tiles{
                    for t in r{
                        t.updatePosition(animated: true, 0.1)
                        t.selected=false
                    }
                }
            }
        }else{
            self.tiles=lastValidBoard!.tiles
        }
    }
    
    func switchIndices(r1:Int,c1:Int,r2:Int,c2:Int){
        //print("Switching tiles at index \(r1),\(c1) and \(r2),\(c2)")
        //print("the tiles in this location in memory are")
        //print("\(tiles[r1][c1].color) and \(tiles[r2][c2].color) respectively")
        let ph=tiles[r1][c1]
        tiles[r1][c1]=tiles[r2][c2]
        tiles[r2][c2]=ph
        tiles[r1][c1].row=r1
        tiles[r1][c1].col=c1
        tiles[r2][c2].row=r2
        tiles[r2][c2].col=c2
    }
    func advanceTurn(){
    
    }
    func highlightGroups(){
    }
    func calculateScore(g:[ZenTile]){
    }
    func removeGroups(completionHandler: @escaping GroupsRemoved){
    }
    func shiftDown(){
    }
    func moveDown(tile:ZenTile,move:Int){
    }
    func emptyBelow(r:Int,c:Int)->Bool{
        if(tiles[r][c].finalGrouped){
            //print("tile is being removed")
            return false
        }
        if(r-1<0){
            //print("tile checked is on the bottom of the screen")
            return false
        }
        if(!tiles[r-1][c].finalGrouped){
            //print("tile present below")
            return false
        }else{
            return true
        }
    }
    func repopulateBoard(completionHandler: @escaping GroupsRemoved){
    }
    func floodFill(rPos:Int,cPos:Int,target:TileColor){
       // print("Checking for \(target) group at \(rPos),\(cPos)")
        
        if(rPos>r-1 || cPos>c-1){
            //print("tile checked is off screen")
            return
        }
        if(rPos<0 || cPos<0){
          //  print("tile checked is off screen")
            return
        }
       // print("tile there is \(tiles[rPos][cPos].color)")
        if(tiles[rPos][cPos].color != target){
           // print("Color does not match")
            return
        }
        if(tiles[rPos][cPos].grouped){
            //print("tile checked is already grouped")
            return
        }
       // print("Color matches, adding")
        group.append(tiles[rPos][cPos])
        tiles[rPos][cPos].grouped=true
        print(group.count)
        floodFill(rPos: rPos-1, cPos: cPos, target: target)
        floodFill(rPos: rPos+1, cPos: cPos, target: target)
        floodFill(rPos: rPos, cPos: cPos-1, target: target)
        floodFill(rPos: rPos, cPos: cPos+1, target: target)
    }
    func getCombo(i:Int)->ComboID{
        if i<2{
            return ComboID.single
        }else if i==2{
            return ComboID.duo
        }else if i==3{
            return ComboID.tri
        }else if i==4{
            return ComboID.quad
        }else if i==5{
            return ComboID.penta
        }else if i==6{
            return ComboID.sexta
        }else if i==7{
            return ComboID.sept
        }else if i>7{
            return ComboID.octo
        }
        return ComboID.single
    }
    func averagePosition(of:[DashTile])->CGPoint{
        var ax=0.0
        var ay=0.0
        for t in of{
            ax+=t.position.x
            ay+=t.position.y
        }
        ax=ax/Double(of.count)
        ay=ay/Double(of.count)
        return CGPoint(x: Double(ax+Double.random(in: -30...30)), y: Double(ay+Double.random(in: -30...30)))
    }
}
