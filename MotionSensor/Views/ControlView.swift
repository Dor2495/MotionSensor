//
//  ControlView.swift
//  MotionSensor
//
//  Created by Dor Mizrachi on 27/05/2025.
//

import SwiftUI

struct ControlView: View {
    @StateObject private var bluetoothManager = BluetoothManager.shared
    
    @State private var speedSendWorkItem: DispatchWorkItem?
    
    var body: some View {
        NavigationStack {
            
            DashBoard(
                isConnected: $bluetoothManager.isConnected,
                isMotionDetected: $bluetoothManager.isMotionDetected,
                peripheralName: $bluetoothManager.peripheralName,
                onChangOfSpeed: { speed in
                    sendThrottledSpeed(speed)
                }
//                ,
//                onMotionDetected: { isMotionDetected in
//                    bluetoothManager.isMotionDetected = isMotionDetected
//                },
//                onConnectionChanged: { isConnected in
//                    bluetoothManager.isConnected = isConnected
//                }
            )
            
            
            
        }
    }
    
    func sendThrottledSpeed(_ value: Double) {
        speedSendWorkItem?.cancel()
        let workItem = DispatchWorkItem {
            bluetoothManager.sendValue(String(format: "%.0f", value))
        }
        speedSendWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01, execute: workItem)
    }


}

#Preview {
    ControlView()
}
