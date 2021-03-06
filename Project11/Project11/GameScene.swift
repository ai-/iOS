//
//  GameScene.swift
//  Project11
//
//  Created by Amar Idrizovic on 27/07/15.
//  Copyright (c) 2015 Amar Idrizovic. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var scoreLabel: SKLabelNode!
    
    var score: Int = 0 {
        didSet {
            if (score == 5) {
                removeAllChildren()
                removeAllActions()
                self.scene?.view?.presentScene(GameScene(size: self.size))
            }
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var editLabel: SKLabelNode!
    var newLabel: SKLabelNode!
    
    var editingMode: Bool = false {
        didSet {
            if editingMode {
                editLabel.text = "Done"
            } else {
                editLabel.text = "Edit"
            }
        }
    }
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        let background = SKSpriteNode(imageNamed: "background.jpg")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .Replace
        background.zPosition = -1
        addChild(background)
        physicsBody = SKPhysicsBody(edgeLoopFromRect: frame)
        physicsWorld.contactDelegate = self
        var broj = Int(arc4random_uniform(4))
        makeSlotAt(CGPoint(x: 128, y: 0), isGood: broj == 0)
        makeSlotAt(CGPoint(x: 384, y: 0), isGood: broj == 1)
        makeSlotAt(CGPoint(x: 640, y: 0), isGood: broj == 2)
        makeSlotAt(CGPoint(x: 896, y:0), isGood: broj == 3)
        makeBouncerAt(CGPoint(x: 0, y: 0))
        makeBouncerAt(CGPoint(x: 256, y: 0))
        makeBouncerAt(CGPoint(x: 512, y: 0))
        makeBouncerAt(CGPoint(x: 768, y: 0))
        makeBouncerAt(CGPoint(x: 1024, y: 0))
        
        for index in 1...10 {
        let size = CGSize(width: RandomInt(min: 128, max: 256), height: 16)
        let box = SKSpriteNode(color: RandomColor(), size: size)
        box.zRotation = RandomCGFloat(min: -1, max: 1)
        box.position = CGPoint(x: RandomCGFloat(min: 64, max: 980), y: RandomCGFloat(min: 256, max: 640))
        
        box.physicsBody = SKPhysicsBody(rectangleOfSize: box.size)
        box.physicsBody!.dynamic = false
        
        addChild(box)
            }
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .Right
        scoreLabel.position = CGPoint(x: 980, y: 700)
        addChild(scoreLabel)
        editLabel = SKLabelNode(fontNamed: "Chalkduster")
        editLabel.text = "Edit"
        editLabel.position = CGPoint(x: 200, y: 700)
        addChild(editLabel)
        newLabel = SKLabelNode(fontNamed: "Chalkduster")
        newLabel.text = "New"
        newLabel.position = CGPoint(x: 80, y: 700)
        addChild(newLabel)
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */
        if let touch = touches.first as? UITouch {
            let location = touch.locationInNode(self)
            let objects = nodesAtPoint(location) as! [SKNode]
            if contains(objects, editLabel) {
                editingMode = !editingMode
            } else if contains(objects, newLabel) {
                removeAllChildren()
                removeAllActions()
                self.scene?.view?.presentScene(GameScene(size: self.size))
            } else {
                if editingMode {
                    let size = CGSize(width: RandomInt(min: 128, max: 256), height: 16)
                    let box = SKSpriteNode(color: RandomColor(), size: size)
                    box.zRotation = RandomCGFloat(min: -1, max: 1)
                    box.position = location
                    
                    box.physicsBody = SKPhysicsBody(rectangleOfSize: box.size)
                    box.physicsBody!.dynamic = false
                    
                    addChild(box)
                } else {
                    let ball = SKSpriteNode(imageNamed: "ballRed")
                    
                    ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2.0)
                    ball.physicsBody!.contactTestBitMask = ball.physicsBody!.collisionBitMask
                    ball.physicsBody!.restitution = 0.7
                    ball.position = CGPoint(x: location.x, y: 768)
                    ball.name = "ball"
                    addChild(ball)
                }
            }
        }
        
    }
    
    func makeBouncerAt(position: CGPoint) {
        let bouncer = SKSpriteNode(imageNamed: "bouncer")
        bouncer.position = position
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width / 2.0)
        bouncer.physicsBody!.contactTestBitMask = bouncer.physicsBody!.collisionBitMask
        bouncer.physicsBody!.dynamic = false
        addChild(bouncer)
    }
    
    func makeSlotAt(position: CGPoint, isGood: Bool) {
        var slotBase: SKSpriteNode
        var slotGlow: SKSpriteNode
        
        if isGood {
            slotBase = SKSpriteNode(imageNamed: "slotBaseGood")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowGood")
            slotBase.name = "good"
        } else {
            slotBase = SKSpriteNode(imageNamed: "slotBaseBad")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowBad")
            slotBase.name = "bad"
        }
        
        slotBase.position = position
        slotGlow.position = position
        
        let spin = SKAction.rotateByAngle(CGFloat(M_PI_2), duration: 6)
        let spinForever = SKAction.repeatActionForever(spin)
        slotGlow.runAction(spinForever)
        
        slotBase.physicsBody = SKPhysicsBody(rectangleOfSize: slotBase.size)
        slotBase.physicsBody!.dynamic = false
        
        addChild(slotBase)
        addChild(slotGlow)
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    func collisionBetweenBall(ball: SKNode, object: SKNode) {
        if object.name == "good" {
            destroyBall(ball)
            ++score
        } else if object.name == "bad" {
            destroyBall(ball)
            --score
        }
    }
    
    func destroyBall(ball: SKNode) {
        if let myParticlePath = NSBundle.mainBundle().pathForResource("FireParticles", ofType: "sks") {
            let fireParticles = NSKeyedUnarchiver.unarchiveObjectWithFile(myParticlePath) as! SKEmitterNode
            fireParticles.position = ball.position
            addChild(fireParticles)
        }
        
        ball.removeFromParent()
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        if contact.bodyA.node!.name == "ball" {
            collisionBetweenBall(contact.bodyA.node!, object: contact.bodyB.node!)
        } else if contact.bodyB.node!.name == "ball" {
            collisionBetweenBall(contact.bodyB.node!, object: contact.bodyA.node!)
        }
    }
}
