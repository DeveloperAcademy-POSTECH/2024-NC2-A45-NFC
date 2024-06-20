//
//  FemaleView.swift
//  NC2Practice
//
//  Created by 신혜연 on 6/19/24.
//

import SwiftUI

struct FemaleView: View {
    @Binding var selectedWasher: String?
    @Binding var selectedDryer: String?
    @Binding var title: String
    
    var body: some View {
        VStack {
            Text("사용하려는 세탁기기를 선택 후 타이머를 설정하세요.")
                .foregroundColor(Color.subtext)
                .font(.system(size: 12))
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
            
            // 4F
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .frame(width: 361, height: 163)
                    .foregroundColor(.white)
                HStack {
                    Text("4F")
                        .font(.system(size: 18))
                        .foregroundColor(Color.mainblue)
                        .padding(.leading, 20)
                    
                    // 세탁기6
                    Button {
                        selectedWasher("세탁기 6")
                        title = "세탁기 6"
                    } label: {
                        Washer(title: "세탁기 6", isSelected: selectedWasher == "세탁기 6")
                    }
                    
                    Spacer()
                    
                    // 건조기4
                    Button {
                        selectedDryer("건조기 4")
                        title = "건조기 4"
                    } label: {
                        Dryer(title2: "건조기 4", isSelected2: selectedDryer == "건조기 4")
                    }
                }
                .padding(.horizontal, 25)
            }
            
            // 3F
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .frame(width: 361, height: 163)
                    .foregroundColor(.white)
                HStack {
                    Text("3F")
                        .font(.system(size: 18))
                        .foregroundColor(Color.mainblue)
                        .padding(.leading, 20)
                    
                    // 세탁기4
                    Button {
                        selectedWasher("세탁기 4")
                        title = "세탁기 4"
                    } label: {
                        Washer(title: "세탁기 4", isSelected: selectedWasher == "세탁기 4")
                    }
                    
                    Spacer()
                    
                    // 세탁기5
                    Button {
                        selectedWasher("세탁기 5")
                        title = "세탁기 5"
                    } label: {
                        Washer(title: "세탁기 5", isSelected: selectedWasher == "세탁기 5")
                    }
                    
                    Spacer()
                    
                    // 건조기3
                    Button {
                        selectedDryer("건조기 3")
                        title = "건조기 3"
                    } label: {
                        Dryer(title2: "건조기 3", isSelected2: selectedDryer == "건조기 3")
                    }
                }
                .padding(.horizontal, 25)
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

struct Washer: View {
    let title: String
    let isSelected: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            Text(title)
                .font(.system(size: 10))
                .fontWeight(.semibold)
                .foregroundColor(Color.dwhite)
                .padding(.horizontal, 5)
                .padding(.vertical, 2)
                .background(isSelected ? Color.mainblue : Color.dgray)
                .clipShape(RoundedRectangle(cornerRadius: 5))
                .padding(.bottom, 4)
            Image(isSelected ? "washing" :"notworking")
                .resizable()
                .frame(width: 90, height: 90)
        }
    }
}

struct Dryer: View {
    let title2: String
    let isSelected2: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            Text(title2)
                .font(.system(size: 10))
                .fontWeight(.semibold)
                .foregroundColor(Color.dwhite)
                .padding(.horizontal, 5)
                .padding(.vertical, 2)
                .background(isSelected2 ? Color.mainmint : Color.dgray)
                .clipShape(RoundedRectangle(cornerRadius: 5))
                .padding(.bottom, 4)
            Image(isSelected2 ? "dryer" :"notworking")
                .resizable()
                .frame(width: 90, height: 90)
        }
    }
}

//#Preview {
//    @State var selectedWasher: String? = nil
//    @State var selectedDryer: String? = nil
//    @State var title: String? = nil
//    
//    return FemaleView(selectedWasher: $selectedWasher, selectedDryer: $selectedDryer)
//}
