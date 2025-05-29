# Motion Sensor iOS App

An iOS app that connects to an ESP32 device via Bluetooth to monitor motion detection with Live Activity support.

## Features

- **Bluetooth Connectivity**: Connect to ESP32 devices for real-time motion monitoring
- **Live Activities**: Display motion detection status on the Lock Screen and Dynamic Island
- **Real-time Dashboard**: Monitor motion status, connection status, and device controls
- **Speed Control**: Send speed values to the connected ESP32 device

## Live Activity Integration

### What's New
The app now supports iOS Live Activities, allowing you to monitor motion detection status directly from:
- Lock Screen notifications
- Dynamic Island (iPhone 14 Pro and later)
- Notification Center

### How to Use Live Activities

1. **Enable Live Activities**:
   - Connect to your ESP32 device
   - Tap the Live Activity button (📱) in the dashboard header
   - Or go to Settings > Live Activity > Start Live Activity

2. **Live Activity Display**:
   - **Lock Screen**: Shows motion status, device name, and last update time
   - **Dynamic Island**: 
     - Minimal: Shows motion status icon
     - Compact: Shows motion status and connection status
     - Expanded: Full details including device name and timestamps

3. **Interaction**:
   - Tap the Live Activity to open the app directly to the dashboard
   - Live Activity automatically updates when motion is detected or connection status changes

### Requirements
- iOS 16.1 or later for Live Activities
- iPhone 14 Pro or later for Dynamic Island features

## Setup

1. Build and run the app in Xcode
2. Ensure your ESP32 device is broadcasting Bluetooth signals
3. Use the Settings screen to scan and connect to your device
4. Enable Live Activities for persistent monitoring

## Technical Details

### Live Activity Data
The Live Activity displays:
- Motion detection status (🚨 for motion, ✅ for no motion)
- Device connection status
- Device name
- Last update timestamp

### URL Scheme
The app supports the `motionsensor://dashboard` URL scheme for deep linking from Live Activities.

### Bluetooth Protocol
The app expects the following messages from the ESP32:
- `"motion"` - Motion detected
- `"no motion"` - No motion detected

## Architecture

- **MVVM Pattern**: Uses ObservableObject view models
- **SwiftUI**: Modern declarative UI framework
- **Core Bluetooth**: For ESP32 communication
- **ActivityKit**: For Live Activities (iOS 16.1+)

## Files Structure

```
MotionSensor/
├── MotionSensorApp.swift          # Main app entry point with URL handling
├── ContentView.swift              # Root view
├── Views/
│   ├── ControlView.swift          # Main control interface
│   ├── DashBoard.swift            # Dashboard with Live Activity controls
│   └── SettingsView.swift         # Bluetooth and Live Activity settings
├── ViewModel/
│   ├── BluetoothManager.swift     # Bluetooth communication manager
│   └── LiveActivityManager.swift  # Live Activity management
└── Info.plist                    # URL scheme configuration

MotionDetectorLiveActivity/
├── MotionDetectorLiveActivityLiveActivity.swift  # Live Activity UI
├── MotionDetectorLiveActivityBundle.swift        # Widget bundle
└── Other widget files...
```

## Troubleshooting

### Live Activities Not Working

#### On iOS Simulator:
1. **Enable Live Activities in Simulator**:
   - Go to Settings app in simulator
   - Navigate to Face ID & Passcode (or Touch ID & Passcode)
   - Enable "Live Activities"

2. **Testing Steps**:
   - Use the "🧪 Force Start (Test Mode)" button in Settings
   - Check the debug messages in the Debug Information section
   - Lock the simulator: Device → Lock (or Cmd+L)
   - Look for the Live Activity on the Lock Screen
   - Alternatively, swipe down from the top to see Notification Center

3. **Common Simulator Issues**:
   - Live Activities may not appear immediately
   - Try restarting the simulator if they don't show
   - Ensure you're using iOS 16.1+ simulator
   - Check Xcode console for debug messages

#### On Physical Device:
1. Check that Live Activities are enabled in iOS Settings > Face ID & Passcode > Live Activities
2. Ensure you're running iOS 16.1 or later
3. Make sure the app has proper permissions
4. Try force-closing and reopening the app

### Bluetooth Connection Issues
1. Ensure Bluetooth is enabled on your device
2. Check that your ESP32 is broadcasting and discoverable
3. Try disconnecting and reconnecting

### Debug Features
The app includes several debug features accessible in Settings:
- **Debug Information**: Shows system info and debug messages
- **Force Start (Test Mode)**: Starts Live Activity without requiring Bluetooth connection
- **Test Motion Buttons**: Simulate motion detection when Live Activity is active
- **List All Activities**: Shows all active Live Activities in console
- **End All Activities**: Stops all Live Activities

## Future Enhancements

- Push notifications for motion detection
- Historical motion data tracking
- Multiple device support
- Custom alert sounds and vibrations 