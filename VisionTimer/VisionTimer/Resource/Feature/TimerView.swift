//
//  TimerView.swift
//  VisionTimer
//
//  Created by 이민규 on 6/12/24.
//

import SwiftUI

struct TimerView: View {
    @StateObject private var viewModel = TimerViewModel()
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            HStack(spacing: 8) {
                Image(systemName: "bell.fill")
                    .foregroundStyle(.white)
                Text("\(viewModel.getAlarmEndTime())")
                    .foregroundStyle(.white)
                    .font(.system(size: 20, weight: .semibold))
            }
            .padding(.top, 50)
            Text("\(viewModel.getTimeRemaining())")
                .foregroundStyle(.white)
                .font(.system(size: 80, weight: .semibold))
            Spacer()
            HStack {
                Button {
                    viewModel.stopAlarmSound()
                } label: {
                    Text("취소")
                        .frame(width: 60, height: 60)
                }
                .clipShape(
                    Capsule()
                )
                Spacer()
                Button {
                    viewModel.startTimer(duration: 150)
                } label: {
                    Text("재생")
                        .frame(width: 60, height: 60)
                }
                .clipShape(
                    Capsule()
                )
            }
            .frame(width: 300)
            .padding(.bottom, 50)
        }
        .frame(maxWidth: 500, maxHeight: 500)
        .background(.red)
    }
}

#Preview {
    TimerView()
}
