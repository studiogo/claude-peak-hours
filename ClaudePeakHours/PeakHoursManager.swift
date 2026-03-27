import Foundation
import Combine
import UserNotifications

enum PeakStatus {
    case offPeak
    case peak
    case warning // 15 min before change
}

final class PeakHoursManager: ObservableObject {
    @Published var isPeak: Bool = false
    @Published var status: PeakStatus = .offPeak
    @Published var timeUntilChange: TimeInterval = 0
    @Published var countdownText: String = ""
    @Published var peakHoursLocalString: String = ""
    @Published var nextChangeLabel: String = ""

    private var timer: Timer?
    private var lastNotifiedPeak: Bool?
    private var lastNotifiedWarning: Bool = false
    @Published var notificationsEnabled: Bool {
        didSet { UserDefaults.standard.set(notificationsEnabled, forKey: "notificationsEnabled") }
    }

    private let ptTimeZone = TimeZone(identifier: "America/Los_Angeles")!
    private let peakStartHour = 5  // 5:00 AM PT
    private let peakEndHour = 11   // 11:00 AM PT
    private let warningMinutes: TimeInterval = 15 * 60 // 15 minutes

    init() {
        self.notificationsEnabled = UserDefaults.standard.bool(forKey: "notificationsEnabled")
        update()
        computeLocalPeakHoursString()
        timer = Timer.scheduledTimer(withTimeInterval: 30, repeats: true) { [weak self] _ in
            self?.update()
        }
    }

    deinit {
        timer?.invalidate()
    }

    func update() {
        let now = Date()
        let cal = Calendar.current
        let ptComponents = cal.dateComponents(in: ptTimeZone, from: now)

        guard let weekday = ptComponents.weekday,
              let hour = ptComponents.hour,
              let minute = ptComponents.minute else { return }

        // Weekend = always off-peak (weekday: 1=Sun, 7=Sat)
        let isWeekday = weekday >= 2 && weekday <= 6
        let currentIsPeak = isWeekday && hour >= peakStartHour && hour < peakEndHour

        // Calculate time until next change
        let secondsIntoDay = Double(hour * 3600 + minute * 60 + (ptComponents.second ?? 0))
        let peakStartSeconds = Double(peakStartHour * 3600)
        let peakEndSeconds = Double(peakEndHour * 3600)

        var secondsUntilChange: TimeInterval

        if !isWeekday {
            // Weekend: find next Monday 5:00 AM PT
            let daysUntilMonday = weekday == 1 ? 1 : (9 - weekday) // Sun=1 day, Sat=2 days
            secondsUntilChange = Double(daysUntilMonday) * 86400 - secondsIntoDay + peakStartSeconds
            nextChangeLabel = L.restrictionsIn
        } else if currentIsPeak {
            // Currently peak: count down to peakEndHour
            secondsUntilChange = peakEndSeconds - secondsIntoDay
            nextChangeLabel = L.fullPowerIn
        } else if secondsIntoDay < peakStartSeconds {
            // Before peak today
            secondsUntilChange = peakStartSeconds - secondsIntoDay
            nextChangeLabel = L.restrictionsIn
        } else {
            // After peak today
            if weekday == 6 { // Friday after peak -> Monday
                secondsUntilChange = 2 * 86400 + (86400 - secondsIntoDay) + peakStartSeconds
            } else {
                secondsUntilChange = (86400 - secondsIntoDay) + peakStartSeconds
            }
            nextChangeLabel = L.restrictionsIn
        }

        timeUntilChange = max(0, secondsUntilChange)
        isPeak = currentIsPeak

        // Determine status with warning
        if currentIsPeak && secondsUntilChange <= warningMinutes {
            status = .warning
        } else if !currentIsPeak && secondsUntilChange <= warningMinutes {
            status = .warning
        } else {
            status = currentIsPeak ? .peak : .offPeak
        }

        countdownText = formatCountdown(timeUntilChange)

        // Send notifications on state change
        if notificationsEnabled {
            handleNotifications(isPeak: currentIsPeak, secondsUntilChange: secondsUntilChange)
        }
    }

    private func handleNotifications(isPeak: Bool, secondsUntilChange: TimeInterval) {
        // Notify on peak/off-peak transition
        if let lastPeak = lastNotifiedPeak, lastPeak != isPeak {
            if isPeak {
                sendNotification(title: L.notifRestrictedTitle, body: L.notifRestrictedBody)
            } else {
                sendNotification(title: L.notifFullPowerTitle, body: L.notifFullPowerBody)
            }
        }
        lastNotifiedPeak = isPeak

        // Warn 15 min before change
        let shouldWarn = secondsUntilChange <= warningMinutes && secondsUntilChange > (warningMinutes - 60)
        if shouldWarn && !lastNotifiedWarning {
            let minutes = Int(secondsUntilChange / 60)
            if isPeak {
                let n = L.notifFullPowerSoon(minutes)
                sendNotification(title: n.title, body: n.body)
            } else {
                let n = L.notifRestrictedSoon(minutes)
                sendNotification(title: n.title, body: n.body)
            }
            lastNotifiedWarning = true
        } else if !shouldWarn {
            lastNotifiedWarning = false
        }
    }

    private func sendNotification(title: String, body: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request)
    }

    private func formatCountdown(_ seconds: TimeInterval) -> String {
        let totalMinutes = Int(seconds) / 60
        let hours = totalMinutes / 60
        let minutes = totalMinutes % 60

        if hours > 24 {
            let days = hours / 24
            let remainingHours = hours % 24
            return "\(days)d \(remainingHours)h"
        } else if hours > 0 {
            return "\(hours)h \(minutes)min"
        } else {
            return "\(minutes)min"
        }
    }

    func computeLocalPeakHoursString() {
        let cal = Calendar.current
        let now = Date()

        // Create today's peak start/end in PT
        var ptStart = cal.dateComponents(in: ptTimeZone, from: now)
        ptStart.hour = peakStartHour
        ptStart.minute = 0
        ptStart.second = 0

        var ptEnd = cal.dateComponents(in: ptTimeZone, from: now)
        ptEnd.hour = peakEndHour
        ptEnd.minute = 0
        ptEnd.second = 0

        guard let startDate = cal.date(from: ptStart),
              let endDate = cal.date(from: ptEnd) else {
            peakHoursLocalString = "5:00–11:00 PT"
            return
        }

        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.timeZone = .current

        let localStart = formatter.string(from: startDate)
        let localEnd = formatter.string(from: endDate)
        let tzAbbr = TimeZone.current.abbreviation() ?? "local"

        peakHoursLocalString = "\(localStart)–\(localEnd) \(tzAbbr)"
    }

    var statusBarText: String {
        switch status {
        case .offPeak:
            return L.fullPower
        case .peak:
            return L.restricted
        case .warning:
            let minutes = Int(timeUntilChange / 60)
            if isPeak {
                return "⏱ \(minutes)min"
            } else {
                return "⏱ \(minutes)min"
            }
        }
    }

    var statusBarEmoji: String {
        switch status {
        case .offPeak: return "🟢"
        case .peak: return "🔴"
        case .warning: return "🟡"
        }
    }
}
