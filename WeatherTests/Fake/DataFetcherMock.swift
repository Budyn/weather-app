import Foundation
import RxSwift
@testable import Weather

final class DataFetcherMock: DataFetching {

    private let response: String
    private let errorToSend: Error?

    init(response: String = "", errorToSend: Error? = nil) {
        self.response = response
        self.errorToSend = errorToSend
    }

    func data<T: Decodable>(for request: URLRequest) -> Single<T> {
        Single.create { [response, errorToSend] single in
            if let errorToSend = errorToSend {
                single(.failure(errorToSend))
                return Disposables.create()
            }

            let data = response.data(using: .utf8)!
            let decoded = try! JSONDecoder().decode(T.self, from: data)

            single(.success(decoded))

            return Disposables.create()
        }
    }
}
