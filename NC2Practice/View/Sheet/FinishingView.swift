//
//  FinishingView.swift
//  NC2Practice
//
//  Created by 신혜연 on 6/18/24.
//

import SwiftUI

struct FinishingView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var showCarousel: Bool
    
    var body: some View {
        ZStack(alignment: .top){
            Color(Color.Background).ignoresSafeArea()
            VStack(alignment: .center, spacing: 0){
                
                HStack {
                    Button(action: {
                        showCarousel = false
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
                
                VStack(alignment: .center, spacing: 0) {
                    Text("세탁이 완료되었어요!")
                        .bold()
                        .font(.system(size: 28))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black)
                        .padding(.bottom,10)
                    
                    // Body Medium
                    Text("세탁물을 가져가주세요.")
                        .font(
                            Font.custom("Pretendard", size: 14)
                                .weight(.medium)
                        )
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color.subtext)
                }
                .padding(.bottom,46)
                
                Image("source2")
                    .resizable()
                    .frame(width: 394, height: 380)
            }
        }
    }
}


#Preview {
    FinishingView(showCarousel: .constant(true))
}
