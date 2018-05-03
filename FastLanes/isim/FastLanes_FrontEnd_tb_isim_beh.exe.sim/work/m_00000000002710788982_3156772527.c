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
static const char *ng0 = "D:/ISE/FastLanes2.61/stall_control.v";
static int ng1[] = {0, 0};
static int ng2[] = {1, 0};



static void Always_36_0(char *t0)
{
    char t13[8];
    char t33[8];
    char t43[8];
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
    int t29;
    char *t30;
    char *t31;
    char *t32;
    char *t34;
    char *t35;
    unsigned int t36;
    unsigned int t37;
    unsigned int t38;
    unsigned int t39;
    unsigned int t40;
    unsigned int t41;
    char *t42;
    unsigned int t44;
    unsigned int t45;
    unsigned int t46;
    char *t47;
    char *t48;
    char *t49;
    unsigned int t50;
    unsigned int t51;
    unsigned int t52;
    unsigned int t53;
    unsigned int t54;
    unsigned int t55;
    unsigned int t56;
    char *t57;
    char *t58;
    unsigned int t59;
    unsigned int t60;
    unsigned int t61;
    unsigned int t62;
    unsigned int t63;
    unsigned int t64;
    unsigned int t65;
    unsigned int t66;
    int t67;
    int t68;
    unsigned int t69;
    unsigned int t70;
    unsigned int t71;
    unsigned int t72;
    unsigned int t73;
    unsigned int t74;
    char *t75;
    unsigned int t76;
    unsigned int t77;
    unsigned int t78;
    unsigned int t79;
    unsigned int t80;
    char *t81;
    char *t82;

LAB0:    t1 = (t0 + 3808U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(36, ng0);
    t2 = (t0 + 4128);
    *((int *)t2) = 1;
    t3 = (t0 + 3840);
    *((char **)t3) = t2;
    *((char **)t1) = &&LAB4;

LAB1:    return;
LAB4:    xsi_set_current_line(37, ng0);

LAB5:    xsi_set_current_line(38, ng0);
    t4 = (t0 + 1208U);
    t5 = *((char **)t4);
    t4 = (t5 + 4);
    t6 = *((unsigned int *)t4);
    t7 = (~(t6));
    t8 = *((unsigned int *)t5);
    t9 = (t8 & t7);
    t10 = (t9 != 0);
    if (t10 > 0)
        goto LAB6;

LAB7:    xsi_set_current_line(43, ng0);
    t2 = (t0 + 1368U);
    t3 = *((char **)t2);
    memset(t13, 0, 8);
    t2 = (t3 + 4);
    t6 = *((unsigned int *)t2);
    t7 = (~(t6));
    t8 = *((unsigned int *)t3);
    t9 = (t8 & t7);
    t10 = (t9 & 1U);
    if (t10 != 0)
        goto LAB13;

LAB11:    if (*((unsigned int *)t2) == 0)
        goto LAB10;

LAB12:    t4 = (t13 + 4);
    *((unsigned int *)t13) = 1;
    *((unsigned int *)t4) = 1;

LAB13:    t5 = (t13 + 4);
    t11 = (t3 + 4);
    t14 = *((unsigned int *)t3);
    t15 = (~(t14));
    *((unsigned int *)t13) = t15;
    *((unsigned int *)t5) = 0;
    if (*((unsigned int *)t11) != 0)
        goto LAB15;

LAB14:    t20 = *((unsigned int *)t13);
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
        goto LAB16;

LAB17:
LAB18:
LAB8:    goto LAB2;

LAB6:    xsi_set_current_line(39, ng0);

LAB9:    xsi_set_current_line(40, ng0);
    t11 = ((char*)((ng1)));
    t12 = (t0 + 2408);
    xsi_vlogvar_wait_assign_value(t12, t11, 0, 0, 1, 0LL);
    xsi_set_current_line(41, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 2888);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 1, 0LL);
    goto LAB8;

LAB10:    *((unsigned int *)t13) = 1;
    goto LAB13;

LAB15:    t16 = *((unsigned int *)t13);
    t17 = *((unsigned int *)t11);
    *((unsigned int *)t13) = (t16 | t17);
    t18 = *((unsigned int *)t5);
    t19 = *((unsigned int *)t11);
    *((unsigned int *)t5) = (t18 | t19);
    goto LAB14;

LAB16:    xsi_set_current_line(44, ng0);

LAB19:    xsi_set_current_line(45, ng0);
    t27 = (t0 + 1528U);
    t28 = *((char **)t27);
    t27 = (t0 + 2568);
    xsi_vlogvar_wait_assign_value(t27, t28, 0, 0, 1, 0LL);
    xsi_set_current_line(46, ng0);
    t2 = (t0 + 1688U);
    t3 = *((char **)t2);
    t2 = (t0 + 2728);
    xsi_vlogvar_wait_assign_value(t2, t3, 0, 0, 1, 0LL);
    xsi_set_current_line(47, ng0);
    t2 = (t0 + 2888);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);

