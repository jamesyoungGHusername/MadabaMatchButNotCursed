//
//  TileFactory.swift
//  MadabaMatch
//
//  Created by James Young on 12/5/21.
//

import Foundation
import SpriteKit
class TileFactory:NSObject{
    var tileWidth:Double
    var tileHeight:Double
    var board:Board
    var colorsPresent:Int?
    var upperHealth:Int
    var lowerHealth:Int
    let tileTextureAtlas=SKTextureAtlas(named: "TilePatterns.atlas")
    let defaults=UserDefaults.standard
    init(for board:Board,_ colorsPresent:Int?,upperHealth:Int,lowerHealth:Int){
        self.board=board
        print("board will have \(board.c) columns")
        print("board will have \(board.r) rows")
        print("board is \(board.w) wide")
        print("board is \(board.h) tall")
        print(board.w/Double(board.c))
        print(board.h/Double(board.r))
        tileWidth=board.w/Double(board.c)
        tileHeight=board.h/Double(board.r)
        self.colorsPresent=colorsPresent
        self.upperHealth=upperHealth
        self.lowerHealth=lowerHealth
    }
    func getRandomTileFor(r:Int,c:Int)->Tile{
        let node=SKShapeNode(rectOf: CGSize(width: tileWidth, height: tileHeight))
        return Tile.init(row: r, col: c, w: tileWidth-2, h: tileHeight-2, position: getBoardPositionFrom(r: r, c: c), node: node, color: getRandomColor())
    }
    func getRandomSurvivalTileFor(r:Int,c:Int)->Tile{
        let node=SKShapeNode(rectOf: CGSize(width: tileWidth, height: tileHeight))
        let tile=Tile.init(row: r, col: c, w: tileWidth-2, h: tileHeight-2, position: getBoardPositionFrom(r: r, c: c), node: node, color: getRandomColor())
        tile.moves=Int.random(in: lowerHealth...upperHealth)
        
        if(defaults.bool(forKey: "CBMode")){
            switch tile.color {
            case .red:
                tile.node.fillColor = UIColor.systemRed
                let redTexture:SKTexture
                redTexture=tileTextureAtlas.textureNamed("redTile")
                tile.node.addChild(SKSpriteNode(texture: redTexture,size: CGSize(width: tile.w, height: tile.h)))
            case .blue:
                tile.node.fillColor=UIColor.systemBlue
                let blueTexture:SKTexture
                blueTexture=tileTextureAtlas.textureNamed("darkBlueTile")
                tile.node.addChild(SKSpriteNode(texture: blueTexture,size: CGSize(width: tile.w, height: tile.h)))
            case .purple:
                tile.node.fillColor=UIColor.systemPurple
                let purpleTexture:SKTexture
                purpleTexture=tileTextureAtlas.textureNamed("purpleTile")
                tile.node.addChild(SKSpriteNode(texture: purpleTexture,size: CGSize(width: tile.w, height: tile.h)))
            case .green:
                tile.node.fillColor=UIColor.systemGreen
                let greenTexture:SKTexture
                greenTexture=tileTextureAtlas.textureNamed("darkGreenTexture")
                tile.node.addChild(SKSpriteNode(texture: greenTexture,size: CGSize(width: tile.w, height: tile.h)))
            case .yellow:
                tile.node.fillColor=UIColor.systemYellow
                let yellowTexture:SKTexture
                yellowTexture=tileTextureAtlas.textureNamed("yellowTile")
                tile.node.addChild(SKSpriteNode(texture: yellowTexture,size: CGSize(width: tile.w, height: tile.h)))
            case .orange:
                tile.node.fillColor=UIColor.systemOrange
                let redTexture:SKTexture
                redTexture=tileTextureAtlas.textureNamed("orangeTile")
                tile.node.addChild(SKSpriteNode(texture: redTexture,size: CGSize(width: tile.w, height: tile.h)))
            case .pink:
                tile.node.fillColor=UIColor.systemTeal
                let blueTexture:SKTexture
                blueTexture=tileTextureAtlas.textureNamed("tealTile")
                tile.node.addChild(SKSpriteNode(texture: blueTexture,size: CGSize(width: tile.w, height: tile.h)))
            case .brown:
                tile.node.fillColor=UIColor.green
                let greenTexture:SKTexture
                greenTexture=tileTextureAtlas.textureNamed("lightGreenTile")
                tile.node.addChild(SKSpriteNode(texture: greenTexture,size: CGSize(width: tile.w, height: tile.h)))
            case .magenta:
                tile.node.fillColor=UIColor.magenta
                let purpleTexture:SKTexture
                purpleTexture=tileTextureAtlas.textureNamed("magentaTile")
                tile.node.addChild(SKSpriteNode(texture: purpleTexture,size: CGSize(width: tile.w, height: tile.h)))
            }
        }else{
            switch tile.color {
            case .red:
                tile.node.fillColor = UIColor.systemRed
                
            case .blue:
                tile.node.fillColor=UIColor.systemBlue
                
            case .purple:
                tile.node.fillColor=UIColor.systemPurple
                
            case .green:
                tile.node.fillColor=UIColor.systemGreen
               
            case .yellow:
                tile.node.fillColor=UIColor.systemYellow
                
            case .orange:
                tile.node.fillColor=UIColor.systemOrange
                
            case .pink:
                tile.node.fillColor=UIColor.systemTeal
               
            case .brown:
                tile.node.fillColor=UIColor.green
                
            case .magenta:
                tile.node.fillColor=UIColor.magenta
                
            }
        }
        return tile
    }
    func getBoardPositionFrom(r:Int,c:Int)->CGPoint{
        return CGPoint(x: -board.w/2+tileWidth*Double(c)+tileWidth/2,y:-board.h/2+tileHeight*Double(r)+tileHeight/2)
    }
    func getRandomColor()->TileColor{
        return TileColor.allCases.randomElement()!
    }
    func getRandomColorSubset()->TileColor{
        var arr:[TileColor]=[]
        
        for i in 0..<colorsPresent!{
            arr.append(TileColor.allCases[i])
        }
        return arr.randomElement()!
    }
}
