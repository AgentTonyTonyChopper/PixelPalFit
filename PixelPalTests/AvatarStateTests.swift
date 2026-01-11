import XCTest
@testable import PixelPal

final class AvatarStateTests: XCTestCase {

    // MARK: - Low State Tests (0-2499)

    func testDetermineState_zeroSteps_returnsLow() {
        let result = AvatarLogic.determineState(steps: 0)
        XCTAssertEqual(result, .low)
    }

    func testDetermineState_midLow_returnsLow() {
        let result = AvatarLogic.determineState(steps: 1000)
        XCTAssertEqual(result, .low)
    }

    func testDetermineState_atLowBoundary_returnsLow() {
        let result = AvatarLogic.determineState(steps: 2499)
        XCTAssertEqual(result, .low)
    }

    // MARK: - Neutral State Tests (2500-7499)

    func testDetermineState_atNeutralStart_returnsNeutral() {
        let result = AvatarLogic.determineState(steps: 2500)
        XCTAssertEqual(result, .neutral)
    }

    func testDetermineState_midNeutral_returnsNeutral() {
        let result = AvatarLogic.determineState(steps: 5000)
        XCTAssertEqual(result, .neutral)
    }

    func testDetermineState_atNeutralEnd_returnsNeutral() {
        let result = AvatarLogic.determineState(steps: 7499)
        XCTAssertEqual(result, .neutral)
    }

    // MARK: - Vital State Tests (7500+)

    func testDetermineState_atVitalStart_returnsVital() {
        let result = AvatarLogic.determineState(steps: 7500)
        XCTAssertEqual(result, .vital)
    }

    func testDetermineState_largeSteps_returnsVital() {
        let result = AvatarLogic.determineState(steps: 50000)
        XCTAssertEqual(result, .vital)
    }

    // MARK: - Double Overload

    func testDetermineState_doubleInput_convertsCorrectly() {
        XCTAssertEqual(AvatarLogic.determineState(steps: 2500.7), .neutral)
        XCTAssertEqual(AvatarLogic.determineState(steps: 7500.1), .vital)
        XCTAssertEqual(AvatarLogic.determineState(steps: 2499.9), .low) // Truncates to 2499
    }

    // MARK: - State Descriptions

    func testAvatarState_descriptions() {
        XCTAssertEqual(AvatarState.low.description, "Low Energy")
        XCTAssertEqual(AvatarState.neutral.description, "Neutral")
        XCTAssertEqual(AvatarState.vital.description, "Vital")
    }

    // MARK: - Gender Display Names

    func testGender_displayNames() {
        XCTAssertEqual(Gender.male.displayName, "Male")
        XCTAssertEqual(Gender.female.displayName, "Female")
    }

    // MARK: - Enum Raw Values

    func testAvatarState_rawValues() {
        XCTAssertEqual(AvatarState.low.rawValue, "low")
        XCTAssertEqual(AvatarState.neutral.rawValue, "neutral")
        XCTAssertEqual(AvatarState.vital.rawValue, "vital")
    }

    func testGender_rawValues() {
        XCTAssertEqual(Gender.male.rawValue, "male")
        XCTAssertEqual(Gender.female.rawValue, "female")
    }

    // MARK: - Codable Conformance

    func testAvatarState_codable() throws {
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()

        for state in [AvatarState.low, .neutral, .vital] {
            let data = try encoder.encode(state)
            let decoded = try decoder.decode(AvatarState.self, from: data)
            XCTAssertEqual(state, decoded)
        }
    }

    func testGender_codable() throws {
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()

        for gender in Gender.allCases {
            let data = try encoder.encode(gender)
            let decoded = try decoder.decode(Gender.self, from: data)
            XCTAssertEqual(gender, decoded)
        }
    }
}
