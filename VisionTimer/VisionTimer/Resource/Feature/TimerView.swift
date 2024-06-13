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
        ZStack {
            VStack(alignment: .center, spacing: 0) {
                HStack(spacing: 8) {
                    Image(systemName: "bell.fill")
                        .foregroundStyle(Sources.label)
                    Text("\(viewModel.getAlarmEndTime())")
                        .foregroundStyle(Sources.label)
                        .font(.system(size: 20, weight: .semibold))
                }
                .padding(.top, 50)
                Text("\(viewModel.getTimeRemaining())")
                    .foregroundStyle(Sources.label)
                    .font(.system(size: 80, weight: .semibold))
                    .onTapGesture {
                        viewModel.onTapTimeSetter()
                    }
                Spacer()
                HStack {
                    VStack(spacing: 10) {
                        if viewModel.timerState != .initialized {
                            Button {
                                viewModel.resetTimer()
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
                                .font(.system(size: 16, weight: .medium))
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
                                .font(.system(size: 16, weight: .medium))
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
                                .font(.system(size: 16, weight: .medium))
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
                                .font(.system(size: 16, weight: .medium))
                        }
                    }
                }
                .frame(width: 300)
                .padding(.bottom, 50)
            }
            .frame(maxWidth: 500, maxHeight: 500)
            .sheet(isPresented: $viewModel.isShowTimeSetterDialog) {
                VStack {
                    Text("타이머 시간 10초로 설정")
                    Button {
                        viewModel.isShowTimeSetterDialog.toggle()
                        viewModel.setTimer(time: 10)
                    } label: {
                        Text("설정")
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Sources.container)
            }
            .sheet(isPresented: $viewModel.isShowResetDialog) {
                VStack {
                    Text("타이머를 초기화 하시겠습니까?")
                    HStack(spacing: 20) {
                        Button("취소") {
                            viewModel.isShowResetDialog.toggle()
                        }
                        .frame(width: 100)
                        Button("확인") {
                            viewModel.resetTimer()
                            viewModel.isShowResetDialog.toggle()
                        }
                        .frame(width: 100)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Sources.container)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Sources.background)
    }
}

#Preview {
    TimerView()
}
