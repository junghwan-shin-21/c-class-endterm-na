/*
#include <stdio.h>

int main(void)  {    

    printf("Hello World!");
    
    return 0;
}
*/

#include <stdio.h>

int main(void) {
    int matrix[3][3];
    int *p = &matrix[0][0];
    int sum = 0;

    /* 1부터 9까지 초기화 */
    for (int i = 0; i < 9; i++)
        *(p + i) = i + 1;

    /* 배열 요소 출력 (포인터 사용) */
    for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++)
            printf("%3d", *(p + i * 3 + j));
        printf("\n");
    }

    /* 주대각선 합계 계산 (포인터 사용) */
    for (int i = 0; i < 3; i++)
        sum += *(p + i * 3 + i);

    printf("======\n");
    printf("대각선 합계: %d\n", sum);

    return 0;
}

