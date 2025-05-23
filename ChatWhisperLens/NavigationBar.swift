
import SwiftUI

struct NavigationBar: View {
    @EnvironmentObject private var appViewModel: AppViewModel
    
    var body: some View {
        HStack(spacing: 0) {
            NavButton(
                icon: "square.grid.2x2",
                label: "Accueil",
                isActive: appViewModel.currentView == .home,
                action: { appViewModel.setCurrentView(.home) }
            )
            
            NavButton(
                icon: "arrow.up",
                label: "Analyser",
                isActive: appViewModel.currentView == .analyze,
                isPrimary: true,
                action: { appViewModel.setCurrentView(.analyze) }
            )
            
            NavButton(
                icon: "clock",
                label: "Historique",
                isActive: appViewModel.currentView == .history,
                action: { appViewModel.setCurrentView(.history) }
            )
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 12)
        .background(
            Rectangle()
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: -2)
                .edgesIgnoringSafeArea(.bottom)
        )
    }
}

struct NavButton: View {
    let icon: String
    let label: String
    let isActive: Bool
    var isPrimary: Bool = false
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                ZStack {
                    if isPrimary {
                        Circle()
                            .fill(Color.accentColor)
                            .frame(width: 40, height: 40)
                    }
                    
                    Image(systemName: icon)
                        .font(.system(size: isPrimary ? 18 : 22))
                        .foregroundColor(
                            isPrimary ? .white :
                                isActive ? .accentColor : .secondary
                        )
                }
                
                Text(label)
                    .font(.system(size: 12))
                    .foregroundColor(isActive ? .accentColor : .secondary)
            }
            .frame(maxWidth: .infinity)
        }
    }
}

struct NavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        NavigationBar()
            .environmentObject(AppViewModel())
            .previewLayout(.sizeThatFits)
    }
}
