//
//  Board.swift
//  MadabaMatch
//
//  Created by James Young on 12/5/21.
//

import Foundation
import SpriteKit
class Board{
    var tiles:[[Tile]]
    var r:Int
    var c:Int
    var w:Double
    var h:Double
    var sn:SKShapeNode
    var tileSelected:Bool=false
    var selectedTile:Tile?
    var tf:TileFactory?
    var gs:GameScene
    var totalMoves=0
    init(w:Double,h:Double,r:Int,c:Int,gs:GameScene){
        self.w=w
        self.h=h
        self.r=r
        self.c=c
        self.sn=SKShapeNode(rectOf: CGSize(width: w, height: h))
        self.tiles=Array(repeating:[Tile](), count: r)
        self.gs=gs
    }
    func populate(){
        self.tf=TileFactory(for:self)
        for i in 0..<r{
            for j in 0..<c{
                tiles[i].append(tf!.getRandomTileFor(r: i, c: j))
                tiles[i][j].updatePosition(animated: false, 0)
            }
        }
        print(tiles)
    }
    
    func touchDown(touch:UITouch){
        if !tileSelected{
            for r in tiles{
                for t in r{
                    if t.node.contains(touch.location(in: gs)){
                        t.selected=true
                        t.node.zPosition=3
                        selectedTile=t
                        tileSelected=true
                        let drag=SKAction.move(to: touch.location(in: gs), duration: 0)
                        selectedTile!.node.run(drag)
                    }
                }
            }
        }
    }
    func touchMoved(touch:UITouch){
        if tileSelected{
            let drag=SKAction.move(to: touch.location(in: gs), duration: 0)
            selectedTile!.node.run(drag)
            
            for r in tiles{
                for t in r{
                    if t.node.contains(touch.location(in: gs)) && !t.selected{
                        if !t.animating{
                            switchIndices(r1: t.row, c1: t.col, r2: selectedTile!.row, c2: selectedTile!.col)
                            t.switchPosition(with: selectedTile!)
                            t.updatePosition(animated: true, 0.1)
                            selectedTile!.timesMoved+=1
                            totalMoves+=1
                        }
                    }
                }
            }
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
    
    func touchUp(touch:UITouch){
        if tileSelected{
            selectedTile?.selected=false
            selectedTile?.node.zPosition=0
            tileSelected=false
            selectedTile=nil
            for r in tiles{
                for t in r{
                    t.updatePosition(animated: true, 0.1)
                    
                }
            }
            advanceTurn()
        }
    }
    func advanceTurn(){
        highlightGroups()
        calculateScore()
        removeGroups()
        repopulateBoard()
        highlightGroups()
        if(!groups.isEmpty){
            advanceTurn()
        }
    }
    var score:Int=0
    var maxCombo:Int=0
    var groups:[[Tile]]=[[]]
    var group:[Tile]=[]
    func highlightGroups(){
        for r in tiles{
            for t in r{
                //t.updatePosition(animated: true, 0.1)
                if !t.grouped{
                    floodFill(rPos: t.row, cPos: t.col, target: t.color)
                    //print(group.count)
                    if(group.count>=4){
                        let g=group
                        groups.append(g)
                    }
                    group.removeAll()
                }
            }
        }
        for r in tiles{
            for t in r{
                t.grouped=false
            }
        }
        for g in groups{
            for t in g{
                t.finalGrouped=true
                t.updatePosition(animated: false, 0)
            }
        }
        
    }
    func calculateScore(){
        var turnScore=0
        var groupScore=0
        for g in groups{
            groupScore=(g.count-3)*g.count
            if turnScore==0{
                turnScore=groupScore
            }else{
                turnScore+=turnScore*groupScore
            }
        }
        if turnScore>maxCombo{
            maxCombo=turnScore
        }
        score+=turnScore
    }
    func removeGroups(){
        for g in groups{
            for t in g{
                t.node.removeFromParent()
            }
        }
        for r in tiles{
            for t in r{
                    if(emptyBelow(r: t.row, c: t.col)){
                        //print("the \(tiles[t.row][t.col].color) at \(t.row),\(t.col) can move")
                        moveDown(tile: t, move: 0)
                        
                    }else{
                        //print("the \(tiles[t.row][t.col].color) at \(t.row),\(t.col) can NOT move")
                    }
            }
        }
        
    }
    func moveDown(tile:Tile,move:Int){
        
        if(emptyBelow(r: tile.row, c: tile.col)){
            //print("switching position with empty at \(tile.row-1),\(tile.col)")
            //print("old position is \(tiles[tile.row][tile.col].position)")
            //print("target position is \(tiles[tile.row-1][tile.col].position)")
            tile.animating=false
            tile.switchPosition(with: tiles[tile.row-1][tile.col])
            //print("new position is \(tiles[tile.row][tile.col].position)")
            switchIndices(r1: tile.row, c1: tile.col, r2: tile.row-1, c2: tile.col)
            tile.node.zPosition=3
            tile.updatePosition(animated: true, 0.2)
            
            //print("tile moved to \(tile.row),\(tile.col)")
            if(emptyBelow(r: tile.row, c: tile.col)){
                moveDown(tile: tile,move: move+1)
            }
            
        }
        
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
    func repopulateBoard(){
        for g in groups{
            for t in g{
                tiles[t.row][t.col]=(tf!.getRandomTileFor(r: t.row, c: t.col))
                let shrink=SKAction.scale(by: 0.1, duration: 0)
                tiles[t.row][t.col].node.run(shrink)
                tiles[t.row][t.col].updatePosition(animated: false, 0)
                tiles[t.row][t.col].node.zPosition = -1
                let grow=SKAction.scale(by: 10, duration: 0.5)
                gs.addChild(tiles[t.row][t.col].node)
                tiles[t.row][t.col].node.run(grow)
            }
        }
        groups.removeAll()
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
}
