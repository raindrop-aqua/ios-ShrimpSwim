//
//  GameScene.swift
//  ios-ShrimpSwim
//
//  Created by Masahiro Atsumi on 2019/03/24.
//  Copyright © 2019年 Masahiro Atsumi. All rights reserved.
//
import Foundation
import SpriteKit

class GameScene: SKScene {

    struct Constants {
        // Player画像
        static let PlayerImages = ["shrimp01", "shrimp02", "shrimp03", "shrimp04"]
    }
    
    /// 衝突の判定に使うBitMask
    struct ColliderType {
        static let Player: UInt32 = (1 << 0)
        static let World: UInt32  = (1 << 1)
        static let Coral: UInt32  = (1 << 2)
        static let Score: UInt32  = (1 << 3)
        static let None: UInt32   = (1 << 4)
    }
    // すべてのノードを格納するルートノード
    var baseNode: SKNode!
    // サンゴを格納するノード
    var coralNode: SKNode!
    // プレイヤーノード
    var player: SKSpriteNode!
    // スコア関連
    var scoreLabelNode: SKLabelNode!
    var score: UInt32!
    
    override func didMove(to view: SKView) {
        // スコア初期化
        score = 0
        
        // 物理シミュレーションON
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: -2.0)
        // 親ノードを作成
        baseNode = SKNode()
        baseNode.speed = 1.0
        self.addChild(baseNode)
        
        coralNode = SKNode()
        baseNode.addChild(coralNode)
        
