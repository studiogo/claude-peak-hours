import Foundation

enum L {
    private static let isPolish: Bool = {
        let lang = Locale.preferredLanguages.first ?? ""
        return lang.hasPrefix("pl")
    }()

    // Status bar
    static let fullPower = isPolish ? "Pełna moc" : "Full power"
    static let restricted = isPolish ? "Ograniczenia" : "Restricted"

    // Popover header
    static let fullPowerHeader = isPolish ? "PEŁNA MOC" : "FULL POWER"
    static let restrictedHeader = isPolish ? "OGRANICZENIA" : "RESTRICTED"

    // Popover description
    static let fullPowerDesc = isPolish
        ? "Claude działa na full — korzystaj!"
        : "Claude running at full capacity — go ahead!"
    static let restrictedDesc = isPolish
        ? "Limity sesji aktywne — oszczędzaj tokeny"
        : "Session limits active — conserve your tokens"

    // Countdown labels
    static let restrictionsIn = isPolish ? "Ograniczenia za" : "Restrictions in"
    static let fullPowerIn = isPolish ? "Pełna moc za" : "Full power in"

    // Info rows
    static let restrictionHours = isPolish ? "Ograniczenia" : "Restrictions"
    static let workdays = isPolish ? "Dni robocze" : "Workdays"
    static let workdaysValue = isPolish ? "Pon–Pt" : "Mon–Fri"

    // Settings
    static let launchAtLogin = isPolish ? "Uruchom przy starcie" : "Launch at login"
    static let notifications = isPolish ? "Powiadomienia" : "Notifications"
    static let quit = isPolish ? "Zamknij" : "Quit"

    // Notifications
    static let notifRestrictedTitle = isPolish ? "Ograniczenia aktywne" : "Restrictions active"
    static let notifRestrictedBody = isPolish
        ? "Claude działa wolniej — oszczędzaj tokeny."
        : "Claude is slower — conserve your tokens."
    static let notifFullPowerTitle = isPolish ? "Pełna moc" : "Full power"
    static let notifFullPowerBody = isPolish
        ? "Koniec ograniczeń — Claude działa na full."
        : "Restrictions lifted — Claude at full capacity."

    static func notifFullPowerSoon(_ min: Int) -> (title: String, body: String) {
        isPolish
            ? ("Pełna moc za \(min) min", "Niedługo koniec ograniczeń.")
            : ("Full power in \(min) min", "Restrictions ending soon.")
    }

    static func notifRestrictedSoon(_ min: Int) -> (title: String, body: String) {
        isPolish
            ? ("Ograniczenia za \(min) min", "Niedługo limity sesji Claude.")
            : ("Restrictions in \(min) min", "Session limits starting soon.")
    }
}
