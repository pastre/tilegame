//
//  GameScene.swift
//  TileGame Shared
//
//  Created by Bruno Pastre on 08/07/22.
//

import SpriteKit

class GameScene: SKScene {
    
    class func make(withSize size: CGSize) -> GameScene {
        let scene = GameScene(size: size)
        
        scene.scaleMode = .aspectFill
        scene.anchorPoint = .zero
        
        return scene
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}

    
