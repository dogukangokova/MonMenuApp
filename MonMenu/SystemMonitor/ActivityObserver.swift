//
// ActivityObserver.swift
// MonMenu
// Copyright (c) 2022 and All rights reserved.
//

import Foundation

final public class ActivityObserver {
    private let cpu = CPU()
    private var timer: Timer?

    public var updatedStatisticsHandler: ((_ observer: ActivityObserver) -> Void)?
    
    public init() {}

    deinit {
        timer?.invalidate()
    }

    public func update(interval: Double) {
        cpu.update()
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
            cpu.current.description,
            "☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆",
        ]
        return info.joined(separator: "\n")
    }
    
    public var cpuUsage: CPUInfo {
            return cpu.current
    }
    
    public var cpuDescription: String {
            return cpu.current.description
    }
}
