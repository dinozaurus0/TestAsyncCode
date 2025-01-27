import XCTest
import TestAsyncCode
import ViewInspector

final class TestAsyncCodeTests: XCTestCase {
    func test_whenButtonIsTapped_shouldDisableButton() {
        // Arrange
        var sut = AsyncButton(operation: {})
        var isLoading: Bool = false

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
