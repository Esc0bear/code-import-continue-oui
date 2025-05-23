
import SwiftUI

struct AnalysisView: View {
    @EnvironmentObject private var appViewModel: AppViewModel
    @State private var isAnalyzing = false
    @State private var analysisResult: AnalysisResult?
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                if !appViewModel.capturedImages.isEmpty {
                    ImageCarouselView()
                }
                
                AnalysisOptionsView()
                
                if let result = analysisResult {
                    resultView(result)
                } else {
                    analyzeButton
                }
            }
            .padding(.bottom, 40)
        }
        .padding(.horizontal)
    }
    
    private var analyzeButton: some View {
        Button {
            performAnalysis()
        } label: {
            Group {
                if isAnalyzing {
                    HStack {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        Text("Analyse en cours...")
                            .padding(.leading, 8)
                    }
                } else {
                    Text("Analyser les messages")
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.accentColor)
            .foregroundColor(.white)
            .cornerRadius(30)
        }
        .disabled(isAnalyzing)
    }
    
    private func resultView(_ result: AnalysisResult) -> some View {
        VStack(spacing: 24) {
            ToneIndicator(tone: result.tone)
            
            VStack(alignment: .leading, spacing: 16) {
                Text("Analyse")
                    .font(.headline)
                
                Text(result.advice)
                    .lineSpacing(4)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemBackground))
                    .shadow(radius: 2)
            )
            
            Button {
                // Save analysis to history
                appViewModel.addAnalysis(advice: result.advice, tone: result.tone)
                
                // Reset and go to home
                analysisResult = nil
                appViewModel.setCurrentView(.home)
            } label: {
                Text("Terminer et sauvegarder")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(30)
            }
            
            Button {
                // Just reset and go to home without saving
                analysisResult = nil
                appViewModel.setCurrentView(.home)
            } label: {
                Text("Retour sans sauvegarder")
                    .foregroundColor(.secondary)
            }
        }
    }
    
    private func performAnalysis() {
        guard !appViewModel.capturedImages.isEmpty else { return }
        
        isAnalyzing = true
        
        // Simulate API call for the demo
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            // Generate random result
            let tones: [ToneType] = [.friendly, .flirty, .professional, .ambiguous, .toxic, .manipulative]
            let randomTone = tones.randomElement() ?? .professional
            
            let advices = [
                "Ce message est clairement professionnel. La personne souhaite établir une relation de travail. Répondez de manière formelle tout en restant cordiale.",
                "Il y a une ambiguïté dans ce message. La personne semble intéressée mais garde une certaine distance. Clarifiez ses intentions avant d'aller plus loin.",
                "Le ton est amical mais avec des sous-entendus. La personne cherche probablement à créer un lien plus personnel. Vous pouvez répondre de façon détendue mais sans vous engager trop.",
                "Ce message contient des drapeaux rouges. La personne utilise des techniques de manipulation émotionnelle. Soyez prudent dans votre réponse et maintenez des limites claires."
            ]
            
            self.analysisResult = AnalysisResult(
                tone: randomTone,
                advice: advices.randomElement() ?? advices[0]
            )
            
            self.isAnalyzing = false
        }
    }
}

struct AnalysisResult {
    let tone: ToneType
    let advice: String
}

struct ToneIndicator: View {
    let tone: ToneType
    
    private var toneColor: Color {
        switch tone {
        case .friendly: return Color.green
        case .flirty: return Color.purple
        case .professional: return Color.blue
        case .ambiguous: return Color.orange
        case .toxic: return Color.red
        case .manipulative: return Color.pink
        }
    }
    
    private var toneText: String {
        switch tone {
        case .friendly: return "Amical"
        case .flirty: return "Flirt"
        case .professional: return "Professionnel"
        case .ambiguous: return "Ambigu"
        case .toxic: return "Toxique"
        case .manipulative: return "Manipulateur"
        }
    }
    
    var body: some View {
        VStack(spacing: 12) {
            Text("Ton détecté")
                .font(.headline)
            
            Text(toneText)
                .font(.title)
                .fontWeight(.semibold)
                .foregroundColor(toneColor)
                .padding(.horizontal, 24)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(toneColor.opacity(0.2))
                )
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(radius: 2)
        )
    }
}

struct AnalysisView_Previews: PreviewProvider {
    static var previews: some View {
        AnalysisView()
            .environmentObject(AppViewModel())
    }
}
