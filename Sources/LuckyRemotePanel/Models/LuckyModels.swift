import Foundation

struct LuckyServerConfig: Codable, Equatable {
    var baseURL: String
    var username: String
}

struct LuckyAuthToken: Codable, Equatable {
    var token: String
}

struct LuckyStatusSummary: Codable, Equatable {
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
