// democal: create / list / delete WallCal demo calendars and reminders.
// usage: democal list | create <statefile> | delete <statefile>
import EventKit
import Foundation

let store = EKEventStore()
let args = CommandLine.arguments
let mode = args.count > 1 ? args[1] : "list"

func requestAccess() {
    let sem = DispatchSemaphore(value: 0)
    var okE = false, okR = false
    store.requestFullAccessToEvents { g, e in okE = g; if let e { print("events err:", e) }; sem.signal() }
    sem.wait()
    store.requestFullAccessToReminders { g, e in okR = g; if let e { print("reminders err:", e) }; sem.signal() }
    sem.wait()
    print("access events=\(okE) reminders=\(okR)")
    if !okE || !okR { exit(2) }
}

func pickSource(for type: EKEntityType) -> EKSource {
    let sources = store.sources
    if let local = sources.first(where: { $0.sourceType == .local }) { return local }
    // iCloud hides the local source; fall back to the default calendar's source.
    let def = type == .event ? store.defaultCalendarForNewEvents : store.defaultCalendarForNewReminders()
    return def!.source
}

func cal(_ title: String, _ hex: String, _ type: EKEntityType) throws -> EKCalendar {
    let c = EKCalendar(for: type, eventStore: store)
    c.title = title
    c.source = pickSource(for: type)
    let v = Int(hex, radix: 16)!
    c.cgColor = CGColor(red: CGFloat((v >> 16) & 255) / 255, green: CGFloat((v >> 8) & 255) / 255, blue: CGFloat(v & 255) / 255, alpha: 1)
    try store.saveCalendar(c, commit: true)
    return c
}

let calendar = Calendar.current
func day(_ d: Int, _ h: Int = 0, _ m: Int = 0) -> Date {
    // Days in the current month.
    var comps = calendar.dateComponents([.year, .month], from: Date())
    comps.day = d; comps.hour = h; comps.minute = m
    return calendar.date(from: comps)!
}

requestAccess()

switch mode {
case "list":
    for s in store.sources { print("source:", s.title, s.sourceType.rawValue) }
    for c in store.calendars(for: .event) { print("event-cal", c.calendarIdentifier, c.title, c.source.title) }
    for c in store.calendars(for: .reminder) { print("reminder-cal", c.calendarIdentifier, c.title, c.source.title) }

case "setup":
    let made = [try cal("Work", "3B82F6", .event), try cal("Personal", "F2683F", .event), try cal("Fitness", "22C55E", .event)]
    let initial = ["events": made.map(\.calendarIdentifier), "reminders": [String]()]
    try JSONSerialization.data(withJSONObject: initial, options: .prettyPrinted).write(to: URL(fileURLWithPath: args[2]))
    fallthrough

case "create":
    let statePath = args[2]
    let ids = (try JSONSerialization.jsonObject(with: Data(contentsOf: URL(fileURLWithPath: statePath))) as! [String: [String]])["events"]!
    let work = store.calendar(withIdentifier: ids[0])!
    let personal = store.calendar(withIdentifier: ids[1])!
    let fitness = store.calendar(withIdentifier: ids[2])!

    func ev(_ c: EKCalendar, _ title: String, _ start: Date, mins: Int = 60, allDay: Bool = false, location: String? = nil) throws {
        let e = EKEvent(eventStore: store)
        e.calendar = c; e.title = title; e.startDate = start
        e.endDate = allDay ? start : start.addingTimeInterval(TimeInterval(mins * 60))
        e.isAllDay = allDay; e.location = location
        try store.save(e, span: .thisEvent, commit: false)
    }

    let monthRange = calendar.range(of: .day, in: .month, for: Date())!
    for d in monthRange {
        let wd = calendar.component(.weekday, from: day(d))
        let weekday = wd >= 2 && wd <= 6
        if weekday { try ev(work, "Team standup", day(d, 9, 30), mins: 15) }
        if wd == 2 { try ev(work, "Sprint planning", day(d, 11), mins: 60) }
        if wd == 3 || wd == 5 { try ev(fitness, "Gym", day(d, 7), mins: 60) }
        if wd == 4 { try ev(work, "Design review", day(d, 14), mins: 60) }
        if wd == 6 { try ev(work, "1:1 with Alex", day(d, 16), mins: 30) }
        if wd == 7 { try ev(fitness, "Morning run", day(d, 8), mins: 45) }
    }
    try ev(personal, "Lunch with Sam", day(3, 12, 30), mins: 60, location: "Blue Bottle")
    try ev(personal, "Dentist", day(6, 10), mins: 45)
    try ev(work, "Product launch 🚀", day(10), allDay: true)
    try ev(work, "Launch retro", day(12, 15), mins: 60)
    try ev(personal, "Mom’s birthday 🎂", day(14), allDay: true)
    try ev(personal, "Dinner with Jamie", day(14, 19), mins: 120)
    try ev(fitness, "Yoga class", day(16, 18, 30), mins: 60)
    try ev(work, "Quarterly review", day(18, 13), mins: 90)
    try ev(personal, "Book club", day(19, 19), mins: 90)
    try ev(personal, "Flight to Tokyo ✈️", day(21, 10, 40), mins: 180)
    try ev(personal, "Tokyo trip", day(22), allDay: true)
    try ev(personal, "Tokyo trip", day(23), allDay: true)
    try ev(work, "Client workshop", day(25, 10), mins: 120)
    try ev(personal, "Haircut", day(27, 17), mins: 45)
    try ev(work, "Team dinner 🍜", day(28, 19), mins: 120)
    try store.commit()

    print("events created")

case "reminders":
    let statePath = args[2]
    let errands = try cal("Errands", "E5452C", .reminder)
    let monthRange = calendar.range(of: .day, in: .month, for: Date())!
    let reminders: [(String, Int?)] = [
        ("Pay rent", 1), ("Renew passport", 5), ("Buy Mom’s gift", 12), ("Book Tokyo hotel", 8),
        ("Send invoice to Acme", 3), ("Water the plants", 4), ("Call the bank", nil), ("Pick up dry cleaning", 2),
    ]
    let today = calendar.component(.day, from: Date())
    for (title, offset) in reminders {
        let r = EKReminder(eventStore: store)
        r.calendar = errands; r.title = title
        if let offset {
            let d = min(today + offset, monthRange.upperBound - 1)
            r.dueDateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: day(d, 18))
        }
        try store.save(r, commit: false)
    }
    try store.commit()

    var state = try JSONSerialization.jsonObject(with: Data(contentsOf: URL(fileURLWithPath: statePath))) as! [String: [String]]
    state["reminders"] = [errands.calendarIdentifier]
    try JSONSerialization.data(withJSONObject: state, options: .prettyPrinted).write(to: URL(fileURLWithPath: statePath))
    print("reminders created in", errands.source.title)

case "delete":
    let data = try Data(contentsOf: URL(fileURLWithPath: args[2]))
    let state = try JSONSerialization.jsonObject(with: data) as! [String: [String]]
    for id in (state["events"] ?? []) + (state["reminders"] ?? []) {
        if let c = store.calendar(withIdentifier: id) { try store.removeCalendar(c, commit: true); print("deleted", c.title) }
    }

default:
    print("unknown mode")
}
