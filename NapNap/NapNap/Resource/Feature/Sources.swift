//
//  Source.swift
//  NapNap
//
//  Created by 이민규 on 6/18/24.
//

import SwiftUI

public enum Sources {
    
    //Color
    static let background = Color("Background")
    static let container = Color("Container")
    static let primary = Color("Primary")
    static let darkPrimary = Color("DarkPrimary")
    static let label = Color("Label")
    
    //Image
    static let triangle = Image("Triangle")
    static let clockwiseArrow = Image("ClockwiseArrow")
    static let cat1 = Image("SleepingCat")
    static let cat2 = Image("Wakeup")
    
    //Sound
    static let alarm = "Alarm.wav".split(separator: ".").map { String($0) }
    static let rain = "Rain.wav".split(separator: ".").map { String($0) }
}