LAB20:    t5 = ((char*)((ng1)));
    t29 = xsi_vlog_unsigned_case_compare(t4, 1, t5, 32);
    if (t29 == 1)
        goto LAB21;

LAB22:    t2 = ((char*)((ng2)));
    t29 = xsi_vlog_unsigned_case_compare(t4, 1, t2, 32);
    if (t29 == 1)
        goto LAB23;

LAB24:
LAB25:    goto LAB18;

LAB21:    xsi_set_current_line(48, ng0);

LAB26:    xsi_set_current_line(49, ng0);
    t11 = (t0 + 2008U);
    t12 = *((char **)t11);
    t11 = (t12 + 4);
    t6 = *((unsigned int *)t11);
    t7 = (~(t6));
    t8 = *((unsigned int *)t12);
    t9 = (t8 & t7);
    t10 = (t9 != 0);
    if (t10 > 0)
        goto LAB27;

LAB28:    xsi_set_current_line(53, ng0);
    t2 = (t0 + 1848U);
    t3 = *((char **)t2);
    t2 = (t3 + 4);
    t6 = *((unsigned int *)t2);
    t7 = (~(t6));
    t8 = *((unsigned int *)t3);
    t9 = (t8 & t7);
    t10 = (t9 != 0);
    if (t10 > 0)
        goto LAB31;

LAB32:
LAB33:
LAB29:    goto LAB25;

LAB23:    xsi_set_current_line(60, ng0);

LAB35:    xsi_set_current_line(61, ng0);
    t3 = (t0 + 2568);
    t5 = (t3 + 56U);
    t11 = *((char **)t5);
    t12 = ((char*)((ng1)));
    memset(t13, 0, 8);
    t27 = (t11 + 4);
    t28 = (t12 + 4);
    t6 = *((unsigned int *)t11);
    t7 = *((unsigned int *)t12);
    t8 = (t6 ^ t7);
    t9 = *((unsigned int *)t27);
    t10 = *((unsigned int *)t28);
    t14 = (t9 ^ t10);
    t15 = (t8 | t14);
    t16 = *((unsigned int *)t27);
    t17 = *((unsigned int *)t28);
    t18 = (t16 | t17);
    t19 = (~(t18));
    t20 = (t15 & t19);
    if (t20 != 0)
        goto LAB39;

LAB36:    if (t18 != 0)
        goto LAB38;

LAB37:    *((unsigned int *)t13) = 1;

LAB39:    t31 = (t0 + 1528U);
    t32 = *((char **)t31);
    t31 = ((char*)((ng2)));
    memset(t33, 0, 8);
    t34 = (t32 + 4);
    t35 = (t31 + 4);
    t21 = *((unsigned int *)t32);
    t22 = *((unsigned int *)t31);
    t23 = (t21 ^ t22);
    t24 = *((unsigned int *)t34);
    t25 = *((unsigned int *)t35);
    t26 = (t24 ^ t25);
    t36 = (t23 | t26);
    t37 = *((unsigned int *)t34);
    t38 = *((unsigned int *)t35);
    t39 = (t37 | t38);
    t40 = (~(t39));
    t41 = (t36 & t40);
    if (t41 != 0)
        goto LAB43;

LAB40:    if (t39 != 0)
        goto LAB42;

LAB41:    *((unsigned int *)t33) = 1;

