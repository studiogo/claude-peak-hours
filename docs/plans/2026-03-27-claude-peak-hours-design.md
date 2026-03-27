# Claude Peak Hours — Design Doc

## Problem
Anthropic dynamicznie ogranicza limity sesji Claude w godzinach peak (weekdays 5:00-11:00 PT). Brak widocznego wskaznika sprawia, ze uzytkownik nie wie kiedy oszczedzac tokeny.

## Rozwiazanie
Lekka natywna aplikacja macOS menu bar (Swift + SwiftUI) pokazujaca w czasie rzeczywistym czy jestesmy w peak czy off-peak hours.

## Architektura

### Technologia
- **Swift + SwiftUI** (popover)
- **NSStatusItem** (ikona w menu barze)
- **macOS 13+ (Ventura)** — wymagane dla SwiftUI popover
- **LSUIElement = true** — brak ikony w Dock, tylko menu bar
- **Zero zaleznosci zewnetrznych**

### Struktura plikow
```
ClaudePeakHours/
├── ClaudePeakHoursApp.swift    # @main, App lifecycle
├── AppDelegate.swift           # NSStatusItem, popover management
├── PeakHoursManager.swift      # Logika peak/off-peak + timer
├── PopoverView.swift           # SwiftUI widok popoveru
├── StatusBarController.swift   # Kontroler ikony menu bar
└── Info.plist                  # LSUIElement = true
```

### Menu Bar Display
- `🟢 OFF-PEAK` — zielone kolko + tekst (off-peak)
- `🔴 PEAK` — czerwone kolko + tekst (peak hours)
- `🟡 PEAK 5min` — zolte kolko + countdown (15 min przed zmiana)

### Popover (po kliknieciu)
- Status — duzy, wyrazny (zielony/czerwony kolor)
- Opis — krotki tekst ("Claude dziala bez limitow" / "Limity sesji aktywne")
- Countdown — ile czasu do zmiany statusu
- Godziny peak — przeliczone na lokalna strefe
- Toggle: Launch at Login (ServiceManagement)
- Toggle: Powiadomienia przed peak (UserNotifications)
- Quit button

### Logika Peak Hours
```
Peak = poniedzialek–piatek, 5:00–11:00 America/Los_Angeles
Off-peak = weekendy + wszystko poza 5:00–11:00 PT
```
- Obliczenia w strefie America/Los_Angeles
- Wyswietlanie w lokalnej strefie systemowej (auto-detekcja)
- Timer odswieza co 30 sekund

### Powiadomienia (macOS native)
- 15 min przed peak: "Peak hours za 15 minut"
- Wejscie w peak: "Peak hours — limity aktywne"
- Wyjscie z peak: "Off-peak — limity zniesione"

## Weryfikacja
1. Zbudowac projekt w Xcode (Cmd+B)
2. Uruchomic — ikona pojawia sie w menu bar
3. Kliknac — popover sie otwiera z poprawnymi danymi
4. Zmienic zegar systemowy na godzine peak — sprawdzic zmiane statusu
5. Sprawdzic ze autostart toggle dziala (System Settings > Login Items)
6. Sprawdzic powiadomienia (Notification Center)
