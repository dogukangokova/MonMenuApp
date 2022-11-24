//
// ActivityObserver.swift
// MonMenu
// Copyright (c) 2022 and All rights reserved.
//

import Foundation

final public class ActivityObserver {
    private let cpu = CPU()
    private let memory = Memory()
    private let disk = Disk()
    private let network = Network()
    private var timer: Timer?

    public var updatedStatisticsHandler: ((_ observer: ActivityObserver) -> Void)?
    
    public init() {}

    deinit {
        timer?.invalidate()
    }

    public func update(interval: Double) {
        cpu.update()
        memory.update()
        disk.update()
        network.update(interval: interval)
        updatedStatisticsHandler?(self)
    }
    
    public func start(interval: Double) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true, block: { [weak self] _ in
            self?.update(interval: interval)
        })
        RunLoop.main.add(timer!, forMode: RunLoop.Mode.common)
    }
    
    public func stop() {
        timer?.invalidate()
        timer = nil
    }
    
    public var statistics: String {
        let info: [String] = [
            "☆☆☆☆☆☆☆☆☆☆ ActivityKit Stats ☆☆☆☆☆☆☆☆☆☆",
            String(cpu.current.description),
            String(memory.current.description),
            String(disk.current.description),
            "☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆",
        ]
        return info.joined(separator: "\n")
    }
    
    public var cpuUsage: CPUInfo {
            return cpu.current
    }
    
    public var cpuDescription: Double {
            return cpu.current.description
    }
    
    public var memoryPerformance: MemoryInfo {
           return memory.current
       }
       
    public var memoryDescription: Double {
        return memory.current.description
    }
    
    public var diskCapacity: DiskInfo {
        return disk.current
    }

   public var diskDescription: Double {
        return disk.current.description
   }
    
    public var networkConnection: NetworkInfo {
        return network.current
    }
    
    public var networkDescription: String {
        return network.current.description
    }

}
