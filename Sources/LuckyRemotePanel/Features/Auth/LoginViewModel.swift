import Foundation

@MainActor
final class LoginViewModel: ObservableObject {
    @Published var server = "http://192.168.9.102:16601"
    @Published var username = "xiaojun"
    @Published var password = ""
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let api: LuckyAPIProtocol
    private var sessionStore: SessionStore?

    init(api: LuckyAPIProtocol = LuckyAPI()) {
        self.api = api
    }

    func bind(sessionStore: SessionStore) {
        self.sessionStore = sessionStore
        self.server = sessionStore.config.baseURL
        self.username = sessionStore.config.username
    }

    func login() async {
        guard let sessionStore else {
            errorMessage = "SessionStore not bound"
            return
        }

        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            let token = try await api.login(baseURL: server, username: username, password: password)
            sessionStore.config = LuckyServerConfig(baseURL: server, username: username)
            sessionStore.updateToken(token)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
