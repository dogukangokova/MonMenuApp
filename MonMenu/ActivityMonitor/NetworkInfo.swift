//
// NetworkInfo.swift
// MonMenu
// Copyright (c) 2022 and All rights reserved.
//

import Foundation
import SystemConfiguration

public struct LoadData {
    public var ip: String
    public var up: Double
    public var down: Double
}

public struct PacketData {
    public var value: Double
    public var unit: String
}

public struct NetworkInfo {
    
    public var name: String = "no connection"
    public var localIP: String = "xx.x.x.xx"
    public var upload = PacketData(value: 0.0, unit: "KB/s")
    public var download = PacketData(value: 0.0, unit: "KB/s")
    
    public var description: String {
        let format = "\nName %@\nLocal IP: %@\nUpload: %.1f %@\nDownload: %.1f %@"
        return String(format: format, name, localIP,
                      upload.value, upload.unit,
                      download.value, download.unit)
    }
    
    init() {}
    
    init(name: String, load: LoadData) {
        self.name = name
        self.localIP = load.ip
        self.upload = convert(byte: load.up)
        self.download = convert(byte: load.down)
    }

    private func convert(byte: Double) -> PacketData {
        let KB: Double = 1024
        let MB: Double = pow(KB, 2)
        let GB: Double = pow(KB, 3)
        let TB: Double = pow(KB, 4)
        if TB <= byte {
            return PacketData(value: (byte / TB).round2dp, unit: "TB/s")
        } else if GB <= byte {
            return PacketData(value: (byte / GB).round2dp, unit: "GB/s")
        } else if MB <= byte {
            return PacketData(value: (byte / MB).round2dp, unit: "MB/s")
        } else {
            return PacketData(value: (byte / KB).round2dp, unit: "KB/s")
        }
    }
    
}

final public class Network {

    public internal(set) var current = NetworkInfo()
    
    private var interval: Double = 1.0
    private var previousIP: String = "xx.x.x.xx"
    private var previousUpload: Int64 = 0
    private var previousDownload: Int64 = 0
    
    private var getDefaultID: String? {
        let processName = ProcessInfo.processInfo.processName as CFString
        let dynamicStore = SCDynamicStoreCreate(kCFAllocatorDefault, processName, nil, nil)
        let ipv4Key = SCDynamicStoreKeyCreateNetworkGlobalEntity(kCFAllocatorDefault,
                                                                 kSCDynamicStoreDomainState,
                                                                 kSCEntNetIPv4)
        guard let list = SCDynamicStoreCopyValue(dynamicStore, ipv4Key) as? [CFString: Any],
              let interface = list[kSCDynamicStorePropNetPrimaryInterface] as? String
        else { return nil }
        return interface
    }
    
    private func getHardwareName(_ id: String) -> String {
        for interface in SCNetworkInterfaceCopyAll() as! [SCNetworkInterface] {
            if let bsd = SCNetworkInterfaceGetBSDName(interface) {
                if bsd as String != id { continue }
                if let name = SCNetworkInterfaceGetLocalizedDisplayName(interface) {
                    return name as String
                }
            }
        }
        return "Unknown"
    }
    
    private func getBytesInfo(
        _ id: String,
        _ pointer: UnsafeMutablePointer<ifaddrs>
    ) -> (up: Int64, down: Int64)? {
        let name = String(cString: pointer.pointee.ifa_name)
        if name == id {
            let addr = pointer.pointee.ifa_addr.pointee
            guard addr.sa_family == UInt8(AF_LINK) else { return nil }
            var data: UnsafeMutablePointer<if_data>? = nil
            data = unsafeBitCast(pointer.pointee.ifa_data,
                                 to: UnsafeMutablePointer<if_data>.self)
            return (up: Int64(data?.pointee.ifi_obytes ?? 0),
                    down: Int64(data?.pointee.ifi_ibytes ?? 0))
        }
        return nil
    }
    
    private func getIPAddress(
        _ id: String,
        _ pointer: UnsafeMutablePointer<ifaddrs>
    ) -> String? {
        let name = String(cString: pointer.pointee.ifa_name)
        if name == id {
            var addr = pointer.pointee.ifa_addr.pointee
            guard addr.sa_family == UInt8(AF_INET) else { return nil }
            var ip = [CChar](repeating: 0, count: Int(NI_MAXHOST))
            getnameinfo(&addr, socklen_t(addr.sa_len), &ip,
                        socklen_t(ip.count), nil, socklen_t(0), NI_NUMERICHOST)
            return String(cString: ip)
        }
        return nil
    }
    
    private func getUpDown(_ id: String) -> LoadData {
        var result = LoadData(ip: "xx.x.x.xx", up: 0.0, down: 0.0)
        var ifaddr: UnsafeMutablePointer<ifaddrs>? = nil
        guard getifaddrs(&ifaddr) == 0 else { return result }

        var pointer = ifaddr
        var upload: Int64 = 0
        var download: Int64 = 0
        while pointer != nil {
            defer { pointer = pointer?.pointee.ifa_next }
            if let info = getBytesInfo(id, pointer!) {
                upload += info.up
                download += info.down
            }
            if let ip = getIPAddress(id, pointer!) {
                if previousIP != ip {
                    previousUpload = 0
                    previousDownload = 0
                }
                previousIP = ip
            }
        }
        result.ip = previousIP
        freeifaddrs(ifaddr)
        if previousUpload != 0 && previousDownload != 0 {
            result.up = Double(upload - previousUpload) / interval
            result.down = Double(download - previousDownload) / interval
        }
        previousUpload = upload
        previousDownload = download
        return result
    }
    
    public func update(interval: Double) {
        self.interval = max(interval, 1.0)
        guard let id = getDefaultID else { return }
        let name = getHardwareName(id)
        let load = getUpDown(id)
        current = NetworkInfo(name: name, load: load)
    }
    
}
