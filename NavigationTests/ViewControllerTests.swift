@testable import Navigation
import XCTest

final class ViewControllerTests: XCTestCase {
    func test_tappingCodePushButton_shouldPushCodeNextViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let sut: ViewController = storyboard.instantiateViewController(identifier: String(describing: ViewController.self))
        sut.loadViewIfNeeded()
        let navigation = UINavigationController(rootViewController: sut)
        
        tap(sut.codePushButton)
        
        XCTAssertNotNil(sut.navigationController) // To check if sut is contained in navigationController
    }
}
