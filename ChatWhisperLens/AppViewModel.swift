
import SwiftUI

enum AppView: String {
    case home
    case analyze
    case history
}

enum AnalysisOption: String {
    case responseAdvice = "response-advice"
    case toneAnalysis = "tone-analysis"
    case hiddenIntentions = "hidden-intentions"
    case relationshipDynamics = "relationship-dynamics"
}

struct CapturedImage: Identifiable, Equatable {
    let id: String
    let imageData: Data
    var order: Int
    
    static func == (lhs: CapturedImage, rhs: CapturedImage) -> Bool {
        return lhs.id == rhs.id
    }
}

struct Analysis: Identifiable {
    let id: String
    let selectedOption: AnalysisOption
    let images: [CapturedImage]
    let timestamp: Date
    let advice: String
    let tone: ToneType
}

enum ToneType: String {
    case friendly
    case flirty
    case professional
    case ambiguous
    case toxic
    case manipulative
}

class AppViewModel: ObservableObject {
    @Published var onboarded: Bool = false
    @Published var currentView: AppView = .home
    @Published var capturedImages: [CapturedImage] = []
    @Published var selectedAnalysisOption: AnalysisOption = .responseAdvice
    @Published var userComment: String = ""
    @Published var analyses: [Analysis] = []
    
    func setOnboarded(_ value: Bool) {
        withAnimation {
            self.onboarded = value
        }
    }
    
    func setCurrentView(_ view: AppView) {
        withAnimation {
            self.currentView = view
        }
    }
    
    func addCapturedImage(_ imageData: Data) {
        let newImage = CapturedImage(
            id: UUID().uuidString,
            imageData: imageData,
            order: capturedImages.count
        )
        
        withAnimation {
            capturedImages.append(newImage)
        }
    }
    
    func removeCapturedImage(id: String) {
        withAnimation {
            capturedImages.removeAll(where: { $0.id == id })
            
            // Reorder remaining images
            for (index, _) in capturedImages.enumerated() {
                capturedImages[index].order = index
            }
        }
    }
    
    func updateImageOrder(id: String, newIndex: Int) {
        guard let currentIndex = capturedImages.firstIndex(where: { $0.id == id }),
              newIndex >= 0 && newIndex < capturedImages.count else {
            return
        }
        
        let movedItem = capturedImages.remove(at: currentIndex)
        capturedImages.insert(movedItem, at: newIndex)
        
        // Update order of all images
        for (index, _) in capturedImages.enumerated() {
            capturedImages[index].order = index
        }
    }
    
    func setSelectedAnalysisOption(_ option: AnalysisOption) {
        self.selectedAnalysisOption = option
    }
    
    func setUserComment(_ comment: String) {
        self.userComment = comment
    }
    
    func addAnalysis(advice: String, tone: ToneType) {
        let newAnalysis = Analysis(
            id: UUID().uuidString,
            selectedOption: selectedAnalysisOption,
            images: capturedImages,
            timestamp: Date(),
            advice: advice,
            tone: tone
        )
        
        analyses.append(newAnalysis)
    }
}
