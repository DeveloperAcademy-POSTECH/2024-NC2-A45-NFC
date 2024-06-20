//
//  ReadView.swift
//  NC2Practice
//
//  Created by 신혜연 on 6/19/24.
//

import SwiftUI
import CoreNFC

struct ReadView: View {
    @State private var readData: String = ""
    
    var body: some View {
        VStack {
            Text("읽은 데이터:")
                .font(.headline)
            
            Text(readData)
                .padding()
            
            Button(action: {
                NFCReadManager.shared.startSession { result in
                    switch result {
                    case .success(let data):
                        self.readData = data
                        print("읽은 데이터: \(data)")
                    case .failure(let error):
                        print("데이터 읽기 실패: \(error.localizedDescription)")
                    }
                }
            }) {
                Text("NFC 태그에서 데이터 읽기")
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
}

class NFCReadManager: NSObject, NFCTagReaderSessionDelegate {
    static let shared = NFCReadManager()
    
    private var session: NFCTagReaderSession?
    private var completion: ((Result<String, Error>) -> Void)?
    
    private override init() {
        super.init()
    }
    
    func startSession(completion: @escaping (Result<String, Error>) -> Void) {
        self.completion = completion
        
        guard NFCNDEFReaderSession.readingAvailable else {
            print("NFC 태그 읽기를 지원하지 않는 기기입니다.")
            completion(.failure(NFCError.readingUnavailable))
            return
        }
        
        session = NFCTagReaderSession(pollingOption: .iso14443, delegate: self)
        session?.begin()
    }
    
    func tagReaderSessionDidBecomeActive(_ session: NFCTagReaderSession) {
        // 사용하지 않을 경우 구현하지 않아도 됨
    }
    
    func tagReaderSession(_ session: NFCTagReaderSession, didInvalidateWithError error: Error) {
        print("NFC 리더기 오류: \(error.localizedDescription)")
        completion?(.failure(error))
    }
    
    func tagReaderSession(_ session: NFCTagReaderSession, didDetect tags: [NFCTag]) {
        guard let tag = tags.first else {
            session.invalidate(errorMessage: "태그를 찾을 수 없습니다.")
            completion?(.failure(NFCError.tagNotFound))
            return
        }
        
        session.connect(to: tag) { error in
            guard error == nil else {
                session.invalidate(errorMessage: "태그와 연결할 수 없습니다.")
                self.completion?(.failure(error!))
                return
            }
            
            if case let .miFare(miFareTag) = tag {
                miFareTag.readNDEF { message, error in
                    if let error = error {
                        session.invalidate(errorMessage: "NFC 태그에서 데이터 읽기 실패: \(error.localizedDescription)")
                        self.completion?(.failure(error))
                        return
                    }
                    
                    if let message = message {
                        let records = message.records
                        if let record = records.first,
                           let payloadString = self.parseTextPayload(from: record) {
                            print("읽은 페이로드: \(payloadString)")
                            self.completion?(.success(payloadString))
                        } else {
                            session.invalidate(errorMessage: "NDEF 메시지에 읽을 수 있는 데이터가 없습니다.")
                            self.completion?(.failure(NFCError.noData))
                        }
                    } else {
                        session.invalidate(errorMessage: "NDEF 메시지를 읽을 수 없습니다.")
                        self.completion?(.failure(NFCError.noMessage))
                    }
                }
            } else {
                session.invalidate(errorMessage: "지원하지 않는 태그 형식입니다.")
                self.completion?(.failure(NFCError.unsupportedTag))
            }
        }
    }
    
    private func parseTextPayload(from record: NFCNDEFPayload) -> String? {
        guard record.typeNameFormat == .nfcWellKnown else { return nil }
        guard let payload = String(data: record.payload.advanced(by: 3), encoding: .utf8) else { return nil }
        return payload
    }
}

enum NFCError: Error {
    case readingUnavailable
    case tagNotFound
    case noData
    case noMessage
    case unsupportedTag
}

struct ReadView_Previews: PreviewProvider {
    static var previews: some View {
        ReadView()
    }
}

