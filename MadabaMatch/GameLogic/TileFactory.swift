//
//  TileFactory.swift
//  MadabaMatch
//
//  Created by James Young on 12/5/21.
//

import Foundation
import SpriteKit
class TileFactory{
    var tileWidth:Double
    var tileHeight:Double
    var board:Board
    init(for board:Board){
        self.board=board
        print("board will have \(board.c) columns")
        print("board will have \(board.r) rows")
        print("board is \(board.w) wide")
        print("board is \(board.h) tall")
        print(board.w/Double(board.c))
        print(board.h/Double(board.r))
        tileWidth=board.w/Double(board.c)
        tileHeight=board.h/Double(board.r)
    }
    func getRandomTileFor(r:Int,c:Int)->Tile{
        let node=SKShapeNode(rectOf: CGSize(width: tileWidth, height: tileHeight))
        return Tile.init(row: r, col: c, w: tileWidth, h: tileHeight, position: getBoardPositionFrom(r: r, c: c), node: node, color: getRandomColor())
    }
    func getBoardPositionFrom(r:Int,c:Int)->CGPoint{
        return CGPoint(x: -board.w/2+tileWidth*Double(c)+tileWidth/2,y:-board.h/2+tileHeight*Double(r)+tileHeight/2)
    }
    func getRandomColor()->TileColor{
        return TileColor.allCases.randomElement()!
    }
}
