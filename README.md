## **💡1. 프로젝트 개요**

**1-1. 프로젝트 소개**
- 프로젝트 명 : 인공지능기반의 노인 낙상 예측 시스템 구현
- 프로젝트 정의 : 실시간 낙상 예측 및 감지 시스템</br>
  <img width="800" height="800" alt="image" src="https://lh3.googleusercontent.com/rd-gg/AAHar4fE6_wbV_HcE8g2MzERQv8Avs5YJ4Yv9PJm_VOnX9dMeCuiDMA2HsYRIk0z7JEtKeVcEzCVQf2tz4CyqO0aPyuG6KXcWEi2HCrm0_DoRXTKZaFTkKkvzn5_KEgZbGJcz31mPCG_w46F621B8pCvkBkHyaMoc88tNiWCjyW2uuwSeKOnJFsD6iuDIUIzKWRVzYP4EVzteJnCxiQKnXsZIcahYHylNCk1IbzuvbXgxsFTsKAS08ImJqeD_09Vd-xHZ2VdOBg5NKKnVhA6c1RqWUcoyWrah9zydX7qj3kIYTVqvbFOSTeXx6h57nnpPOMSBjoVp-KVg9ZfkLRHDNSObTLcNi-Vo-f7_U8yiE1BTZk3oik9VRctBp1E6xHq_-I2I-HD544OYGbAUP_nTf9QXRfXC8T9zRaSgFSRAAbtaA32a7d2zeOF4UNn4NZ0T6GR4dd5hq309idJwLx5-hI7ODSHUvPTobNQFKjS49hq_J8ZJqt2vQFlV3ggInKJEuwh1Kv1bfKnK4BNYmQQ8nmv2nwWcdQa2nUZJvxqpoSh-jSynbTwlXYAR3YLGdlJNJKbPlUtbT_2PCiRe3k-YHfbmHWz7OkU9lBcvT3cjx-mA9DPdCbh8XPKzPWhau1EFD-8XJ644MYNYk6mK1fRyWpz4FZLvzbWHCSo5bxh5suD2jD9stbIMplDz75E0JST_JzJHXtnfyNOpVzzGraUAI3zE-Gc1zCmPnyTm5aMpzCsnCSbb-KRJHdD5-7Udi_zeHHGb2fxZwXv0XOOaiIMjKqHXnFwckQL_IJcLlzbxO-Zi1lzK8pxJ4aDvCoHN525dVfRSPs-kTP9a3lP-X9BdN3StM77rhd-w60ZyCvbgoMNbUv-CD1aE5vIellfUztAihXU6-cMATtG0mlanAeynSp1ZRpQkCUz-QYapSnxrzfSR5LMs2TGr16jxa_uyRLAlPTnRRZnSj4U20anPjY_baL0PKdumGTcLY6_G_qSnlkgH__q3WoeTaNbjkmmUXerPr0a0kKWXQXmTGUANmX4xiCtKSo0-8ov-xsGnuzjrD-kBck0BFjTek1dkzmPM-D6xt_tvrU-4ipbwyaZgfm0-7LF5vaSwzHSrNO3USkcP5wIwIx6sX0iRcgVv8HQANbdH9RxR6JEKsvctYqRQMwA7967aPAWaqlsaEM-01IigBGffVVbmN-g8kMS9xwFgU0xTv0ZBqS2693JJRajrTeZOaB_1xMX3vPUqwowx82G7wKrhhgwBMzMf2do-g5qj78nhZLKQh6JA7Ma_QXwfOGZVtPFuyfv9dM05Zv4yg=s1024" style="display:block;margin:0 auto" />

**1-2. 개발 배경 및 필요성**
- 낙상 후 사망률이 높아 예방과 신속한 대응이 필수적이다. 기존의 낙상 감지 시스템(CCTV, 웨어러블 기기, 응급 버튼 등)은 개인정보 보호, 착용 거부감, 비효율적인 감지 등의 한계를 가진다. 이를 해결하기 위해 인공지능(AI) 기반 실시간 낙상 예측 및 감지 시스템이 필요하다.

**1-3. 프로젝트 특장점**
- 병실 CCTV 영상을 활용하여 낙상 사건을 자동으로 식별하고 분류하는 영상 기반 낙상 감지 시스템을 제안한다. 제안하는 시스템은 YOLOv8 기반 객체 탐지, AlphaPose를 활용한 정밀 자세 추정, 그리고 ST-GCN을 이용한 시공간적 행동 분석을 결합하여 환자의 상태를 정밀하게 분류하고 실제 낙상 여부를 판단하도록 설계되었다. 이 시스템은 신속한 대응을 가능하게 하며, 비침습적인 방식으로 환자 안전을 
크게 향상시키고 의료비 절감에 기여한다.

