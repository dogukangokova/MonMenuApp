//
// CPUInfo.swift
// MonMenu
// Copyright (c) 2022 and All rights reserved.
//

import Darwin

public struct CPUInfo {
    public var percentage: Double = 0.0
    init() {}
    
    init(percentage: Double) {
        self.percentage = percentage
    }
    
    public var description: Double {
           return percentage
    }
}

final public class CPU {
    
    public internal(set) var current = CPUInfo()
    
    private let loadInfoCount: mach_msg_type_number_t!
    private var loadPrevious = host_cpu_load_info()
    
    init() {
        loadInfoCount = UInt32(MemoryLayout<host_cpu_load_info_data_t>.size / MemoryLayout<integer_t>.size)
    }
    
    private func hostCPULoadInfo() -> host_cpu_load_info {
        var size: mach_msg_type_number_t = loadInfoCount
        let hostInfo = host_cpu_load_info_t.allocate(capacity: 1)
        let _ = hostInfo.withMemoryRebound(to: integer_t.self, capacity: Int(size)) { (pointer) -> kern_return_t in
            return host_statistics(mach_host_self(), HOST_CPU_LOAD_INFO, pointer, &size)
        }
        let data = hostInfo.move()
        hostInfo.deallocate()
        return data
    }
    
    public func update() {
        var result = CPUInfo()
        
        defer {
            current = result
        }
        
        let load = hostCPULoadInfo()
        let userDiff    = Double(load.cpu_ticks.0 - loadPrevious.cpu_ticks.0)
        let systemDiff  = Double(load.cpu_ticks.1 - loadPrevious.cpu_ticks.1)
        let idleDiff    = Double(load.cpu_ticks.2 - loadPrevious.cpu_ticks.2)
        let niceDiff    = Double(load.cpu_ticks.3 - loadPrevious.cpu_ticks.3)
        loadPrevious    = load
        
        let totalTicks = systemDiff + userDiff + idleDiff + niceDiff
        let system     = 100.0 * systemDiff / totalTicks
        let user       = 100.0 * userDiff / totalTicks
        let idle       = 100.0 * idleDiff / totalTicks
        
        result.percentage = min(99.9, (system + user).round2dp)
    }
}
