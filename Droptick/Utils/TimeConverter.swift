//
//  TimeConverter.swift
//  Droptick
//
//  Created by Владимир Семенов on 11/12/22.
//

import Foundation


func convertToHours(seconds: Int) -> Int {
    guard seconds > 0 else {
        return 0
    }
    return seconds / 3600
}

func convertToHours(minutes: Int) -> Int {
    guard minutes > 0 else {
        return 0
    }
    return minutes / 60
}

func convertToMinutes(seconds: Int) -> Int {
    guard seconds > 0 else {
        return 0
    }
    let hours = convertToHours(seconds: seconds)
    return seconds / 60 - hours * 60
}

func convertToMinutes(minutes: Int) -> Int {
    guard minutes > 0 else {
        return 0
    }
    let hours = convertToHours(minutes: minutes)
    return minutes - hours * 60
}

func convertToSeconds(seconds: Int) -> Int {
    guard seconds > 0 else {
        return 0
    }
    let hours = convertToHours(seconds: seconds)
    let minutes = convertToMinutes(seconds: seconds)
    return seconds - minutes * 60 - hours * 3600
}
