/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                       */
/*  \   \        Copyright (c) 2003-2009 Xilinx, Inc.                */
/*  /   /          All Right Reserved.                                 */
/* /---/   /\                                                         */
/* \   \  /  \                                                      */
/*  \___\/\___\                                                    */
/***********************************************************************/

/* This file is designed for use with ISim build 0x7708f090 */

#define XSI_HIDE_SYMBOL_SPEC true
#include "xsi.h"
#include <memory.h>
#ifdef __GNUC__
#include <stdlib.h>
#else
#include <malloc.h>
#define alloca _alloca
#endif
static const char *ng0 = "D:/ISE/FastLanes2.61/OpcolToExecute.v";
static int ng1[] = {0, 0};
static int ng2[] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
static int ng3[] = {0, 0, 0, 0, 0, 0};



static void Always_95_0(char *t0)
{
    char t13[8];
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    unsigned int t6;
    unsigned int t7;
    unsigned int t8;
    unsigned int t9;
    unsigned int t10;
    char *t11;
    char *t12;
    unsigned int t14;
    unsigned int t15;
    unsigned int t16;
    unsigned int t17;
    unsigned int t18;
    unsigned int t19;
    unsigned int t20;
    unsigned int t21;
    unsigned int t22;
    unsigned int t23;
    unsigned int t24;
    unsigned int t25;
    unsigned int t26;
    char *t27;
    char *t28;

LAB0:    t1 = (t0 + 14368U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(95, ng0);
    t2 = (t0 + 14688);
    *((int *)t2) = 1;
    t3 = (t0 + 14400);
    *((char **)t3) = t2;
    *((char **)t1) = &&LAB4;

LAB1:    return;
LAB4:    xsi_set_current_line(95, ng0);

LAB5:    xsi_set_current_line(96, ng0);
    t4 = (t0 + 1048U);
    t5 = *((char **)t4);
    t4 = (t5 + 4);
    t6 = *((unsigned int *)t4);
    t7 = (~(t6));
    t8 = *((unsigned int *)t5);
    t9 = (t8 & t7);
    t10 = (t9 != 0);
    if (t10 > 0)
        goto LAB6;

LAB7:    xsi_set_current_line(136, ng0);

LAB10:    xsi_set_current_line(137, ng0);
    t2 = (t0 + 7288U);
    t3 = *((char **)t2);
    memset(t13, 0, 8);
    t2 = (t3 + 4);
    t6 = *((unsigned int *)t2);
    t7 = (~(t6));
    t8 = *((unsigned int *)t3);
    t9 = (t8 & t7);
    t10 = (t9 & 1U);
    if (t10 != 0)
        goto LAB14;

LAB12:    if (*((unsigned int *)t2) == 0)
        goto LAB11;

LAB13:    t4 = (t13 + 4);
    *((unsigned int *)t13) = 1;
    *((unsigned int *)t4) = 1;

LAB14:    t5 = (t13 + 4);
    t11 = (t3 + 4);
    t14 = *((unsigned int *)t3);
    t15 = (~(t14));
    *((unsigned int *)t13) = t15;
    *((unsigned int *)t5) = 0;
    if (*((unsigned int *)t11) != 0)
        goto LAB16;

LAB15:    t20 = *((unsigned int *)t13);
    *((unsigned int *)t13) = (t20 & 1U);
    t21 = *((unsigned int *)t5);
    *((unsigned int *)t5) = (t21 & 1U);
    t12 = (t13 + 4);
    t22 = *((unsigned int *)t12);
    t23 = (~(t22));
    t24 = *((unsigned int *)t13);
    t25 = (t24 & t23);
    t26 = (t25 != 0);
    if (t26 > 0)
        goto LAB17;

LAB18:
LAB19:
LAB8:    goto LAB2;

LAB6:    xsi_set_current_line(96, ng0);

LAB9:    xsi_set_current_line(97, ng0);
    t11 = ((char*)((ng1)));
    t12 = (t0 + 7688);
    xsi_vlogvar_wait_assign_value(t12, t11, 0, 0, 2, 0LL);
    xsi_set_current_line(98, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 7848);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 2, 0LL);
    xsi_set_current_line(99, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 8008);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 1, 0LL);
    xsi_set_current_line(100, ng0);
    t2 = ((char*)((ng2)));
    t3 = (t0 + 8168);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 182, 0LL);
    xsi_set_current_line(101, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 8328);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 32, 0LL);
    xsi_set_current_line(102, ng0);
    t2 = ((char*)((ng3)));
    t3 = (t0 + 8488);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 96, 0LL);
    xsi_set_current_line(103, ng0);
    t2 = ((char*)((ng3)));
    t3 = (t0 + 8648);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 96, 0LL);
    xsi_set_current_line(104, ng0);
    t2 = ((char*)((ng3)));
    t3 = (t0 + 8808);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 96, 0LL);
    xsi_set_current_line(105, ng0);
    t2 = ((char*)((ng3)));
    t3 = (t0 + 8968);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 96, 0LL);
    xsi_set_current_line(106, ng0);
    t2 = ((char*)((ng3)));
    t3 = (t0 + 9128);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 96, 0LL);
    xsi_set_current_line(107, ng0);
    t2 = ((char*)((ng3)));
    t3 = (t0 + 9288);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 96, 0LL);
    xsi_set_current_line(108, ng0);
    t2 = ((char*)((ng3)));
    t3 = (t0 + 9448);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 96, 0LL);
    xsi_set_current_line(109, ng0);
    t2 = ((char*)((ng3)));
    t3 = (t0 + 9608);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 96, 0LL);
    xsi_set_current_line(110, ng0);
    t2 = ((char*)((ng3)));
    t3 = (t0 + 9768);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 96, 0LL);
    xsi_set_current_line(111, ng0);
    t2 = ((char*)((ng3)));
    t3 = (t0 + 9928);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 96, 0LL);
    xsi_set_current_line(112, ng0);
    t2 = ((char*)((ng3)));
    t3 = (t0 + 10088);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 96, 0LL);
    xsi_set_current_line(113, ng0);
    t2 = ((char*)((ng3)));
    t3 = (t0 + 10248);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 96, 0LL);
    xsi_set_current_line(114, ng0);
    t2 = ((char*)((ng3)));
    t3 = (t0 + 10408);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 96, 0LL);
    xsi_set_current_line(115, ng0);
    t2 = ((char*)((ng3)));
    t3 = (t0 + 10568);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 96, 0LL);
    xsi_set_current_line(116, ng0);
    t2 = ((char*)((ng3)));
    t3 = (t0 + 10728);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 96, 0LL);
    xsi_set_current_line(117, ng0);
    t2 = ((char*)((ng3)));
    t3 = (t0 + 10888);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 96, 0LL);
    xsi_set_current_line(118, ng0);
    t2 = ((char*)((ng3)));
    t3 = (t0 + 11048);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 96, 0LL);
    xsi_set_current_line(119, ng0);
    t2 = ((char*)((ng3)));
    t3 = (t0 + 11208);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 96, 0LL);
    xsi_set_current_line(120, ng0);
    t2 = ((char*)((ng3)));
    t3 = (t0 + 11368);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 96, 0LL);
    xsi_set_current_line(121, ng0);
    t2 = ((char*)((ng3)));
    t3 = (t0 + 11528);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 96, 0LL);
    xsi_set_current_line(122, ng0);
    t2 = ((char*)((ng3)));
    t3 = (t0 + 11688);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 96, 0LL);
    xsi_set_current_line(123, ng0);
    t2 = ((char*)((ng3)));
    t3 = (t0 + 11848);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 96, 0LL);
    xsi_set_current_line(124, ng0);
    t2 = ((char*)((ng3)));
    t3 = (t0 + 12008);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 96, 0LL);
    xsi_set_current_line(125, ng0);
    t2 = ((char*)((ng3)));
    t3 = (t0 + 12168);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 96, 0LL);
    xsi_set_current_line(126, ng0);
    t2 = ((char*)((ng3)));
    t3 = (t0 + 12328);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 96, 0LL);
    xsi_set_current_line(127, ng0);
    t2 = ((char*)((ng3)));
    t3 = (t0 + 12488);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 96, 0LL);
    xsi_set_current_line(128, ng0);
    t2 = ((char*)((ng3)));
    t3 = (t0 + 12648);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 96, 0LL);
    xsi_set_current_line(129, ng0);
    t2 = ((char*)((ng3)));
    t3 = (t0 + 12808);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 96, 0LL);
    xsi_set_current_line(130, ng0);
    t2 = ((char*)((ng3)));
    t3 = (t0 + 12968);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 96, 0LL);
    xsi_set_current_line(131, ng0);
    t2 = ((char*)((ng3)));
    t3 = (t0 + 13128);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 96, 0LL);
    xsi_set_current_line(132, ng0);
    t2 = ((char*)((ng3)));
    t3 = (t0 + 13288);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 96, 0LL);
    xsi_set_current_line(133, ng0);
    t2 = ((char*)((ng3)));
    t3 = (t0 + 13448);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 96, 0LL);
    goto LAB8;

