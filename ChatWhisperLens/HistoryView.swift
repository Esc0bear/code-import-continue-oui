
import SwiftUI

struct HistoryView: View {
    @EnvironmentObject private var appViewModel: AppViewModel
    
    var body: some View {
        VStack(spacing: 24) {
            if appViewModel.analyses.isEmpty {
                emptyHistoryView
            } else {
                analysisList
            }
        }
    }
    
    private var emptyHistoryView: some View {
        VStack(spacing: 16) {
            Text("Aucune analyse récente")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Vos analyses apparaîtront ici une fois que vous aurez analysé des messages.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button {
                appViewModel.setCurrentView(.home)
            } label: {
                Text("Effectuer une analyse")
                    .padding()
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(30)
            }
            .padding(.top, 24)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .frame(height: 300)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(radius: 2)
        )
    }
    
    private var analysisList: some View {
        LazyVStack(spacing: 16) {
            ForEach(appViewModel.analyses) { analysis in
                AnalysisCard(analysis: analysis)
            }
        }
    }
}

struct AnalysisCard: View {
    let analysis: Analysis
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM, HH:mm"
        formatter.locale = Locale(identifier: "fr_FR")
        return formatter.string(from: analysis.timestamp)
    }
    
    private var optionText: String {
        switch analysis.selectedOption {
        case .responseAdvice: return "Conseil de réponse"
        case .toneAnalysis: return "Analyse du ton"
        case .hiddenIntentions: return "Intentions cachées"
        case .relationshipDynamics: return "Dynamique relationnelle"
        }
    }
    
    private var toneText: String {
        switch analysis.tone {
        case .friendly: return "Amical"
        case .flirty: return "Flirt"
        case .professional: return "Professionnel"
        case .ambiguous: return "Ambigu"
        case .toxic: return "Toxique"
        case .manipulative: return "Manipulateur"
        }
    }
    
    private var toneColor: Color {
        switch analysis.tone {
        case .friendly: return Color.green
        case .flirty: return Color.purple
        case .professional: return Color.blue
        case .ambiguous: return Color.orange
        case .toxic: return Color.red
        case .manipulative: return Color.pink
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                HStack(spacing: 8) {
                    Text(formattedDate)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text(optionText)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(Color(.systemGray5))
                        .cornerRadius(10)
                }
                
                Spacer()
                
                Text(toneText)
                    .font(.caption)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(toneColor.opacity(0.2))
                    .foregroundColor(toneColor)
                    .cornerRadius(10)
            }
            .padding()
            .background(Color(.systemGray6).opacity(0.5))
            
            Divider()
            
            VStack(alignment: .leading, spacing: 12) {
                if !analysis.images.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(analysis.images) { image in
                                if let uiImage = UIImage(data: image.imageData) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 70, height: 70)
                                        .clipShape(RoundedRectangle(cornerRadius: 6))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 6)
                                                .stroke(Color(.systemGray4), lineWidth: 1)
                                        )
                                }
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
                
                Text(analysis.advice)
                    .lineLimit(2)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding()
        }
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(radius: 2)
        )
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        // Prépare d'abord ton viewModel
        let viewModel = AppViewModel()
        viewModel.addAnalysis(
            advice: "Ce message semble amical et ouvert. La personne cherche à établir une connexion genuine.",
            tone: .friendly
        )
        viewModel.addAnalysis(
            advice: "Attention, le ton est manipulateur. La personne utilise des techniques de culpabilisation.",
            tone: .manipulative
        )

        // Retourne ensuite les vues dans un Group
        return Group {
            // Preview avec analyses
            HistoryView()
                .environmentObject(viewModel)
            
            // Preview avec état vide
            HistoryView()
                .environmentObject(AppViewModel())
        }
    }
}
