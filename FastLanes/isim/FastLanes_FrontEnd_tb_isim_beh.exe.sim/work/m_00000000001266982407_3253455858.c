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
static const char *ng0 = "D:/ISE/FastLanes2.61/FrontEnd_MultiSM.v";
static int ng1[] = {0, 0};
static unsigned int ng2[] = {1U, 0U};
static int ng3[] = {1, 0};
static int ng4[] = {2, 0};
static int ng5[] = {3, 0};



static void Always_548_0(char *t0)
{
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    int t6;
    char *t7;
    char *t8;

LAB0:    t1 = (t0 + 20448U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(548, ng0);
    t2 = (t0 + 21016);
    *((int *)t2) = 1;
    t3 = (t0 + 20480);
    *((char **)t3) = t2;
    *((char **)t1) = &&LAB4;

LAB1:    return;
LAB4:    xsi_set_current_line(548, ng0);

LAB5:    xsi_set_current_line(549, ng0);
    t4 = (t0 + 1688U);
    t5 = *((char **)t4);

LAB6:    t4 = ((char*)((ng1)));
    t6 = xsi_vlog_unsigned_case_compare(t5, 2, t4, 32);
    if (t6 == 1)
        goto LAB7;

LAB8:    t2 = ((char*)((ng3)));
    t6 = xsi_vlog_unsigned_case_compare(t5, 2, t2, 32);
    if (t6 == 1)
        goto LAB9;

LAB10:    t2 = ((char*)((ng4)));
    t6 = xsi_vlog_unsigned_case_compare(t5, 2, t2, 32);
    if (t6 == 1)
        goto LAB11;

LAB12:    t2 = ((char*)((ng5)));
    t6 = xsi_vlog_unsigned_case_compare(t5, 2, t2, 32);
    if (t6 == 1)
        goto LAB13;

LAB14:
LAB15:    goto LAB2;

LAB7:    xsi_set_current_line(550, ng0);

LAB16:    xsi_set_current_line(551, ng0);
    t7 = (t0 + 1848U);
    t8 = *((char **)t7);
    t7 = (t0 + 19048);
    xsi_vlogvar_assign_value(t7, t8, 0, 0, 1);
    xsi_set_current_line(552, ng0);
    t2 = ((char*)((ng2)));
    t3 = (t0 + 19208);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(553, ng0);
    t2 = ((char*)((ng2)));
    t3 = (t0 + 19368);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(554, ng0);
    t2 = ((char*)((ng2)));
    t3 = (t0 + 19528);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    goto LAB15;

LAB9:    xsi_set_current_line(557, ng0);

LAB17:    xsi_set_current_line(558, ng0);
    t3 = ((char*)((ng2)));
    t4 = (t0 + 19048);
    xsi_vlogvar_assign_value(t4, t3, 0, 0, 1);
    xsi_set_current_line(559, ng0);
    t2 = (t0 + 1848U);
    t3 = *((char **)t2);
    t2 = (t0 + 19208);
    xsi_vlogvar_assign_value(t2, t3, 0, 0, 1);
    xsi_set_current_line(560, ng0);
    t2 = ((char*)((ng2)));
    t3 = (t0 + 19368);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(561, ng0);
    t2 = ((char*)((ng2)));
    t3 = (t0 + 19528);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    goto LAB15;

LAB11:    xsi_set_current_line(564, ng0);

LAB18:    xsi_set_current_line(565, ng0);
    t3 = ((char*)((ng2)));
    t4 = (t0 + 19048);
    xsi_vlogvar_assign_value(t4, t3, 0, 0, 1);
    xsi_set_current_line(566, ng0);
    t2 = ((char*)((ng2)));
    t3 = (t0 + 19208);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(567, ng0);
    t2 = (t0 + 1848U);
    t3 = *((char **)t2);
    t2 = (t0 + 19368);
    xsi_vlogvar_assign_value(t2, t3, 0, 0, 1);
    xsi_set_current_line(568, ng0);
    t2 = ((char*)((ng2)));
    t3 = (t0 + 19528);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    goto LAB15;

LAB13:    xsi_set_current_line(571, ng0);

LAB19:    xsi_set_current_line(572, ng0);
    t3 = ((char*)((ng2)));
    t4 = (t0 + 19048);
    xsi_vlogvar_assign_value(t4, t3, 0, 0, 1);
    xsi_set_current_line(573, ng0);
    t2 = ((char*)((ng2)));
    t3 = (t0 + 19208);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(574, ng0);
    t2 = ((char*)((ng2)));
    t3 = (t0 + 19368);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(575, ng0);
    t2 = (t0 + 1848U);
    t3 = *((char **)t2);
    t2 = (t0 + 19528);
    xsi_vlogvar_assign_value(t2, t3, 0, 0, 1);
    goto LAB15;

}

static void Always_582_1(char *t0)
{
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    int t6;
    char *t7;
    char *t8;

LAB0:    t1 = (t0 + 20696U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(582, ng0);
    t2 = (t0 + 21032);
    *((int *)t2) = 1;
    t3 = (t0 + 20728);
    *((char **)t3) = t2;
    *((char **)t1) = &&LAB4;

LAB1:    return;
LAB4:    xsi_set_current_line(582, ng0);

LAB5:    xsi_set_current_line(583, ng0);
    t4 = (t0 + 1688U);
    t5 = *((char **)t4);

LAB6:    t4 = ((char*)((ng1)));
    t6 = xsi_vlog_unsigned_case_compare(t5, 2, t4, 32);
    if (t6 == 1)
        goto LAB7;

LAB8:    t2 = ((char*)((ng3)));
    t6 = xsi_vlog_unsigned_case_compare(t5, 2, t2, 32);
    if (t6 == 1)
        goto LAB9;

LAB10:    t2 = ((char*)((ng4)));
    t6 = xsi_vlog_unsigned_case_compare(t5, 2, t2, 32);
    if (t6 == 1)
        goto LAB11;

LAB12:    t2 = ((char*)((ng5)));
    t6 = xsi_vlog_unsigned_case_compare(t5, 2, t2, 32);
    if (t6 == 1)
        goto LAB13;

LAB14:
LAB15:    goto LAB2;

LAB7:    xsi_set_current_line(584, ng0);

LAB16:    xsi_set_current_line(586, ng0);
    t7 = (t0 + 6648U);
    t8 = *((char **)t7);
    t7 = (t0 + 16648);
    xsi_vlogvar_assign_value(t7, t8, 0, 0, 2);
    xsi_set_current_line(587, ng0);
    t2 = (t0 + 6808U);
    t3 = *((char **)t2);
    t2 = (t0 + 16808);
    xsi_vlogvar_assign_value(t2, t3, 0, 0, 1);
    xsi_set_current_line(588, ng0);
    t2 = (t0 + 6968U);
    t3 = *((char **)t2);
    t2 = (t0 + 16968);
    xsi_vlogvar_assign_value(t2, t3, 0, 0, 182);
    xsi_set_current_line(589, ng0);
    t2 = (t0 + 7128U);
    t3 = *((char **)t2);
    t2 = (t0 + 17128);
    xsi_vlogvar_assign_value(t2, t3, 0, 0, 32);
    xsi_set_current_line(591, ng0);
    t2 = (t0 + 7288U);
    t3 = *((char **)t2);
    t2 = (t0 + 17288);
    xsi_vlogvar_assign_value(t2, t3, 0, 0, 1);
    xsi_set_current_line(593, ng0);
    t2 = (t0 + 7448U);
    t3 = *((char **)t2);
    t2 = (t0 + 17448);
    xsi_vlogvar_assign_value(t2, t3, 0, 0, 1);
    xsi_set_current_line(594, ng0);
    t2 = (t0 + 7608U);
    t3 = *((char **)t2);
    t2 = (t0 + 17608);
    xsi_vlogvar_assign_value(t2, t3, 0, 0, 1);
    xsi_set_current_line(598, ng0);
    t2 = (t0 + 7768U);
    t3 = *((char **)t2);
    t2 = (t0 + 17768);
    xsi_vlogvar_assign_value(t2, t3, 0, 0, 32);
    xsi_set_current_line(599, ng0);
    t2 = (t0 + 7928U);
    t3 = *((char **)t2);
    t2 = (t0 + 17928);
    xsi_vlogvar_assign_value(t2, t3, 0, 0, 32);
    xsi_set_current_line(602, ng0);
    t2 = (t0 + 8088U);
    t3 = *((char **)t2);
    t2 = (t0 + 18088);
    xsi_vlogvar_assign_value(t2, t3, 0, 0, 16);
    xsi_set_current_line(603, ng0);
    t2 = (t0 + 8248U);
    t3 = *((char **)t2);
    t2 = (t0 + 18248);
    xsi_vlogvar_assign_value(t2, t3, 0, 0, 16);
    xsi_set_current_line(604, ng0);
    t2 = (t0 + 8408U);
    t3 = *((char **)t2);
    t2 = (t0 + 18408);
    xsi_vlogvar_assign_value(t2, t3, 0, 0, 16);
    xsi_set_current_line(606, ng0);
    t2 = (t0 + 8568U);
    t3 = *((char **)t2);
    t2 = (t0 + 18568);
    xsi_vlogvar_assign_value(t2, t3, 0, 0, 1);
    xsi_set_current_line(607, ng0);
    t2 = (t0 + 8728U);
    t3 = *((char **)t2);
    t2 = (t0 + 18728);
    xsi_vlogvar_assign_value(t2, t3, 0, 0, 1);
    xsi_set_current_line(608, ng0);
    t2 = (t0 + 8888U);
    t3 = *((char **)t2);
    t2 = (t0 + 18888);
    xsi_vlogvar_assign_value(t2, t3, 0, 0, 1);
    goto LAB15;

LAB9:    xsi_set_current_line(611, ng0);

LAB17:    xsi_set_current_line(613, ng0);
    t3 = (t0 + 9048U);
    t4 = *((char **)t3);
    t3 = (t0 + 16648);
    xsi_vlogvar_assign_value(t3, t4, 0, 0, 2);
    xsi_set_current_line(614, ng0);
    t2 = (t0 + 9208U);
    t3 = *((char **)t2);
    t2 = (t0 + 16808);
    xsi_vlogvar_assign_value(t2, t3, 0, 0, 1);
    xsi_set_current_line(615, ng0);
    t2 = (t0 + 9368U);
    t3 = *((char **)t2);
    t2 = (t0 + 16968);
    xsi_vlogvar_assign_value(t2, t3, 0, 0, 182);
    xsi_set_current_line(616, ng0);
    t2 = (t0 + 9528U);
    t3 = *((char **)t2);
    t2 = (t0 + 17128);
    xsi_vlogvar_assign_value(t2, t3, 0, 0, 32);
    xsi_set_current_line(618, ng0);
    t2 = (t0 + 9688U);
    t3 = *((char **)t2);
    t2 = (t0 + 17288);
    xsi_vlogvar_assign_value(t2, t3, 0, 0, 1);
    xsi_set_current_line(620, ng0);
    t2 = (t0 + 9848U);
    t3 = *((char **)t2);
    t2 = (t0 + 17448);
    xsi_vlogvar_assign_value(t2, t3, 0, 0, 1);
    xsi_set_current_line(621, ng0);
    t2 = (t0 + 10008U);
    t3 = *((char **)t2);
    t2 = (t0 + 17608);
    xsi_vlogvar_assign_value(t2, t3, 0, 0, 1);
    xsi_set_current_line(625, ng0);
    t2 = (t0 + 10168U);
    t3 = *((char **)t2);
    t2 = (t0 + 17768);
    xsi_vlogvar_assign_value(t2, t3, 0, 0, 32);
    xsi_set_current_line(626, ng0);
    t2 = (t0 + 10328U);
    t3 = *((char **)t2);
    t2 = (t0 + 17928);
    xsi_vlogvar_assign_value(t2, t3, 0, 0, 32);
    xsi_set_current_line(629, ng0);
    t2 = (t0 + 10488U);
    t3 = *((char **)t2);
    t2 = (t0 + 18088);
    xsi_vlogvar_assign_value(t2, t3, 0, 0, 16);
    xsi_set_current_line(630, ng0);
    t2 = (t0 + 10648U);
    t3 = *((char **)t2);
    t2 = (t0 + 18248);
    xsi_vlogvar_assign_value(t2, t3, 0, 0, 16);
    xsi_set_current_line(631, ng0);
    t2 = (t0 + 10808U);
    t3 = *((char **)t2);
    t2 = (t0 + 18408);
    xsi_vlogvar_assign_value(t2, t3, 0, 0, 16);
    xsi_set_current_line(633, ng0);
    t2 = (t0 + 10968U);
    t3 = *((char **)t2);
    t2 = (t0 + 18568);
    xsi_vlogvar_assign_value(t2, t3, 0, 0, 1);
    xsi_set_current_line(634, ng0);
    t2 = (t0 + 11128U);
    t3 = *((char **)t2);
    t2 = (t0 + 18728);
    xsi_vlogvar_assign_value(t2, t3, 0, 0, 1);
    xsi_set_current_line(635, ng0);
    t2 = (t0 + 11288U);
    t3 = *((char **)t2);
    t2 = (t0 + 18888);
    xsi_vlogvar_assign_value(t2, t3, 0, 0, 1);
    goto LAB15;

LAB11:    xsi_set_current_line(638, ng0);

LAB18:    xsi_set_current_line(640, ng0);
    t3 = (t0 + 11448U);
    t4 = *((char **)t3);
    t3 = (t0 + 16648);
    xsi_vlogvar_assign_value(t3, t4, 0, 0, 2);
    xsi_set_current_line(641, ng0);
    t2 = (t0 + 11608U);
    t3 = *((char **)t2);
    t2 = (t0 + 16808);
    xsi_vlogvar_assign_value(t2, t3, 0, 0, 1);
    xsi_set_current_line(642, ng0);
    t2 = (t0 + 11768U);
    t3 = *((char **)t2);
    t2 = (t0 + 16968);
    xsi_vlogvar_assign_value(t2, t3, 0, 0, 182);
    xsi_set_current_line(643, ng0);
    t2 = (t0 + 11928U);
    t3 = *((char **)t2);
    t2 = (t0 + 17128);
    xsi_vlogvar_assign_value(t2, t3, 0, 0, 32);
    xsi_set_current_line(645, ng0);
    t2 = (t0 + 12088U);
    t3 = *((char **)t2);
    t2 = (t0 + 17288);
    xsi_vlogvar_assign_value(t2, t3, 0, 0, 1);
    xsi_set_current_line(647, ng0);
    t2 = (t0 + 12248U);
    t3 = *((char **)t2);
    t2 = (t0 + 17448);
    xsi_vlogvar_assign_value(t2, t3, 0, 0, 1);
    xsi_set_current_line(648, ng0);
    t2 = (t0 + 12408U);
    t3 = *((char **)t2);
    t2 = (t0 + 17608);
    xsi_vlogvar_assign_value(t2, t3, 0, 0, 1);
    xsi_set_current_line(652, ng0);
    t2 = (t0 + 12568U);
    t3 = *((char **)t2);
    t2 = (t0 + 17768);
    xsi_vlogvar_assign_value(t2, t3, 0, 0, 32);
    xsi_set_current_line(653, ng0);
    t2 = (t0 + 12728U);
    t3 = *((char **)t2);
    t2 = (t0 + 17928);
    xsi_vlogvar_assign_value(t2, t3, 0, 0, 32);
    xsi_set_current_line(656, ng0);
    t2 = (t0 + 12888U);
    t3 = *((char **)t2);
    t2 = (t0 + 18088);
    xsi_vlogvar_assign_value(t2, t3, 0, 0, 16);
    xsi_set_current_line(657, ng0);
    t2 = (t0 + 13048U);
    t3 = *((char **)t2);
    t2 = (t0 + 18248);
    xsi_vlogvar_assign_value(t2, t3, 0, 0, 16);
    xsi_set_current_line(658, ng0);
    t2 = (t0 + 13208U);
    t3 = *((char **)t2);
    t2 = (t0 + 18408);
    xsi_vlogvar_assign_value(t2, t3, 0, 0, 16);
    xsi_set_current_line(660, ng0);
    t2 = (t0 + 13368U);
    t3 = *((char **)t2);
    t2 = (t0 + 18568);
    xsi_vlogvar_assign_value(t2, t3, 0, 0, 1);
    xsi_set_current_line(661, ng0);
    t2 = (t0 + 13528U);
    t3 = *((char **)t2);
    t2 = (t0 + 18728);
    xsi_vlogvar_assign_value(t2, t3, 0, 0, 1);
    xsi_set_current_line(662, ng0);
    t2 = (t0 + 13688U);
    t3 = *((char **)t2);
    t2 = (t0 + 18888);
    xsi_vlogvar_assign_value(t2, t3, 0, 0, 1);
    goto LAB15;

LAB13:    xsi_set_current_line(665, ng0);

LAB19:    xsi_set_current_line(667, ng0);
    t3 = (t0 + 13848U);
    t4 = *((char **)t3);
    t3 = (t0 + 16648);
    xsi_vlogvar_assign_value(t3, t4, 0, 0, 2);
    xsi_set_current_line(668, ng0);
    t2 = (t0 + 14008U);
    t3 = *((char **)t2);
    t2 = (t0 + 16808);
    xsi_vlogvar_assign_value(t2, t3, 0, 0, 1);
    xsi_set_current_line(669, ng0);
    t2 = (t0 + 14168U);
    t3 = *((char **)t2);
    t2 = (t0 + 16968);
    xsi_vlogvar_assign_value(t2, t3, 0, 0, 182);
    xsi_set_current_line(670, ng0);
    t2 = (t0 + 14328U);
    t3 = *((char **)t2);
    t2 = (t0 + 17128);
    xsi_vlogvar_assign_value(t2, t3, 0, 0, 32);
    xsi_set_current_line(672, ng0);
    t2 = (t0 + 14488U);
    t3 = *((char **)t2);
    t2 = (t0 + 17288);
    xsi_vlogvar_assign_value(t2, t3, 0, 0, 1);
    xsi_set_current_line(674, ng0);
    t2 = (t0 + 14648U);
    t3 = *((char **)t2);
    t2 = (t0 + 17448);
    xsi_vlogvar_assign_value(t2, t3, 0, 0, 1);
    xsi_set_current_line(675, ng0);
    t2 = (t0 + 14808U);
    t3 = *((char **)t2);
    t2 = (t0 + 17608);
    xsi_vlogvar_assign_value(t2, t3, 0, 0, 1);
    xsi_set_current_line(679, ng0);
    t2 = (t0 + 14968U);
    t3 = *((char **)t2);
    t2 = (t0 + 17768);
    xsi_vlogvar_assign_value(t2, t3, 0, 0, 32);
    xsi_set_current_line(680, ng0);
    t2 = (t0 + 15128U);
    t3 = *((char **)t2);
    t2 = (t0 + 17928);
    xsi_vlogvar_assign_value(t2, t3, 0, 0, 32);
    xsi_set_current_line(683, ng0);
    t2 = (t0 + 15288U);
    t3 = *((char **)t2);
    t2 = (t0 + 18088);
    xsi_vlogvar_assign_value(t2, t3, 0, 0, 16);
    xsi_set_current_line(684, ng0);
    t2 = (t0 + 15448U);
    t3 = *((char **)t2);
    t2 = (t0 + 18248);
    xsi_vlogvar_assign_value(t2, t3, 0, 0, 16);
    xsi_set_current_line(685, ng0);
    t2 = (t0 + 15608U);
    t3 = *((char **)t2);
    t2 = (t0 + 18408);
    xsi_vlogvar_assign_value(t2, t3, 0, 0, 16);
    xsi_set_current_line(687, ng0);
    t2 = (t0 + 15768U);
    t3 = *((char **)t2);
    t2 = (t0 + 18568);
    xsi_vlogvar_assign_value(t2, t3, 0, 0, 1);
    xsi_set_current_line(688, ng0);
    t2 = (t0 + 15928U);
    t3 = *((char **)t2);
    t2 = (t0 + 18728);
    xsi_vlogvar_assign_value(t2, t3, 0, 0, 1);
    xsi_set_current_line(689, ng0);
    t2 = (t0 + 16088U);
    t3 = *((char **)t2);
    t2 = (t0 + 18888);
    xsi_vlogvar_assign_value(t2, t3, 0, 0, 1);
    goto LAB15;

}


extern void work_m_00000000001266982407_3253455858_init()
{
	static char *pe[] = {(void *)Always_548_0,(void *)Always_582_1};
	xsi_register_didat("work_m_00000000001266982407_3253455858", "isim/FastLanes_FrontEnd_tb_isim_beh.exe.sim/work/m_00000000001266982407_3253455858.didat");
	xsi_register_executes(pe);
}