**1-4. 소프트웨어(S/W) 주요 기능**
- 실시간 객체 탐지 : YOLOv8 기반으로 환자 및 의료진을 실시간으로 인식하여 사람의 위치를 추출함
- 포즈 추정 및 자세 분석 : AlphaPose를 통해 사람의 관절 위치를 추출하고, 낙상 위험 행동(넘어짐, 쓰러짐 등)을 분석함
- 의미 기반 추천 : 단순한 ‘정확 단어 일치’가 아닌 맥락과 의미를 기반으로 한 결과 제공
- 맞춤형 필터링 및 정렬 : 사용자 성향에 따라 검색 결과 필터 및 순위 조정
- 멀티플랫폼 지원 : 웹·모바일 등 다양한 기기 환경에서 최적화된 검색 경험 제공

**1-5. 하드웨어(H/W) 주요 기능**
- 카메라 : 카메라를 활용한 실시간 영상 수집
- 테스트 및 실증 침대 : 데이터 수집 및 실증 침대 구현

**1-6. 기대 효과 및 활용 분야**
- 기대 효과 : 비접촉 및 비침습성 모니터링, 높은 실시간성 및 정확도, 비용 효율성
- 활용 분야 : 의료 및 요양 시설, 가정 내 스마트 헬스케어

**1-7. 기술 스택**
- 프론트엔드 : Html, CSS3, Javascript, VueJS 3, Fetch API
- 백엔드 : Express.js(NodeJS)
- AI/ML : OpenCV, Yolo, AlphpPose, ST-GCN
- 데이터베이스 : MySQL 8.0

---

## **💡2. 팀원 소개**
| <img width="80" height="100" src="/profiles/1.jpg"> | <img width="80" height="100" alt="image" src="/profiles/2.jpg"> | <img width="80" height="100" alt="image" src="/profiles/3.jpg"> | <img width="80" height="100" alt="image" src="/profiles/4.jpg"> | <img width="80" height="100" alt="image" src="/profiles/5.png"> | <img width="80" height="100" alt="image" src="/profiles/6.jpg"> | <img width="80" height="100" alt="image" src="/profiles/7.png"> |
|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
| **김철응** | **심가은** | **이유빈** | **김백강** | **유민지** | **최지훈** | **안영휘** |
| • 팀장 <br> • 데이터수집 | • 서류작성&취합 | • 기술개발 | • 장비점검 | • 데이터분석 | • 프로젝트 멘토 | • 지도교수 |
---
## **💡3. 시스템 구성도**

- 하드웨어 구성도
<img width="800" height="800" alt="image" src="https://t1.daumcdn.net/cafeattach/yv8a/c014b06c344c1c02f283e0884bbaba7d6a42e642" style="display:block;margin:0 auto" />

- 소프트웨어 구성도
<img width="800" height="800" alt="image" src="https://t1.daumcdn.net/cafeattach/yv8a/423d9fe516f659dbc2124dc4de2d774f8db44183" style="display:block;margin:0 auto" />

- 프로세스 흐름도
<img width="800" height="800" alt="image" src="https://t1.daumcdn.net/cafeattach/yv8a/42427bb0f59a591e51d134202dc2abb089f5301d" style="display:block;margin:0 auto" />

---
## **💡4. 작품 소개영상**

[![한이음 드림업 프로젝트 소개](https://t1.daumcdn.net/cafeattach/yv8a/843e82472337eda73d22f5ce5f4b9beb3c9cfece)](https://youtu.be/Z6AcirN5684?si=LVQE4deD56aUPQWe)

---
## **💡5. 핵심 소스코드**
- 소스코드 설명 : API를 활용해서 자동 배포를 생성하는 메서드입니다.

```python
    for i, track in enumerate(tracker.tracks):
        if not track.is_confirmed():
            continue
    
        track_id = track.track_id
        bbox = track.to_tlbr().astype(int)
        center = track.get_center().astype(int)

        action = 'pending..'
        clr = (0, 255, 0)

        if len(track.keypoints_list) == 30: #스켈레톤 데이터의 좌표 추출해서 30개인지 확인(유효한 값 확인)
            pts = np.array(track.keypoints_list, dtype=np.float32)
            out = action_model.predict(pts, frame.shape[:2]) #스켈레톤 데이터로 자세 예측
            action_name = action_model.class_names[out[0].argmax()]
            action = '{}: {:.2f}%'.format(action_name, out[0].max() *100)
            if action_name == 'Fall Down':
                clr = (255, 0, 0)
            elif action_name == 'Lying Down':
                clr = (255, 200, 0)

```





