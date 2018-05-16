//
//  IntroScene.swift
//  Rock Pools
//
//  Created by Andrew Robert Gabb on 30/3/18.
//  Copyright © 2018 Andrew Robert Gabb. All rights reserved.
//


import Foundation
import SpriteKit

class IntroScene: SKScene {
    
    override init(size: CGSize) {
        
        super.init(size: size)
        // 1
        backgroundColor = SKColor.init(red: 136/255, green: 255/255, blue: 255/253, alpha: 1.0)
        
        //Title
        let title = SKLabelNode(fontNamed: "Futura-CondensedExtraBold")
        title.text = "ROCK POOLS"
        title.fontSize = size.width * 0.15
        title.fontColor = SKColor.black
        title.position = CGPoint(x: size.width * 0.5, y: size.height * 0.55)
        addChild(title)
        
        //Arrow
        let arrow = SKSpriteNode(imageNamed: "Arrow")
        arrow.position = CGPoint(x: size.width * 0.5, y: size.height * 0.3)
        arrow.isUserInteractionEnabled = false
        arrow.name = "arrow"
        arrow.setScale((self.size.width/arrow.size.width)*0.15)
        addChild(arrow)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let node : SKNode = self.atPoint(location)
            if node.name == "arrow" {
                presentGameScene()
            }
        }
    }
    
    func presentGameScene(){
        let scene = GameScene(size: size)
        self.view?.presentScene(scene)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


