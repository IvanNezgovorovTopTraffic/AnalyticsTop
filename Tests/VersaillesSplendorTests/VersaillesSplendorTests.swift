import XCTest
@testable import VersaillesSplendor

// MARK: -- VersaillesSplendorTests

final class VersaillesSplendorTests: XCTestCase {
    
    // MARK: -- Test Functions
    
    func testChateauKeeperGeneratesUniqueSeal() throws {
        // Проверяем, что хранитель замка генерирует уникальную печать
        let firstSeal = ChateauKeeper.sovereign.getUniqueChateauSeal()
        let secondSeal = ChateauKeeper.sovereign.getUniqueChateauSeal()
        
        // Печати должны быть одинаковыми (кэшируются)
        XCTAssertEqual(firstSeal, secondSeal, "Королевская печать должна кэшироваться")
        XCTAssertFalse(firstSeal.isEmpty, "Королевская печать не должна быть пустой")
    }
    
    func testVersaillesSplendorPublicAPI() throws {
        // Проверяем, что публичные методы доступны
        let chateauSeal = VersaillesSplendor.obtainChateauSeal()
        XCTAssertFalse(chateauSeal.isEmpty, "Королевская печать должна быть получена")
    }
}

