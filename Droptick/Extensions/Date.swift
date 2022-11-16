//
//  Date.swift
//  Droptick
//
//  Created by Владимир Семенов on 11/17/22.
//

import Foundation


extension Date {
    // FIXME I have no idea how it works
    func normalize() -> Date {
        let timezone = TimeZone.current
        let seconds = TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
}
