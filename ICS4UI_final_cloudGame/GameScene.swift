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
    
    class cloud {
        var positionX:CGFloat = 0.0
        var positionY:CGFloat = 0.0
    }
    
    let player = cloud()
    
    var lastX:CGFloat = 0
    var lastY:CGFloat = 0
    
    var waterTiles: [String: [Int]] = [:]
    
    override func didMove(to view: SKView) {
        
        let size = CGSize(width: 64, height: 64)
        let cloud = SKTexture(image: #imageLiteral(resourceName: "bg_cloud8"))
        let cloudNode = SKSpriteNode(texture: cloud, size: size)
        self.addChild(cloudNode)
        cloudNode.position = CGPoint(x: 32, y: 32)
        
        // setting up camera
        cam = SKCameraNode()
        
        self.camera = cam
        self.addChild(cam)

        cam.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        
        // making label and attaching it to the camera so that it follows the camera
        myLabel = SKLabelNode(fontNamed: "Arial")
        myLabel.text = "you are here"
        myLabel.fontSize = 20
        myLabel.fontColor = SKColor.black
        cam.addChild(myLabel)
        
        
        
        
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
        let columns = 33
        let rows = 25
        let size = CGSize(width: 64, height: 64)
        
        guard let tileSet = SKTileSet(named: "Water Tile") else {
            fatalError("Water Tile Set not found")
        }
        
        waterTileMap = SKTileMapNode(tileSet: tileSet, columns: columns, rows: rows, tileSize: size)
        
        addChild(waterTileMap)
        
        let tileGroups = tileSet.tileGroups
        
        guard let waterTile = tileGroups.first(where: {$0.name == "Water"}) else {
            fatalError("No Water tile definition found")
        }
        
        let waterSources = 10
        
        for index in 1...waterSources {
            
            let column = Int(arc4random_uniform(UInt32(columns)))
            let row = Int(arc4random_uniform(UInt32(rows)))
            
            waterTileMap.setTileGroup(waterTile, forColumn: column, row: row)
            
            // columns and rows are based starting in the lower left hand corner, with the row and column next to the white line being row/ column 0
            waterTiles["\(index)"] = [column, row, columnSort(column: column), rowSort(row: row)]
            
        }
        for (tile, location) in waterTiles {
            print("The location of tile \(tile) is \(location)")
        }
    }
    
    func columnSort(column:Int ) -> Int {
            var columnPos = 42

            if column > 16 {
                columnPos = column - 16
            }
            else if column < 15 {
                columnPos = column - 15
            }
            else if column == 16 {
                columnPos = 32
            }
            else if column == 15 {
                columnPos = -32
            }
     

        return columnPos
    }
     
    func rowSort(row:Int) -> Int {
        var rowPos = 4224
     
        if row > 12 {
            rowPos = row - 12
        }
        else if row < 11 {
            rowPos = row - 11
        }
        else if row == 12 {
           rowPos = 24
        }
        else if row == 11 {
        rowPos = -24
        }
        return rowPos
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        myLabel.text = "you are here"
        
        let firstTouch = touches.first
        let location = (firstTouch?.location(in: self))!
        
        // taking raw coordinate position, and turning it into a location of a tile
        var locX = location.x/64
        var locY = location.y/64

        var posX:CGFloat = 0
        var posY:CGFloat = 0
        
        //let locX = locX.truncatingRemainder(dividingBy: 1)
        
        
        cam.position = CGPoint(x: posX, y: posY)
        print("X: \(locX)")
        print("Y: \(locY)")
        
        // checking if camera is on top of water tile
        for (_, location) in waterTiles {
            if Int(locX) == location[2] {
                if Int(locY) == location[3] {
                    myLabel.text = "you are on a water tile"
                }
                else if (locY == 0  && location[3] == 24) {
                    myLabel.text = "you are on a water tile"
                }
                else if (locY == 0  && location[3] == -24) {
                    myLabel.text = "you are on a water tile"
                }
            }
            else if (locX == 0 && location[2] == 32) {
                if Int(locY) == location[3] {
                    myLabel.text = "you are on a water tile"
                }
                else if (locY == 0 && location[3] == 24) {
                    myLabel.text = "you are on a water tile"
                }
                else if (locY == 0 && location[3] == 24) {
                    myLabel.text = "you are on a water tile"
                }

            }
        }
        /* thought: instead of having tap and hold, if the user taps the tile the camera is on more than once, move the cloud to the camera
        
        let wait = SKAction.wait(forDuration:2.0)
        let action = SKAction.run {
            //cloud.positionX = posX
            //cloud.positionY = posY
        }
        run(SKAction.sequence([wait,action]))*/
    }
    
}









