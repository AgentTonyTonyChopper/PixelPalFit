import Foundation
import WidgetKit

struct SharedData {
    static let appGroupId = "group.com.pixelpalfit.app"

    struct Keys {
        static let avatarState = "avatarState"
        static let lastUpdateDate = "lastUpdateDate"
        static let currentSteps = "currentSteps"
        static let gender = "gender"
    }

    static var userDefaults: UserDefaults? {
        return UserDefaults(suiteName: appGroupId)
    }

    // MARK: - State

    static func saveState(state: AvatarState, steps: Double) {
        guard let defaults = userDefaults else { return }
        defaults.set(state.rawValue, forKey: Keys.avatarState)
        defaults.set(steps, forKey: Keys.currentSteps)
        defaults.set(Date(), forKey: Keys.lastUpdateDate)

        // Reload widget
        WidgetCenter.shared.reloadAllTimelines()
    }

    static func loadState() -> AvatarState {
        guard let defaults = userDefaults,
              let rawValue = defaults.string(forKey: Keys.avatarState),
              let state = AvatarState(rawValue: rawValue) else {
            return .low // Default for new users
        }
        return state
    }

    static func loadSteps() -> Int {
        guard let defaults = userDefaults else { return 0 }
        return defaults.integer(forKey: Keys.currentSteps)
    }

    static func loadLastUpdateDate() -> Date? {
        guard let defaults = userDefaults else { return nil }
        return defaults.object(forKey: Keys.lastUpdateDate) as? Date
    }

    // MARK: - Gender

    static func saveGender(_ gender: Gender) {
        guard let defaults = userDefaults else { return }
        defaults.set(gender.rawValue, forKey: Keys.gender)
    }

    static func loadGender() -> Gender? {
        guard let defaults = userDefaults,
              let rawValue = defaults.string(forKey: Keys.gender),
              let gender = Gender(rawValue: rawValue) else {
            return nil // Not yet selected
        }
        return gender
    }

    static var hasSelectedGender: Bool {
        return loadGender() != nil
    }
}
