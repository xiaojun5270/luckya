import Foundation

@MainActor
final class SessionStore: ObservableObject {
    @Published var config = LuckyServerConfig(baseURL: "http://192.168.9.102:16601", username: "xiaojun")
    @Published var authToken: LuckyAuthToken?
    @Published var isLoggedIn = false

    func updateToken(_ token: LuckyAuthToken) {
        authToken = token
        isLoggedIn = !token.token.isEmpty
    }

    func logout() {
        authToken = nil
        isLoggedIn = false
    }
}
