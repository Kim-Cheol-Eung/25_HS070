## **💡1. 프로젝트 개요**

**1-1. 프로젝트 소개**
- 프로젝트 명 : 인공지능기반의 노인 낙상 예측 시스템 구현
- 프로젝트 정의 : 실시간 낙상 예측 및 감지 시스템</br>
  <img width="800" height="800" alt="image" src="https://t1.daumcdn.net/cafeattach/yv8a/f9a34015f3093426cda13865a67b755c1e97ab96" style="display:block;margin:0 auto" />

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
- 적외선(열화상) 카메라 : 카메라를 활용한 실시간 영상 수집
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
| <img width="80" height="100" src="https://pics.craiyon.com/2024-03-29/TAgYq3VcQKe3IkDw6PBd1A.webp"> | <img width="80" height="100" alt="image" src="https://image2.1004gundam.com/item_images/goods/380/1376406813.jpg"> | <img width="80" height="100" alt="image" src="https://image2.1004gundam.com/item_images/goods/380/1376406811.jpg"> | <img width="80" height="100" alt="image" src="https://www.sideshow.com/storage/product-images/903245/green-ranger-dragonzord_mighty-morphin-power-rangers_feature.jpg"> | <img width="80" height="100" alt="image" src="https://e7.pngegg.com/pngimages/767/8/png-clipart-kimberly-hart-katherine-hillard-pink-super-sentai-mighty-morphin-power-rangers-power-rangers-fictional-character-magenta-thumbnail.png"> | <img width="80" height="100" alt="image" src="https://m.herotime.co.kr/web/product/big/202312/852289aa69b6ac9eb8d5f4d03be0c40f.png"> | <img width="80" height="100" alt="image" src="https://ecimg.cafe24img.com/pg168b06062900060/asl1052/web/product/big/20240401/cb914c20ffcaf86d6d8f593f8420793b.jpg"> |
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

> **참고**: 썸네일과 유튜브 영상을 등록하는 방법입니다.
```Python
아래와 같이 작성하면, 썸네일과 링크등록을 할 수 있습니다.
[![영상 제목](유튜브 썸네일 URL)](유튜브 영상 URL)

작성 예시 : 저는 다음과 같이 작성하니, 아래와 같이 링크가 연결된 썸네일 이미지가 등록되었네요! 
[![한이음 드림업 프로젝트 소개](https://t1.daumcdn.net/cafeattach/yv8a/843e82472337eda73d22f5ce5f4b9beb3c9cfece)](https://youtu.be/Z6AcirN5684?si=LVQE4deD56aUPQWe)
```
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