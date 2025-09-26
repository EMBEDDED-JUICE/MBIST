// file = 0; split type = patterns; threshold = 100000; total count = 0.
#include <stdio.h>
#include <stdlib.h>
#include <strings.h>
#include "rmapats.h"

void  schedNewEvent (struct dummyq_struct * I1415, EBLK  * I1410, U  I623);
void  schedNewEvent (struct dummyq_struct * I1415, EBLK  * I1410, U  I623)
{
    U  I1681;
    U  I1682;
    U  I1683;
    struct futq * I1684;
    struct dummyq_struct * pQ = I1415;
    I1681 = ((U )vcs_clocks) + I623;
    I1683 = I1681 & ((1 << fHashTableSize) - 1);
    I1410->I668 = (EBLK  *)(-1);
    I1410->I669 = I1681;
    if (0 && rmaProfEvtProp) {
        vcs_simpSetEBlkEvtID(I1410);
    }
    if (I1681 < (U )vcs_clocks) {
        I1682 = ((U  *)&vcs_clocks)[1];
        sched_millenium(pQ, I1410, I1682 + 1, I1681);
    }
    else if ((peblkFutQ1Head != ((void *)0)) && (I623 == 1)) {
        I1410->I671 = (struct eblk *)peblkFutQ1Tail;
        peblkFutQ1Tail->I668 = I1410;
        peblkFutQ1Tail = I1410;
    }
    else if ((I1684 = pQ->I1318[I1683].I691)) {
        I1410->I671 = (struct eblk *)I1684->I689;
        I1684->I689->I668 = (RP )I1410;
        I1684->I689 = (RmaEblk  *)I1410;
    }
    else {
        sched_hsopt(pQ, I1410, I1681);
    }
}
#ifdef __cplusplus
extern "C" {
#endif
void SinitHsimPats(void);
#ifdef __cplusplus
}
#endif
