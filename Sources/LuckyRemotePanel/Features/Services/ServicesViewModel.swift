import Foundation

@MainActor
final class ServicesViewModel: ObservableObject {
    @Published var services: [LuckyService] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let api: LuckyAPIProtocol
    private let sessionStore: SessionStore

    init(api: LuckyAPIProtocol = LuckyAPI(), sessionStore: SessionStore) {
        self.api = api
        self.sessionStore = sessionStore
    }

    func load() async {
        guard let token = sessionStore.authToken?.token else { return }
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            services = try await api.fetchModules(baseURL: sessionStore.config.baseURL, token: token)
        } catch {
            errorMessage = String(describing: error)
        }
    }
}
