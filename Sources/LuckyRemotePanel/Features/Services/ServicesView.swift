import SwiftUI

struct ServicesView: View {
    @EnvironmentObject private var sessionStore: SessionStore
    @StateObject private var viewModel = ServicesViewModel()

    private var runningServices: [LuckyService] {
        viewModel.services.filter { $0.status == "running" }
    }

    private var availableServices: [LuckyService] {
        viewModel.services.filter { $0.status == "available" }
    }

    var body: some View {
        NavigationStack {
            List {
                summarySection

                if let error = viewModel.errorMessage {
                    Section {
                        Text(error)
                            .foregroundStyle(.orange)
                    }
                    .listRowBackground(Color.orange.opacity(0.08))
                }

                if viewModel.services.isEmpty, viewModel.errorMessage == nil {
                    Section("模块列表") {
                        Text("暂无服务数据")
                            .foregroundStyle(.secondary)
                    }
                    .listRowBackground(Color.white.opacity(0.04))
                } else {
                    if !runningServices.isEmpty {
                        Section("主模块 · \(runningServices.count)") {
                            ForEach(runningServices) { service in
                                serviceRow(service)
                            }
                        }
                    }

                    if !availableServices.isEmpty {
                        Section("扩展模块 · \(availableServices.count)") {
                            ForEach(availableServices) { service in
                                serviceRow(service)
                            }
                        }
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color.black.ignoresSafeArea())
            .navigationTitle("服务")
            .task(id: sessionStore.authToken?.token) {
                viewModel.bind(sessionStore: sessionStore)
                await viewModel.load()
            }
        }
    }

    private var summarySection: some View {
        Section {
            HStack {
                summaryChip(title: "总数", value: "\(viewModel.services.count)", color: .white)
                Spacer()
                summaryChip(title: "主模块", value: "\(runningServices.count)", color: .green)
                Spacer()
                summaryChip(title: "扩展", value: "\(availableServices.count)", color: .cyan)
            }
            .padding(.vertical, 6)
        }
        .listRowBackground(Color.white.opacity(0.04))
    }

    private func summaryChip(title: String, value: String, color: Color) -> some View {
        VStack(spacing: 6) {
            Text(value)
                .font(.title3.bold())
                .foregroundStyle(color)
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }

    private func serviceRow(_ service: LuckyService) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .center) {
                Circle()
                    .fill(statusColor(service.status))
                    .frame(width: 8, height: 8)

                Text(service.name)
                    .font(.headline)
                    .foregroundStyle(.white)

                Spacer()

                Text(statusLabel(service.status))
                    .font(.caption)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(statusColor(service.status).opacity(0.18))
                    .foregroundStyle(statusColor(service.status))
                    .clipShape(Capsule())
            }

            Text(service.detail)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .textSelection(.enabled)
        }
        .padding(.vertical, 4)
        .listRowBackground(Color.white.opacity(0.04))
    }

    private func statusLabel(_ value: String) -> String {
        switch value {
        case "running": return "主模块"
        case "available": return "扩展模块"
        default: return value
        }
    }

    private func statusColor(_ value: String) -> Color {
        switch value {
        case "running": return .green
        case "available": return .cyan
        default: return .orange
        }
    }
}
