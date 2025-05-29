import SwiftUI
import ActivityKit

struct BluetoothSettingsView: View {
    @Environment(\.dismiss) private var dismiss
    
    @StateObject private var bluetoothManager = BluetoothManager.shared
    @StateObject private var liveActivityManager = {
        if #available(iOS 16.1, *) {
            return LiveActivityManager.shared
        } else {
            return LiveActivityManager.shared
        }
    }()
    
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Bluetooth Status")) {
                    HStack {
                        Text("Status")
                        Spacer()
                        Text(bluetoothManager.isConnected ? "Connected" : "Disconnected")
                            .foregroundColor(bluetoothManager.isConnected ? .green : .red)
                    }
                    
                    Button(action: {
                        if bluetoothManager.isScanning {
                            bluetoothManager.stopScanning()
                        } else {
                            bluetoothManager.startScanning()
                        }
                    }) {
                        Text(bluetoothManager.isScanning ? "Stop Scanning" : "Start Scanning")
                    }
                    
                    Button(action: {
                        if liveActivityManager.isLiveActivityActive {
                            bluetoothManager.stopLiveActivity()
                        } else {
                            bluetoothManager.startLiveActivity()
                        }
                    }) {
                        Text(liveActivityManager.isLiveActivityActive ? "Stop Live Activity" : "Start Live Activity")
                    }
                    .disabled(!bluetoothManager.isConnected)
                }
                
                // Live Activity Section
