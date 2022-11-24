//
//  CPU_Temp_XPC_Protocol.swift
//  CPU_Temp_XPC
//


import Foundation

@objc public protocol CPU_Temp_XPC_Protocol {
    func getCPUTemp(withReply reply: @escaping (String) -> Void)
}

