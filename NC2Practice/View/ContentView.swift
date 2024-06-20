//
//  ContentView.swift
//  NC2Practice
//
//  Created by 신혜연 on 6/16/24.
//

import SwiftUI
import CoreNFC
import UserNotifications

struct ContentView: View {
    @State private var selection = 1
    let options = ["남자층", "여자층"]
    
    @State private var showCarousel = false
    @State private var remainingTime = 0
    @State private var timer: Timer? = nil
    @State private var showingFinishingView = false
    @State private var showingSettingView = false
    
    @State private var selectedWasher: String? = nil
    @State private var selectedDryer: String? = nil
    @State private var selectedTitle: String = ""
    
    var body: some View {
        ZStack {
            Color.Background.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            // 시간 추가
            VStack(spacing: 10) {
                if showCarousel {
                    TimerCardView(remainingTime: $remainingTime, showingFinishingView: $showingFinishingView, showCarousel: $showCarousel, title: selectedTitle, selectedWasher: $selectedWasher, selectedDryer: $selectedDryer)
                        .transition(.scale)
                }
                Button(action: {
                    startNFCTagging()
                }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .frame(width: 360, height: 102)
                            .foregroundColor(Color.mainblue)
                        HStack {
                            Text("타이머 설정하기")
                                .font(.system(size: 24))
                                .bold()
                                .foregroundColor(Color.textwhite)
                            
                            Image(systemName: "plus.circle")
                                .font(.system(size: 24))
                                .foregroundColor(Color.textwhite)
                                .bold()
                        }
                    }
                }
                .padding(.vertical, 5)
                
                // 남자/여자층 구분
                Picker("Options", selection: $selection) {
                    ForEach(options.indices, id: \.self) { index in
                        Text(options[index]).tag(index)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal, 130)
                .padding(.bottom, 20)
                
                if selection == 0 {
                    MaleView(selectedWasher: $selectedWasher, selectedDryer: $selectedDryer)
                } else {
                    FemaleView(selectedWasher: $selectedWasher, selectedDryer: $selectedDryer, title: $selectedTitle)
                }
                
                Spacer()
            }
        }
        .onAppear {
            // MARK: 시작할 때 Notification 권한 설정
            NotificationManager.shared.requestNotificationPermission()
            
            NotificationCenter.default.addObserver(forName: NSNotification.Name("ShowFinishingView"), object: nil, queue: .main) { _ in
                //push 클릭 시 FinishingView 표시
                showingFinishingView = true
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("StartTimer"))) { notification in
            if let userInfo = notification.userInfo,
               let _ = userInfo["device"] as? String {
                withAnimation {
                    showCarousel = true
                }
                if selectedWasher != nil {
                    remainingTime = 47 * 60
                } else if selectedDryer != nil {
                    remainingTime = 45 * 60
                } else {
                    remainingTime = 46 * 60
                }
                startTimer()
                showingSettingView = true
            }
        }
        .sheet(isPresented: $showingSettingView) {
            SettingWasherView(title: $selectedTitle)
        }
    }
    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if remainingTime > 0 {
                remainingTime -= 1
            } else {
                timer?.invalidate()
                //notification 넣기
                NotificationManager.shared.scheduleLocalNotification()
                showingFinishingView = true
                
                selectedWasher = nil
                selectedDryer = nil
                
            }
        }
    }
}

struct TimerCardView: View {
    @Binding var remainingTime: Int
    
    @Binding var showingFinishingView: Bool
    @Binding var showCarousel: Bool
    
    let title: String
    @Binding var selectedWasher: String?
    @Binding var selectedDryer: String?
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .frame(width: 360, height: 102)
                .foregroundColor(Color.mainblue)
                .gesture(swipeGesture)
            
            HStack {
                VStack() {
                    Text(title)
                        .bold()
                        .font(.system(size: 18))
                        .foregroundColor(Color.textwhite)
                        .padding(.trailing, 30)
                    HStack {
                        Button(action: {
                            remainingTime = max(0, remainingTime - 600)
                        }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 4)
                                    .frame(width: 45, height: 26)
                                    .foregroundColor(Color.subblue)
                                Text("-1분")
                                    .foregroundColor(Color.textwhite)
                                    .font(.system(size: 14))
                                    .fontWeight(.semibold)
                            }
                        }
                        Button(action: {
                            remainingTime += 60
                        }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 4)
                                    .frame(width: 45, height: 26)
                                    .foregroundColor(Color.subblue)
                                Text("+1분")
                                    .foregroundColor(Color.textwhite)
                                    .font(.system(size: 14))
                                    .fontWeight(.semibold)
                            }
                        }
                    }
                }
                
                Spacer()
                
                VStack {
                    HStack(spacing: 3) {
                        Image(systemName: "clock")
                            .bold()
                            .font(.system(size: 12))
                            .foregroundColor(Color.textwhite)
                        Text("남은 시간")
                            .fontWeight(.semibold)
                            .font(.system(size: 12))
                            .foregroundColor(Color.textwhite)
                    }
                    Text(formatTime(remainingTime))
                        .bold()
                        .foregroundColor(Color.textwhite)
                        .font(.system(size: 30))
                }
                .foregroundColor(.white)
            }
            .padding(.horizontal, 40)
        }
        .sheet(isPresented: $showingFinishingView) {
            FinishingView(showCarousel: $showCarousel)
        }
    }
    private func formatTime(_ totalSeconds: Int) -> String {
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    private var swipeGesture: some Gesture {
        DragGesture()
            .onEnded { _ in
                showCarousel = false
                selectedWasher = nil
                selectedDryer = nil
            }
    }
}

extension Color {
    static let mainblue = Color("MainBlue")
    static let mainmint = Color("MainMint")
    static let dgray = Color("DGray")
    static let textwhite = Color("TextWhite")
    static let Background = Color("Background")
    static let Text = Color("Text")
    static let subtext = Color("SubText")
    static let dwhite = Color("DWhite")
    static let subblue = Color("SubBlue")
    static let submint = Color("SubMint")
}

#Preview {
    ContentView()
}
