//
//  MenuScene.swift
//  Rock Pools
//
//  Created by Andrew Robert Gabb on 24/2/18.
//  Copyright © 2018 Andrew Robert Gabb. All rights reserved.
//

import Foundation
import SpriteKit

class MenuScene: SKScene {
    let userDefaults = UserDefaults.standard
    
    init(size: CGSize, score: Int) {
        
        super.init(size: size)
        // 1
        backgroundColor = SKColor.init(red: 136/255, green: 255/255, blue: 255/253, alpha: 1.0)

        //scorelabel
        let scorelabel = SKLabelNode(fontNamed: "Futura-Medium")
        scorelabel.text = "Score: \(score)"
        scorelabel.fontSize = size.height * 0.15
        scorelabel.fontColor = SKColor.black
        scorelabel.position = CGPoint(x: size.width * 0.5, y: size.height * 0.75)
        addChild(scorelabel)
        
        //highScorelabel
        let highscorelabel = SKLabelNode(fontNamed: "Futura-Medium")
        let highscore = userDefaults.integer(forKey: "Highscore")
        highscorelabel.text = "Highscore: \(highscore)"
        highscorelabel.fontSize = size.height * 0.15
        highscorelabel.fontColor = SKColor.black
        highscorelabel.position = CGPoint(x: size.width * 0.5, y: size.height * 0.55)
        addChild(highscorelabel)
        
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

