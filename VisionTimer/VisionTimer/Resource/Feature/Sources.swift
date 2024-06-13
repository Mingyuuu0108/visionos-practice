//
//  Assets.swift
//  VisionTimer
//
//  Created by 이민규 on 6/13/24.
//

import SwiftUI

public enum Sources {
    
    //Color
    static let background = Color("Background")
    static let container = Color("Container")
    static let primary = Color("Primary")
    static let label = Color("Label")
    
    //Image
    
    //Sound
    static let alarm = "Alarm.wav".split(separator: ".").map { String($0) }
    static let rain = "Rain.wav".split(separator: ".").map { String($0) }
}
