//
//  MotionDetectorLiveActivityLiveActivity.swift
//  MotionDetectorLiveActivity
//
//  Created by Dor Mizrachi on 28/05/2025.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct MotionDetectorLiveActivityAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var isMotionDetected: Bool
        var deviceName: String
        var lastUpdated: Date
        var connectionStatus: Bool
    }
    
    var sensorName: String
}

struct MotionDetectorLiveActivityLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: MotionDetectorLiveActivityAttributes.self) { context in
            // Lock screen/banner UI goes here
            HStack(spacing: 12) {
                // Status Icon
                Image(systemName: context.state.isMotionDetected ? "exclamationmark.triangle.fill" : "checkmark.circle.fill")
                    .foregroundColor(context.state.isMotionDetected ? .red : .green)
                    .font(.title2)
                
                VStack(alignment: .leading, spacing: 4) {
                    // Main status text
                    Text(context.state.isMotionDetected ? "Motion Detected!" : "All Clear")
                        .font(.headline)
                        .foregroundColor(context.state.isMotionDetected ? .red : .green)
                    
                    // Device info
                    Text(context.state.deviceName)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    // Last updated
                    Text("Updated \(context.state.lastUpdated, style: .time)")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Connection status
                VStack {
                    Image(systemName: context.state.connectionStatus ? "wifi" : "wifi.slash")
                        .foregroundColor(context.state.connectionStatus ? .green : .red)
                        .font(.caption)
                    
                    Text(context.state.connectionStatus ? "Connected" : "Offline")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(context.state.isMotionDetected ? Color.red.opacity(0.1) : Color.green.opacity(0.1))
            )

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI
                DynamicIslandExpandedRegion(.leading) {
                    HStack {
                        Image(systemName: context.state.isMotionDetected ? "exclamationmark.triangle.fill" : "checkmark.circle.fill")
                            .foregroundColor(context.state.isMotionDetected ? .red : .green)
                            .font(.title3)
                        
                        Text("Motion")
                            .font(.caption)
                            .foregroundColor(.primary)
                    }
                }
                
                DynamicIslandExpandedRegion(.trailing) {
                    HStack {
                        Image(systemName: context.state.connectionStatus ? "wifi" : "wifi.slash")
                            .foregroundColor(context.state.connectionStatus ? .green : .red)
                            .font(.title3)
                        
                        Text("Device")
                            .font(.caption)
                            .foregroundColor(.primary)
                    }
                }
                
                DynamicIslandExpandedRegion(.bottom) {
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(context.state.isMotionDetected ? "🚨 Motion Alert" : "✅ All Clear")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(context.state.isMotionDetected ? .red : .green)
                            
                            Text(context.state.deviceName)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Text(context.state.lastUpdated, style: .time)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal, 8)
                }
            } compactLeading: {
                Image(systemName: context.state.isMotionDetected ? "exclamationmark.triangle.fill" : "checkmark.circle.fill")
                    .foregroundColor(context.state.isMotionDetected ? .red : .green)
                    .font(.caption)
            } compactTrailing: {
                HStack(spacing: 2) {
                    Text(context.state.isMotionDetected ? "🚨" : "✅")
                        .font(.caption)
                    
                    if !context.state.connectionStatus {
                        Image(systemName: "wifi.slash")
                            .foregroundColor(.red)
                            .font(.caption2)
                    }
                }
            } minimal: {
                Image(systemName: context.state.isMotionDetected ? "exclamationmark.triangle.fill" : "checkmark.circle.fill")
                    .foregroundColor(context.state.isMotionDetected ? .red : .green)
                    .font(.caption)
                }
            .widgetURL(URL(string: "motionsensor://dashboard"))
            .keylineTint(context.state.isMotionDetected ? Color.red : Color.green)
        }
        .configurationDisplayName("Motion Sensor")
        .description("Monitor motion detection from your ESP32 device")
    }
}

extension MotionDetectorLiveActivityAttributes {
    fileprivate static var preview: MotionDetectorLiveActivityAttributes {
        MotionDetectorLiveActivityAttributes(sensorName: "ESP32 Motion Sensor")
    }
}

extension MotionDetectorLiveActivityAttributes.ContentState {
    fileprivate static var motionDetected: MotionDetectorLiveActivityAttributes.ContentState {
        MotionDetectorLiveActivityAttributes.ContentState(
            isMotionDetected: true,
            deviceName: "ESP32-Test-Device",
            lastUpdated: Date(),
            connectionStatus: true
        )
    }
    
    fileprivate static var noMotion: MotionDetectorLiveActivityAttributes.ContentState {
        MotionDetectorLiveActivityAttributes.ContentState(
            isMotionDetected: false,
            deviceName: "ESP32-Test-Device",
            lastUpdated: Date(),
            connectionStatus: true
        )
    }
    
    fileprivate static var disconnected: MotionDetectorLiveActivityAttributes.ContentState {
        MotionDetectorLiveActivityAttributes.ContentState(
            isMotionDetected: false,
            deviceName: "ESP32-Test-Device",
            lastUpdated: Date(),
            connectionStatus: false
        )
    }
}

#Preview("Notification", as: .content, using: MotionDetectorLiveActivityAttributes.preview) {
    MotionDetectorLiveActivityLiveActivity()
} contentStates: {
    MotionDetectorLiveActivityAttributes.ContentState.motionDetected
    MotionDetectorLiveActivityAttributes.ContentState.noMotion
    MotionDetectorLiveActivityAttributes.ContentState.disconnected
}