LAB43:    t44 = *((unsigned int *)t13);
    t45 = *((unsigned int *)t33);
    t46 = (t44 & t45);
    *((unsigned int *)t43) = t46;
    t47 = (t13 + 4);
    t48 = (t33 + 4);
    t49 = (t43 + 4);
    t50 = *((unsigned int *)t47);
    t51 = *((unsigned int *)t48);
    t52 = (t50 | t51);
    *((unsigned int *)t49) = t52;
    t53 = *((unsigned int *)t49);
    t54 = (t53 != 0);
    if (t54 == 1)
        goto LAB44;

LAB45:
LAB46:    t75 = (t43 + 4);
    t76 = *((unsigned int *)t75);
    t77 = (~(t76));
    t78 = *((unsigned int *)t43);
    t79 = (t78 & t77);
    t80 = (t79 != 0);
    if (t80 > 0)
        goto LAB47;

LAB48:    xsi_set_current_line(66, ng0);
    t2 = (t0 + 2728);
    t3 = (t2 + 56U);
    t5 = *((char **)t3);
    t11 = ((char*)((ng1)));
    memset(t13, 0, 8);
    t12 = (t5 + 4);
    t27 = (t11 + 4);
    t6 = *((unsigned int *)t5);
    t7 = *((unsigned int *)t11);
    t8 = (t6 ^ t7);
    t9 = *((unsigned int *)t12);
    t10 = *((unsigned int *)t27);
    t14 = (t9 ^ t10);
    t15 = (t8 | t14);
    t16 = *((unsigned int *)t12);
    t17 = *((unsigned int *)t27);
    t18 = (t16 | t17);
    t19 = (~(t18));
    t20 = (t15 & t19);
    if (t20 != 0)
        goto LAB54;

LAB51:    if (t18 != 0)
        goto LAB53;

LAB52:    *((unsigned int *)t13) = 1;

LAB54:    t30 = (t0 + 1688U);
    t31 = *((char **)t30);
    t30 = ((char*)((ng2)));
    memset(t33, 0, 8);
    t32 = (t31 + 4);
    t34 = (t30 + 4);
    t21 = *((unsigned int *)t31);
    t22 = *((unsigned int *)t30);
    t23 = (t21 ^ t22);
    t24 = *((unsigned int *)t32);
    t25 = *((unsigned int *)t34);
    t26 = (t24 ^ t25);
    t36 = (t23 | t26);
    t37 = *((unsigned int *)t32);
    t38 = *((unsigned int *)t34);
    t39 = (t37 | t38);
    t40 = (~(t39));
    t41 = (t36 & t40);
    if (t41 != 0)
        goto LAB58;

LAB55:    if (t39 != 0)
        goto LAB57;

LAB56:    *((unsigned int *)t33) = 1;

LAB58:    t44 = *((unsigned int *)t13);
    t45 = *((unsigned int *)t33);
    t46 = (t44 & t45);
    *((unsigned int *)t43) = t46;
    t42 = (t13 + 4);
    t47 = (t33 + 4);
    t48 = (t43 + 4);
    t50 = *((unsigned int *)t42);
    t51 = *((unsigned int *)t47);
    t52 = (t50 | t51);
    *((unsigned int *)t48) = t52;
    t53 = *((unsigned int *)t48);
    t54 = (t53 != 0);
    if (t54 == 1)
        goto LAB59;

LAB60:
LAB61:    t58 = (t43 + 4);
    t76 = *((unsigned int *)t58);
    t77 = (~(t76));
    t78 = *((unsigned int *)t43);
    t79 = (t78 & t77);
    t80 = (t79 != 0);
    if (t80 > 0)
        goto LAB62;

LAB63:
LAB64:
LAB49:    goto LAB25;

LAB27:    xsi_set_current_line(50, ng0);

LAB30:    xsi_set_current_line(51, ng0);
    t27 = ((char*)((ng1)));
    t28 = (t0 + 2408);
    xsi_vlogvar_wait_assign_value(t28, t27, 0, 0, 1, 0LL);
    goto LAB29;

LAB31:    xsi_set_current_line(54, ng0);

