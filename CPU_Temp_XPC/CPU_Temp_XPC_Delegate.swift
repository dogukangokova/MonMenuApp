//
//  CPU_Temp_XPC_Delegate.swift
//  CPU_Temp_XPC
//


import Foundation

class CPU_Temp_XPC_Delegate: NSObject, NSXPCListenerDelegate {
    func listener(_ listener: NSXPCListener, shouldAcceptNewConnection newConnection: NSXPCConnection) -> Bool {
        let exportedObject = CPU_Temp_XPC()
        newConnection.exportedInterface = NSXPCInterface(with: CPU_Temp_XPC_Protocol.self)
        newConnection.exportedObject = exportedObject
        newConnection.resume()
        return true
    }
}
