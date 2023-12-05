import Foundation
import ReactorKit
import RxCocoa
import RxFlow
import RxSwift

class MainReactor: Reactor {
    enum Action {
        case searchButtonDidTap
        case logoutButtonDidTap
    }

    enum Mutation {}

    struct State {
        var count: Int = 0
    }

    var initialState: State

    init() {
        initialState = State(
            count: 0
        )
    }
}

// MARK: - Mutate

extension MainReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .searchButtonDidTap:
            return seachButtonDidTap()
        case .logoutButtonDidTap:
            return logoutButtonDidTap()
        }
    }
}

// MARK: - Reduce

extension MainReactor {
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {}
    }
}

private extension MainReactor {
    func seachButtonDidTap() -> Observable<Mutation> {
        //        self.steps.accept(<#T##Element#>)

        return .empty()
    }

    func logoutButtonDidTap() -> Observable<Mutation> {
        //        self.steps.accept(<#T##Element#>)
        return .empty()
    }
}
