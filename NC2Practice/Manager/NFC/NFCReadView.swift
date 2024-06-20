//
//  NFCReadView.swift
//  NC2Practice
//
//  Created by 신혜연 on 6/18/24.
//

import SwiftUI
import CoreNFC

// NFC 리더기 세션을 관리하는 클래스
class NFCReadSessionDelegate: NSObject, NFCNDEFReaderSessionDelegate {
    var deviceNum: String = ""
    var deviceType: String = ""
    
    // NFC 태그에서 NDEF 메시지를 읽었을 때 호출되는 메서드
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        
        guard let message = messages.first else {
            self.deviceNum = "NFC 태그에 데이터가 없습니다."
            self.deviceType = ""
            return
        }
        
        for record in message.records {
            guard let payloadString = String(data: record.payload.advanced(by: 3), encoding: .utf8) else {
                self.deviceNum = "데이터를 읽는 중에 오류가 발생했습니다."
                self.deviceType = ""
                return
            }
            
            if self.deviceNum.isEmpty {
                self.deviceNum = payloadString
                print(deviceNum)
            } else {
                self.deviceType = payloadString
                print(deviceType)
            }
        }
    }
    
    // NFC 리더기 세션이 오류로 인해 종료될 때 호출되는 메서드
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        if let readerError = error as? NFCReaderError {
            if readerError.code == .readerSessionInvalidationErrorFirstNDEFTagRead {
                print("첫 번째 NDEF 태그를 성공적으로 읽었습니다.")
            } else {
                print("NFC Reader Session 오류: \(error.localizedDescription)")
            }
        }
    }
    
    // NFC 리더기 세션이 활성화될 때 호출되는 메서드
    func readerSessionDidBecomeActive(_ session: NFCNDEFReaderSession) {
        print("NFC 리더기 세션이 활성화되었습니다.")
        DispatchQueue.main.async {
            self.deviceNum = "기기 번호를 읽는 중입니다."
            self.deviceType = "기기 종류를 읽는 중입니다."
        }
    }
    
    
}

// NFC 태그 데이터 읽기 화면
struct NFCReadView: View {
    //    @State private var deviceNum: String = "기기 번호가 여기에 표시됩니다."
    @State private var deviceType: String = "기기 종류가 여기에 표시됩니다."
    @State private var session: NFCNDEFReaderSession?
    @State private var delegate = NFCReadSessionDelegate()
    
    var body: some View {
        VStack {
            Text("기기 번호: \(delegate.deviceNum)")
                .padding()
            
            Text("기기 종류: \(deviceType)")
                .padding()
            
            Button(action: {
                self.startNFCReaderSession()
            }) {
                Text("NFC 태그에서 데이터 읽어오기")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
            }
            .padding()
            
            Spacer()
        }
        .padding()
        .navigationBarTitle("NFC 태그 데이터 읽기")
    }
    
    // NFC 리더기 세션 시작 메서드
    private func startNFCReaderSession() {
        guard NFCNDEFReaderSession.readingAvailable else {
            print("NFC 리더기를 지원하지 않는 기기입니다.")
            return
        }
        
        // NFC 리더기 세션의 델리게이트 설정
        self.session = NFCNDEFReaderSession(delegate: delegate, queue: .main, invalidateAfterFirstRead: true)
        self.session?.alertMessage = "NFC 태그를 인식 중입니다."
        self.session?.begin()
    }
}

struct NFCReadView_Previews: PreviewProvider {
    static var previews: some View {
        NFCReadView()
    }
}
