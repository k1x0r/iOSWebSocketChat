//
//  Extensions.swift
//  WebSocketChat
//
//  Created by k1x on 26/09/16.
//  Copyright © 2016 k1x. All rights reserved.
//

import Foundation

extension Array {
    func shiftRight(amount: Int = 1) -> [Element] {
        var amount = amount
        assert(-count...count ~= amount, "Shift amount out of bounds")
        if amount < 0 { amount += count }  // this needs to be >= 0
        return Array(self[amount ..< count] + self[0 ..< amount])
    }
    
    mutating func shiftRightInPlace(amount: Int = 1) {
        self = shiftRight(amount: amount)
    }
}

extension Date {
    func getDayOfWeek() -> Int? {
        let myCalendar = Calendar(identifier: .gregorian)
        let weekDay = myCalendar.component(.weekday, from: self)
        return weekDay
    }
    
}

extension Command: Equatable {}

func ==(lhs: Command, rhs: Command) -> Bool {
    let areEqual = lhs.author == rhs.author &&
        lhs.commandData == rhs.commandData
    return areEqual
}

extension CommandData: Equatable {
}

func ==(lhs: CommandData, rhs: CommandData) -> Bool {
    switch (lhs, rhs) {
    case (let .Date(date1), let .Date(date2)):
        return date1 == date2
    case (let .LatLng(lat1, lng1), let .LatLng(lat2, lng2)):
        return lat1 == lat2 && lng1 == lng2
    case (let .Complete(variants1), let .Complete(variants2)):
        return variants1 == variants2
    case (let .Rate(minMax1), let .Rate(minMax2)):
        return minMax1 == minMax2
    case (let .Message(msg1), let .Message(msg2)):
        return msg1 == msg2
    default:
        return false
    }
}


