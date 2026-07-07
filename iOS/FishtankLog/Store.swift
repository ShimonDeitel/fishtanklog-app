import Foundation
import Combine

@MainActor
final class Store: ObservableObject {
    @Published var entries: [FishEntry] = []
    @Published var isPro: Bool = false

    /// Free-tier item cap. Always kept well above seed data count so a fresh
    /// install never hits the paywall immediately.
    static let freeLimit = 10

    private let fileURL: URL

    init() {
        let appSupport = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let dir = appSupport.appendingPathComponent("FishtankLog", isDirectory: true)
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        fileURL = dir.appendingPathComponent("entries.json")
        load()
    }

    var canAddMore: Bool {
        isPro || entries.count < Store.freeLimit
    }

    func add(_ entry: FishEntry) {
        guard canAddMore else { return }
        entries.append(entry)
        save()
    }

    func update(_ entry: FishEntry) {
        guard let idx = entries.firstIndex(where: { $0.id == entry.id }) else { return }
        entries[idx] = entry
        save()
    }

    func delete(at offsets: IndexSet) {
        entries.remove(atOffsets: offsets)
        save()
    }

    func delete(_ entry: FishEntry) {
        entries.removeAll { $0.id == entry.id }
        save()
    }

    private func load() {
        if let data = try? Data(contentsOf: fileURL),
           let decoded = try? JSONDecoder().decode([FishEntry].self, from: data) {
            entries = decoded
        } else {
            entries = [
        FishEntry(name: "Neon Tetra", species: "Neon Tetra", tankName: "Reef Tank", lastTestDate: ""),
        FishEntry(name: "Clownfish", species: "Clownfish", tankName: "Reef Tank", lastTestDate: ""),
        FishEntry(name: "Java Fern", species: "Java Fern", tankName: "Planted 40g", lastTestDate: "")
            ]
            save()
        }
    }

    private func save() {
        if let data = try? JSONEncoder().encode(entries) {
            try? data.write(to: fileURL, options: .atomic)
        }
    }
}
