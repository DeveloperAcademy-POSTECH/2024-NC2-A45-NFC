# 2024-NC2-A45-NFC
<img src="https://github.com/DeveloperAcademy-POSTECH/2024-NC2-A45-NFC/assets/126846444/95b3b285-20fd-43eb-b8eb-e92ef033ace3" width="100" height="100"/> <br>
### 해피와 지지(a.k.a 해피지)가 만든<br>
**18동 생활관의 슬기로운 세탁생활을 위한 NFC 활용 타이머 설정 앱, 띠-딕빨래** <br><br>

## 🎥 Youtube Link
(추후 만들어진 유튜브 링크 추가)
<br><br>
## 💳 NFC란?
> **Near Field Communication, 근거리 무선 통신 기술**
* 짧은 거리(약 4cm 이내)에서 무선 신호를 통해 장치 간 데이터를 전송하는 기술
* 앱 내 태그 읽기 / 백그라운드 태그 읽기를 지원
* 비접촉 결제, 전자 티켓, 디지털 신분증 및 정보 교환에 사용  
<br>

### Core NFC
> **iOS 11 이후 버전에서 사용 가능하며 iOS 및 iPadOS 장치에서 근거리 무선 통신(NFC) 기능을 활용할 수 있게 해주는 프레임워크**
<br>

## 🎯 What we focus on?
* 현재 배치된 기숙사 세탁기와 직접적인 NFC 연동이 불가능 하니,<br>
외부 하드웨어(Tag Sticker)와 스마트폰 간의 데이터 교환을 해보자.ᐟ
* 백그라운드 태그 읽기 말고 앱 내 태그 읽기로 구현하자.ᐟ
* **제발 NFC 태그라도 구현해보자.ᐟ**
<br><br>
## 💼 Use Case
![Group 30](https://github.com/DeveloperAcademy-POSTECH/2024-NC2-A45-NFC/assets/126846444/496455c5-0877-4d38-8d6a-921485269034)
### 💡 18동 생활관 사생들의 세탁기기 이용의 불편함을 줄여주자!
> 직접 타이머를 설정하지 않아도 NFC 태그를 통해 자동으로 타이머를 설정해주고 <br>

> 내가 현재 어느 세탁기기를 사용하고 있는지 사용 중인 세탁기기의 위치를 시각적으로 확인이 가능한, <br>

> 세탁기기가 끝나면 종료 알림(타이머)을 알려주는 앱 <br>

<br>

## 🖼️ Prototype
<img width="729" alt="image" src="https://github.com/DeveloperAcademy-POSTECH/2024-NC2-A45-NFC/assets/126846444/0e639b7c-ad3e-47cf-bd83-3bdc95d88f79"> <br>

1️⃣ 18동 생활관 내 세탁실을 남자층과 여자층을 구분해 보여줌 <br>

2️⃣ 사용하려는 세탁기기를 선택 후 타이머 설정하기 버튼을 눌러 태그 <br>
    → 스캔이 되면 47분(세탁기) 타이머가 설정됨 <br>
    
3️⃣ 타이머 -1분/+1분 버튼을 통해 섬세한 시간 조정 <br>

4️⃣ 경험상 빨래가 끝나면 미리 내려와있도록 종료 시간보다 일찍 알람을 맞추거나(-1분),<br>
    NFC 태그를 미리한 경우(+1분) 두 가지를 고려함 <br>
     * 시연을 위해 -1분의 기능을 -10분이 되도록 하였습니다. <br>
     
5️⃣ 세탁 기기의 시간이 끝나면 종료 알림(Notification)과 함께, 세탁 완료 뷰를 보여줌 <br>

6️⃣ 다시 메인 화면으로 돌아가면 화면이 리셋됨 <br>

***

☑️ 세탁기와 건조기의 UI를 다르게 표현해 사용자가 구분할 수 있도록 함 <br>

☑️ 건조기도 NFC 스캔을 통해 45분(건조기)의 타이머가 자동 설정됨 <br>

☑️ 시간이 모두 흐르면 세탁기와 동일하게 세탁 완료 뷰를 보여줌 <br>

☑️ 타이머 설정 후 슬라이딩하면 설정한 타이머가 무효화됨 


<br><br>

## 🛠️ About Code
> 뷰에서 NFC Reader 세션 활성화 및 태그 감지 코드 <br>

**NFCManager : NFC 태그 리딩 및 리딩한 데이터를 기반으로 특정 기기를 식별해 타이머 시작** <br>

<pre>
<code> import CoreNFC

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
                  // 기기에 정보 전달
                  NotificationCenter.default.post(name: NSNotification.Name("StartTimer"), object: nil, userInfo: ["device": deviceIdentifier])
              }
          }
      }
    
    func identifyDevice(from tag: NFCTag) -> String {
        return "세탁기" // or "건조기"
    }
    
    func tagReaderSessionDidBecomeActive(_ session: NFCTagReaderSession) {
        // 세션이 활성화
    }
    
    func tagReaderSession(_ session: NFCTagReaderSession, didInvalidateWithError error: Error) {
        // 세션이 오류로 인해 무효화
        if let readerError = error as? NFCReaderError, readerError.code != .readerSessionInvalidationErrorFirstNDEFTagRead {
            print("NFC Reader Session 오류: \(error.localizedDescription)")
        }
    }
}
</code> </pre>
