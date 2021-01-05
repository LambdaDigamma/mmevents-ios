import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(mmevents_iosTests.allTests),
    ]
}
#endif
