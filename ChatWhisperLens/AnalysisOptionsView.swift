
import SwiftUI

struct AnalysisOptionsView: View {
    @EnvironmentObject private var appViewModel: AppViewModel
    
    private let analysisOptions = [
        AnalysisOptionItem(
            id: .responseAdvice,
            title: "Conseil de réponse",
            description: "Comment devrais-je répondre à ce message?"
        ),
        AnalysisOptionItem(
            id: .toneAnalysis,
            title: "Analyse du ton",
            description: "Quelle est l'intention derrière ce message?"
        ),
        AnalysisOptionItem(
            id: .hiddenIntentions,
            title: "Intentions cachées",
            description: "Y a-t-il des intentions non dites?"
        ),
        AnalysisOptionItem(
            id: .relationshipDynamics,
            title: "Dynamique relationnelle",
            description: "Que dit cet échange de notre relation?"
        )
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Que souhaitez-vous analyser?")
                .font(.title3)
                .fontWeight(.medium)
            
            ForEach(analysisOptions, id: \.id.rawValue) { option in
                OptionButton(
                    option: option,
                    isSelected: appViewModel.selectedAnalysisOption == option.id
                ) {
                    appViewModel.setSelectedAnalysisOption(option.id)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(radius: 2)
        )
    }
}

struct AnalysisOptionItem {
    let id: AnalysisOption
    let title: String
    let description: String
}

struct OptionButton: View {
    let option: AnalysisOptionItem
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(alignment: .top, spacing: 12) {
                Circle()
                    .strokeBorder(Color.accentColor, lineWidth: 2)
                    .frame(width: 24, height: 24)
                    .overlay(
                        Circle()
                            .fill(Color.accentColor)
                            .frame(width: 16, height: 16)
                            .opacity(isSelected ? 1 : 0)
                    )
                    .padding(.top, 2)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(option.title)
                        .fontWeight(.medium)
                    
                    Text(option.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(isSelected ? Color.accentColor.opacity(0.1) : Color.clear)
            )
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct AnalysisOptionsView_Previews: PreviewProvider {
    static var previews: some View {
        AnalysisOptionsView()
            .environmentObject(AppViewModel())
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
