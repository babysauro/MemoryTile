import SpriteKit

class GameScene: SKScene {
    
    weak var tileData: TileData?
    private var tileNodes: [UUID: SKSpriteNode] = [:]
    private var lastMatchedTiles: Set<UUID> = []
    private var resetButton: SKSpriteNode!
    
    private let tileSize = CGSize(width: 100, height: 120)
    private let tileOffset = CGPoint(x: 110, y: 130)
    private let gridSize = 6
    
    override func didMove(to view: SKView) {
        backgroundColor = UIColor(named: "AccentColor") ?? .black
        
        setupResetButton()
        
        let centerX = size.width / 2
        let centerY = size.height / 2
        setupGame(centerX: centerX, centerY: centerY)
    }
    
    private func setupResetButton() {
            resetButton = SKSpriteNode(imageNamed: "restart")
            resetButton.size = CGSize(width: 60, height: 60)
            resetButton.position = CGPoint(x: size.width / 2, y: 100)
            resetButton.zPosition = 100
            addChild(resetButton)
        }
    
    private func setupGame(centerX: CGFloat, centerY: CGFloat) {
            removeAllChildren()
            tileNodes.removeAll()
            setupResetButton()
            
            guard let tileData = tileData else { return }
            
            let gridWidth = CGFloat(gridSize - 1) * tileOffset.x
            let gridHeight = CGFloat(gridSize - 1) * tileOffset.y
            let startX = centerX - (gridWidth / 2)
            let startY = centerY - (gridHeight / 2) + tileSize.height - 100
            
            for tile in tileData.tiles {
                createTileNode(for: tile, startX: startX, startY: startY)
                
                if tile.isMatched && !lastMatchedTiles.contains(tile.id) {
                    if let node = tileNodes[tile.id] {
                        playMatchAnimation(for: node)
                        lastMatchedTiles.insert(tile.id)
                    }
                }
            }
        }
    
    private func createTileNode(for tile: Tile, startX: CGFloat, startY: CGFloat) {
        let texture = SKTexture(imageNamed: tile.isMatched ? "backImage" : tile.frontImage)
        
        if let existingNode = tileNodes[tile.id] {
            existingNode.texture = texture  // Update exsisting texture
            existingNode.alpha = tile.isMatched ? 0.5 : 1.0
            return
        }
        
        let node = SKSpriteNode(texture: texture, size: tileSize)
        let x = startX + (CGFloat(tile.position.x) * tileOffset.x)
        let y = startY + (CGFloat(tile.position.y) * tileOffset.y)
        let z = CGFloat(tile.position.z) * 0.1
        
        node.position = CGPoint(x: x, y: y)
        node.zPosition = z
        
        if tile.isSelected {
            node.color = .yellow
            node.colorBlendFactor = 0.3
        }
        
        if tile.isMatched {
            node.alpha = 0.5
        }
        
        addChild(node)
        tileNodes[tile.id] = node
    }
    
    private func playMatchAnimation(for node: SKSpriteNode) {
        let scaleUp = SKAction.scale(to: 1.2, duration: 0.2)
        let scaleDown = SKAction.scale(to: 1.0, duration: 0.2)
        let rotate = SKAction.rotate(byAngle: .pi * 2, duration: 0.4)
        let fade = SKAction.fadeAlpha(to: 0.5, duration: 0.4)
        
        let group = SKAction.group([rotate, fade])
        let sequence = SKAction.sequence([scaleUp, scaleDown, group])
        
        node.run(sequence)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        guard let tileData = tileData else { return }
        
                
                if resetButton.contains(location) {
                    tileData.generateTiles()
                    updateTileVisuals()
                    return
                }
                
                
                for tile in tileData.tiles.reversed() {
                    if let node = tileNodes[tile.id], node.contains(location) {
                        tileData.selectTile(tile)
                        updateTileVisuals()
                        break
                    }
                }
        
    }
    
    private func updateTileVisuals() {
        let centerX = size.width / 2
        let centerY = size.height / 2
        setupGame(centerX: centerX, centerY: centerY)
    }
}
