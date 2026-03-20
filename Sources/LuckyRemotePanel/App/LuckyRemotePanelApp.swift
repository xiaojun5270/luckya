import SwiftUI

@main
struct LuckyRemotePanelApp: App {
    @StateObject private var sessionStore = SessionStore()

    var body: some Scene {
        WindowGroup {
            RootTabView()
                .environmentObject(sessionStore)
                .preferredColorScheme(.dark)
        }
    }
}
