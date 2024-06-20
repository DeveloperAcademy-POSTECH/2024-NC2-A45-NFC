//
//  NFCWriteView.swift
//  NC2Practice
//
//  Created by 신혜연 on 6/18/24.
//

import SwiftUI
import CoreNFC

struct NFCWriteView: View {
    @State private var deviceNum: String = ""
    @State private var deviceType: String = ""
    
    var body: some View {
        VStack {
            TextField("기기 번호", text: $deviceNum)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            TextField("기기 종류(세탁기 또는 건조기)", text: $deviceType)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button(action: {
                NFCWriteManager.shared.writeDeviceDataToTag(deviceNum: self.deviceNum, deviceType: self.deviceType) { success in
                    if success {
                        print("NFC 태그에 데이터 쓰기성공!")
                    } else {
                        print("NFC 태그에 데이터 쓰기 실패!")
                    }
                }
            }) {
                Text("NFC 태그에 데이터 쓰기")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
            }
            .padding()
            
            Spacer()
        }
        .padding()
        .navigationBarTitle("NFC 태그 스티커 입력")
    }
}

class NFCWriteManager: NSObject, NFCTagReaderSessionDelegate {
    static let shared = NFCWriteManager()
    
    private var session: NFCTagReaderSession?
    private var deviceNum: String?
    private var deviceType: String?
    private var completion: ((Bool) -> Void)?
    
    private override init() {
        super.init()
    }
    
    func writeDeviceDataToTag(deviceNum: String, deviceType: String, completion: @escaping (Bool) -> Void) {
        self.deviceNum = deviceNum
        self.deviceType = deviceType
        self.completion = completion
        
        guard NFCNDEFReaderSession.readingAvailable else {
            print("NFC 태그 쓰기를 지원하지 않는 기기입니다.")
            completion(false)
            return
        }
        
        session = NFCTagReaderSession(pollingOption: .iso14443, delegate: self)
        session?.begin()
    }
    
    func tagReaderSessionDidBecomeActive(_ session: NFCTagReaderSession) {
        // NFCTagReaderSessionDelegate 메서드, 사용하지 않을 경우 구현하지 않아도 됨
    }
    
    func tagReaderSession(_ session: NFCTagReaderSession, didInvalidateWithError error: Error) {
        print("NFC 리더기 오류: \(error.localizedDescription)")
        completion?(false)
    }
    
    func tagReaderSession(_ session: NFCTagReaderSession, didDetect tags: [NFCTag]) {
        guard let tag = tags.first else {
            session.invalidate(errorMessage: "태그를 찾을 수 없습니다.")
            completion?(false)
            return
        }
        
        session.connect(to: tag) { error in
            guard error == nil else {
                session.invalidate(errorMessage: "태그와 연결할 수 없습니다.")
                self.completion?(false)
                return
            }
            
            if case let .miFare(miFareTag) = tag {
                guard let deviceNum = self.deviceNum, let deviceType = self.deviceType else {
                    session.invalidate(errorMessage: "기기 번호 또는 기기 종류를 찾을 수 없습니다.")
                    self.completion?(false)
                    return
                }
                
                let payloadString = "\(deviceNum),\(deviceType)"
                print("Writing payload: \(payloadString)")
                
                if let payload = NFCNDEFPayload.wellKnownTypeTextPayload(string: payloadString, locale: Locale(identifier: "en")) {
                    let message = NFCNDEFMessage(records: [payload])
                    miFareTag.writeNDEF(message) { error in
                        if let error = error {
                            print("NFC 태그에 데이터 쓰기 실패: \(error.localizedDescription)")
                            session.invalidate(errorMessage: "NFC 태그에 데이터 쓰기 실패: \(error.localizedDescription)")
                            self.completion?(false)
                        } else {
                            print("NFC 태그에 데이터 쓰기 성공!")
                            session.invalidate() // 성공 시 세션 무효화
                            self.completion?(true)
                        }
                    }
                } else {
                    session.invalidate(errorMessage: "NDEF 페이로드 생성 실패")
                    self.completion?(false)
                }
            } else {
                session.invalidate(errorMessage: "지원하지 않는 태그 형식입니다.")
                self.completion?(false)
            }
        }
    }
}
