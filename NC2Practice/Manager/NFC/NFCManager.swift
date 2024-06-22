//
//  NFCManager.swift
//  NC2Practice
//
//  Created by 신혜연 on 6/20/24.
//

import CoreNFC

// NFC 태그 세션 시작
func startNFCTagging() {
    let session = NFCTagReaderSession(pollingOption: .iso14443, delegate: NFCManager.shared)
    session?.alertMessage = "세탁기 및 건조기 옆 스티커를 스캔하십시오."
    session?.begin()
}

// NFC 태그 인식 및 데이터 읽기
final class NFCManager: NSObject, NFCTagReaderSessionDelegate {
    static let shared = NFCManager()
    func tagReaderSession(_ session: NFCTagReaderSession, didDetect tags: [NFCTag]) {
          guard let firstTag = tags.first else { return }
          
          session.connect(to: firstTag) { error in
              if let error = error {
                  session.invalidate(errorMessage: "Connection failed: \(error.localizedDescription)")
                  return
              }
              
              let deviceIdentifier = self.identifyDevice(from: firstTag)
              
              session.alertMessage = "시간이 설정되었습니다."
              session.invalidate()
              
              DispatchQueue.main.async {
                  // 기기 정보 전달
                  NotificationCenter.default.post(name: NSNotification.Name("StartTimer"), object: nil, userInfo: ["device": deviceIdentifier])
              }
          }
      }
    
    func identifyDevice(from tag: NFCTag) -> String {
        return "세탁기" // or "건조기"
    }
    
    func tagReaderSessionDidBecomeActive(_ session: NFCTagReaderSession) {
        // 세션이 활성화되었습니다.
    }
    
    func tagReaderSession(_ session: NFCTagReaderSession, didInvalidateWithError error: Error) {
        // 세션이 오류로 인해 무효화되었습니다.
        if let readerError = error as? NFCReaderError, readerError.code != .readerSessionInvalidationErrorFirstNDEFTagRead {
            print("NFC Reader Session 오류: \(error.localizedDescription)")
        }
    }
}
