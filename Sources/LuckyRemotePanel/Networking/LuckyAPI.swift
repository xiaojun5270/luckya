import Foundation

protocol LuckyAPIProtocol {
    func login(baseURL: String, username: String, password: String) async throws -> LuckyAuthToken
    func fetchStatus(baseURL: String, token: String) async throws -> [LuckyStatusSummary]
    func fetchLogs(baseURL: String, token: String) async throws -> [LuckyActivityItem]
    func fetchModules(baseURL: String, token: String) async throws -> [LuckyService]
}

enum LuckyAPIError: Error {
    case invalidURL
    case invalidResponse
    case unauthorized
    case server(String)
}

final class LuckyAPI: LuckyAPIProtocol {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func login(baseURL: String, username: String, password: String) async throws -> LuckyAuthToken {
        guard let url = URL(string: baseURL + "/api/login") else { throw LuckyAPIError.invalidURL }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: [
            "username": username,
            "password": password
        ])

        let (_, response) = try await session.data(for: request)
        guard let http = response as? HTTPURLResponse else { throw LuckyAPIError.invalidResponse }
        guard (200...299).contains(http.statusCode) else {
            if http.statusCode == 401 { throw LuckyAPIError.unauthorized }
            throw LuckyAPIError.server("login failed: \(http.statusCode)")
        }

        let token = http.value(forHTTPHeaderField: "Set-Cookie") ?? ""
        return LuckyAuthToken(token: token)
    }

    func fetchStatus(baseURL: String, token: String) async throws -> [LuckyStatusSummary] {
        _ = try await sendGET(path: "/api/status", baseURL: baseURL, token: token)
        return [
            LuckyStatusSummary(title: "系统状态", value: "在线", level: .ok),
            LuckyStatusSummary(title: "RPC", value: "正常", level: .ok),
            LuckyStatusSummary(title: "服务数", value: "待接入", level: .warning)
        ]
    }

    func fetchLogs(baseURL: String, token: String) async throws -> [LuckyActivityItem] {
        _ = try await sendGET(path: "/api/logs", baseURL: baseURL, token: token)
        return [
            LuckyActivityItem(id: UUID().uuidString, timestamp: "now", title: "日志已拉取", detail: "后续替换为真实解析")
        ]
    }

    func fetchModules(baseURL: String, token: String) async throws -> [LuckyService] {
        _ = try await sendGET(path: "/api/modules/list", baseURL: baseURL, token: token)
        return [
            LuckyService(id: "gateway", name: "概览模块", status: "running", detail: "模块列表接口已探测")
        ]
    }

    private func sendGET(path: String, baseURL: String, token: String) async throws -> Data {
        guard let url = URL(string: baseURL + path) else { throw LuckyAPIError.invalidURL }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        if !token.isEmpty {
            request.setValue(token, forHTTPHeaderField: "Cookie")
        }
        let (data, response) = try await session.data(for: request)
        guard let http = response as? HTTPURLResponse else { throw LuckyAPIError.invalidResponse }
        guard (200...299).contains(http.statusCode) else {
            if http.statusCode == 401 { throw LuckyAPIError.unauthorized }
            throw LuckyAPIError.server("request failed: \(http.statusCode)")
        }
        return data
    }
}
