//
//  SettingView.swift
//  NC2Practice
//
//  Created by 신혜연 on 6/18/24.
//

import SwiftUI

struct SettingWasherView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var title: String
    
    var body: some View {
        ZStack(alignment: .top){
            Color(Color.Background).ignoresSafeArea()
            VStack(alignment: .center, spacing: 0){
                
                HStack{
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("홈으로 돌아가기")
                            .font(
                                Font.custom("Pretendard", size: 18)
                                    .weight(.semibold)
                            )
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color.mainblue)
                        Image(systemName:"arrow.counterclockwise")
                            .foregroundColor(Color.mainblue)
                    }
                }
                .padding(.bottom,34)
                .padding(.top,35)
                
                VStack(alignment: .center, spacing: 0){
                    Text(title)
                        .bold()
                        .font(.system(size: 28))
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color.black)
                        .padding(.bottom,10)
                    
                    // Body Medium
                    Text("타이머가 설정되었습니다!")
                        .font(
                            Font.custom("Pretendard", size: 14)
                                .weight(.medium)
                        )
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color.subtext)
                }
                .padding(.bottom,46)
                
                ZStack {
                    if title.contains("세탁기") {
                        Image("source1")
                            .resizable()
                            .frame(width: 394, height: 528)
                    } else if title.contains("건조기") {
                        Image("source3")
                            .resizable()
                            .frame(width: 394, height: 528)
                    } else {
                        Image("source1")
                            .resizable()
                            .frame(width: 394, height: 528)
                    }
                }
            }
        }
    }
}
