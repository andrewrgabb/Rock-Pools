import SpriteKit
import UIKit

//Physics world
struct PhysicsCategory {
    static let None      : UInt32 = 0
    static let All       : UInt32 = UInt32.max
    static let Rock      : UInt32 = 0b1       // 1
    static let Fish      : UInt32 = 0b10      // 2
    static let Ocean      : UInt32 = 0b100      //3
    static let Fishbed      : UInt32 = 0b1000   //4
    static let ScoreLine    : UInt32 = 0b10000   //5
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let userDefaults = UserDefaults.standard
    
    // Universal Variables
    var fishjumpcount = 0
    var rockx = 0.0
    var rockwidth = CGFloat(0.25)
    var timemod = 1.0
    var score = 0
    var currentHighScore = UserDefaults.standard.integer(forKey: "Highscore")

    var GameBegun = false
    var GameEnded = false
    var fishbedheight = CGFloat(0)
    
    let scorelabel = SKLabelNode(fontNamed: "Futura-Medium")
    let beginlabel = SKLabelNode(fontNamed: "Futura-Medium")
    
    let rockbrown = SKColor.init(red: 130/255, green: 67/255, blue: 3/255, alpha: 1.0)
    
    let fish = SKSpriteNode(imageNamed: "Gabbles")
    let ocean = SKSpriteNode(color: SKColor.init(red: 0/255, green: 0/255, blue: 205/255, alpha: 0.8),
                             size: CGSize(width: 1, height: 1))
    
    let rockbed = SKSpriteNode(color: SKColor.init(red: 130/255, green: 67/255, blue: 3/255, alpha: 1.0),
                               size: CGSize(width: 1, height: 1))
    let fishbed = SKSpriteNode(color: SKColor.init(white: 0, alpha: 0),
                               size: CGSize(width: 1, height: 1))
    
    let scoreLine = SKSpriteNode(color: SKColor.init(white: 0, alpha: 0.0),
                                 size: CGSize(width: 1, height: 1))
    
