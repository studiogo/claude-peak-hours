import SwiftUI
import ServiceManagement

struct PopoverView: View {
    @ObservedObject var manager: PeakHoursManager
    @State private var launchAtLogin: Bool = SMAppService.mainApp.status == .enabled

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Status header
            HStack(spacing: 8) {
                Circle()
                    .fill(statusColor)
                    .frame(width: 14, height: 14)

                Text(manager.isPeak ? L.restrictedHeader : L.fullPowerHeader)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(statusColor)
            }

            Text(manager.isPeak ? L.restrictedDesc : L.fullPowerDesc)
                .font(.system(size: 12))
                .foregroundColor(.secondary)

            Divider()

            // Info rows — uniform font
            VStack(alignment: .leading, spacing: 8) {
                infoRow("timer", label: manager.nextChangeLabel, value: manager.countdownText)
                infoRow("clock", label: L.restrictionHours, value: manager.peakHoursLocalString)
                infoRow("calendar", label: L.workdays, value: L.workdaysValue)
            }

            Divider()

            // Settings
            Toggle(L.launchAtLogin, isOn: $launchAtLogin)
                .toggleStyle(.switch)
                .font(.system(size: 12))
                .onChange(of: launchAtLogin) { [launchAtLogin] newValue in
                    guard newValue != launchAtLogin else { return }
                    do {
                        if newValue {
                            try SMAppService.mainApp.register()
                        } else {
                            try SMAppService.mainApp.unregister()
                        }
                    } catch {
                        // revert on failure
                    }
                }

            Toggle(L.notifications, isOn: $manager.notificationsEnabled)
                .toggleStyle(.switch)
                .font(.system(size: 12))

            Button(L.quit) {
                NSApplication.shared.terminate(nil)
            }
            .buttonStyle(.plain)
            .font(.system(size: 12))
            .foregroundColor(.secondary)
        }
        .padding(16)
        .frame(width: 260)
    }

    private func infoRow(_ icon: String, label: String, value: String) -> some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .frame(width: 14)
                .foregroundColor(.secondary)
            Text(label)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
        }
        .font(.system(size: 12))
    }

    private var statusColor: Color {
        switch manager.status {
        case .offPeak: return Color(red: 0.0, green: 0.5, blue: 0.25)
        case .peak: return .red
        case .warning: return .orange
        }
    }
}