//                if #available(iOS 16.1, *) {
//                    Section(header: Text("Live Activity")) {
//                        HStack {
//                            Text("Status")
//                            Spacer()
//                            Text(liveActivityManager.isLiveActivityActive ? "Active" : "Inactive")
//                                .foregroundColor(liveActivityManager.isLiveActivityActive ? .green : .gray)
//                        }
//                        
//                        Button(action: {
//                            if liveActivityManager.isLiveActivityActive {
//                                bluetoothManager.stopLiveActivity()
//                            } else {
//                                bluetoothManager.startLiveActivity()
//                            }
//                        }) {
//                            Text(liveActivityManager.isLiveActivityActive ? "Stop Live Activity" : "Start Live Activity")
//                        }
//                        .disabled(!bluetoothManager.isConnected)
//                        
//                        // Force start for testing (bypasses connection requirement)
//                        Button("🧪 Force Start (Test Mode)") {
//                            liveActivityManager.startLiveActivity(
//                                sensorName: "ESP32 Motion Sensor (Test)",
//                                deviceName: "Test Device",
//                                isConnected: false
//                            )
//                        }
//                        .foregroundColor(.purple)
//                        .disabled(liveActivityManager.isLiveActivityActive)
//                        
//                        // Dedicated test function
//                        Button("🔬 Start Test Live Activity") {
//                            liveActivityManager.startTestLiveActivity()
//                        }
//                        .foregroundColor(.orange)
//                        .disabled(liveActivityManager.isLiveActivityActive)
//                        
//                        if !ActivityAuthorizationInfo().areActivitiesEnabled {
//                            Text("Live Activities are disabled in Settings")
//                                .font(.caption)
//                                .foregroundColor(.orange)
//                        }
//                        
//                        // Debug buttons
//                        Button("List All Activities") {
//                            liveActivityManager.listAllActivities()
//                        }
//                        .foregroundColor(.blue)
//                        
//                        Button("End All Activities") {
//                            liveActivityManager.endAllActivities()
//                        }
//                        .foregroundColor(.red)
//                        
//                        // Test motion detection
//                        if liveActivityManager.isLiveActivityActive {
//                            Button("🚨 Test Motion Detected") {
//                                liveActivityManager.updateLiveActivity(
//                                    isMotionDetected: true,
//                                    deviceName: "Test Device",
//                                    isConnected: true
//                                )
//                            }
//                            .foregroundColor(.red)
//                            
//                            Button("✅ Test No Motion") {
//                                liveActivityManager.updateLiveActivity(
//                                    isMotionDetected: false,
//                                    deviceName: "Test Device",
//                                    isConnected: true
//                                )
//                            }
//                            .foregroundColor(.green)
//                        }
//                    }
//                    
//                    // Debug Information Section
//                    Section(header: Text("Debug Information")) {
//                        VStack(alignment: .leading, spacing: 8) {
//                            Text("Debug Messages:")
//                                .font(.caption)
//                                .foregroundColor(.secondary)
//                            
//                            Text(liveActivityManager.debugMessage.isEmpty ? "No debug messages" : liveActivityManager.debugMessage)
//                                .font(.caption2)
//                                .foregroundColor(.primary)
//                                .textSelection(.enabled)
//                        }
//                        
//                        #if targetEnvironment(simulator)
//                        VStack(alignment: .leading, spacing: 4) {
//                            Text("🔧 Simulator Instructions:")
//                                .font(.caption)
//                                .fontWeight(.semibold)
//                                .foregroundColor(.orange)
//                            
//                            Text("1. Start Live Activity")
//                                .font(.caption2)
//                            Text("2. Lock simulator: Device → Lock")
//                                .font(.caption2)
//                            Text("3. Check Lock Screen for Live Activity")
//                                .font(.caption2)
//                            Text("4. Or swipe down for Notification Center")
//                                .font(.caption2)
//                        }
//                        .padding(.vertical, 4)
//                        #endif
//                        
//                        VStack(alignment: .leading, spacing: 4) {
//                            Text("System Info:")
//                                .font(.caption)
//                                .fontWeight(.semibold)
//                            
//                            Text("iOS: \(ProcessInfo.processInfo.operatingSystemVersionString)")
//                                .font(.caption2)
//                            
//                            Text("Activities Enabled: \(ActivityAuthorizationInfo().areActivitiesEnabled ? "Yes" : "No")")
//                                .font(.caption2)
//                                .foregroundColor(ActivityAuthorizationInfo().areActivitiesEnabled ? .green : .red)
//                        }
//                        
//                        // Live Activity State Debug
//                        if liveActivityManager.isLiveActivityActive {
//                            VStack(alignment: .leading, spacing: 4) {
//                                Text("Live Activity State:")
//                                    .font(.caption)
//                                    .fontWeight(.semibold)
//                                
//                                Text("Status: Active ✅")
//                                    .font(.caption2)
//                                    .foregroundColor(.green)
//                                
//                                Button("📋 Log Activity Details") {
//                                    liveActivityManager.listAllActivities()
//                                }
//                                .font(.caption2)
//                                .foregroundColor(.blue)
//                            }
//                        } else {
//                            VStack(alignment: .leading, spacing: 4) {
//                                Text("Live Activity State:")
//                                    .font(.caption)
//                                    .fontWeight(.semibold)
//                                
//                                Text("Status: Inactive ❌")
//                                    .font(.caption2)
//                                    .foregroundColor(.red)
//                            }
//                        }
//                    }
//                }
                
                Section(header: Text("Available Devices")) {
                    ForEach(bluetoothManager.discoveredPeripherals, id: \.identifier) { peripheral in
                        Button(action: {
                            bluetoothManager.connect(to: peripheral)
                        }) {
                            HStack {
                                Text(peripheral.name ?? "Unknown Device")
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Bluetooth Settings")
            .refreshable {
                if !bluetoothManager.isScanning {
                    bluetoothManager.startScanning()
                }
            }
            .toolbar {
                if bluetoothManager.isConnected {
                    Section {
                        Button(action: {
                            bluetoothManager.disconnect()
                        }) {
                            Text("Disconnect")
                                .foregroundColor(.red)
                        }
                    }
                }
            }
            .onChange(of: bluetoothManager.isConnected) { _, isConnected in
                if isConnected {
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    BluetoothSettingsView()
}
