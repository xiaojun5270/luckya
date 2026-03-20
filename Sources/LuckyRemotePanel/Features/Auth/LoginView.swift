import SwiftUI

struct LoginView: View {
    @State private var server = "http://192.168.9.102:16601"
    @State private var username = ""
    @State private var password = ""

    var body: some View {
        VStack(spacing: 20) {
            Text("登录远程管理面板")
                .font(.largeTitle.bold())
                .foregroundStyle(.white)
            TextField("服务器地址", text: $server)
                .textFieldStyle(.roundedBorder)
            TextField("用户名", text: $username)
                .textFieldStyle(.roundedBorder)
            SecureField("密码", text: $password)
                .textFieldStyle(.roundedBorder)
            Button("登录") {}
                .buttonStyle(.borderedProminent)
        }
        .padding()
        .background(Color.black.ignoresSafeArea())
    }
}
