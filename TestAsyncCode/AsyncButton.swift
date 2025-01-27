import SwiftUI

public struct AsyncButton: View {
    @State private var isLoading: Bool = false
    private let operation: () async throws -> Void
    public var viewInspectHook: ((Self) -> Void)?

    public init(operation: @escaping () -> Void) {
        self.operation = operation
    }

    public var body: some View {
        Button(
            action: {
                Task {
                    isLoading = true
                    try await operation()
//                    isLoading = false // A second problem would be how to test the fact that state is changed while operation is executed
                }
            },
            label: {
                Text("Tap Me")
            }
        )
        .disabled(isLoading)
        .onAppear { self.viewInspectHook?(self) }
    }
}
