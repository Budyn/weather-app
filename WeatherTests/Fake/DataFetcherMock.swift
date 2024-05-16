import Foundation
import RxSwift
@testable import Weather

final class DataFetcherMock: DataFetching {

    private let response: String
    private let errorToSend: Error?

    init(response: String, errorToSend: Error?) {
        self.response = response
        self.errorToSend = errorToSend
    }

    func data<T: Decodable>(for request: URLRequest) -> Single<T> {
        if let errorToSend = errorToSend { return Single.error(errorToSend) }

        return Single.create { [response] single in
            let data = response.data(using: .utf8)!
            let decoded = try! JSONDecoder().decode(T.self, from: data)

            single(.success(decoded))

            return Disposables.create()
        }
    }
}
