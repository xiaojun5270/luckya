import SwiftUI

struct SettingsView: View {
    @State private var serverURL = "http://192.168.9.102:16601"
    @State private var username = "xiaojun"
    @State private var biometricUnlock = true

    var body: some View {
        NavigationStack {
            Form {
                Section("连接") {
                    TextField("服务器地址", text: $serverURL)
                    TextField("用户名", text: $username)
                }

                Section("安全") {
                    Toggle("Face ID / 生物识别", isOn: $biometricUnlock)
                }

                Section("关于") {
                    Text("Lucky Remote Panel")
                    Text("iOS 管理面板骨架 v0.1")
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("设置")
        }
    }
}
