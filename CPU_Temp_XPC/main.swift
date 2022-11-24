//
//  main.swift
//  CPU_Temp_XPC
//


import Foundation

let delegate = CPU_Temp_XPC_Delegate()
let listener = NSXPCListener.service()
listener.delegate = delegate
listener.resume()
