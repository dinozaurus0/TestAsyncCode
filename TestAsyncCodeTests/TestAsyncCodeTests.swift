import XCTest
import TestAsyncCode
import ViewInspector
import SwiftUI

final class TestAsyncCodeTests: XCTestCase {
    func test_whenButtonIsTapped_shouldDisableButton() throws {
        // Arrange
        var sut = AsyncButton(operation: {})
        var isLoading = try sut.findButton().isDisabled()
        XCTAssertFalse(isLoading, "precondition")

        // Act
        load(&sut) { view in
            try view.button().tap()
            isLoading = try view.button().isDisabled()
        }

        // Assert
        XCTAssertTrue(isLoading)
    }

    private func load(
        _ sut: inout AsyncButton,
        using: @escaping ((InspectableView<ViewType.View<AsyncButton>>)) throws -> Void
    ) {
        let expectation = sut.on(\.viewInspectHook, perform: using)
        ViewHosting.host(view: sut)
        wait(for: [expectation], timeout: 0.01)
    }
}

extension View {
    func findButton() throws -> InspectableView<ViewType.Button> {
        try inspect().find(ViewType.Button.self)
    }
}
