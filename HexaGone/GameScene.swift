//
//  GameScene.swift
//  HexaGone
//
//  Created by Jan Geselle on 27.05.15.
//  Copyright (c) 2015 Jan Geselle. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var sprites = [SKShapeNode]()
    
    var lastIndex = 0
    
    var hexGrid:HexGrid? = nil
    
    var background:SKShapeNode? = nil
    
    var lastUpdateTimeInterval:CFTimeInterval? = nil
    
    var spawnCounter = CGFloat(0)
    
    var patternHeight = CGFloat(0)
    var patternWidth = CGFloat(0)
    
    var viewController: GameViewController!
    
    var alive = true
    
    var score = CGFloat(0)
    
    var deathHex:SKShapeNode!
    
    var scoreLabel:SKLabelNode!
    
    var gameOver:SKLabelNode!
    
    var sprite:SKSpriteNode!
    
    var scale:CGFloat!
    
    override func didMove(to view: SKView) {
        /* Setup your scene here */
        let colorIndex = randRange(0, upper: 5)
        background = SKShapeNode(rect: self.frame)
        background?.lineWidth = CGFloat(0)
        background?.fillColor = getColorByIndex(colorIndex, type: "bg")
        self.addChild(background!)
        hexGrid = HexGrid(sceneFrame: self.frame)
        hexGrid!.scene = self
        
        hexGrid!.createPattern();
        
        sprite = SKSpriteNode(imageNamed:"HexGrid")
        scale = self.size.width / sprite.size.width
        
        patternHeight = scale * sprite.size.height
        patternWidth = 2 * patternHeight / sqrt(3)
        
        for sprite in hexGrid!.sprites {
            self.addChild(sprite)
        }
        
        scoreLabel = SKLabelNode(fontNamed:"Helvetica Neue Thin")
        scoreLabel.text = String(Int(score))
        scoreLabel.color = SKColor(red: 1, green: 1, blue: 1, alpha: 1)
        scoreLabel.fontSize = 24
        scoreLabel.position = CGPoint(x: self.frame.maxX - 20, y: self.frame.maxY - 17)
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.verticalAlignmentMode = .top
        scoreLabel.zPosition = 10
        self.addChild(scoreLabel)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /* Called when a touch begins */
        
        for touch in (touches) {
            if alive {
                let location = touch.location(in: self)
                
                for shape in sprites {
                    if shape.contains(location) {
                        if colorIsDeadly(shape.fillColor) {
                            die(shape)
                        } else {
                            shape.position.y -= self.frame.height
                        }
                        background?.fillColor = getColorByHexColor(shape.fillColor)
                    }
                }
                
                //spawnHex()
            }
        }
    }
    
    func spawnHex () {
        let pathRect = CGRect(x: 0, y: 0, width: 346.41016, height: 300)
        let path = roundedPolygonPathWithRect(pathRect, lineWidth: 2.0, sides: 6, cornerRadius: 0.0).cgPath
        let shape = SKShapeNode(path: path, centered: true)
        
        let hexX = randRange(0, upper: 4)
        
        let fullGridHeight = (floor(self.size.height / patternHeight) + 1) * patternHeight
        
        var spawnY = fullGridHeight + hexGrid!.offset + patternHeight + (patternHeight / 2)
        
        let spawnX = ((self.size.width - (patternWidth * 4)) / 2) + (patternWidth / 2) + (CGFloat(hexX) * 0.75 * patternWidth)
        
        if hexX % 2 != 0 {
            spawnY += patternHeight / 2
        }
        
        let colorIndex = randRange(0, upper: 5)
        
        shape.isAntialiased = true
        shape.xScale = scale + 0.025
        shape.yScale = scale + 0.025
        shape.position = CGPoint(x: spawnX, y: spawnY)
        //sprite.position = CGPoint(x: CGFloat(0), y: CGFloat(patternHeight * CGFloat(lastIndex)))
        shape.zRotation = 0
        shape.lineWidth = CGFloat(0)
        shape.fillColor = getColorByIndex(colorIndex, type: "hex")
        lastIndex += 1
        
        self.addChild(shape)
        sprites += [shape]
    }
    
    func getColorByIndex (_ index: Int, type: String) -> SKColor {
        let colorIndex = CGFloat(index)
        if type == "hex" {
            return SKColor(hue: colorIndex * 60/360, saturation: 85/100, brightness: 57/100, alpha: 1)
        } else {
            return SKColor(hue: colorIndex * 60/360, saturation: 64/100, brightness: 30/100, alpha: 1)
        }
    }
    
    func getIndexByColor (_ color: SKColor) -> Int {
        var h = CGFloat(0)
        var s = CGFloat(0)
        var l = CGFloat(0)
        var a = CGFloat(0)
        
        color.getHue(&h, saturation: &s, brightness: &l, alpha: &a)
        return Int(h * 360 / 60)
    }
    
    func getColorByHexColor (_ hexColor: SKColor) -> SKColor {
        let index = getIndexByColor(hexColor)
        let color = getColorByIndex(index, type: "bg")
        return color
    }
    
    func colorIsDeadly (_ color: SKColor) -> Bool {
        let index = getIndexByColor(color)
        let bgIndex = getIndexByColor(background!.fillColor)
        return index == bgIndex
    }
    
    func die (_ hex: SKShapeNode) {
        alive = false
        deathHex = hex
        
        hexGrid!.speed = CGFloat(4)
        
        let width = self.frame.width
        let height = CGFloat(100)
        let x = CGFloat(0)
        let y = self.frame.midY - CGFloat(height / 2)
        
        let gameOverRect = CGRect(x: x, y: y, width: width, height: height)
        
        let gameOverBg = SKShapeNode(rect: gameOverRect)
        
        gameOverBg.lineWidth = CGFloat(0)
        gameOverBg.fillColor = SKColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        self.addChild(gameOverBg)
        
        gameOver = SKLabelNode(fontNamed:"Helvetica Neue UltraLight")
        gameOver.text = "Game Over"
        gameOver.color = SKColor(red: 1, green: 1, blue: 1, alpha: 1)
        gameOver.fontSize = 48
        gameOver.position = CGPoint(x:self.frame.midX, y:self.frame.midY - 14)
        gameOver.zPosition = 10
        self.addChild(gameOver)
    }
    
    func deathAnimUpdate (_ movement: CGFloat) {
        let mod = movement / 50
        deathHex!.xScale += mod
        deathHex!.yScale += mod
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        if deathHex!.xScale > 5 && Int(score) > appDelegate.highscore {
            gameOver.text = "New Highscore"
        }
        
        if deathHex!.xScale > 10 {
            
            if Int(score) > appDelegate.highscore {
                appDelegate.highscore = Int(score)
                
                let userDefaults = UserDefaults.standard
                userDefaults.setValue(score, forKey: "highscore")
                userDefaults.synchronize()
            }
            
            viewController.toMenu()
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
        if lastUpdateTimeInterval == nil {
            lastUpdateTimeInterval = currentTime
        }
        let timeSinceLast = currentTime - lastUpdateTimeInterval!
        lastUpdateTimeInterval = currentTime
        
        let movement = CGFloat(timeSinceLast*60) * hexGrid!.speed * (patternHeight / 75)
        
        hexGrid!.update(movement)
        
        if alive {
            
            for shape in self.sprites {
                shape.position.y -= movement
                if shape.position.y < self.patternHeight / -2 {
                    shape.removeFromParent()
                }
                if shape.position.y < self.patternHeight / 2 && shape.position.y + movement > self.patternHeight / 2 {
                    if !colorIsDeadly(shape.fillColor) {
                        die(shape)
                    }
                }
            }
            sprites = sprites.filter({$0.position.y > self.patternHeight / -2})
            spawnCounter += CGFloat(timeSinceLast*60) * hexGrid!.speed
            if spawnCounter > 90 {
                spawnCounter = 0
                spawnHex()
            }
            
            if score < 2000 {
                hexGrid!.speed = (score / 4000) + CGFloat(3)
            } else if score < 4000 {
                hexGrid!.speed = (2000/4000) + ((score - 2000) / 6000) + CGFloat(3)
            } else {
                hexGrid!.speed = (2000/4000) + (2000/6000) + ((score - 4000) / 8000) + CGFloat(3)
            }
            
            score += CGFloat(timeSinceLast * 60)
            
            let nf = NumberFormatter()
            nf.groupingSeparator = ","
            nf.numberStyle = NumberFormatter.Style.decimal
            let highscoreString = nf.string(from: NSNumber(value: Int(score)))!
    
            scoreLabel.text = highscoreString
        } else {
            deathAnimUpdate(movement)
        }
    }
    
    func randRange (_ lower: Int , upper: Int) -> Int {
        return lower + Int(arc4random_uniform(UInt32(upper - lower + 1)))
    }

    func roundedPolygonPathWithRect(_ square: CGRect, lineWidth: Float, sides: Int, cornerRadius: Float) -> UIBezierPath {
        let path = UIBezierPath()
        
        let theta = Float(2.0 * M_PI) / Float(sides)
        let offset = cornerRadius * tanf(theta / 2.0)
        let squareWidth = Float(min(square.size.width, square.size.height))
        
        var length = squareWidth - lineWidth
        
        if sides % 4 != 0 {
            length = length * cosf(theta / 2.0) + offset / 2.0
        }
        
        let sideLength = length * tanf(theta / 2.0)
        
        let pointX = CGFloat((squareWidth / 2.0) + (sideLength / 2.0) - offset)
        let pointY = CGFloat(squareWidth - (squareWidth - length) / 2.0)
        
        var point = CGPoint(x: pointX, y: pointY)
        var angle = Float(M_PI)
        path.move(to: point)
        
        for _ in 0 ..< sides {
            
            let x = Float(point.x) + (sideLength - offset * 2.0) * cosf(angle)
            let y = Float(point.y) + (sideLength - offset * 2.0) * sinf(angle)
            
            point = CGPoint(x: CGFloat(x), y: CGFloat(y))
            path.addLine(to: point)
            
            let centerX = Float(point.x) + cornerRadius * cosf(angle + Float(M_PI_2))
            let centerY = Float(point.y) + cornerRadius * sinf(angle + Float(M_PI_2))
            
            let center = CGPoint(x: CGFloat(centerX), y: CGFloat(centerY))
            
            let startAngle = CGFloat(angle) - CGFloat(M_PI_2)
            let endAngle = CGFloat(angle) + CGFloat(theta) - CGFloat(M_PI_2)
            
            path.addArc(withCenter: center, radius: CGFloat(cornerRadius), startAngle: startAngle, endAngle: endAngle, clockwise: true)
            
            point = path.currentPoint
            angle += theta
        }
        
        path.close()
        
        return path
    }
}
