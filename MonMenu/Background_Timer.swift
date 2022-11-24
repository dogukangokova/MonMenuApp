//
//  Background_Timer.swift
//  MonMenu
//


import Foundation

class Background_Timer: ObservableObject {
    
    var my_CPU_Temp_Handler = CPU_Temp_Handler()
    let observer = ActivityObserver()
    @Published var cpu_Temp_copy = ""
    @Published var cpu_usage = 0
    @Published var memory_usage = 0
    @Published var disk_usage = 0
    @Published var network_info = ""
    
    let myRT: RepeatingTimer
    
    init() {
        myRT = RepeatingTimer(timeInterval: 2)
        observer.start(interval: 3.0)
        
        myRT.eventHandler = {
            print("Timer Fired")
            self.updateCPUTemp()
            print("CPU temp: \(self.my_CPU_Temp_Handler.CPU_Temp)")
            self.observer.updatedStatisticsHandler = { observer in
            print("CPU usage: \(self.observer.cpuDescription)")
                self.cpu_usage = Int(self.observer.cpuDescription)
                self.memory_usage = Int(self.observer.memoryDescription)
                self.disk_usage = Int(self.observer.diskDescription)
                self.network_info=self.observer.networkDescription
            }
        }
        myRT.resume()
    }
    
    func updateCPUTemp() {
        DispatchQueue.main.sync {
            self.my_CPU_Temp_Handler.setCPUTemp()
            let temp = self.my_CPU_Temp_Handler.CPU_Temp
            observer.updatedStatisticsHandler = { observer in
                self.cpu_usage = Int(observer.cpuDescription)
                self.memory_usage = Int(observer.memoryDescription)
                self.disk_usage = Int(observer.diskDescription)
                self.network_info=self.observer.networkDescription
            }
            self.cpu_Temp_copy = String(format: "%1.0f", (temp as NSString).doubleValue)
        }
    }
    
}

class RepeatingTimer {

    let timeInterval: TimeInterval
    
    init(timeInterval: TimeInterval) {
        self.timeInterval = timeInterval
    }
    
    private lazy var timer: DispatchSourceTimer = {
        let t = DispatchSource.makeTimerSource()
        t.schedule(deadline: .now() + self.timeInterval, repeating: self.timeInterval)
        t.setEventHandler(handler: { [weak self] in
            self?.eventHandler?()
        })
        return t
    }()

    var eventHandler: (() -> Void)?

    private enum State {
        case suspended
        case resumed
    }

    private var state: State = .suspended

    deinit {
        timer.setEventHandler {}
        timer.cancel()
        /*
         If the timer is suspended, calling cancel without resuming
         triggers a crash. This is documented here https://forums.developer.apple.com/thread/15902
         */
        resume()
        eventHandler = nil
    }

    func resume() {
        if state == .resumed {
            return
        }
        state = .resumed
        timer.resume()
    }

    func suspend() {
        if state == .suspended {
            return
        }
        state = .suspended
        timer.suspend()
    }
}

