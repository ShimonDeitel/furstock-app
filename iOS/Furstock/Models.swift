import Foundation

struct SupplyItem: Identifiable, Codable, Equatable {
    let id: UUID
    var createdAt: Date
    var itemName: String
    var category: String
    var quantity: Double
    var unit: String

    init(id: UUID = UUID(), createdAt: Date = Date(), itemName: String = "", category: String = "", quantity: Double = 0, unit: String = "") {
        self.id = id
        self.createdAt = createdAt
        self.itemName = itemName
        self.category = category
        self.quantity = quantity
        self.unit = unit
    }
}
