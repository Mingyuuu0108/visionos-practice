//
//  TimerView.swift
//  VisionTimer
//
//  Created by 이민규 on 6/12/24.
//

import SwiftUI

struct TimerView: View {
    @StateObject private var viewModel = TimerViewModel()
    @GestureState private var dragAmount = CGSize.zero
    @State private var currentPosition = CGSize.zero
    @State private var time: UInt = 0
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            HStack(spacing: 10) {
                Image(systemName: "bell.fill")
                    .resizable()
                    .frame(width: 18, height: 21)
                    .foregroundStyle(Sources.label)
                Text("\(viewModel.getAlarmEndTime())")
                    .foregroundStyle(Sources.label)
                    .font(.system(size: 24, weight: .semibold))
            }
            .padding(.top, 50)
            if viewModel.timerState == .finished {
                Text("일어나요!!")
                    .foregroundStyle(Sources.label)
                    .font(.system(size: 100, weight: .semibold))
                    .offset(x: viewModel.isShaking ? -2 : 2)
                    .onAppear {
                        withAnimation(.linear(duration: 0.1).repeatCount(60)) {
                            viewModel.isShaking.toggle()
                        }
                    }
            } else {
                Text("\(viewModel.getTimeRemaining())")
                    .foregroundStyle(Sources.label)
                    .font(.system(size: 120, weight: .semibold))
                    .onTapGesture {
                        viewModel.onTapTimeSetter()
                    }
                    .onAppear {
                        viewModel.isShaking.toggle()
                    }
            }
            (viewModel.timerState == .finished ? Sources.cat2 : Sources.cat1)
                .resizable()
                .frame(width: 300, height: 275)
            Spacer()
            HStack {
                VStack(spacing: 10) {
                    if viewModel.timerState != .initialized {
                        Button {
                            viewModel.timerState == .finished ?
                            viewModel.resetTimer() :
                            viewModel.isShowResetDialog.toggle()
                        } label: {
                            ZStack {
                                Rectangle()
                                    .frame(width: 3, height: 28)
                                    .foregroundStyle(Sources.label)
                                    .clipShape(RoundedRectangle(cornerRadius: 3))
                                    .rotationEffect(.degrees(45))
                                Rectangle()
                                    .frame(width: 3, height: 28)
                                    .foregroundStyle(Sources.label)
                                    .clipShape(RoundedRectangle(cornerRadius: 3))
                                    .rotationEffect(.degrees(135))
                            }
                            .frame(width: 60, height: 60)
                        }
                        .clipShape(
                            Capsule()
                        )
                        Text("초기화")
                            .foregroundStyle(Sources.label)
                            .font(.system(size: 24, weight: .medium))
                    }
                }
                Spacer()
                VStack(spacing: 10) {
                    switch viewModel.timerState {
                    case .initialized:
                        EmptyView()
                    case .finished:
                        Button {
                            viewModel.setTimer(time: 300)
                            viewModel.startTimer()
                        } label: {
                            Sources.clockwiseArrow
                                .frame(width: 60, height: 60)
                        }
                        .background(.white)
                        .clipShape(
                            Capsule()
                        )
                        Text("5분 더")
                            .foregroundStyle(Sources.label)
                            .font(.system(size: 24, weight: .medium))
                    case .running:
                        Button {
                            viewModel.stopTimer()
                        } label: {
                            HStack {
                                Rectangle()
                                    .frame(width: 3, height: 24)
                                    .foregroundStyle(Sources.primary)
                                    .clipShape(RoundedRectangle(cornerRadius: 3))
                                Rectangle()
                                    .frame(width: 3, height: 24)
                                    .foregroundStyle(Sources.primary)
                                    .clipShape(RoundedRectangle(cornerRadius: 3))
                            }
                            .frame(width: 60, height: 60)
                        }
                        .background(Sources.darkPrimary)
                        .clipShape(
                            Capsule()
                        )
                        Text("정지")
                            .foregroundStyle(Sources.label)
                            .font(.system(size: 24, weight: .medium))
                    case .stopped:
                        Button {
                            viewModel.startTimer()
                        } label: {
                            Sources.triangle
                                .frame(width: 60, height: 60)
                        }
                        .background(.white)
                        .clipShape(
                            Capsule()
                        )
                        Text("시작")
                            .foregroundStyle(Sources.label)
                            .font(.system(size: 24, weight: .medium))
                    }
                }
            }
            .frame(width: 300)
            .padding(.bottom, 50)
        }
        .sheet(isPresented: $viewModel.isShowTimeSetterDialog) {
            VStack {
                Text("타이머 시간 설정")
                    .foregroundStyle(Sources.label)
                    .font(.system(size: 32, weight: .medium))
                
                ZStack {
                    Circle()
                        .frame(width: 300, height: 300)
                        .foregroundStyle(.red)
                    
                    Circle()
                        .frame(width: 100, height: 100)
                        .foregroundStyle(.blue)
                        .offset(
                            x: currentPosition.width + dragAmount.width,
                            y: currentPosition.height + dragAmount.height
                        )
                        .animation(.easeInOut, value: dragAmount)
                        .gesture(
                            DragGesture()
                                .updating($dragAmount) { value, state, _ in
                                    let newTranslation = value.translation
                                    
                                    // radius
                                    let clockRadius: CGFloat = 150
                                    let pointerRadius: CGFloat = 50
                                    let limit = clockRadius - pointerRadius
                                    let newX = currentPosition.width + newTranslation.width
                                    let newY = currentPosition.height + newTranslation.height
                                    
                                    if sqrt(newX * newX + newY * newY) <= limit {
                                        state = newTranslation
                                    } else {
                                        let angle = atan2(newTranslation.height, newTranslation.width)
                                        state = CGSize(
                                            width: cos(angle) * limit - currentPosition.width,
                                            height: sin(angle) * limit - currentPosition.height
                                        )
                                    }
                                }
                                .onEnded { _ in
                                    currentPosition = .zero
                                }
                        )
                }
                .frame(width: 300, height: 300)
                
                Spacer()
                HStack(spacing: 20) {
                    Button {
                        viewModel.isShowTimeSetterDialog.toggle()
                    } label: {
                        Text("닫기")
                            .foregroundStyle(Sources.label)
                            .font(.system(size: 18, weight: .semibold))
                    }
                    Button {
                        viewModel.isShowTimeSetterDialog.toggle()
                        viewModel.setTimer(time: time)
                    } label: {
                        Text("설정")
                            .foregroundStyle(
                                time == 0 ? Sources.darkPrimary : Sources.primary
                            )
                            .font(.system(size: 18, weight: .semibold))
                    }
                    .disabled(time == 0)
                }
            }
            .padding(32)
            .frame(width: 500, height: 500)
        }
        .sheet(isPresented: $viewModel.isShowResetDialog) {
            VStack {
                Text("타이머를 초기화 하시겠습니까?")
                    .foregroundStyle(Sources.label)
                    .font(.system(size: 24, weight: .medium))
                    .padding(.top, 32)
                Spacer()
                HStack(spacing: 20) {
                    Button("취소") {
                        viewModel.isShowResetDialog.toggle()
                    }
                    Button("확인") {
                        viewModel.isShowResetDialog.toggle()
                        viewModel.resetTimer()
                    }
                }
                .padding(.bottom, 32)
            }
            .frame(width: 380, height: 160)
        }
    }
}

#Preview {
    TimerView()
}
