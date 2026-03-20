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
            VStack(alignment: .leading, spacing: 10) {
                HStack(spacing: 10) {
                    Circle()
                        .fill(viewModel.errorMessage == nil ? .green : .orange)
                        .frame(width: 10, height: 10)
                    Text(viewModel.errorMessage == nil ? "设备在线" : "连接异常")
                        .font(.headline)
                        .foregroundStyle(viewModel.errorMessage == nil ? .green : .orange)
                }

                Text("Lucky Remote Panel")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)

                Text(sessionStore.config.baseURL)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                if let token = sessionStore.authToken?.token, !token.isEmpty {
                    Text("Token 已载入 · \(String(token.prefix(16)))...")
                        .font(.caption)
                        .foregroundStyle(.gray)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private var statusCards: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
            if viewModel.summaries.isEmpty {
                GlassCard {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("状态")
                            .foregroundStyle(.secondary)
                        Text("暂无数据")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundStyle(.gray)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }

            ForEach(viewModel.summaries) { item in
                GlassCard {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text(item.title)
                                .foregroundStyle(.secondary)
                            Spacer()
                            Circle()
                                .fill(color(for: item.level))
                                .frame(width: 8, height: 8)
                        }
                        Text(item.value)
                            .font(.system(size: 20, weight: .bold))
                            .foregroundStyle(color(for: item.level))
                            .lineLimit(2)
                            .minimumScaleFactor(0.85)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
    }

    private var recentActivity: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("最近动态")
                        .font(.headline)
                        .foregroundStyle(.white)
                    Spacer()
                    Text("最近 5 条")
                        .font(.caption)
                        .foregroundStyle(.gray)
                }

                if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundStyle(.orange)
                }

                if viewModel.activities.isEmpty {
                    Text("暂无动态数据")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                ForEach(viewModel.activities.prefix(5)) { item in
                    VStack(alignment: .leading, spacing: 6) {
                        HStack(alignment: .top) {
                            RoundedRectangle(cornerRadius: 3)
                                .fill(.cyan.opacity(0.8))
                                .frame(width: 4, height: 34)
                            VStack(alignment: .leading, spacing: 4) {
                                Text(item.title)
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundStyle(.white)
                                Text(item.detail)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                    .lineLimit(3)
                                Text(item.timestamp)
                                    .font(.caption2)
                                    .foregroundStyle(.gray)
                            }
                        }

                        if item.id != viewModel.activities.prefix(5).last?.id {
                            Divider().overlay(.white.opacity(0.08))
                        }
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
