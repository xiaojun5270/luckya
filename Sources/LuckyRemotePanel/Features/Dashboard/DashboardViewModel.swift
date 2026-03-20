import Foundation

@MainActor
final class DashboardViewModel: ObservableObject {
    @Published var summaries: [LuckyStatusSummary] = []
    @Published var activities: [LuckyActivityItem] = []
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
            async let status = api.fetchStatus(baseURL: sessionStore.config.baseURL, token: token)
            async let logs = api.fetchLogs(baseURL: sessionStore.config.baseURL, token: token)
            summaries = try await status
            activities = try await logs
        } catch {
            errorMessage = String(describing: error)
        }
    }
}
