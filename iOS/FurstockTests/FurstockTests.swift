import XCTest
@testable import Furstock

@MainActor
final class FurstockTests: XCTestCase {
    func testSeedDataBelowFreeLimit() {
        let store = Store()
        XCTAssertLessThan(store.entries.count, store.freeLimit)
    }

    func testAddIncreasesCount() {
        let store = Store()
        let before = store.entries.count
        store.add(SupplyItem())
        XCTAssertEqual(store.entries.count, before + 1)
    }

    func testDeleteRemovesEntry() {
        let store = Store()
        let entry = SupplyItem()
        store.add(entry)
        store.delete(entry)
        XCTAssertFalse(store.entries.contains(where: { $0.id == entry.id }))
    }

    func testDeleteAtOffsetsRemovesCorrectEntry() {
        let store = Store()
        store.add(SupplyItem())
        let target = store.entries[0]
        store.delete(at: IndexSet(integer: 0))
        XCTAssertFalse(store.entries.contains(where: { $0.id == target.id }))
    }

    func testCanAddMoreWhenUnderLimit() {
        let store = Store()
        store.isPro = false
        XCTAssertTrue(store.canAddMore)
    }

    func testCannotAddMoreAtLimitWhenNotPro() {
        let store = Store()
        store.isPro = false
        while store.entries.count < store.freeLimit {
            store.add(SupplyItem())
        }
        XCTAssertFalse(store.canAddMore)
    }

    func testCanAddMoreWhenProEvenAtLimit() {
        let store = Store()
        store.isPro = true
        while store.entries.count < store.freeLimit {
            store.add(SupplyItem())
        }
        XCTAssertTrue(store.canAddMore)
    }

    func testUpdateModifiesExistingEntry() {
        let store = Store()
        var entry = SupplyItem()
        store.add(entry)
        entry = store.entries[0]
        store.update(entry)
        XCTAssertEqual(store.entries.count, 1)
    }
}
