//
//  TimerViewModel.swift
//  VisionTimer
//
//  Created by 이민규 on 6/12/24.
//

import SwiftUI
import AVFAudio

class TimerViewModel: ObservableObject {
    enum TimerState {
        case initialized
        case finished
        case running
        case stopped
    }
    @Published var timerState: TimerState = .initialized
    @Published var timeRemaining: Int = 0
    
    private var timer: Timer?
    private var player: AVAudioPlayer?
    
    func startTimer(duration: Int) {
        timeRemaining = duration
        timerState = .running
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            self.timeRemaining -= 1
            
            if self.timeRemaining < 1 {
                self.timerState = .finished
                self.playAlarmSound()
                self.timer?.invalidate()
            }
        }
    }
    
    func stopAlarmSound() {
        player?.stop()
        timerState = .stopped
    }
    
    private func playAlarmSound() {
        guard let url = Bundle.main.url(forResource: "alarm", withExtension: "wav") else { return }
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
            print("playing")
        } catch {
            print("missing alarm.wav file")
        }
    }
    
    func getTimeRemaining() -> String {
        let min = (timeRemaining / 60) < 10 ? "0\(timeRemaining / 60)" : "\(timeRemaining / 60)"
        let sec = (timeRemaining % 60) < 10 ? "0\(timeRemaining % 60)" : "\(timeRemaining % 60)"
        return "\(min):\(sec)"
    }
    
    func getAlarmEndTime() -> String {
        let finishingTime = Date().addingTimeInterval(TimeInterval(timeRemaining))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "a h시 mm분"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        let formattedFinishingTime = dateFormatter.string(from: finishingTime)
        return timerState == .initialized ? "시간을 정해주세요" : "\(formattedFinishingTime)"
    }
}
