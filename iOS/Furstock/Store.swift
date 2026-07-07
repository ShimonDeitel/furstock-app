import Foundation
import Combine

@MainActor
final class Store: ObservableObject {
    @Published private(set) var entries: [SupplyItem] = []
    @Published var isPro: Bool = false

    /// Free-tier cap. Kept comfortably above seed count so a fresh install
    /// never hits the paywall on first launch.
    let freeLimit = 40

    private let fileURL: URL

    init() {
        let dir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        fileURL = dir.appendingPathComponent("furstock_entries.json")
        load()
    }

    var canAddMore: Bool {
        isPro || entries.count < freeLimit
    }

    func add(_ entry: SupplyItem) {
        entries.insert(entry, at: 0)
        save()
    }

    func update(_ entry: SupplyItem) {
        guard let idx = entries.firstIndex(where: { $0.id == entry.id }) else { return }
        entries[idx] = entry
        save()
    }

    func delete(at offsets: IndexSet) {
        entries.remove(atOffsets: offsets)
        save()
    }

    func delete(_ entry: SupplyItem) {
        entries.removeAll { $0.id == entry.id }
        save()
    }

    private func load() {
        if let data = try? Data(contentsOf: fileURL),
           let decoded = try? JSONDecoder().decode([SupplyItem].self, from: data) {
            entries = decoded
        } else {
            entries = Store.seedData
        }
    }

    func save() {
        if let data = try? JSONEncoder().encode(entries) {
            try? data.write(to: fileURL, options: .atomic)
        }
    }

    static var seedData: [SupplyItem] {
        [
        SupplyItem(itemName: "Item Name 1", category: "Category 1", quantity: 1.0, unit: "Unit 1"),
        SupplyItem(itemName: "Item Name 2", category: "Category 2", quantity: 2.0, unit: "Unit 2"),
        SupplyItem(itemName: "Item Name 3", category: "Category 3", quantity: 3.0, unit: "Unit 3"),
        SupplyItem(itemName: "Item Name 4", category: "Category 4", quantity: 4.0, unit: "Unit 4"),
        SupplyItem(itemName: "Item Name 5", category: "Category 5", quantity: 5.0, unit: "Unit 5"),
        SupplyItem(itemName: "Item Name 6", category: "Category 6", quantity: 6.0, unit: "Unit 6"),
        SupplyItem(itemName: "Item Name 7", category: "Category 7", quantity: 7.0, unit: "Unit 7"),
        SupplyItem(itemName: "Item Name 8", category: "Category 8", quantity: 8.0, unit: "Unit 8")
        ]
    }
}
