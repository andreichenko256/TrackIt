import Foundation
import UIKit

enum OnboardingFactory {
    static func make() -> [PageModel] {
        return [
            .init(
                currentIndex: 0,
                title: "Welcome to Trackt It",
                description: "Start your journey to better habits. Track your daily routines and see your progress grow",
                image: .onb1
            ),
            .init(
                currentIndex: 1,
                title: "Stay Motivated",
                description: "Set reminders, celebrate small wins, and stay motivated every day to achieve your goals.",
                image: .onb2
            ),
            .init(
                currentIndex: 2,
                title: "Visualize Your Progress",
                description: "See your streaks and statistics at a glance. Watch your habits become second nature.",
                image: .onb3
            ),
            .init(
                currentIndex: 3,
                title: "Achieve Your Goals",
                description: "Build lasting habits, reach your personal goals, and make every day count.",
                image: .onb4
            )
        ]
    }
}
