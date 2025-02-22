import Foundation

struct Tile: Identifiable, Equatable {
    let id = UUID()
    let frontImage: String
    let backImage: String
    var isVisible: Bool
    var isSelected: Bool
    var isMatched: Bool
    var position: Position
    let soundFileName: String
    
    struct Position: Equatable {
        var x: Int
        var y: Int
        var z: Int
        
        
        func isAccessible(in tiles: [Tile]) -> Bool {
            return true
        }
    }
    
    static func == (lhs: Tile, rhs: Tile) -> Bool {
        return lhs.id == rhs.id
    }
}
