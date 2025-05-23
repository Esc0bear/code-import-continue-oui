
import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject private var appViewModel: AppViewModel
    @State private var currentStep = 0
    
    private let onboardingSteps = [
        OnboardingStep(
            title: "Bienvenue sur Chat Whisper Lens",
            description: "Analysez vos messages avec l'aide de l'intelligence artificielle pour mieux comprendre les intentions et émotions.",
            emoji: "📱"
        ),
        OnboardingStep(
            title: "Importez vos captures d'écran",
            description: "Ajoutez simplement une capture d'écran de conversation pour l'analyser.",
            emoji: "📷"
        ),
        OnboardingStep(
            title: "Obtenez des analyses claires",
            description: "Recevez des indications sur le ton du message et des conseils pour y répondre.",
            emoji: "🧠"
        )
    ]
    
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            
            Text(onboardingSteps[currentStep].emoji)
                .font(.system(size: 72))
            
            VStack(spacing: 16) {
                Text(onboardingSteps[currentStep].title)
                    .font(.title)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                
                Text(onboardingSteps[currentStep].description)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemBackground))
                    .opacity(0.8)
                    .shadow(radius: 4)
            )
            
            // Progress dots
            HStack(spacing: 8) {
                ForEach(0..<onboardingSteps.count, id: \.self) { index in
                    Circle()
                        .frame(width: index == currentStep ? 16 : 8, height: 8)
                        .foregroundColor(index == currentStep ? .accentColor : .secondary.opacity(0.3))
                        .animation(.spring(), value: currentStep)
                }
            }
            
            VStack(spacing: 12) {
                Button {
                    if currentStep < onboardingSteps.count - 1 {
                        withAnimation {
                            currentStep += 1
                        }
                    } else {
                        appViewModel.setOnboarded(true)
                    }
                } label: {
                    Text(currentStep == onboardingSteps.count - 1 ? "Commencer" : "Suivant")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(30)
                }
                
                if currentStep < onboardingSteps.count - 1 {
                    Button {
                        appViewModel.setOnboarded(true)
                    } label: {
                        Text("Passer")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding(.horizontal, 24)
            
            Spacer()
        }
        .padding()
    }
}

struct OnboardingStep {
    let title: String
    let description: String
    let emoji: String
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
            .environmentObject(AppViewModel())
    }
}
