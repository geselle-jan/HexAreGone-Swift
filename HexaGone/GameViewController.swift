//
//  GameViewController.swift
//  HexaGone
//
//  Created by Jan Geselle on 27.05.15.
//  Copyright (c) 2015 Jan Geselle. All rights reserved.
//

import UIKit
import SpriteKit

extension SKNode {
    class func unarchiveFromFile(_ file : String) -> SKNode? {
        if let url = Bundle.main.url(forResource: file, withExtension: "sks") {
            do {
                let sceneData = try Data(contentsOf: url)
                let archiver = NSKeyedUnarchiver(forReadingWith: sceneData)
                
                archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
                let scene = archiver.decodeObject(forKey: NSKeyedArchiveRootObjectKey) as! GameScene
                archiver.finishDecoding()
                return scene
            } catch {
                return nil
            }
        } else {
            return nil
        }
    }
}

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.gameViewController = self

        if let scene = GameScene.unarchiveFromFile("GameScene") as? GameScene {
            // Configure the view.
            let skView = self.view as! SKView
            //skView.showsFPS = true
            //skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .fill
            
            scene.viewController = self
            
            scene.size = skView.bounds.size
            
            skView.presentScene(scene)
        }
    }
    
    func purgeView() {
        self.setValue(nil, forKey: "view")
    }
    
    func toMenu() {
        dismiss(animated: true, completion: purgeView)
    }

    override var shouldAutorotate : Bool {
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
        if self.view.window == nil {
            purgeView()
        }
    }

    override var prefersStatusBarHidden : Bool {
        return true
    }
}
