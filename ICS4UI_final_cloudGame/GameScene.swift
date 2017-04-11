//
//  GameScene.swift
//  ICS4UI_final_cloudGame
//
//  Created by Student on 2017-03-23.
//  Copyright © 2017 Alex T. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var landBackground:SKTileMapNode!
    var waterTileMap:SKTileMapNode!
    
    
    // touch location
    var targetLocation: CGPoint = .zero
    
    
    override func didMove(to view: SKView) {
        loadSceneNodes()
        
        setupWater()
    }
    
    func loadSceneNodes() {
        guard let landBackground = childNode(withName: "landBackground")
            as? SKTileMapNode else {
                fatalError("Background node not loaded")
        }
        self.landBackground = landBackground
    }
    
    func setupWater() {
        let columns = 32
        let rows = 24
        let size = CGSize(width: 64, height: 64)
        
        // 1
        guard let tileSet = SKTileSet(named: "Water Tile") else {
            fatalError("Water Tile Set not found")
        }
        
        // 2
        waterTileMap = SKTileMapNode(tileSet: tileSet,
                                       columns: columns,
                                       rows: rows,
                                       tileSize: size)
        
        // 3
        addChild(waterTileMap)
        
        // 4
        let tileGroups = tileSet.tileGroups
        
        // 5
        guard let waterTile = tileGroups.first(where: {$0.name == "Water"}) else {
            fatalError("No Water tile definition found")
        }
        
        // 6
        let waterSources = 10
        
        // 7
        for _ in 1...waterSources {
            
            // 8
            let column = Int(arc4random_uniform(UInt32(columns)))
            let row = Int(arc4random_uniform(UInt32(rows)))
            
            // 9
            let tile = waterTile
            
            // 10
            waterTileMap.setTileGroup(tile, forColumn: column, row: row)
        }
    }
}
