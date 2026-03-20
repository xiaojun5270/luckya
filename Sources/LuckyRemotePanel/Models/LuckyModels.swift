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
    let data: LuckyRuntimeStatus?
}

struct LuckyRuntimeStatus: Codable, Equatable {
    let heapInuse: String?
    let numForcedGC: Int?
    let numGC: Int?
    let currentProcessUsedCPU: String?
    let currentTCPConnections: String?
    let currentUDPConnections: String?
    let goroutine: String?
    let handleCount: Int?
    let lastNetInSpeed: Int64?
    let lastNetOutSpeed: Int64?
    let maxTCPConnections: String?
    let netin: Int64?
    let netout: Int64?
    let processUsedMem: String?
    let queryTime: String?
    let runTime: String?
    let systemBootTime: String?
    let totleMem: Int64?
    let unusedMem: Int64?
    let usedCPU: String?
    let usedMem: Int64?

    enum CodingKeys: String, CodingKey {
        case heapInuse = "HeapInuse"
        case numForcedGC = "NumForcedGC"
        case numGC = "NumGC"
        case currentProcessUsedCPU
        case currentTCPConnections
        case currentUDPConnections
        case goroutine
        case handleCount
        case lastNetInSpeed
        case lastNetOutSpeed
        case maxTCPConnections
        case netin
        case netout
        case processUsedMem
        case queryTime
        case runTime
        case systemBootTime
        case totleMem
        case unusedMem
        case usedCPU
        case usedMem
    }
}

struct LuckyLogsResponse: Codable {
    let ret: Int?
    let logsCount: Int?
    let list: [LuckyLogEntry]?
    let data: [LuckyLogEntry]?
    let logs: [LuckyLogEntry]?
}

struct LuckyLogEntry: Codable, Equatable {
    let timestamp: String?
    let time: String?
    let title: String?
    let detail: String?
    let log: String?
    let msg: String?
    let message: String?
    let level: String?
}
