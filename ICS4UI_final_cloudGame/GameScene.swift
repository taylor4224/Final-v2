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
    
    var cam:SKCameraNode!
    
    var myLabel:SKLabelNode!
    
    override func didMove(to view: SKView) {
        
        cam = SKCameraNode()
        // need to set the scale by default somehow :/
        
        self.camera = cam
        self.addChild(cam)

        cam.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        
        // preparing the map, making sure the forest background loaded, and that water tiles get placed
        loadSceneNodes()
        setupWater()
    }
    
    // making sure forest background loads
    func loadSceneNodes() {
        guard let landBackground = childNode(withName: "landBackground") as? SKTileMapNode else {
                fatalError("Background node not loaded")
        }
        self.landBackground = landBackground
    }
    
    // randomly placing water tiles on top of forest tiles
    func setupWater() {
        let columns = 32
        let rows = 24
        let size = CGSize(width: 64, height: 64)
        
        guard let tileSet = SKTileSet(named: "Water Tile") else {
            fatalError("Water Tile Set not found")
        }
        
        waterTileMap = SKTileMapNode(tileSet: tileSet,
                                       columns: columns,
                                       rows: rows,
                                       tileSize: size)
        
        addChild(waterTileMap)
        
        let tileGroups = tileSet.tileGroups
        
        guard let waterTile = tileGroups.first(where: {$0.name == "Water"}) else {
            fatalError("No Water tile definition found")
        }
        
        let waterSources = 10
        
        for _ in 1...waterSources {
            
            let column = Int(arc4random_uniform(UInt32(columns)))
            let row = Int(arc4random_uniform(UInt32(rows)))
            
            waterTileMap.setTileGroup(waterTile, forColumn: column, row: row)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let firstTouch = touches.first
        let location = (firstTouch?.location(in: self))!
        // taking raw x,y position and forcing the camera to only be in the middle of a tile
        var locX = location.x/64
        var locY = location.y/64
        locX = locX - locX.truncatingRemainder(dividingBy: 1.0)
        locY = locY - locY.truncatingRemainder(dividingBy: 1.0)
        if locX > 16 {
            locX = 16
        } else if locX < -16 {
            locX = -16
        }
        if locY > 12 {
            locY = 12
        } else if locY < -12 {
            locY = -12
        }
        let posX = 32+64*locX
        let posY = 32+64*locY
        
        cam.position = CGPoint(x: posX, y: posY)
    }
    
    // add function so that if the touch is held for 2 seconds, it will display the information of the tile, which as of April 24th would only be if it's a water tile or not
}









