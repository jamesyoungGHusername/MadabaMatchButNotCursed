//
//  Board.swift
//  MadabaMatch
//
//  Created by James Young on 12/5/21.
//

import Foundation
import SpriteKit
import AudioToolbox
/*
 TO DO
 IMPLEMENT BOARD CLASSES THAT ARE SPECIFIC TO DIFFERENT GAME MODES, allow parametes to be modified to change level difficulty
 
 Game currently ends before checking to see if turn is done. Calls advance turn over and over until there are no groups, but says "game over" after the first call.
 
 
 */


class Board:NSCoder{
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
    var movesRemaining=50
    var targetScore=500
    var lastTouch:UITouch?
    var turn=0
    var gameOver=false
    var ub:Int
    var lb:Int
    init(w:Double,h:Double,r:Int,c:Int,gs:GameScene,uB:Int,lB:Int){
        self.w=w
        self.h=h
        self.r=r
        self.c=c
        self.sn=SKShapeNode(rectOf: CGSize(width: w, height: h))
        self.tiles=Array(repeating:[Tile](), count: r)
        self.gs=gs
        ub=uB
        lb=lB
    }
    convenience required init?(coder aDecoder: NSCoder) {
        let w = aDecoder.decodeDouble(forKey: "bW")
        let h = aDecoder.decodeDouble(forKey: "bH")
        let r = aDecoder.decodeInteger(forKey: "bR")
        let c = aDecoder.decodeInteger(forKey: "bC")
        let uB=aDecoder.decodeInteger(forKey: "UB")
        let lB=aDecoder.decodeInteger(forKey: "LB")
        let gs=aDecoder.decodeObject(forKey: "GS") as! GameScene
        self.init(w: w, h: h, r: r, c: c, gs: gs, uB: uB, lB: lB)
    }
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encode(w, forKey: "bW")
        aCoder.encode(h, forKey: "bH")
        aCoder.encode(r, forKey: "bR")
        aCoder.encode(c, forKey: "bC")
        aCoder.encode(ub, forKey: "UB")
        aCoder.encode(lb, forKey: "LB")
        aCoder.encode(gs,forKey: "GS")
        aCoder.encode(tiles,forKey: "Tiles")
    }
    func populate(){
        self.tf=TileFactory(for:self,gs.colorsPresent,upperHealth: ub,lowerHealth: lb)
        for i in 0..<r{
            for j in 0..<c{
                tiles[i].append(tf!.getRandomSurvivalTileFor(r: i, c: j))
                tiles[i][j].updatePosition(animated: false, 0)
            }
        }
        bringRedToFront()
    }
    
    func touchDown(touch:UITouch){
        if !boardAnimating{
            lastTouch=touch
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
                            t.updatePositionWithSound(0.1)
                            moved=true
                            selectedTile!.moveLabel.text="\(selectedTile!.moves)"
                            if(selectedTile!.moves<=0){
                                selectedTile!.moveLabel.text=""
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
                                    //advanceTurn()
                                }
                            }
                            movesRemaining-=1
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
    var moved=false
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
            bringRedToFront()
        }
    }
    func bringRedToFront(){
        for tile in tiles {
            for t in tile{
                if t.moves<=5{
                    t.node.zPosition=5
                    
                }else{
                    t.node.zPosition = 2
                }
            }
        }
    }
    func wiggleRed(){
        for tile in tiles {
            for t in tile{
                if t.moves<=1{
                    t.node.run(wiggle(times: 5-t.moves))
                }
            }
        }
    }
    var boardAnimating=false
    func advanceTurn(){
        highlightGroups()
        var numGrouped=0
        for g in groups{
            numGrouped+=g.count
        }
        if(numGrouped>0){
            
            removeGroups(completionHandler:{ progress in
                if progress==numGrouped{
                    self.boardAnimating=true
                    self.shiftDown()
                    self.repopulateBoard(completionHandler:{ numDone in
                        if numDone==numGrouped{
                            self.highlightGroups()
                            if(!self.groups.isEmpty){
                                self.groups.removeAll()
                                self.bringRedToFront()
                                self.advanceTurn()
                            }else{
                                self.boardAnimating=false
                                var audioPlayed=false
                                self.combo=0
                                for g in self.tiles{
                                    for t in g{
                                        if(self.moved && t.moves>0){
                                            t.node.zPosition=0
                                            t.moves-=1
                                            t.moveLabel.text="\(t.moves)"
                                            t.moveShadow.text="\(t.moves)"
                                            if(t.moves<=0){
                                                self.gameOver=true
                                            }else if t.moves<=5{
                                                t.node.zPosition=10
                                                t.moveShadow.color=UIColor.red
                                            }
                                        }
                                    }
                                }
                                if(self.moved){
                                    self.turn+=1
                                }
                                
                                self.moved=false
                                if(self.turn==self.gs.turnGoal && !self.gameOver){
                                    self.gs.readyForNext=true
                                }
                                for g in self.tiles{
                                    for t in g{
                                        if(!audioPlayed && t.moves==1 && !self.gameOver && !self.gs.readyForNext){
                                            AudioServicesPlaySystemSound (1326)
                                            audioPlayed=true
                                        }
                                    }
                                }
                                self.wiggleRed()
                            }
                        }
                    })
                    
                }
            })
        }else{
            self.combo=0
            var audioPlayed=false
            for g in self.tiles{
                for t in g{
                    if(self.moved && t.moves>0){
                        t.node.zPosition=0
                        t.moves-=1
                        t.moveLabel.text="\(t.moves)"
                        t.moveShadow.text="\(t.moves)"
                        if(t.moves<=0){
                            self.gameOver=true
                        }else if t.moves<=5{
                            t.node.zPosition=10
                            t.moveShadow.color=UIColor.red
                            
                        }
                        
                    }
                }
            }
            if(self.moved){
                self.turn+=1
                
            }
            
            self.moved=false
            if(self.turn==self.gs.turnGoal && !self.gameOver){
                self.gs.readyForNext=true
            }
            for g in self.tiles{
                for t in g{
                    if(!audioPlayed && t.moves==1 && !self.gameOver && !self.gs.readyForNext){
                        AudioServicesPlaySystemSound (1326)
                        audioPlayed=true
                    }
                }
            }
        }
        wiggleRed()
        bringRedToFront()
        
    }
    typealias GroupsRemoved = (_ progress:Int)->Void
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
        bringRedToFront()
        
    }
    var combo:Int = -1
    func calculateScore(g:[Tile]){
        
        print("calculating score for group of \(g.count)")
        var groupScore=0
        let comboLabel=gs.getComboLabel(at: averagePosition(of: g), type: getCombo(i: combo))
        let fadeIn=SKAction.fadeIn(withDuration: 0.5)
        let fadeOut=SKAction.fadeOut(withDuration: 2)
        let shift=SKAction.move(by: CGVector(dx: 20, dy: 5), duration: 2.5)
        let wait=SKAction.wait(forDuration: 0.1)
        let sequence=SKAction.sequence([wait,fadeIn,fadeOut])
        let pointSeq=SKAction.sequence([fadeIn,fadeOut])
        gs.addChild(comboLabel)
        comboLabel.zPosition=10
        comboLabel.run(shift)
        comboLabel.run(sequence,completion:{comboLabel.removeFromParent()})
        groupScore=(g.count-3)*g.count*combo
        if combo>maxCombo{
            maxCombo=combo
        }
        let pointLabel=gs.getPointLabel(at: CGPoint(x:averagePosition(of: g).x,y: averagePosition(of: g).y-tf!.tileHeight/2), points: groupScore)
        gs.addChild(pointLabel)
        pointLabel.zPosition=10
        pointLabel.run(shift)
        pointLabel.run(pointSeq,completion:{pointLabel.removeFromParent()})
        score+=groupScore
        print("combo of \(combo)")
        
    }
    func removeGroups(completionHandler: @escaping GroupsRemoved){
        let rotate=SKAction.rotate(byAngle: 540, duration: 0.3)
        let shrink=SKAction.scale(by: 0.1, duration: 0.3)
        var count=0
        for g in groups{
            combo+=1
            self.calculateScore(g:g)
            for t in g{
                t.node.run(rotate)
                t.node.run(shrink,completion: {t.node.removeFromParent();count+=1;completionHandler(count)})
            }
        }
        
    }
    func shiftDown(){
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
        bringRedToFront()
    }
    func wiggle(times:Int)->SKAction{
        let wiggleLeft1=SKAction.rotate(byAngle: 0.1, duration: 0.1)
        let wiggleLeft2=SKAction.rotate(byAngle: 0.2, duration: 0.2)
        let wiggleRight=SKAction.rotate(byAngle: -0.2, duration: 0.2)
        let wiggleRight2=SKAction.rotate(byAngle: -0.1, duration: 0.2)
        var seq:[SKAction]=[wiggleLeft1]
        for _ in 0..<times{
            seq.append(wiggleRight)
            seq.append(wiggleLeft2)
        }
        seq.append(wiggleRight2)
        return SKAction.sequence(seq)
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
            tile.updatePositionWithSound(0.3)
            
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
    func repopulateBoard(completionHandler: @escaping GroupsRemoved){
        var count=0
        for g in groups{
            for t in g{
                tiles[t.row][t.col]=(tf!.getRandomSurvivalTileFor(r: t.row, c: t.col))
                let shrink=SKAction.scale(by: 0.1, duration: 0)
                tiles[t.row][t.col].node.run(shrink)
                tiles[t.row][t.col].updatePosition(animated: false, 0)
                tiles[t.row][t.col].node.zPosition = -1
                let grow=SKAction.scale(by: 10, duration: 0.5)
                gs.addChild(tiles[t.row][t.col].node)
                tiles[t.row][t.col].node.run(grow,completion: {count+=1;completionHandler(count)})
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
    func averagePosition(of:[Tile])->CGPoint{
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
