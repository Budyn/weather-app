import RxBlocking
import RxSwift
import RxTest
@testable import Weather
import XCTest

final class GeocodingServiceTests: XCTestCase {

    private var disposeBag: DisposeBag!

    override func setUp() {
        super.setUp()
        disposeBag = DisposeBag()
    }

    override func tearDown() {
        disposeBag = nil
        super.tearDown()
    }

    func testGetCoordinatesReturnsCoordinates() {
        let dataFetcher = DataFetcherMock(response: fakeCoordinatesResponse)
        let sut = GeocodingServiceImpl(dataFetcher: dataFetcher)

        let expectation = expectation(description: "Should send data")

        sut.getCoordinates(for: "paris").asObservable()
            .subscribe(
                onNext: { response in
                    XCTAssertNotNil(response)
                    XCTAssertTrue(response!.latitude.isNearlyEqual(to: 51.5073219))
                    XCTAssertTrue(response!.longitude.isNearlyEqual(to: -0.1276474))
                    expectation.fulfill()
                },
                onError: { _ in
                    XCTFail("Should not happen")
                }
            )
            .disposed(by: disposeBag)

        waitForExpectations(timeout: 0.5) { error in
            guard error == nil else {
                XCTFail(error!.localizedDescription)
                return
            }
        }
    }

    func testGetCoordinatesWihCorruptedDataReturnsError() {
        let dataFetcher = DataFetcherMock(errorToSend: DataFetchingError.decoding)
        let sut = GeocodingServiceImpl(dataFetcher: dataFetcher)

        let expectation = expectation(description: "Should send error")

        sut.getCoordinates(for: "paris").asObservable()
            .subscribe(
                onNext: { _ in
                    XCTFail("Should not happen")
                },
                onError: { error in
                    switch error as? DataFetchingError {
                    case .decoding:
                        expectation.fulfill()
                    default:
                        XCTFail("Wrong error type")
                    }
                }
            )
            .disposed(by: disposeBag)

        waitForExpectations(timeout: 0.5) { error in
            guard error == nil else {
                XCTFail(error!.localizedDescription)
                return
            }
        }
    }
}

private extension FloatingPoint {
    func isNearlyEqual(to value: Self) -> Bool {
        return abs(self - value) <= .ulpOfOne
    }
}
