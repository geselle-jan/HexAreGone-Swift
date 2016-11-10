//
//  HexGrid.swift
//  HexaGone
//
//  Created by Jan Geselle on 28.05.15.
//  Copyright (c) 2015 Jan Geselle. All rights reserved.
//

import Foundation
import SpriteKit

class HexGrid {
    
    var rotationAngle = CGFloat(M_PI) / 120
    
    var sprites = [SKSpriteNode]()
    
    var frame:CGRect? = nil
    
    var speed = CGFloat(4)
    
    var offset = CGFloat(0)
    
    var patternHeight = CGFloat(0)
    
    var scene:GameScene!
    
    init (sceneFrame: CGRect) {
        frame = sceneFrame
    }
    
    func createPattern () {
        let pattern = SKSpriteNode(imageNamed:"HexGrid")
        
        let scale = frame!.width / pattern.size.width
        
        patternHeight = scale * pattern.size.height
        
        let patternRepeats = Int(round(frame!.height / patternHeight + 1))
        
        var i = 0
        
        while i <= patternRepeats {
            let sprite = SKSpriteNode(imageNamed:"HexGrid")
            sprite.xScale = scale
            sprite.yScale = scale
            sprite.anchorPoint = CGPoint.zero
            sprite.position = CGPoint(x: CGFloat(0), y: CGFloat(patternHeight * CGFloat(i)))
            sprites += [sprite]
            i += 1
        }

    }
    
    func update (_ movement: CGFloat) {
        if scene!.alive {
            offset -= movement
            for sprite in sprites {
                sprite.position.y -= movement
            }
            if offset < (patternHeight * -1) {
                offset += patternHeight
                for sprite in sprites {
                    sprite.position.y += patternHeight
                }
            }
        }
    }
}