LAB34:    xsi_set_current_line(55, ng0);
    t5 = ((char*)((ng2)));
    t11 = (t0 + 2408);
    xsi_vlogvar_wait_assign_value(t11, t5, 0, 0, 1, 0LL);
    xsi_set_current_line(56, ng0);
    t2 = ((char*)((ng2)));
    t3 = (t0 + 2888);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 1, 0LL);
    goto LAB33;

LAB38:    t30 = (t13 + 4);
    *((unsigned int *)t13) = 1;
    *((unsigned int *)t30) = 1;
    goto LAB39;

LAB42:    t42 = (t33 + 4);
    *((unsigned int *)t33) = 1;
    *((unsigned int *)t42) = 1;
    goto LAB43;

LAB44:    t55 = *((unsigned int *)t43);
    t56 = *((unsigned int *)t49);
    *((unsigned int *)t43) = (t55 | t56);
    t57 = (t13 + 4);
    t58 = (t33 + 4);
    t59 = *((unsigned int *)t13);
    t60 = (~(t59));
    t61 = *((unsigned int *)t57);
    t62 = (~(t61));
    t63 = *((unsigned int *)t33);
    t64 = (~(t63));
    t65 = *((unsigned int *)t58);
    t66 = (~(t65));
    t67 = (t60 & t62);
    t68 = (t64 & t66);
    t69 = (~(t67));
    t70 = (~(t68));
    t71 = *((unsigned int *)t49);
    *((unsigned int *)t49) = (t71 & t69);
    t72 = *((unsigned int *)t49);
    *((unsigned int *)t49) = (t72 & t70);
    t73 = *((unsigned int *)t43);
    *((unsigned int *)t43) = (t73 & t69);
    t74 = *((unsigned int *)t43);
    *((unsigned int *)t43) = (t74 & t70);
    goto LAB46;

LAB47:    xsi_set_current_line(62, ng0);

LAB50:    xsi_set_current_line(63, ng0);
    t81 = ((char*)((ng1)));
    t82 = (t0 + 2888);
    xsi_vlogvar_wait_assign_value(t82, t81, 0, 0, 1, 0LL);
    xsi_set_current_line(64, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 2408);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 1, 0LL);
    goto LAB49;

LAB53:    t28 = (t13 + 4);
    *((unsigned int *)t13) = 1;
    *((unsigned int *)t28) = 1;
    goto LAB54;

LAB57:    t35 = (t33 + 4);
    *((unsigned int *)t33) = 1;
    *((unsigned int *)t35) = 1;
    goto LAB58;

LAB59:    t55 = *((unsigned int *)t43);
    t56 = *((unsigned int *)t48);
    *((unsigned int *)t43) = (t55 | t56);
    t49 = (t13 + 4);
    t57 = (t33 + 4);
    t59 = *((unsigned int *)t13);
    t60 = (~(t59));
    t61 = *((unsigned int *)t49);
    t62 = (~(t61));
    t63 = *((unsigned int *)t33);
    t64 = (~(t63));
    t65 = *((unsigned int *)t57);
    t66 = (~(t65));
    t29 = (t60 & t62);
    t67 = (t64 & t66);
    t69 = (~(t29));
    t70 = (~(t67));
    t71 = *((unsigned int *)t48);
    *((unsigned int *)t48) = (t71 & t69);
    t72 = *((unsigned int *)t48);
    *((unsigned int *)t48) = (t72 & t70);
    t73 = *((unsigned int *)t43);
    *((unsigned int *)t43) = (t73 & t69);
    t74 = *((unsigned int *)t43);
    *((unsigned int *)t43) = (t74 & t70);
    goto LAB61;

LAB62:    xsi_set_current_line(67, ng0);

LAB65:    xsi_set_current_line(68, ng0);
    t75 = ((char*)((ng1)));
    t81 = (t0 + 2888);
    xsi_vlogvar_wait_assign_value(t81, t75, 0, 0, 1, 0LL);
    xsi_set_current_line(69, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 2408);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 1, 0LL);
    goto LAB64;

}


extern void work_m_00000000002710788982_3156772527_init()
{
	static char *pe[] = {(void *)Always_36_0};
	xsi_register_didat("work_m_00000000002710788982_3156772527", "isim/FastLanes_FrontEnd_tb_isim_beh.exe.sim/work/m_00000000002710788982_3156772527.didat");
	xsi_register_executes(pe);
}
