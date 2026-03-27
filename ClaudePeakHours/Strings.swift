import Foundation

enum L {
    private static let isPolish: Bool = {
        let lang = Locale.preferredLanguages.first ?? ""
        return lang.hasPrefix("pl")
    }()

    // Status bar
    static let fullPower = isPolish ? "Pełna moc" : "Full power"
    static let restricted = isPolish ? "Zwiększone zużycie" : "Higher usage"

    // Popover header
    static let fullPowerHeader = isPolish ? "PEŁNA MOC" : "FULL POWER"
    static let restrictedHeader = isPolish ? "ZWIĘKSZONE ZUŻYCIE" : "HIGHER USAGE"

    // Popover description
    static let fullPowerDesc = isPolish
        ? "Claude działa na full — korzystaj!"
        : "Claude running at full capacity — go ahead!"
    static let restrictedDesc = isPolish
        ? "Twoje limity zużywają się szybciej niż zwykle"
        : "Your limits are being consumed faster than usual"

    // Countdown labels
    static let restrictionsIn = isPolish ? "Zwiększone zużycie za" : "Higher usage in"
    static let fullPowerIn = isPolish ? "Pełna moc za" : "Full power in"

    // Info rows
    static let restrictionHours = isPolish ? "Peak hours" : "Peak hours"
    static let workdays = isPolish ? "Dni robocze" : "Workdays"
    static let workdaysValue = isPolish ? "Pon–Pt" : "Mon–Fri"

    // Settings
    static let launchAtLogin = isPolish ? "Uruchom przy starcie" : "Launch at login"
    static let notifications = isPolish ? "Powiadomienia" : "Notifications"
    static let quit = isPolish ? "Zamknij" : "Quit"

    // Notifications
    static let notifRestrictedTitle = isPolish ? "Zwiększone zużycie" : "Higher usage"
    static let notifRestrictedBody = isPolish
        ? "Twoje limity zużywają się szybciej — oszczędzaj tokeny."
        : "Your limits are consumed faster — conserve tokens."
    static let notifFullPowerTitle = isPolish ? "Pełna moc" : "Full power"
    static let notifFullPowerBody = isPolish
        ? "Normalne zużycie limitów — Claude działa na full."
        : "Normal limit usage — Claude at full capacity."

    static func notifFullPowerSoon(_ min: Int) -> (title: String, body: String) {
        isPolish
            ? ("Pełna moc za \(min) min", "Niedługo normalne zużycie limitów.")
            : ("Full power in \(min) min", "Normal usage returning soon.")
    }

    static func notifRestrictedSoon(_ min: Int) -> (title: String, body: String) {
        isPolish
            ? ("Zwiększone zużycie za \(min) min", "Niedługo limity będą się szybciej zużywać.")
            : ("Higher usage in \(min) min", "Limits will be consumed faster soon.")
    }
}
