//
//  MotionSensorApp.swift
//  MotionSensor
//
//  Created by Dor Mizrachi on 27/05/2025.
//

import SwiftUI

@main
struct MotionSensorApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onOpenURL { url in
                    handleURL(url)
                }
        }
    }
    
    private func handleURL(_ url: URL) {
        guard url.scheme == "motionsensor" else { return }
        
        switch url.host {
        case "dashboard":
            // Navigate to dashboard - since ContentView already shows ControlView which contains DashBoard,
            // we don't need to do anything special here
            print("Opening dashboard from Live Activity")
        default:
            print("Unknown URL: \(url)")
        }
    }
}
