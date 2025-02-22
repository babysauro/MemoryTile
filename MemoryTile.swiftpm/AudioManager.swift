import AVFoundation

@MainActor
class AudioManager {
    static let shared = AudioManager()
    
    private var backgroundMusicPlayer: AVAudioPlayer?
    private var soundEffectPlayer: AVAudioPlayer?
    
    private init() {}
    
    func playBackgroundMusic(named fileName: String) {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "mp3") else {
            print("File audio non trovato: \(fileName).mp3")
            return
        }
        
        do {
            backgroundMusicPlayer = try AVAudioPlayer(contentsOf: url)
            backgroundMusicPlayer?.numberOfLoops = -1
            backgroundMusicPlayer?.volume = 0.2
            backgroundMusicPlayer?.play()
        } catch {
            print("Errore nel caricamento della musica: \(error.localizedDescription)")
        }
    }
    
    
    func stopBackgroundMusic() {
        backgroundMusicPlayer?.stop()
    }
    
    
    func playSoundEffect(named fileName: String) {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "mp3") else {
            print("File audio non trovato: \(fileName).mp3")
            return
        }
        
        do {
            soundEffectPlayer = try AVAudioPlayer(contentsOf: url)
            soundEffectPlayer?.volume = 0.5
            soundEffectPlayer?.play()
        } catch {
            print("Errore nel caricamento dell'effetto sonoro: \(error.localizedDescription)")
        }
    }
}

