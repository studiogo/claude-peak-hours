import Cocoa
import SwiftUI
import UserNotifications
import Combine

final class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem!
    private var popover: NSPopover!
    private var manager: PeakHoursManager!
    private var cancellables = Set<AnyCancellable>()
    private var eventMonitor: Any?

    func applicationDidFinishLaunching(_ notification: Notification) {
        manager = PeakHoursManager()

        // Setup status bar item
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        updateStatusBarTitle()

        if let button = statusItem.button {
            button.action = #selector(togglePopover)
            button.target = self
        }

        // Setup popover
        popover = NSPopover()
        popover.contentSize = NSSize(width: 260, height: 320)
        popover.behavior = .transient
        popover.contentViewController = NSHostingController(rootView: PopoverView(manager: manager))

        // Observe manager changes to update status bar
        manager.$status
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in self?.updateStatusBarTitle() }
            .store(in: &cancellables)

        manager.$timeUntilChange
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in self?.updateStatusBarTitle() }
            .store(in: &cancellables)

        // Request notification permission
        if manager.notificationsEnabled {
            requestNotificationPermission()
        }

        // Monitor for clicks outside popover to close it
        eventMonitor = NSEvent.addGlobalMonitorForEvents(matching: [.leftMouseDown, .rightMouseDown]) { [weak self] _ in
            if let popover = self?.popover, popover.isShown {
                popover.performClose(nil)
            }
        }
    }

    func applicationWillTerminate(_ notification: Notification) {
        if let monitor = eventMonitor {
            NSEvent.removeMonitor(monitor)
        }
    }

    private func updateStatusBarTitle() {
        guard let button = statusItem.button else { return }
        button.title = "\(manager.statusBarEmoji) \(manager.statusBarText)"
    }

    @objc private func togglePopover() {
        guard let button = statusItem.button else { return }

        if popover.isShown {
            popover.performClose(nil)
        } else {
            manager.update()
            manager.computeLocalPeakHoursString()
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
            NSApp.activate(ignoringOtherApps: true)
        }
    }

    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { _, _ in }
    }
}