LAB11:    *((unsigned int *)t13) = 1;
    goto LAB14;

LAB16:    t16 = *((unsigned int *)t13);
    t17 = *((unsigned int *)t11);
    *((unsigned int *)t13) = (t16 | t17);
    t18 = *((unsigned int *)t5);
    t19 = *((unsigned int *)t11);
    *((unsigned int *)t5) = (t18 | t19);
    goto LAB15;

LAB17:    xsi_set_current_line(137, ng0);

LAB20:    xsi_set_current_line(138, ng0);
    t27 = (t0 + 1368U);
    t28 = *((char **)t27);
    t27 = (t0 + 7688);
    xsi_vlogvar_wait_assign_value(t27, t28, 0, 0, 2, 0LL);
    xsi_set_current_line(139, ng0);
    t2 = (t0 + 1528U);
    t3 = *((char **)t2);
    t2 = (t0 + 7848);
    xsi_vlogvar_wait_assign_value(t2, t3, 0, 0, 2, 0LL);
    xsi_set_current_line(140, ng0);
    t2 = (t0 + 1688U);
    t3 = *((char **)t2);
    t2 = (t0 + 8008);
    xsi_vlogvar_wait_assign_value(t2, t3, 0, 0, 1, 0LL);
    xsi_set_current_line(141, ng0);
    t2 = (t0 + 1848U);
    t3 = *((char **)t2);
    t2 = (t0 + 8168);
    xsi_vlogvar_wait_assign_value(t2, t3, 0, 0, 182, 0LL);
    xsi_set_current_line(142, ng0);
    t2 = (t0 + 2008U);
    t3 = *((char **)t2);
    t2 = (t0 + 8328);
    xsi_vlogvar_wait_assign_value(t2, t3, 0, 0, 32, 0LL);
    xsi_set_current_line(143, ng0);
    t2 = (t0 + 2168U);
    t3 = *((char **)t2);
    t2 = (t0 + 8488);
    xsi_vlogvar_wait_assign_value(t2, t3, 0, 0, 96, 0LL);
    xsi_set_current_line(144, ng0);
    t2 = (t0 + 2328U);
    t3 = *((char **)t2);
    t2 = (t0 + 8648);
    xsi_vlogvar_wait_assign_value(t2, t3, 0, 0, 96, 0LL);
    xsi_set_current_line(145, ng0);
    t2 = (t0 + 2488U);
    t3 = *((char **)t2);
    t2 = (t0 + 8808);
    xsi_vlogvar_wait_assign_value(t2, t3, 0, 0, 96, 0LL);
    xsi_set_current_line(146, ng0);
    t2 = (t0 + 2648U);
    t3 = *((char **)t2);
    t2 = (t0 + 8968);
    xsi_vlogvar_wait_assign_value(t2, t3, 0, 0, 96, 0LL);
    xsi_set_current_line(147, ng0);
    t2 = (t0 + 2808U);
    t3 = *((char **)t2);
    t2 = (t0 + 9128);
    xsi_vlogvar_wait_assign_value(t2, t3, 0, 0, 96, 0LL);
    xsi_set_current_line(148, ng0);
    t2 = (t0 + 2968U);
    t3 = *((char **)t2);
    t2 = (t0 + 9288);
    xsi_vlogvar_wait_assign_value(t2, t3, 0, 0, 96, 0LL);
    xsi_set_current_line(149, ng0);
    t2 = (t0 + 3128U);
    t3 = *((char **)t2);
    t2 = (t0 + 9448);
    xsi_vlogvar_wait_assign_value(t2, t3, 0, 0, 96, 0LL);
    xsi_set_current_line(150, ng0);
    t2 = (t0 + 3288U);
    t3 = *((char **)t2);
    t2 = (t0 + 9608);
    xsi_vlogvar_wait_assign_value(t2, t3, 0, 0, 96, 0LL);
    xsi_set_current_line(151, ng0);
    t2 = (t0 + 3448U);
    t3 = *((char **)t2);
    t2 = (t0 + 9768);
    xsi_vlogvar_wait_assign_value(t2, t3, 0, 0, 96, 0LL);
    xsi_set_current_line(152, ng0);
    t2 = (t0 + 3608U);
    t3 = *((char **)t2);
    t2 = (t0 + 9928);
    xsi_vlogvar_wait_assign_value(t2, t3, 0, 0, 96, 0LL);
    xsi_set_current_line(153, ng0);
    t2 = (t0 + 3768U);
    t3 = *((char **)t2);
    t2 = (t0 + 10088);
    xsi_vlogvar_wait_assign_value(t2, t3, 0, 0, 96, 0LL);
    xsi_set_current_line(154, ng0);
    t2 = (t0 + 3928U);
    t3 = *((char **)t2);
    t2 = (t0 + 10248);
    xsi_vlogvar_wait_assign_value(t2, t3, 0, 0, 96, 0LL);
    xsi_set_current_line(155, ng0);
    t2 = (t0 + 4088U);
    t3 = *((char **)t2);
    t2 = (t0 + 10408);
    xsi_vlogvar_wait_assign_value(t2, t3, 0, 0, 96, 0LL);
    xsi_set_current_line(156, ng0);
    t2 = (t0 + 4248U);
    t3 = *((char **)t2);
    t2 = (t0 + 10568);
    xsi_vlogvar_wait_assign_value(t2, t3, 0, 0, 96, 0LL);
    xsi_set_current_line(157, ng0);
    t2 = (t0 + 4408U);
    t3 = *((char **)t2);
    t2 = (t0 + 10728);
    xsi_vlogvar_wait_assign_value(t2, t3, 0, 0, 96, 0LL);
    xsi_set_current_line(158, ng0);
    t2 = (t0 + 4568U);
    t3 = *((char **)t2);
    t2 = (t0 + 10888);
    xsi_vlogvar_wait_assign_value(t2, t3, 0, 0, 96, 0LL);
    xsi_set_current_line(159, ng0);
    t2 = (t0 + 4728U);
    t3 = *((char **)t2);
    t2 = (t0 + 11048);
    xsi_vlogvar_wait_assign_value(t2, t3, 0, 0, 96, 0LL);
    xsi_set_current_line(160, ng0);
    t2 = (t0 + 4888U);
    t3 = *((char **)t2);
    t2 = (t0 + 11208);
    xsi_vlogvar_wait_assign_value(t2, t3, 0, 0, 96, 0LL);
    xsi_set_current_line(161, ng0);
    t2 = (t0 + 5048U);
    t3 = *((char **)t2);
    t2 = (t0 + 11368);
    xsi_vlogvar_wait_assign_value(t2, t3, 0, 0, 96, 0LL);
    xsi_set_current_line(162, ng0);
    t2 = (t0 + 5208U);
    t3 = *((char **)t2);
    t2 = (t0 + 11528);
    xsi_vlogvar_wait_assign_value(t2, t3, 0, 0, 96, 0LL);
    xsi_set_current_line(163, ng0);
    t2 = (t0 + 5368U);
    t3 = *((char **)t2);
    t2 = (t0 + 11688);
    xsi_vlogvar_wait_assign_value(t2, t3, 0, 0, 96, 0LL);
    xsi_set_current_line(164, ng0);
    t2 = (t0 + 5528U);
    t3 = *((char **)t2);
    t2 = (t0 + 11848);
    xsi_vlogvar_wait_assign_value(t2, t3, 0, 0, 96, 0LL);
    xsi_set_current_line(165, ng0);
    t2 = (t0 + 5688U);
    t3 = *((char **)t2);
    t2 = (t0 + 12008);
    xsi_vlogvar_wait_assign_value(t2, t3, 0, 0, 96, 0LL);
    xsi_set_current_line(166, ng0);
    t2 = (t0 + 5848U);
    t3 = *((char **)t2);
    t2 = (t0 + 12168);
    xsi_vlogvar_wait_assign_value(t2, t3, 0, 0, 96, 0LL);
    xsi_set_current_line(167, ng0);
    t2 = (t0 + 6008U);
    t3 = *((char **)t2);
    t2 = (t0 + 12328);
    xsi_vlogvar_wait_assign_value(t2, t3, 0, 0, 96, 0LL);
    xsi_set_current_line(168, ng0);
    t2 = (t0 + 6168U);
    t3 = *((char **)t2);
    t2 = (t0 + 12488);
    xsi_vlogvar_wait_assign_value(t2, t3, 0, 0, 96, 0LL);
    xsi_set_current_line(169, ng0);
    t2 = (t0 + 6328U);
    t3 = *((char **)t2);
    t2 = (t0 + 12648);
    xsi_vlogvar_wait_assign_value(t2, t3, 0, 0, 96, 0LL);
    xsi_set_current_line(170, ng0);
    t2 = (t0 + 6488U);
    t3 = *((char **)t2);
    t2 = (t0 + 12808);
    xsi_vlogvar_wait_assign_value(t2, t3, 0, 0, 96, 0LL);
    xsi_set_current_line(171, ng0);
    t2 = (t0 + 6648U);
    t3 = *((char **)t2);
    t2 = (t0 + 12968);
    xsi_vlogvar_wait_assign_value(t2, t3, 0, 0, 96, 0LL);
    xsi_set_current_line(172, ng0);
    t2 = (t0 + 6808U);
    t3 = *((char **)t2);
    t2 = (t0 + 13128);
    xsi_vlogvar_wait_assign_value(t2, t3, 0, 0, 96, 0LL);
    xsi_set_current_line(173, ng0);
    t2 = (t0 + 6968U);
    t3 = *((char **)t2);
    t2 = (t0 + 13288);
    xsi_vlogvar_wait_assign_value(t2, t3, 0, 0, 96, 0LL);
    xsi_set_current_line(174, ng0);
    t2 = (t0 + 7128U);
    t3 = *((char **)t2);
    t2 = (t0 + 13448);
    xsi_vlogvar_wait_assign_value(t2, t3, 0, 0, 96, 0LL);
    goto LAB19;

}


extern void work_m_00000000000081565842_3133015722_init()
{
	static char *pe[] = {(void *)Always_95_0};
	xsi_register_didat("work_m_00000000000081565842_3133015722", "isim/FastLanes_FrontEnd_tb_isim_beh.exe.sim/work/m_00000000000081565842_3133015722.didat");
	xsi_register_executes(pe);
}