    override func didMove(to view: SKView) {
        
        backgroundColor = SKColor.init(red: 136/255, green: 255/255, blue: 255/253, alpha: 1.0)
        
        //Ocean
        ocean.position = CGPoint(x: size.width * 0.5, y: size.height * 0.1)
        ocean.size = CGSize(width: size.width, height: size.height * 0.2)
        //ocean Physics
        ocean.physicsBody = SKPhysicsBody(rectangleOf: ocean.size)
        ocean.physicsBody?.isDynamic = true
        ocean.physicsBody?.categoryBitMask = PhysicsCategory.Ocean
        ocean.physicsBody?.contactTestBitMask = PhysicsCategory.Fish
        ocean.physicsBody?.collisionBitMask = PhysicsCategory.None
        ocean.physicsBody?.affectedByGravity = false
        ocean.physicsBody?.linearDamping = 0.4
        addChild(ocean)
        
        //Rockbed
        rockbed.position = CGPoint(x: size.width * 0.5, y: size.height * 0.04)
        rockbed.size = CGSize(width: size.width, height: size.height * 0.08)
        rockbed.physicsBody = SKPhysicsBody(rectangleOf: rockbed.size)
        rockbed.physicsBody?.isDynamic = true
        rockbed.physicsBody?.categoryBitMask = PhysicsCategory.Fishbed
        rockbed.physicsBody?.contactTestBitMask = PhysicsCategory.None
        rockbed.physicsBody?.collisionBitMask = PhysicsCategory.None
        rockbed.physicsBody?.affectedByGravity = false
        rockbed.physicsBody?.restitution = 0.5
        addChild(rockbed)
        
        //Scoreline
        scoreLine.position = CGPoint(x: size.width * 0.23, y: size.height * 0.14)
        scoreLine.size = CGSize(width: size.width*0.02, height: size.height * 0.05)
        scoreLine.physicsBody = SKPhysicsBody(rectangleOf: scoreLine.size)
        scoreLine.physicsBody?.isDynamic = true
        scoreLine.physicsBody?.categoryBitMask = PhysicsCategory.ScoreLine
        scoreLine.physicsBody?.contactTestBitMask = PhysicsCategory.Rock
        scoreLine.physicsBody?.collisionBitMask = PhysicsCategory.None
        scoreLine.physicsBody?.affectedByGravity = false
        addChild(scoreLine)
        
        //Scorelabel
        scorelabel.text = "0"
        scorelabel.fontSize = size.height * 0.1
        scorelabel.fontColor = SKColor.black
        scorelabel.position = CGPoint(x: size.width * 0.9, y: size.height * 0.85)
        addChild(scorelabel)
        //Beginlabel
        beginlabel.text = "TAP TO SWIM"
        beginlabel.fontSize = size.width * 0.1
        beginlabel.fontColor = SKColor.black
        beginlabel.position = CGPoint(x: size.width * 0.5, y: size.height * 0.55)
        addChild(beginlabel)
        
        //Pink Fishy?
        let number = arc4random_uniform(10) + 1
        
        if number > 9{
            fish.texture = SKTexture(imageNamed: "pinkGabbles")
        }
        
        fish.position = CGPoint(x: size.width * 0.25, y: size.height * 0.14)
        
        //Scale fish to different devies
        fish.setScale((size.width/fish.size.width)*0.05)
        //Fish physics
        fish.physicsBody = SKPhysicsBody(texture: fish.texture!,
                                         size: CGSize(width: fish.size.width,
                                                      height: fish.size.height))
        fish.physicsBody?.isDynamic = true
        fish.physicsBody?.categoryBitMask = PhysicsCategory.Fish
        fish.physicsBody?.contactTestBitMask = PhysicsCategory.Ocean | PhysicsCategory.Rock
        fish.physicsBody?.collisionBitMask = PhysicsCategory.Fishbed | PhysicsCategory.Rock
        fish.physicsBody?.usesPreciseCollisionDetection = true
        fish.physicsBody?.affectedByGravity = true
        fish.physicsBody?.mass = CGFloat(1.0)
        fish.physicsBody?.restitution = 0.0
        addChild(fish)
        
        fishbedheight = size.height * 0.14 - fish.size.height/2
        fishbed.position = CGPoint(x: size.width * 0.5, y: fishbedheight/2)
        fishbed.size = CGSize(width: size.width, height: fishbedheight)
        fishbed.physicsBody = SKPhysicsBody(rectangleOf: fishbed.size)
        fishbed.physicsBody?.isDynamic = true
        fishbed.physicsBody?.categoryBitMask = PhysicsCategory.Fishbed
        fishbed.physicsBody?.contactTestBitMask = PhysicsCategory.None
        fishbed.physicsBody?.collisionBitMask = PhysicsCategory.None
        fishbed.physicsBody?.affectedByGravity = false
        fishbed.physicsBody?.restitution = 0.0
        addChild(fishbed)
        
        rockwidth *= size.width
        
        //Physics
        let dyvector = -0.04*size.height
        physicsWorld.gravity = CGVector(dx: 0.0, dy: dyvector)
        physicsWorld.contactDelegate = self
        
        //Rocks!
        run(SKAction.repeatForever(
                SKAction.sequence([
                    SKAction.run(addRock),
                    SKAction.wait(forDuration: 1.0)
                    ])
        ))
        
    }
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    func addRock() {
        if GameBegun == true && GameEnded == false{
            let heightmax = UInt32(size.height * 0.28)
            let heightmin = UInt32(size.height * 0.22)
            let heightx = arc4random_uniform(heightmax - heightmin) + heightmin
            var height = CGFloat(heightx)
            if height < size.height * 0.2{
                height = size.height * 0.2
            }
            let posy = height/2

            let rock = SKSpriteNode()
            rock.size = CGSize(width: rockwidth, height: height)
            rock.color = rockbrown
            rock.position = CGPoint(x: size.width + rockwidth/2 + CGFloat(rockx), y: posy)

            //Rock Physics
            rock.physicsBody = SKPhysicsBody(rectangleOf: rock.size)
            rock.physicsBody?.isDynamic = true
            rock.physicsBody?.categoryBitMask = PhysicsCategory.Rock
            rock.physicsBody?.contactTestBitMask = PhysicsCategory.Fish
            rock.physicsBody?.collisionBitMask = PhysicsCategory.None
            rock.physicsBody?.affectedByGravity = false
            rock.physicsBody?.restitution = 0.4
            rock.name = "Rocks"

            addChild(rock)

            // Create the actions
            let actionMove = SKAction.move(to: CGPoint(x: -rockwidth/2, y: posy), duration: TimeInterval(2.0*timemod))
            let actionMoveDone = SKAction.removeFromParent()

            rock.run(SKAction.sequence([actionMove, actionMoveDone]))

            //Create new rockx and rockwidth
            let douwidth = Double(size.width)
            let room = (douwidth - (rockx+Double(rockwidth)))/2
            let maxrockx = UInt32(0.15*douwidth)
            var minrockx = UInt32(0.0)
            if 0.3*douwidth > room{
                minrockx = UInt32(0.3*douwidth - room)
            }else{
                minrockx = UInt32(0.0)
            }
            if maxrockx > minrockx{
                let rockxx = arc4random_uniform(maxrockx - minrockx) + minrockx
                rockx = Double(rockxx)
            }else{
                rockx = 0.0
            }

            let maxrockwidth = UInt32(0.35*douwidth - rockx)
            let minrockwidth = UInt32(0.2*douwidth)
            let rockwidthx = arc4random_uniform(maxrockwidth - minrockwidth) + minrockwidth
            rockwidth = CGFloat(rockwidthx)

            //Time Interval Modifier
            timemod = Double((size.width + rockwidth + CGFloat(rockx))/(size.width + rockwidth))

        }
    }
    
