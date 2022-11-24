//
// Double.swift
// MonMenu
// Copyright (c) 2022 and All rights reserved.
//

import Foundation

extension Double {
    var round2dp: Double {
        return (10.0 * self).rounded() / 10.0
    }
}
