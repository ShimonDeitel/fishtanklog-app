import Foundation

struct FishEntry: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var name: String
    var species: String
    var tankName: String
    var lastTestDate: String
    var notes: String = ""
    var createdAt: Date = Date()
}
