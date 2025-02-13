import Foundation

struct Tile: Identifiable, Equatable {
    let id = UUID()
    let frontImage: String
    let backImage: String
    var isVisible: Bool
    var isSelected: Bool
    var isMatched: Bool
    var position: Position
    
    struct Position: Equatable {
        var x: Int
        var y: Int
        var z: Int
        
        
        func isAccessible(in tiles: [Tile]) -> Bool {
            
            let hasTileAbove = tiles.contains { tile in
                tile.position.x == x &&
                tile.position.y == y &&
                tile.position.z == z + 1
            }
            
            let hasLeftTile = tiles.contains { tile in
                tile.position.x == x - 1 &&
                tile.position.y == y &&
                tile.position.z == z &&
                !tile.isMatched
            }
            
            let hasRightTile = tiles.contains { tile in
                tile.position.x == x + 1 &&
                tile.position.y == y &&
                tile.position.z == z &&
                !tile.isMatched
            }
            
            return !hasTileAbove && (!hasLeftTile || !hasRightTile)
        }
    }
    
    static func == (lhs: Tile, rhs: Tile) -> Bool {
        return lhs.id == rhs.id
    }
}
