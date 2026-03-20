import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var sessionStore: SessionStore
    @State private var biometricUnlock = true

    var body: some View {
        NavigationStack {
            Form {
                Section("连接") {
                    LabeledContent("服务器") {
                        Text(sessionStore.config.baseURL)
                    }
                    LabeledContent("用户名") {
                        Text(sessionStore.config.username)
                    }
                }

                Section("安全") {
                    Toggle("Face ID / 生物识别", isOn: $biometricUnlock)
                }

                Section("会话") {
                    LabeledContent("登录状态") {
                        Text(sessionStore.isLoggedIn ? "已登录" : "未登录")
                    }
                    if let token = sessionStore.authToken?.token {
                        Text(token.prefix(24) + "...")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                    Button("退出登录", role: .destructive) {
                        sessionStore.logout()
                    }
                }

                Section("关于") {
                    Text("Lucky Remote Panel")
                    Text("真实 Lucky API 对接中")
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("设置")
        }
    }
}
