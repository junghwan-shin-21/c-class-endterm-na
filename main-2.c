#include <stdio.h>

int main(void) {
    FILE *fin, *fout;
    unsigned int a, b, c;
    unsigned int *p;

    /* 1. 입력 파일(source.txt) 열기 */
    fin = fopen("source.txt", "r");
    if (fin == NULL) {
        perror("source.txt");
        return 1;
    }

    /* 2. 한 줄 전체를 포맷에 맞춰 읽기 */
    /*  예: "입력 변수: 0x330a 0x751d 0x1aae" */
    if (fscanf(fin, "입력 변수: %x %x %x", &a, &b, &c) != 3) {
        fclose(fin);
        return 1;
    }
    fclose(fin);

    /* 3. 포인터를 사용한 비트 조작 (LSB=0, 6번 set, 12번 clear) */
    p = &a;
    *p |=  (1u << 6);   /* 6번 비트 set */
    *p &= ~(1u << 12);  /* 12번 비트 clear */

    p = &b;
    *p |=  (1u << 6);
    *p &= ~(1u << 12);

    p = &c;
    *p |=  (1u << 6);
    *p &= ~(1u << 12);

    /* 4. 결과를 파일(result.txt)에 저장 (포인터 이용) */
    fout = fopen("result.txt", "w");
    if (fout == NULL) {
        perror("result.txt");
        return 1;
    }

    p = &a;
    fprintf(fout, "Bit setting 결과: 0x%04X ", *p);
    p = &b;
    fprintf(fout, "0x%04X ", *p);
    p = &c;
    fprintf(fout, "0x%04X\n", *p);

    fclose(fout);
    return 0;
}
