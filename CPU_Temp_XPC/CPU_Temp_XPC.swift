//
//  CPU_Temp_XPC.swift
//  CPU_Temp_XPC
//



import Foundation

class CPU_Temp_XPC: NSObject, CPU_Temp_XPC_Protocol {
    func getCPUTemp(withReply reply: @escaping (String) -> Void){
        _ = SMCOpen()
        var toReturn = ""
        let sizeToReturn: CUnsignedLong = 10
        var addressBuffer = [Int8](repeating:0, count:Int(sizeToReturn))
        
        getCpuTemp(&addressBuffer, Int(sizeToReturn))
        let data = Data(bytes: addressBuffer as [Int8], count: Int(CUnsignedLong(sizeToReturn)));
        toReturn = String(data: data, encoding: .utf8) ?? ""
        SMCClose()
        reply(toReturn)
    }
}
