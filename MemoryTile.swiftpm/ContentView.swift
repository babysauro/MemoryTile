import SwiftUI
import SpriteKit

struct ContentView: View {
    @StateObject private var tileData = TileData()
    @State private var showGameOver = false
    
    var scene: SKScene {
        let scene = GameScene()
        scene.size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        scene.scaleMode = .resizeFill
        scene.tileData = tileData
        return scene
    }
    
    var body: some View {
        ZStack {
            SpriteView(scene: scene)
                .ignoresSafeArea()
            
            VStack {
                Text("Memory Tile")
                    .font(.largeTitle)
                    .foregroundColor(.black)
                    .padding()
                
                Text("Score: \(tileData.score)")
                    .font(.title)
                    .foregroundColor(.black)
                    .padding()
                
                Spacer()
            }
        }
        .onAppear {
            tileData.generateTiles()
        }
        .alert("Game Complete!", isPresented: $showGameOver) {
            Button("Play Again") {
                tileData.generateTiles()
            }
        } message: {
            Text("Final Score: \(tileData.score)")
        }
        .onChange(of: tileData.tiles) { _ in
            if tileData.isGameComplete() {
                showGameOver = true
            }
        }
    }
}
