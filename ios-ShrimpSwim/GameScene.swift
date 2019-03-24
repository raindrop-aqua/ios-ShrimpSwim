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
    
    var baseNode: SKNode!
    var coralNode: SKNode!

    override func didMove(to view: SKView) {
        baseNode = SKNode()
        baseNode.speed = 1.0
        self.addChild(baseNode)
        
        coralNode = SKNode()
        baseNode.addChild(coralNode)
        
        self.setupBackground()
        self.setupBackgroundRock()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func update(_ currentTime: TimeInterval) {
    }
    
    func setupBackground() {
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
    
    func setupBackgroundRock() {
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
}
