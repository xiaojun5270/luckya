import Foundation

struct LuckyServerConfig: Codable, Equatable {
    var baseURL: String
    var username: String
}

struct LuckyAuthToken: Codable, Equatable {
    var token: String
    var safeURL: String?
    var message: String?
}

struct LuckyStatusSummary: Codable, Equatable, Identifiable {
    var id: String { title }
    var title: String
    var value: String
    var level: StatusLevel
}

enum StatusLevel: String, Codable {
    case ok
    case warning
    case error
}

struct LuckyService: Identifiable, Codable, Equatable {
    var id: String
    var name: String
    var status: String
    var detail: String
}

struct LuckyActivityItem: Identifiable, Codable, Equatable {
    var id: String
    var timestamp: String
    var title: String
    var detail: String
}

struct LuckyLoginResponse: Codable {
    let ret: Int
    let msg: String?
    let token: String?
    let safeURL: String?
    let frontendsetting: LuckyFrontendSetting?
}

struct LuckyFrontendSetting: Codable {
    let title: String?
    let theme: String?
}

struct LuckyModulesResponse: Codable {
    let ret: Int
    let u: String?
    let modules: [String]?
    let extraModules: [String]?
    let isDefaultAuthInfo: Bool?
    let noSetSafeURL: Bool?

    enum CodingKeys: String, CodingKey {
        case ret, u, extraModules, isDefaultAuthInfo, noSetSafeURL
        case modules = "Modules"
    }
}

struct LuckyInfoResponse: Codable {
    let ret: Int
    let u: String?
    let info: LuckySystemInfo?
    let moduleList: [String]?
    let extraModules: [String]?
}

struct LuckySystemInfo: Codable, Equatable {
    let appName: String?
    let version: String?
    let versionName: String?
    let os: String?
    let arch: String?
    let date: String?
    let goVersion: String?

    enum CodingKeys: String, CodingKey {
        case appName = "AppName"
        case version = "Version"
        case versionName = "VersionName"
        case os = "OS"
        case arch = "ARCH"
        case date = "Date"
        case goVersion = "GoVersion"
    }
}

struct LuckyStatusResponse: Codable {
    let ret: Int?
    let u: String?
    let data: [String: String]?
}

struct LuckyLogsResponse: Codable {
    let ret: Int?
    let list: [LuckyLogEntry]?
    let data: [LuckyLogEntry]?
    let logs: [LuckyLogEntry]?
}

struct LuckyLogEntry: Codable, Equatable {
    let time: String?
    let title: String?
    let detail: String?
    let msg: String?
    let message: String?
    let level: String?
}
