//
//  DashBoard.swift
//  MotionSensor
//
//  Created by Dor Mizrachi on 27/05/2025.
//

import SwiftUI
import ActivityKit

struct DashBoard: View {
    
    @Binding var isConnected: Bool
    @Binding var isMotionDetected: Bool
    
    @State private var temperature: Double = 24.0
    @State private var speed: Double = 0.0
    
    @State private var footerTextIndex: Int = 0
    @State private var footerTexts: [String] = []
    
    @Binding var peripheralName: String?
    
    @StateObject private var bluetoothManager = BluetoothManager.shared
    @StateObject private var liveActivityManager = {
        if #available(iOS 16.1, *) {
            return LiveActivityManager.shared
        }
    }()
    
    var onChangOfSpeed: ((Double) -> Void)
//    var onMotionDetected: ((Bool) -> Void)?
//    var onConnectionChanged: ((Bool) -> Void)?
    
    
    var body: some View {
        
        GeometryReader { proxy in
            
            let width = proxy.size.width
            let height = proxy.size.height
            
            VStack(spacing: 20) {
                GeometryReader { newProxy in
                    
                    // MARK: HEADER
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("ESP 32 Control Panel")
                                .font(.system(.title, design: .rounded, weight: .bold))
                            
                            Spacer()
                            
                            // Live Activity Toggle
                            if #available(iOS 16.1, *) {
                                Button {
                                    if liveActivityManager.isLiveActivityActive {
                                        bluetoothManager.stopLiveActivity()
                                    } else {
                                        bluetoothManager.startLiveActivity()
                                    }
                                } label: {
                                    Image(systemName: liveActivityManager.isLiveActivityActive && bluetoothManager.isConnected ? "livephoto" : "livephoto.slash")
                                        .font(.system(size: 25, weight: .bold))
                                        .foregroundStyle(bluetoothManager.isConnected ? .blue : .gray)
                                }
                                .disabled(!bluetoothManager.isConnected)
                            }
                            
                            NavigationLink {
                                BluetoothSettingsView()
                            } label: {
                                Image(systemName: "gearshape")
                                    .font(.system(size: 30, weight: .bold))
                                    .foregroundStyle(.blue)
                                    
                            }
                        }
                        
                        HStack(alignment: .center, spacing: 10) {
                            VStack(spacing: 5) {
                                Image(systemName: "dot.radiowaves.left.and.right")
                                    .foregroundStyle(isConnected ? .green : .gray)
                                    .symbolEffect(.variableColor.iterative.hideInactiveLayers.reversing, options: .repeat(.continuous), isActive: isConnected)
                                    .symbolEffect(.pulse, isActive: isConnected)
//                                    .onTapGesture {
//                                        isConnected.toggle()
//                                    }
                                
                                if #available(iOS 16.1, *) {
                                    
                                    Image(systemName: "livephoto")
                                        .foregroundColor(liveActivityManager.isLiveActivityActive ? .green : .gray)
                                        .font(.caption)
                                }
                            }
                            
                            
                            VStack(alignment: .leading, spacing: 5) {
                                Text("\(isConnected ? (peripheralName ?? "Unknown") : "Disconnected")")
                                    .font(.caption2)
                                    .foregroundColor(isConnected ? .green : .gray)
                                if #available(iOS 16.1, *) {
                                    
                                    Text("Live Activity: \(liveActivityManager.isLiveActivityActive ? "On" : "Off")")
                                        .font(.caption2)
                                        .foregroundColor(liveActivityManager.isLiveActivityActive ? .green : .gray)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    .frame(maxWidth: width, maxHeight: CGFloat(Int(height / 5)))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12).stroke(
                            style: StrokeStyle(lineWidth: 3)
                        )
                    )
                }
                
                
                
                
                // MARK: BODY
                VStack {
                    GeometryReader { newProxy in
                        VStack {
                            HStack {
                                bodyItem(
                                    maxWidth: newProxy.size.width / 2,
                                    maxHeight: newProxy.size.height / 2,
                                    "Live Streaming",
                                    isMotionDetected
                                )
                                
                                bodyItem(
                                    maxWidth: newProxy.size.width / 2,
                                    maxHeight: newProxy.size.height / 2,
                                    "Motion Status",
                                    isMotionDetected,
                                    true
                                )
                            }
                            
                            HStack {
                                VStack(alignment: .center, spacing: 20) {
                                    Text("Temperture: ")
                                    Text("\(temperature.description) °C")
                                        .font(.system(size: 30))
                                }
                                .frame(maxWidth: newProxy.size.width / 2, maxHeight: newProxy.size.height / 2)
                                .fontDesign(.serif)
                                .overlay(RoundedRectangle(cornerRadius: 12).stroke(style: StrokeStyle(lineWidth: 3)))
                                
                                VStack(alignment: .center, spacing: 20) {
                                    Text("Speed: ")
                                    Text("\(String(format: "%.1f", speed))%")
                                        .font(.system(size: 30))
                                    
                                    Slider(value: $speed, in: 0...100, step: 1)
                                        .padding(.horizontal)
                                    
                                    .onChange(of: speed) { _, newValue in
                                        print("\(Int(newValue))")
                                        onChangOfSpeed(Double(newValue))
                                    }
                                }
                                .padding(.vertical)
                                .frame(maxWidth: newProxy.size.width / 2, maxHeight: newProxy.size.height / 2)
                                .fontDesign(.serif)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12).stroke(
                                        style: StrokeStyle(lineWidth: 3)
                                    )
                                )
                            }
                        }
                    }
                }
                .frame(width: width, height: CGFloat(Int(height / 1.7)))
                
                
                
                
                
                
                
                
                // MARK: FOOTER
                HStack {
                    GeometryReader { newProxy in
                        VStack(alignment: .leading) {
//                            let text = isConnected ? "Connected to \(peripheralName ?? "Unknown Device")"
//                                                : "Please Connect device to see data. Go to Settings > Scan > Select Device."
                            
                            
//                            var footerTexts: [String] {[
//                                "Speed: \(speed)",
//                                "Temperture: \(temperature.description) °C",
//                                "\(isMotionDetected ? "Motion Detected" : "No Motion Detected")"
//                                ]
//                            }
                            
                            if footerTexts.indices.contains(footerTextIndex) {
                                Text(footerTexts[footerTextIndex])
                                    .contentTransition(.numericText())
                            } else {
                                Text("Loading data...")
                            }

                            
                        }
                    }
                }
                .padding()
                .frame(width: width, height: CGFloat(Int(height / 7)))
                .overlay(
                    RoundedRectangle(cornerRadius: 12).stroke(
                        style: StrokeStyle(lineWidth: 3)
                    )
                )
                
            }
            .onAppear {
                footerTexts = [
                    "Speed: \(speed)",
                    "Temperture: \(temperature.description) °C",
                    "\(isMotionDetected ? "Motion Detected" : "No Motion Detected")"
                    ]
                
                
                Timer.scheduledTimer(withTimeInterval: 4.0, repeats: true) { _ in
                    withAnimation() {
                        footerTextIndex = (footerTextIndex + 1) % footerTexts.count
                    }
                }
            }
        }
        .padding()
    }
    
    private func bodyItem(maxWidth: CGFloat, maxHeight: CGFloat, _ description: String, _ trigger: Bool, _ isMotionSensor: Bool = false) -> some View {
        VStack(alignment: .center) {
            if isMotionSensor {
                Image(systemName: isMotionDetected ? "light.beacon.max.fill" : "light.beacon.min")
                    .foregroundStyle(isMotionDetected ? .red : .gray)
                    .shadow(color: isMotionDetected ? .red : .gray, radius: isMotionDetected ? 10 : 0)
                    .font(.system(size: 100))
                    .contentTransition(.symbolEffect(.replace.downUp.byLayer, options: .repeat(.continuous)))
                    .onTapGesture {
                        isMotionDetected.toggle()
                }
            } else {
                Text(trigger ? "👶🏻" : "😴")
                    .font(.system(size: 100))
            }
            
            Spacer()
            Text(description)
                .fontDesign(.serif)
        }
        .padding(.vertical)
        .frame(maxWidth: maxWidth, maxHeight: maxHeight)
        .overlay(
            RoundedRectangle(cornerRadius: 12).stroke(
                style: StrokeStyle(lineWidth: 3)
            )
        )
    }
}

#Preview {
    @Previewable @State var isConnected: Bool = false
    @Previewable @State var isMotionDetected: Bool = false
    
    @Previewable @State var peripheralName: String? = "Example"
    
    DashBoard(isConnected: $isConnected, isMotionDetected: $isMotionDetected, peripheralName: $peripheralName, onChangOfSpeed: {_ in})
}
//
//#Preview {
//    DashBoard()
//}
