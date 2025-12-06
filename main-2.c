/*

//사용 함수
FILE *fopen(const char *filename, const char *mode);
int fprintf(FILE *fp, const char *format, ...);
int fscanf(FILE *fp, const char *format, ...);

#include <stdio.h>

int main(void)  {

    return 0;
}

*/
#include <stdio.h>

int main(void) {
    FILE *fin, *fout;
    unsigned int a, b, c;
    unsigned int *p;

    fin = fopen("source.txt", "r");
    if (fin == NULL) {
        perror("source.txt");
        return 1;
    }

    /* 정수 3개를 포인터를 통해 읽기 */
    p = &a;
    if (fscanf(fin, "%x", p) != 1) return 1;
    p = &b;
    if (fscanf(fin, "%x", p) != 1) return 1;
    p = &c;
    if (fscanf(fin, "%x", p) != 1) return 1;
    fclose(fin);

    /* 포인터를 사용하여 비트 조작 */
    p = &a;
    *p |=  (1u << 6);   /* 6번 비트 set */
    *p &= ~(1u << 12);  /* 12번 비트 clear */

    p = &b;
    *p |=  (1u << 6);
    *p &= ~(1u << 12);

    p = &c;
    *p |=  (1u << 6);
    *p &= ~(1u << 12);

    /* 결과를 파일에 저장 (포인터 이용) */
    fout = fopen("result.txt", "w");
    if (fout == NULL) {
        perror("result.txt");
        return 1;
    } 

    p = &a;
    fprintf(fout, "Bit setting 결과: 0x%04x ", *p);
    p = &b;
    fprintf(fout, "0x%04x ", *p);
    p = &c;
    fprintf(fout, "0x%04x\n", *p);

    fclose(fout);
    return 0;
}

