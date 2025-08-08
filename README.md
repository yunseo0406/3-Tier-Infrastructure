# NCP Terraform 3-Tier Infrastructure

Terraform을 이용해 **Naver Cloud Platform(NCP)**에 3티어 아키텍처를 자동 구축

## 구성 요소
- **네트워크**
  - VPC, Public Subnet(Web), Private Subnet(WAS/DB)
  - ACG(계층별 최소 권한), 기본 NACL
- **컴퓨팅**
  - Web 서버: External LB 연결, HTTP/ICMP 허용
  - WAS 서버: Internal LB 연결, Web 대역만 허용
- **로드밸런서**
  - External LB: 인터넷 → Web
  - Internal LB: Web → WAS
- **데이터베이스**
  - Cloud DB for MySQL, Private Subnet
- **보안**
  - Login Key로 SSH 접속
  - `.env`로 API Key 관리, Git에 민감정보 제외

## 동작 흐름
1. 외부 요청이 External LB를 통해 Web 서버로 전달
2. Web 서버가 Internal LB를 통해 WAS 서버 호출
3. WAS 서버가 Cloud DB에서 데이터 처리 후 응답
