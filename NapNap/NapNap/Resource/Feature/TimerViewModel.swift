//
//  TimerViewModel.swift
//  NapNap
//
//  Created by 이민규 on 6/18/24.
//

import Foundation
import AVFAudio

@Observable
class TimerViewModel {
    var isShowTimeSetterDialog: Bool = false
    var isShowResetDialog: Bool = false
    var isShaking = false
    var showImmersiveSpace = false
    var immersiveSpaceIsShown = false
    
    enum TimerState {
        case initialized
        case finished
        case running
        case stopped
    }
    var timerState: TimerState = .initialized
    var timeRemaining: UInt = 0
    var backgroundMusicVolume: UInt = 0
    
    private var timer: Timer?
    private var player: AVAudioPlayer?
    
    // Timer method
    func setTimer(time: UInt) {
        timeRemaining = time
        timeRemaining > 0 ? (timerState = .stopped) : (timerState = .initialized)
    }
    
    func startTimer() {
        timerState = .running
        playBackgroundMusic()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            } else {
                self.timer?.invalidate()
                self.player?.stop()
                self.playAlarmSound()
                self.timerState = .finished
            }
        }
    }
    
    func stopTimer() {
        player?.pause()
        timer?.invalidate()
        timerState = .stopped
    }
    
    // Audio & Video method
    private func playBackgroundMusic() {
        guard let url = Bundle.main.url(
            forResource: Sources.rain[0], withExtension: Sources.rain[1]
        ) else {
            print("Background music file not found")
            return
        }
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.numberOfLoops = -1
            player?.volume = 0.2
            player?.play()
            print("play background music")
        } catch {
            print("missing rain.wav file")
        }
    }
    
    private func playAlarmSound() {
        guard let url = Bundle.main.url(
            forResource: Sources.alarm[0], withExtension: Sources.alarm[1]
        ) else {
            print("Alarm sound file not found")
            return
        }
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
            print("play alarm sound")
        } catch {
            print("missing alarm.wav file")
        }
    }
    
    func resetTimer() {
        timeRemaining = 0
        timer?.invalidate()
        player?.stop()
        timerState = .initialized
    }
    
    // UI method
    func onTapTimeSetter() {
        if timerState == .initialized || timerState == .stopped {
            isShowTimeSetterDialog.toggle()
        }
    }
    
    func getTimeRemaining() -> String {
        let hours = timeRemaining / 3600
        let minutes = (timeRemaining % 3600) / 60
        let seconds = timeRemaining % 60
        
        let hourString = hours > 0 ? "\(hours):" : ""
        let minuteString = String(format: "%02d", minutes)
        let secondString = String(format: "%02d", seconds)
        
        return "\(hourString)\(minuteString):\(secondString)"
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
