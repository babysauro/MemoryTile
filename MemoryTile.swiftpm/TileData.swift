import Foundation
import CoreGraphics

class TileData: ObservableObject {
    @Published var tiles: [Tile] = []
    @Published var selectedTiles: [Tile] = []
    @Published var score: Int = 0
    
    private let tileImages = [
        "note1", "note2", "note3", "note4", "note5",
        "note6", "note7", "violin", "piano", "guitar", "drum", "flaute"
    ]
    
    // Layout configuration
    private let layerCount = 2
    private let rowCount = 6
    private let columnCount = 6
    
    func generateTiles() {
        tiles = []
        var tempTiles: [Tile] = []
        
        // Create pairs of tiles
        for image in tileImages {
            for _ in 0...1 {
                let tile = Tile(
                    frontImage: image,
                    backImage: "backImage",
                    isVisible: true,
                    isSelected: false,
                    isMatched: false,
                    position: Tile.Position(x: 0, y: 0, z: 0)
                )
                tempTiles.append(tile)
            }
        }
        
        tempTiles.shuffle()
        assignPositions(to: &tempTiles)
        tiles = tempTiles
    }
    
    private func assignPositions(to tiles: inout [Tile]) {
        var tileIndex = 0
        
        for z in 0..<layerCount {
            for y in 0..<rowCount {
                for x in 0..<columnCount {
                    // Skip some positions to create interesting patterns
                    if shouldPlaceTile(at: x, y: y, z: z) && tileIndex < tiles.count {
                        tiles[tileIndex].position = Tile.Position(x: x, y: y, z: z)
                        tileIndex += 1
                    }
                }
            }
        }
    }
    
    private func shouldPlaceTile(at x: Int, y: Int, z: Int) -> Bool {
        // Create interesting patterns by skipping certain positions
        if z == 0 {
            return true
        } else if z == 1 {
            return x > 0 && x < columnCount - 1 && y > 0 && y < rowCount - 1
        } else if z == 2 {
            return x > 1 && x < columnCount - 2 && y > 1 && y < rowCount - 2
        }
        return false
    }
    
    func selectTile(_ tile: Tile) {
        guard tile.position.isAccessible(in: tiles) else { return }
        
        if let index = tiles.firstIndex(of: tile) {
            if selectedTiles.contains(tile) {
                // Deselect tile
                selectedTiles.removeAll { $0 == tile }
                tiles[index].isSelected = false
            } else {
                // Select tile
                if selectedTiles.count < 2 {
                    selectedTiles.append(tile)
                    tiles[index].isSelected = true
                    
                    if selectedTiles.count == 2 {
                        checkMatch()
                    }
                }
            }
        }
    }
    
    private func checkMatch() {
        guard selectedTiles.count == 2 else { return }
        
        let tile1 = selectedTiles[0]
        let tile2 = selectedTiles[1]

        // Match only based on frontImage, no position check
        if tile1.frontImage == tile2.frontImage {
            // Match found
            for tile in selectedTiles {
                if let index = tiles.firstIndex(of: tile) {
                    tiles[index].isMatched = true
                    tiles[index].isSelected = false
                }
            }
            score += 10
        } else {
            // Nessun match
            for tile in selectedTiles {
                if let index = tiles.firstIndex(of: tile) {
                    tiles[index].isSelected = false
                }
            }
        }
        selectedTiles.removeAll()
    }
    
    func isGameComplete() -> Bool {
        return tiles.allSatisfy { $0.isMatched }
    }
}
