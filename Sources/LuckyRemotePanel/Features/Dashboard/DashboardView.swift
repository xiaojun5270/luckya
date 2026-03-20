import SwiftUI

struct DashboardView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    header
                    statusCards
                    quickActions
                    recentActivity
                }
                .padding()
            }
            .background(Color.black.ignoresSafeArea())
            .navigationTitle("远程管理面板")
        }
    }

    private var header: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 8) {
                Text("设备在线")
                    .font(.headline)
                    .foregroundStyle(.green)
                Text("Lucky Remote Panel")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)
                Text("统一查看服务状态、日志与快捷控制")
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private var statusCards: some View {
        HStack(spacing: 12) {
            metricCard(title: "在线服务", value: "12", color: .cyan)
            metricCard(title: "告警", value: "2", color: .orange)
        }
    }

    private func metricCard(title: String, value: String, color: Color) -> some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 6) {
                Text(title).foregroundStyle(.secondary)
                Text(value)
                    .font(.system(size: 34, weight: .bold))
                    .foregroundStyle(color)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private var quickActions: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 12) {
                Text("快捷操作")
                    .font(.headline)
                    .foregroundStyle(.white)
                HStack {
                    actionButton("刷新", systemImage: "arrow.clockwise")
                    actionButton("日志", systemImage: "doc.text.magnifyingglass")
                    actionButton("控制台", systemImage: "terminal")
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private func actionButton(_ title: String, systemImage: String) -> some View {
        VStack(spacing: 8) {
            Image(systemName: systemImage)
                .font(.title2)
            Text(title)
                .font(.caption)
        }
        .foregroundStyle(.white)
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(.cyan.opacity(0.18))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    private var recentActivity: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 10) {
                Text("最近动态")
                    .font(.headline)
                    .foregroundStyle(.white)
                Label("Gateway restarted successfully", systemImage: "checkmark.circle.fill")
                    .foregroundStyle(.green)
                Label("2 services need attention", systemImage: "exclamationmark.triangle.fill")
                    .foregroundStyle(.orange)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}