        self.setupBackground()
        self.setupBackgroundRock()
        self.setupCeilingAndLand()
        self.setupPlayer()
        self.setupCoral()
        self.setupScoreLabel()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            player.physicsBody?.velocity = CGVector.zero
            player.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: 23.0))
        }
    
    }
    
    override func update(_ currentTime: TimeInterval) {
    }
    
    private func setupBackground() {
        // 背景画像の読み込み
        let texture = SKTexture(imageNamed: "background")
        texture.filteringMode = .nearest
        // 必要枚数の算出
        let needNumber = 2.0 + (self.frame.size.width / texture.size().width)
        // アニメーションを作成
        let moveAnim = SKAction.moveBy(x: -texture.size().width, y: 0.0, duration: TimeInterval(texture.size().width / 10.0))
        let resetAnim = SKAction.moveBy(x: texture.size().width, y: 0.0, duration: 0.0)
        let repeatForeverAnim = SKAction.repeatForever(SKAction.sequence([moveAnim, resetAnim]))
        
        for i in 0...Int(needNumber) {
            let sprite = SKSpriteNode(texture: texture)
            sprite.zPosition = -100.0
            sprite.position = CGPoint(x: CGFloat(i) * sprite.size.width, y: self.frame.size.height / 2.0)
            sprite.run(repeatForeverAnim)
            baseNode.addChild(sprite)
        }
    }
    
    private func setupBackgroundRock() {
        // 岩山画像の取り込み
        let under = SKTexture(imageNamed: "rock_under")
        under.filteringMode = .nearest
        // 必要枚数の算出
        var needNumber = 2.0 + (self.frame.size.width / under.size().width)
        // アニメーションを作成
        let moveUnderAnim = SKAction.moveBy(x: -under.size().width, y: 0.0, duration: TimeInterval(under.size().width / 20.0))
        let resetUnderAnim = SKAction.moveBy(x: under.size().width, y: 0.0, duration: 0.0)
        let repeatForeverUnderAnim = SKAction.repeatForever(SKAction.sequence([moveUnderAnim, resetUnderAnim]))
        
        for i in 0...Int(needNumber) {
            let sprite = SKSpriteNode(texture: under)
            sprite.zPosition = -50.0
            sprite.position = CGPoint(x: CGFloat(i) * sprite.size.width, y: sprite.size.height / 2.0)
            sprite.run(repeatForeverUnderAnim)
            baseNode.addChild(sprite)
        }

        // 岩山画像の取り込み
        let above = SKTexture(imageNamed: "rock_above")
        above.filteringMode = .nearest
        // 必要枚数の算出
        needNumber = 2.0 + (self.frame.size.width / above.size().width)
        // アニメーションを作成
        let moveAboveAnim = SKAction.moveBy(x: -above.size().width, y: 0.0, duration: TimeInterval(above.size().width / 20.0))
        let resetAboveAnim = SKAction.moveBy(x: above.size().width, y: 0.0, duration: 0.0)
        let repeatForeverAboveAnim = SKAction.repeatForever(SKAction.sequence([moveAboveAnim, resetAboveAnim]))
        
        for i in 0...Int(needNumber) {
            let sprite = SKSpriteNode(texture: above)
            sprite.zPosition = -50.0
            sprite.position = CGPoint(x: CGFloat(i) * sprite.size.width, y: self.frame.size.height - (sprite.size.height / 2.0))
            sprite.run(repeatForeverAboveAnim)
            baseNode.addChild(sprite)
        }
    }
    
    private func setupCeilingAndLand() {
        // 地面画像の読み込み
        let land = SKTexture(imageNamed: "land")
        land.filteringMode = .nearest
        // 必要枚数の算出
        var needNumber = 2.0 + (self.frame.size.width / land.size().width)
        // アニメーションを作成
        let moveLandAnim = SKAction.moveBy(x: -land.size().width, y: 0.0, duration: TimeInterval(land.size().width / 20.0))
        let resetLandAnim = SKAction.moveBy(x: land.size().width, y: 0.0, duration: 0.0)
        let repeatForeverLandAnim = SKAction.repeatForever(SKAction.sequence([moveLandAnim, resetLandAnim]))

        for i in 0...Int(needNumber) {
            let sprite = SKSpriteNode(texture: land)
            sprite.position = CGPoint(x: CGFloat(i) * sprite.size.width, y: sprite.size.height / 2.0)
            // 画像に物理シミュレーションを設定
            sprite.physicsBody = SKPhysicsBody(texture: land, size: land.size())
            sprite.physicsBody?.isDynamic = false
            sprite.physicsBody?.categoryBitMask = ColliderType.World
            sprite.run(repeatForeverLandAnim)
            baseNode.addChild(sprite)
        }

        // 地面画像の読み込み
        let ceiling = SKTexture(imageNamed: "ceiling")
        ceiling.filteringMode = .nearest
        // 必要枚数の算出
        needNumber = 2.0 + (self.frame.size.width / ceiling.size().width)
        // アニメーションを作成
        for i in 0...Int(needNumber) {
            let sprite = SKSpriteNode(texture: ceiling)
            sprite.position = CGPoint(x: CGFloat(i) * sprite.size.width, y: self.frame.size.height - sprite.size.height / 2.0)
            // 画像に物理シミュレーションを設定
            sprite.physicsBody = SKPhysicsBody(texture: ceiling, size: ceiling.size())
            sprite.physicsBody?.isDynamic = false
            sprite.physicsBody?.categoryBitMask = ColliderType.World
            sprite.run(repeatForeverLandAnim)
            baseNode.addChild(sprite)
        }
    }

    private func setupPlayer() {
        var playerTexture = [SKTexture]()
        
        for imageName in Constants.PlayerImages {
            let texture = SKTexture(imageNamed: imageName)
            texture.filteringMode = .linear
            playerTexture.append(texture)
        }
        
        let playerAnimation = SKAction.animate(with: playerTexture, timePerFrame: 0.2)
        let loopAnimation = SKAction.repeatForever(playerAnimation)

        player = SKSpriteNode(texture: playerTexture[0])
        player.position = CGPoint(x: self.frame.size.width * 0.35, y: self.frame.size.height * 0.6)
        player.run(loopAnimation)
        
        // 物理シミュレーションを設定
        player.physicsBody = SKPhysicsBody(texture: playerTexture[0], size: playerTexture[0].size())
        player.physicsBody?.isDynamic = true
        player.physicsBody?.allowsRotation = false
        
        // 自分自身にPlayerカテゴリを設定
        player.physicsBody?.categoryBitMask = ColliderType.Player
        // 衝突相手にWorldとCoralカテゴリを設定
        player.physicsBody?.collisionBitMask = ColliderType.World | ColliderType.Coral
        player.physicsBody?.contactTestBitMask = ColliderType.World | ColliderType.Coral

        self.addChild(player)
    }
    
    private func setupCoral() {
        let coralUnder = SKTexture(imageNamed: "coral_under")
        coralUnder.filteringMode = .linear
        let coralAbove = SKTexture(imageNamed: "coral_above")
        coralAbove.filteringMode = .linear

        // 移動するよ距離を算出
        let distanceToMove = CGFloat(self.frame.size.width + 2.0 * coralUnder.size().width)
        
        // アニメーションの作成
        let moveAnim = SKAction.moveBy(x: -distanceToMove, y: 0.0, duration: TimeInterval(distanceToMove / 100.0))
        let removeAnim = SKAction.removeFromParent()
        let coralAnim = SKAction.sequence([moveAnim, removeAnim])
        
        // サンゴを生成するメソッドを呼び出すアニメーションを作成
        let newCoralAnim = SKAction.run({
            // サンゴに関するノードを乗せるノードを作成
            let coral = SKNode()
            coral.position = CGPoint(x: self.frame.size.width + coralUnder.size().width * 2, y: 0.0)
            // 地面から伸びるサンゴのY座標を算出
            let height = UInt32(self.frame.size.height / 12)
            let y = CGFloat(arc4random_uniform(height * 2) + height)
            // 地面から伸びるサンゴの作成
            let under = SKSpriteNode(texture: coralUnder)
            under.position = CGPoint(x: 0.0, y: y)
            // サンゴに物理シミュレーションを設定
            under.physicsBody = SKPhysicsBody(texture: coralUnder, size: under.size)
            under.physicsBody?.isDynamic = false
            under.physicsBody?.categoryBitMask = ColliderType.Coral
            under.physicsBody?.contactTestBitMask = ColliderType.Player
            coral.addChild(under)

            // 地面から伸びるサンゴの作成
            let above = SKSpriteNode(texture: coralAbove)
            above.position = CGPoint(x: 0.0, y: y + (under.size.height / 2.0) + 160.0 + (above.size.height / 2.0))
            // サンゴに物理シミュレーションを設定
            above.physicsBody = SKPhysicsBody(texture: coralAbove, size: above.size)
            above.physicsBody?.isDynamic = false
            above.physicsBody?.categoryBitMask = ColliderType.Coral
            above.physicsBody?.contactTestBitMask = ColliderType.Player
            coral.addChild(above)

            let scoreNode = SKNode()
            scoreNode.position = CGPoint(x: (above.size.width / 2.0) + 5.0, y: self.frame.height / 2.0)
            // サンゴに物理シミュレーションを設定
            scoreNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 10.0, height: self.frame.size.height))
            scoreNode.physicsBody?.isDynamic = false
            scoreNode.physicsBody?.categoryBitMask = ColliderType.Score
            scoreNode.physicsBody?.contactTestBitMask = ColliderType.Player
            coral.addChild(scoreNode)

            coral.run(coralAnim)
            self.coralNode.addChild(coral)
        })
        let delayAnim = SKAction.wait(forDuration: 2.5)
        let repeatForeverAnim = SKAction.repeatForever(SKAction.sequence([newCoralAnim, delayAnim]))
        
        self.run(repeatForeverAnim)
    }
    
    private func setupScoreLabel() {
        scoreLabelNode = SKLabelNode(fontNamed: "Arial Bold")
        scoreLabelNode.fontColor = UIColor.black
        scoreLabelNode.position = CGPoint(x: self.frame.size.width / 2.0, y: self.frame.size.height * 0.9)
        scoreLabelNode.zPosition = 100.0
        scoreLabelNode.text = String(score)
        
        self.addChild(scoreLabelNode)
    }
}
