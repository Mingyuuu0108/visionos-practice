//
//  NapNapApp.swift
//  NapNap
//
//  Created by 이민규 on 6/18/24.
//

import SwiftUI

@main
struct NapNapApp: App {
    var body: some Scene {
        WindowGroup {
            TimerView()
                .preferredSurroundingsEffect(.systemDark)
                .persistentSystemOverlays(.hidden)
        }
        .windowStyle(.plain)

        ImmersiveSpace(id: "ImmersiveSpace") {
            EmptyView()
        }.immersionStyle(selection: .constant(.full), in: .full)
    }
}
