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

    
    var waterTileMap:SKTileMapNode!
    var landBackground:SKTileMapNode!
    
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
        let columns = 24
        let rows = 24
        let size = CGSize(width: 32, height: 32)
        
        guard let tileSet = SKTileSet(named: "Water Tile") else {
            fatalError("Water Tile not found")
        }
        
        waterTileMap = SKTileMapNode(tileSet: tileSet,
                                       columns: columns,
                                       rows: rows,
                                       tileSize: size)
        
        addChild(waterTileMap)
        
        let waterSource = tileSet.tileGroups
        
        guard let waterTile = waterSource.first(where: {$0.name == "Water"}) else {
            fatalError("No Water tile definition found")
        }
        
        let sourcesOfWater = 7
        
        for _ in 1...sourcesOfWater {
            
            let column = Int(arc4random_uniform(UInt32(columns)))
            let row = Int(arc4random_uniform(UInt32(rows)))
            
            let groundTile = waterTileMap.tileDefinition(atColumn: column, row: row)
            
            let tile = groundTile == nil ? waterTile : waterTile
            
            waterTileMap.setTileGroup(tile, forColumn: column, row: row)
        }

    }

    
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
