import Foundation

protocol LuckyAPIProtocol {
    func login(baseURL: String, username: String, password: String) async throws -> LuckyAuthToken
    func fetchStatus(baseURL: String, token: String) async throws -> [LuckyStatusSummary]
    func fetchLogs(baseURL: String, token: String) async throws -> [LuckyActivityItem]
    func fetchModules(baseURL: String, token: String) async throws -> [LuckyService]
}

enum LuckyAPIError: LocalizedError {
    case invalidURL
    case invalidResponse
    case unauthorized
    case server(String)
    case decoding(String)

    var errorDescription: String? {
        switch self {
        case .invalidURL: return "无效的服务器地址"
        case .invalidResponse: return "服务端响应无效"
        case .unauthorized: return "登录失效或鉴权失败"
        case .server(let message): return message
        case .decoding(let message): return "数据解析失败：\(message)"
        }
    }
}

final class LuckyAPI: LuckyAPIProtocol {
    private let session: URLSession
    private let decoder = JSONDecoder()

    init(session: URLSession = .shared) {
        self.session = session
    }

    func login(baseURL: String, username: String, password: String) async throws -> LuckyAuthToken {
        guard let url = makeURL(baseURL: baseURL, path: "/api/login", includeTimestamp: true) else {
            throw LuckyAPIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: [
            "Account": username,
            "Password": password,
            "TwoFA": ""
        ])

        let (data, response) = try await session.data(for: request)
        guard let http = response as? HTTPURLResponse else { throw LuckyAPIError.invalidResponse }
        guard (200...299).contains(http.statusCode) else {
            if http.statusCode == 401 { throw LuckyAPIError.unauthorized }
            throw LuckyAPIError.server("login failed: \(http.statusCode)")
        }

        let payload: LuckyLoginResponse
        do {
            payload = try decoder.decode(LuckyLoginResponse.self, from: data)
        } catch {
            throw LuckyAPIError.decoding(error.localizedDescription)
        }

        guard payload.ret == 0, let token = payload.token, !token.isEmpty else {
            throw LuckyAPIError.server(payload.msg?.isEmpty == false ? payload.msg! : "登录失败")
        }

        return LuckyAuthToken(token: token, safeURL: payload.safeURL, message: payload.msg)
    }

    func fetchStatus(baseURL: String, token: String) async throws -> [LuckyStatusSummary] {
        async let statusTask = fetchRuntimeStatus(baseURL: baseURL, token: token)
        async let infoTask = fetchInfo(baseURL: baseURL, token: token)
        async let modulesTask = fetchModulesResponse(baseURL: baseURL, token: token)

        let status = try await statusTask
        let info = try await infoTask
        let modules = try await modulesTask

        var summaries: [LuckyStatusSummary] = []

        if let appName = info.info?.appName, let version = info.info?.version {
            summaries.append(.init(title: "系统", value: "\(appName) \(version)", level: .ok))
        }

        if let usedCPU = status.data?.usedCPU {
            let numeric = Double(usedCPU.replacingOccurrences(of: "%", with: "")) ?? 0
            let level: StatusLevel = numeric >= 85 ? .error : (numeric >= 60 ? .warning : .ok)
            summaries.append(.init(title: "CPU", value: usedCPU, level: level))
        }

        if let processUsedMem = status.data?.processUsedMem {
            summaries.append(.init(title: "内存", value: processUsedMem, level: .ok))
        }

        let totalModules = (modules.modules?.count ?? 0) + (modules.extraModules?.count ?? 0)
        summaries.append(.init(title: "模块数", value: "\(totalModules)", level: totalModules > 0 ? .ok : .warning))

        if let currentTCP = status.data?.currentTCPConnections {
            summaries.append(.init(title: "TCP", value: currentTCP, level: .ok))
        }

        if summaries.isEmpty {
            summaries = [
                .init(title: "连接", value: "已登录", level: .ok)
            ]
        }
        return summaries
    }

