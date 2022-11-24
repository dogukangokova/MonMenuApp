//
// DiskInfo.swift
// MonMenu
// Copyright (c) 2022 and All rights reserved.
//

import Foundation

public struct ByteData {
    public var value: Double
    public var unit: String
    
    public var description: String {
        return String(format: "%.2f %@", value, unit)
    }
}

public struct DiskInfo {

    public var percentage: Double = 0.0
    public var total = ByteData(value: 0.0, unit: "GB")
    public var free = ByteData(value: 0.0, unit: "GB")
    public var used = ByteData(value: 0.0, unit: "GB")
    
    init() {}
    
    init(percentage: Double) {
        self.percentage = percentage
    }

    public var description: Double {
        return percentage
    }
    
}

final public class Disk {

    public internal(set) var current = DiskInfo()
    
    private func convertByteData(byteCount: Int64) -> ByteData {
        let fmt = ByteCountFormatter()
        fmt.countStyle = .decimal
        let array = fmt.string(fromByteCount: byteCount)
            .replacingOccurrences(of: ",", with: ".")
            .components(separatedBy: .whitespaces)
        return ByteData(value: Double(array[0]) ?? 0.0, unit: array[1])
    }
    
    public func update() {
        var result = DiskInfo()
        
        defer {
            current = result
        }
        
        let url = NSURL(fileURLWithPath: "/")
        let keys: [URLResourceKey] = [.volumeTotalCapacityKey, .volumeAvailableCapacityForImportantUsageKey]
        guard let dict = try? url.resourceValues(forKeys: keys) else { return }
        let total = (dict[URLResourceKey.volumeTotalCapacityKey] as! NSNumber).int64Value
        let free = (dict[URLResourceKey.volumeAvailableCapacityForImportantUsageKey] as! NSNumber).int64Value
        let used: Int64 = total - free
        
        result.percentage = min(99.9, (100.0 * Double(used) / Double(total)).round2dp)
        
        // support french style 3,14 → 3.14
        result.total = convertByteData(byteCount: total)
        result.free  = convertByteData(byteCount: free)
        result.used  = convertByteData(byteCount: used)
    }
    
}
