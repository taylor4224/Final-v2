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
    var scoreboard:SKLabelNode!
    
    class cloud {
        let cloudNode = SKSpriteNode(imageNamed: "bg_cloud8")
        var positionX:CGFloat = 0.0
        var positionY:CGFloat = 0.0
        var water:Int = 0
        var user = false
    }
    
    let player = cloud()
    
    var lastX:CGFloat = 0
    var lastY:CGFloat = 0
    
    var waterTiles: [String: [Int]] = [:]
    
    
    override func didMove(to view: SKView) {
        player.user = true
        
        cloudPlacement(ex: CGFloat(1056), why: CGFloat(800))
        
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
        myLabel.zPosition = CGFloat(1.0)
        cam.addChild(myLabel)
        
        scoreboard = SKLabelNode(fontNamed: "Arial")
        scoreboard.text = "you have \(player.water) unit of water"
        scoreboard.fontSize = 30
        scoreboard.fontColor = SKColor.black
        scoreboard.zPosition = 1
        scoreboard.position = CGPoint(x: 608 ,y:1504)
        scoreboard.horizontalAlignmentMode = .left
        self.addChild(scoreboard)
        
        waterScore()
        
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
        let columns = 66
        let rows = 50
        let size = CGSize(width: 64, height: 64)
        let rate = [1,2,4,7,11,18,28,40,50,65,80,100]
        var orderRate = 0
        
        guard let tileSet = SKTileSet(named: "Water Tile") else {
            fatalError("Water Tile Set not found")
        }
        
        waterTileMap = SKTileMapNode(tileSet: tileSet, columns: columns, rows: rows, tileSize: size)
        addChild(waterTileMap)
        
        let tileGroups = tileSet.tileGroups
        guard let waterTile = tileGroups.first(where: {$0.name == "Water"}) else {
            fatalError("No Water tile definition found")
        }
        
        let waterSources = 12
        
        for index in 1...waterSources {
            
            var column = Int(arc4random_uniform(UInt32(columns)))
            var row = Int(arc4random_uniform(UInt32(rows)))
            
            while column < 33 {
                column = Int(arc4random_uniform(UInt32(columns)))
            }
            while row < 25 {
                row = Int(arc4random_uniform(UInt32(rows)))
            }
            
            waterTileMap.setTileGroup(waterTile, forColumn: column, row: row)
            
            column = column - 33
            row = row - 25
            
            waterTiles["\(index)"] = [column, row, rate[orderRate]]
            orderRate+=1
        }
        for (tile, location) in waterTiles {
            print("The location of tile \(tile) is (\(location[0]),\(location[1])) with a collection rate of \(location[2])")
        }
    }
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        myLabel.text = "you are here"
        
        let zero:CGFloat = 0.0
        let twenty:CGFloat = 24.0
        let thirty:CGFloat = 32.0
        
        let firstTouch = touches.first
        let location = (firstTouch?.location(in: self))!
        
        // taking raw coordinate position, and turning it into a location of a tile
        var locX = location.x/64
        var locY = location.y/64
        var posX:CGFloat = 32
        var posY:CGFloat = 32
        var scoreX:CGFloat = 32
        var scoreY:CGFloat = 32
        
        locX = locX - locX.truncatingRemainder(dividingBy: 1)
        locY = locY - locY.truncatingRemainder(dividingBy: 1)
        
        if locX < zero {
            locX = zero
        }
        if locX > thirty {
            locX = thirty
        }
        if locY < zero {
            locY = zero
        }
        if locY > twenty {
            locY = twenty
        }

        
        posX += 64*locX
        posY += 64*locY
        scoreX = posX - 448
        scoreY = posY + 704
        
        cam.position = CGPoint(x: posX, y: posY)
        scoreboard.position = CGPoint(x: scoreX, y: scoreY)
        print("X: \(locX)")
        print("Y: \(locY)")
        
        
        // if the camera is over top a water tile, then display that the player is over top a water tile
        for (_, location) in waterTiles {
            if Int(locX) == location[0] && Int(locY) == location[1]{
                    myLabel.text = "you are on a water tile"
            }
        }
        // if the player clicks the same tile twice, then move the cloud to that tile
        if locX == lastX && locY == lastY {
            cloudPlacement(ex: posX, why: posY)
        }
        lastX = locX
        lastY = locY
    }
    
    
    // removing previous cloud, and placing a new one on the tile that was double clicked, or the middle on game start up
    func cloudPlacement(ex:CGFloat, why:CGFloat) {
        let a = (ex - 32)/64
        let b = (why - 32)/64
        
        player.cloudNode.removeFromParent()
        self.addChild(player.cloudNode)
        player.cloudNode.position = CGPoint(x: ex, y: why)
        player.positionX = a
        player.positionY = b
        print(player.positionX)
        print(player.positionY)
        
    }
    
    // increases the scoreboard when the cloud is on a water tile
    func waterScore() {
        let wait = SKAction.wait(forDuration:2.5)
        let action = SKAction.run {
            for (_, location) in self.waterTiles {
                if self.player.positionX == CGFloat(location[0]) && self.player.positionY == CGFloat(location[1]) {
                    self.player.water += location[2]
                    self.scoreboard.text = "You currently have \(self.player.water) units of water"
                }
            }
        }
        let recursive = SKAction.run {
            self.waterScore()
        }
        run(SKAction.sequence([wait,action,recursive]))
    }

}




/*
 few ideas:
 
 - make camera movement an skaction so that it moves across the screen instead of teleporting
 done: add label to top of screen showing the player the amount of water they currenty have, and make that an action that increases every second if the player is on a water tile
 - thought: move cloud up a tile, while having a shadow on the tile you are on. dunno if i can get semi-transparent images but if not, make it small enough that you can see the tile it's on
*/





