//
//  LiveActivityManager.swift
//  MotionSensor
//
//  Created by Dor Mizrachi on 28/05/2025.
//

import ActivityKit
import Foundation

// Import the Live Activity attributes from the extension
// Note: The MotionDetectorLiveActivityAttributes is defined in the Live Activity extension

@available(iOS 16.1, *)
class LiveActivityManager: ObservableObject {
    @Published var isLiveActivityActive = false
    @Published var debugMessage = ""
    
    private var currentActivity: Activity<MotionDetectorLiveActivityAttributes>?
    
    static let shared = LiveActivityManager()
    
    private init() {
        // Check if there's already an active Live Activity
        checkForActiveActivity()
    }
    
    private func checkForActiveActivity() {
        currentActivity = Activity<MotionDetectorLiveActivityAttributes>.activities.first
        isLiveActivityActive = currentActivity != nil
        
        if let activity = currentActivity {
            print("Found existing Live Activity: \(activity.id)")
        } else {
            print("No existing Live Activities found")
        }
    }
    
    func startLiveActivity(sensorName: String, deviceName: String, isConnected: Bool) {
        print("🚀 Attempting to start Live Activity...")
        
        let authInfo = ActivityAuthorizationInfo()
        guard authInfo.areActivitiesEnabled else {
            let message = "❌ Live Activities are not enabled. Please enable them in Settings > Face ID & Passcode > Live Activities"
            print(message)
            debugMessage = message
            return
        }
        
        // Don't start if already active
        if let existingActivity = currentActivity {
            let message = "⚠️ Live Activity already active: \(existingActivity.id)"
            print(message)
            debugMessage = message
            return
        }
        
        let attributes = MotionDetectorLiveActivityAttributes(sensorName: sensorName)
        let contentState = MotionDetectorLiveActivityAttributes.ContentState(
            isMotionDetected: false,
            deviceName: deviceName,
            lastUpdated: Date(),
            connectionStatus: isConnected
        )
        
        do {
            print("📱 Creating Live Activity with:")
            print("  - Sensor Name: \(sensorName)")
            print("  - Device Name: \(deviceName)")
            print("  - Connected: \(isConnected)")
            print("  - Content State: \(contentState)")
            
            currentActivity = try Activity<MotionDetectorLiveActivityAttributes>.request(
                attributes: attributes,
                content: .init(state: contentState, staleDate: nil),
                pushType: nil
            )
            
            isLiveActivityActive = true
            let message = "✅ Live Activity started successfully! ID: \(currentActivity?.id ?? "unknown")"
            print(message)
            debugMessage = message
            
            // Log the activity details
            if let activity = currentActivity {
                print("📊 Activity Details:")
                print("  - ID: \(activity.id)")
                print("  - Attributes: \(activity.attributes)")
                print("  - Content State: \(activity.content.state)")
                print("  - Activity State: \(activity.activityState)")
            }
            
        } catch {
            let message = "❌ Failed to start Live Activity: \(error.localizedDescription)"
            print(message)
            debugMessage = message
            
            // More detailed error information
            print("🔍 Detailed Error Information:")
            print("  - Error: \(error)")
            print("  - Localized Description: \(error.localizedDescription)")
            
            if let activityError = error as? ActivityKit.ActivityAuthorizationError {
                print("  - ActivityKit Error Details: \(activityError)")
            }
        }
    }
    
    // Test function to create a Live Activity with test data
    func startTestLiveActivity() {
        print("🧪 Starting Test Live Activity...")
        startLiveActivity(
            sensorName: "🧪 Test Motion Sensor",
            deviceName: "Test-ESP32-Device",
            isConnected: true
        )
    }
    
    func updateLiveActivity(isMotionDetected: Bool, deviceName: String, isConnected: Bool) {
        guard let activity = currentActivity else {
            let message = "⚠️ No active Live Activity to update"
            print(message)
            debugMessage = message
            return
        }
        
        let updatedContentState = MotionDetectorLiveActivityAttributes.ContentState(
            isMotionDetected: isMotionDetected,
            deviceName: deviceName,
            lastUpdated: Date(),
            connectionStatus: isConnected
        )
        
        Task {
            do {
                await activity.update(.init(state: updatedContentState, staleDate: nil))
                let message = "🔄 Live Activity updated - Motion: \(isMotionDetected), Connected: \(isConnected)"
                print(message)
                DispatchQueue.main.async {
                    self.debugMessage = message
                }
            } catch {
                let message = "❌ Failed to update Live Activity: \(error.localizedDescription)"
                print(message)
                DispatchQueue.main.async {
                    self.debugMessage = message
                }
            }
        }
    }
    
    func stopLiveActivity() {
        guard let activity = currentActivity else {
            let message = "⚠️ No active Live Activity to stop"
            print(message)
            debugMessage = message
            return
        }
        
        Task {
            do {
                await activity.end(nil, dismissalPolicy: .immediate)
                DispatchQueue.main.async {
                    self.currentActivity = nil
                    self.isLiveActivityActive = false
                    let message = "🛑 Live Activity stopped successfully"
                    print(message)
                    self.debugMessage = message
                }
            } catch {
                let message = "❌ Failed to stop Live Activity: \(error.localizedDescription)"
                print(message)
                DispatchQueue.main.async {
                    self.debugMessage = message
                }
            }
        }
    }
    
    func endAllActivities() {
        Task {
            do {
                for activity in Activity<MotionDetectorLiveActivityAttributes>.activities {
                    await activity.end(nil, dismissalPolicy: .immediate)
                }
                DispatchQueue.main.async {
                    self.currentActivity = nil
                    self.isLiveActivityActive = false
                    let message = "🧹 All Live Activities ended"
                    print(message)
                    self.debugMessage = message
                }
            } catch {
                let message = "❌ Failed to end all activities: \(error.localizedDescription)"
                print(message)
                DispatchQueue.main.async {
                    self.debugMessage = message
                }
            }
        }
    }
    
    // Debug function to list all activities
    func listAllActivities() {
        let activities = Activity<MotionDetectorLiveActivityAttributes>.activities
        print("📋 All Live Activities (\(activities.count)):")
        for (index, activity) in activities.enumerated() {
            print("  \(index + 1). ID: \(activity.id), State: \(activity.content.state)")
        }
        
        if activities.isEmpty {
            print("  No Live Activities found")
        }
    }
} 
