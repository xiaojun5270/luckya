import SwiftUI

struct ServicesView: View {
    let services: [ServiceItem] = [
        .init(name: "OpenClaw Gateway", status: .running, detail: "RPC 正常"),
        .init(name: "Token Monitor", status: .warning, detail: "等待检查"),
        .init(name: "Auto Sign", status: .running, detail: "上次执行成功")
    ]

    var body: some View {
        NavigationStack {
            List(services) { service in
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text(service.name).font(.headline)
                        Spacer()
                        Text(service.status.label)
                            .font(.caption)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(service.status.color.opacity(0.18))
                            .clipShape(Capsule())
                    }
                    Text(service.detail)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .listRowBackground(Color.white.opacity(0.04))
            }
            .scrollContentBackground(.hidden)
            .background(Color.black.ignoresSafeArea())
            .navigationTitle("服务")
        }
    }
}

struct ServiceItem: Identifiable {
    let id = UUID()
    let name: String
    let status: ServiceStatus
    let detail: String
}

enum ServiceStatus {
    case running
    case warning
    case stopped

    var label: String {
        switch self {
        case .running: return "运行中"
        case .warning: return "注意"
        case .stopped: return "已停止"
        }
    }

    var color: Color {
        switch self {
        case .running: return .green
        case .warning: return .orange
        case .stopped: return .red
        }
    }
}
