import SwiftUI

struct DashboardView: View {
    @EnvironmentObject private var sessionStore: SessionStore
    @StateObject private var viewModel = DashboardViewModel()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    header
                    statusCards
                    recentActivity
                }
                .padding()
            }
            .background(Color.black.ignoresSafeArea())
            .navigationTitle("远程管理面板")
            .task(id: sessionStore.authToken?.token) {
                viewModel.bind(sessionStore: sessionStore)
                await viewModel.load()
            }
        }
    }

    private var header: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 8) {
                Text(viewModel.errorMessage == nil ? "设备在线" : "连接异常")
                    .font(.headline)
                    .foregroundStyle(viewModel.errorMessage == nil ? .green : .orange)
                Text("Lucky Remote Panel")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)
                Text(sessionStore.config.baseURL)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private var statusCards: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
            ForEach(viewModel.summaries) { item in
                GlassCard {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(item.title).foregroundStyle(.secondary)
                        Text(item.value)
                            .font(.system(size: 20, weight: .bold))
                            .foregroundStyle(color(for: item.level))
                            .lineLimit(2)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
    }

    private var recentActivity: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 10) {
                Text("最近动态")
                    .font(.headline)
                    .foregroundStyle(.white)

                if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundStyle(.orange)
                }

                ForEach(viewModel.activities.prefix(5)) { item in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(item.title)
                            .foregroundStyle(.white)
                        Text(item.detail)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text(item.timestamp)
                            .font(.caption2)
                            .foregroundStyle(.gray)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private func color(for level: StatusLevel) -> Color {
        switch level {
        case .ok: return .green
        case .warning: return .orange
        case .error: return .red
        }
    }
}
