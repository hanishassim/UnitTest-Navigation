@testable import Navigation
import XCTest
import ViewControllerPresentationSpy

final class ViewControllerTests: XCTestCase {
    private var sut: ViewController!
    
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyboard.instantiateViewController(identifier: String(describing: ViewController.self))
        sut.loadViewIfNeeded()
    }
    
    override func tearDown() {
        executeRunLoop() // To give the window chance to disappear for segue-based navigation
        sut = nil
        super.tearDown()
    }
    
    /// A good test name must have acton and then the outcome or effect
    func test_tappingCodePushButton_shouldPushCodeNextViewController() {
        let navigation = UINavigationController(rootViewController: sut)
        
        tap(sut.codePushButton)
        
        executeRunLoop() // Needed for handling event like push navigation to allow it to take effect
        
        XCTAssertNotNil(sut.navigationController) // To check if sut is contained in navigationController
        XCTAssertEqual(navigation.viewControllers.count, 2, "navigation stack")
        
        let pushedVC = navigation.viewControllers.last
        guard let codeNextVC = pushedVC as? CodeNextViewController else {
            XCTFail("Expected CodeNextViewController, " + "but was \(String(describing: pushedVC))")
            return
        }
        XCTAssertEqual(codeNextVC.label.text, "Pushed from code")
    }
    
    /// This test is incorrect because the VC is not deinitialized,
    /// so it may have potential memory leak (breaking clean room goals)
    func test_INCORRECT_tappingCodeModalButton_shouldPresentCodeNextViewController() {
        UIApplication.shared.windows.first?.rootViewController = sut
        
        tap(sut.codeModalButton)
        
        let presentedVC = sut.presentedViewController
        guard let codeNextVC = presentedVC as? CodeNextViewController else {
            XCTFail("Expected CodeNextViewController, " + "but was \(String(describing: presentedVC))")
            return
        }
        XCTAssertEqual(codeNextVC.label.text, "Modal from code")
    }
    
    @MainActor
    func test_tappingCodeModalButton_shouldPresentCodeNextViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let sut: ViewController = storyboard.instantiateViewController(identifier: String(describing: ViewController.self))
        sut.loadViewIfNeeded()

        let presentationVerifier = PresentationVerifier() // Init must be before the tap action to allow interception
                
        tap(sut.codeModalButton)
        
        let codeNextVC: CodeNextViewController? = presentationVerifier.verify(animated: true, presentingViewController: sut) // Use method swizzling to intercept calls to present view controllers, it capture arguments but without presenting anything
        XCTAssertEqual(codeNextVC?.label.text, "Modal from code")
    }
    
    @MainActor
    func test_tappingSeguePushButton_shouldShowSegueNextViewController() {
        let presentationVerifier = PresentationVerifier()
        
        putInWindow(sut) // To load the view controller into visible UIWindow
        tap(sut.seguePushButton)
        
        let segueNextVC: SegueNextViewController? = presentationVerifier.verify(animated: true, presentingViewController: sut)
        XCTAssertEqual(segueNextVC?.labelText, "Pushed from segue")
    }
}

/// This class only to use for view controller that comes from XIB or code-based, not storyboard
/// as storyboards stores an instance of particular class
private class TestableViewController: ViewController {
    var presentCallCount = 0
    var presentArgsViewController: [UIViewController] = []
    var presentArgsAnimated: [Bool] = []
    var presentArgsClosure: [(() -> Void)?] = []
    
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        presentCallCount += 1
        presentArgsViewController.append(viewControllerToPresent)
        presentArgsAnimated.append(flag)
        presentArgsClosure.append(completion)
    }
}
