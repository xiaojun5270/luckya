import SwiftUI

struct RootTabView: View {
    @EnvironmentObject private var sessionStore: SessionStore

    var body: some View {
        Group {
            if sessionStore.isLoggedIn {
                TabView {
                    DashboardView()
                        .tabItem { Label("总览", systemImage: "rectangle.3.group.bubble") }
                    ServicesView()
                        .tabItem { Label("服务", systemImage: "server.rack") }
                    ActivityView()
                        .tabItem { Label("动态", systemImage: "waveform.path.ecg") }
                    SettingsView()
                        .tabItem { Label("设置", systemImage: "gearshape") }
                }
                .tint(.cyan)
            } else {
                LoginView()
            }
        }
    }
}
