//
//  GameViewController.swift
//  TileGame macOS
//
//  Created by Bruno Pastre on 08/07/22.
//

import Cocoa
import SpriteKit
import GameplayKit

class GameViewController: NSViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let skView = self.view as! SKView
        assert(skView.frame.size != .zero)
        let scene = GameScene.make(withSize: skView.frame.size)
        
        skView.ignoresSiblingOrder = true
        skView.showsFPS = true
        skView.showsNodeCount = true
        
        skView.presentScene(scene)
    }
}

