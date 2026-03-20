import SwiftUI

struct LoginView: View {
    @EnvironmentObject private var sessionStore: SessionStore
    @StateObject private var viewModel = LoginViewModel()

    var body: some View {
        VStack(spacing: 20) {
            Text("登录远程管理面板")
                .font(.largeTitle.bold())
                .foregroundStyle(.white)

            TextField("服务器地址", text: $viewModel.server)
                .textFieldStyle(.roundedBorder)
            TextField("用户名", text: $viewModel.username)
                .textFieldStyle(.roundedBorder)
            SecureField("密码", text: $viewModel.password)
                .textFieldStyle(.roundedBorder)

            if let error = viewModel.errorMessage {
                Text(error)
                    .font(.caption)
                    .foregroundStyle(.red)
            }

            Button(viewModel.isLoading ? "登录中..." : "登录") {
                Task { await viewModel.login() }
            }
            .buttonStyle(.borderedProminent)
            .disabled(viewModel.isLoading)
        }
        .padding()
        .background(Color.black.ignoresSafeArea())
        .onAppear {
            viewModel.bind(sessionStore: sessionStore)
        }
    }
}
