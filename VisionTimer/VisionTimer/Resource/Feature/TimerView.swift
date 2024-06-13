//
//  TimerView.swift
//  VisionTimer
//
//  Created by 이민규 on 6/12/24.
//

import SwiftUI

struct TimerView: View {
    @StateObject private var viewModel = TimerViewModel()
    @State private var isShowSheet = false
    @State private var isShowDialog = false
    
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
                .onTapGesture {
                    isShowSheet.toggle()
                }
            Spacer()
            HStack {
                if viewModel.timerState != .initialized {
                    Button {
                        isShowDialog.toggle()
                    } label: {
                        Text("초기화")
                            .frame(width: 60, height: 60)
                    }
                    .clipShape(
                        Capsule()
                    )
                }
                Spacer()
                switch viewModel.timerState {
                case .initialized:
                    Spacer()
                case .finished:
                    Button {
                        viewModel.setTimer(time: 300)
                        viewModel.startTimer()
                    } label: {
                        Text("5분 더")
                            .frame(width: 60, height: 60)
                    }
                    .clipShape(
                        Capsule()
                    )
                case .running:
                    Button {
                        viewModel.stopTimer()
                    } label: {
                        Text("정지")
                            .frame(width: 60, height: 60)
                    }
                    .clipShape(
                        Capsule()
                    )
                case .stopped:
                    Button {
                        viewModel.startTimer()
                    } label: {
                        Text("시작")
                            .frame(width: 60, height: 60)
                    }
                    .clipShape(
                        Capsule()
                    )
                }
            }
            .frame(width: 300)
            .padding(.bottom, 50)
        }
        .frame(maxWidth: 500, maxHeight: 500)
        .background(.red)
        .sheet(isPresented: $isShowSheet) {
            VStack {
                Text("타이머 시간 10초 추가")
                Button {
                    isShowSheet.toggle()
                    viewModel.setTimer(time: 3)
                } label: {
                    Text("설정")
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.blue)
        }
        .sheet(isPresented: $isShowDialog) {
            VStack {
                Text("타이머를 초기화 하시겠습니까?")
                HStack(spacing: 20) {
                    Button("취소") {
                        isShowDialog.toggle()
                    }
                    .frame(width: 100)
                    Button("확인") {
                        viewModel.resetTimer()
                        isShowDialog.toggle()
                    }
                    .frame(width: 100)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.black)
        }
    }
}

#Preview {
    TimerView()
}