    func jump() {
        fishjumpcount += 1
        let velocity = size.height*2.3
        fish.physicsBody?.velocity.dy = velocity
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if GameBegun == false && GameEnded == false{
            beginlabel.removeFromParent()
        }
        GameBegun = true
        if fishjumpcount < 2 && GameEnded == false{
            jump()
        }else{
            return()
        }
    }
    

    func projectileDidCollideWithMonster(fish: SKSpriteNode, rock: SKSpriteNode) {
        fishbed.removeFromParent()
        GameEnded = true
        self.scene?.enumerateChildNodes(withName: "*Rocks*") {
            (node, stop) in
            node.removeAllActions()
        }
        score = Int(scorelabel.text!)!

        let highscore = userDefaults.integer(forKey: "Highscore")
        if score >= highscore{
            userDefaults.set(score, forKey: "Highscore")
        }
        
        run(SKAction.sequence([
            SKAction.wait(forDuration: 1.0),
            SKAction.run() {
                let scene = MenuScene(size: self.size, score: self.score)
                self.view?.presentScene(scene)
            }
            ]))
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        // 1
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        // 2
        if ((firstBody.categoryBitMask & PhysicsCategory.Rock != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.Fish != 0)) {
            if let rock = firstBody.node as? SKSpriteNode, let
                fish = secondBody.node as? SKSpriteNode {
                projectileDidCollideWithMonster(fish: fish, rock: rock)
            }
        }else if((firstBody.categoryBitMask & PhysicsCategory.Fish != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.Ocean != 0)) {
            fishjumpcount = 0
            scorelabel.text = (String(score))
            
        }else if ((firstBody.categoryBitMask & PhysicsCategory.Rock != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.ScoreLine != 0)) {
            score += 1
        }
            
    }
}

