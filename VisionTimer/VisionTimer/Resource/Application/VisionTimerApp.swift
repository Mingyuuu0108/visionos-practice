//
//  VisionTimerApp.swift
//  VisionTimer
//
//  Created by 이민규 on 6/12/24.
//

import SwiftUI

@main
struct VisionTimerApp: App {
    var body: some Scene {
        WindowGroup {
            TimerView()
                .persistentSystemOverlays(.hidden)
                .preferredSurroundingsEffect(.systemDark)
        }
        .windowStyle(.plain)
    }
}