    func fetchLogs(baseURL: String, token: String) async throws -> [LuckyActivityItem] {
        let data = try await sendGET(path: "/api/logs", baseURL: baseURL, token: token, queryItems: [URLQueryItem(name: "pre", value: "20")])

        if let payload = try? decoder.decode(LuckyLogsResponse.self, from: data) {
            let entries = payload.list ?? payload.data ?? payload.logs ?? []
            let items = entries.enumerated().map { index, entry in
                LuckyActivityItem(
                    id: "log-\(index)",
                    timestamp: entry.timestamp ?? entry.time ?? "now",
                    title: entry.title ?? entry.level ?? "日志",
                    detail: entry.detail ?? entry.log ?? entry.msg ?? entry.message ?? ""
                )
            }
            if !items.isEmpty { return items }
        }

        let raw = String(decoding: data.prefix(800), as: UTF8.self)
        return [
            LuckyActivityItem(id: "raw-log", timestamp: "now", title: "原始日志响应", detail: raw)
        ]
    }

    func fetchModules(baseURL: String, token: String) async throws -> [LuckyService] {
        let payload = try await fetchModulesResponse(baseURL: baseURL, token: token)
        let modules = payload.modules ?? []
        let extras = payload.extraModules ?? []

        let primary = modules.map {
            LuckyService(id: $0, name: $0, status: "running", detail: "Lucky 主模块")
        }
        let secondary = extras.map {
            LuckyService(id: "extra-\($0)", name: $0, status: "available", detail: "Lucky 扩展模块")
        }
        return primary + secondary
    }

    private func fetchInfo(baseURL: String, token: String) async throws -> LuckyInfoResponse {
        let data = try await sendGET(path: "/api/info", baseURL: baseURL, token: token)
        do {
            return try decoder.decode(LuckyInfoResponse.self, from: data)
        } catch {
            throw LuckyAPIError.decoding(error.localizedDescription)
        }
    }

    private func fetchModulesResponse(baseURL: String, token: String) async throws -> LuckyModulesResponse {
        let data = try await sendGET(path: "/api/modules/list", baseURL: baseURL, token: token)
        do {
            return try decoder.decode(LuckyModulesResponse.self, from: data)
        } catch {
            throw LuckyAPIError.decoding(error.localizedDescription)
        }
    }

    private func fetchRuntimeStatus(baseURL: String, token: String) async throws -> LuckyStatusResponse {
        let data = try await sendGET(path: "/api/status", baseURL: baseURL, token: token)
        do {
            return try decoder.decode(LuckyStatusResponse.self, from: data)
        } catch {
            throw LuckyAPIError.decoding(error.localizedDescription)
        }
    }

    private func sendGET(path: String, baseURL: String, token: String, queryItems: [URLQueryItem] = []) async throws -> Data {
        guard let url = makeURL(baseURL: baseURL, path: path, includeTimestamp: true, extraQueryItems: queryItems) else {
            throw LuckyAPIError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(token, forHTTPHeaderField: "Lucky-Admin-Token")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        let (data, response) = try await session.data(for: request)
        guard let http = response as? HTTPURLResponse else { throw LuckyAPIError.invalidResponse }
        guard (200...299).contains(http.statusCode) else {
            if http.statusCode == 401 { throw LuckyAPIError.unauthorized }
            throw LuckyAPIError.server("request failed: \(http.statusCode)")
        }

        let body = String(decoding: data, as: UTF8.self)
        if body.contains("login invalid") {
            throw LuckyAPIError.unauthorized
        }
        return data
    }

    private func makeURL(baseURL: String, path: String, includeTimestamp: Bool, extraQueryItems: [URLQueryItem] = []) -> URL? {
        guard var components = URLComponents(string: baseURL + path) else { return nil }
        var items = components.queryItems ?? []
        items.append(contentsOf: extraQueryItems)
        if includeTimestamp {
            items.append(URLQueryItem(name: "_", value: String(Int(Date().timeIntervalSince1970 * 1000))))
        }
        components.queryItems = items.isEmpty ? nil : items
        return components.url
    }
}
