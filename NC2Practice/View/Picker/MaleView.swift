//
//  MaleView.swift
//  NC2Practice
//
//  Created by 신혜연 on 6/19/24.
//

import SwiftUI

struct MaleView: View {
    @Binding var selectedWasher: String?
    @Binding var selectedDryer: String?
    
    var body: some View {
        VStack {
            Text("사용하려는 세탁기기를 선택 후 타이머를 설정하세요.")
                .foregroundColor(Color.subtext)
                .font(.system(size: 12))
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
            
            // 2F
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .frame(width: 361, height: 163)
                    .foregroundColor(.white)
                HStack {
                    Text("2F")
                        .font(.system(size: 18))
                        .foregroundColor(Color.mainblue)
                        .padding(.leading, 20)
                    
                    // 세탁기2
                    Button {
                        selectedWasher("세탁기 2")
                    } label: {
                        Washer(title: "세탁기 2", isSelected: selectedWasher == "세탁기 2")
                    }
                    
                    Spacer()
                    
                    // 세탁기3
                    Button {
                        selectedWasher("세탁기 3")
                    } label: {
                        Washer(title: "세탁기 3", isSelected: selectedWasher == "세탁기 3")
                    }
                    
                    Spacer()
                    
                    // 건조기2
                    Button {
                        selectedDryer("건조기 2")
                    } label: {
                        Dryer(title2: "건조기 2", isSelected2: selectedDryer == "건조기 2")
                    }
                }
                .padding(.horizontal, 26)
            }
            
            // 1F
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .frame(width: 361, height: 163)
                    .foregroundColor(.white)
                HStack {
                    Text("1F")
                        .font(.system(size: 18))
                        .foregroundColor(Color.mainblue)
                        .padding(.leading, 20)
                    
                    // 세탁기1
                    Button {
                        selectedWasher("세탁기 1")
                    } label: {
                        Washer(title: "세탁기 1", isSelected: selectedWasher == "세탁기 1")
                    }
                    
                    Spacer()
                    
                    // 건조기1
                    Button {
                        selectedDryer("건조기 1")
                    } label: {
                        Dryer(title2: "건조기 1", isSelected2: selectedDryer == "건조기 1")
                    }
                }
                .padding(.horizontal, 28)
            }
        }
    }
    private func selectedWasher(_ washer: String) {
           selectedWasher = washer
           selectedDryer = nil
       }
    
    private func selectedDryer(_ dryer: String) {
        selectedDryer = dryer
        selectedWasher = nil
    }
}

#Preview {
    @State var selectedWasher: String? = nil
    @State var selectedDryer: String? = nil
    
    return MaleView(selectedWasher: $selectedWasher, selectedDryer: $selectedDryer)
}
