import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let scene = IntroScene(size: view.bounds.size)
        let skView = self.view as! SKView

        skView.ignoresSiblingOrder = true
        scene.scaleMode = .resizeFill
        skView.presentScene(scene) //Scenekit view has same dimensions as the overall view
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}

