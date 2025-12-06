#!/bin/bash

# ===============================================
# C 프로그래밍 실습 문제 2 - 통합 채점 스크립트
# ===============================================

# ANSI 색상 코드 정의
GREEN='\033[32m'
RED='\033[31m'
BLUE='\033[34m'
NC='\033[0m' # No Color

# 파일 경로 정의
P1_EXPECTED_FILE="p1_expected.txt"
P2_INPUT_FILE="source.txt"
P2_EXPECTED_FILE="p2_expected.txt"
P2_RESULT_FILE="result.txt"

# 초기 점수 및 피드백 변수
P1_SCORE=0
P2_SCORE=0
P1_FEEDBACK=""
P2_FEEDBACK=""
FINAL_SCORE=0

# C 컴파일 함수
compile_c() {
    local source_file=$1
    local executable_name=$2
    gcc -o "$executable_name" "$source_file" -Wall 2> "compile_error_$executable_name.txt"
    if [ $? -ne 0 ]; then
        echo "FAIL"
        return 1
    }
    echo "OK"
    return 0
}

# 출력 비교 함수 (공백 및 줄바꿈 무시)
normalize_output() {
    # 모든 공백 문자(스페이스, 탭, 개행) 제거 후 대문자 변환
    tr -d '[:space:]' < "$1" | tr '[:lower:]' '[:upper:]'
}

# ===============================================
# 1. 문제 1: 3x3 행렬 출력 및 대각선 합계 채점 (main-1.c) - 50점
# ===============================================
echo -e "\n${BLUE}--- [TEST P1] 3x3 행렬 및 대각선 합계 채점 시작 (main-1.c) ---${NC}"

if [ "$(compile_c main-1.c main-1)" == "OK" ]; then
    echo -e "${GREEN}[OK]${NC} 문제 1: 컴파일 성공."
    
    # 1-1. 실행 및 학생 출력 캡처 (입력 없음)
    ./main-1 > actual_p1.txt 2>&1
    
    # 1-2. 출력 비교 (공백 무시)
    if [ -f "$P1_EXPECTED_FILE" ]; then
        
        # 정규화된 출력 비교
        if [[ "$(normalize_output actual_p1.txt)" == "$(normalize_output "$P1_EXPECTED_FILE")" ]]; then
            P1_SCORE=50
            P1_FEEDBACK="${GREEN}[PASS]${NC} 문제 1 (행렬/포인터): 통과 (50점)"
        else
            P1_FEEDBACK="${RED}[FAIL]${NC} 문제 1 (행렬/포인터): 출력 내용 또는 포맷 불일치."
            P1_FEEDBACK="${P1_FEEDBACK}\n  [학생 출력]: $(cat actual_p1.txt | tr '\n' ' ')"
            P1_FEEDBACK="${P1_FEEDBACK}\n  [예상 출력]: $(cat "$P1_EXPECTED_FILE" | tr '\n' ' ')"
        fi
    else
        P1_FEEDBACK="${RED}[ERROR]${NC} 문제 1: 예상 출력 파일($P1_EXPECTED_FILE) 없음."
    fi
else
    P1_FEEDBACK="${RED}[FAIL]${NC} 문제 1 (행렬/포인터): 컴파일 실패. 코드를 확인하세요."
fi

# ===============================================
# 2. 문제 2: 비트 조작 파일 I/O 채점 (main-2.c) - 50점
# ===============================================
echo -e "\n${BLUE}--- [TEST P2] 비트 조작 파일 I/O 채점 시작 (main-2.c) ---${NC}"

if [ "$(compile_c main-2.c main-2)" == "OK" ]; then
    echo -e "${GREEN}[OK]${NC} 문제 2: 컴파일 성공."
    
    # 2-1. 실행 (result.txt 파일 생성 기대)
    ./main-2
    
    # 2-2. 결과 파일 확인 및 비교
    if [ -f "$P2_RESULT_FILE" ]; then
        
        # 2-3. 출력 비교 (공백 무시)
        if [ -f "$P2_EXPECTED_FILE" ]; then
            
            # 정규화된 출력 비교
            if [[ "$(normalize_output "$P2_RESULT_FILE")" == "$(normalize_output "$P2_EXPECTED_FILE")" ]]; then
                P2_SCORE=50
                P2_FEEDBACK="${GREEN}[PASS]${NC} 문제 2 (비트/I/O): 통과 (50점)"
            else
                P2_FEEDBACK="${RED}[FAIL]${NC} 문제 2 (비트/I/O): result.txt 내용 불일치."
                P2_FEEDBACK="${P2_FEEDBACK}\n  [학생 출력]: $(cat "$P2_RESULT_FILE" | tr '\n' ' ')"
                P2_FEEDBACK="${P2_FEEDBACK}\n  [예상 출력]: $(cat "$P2_EXPECTED_FILE" | tr '\n' ' ')"
            fi
        else
            P2_FEEDBACK="${RED}[ERROR]${NC} 문제 2: 예상 출력 파일($P2_EXPECTED_FILE) 없음."
        fi
    else
        P2_FEEDBACK="${RED}[FAIL]${NC} 문제 2 (비트/I/O): 'result.txt' 파일이 생성되지 않았습니다."
    fi
else
    P2_FEEDBACK="${RED}[FAIL]${NC} 문제 2 (비트/I/O): 컴파일 실패. 코드를 확인하세요."
fi

# ===============================================
# 3. 최종 점수 및 피드백 계산 및 GitHub Actions 출력
# ===============================================
FINAL_SCORE=$((P1_SCORE + P2_SCORE))
echo "$FINAL_SCORE" > result_score.txt # 최종 점수를 파일에 저장

FULL_FEEDBACK="--- 최종 채점 결과 (총 ${FINAL_SCORE}점 / 100점) ---\n"
FULL_FEEDBACK="${FULL_FEEDBACK}\n${P1_FEEDBACK}"
FULL_FEEDBACK="${FULL_FEEDBACK}\n${P2_FEEDBACK}"

echo -e "\n$FULL_FEEDBACK" # 콘솔에 출력

# GitHub Actions의 $GITHUB_OUTPUT 변수에 점수 및 피드백 전달
echo "score=$FINAL_SCORE" >> "$GITHUB_OUTPUT"
echo "feedback<<EOF" >> "$GITHUB_OUTPUT"
echo -e "$FULL_FEEDBACK" >> "$GITHUB_OUTPUT"
echo "EOF" >> "$GITHUB_OUTPUT"

# 최종 실패 보장 로직 (100점 미만 시 GitHub Actions 실패로 표시)
if [ "$FINAL_SCORE" -ne 100 ]; then
    echo "::error::[ERROR] 최종 점수가 100점이 아니므로 채점 실패 처리합니다."
    exit 1
fi
