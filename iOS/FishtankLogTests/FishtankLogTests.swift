import XCTest
@testable import FishtankLog

@MainActor
final class FishtankLogTests: XCTestCase {
    var store: Store!

    override func setUp() {
        super.setUp()
        store = Store()
        store.entries = []
    }

    func testAddEntry() {
        let entry = FishEntry(name: "Test", species: "A", tankName: "B", lastTestDate: "")
        store.add(entry)
        XCTAssertEqual(store.entries.count, 1)
    }

    func testDeleteEntry() {
        let entry = FishEntry(name: "Test", species: "A", tankName: "B", lastTestDate: "")
        store.add(entry)
        store.delete(entry)
        XCTAssertTrue(store.entries.isEmpty)
    }

    func testUpdateEntry() {
        var entry = FishEntry(name: "Test", species: "A", tankName: "B", lastTestDate: "")
        store.add(entry)
        entry.name = "Updated"
        store.update(entry)
        XCTAssertEqual(store.entries.first?.name, "Updated")
    }

    func testFreeLimitEnforced() {
        for i in 0..<Store.freeLimit {
            store.add(FishEntry(name: "Item \(i)", species: "", tankName: "", lastTestDate: ""))
        }
        XCTAssertEqual(store.entries.count, Store.freeLimit)
        XCTAssertFalse(store.canAddMore)
        store.add(FishEntry(name: "Overflow", species: "", tankName: "", lastTestDate: ""))
        XCTAssertEqual(store.entries.count, Store.freeLimit)
    }

    func testProUnlocksUnlimited() {
        store.isPro = true
        for i in 0..<(Store.freeLimit + 5) {
            store.add(FishEntry(name: "Item \(i)", species: "", tankName: "", lastTestDate: ""))
        }
        XCTAssertEqual(store.entries.count, Store.freeLimit + 5)
    }

    func testSeedDataBelowFreeLimit() {
        let fresh = Store()
        XCTAssertLessThan(fresh.entries.count, Store.freeLimit)
    }

    func testDeleteAtOffsets() {
        store.add(FishEntry(name: "A", species: "", tankName: "", lastTestDate: ""))
        store.add(FishEntry(name: "B", species: "", tankName: "", lastTestDate: ""))
        store.delete(at: IndexSet(integer: 0))
        XCTAssertEqual(store.entries.count, 1)
        XCTAssertEqual(store.entries.first?.name, "B")
    }

    func testCanAddMoreInitiallyTrue() {
        XCTAssertTrue(store.canAddMore)
    }
}
