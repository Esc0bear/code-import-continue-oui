
import SwiftUI

struct MainView: View {
    @EnvironmentObject private var appViewModel: AppViewModel
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 0) {
                header
                
                ScrollView {
                    VStack(spacing: 24) {
                        switch appViewModel.currentView {
                        case .home:
                            ImageUploaderView()
                        case .analyze:
                            AnalysisView()
                        case .history:
                            HistoryView()
                        }
                    }
                    .padding(.bottom, 100) // Space for navigation
                }
            }
            .padding(.horizontal)
            
            NavigationBar()
        }
    }
    
    private var header: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(appViewModel.currentView == .history ? "Historique" :
                 appViewModel.currentView == .analyze ? "Analyse" :
                    "Chat Whisper Lens")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text(appViewModel.currentView == .history ? "Consultez vos analyses passées" :
                 appViewModel.currentView == .analyze ? "Comprenez le message" :
                    "Analysez les intentions derrière les messages")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 16)
        .padding(.bottom, 12)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(AppViewModel())
    }
}
