
import SwiftUI

struct ContentView: View {
    @StateObject private var appViewModel = AppViewModel()
    
    var body: some View {
        if !appViewModel.onboarded {
            OnboardingView()
                .environmentObject(appViewModel)
        } else {
            MainView()
                .environmentObject(appViewModel)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
