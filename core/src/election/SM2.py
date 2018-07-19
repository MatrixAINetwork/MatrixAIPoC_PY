"""
// Copyright 2018 The Matrix Authors
// This file is part of the Matrix library.
//
// The Matrix library is free software: you can redistribute it and/or modify
// it under the terms of the GNU Lesser General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// The Matrix library is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU Lesser General Public License for more details.
//
// You should have received a copy of the GNU Lesser General Public License
// along with the Matrix library. If not, see <http://www.gnu.org/licenses/>.
"""
# SM2.py - The core part of the sm2 library
# Author: zh
# Modifier: zheng

from random import choice
import SM3

sm2_N = int('FFFFFFFEFFFFFFFFFFFFFFFFFFFFFFFF7203DF6B21C6052B53BBF40939D54123', 16)
sm2_P = int('FFFFFFFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000FFFFFFFFFFFFFFFF', 16)
sm2_G = '32c4ae2c1f1981195f9904466a39c9948fe30bbff2660be1715a4589334c74c7bc3736a2f4f6779c59bdcee36b692153d0a9877cc62a474002df32e52139f0a0' 
sm2_a = int('FFFFFFFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000FFFFFFFFFFFFFFFC',16)
sm2_b = int('28E9FA9E9D9F5E344D5A9E4BCF6509A7F39789F515AB8F92DDBCBD414D940E93',16)
sm2_a_3 = (sm2_a + 3) % sm2_P 
Fp = 256

def get_random_str(strlen):
    letterlist = ['0','1','2','3','4','5','6','7','8','9','a','b','c','d','e','f']
    str = ''
    for i in range(strlen):
        a = choice(letterlist)
        str = '%s%s' % (str,a)
    return str

def kG(k, Point,len_para):
    Point = '%s%s' % (Point, '1')
    mask_str = '8'
    for i in range(len_para-1):
        mask_str += '0'
    # print(mask_str)
    mask = int(mask_str, 16)
    Temp = Point
    flag = False
    for n in range(len_para * 4):
        if (flag):
            Temp = DoublePoint(Temp,len_para)
        if (k & mask) != 0:
            if (flag):
                Temp = AddPoint(Temp, Point,len_para)
            else:
                flag = True
                Temp = Point
        k = k << 1
    return ConvertJacb2Nor(Temp,len_para)

def DoublePoint(Point,len_para): 
    l = len(Point)
    len_2 = 2 * len_para
    if l< len_para*2:
        return None
    else:
        x1 = int(Point[0:len_para], 16)
        y1 = int(Point[len_para:len_2], 16)
        if l == len_2:
            z1 = 1
        else:
            z1 = int(Point[len_2:], 16)
        T6 = (z1 * z1) % sm2_P
        T2 = (y1 * y1) % sm2_P
        T3 = (x1 + T6) % sm2_P
        T4 = (x1 - T6) % sm2_P
        T1 = (T3 * T4) % sm2_P
        T3 = (y1 * z1) % sm2_P
        T4 = (T2 * 8) % sm2_P
        T5 = (x1 * T4) % sm2_P
        T1 = (T1 * 3) % sm2_P
        T6 = (T6 * T6) % sm2_P
        T6 = (sm2_a_3 * T6) % sm2_P
        T1 = (T1 + T6) % sm2_P
        z3 = (T3 + T3) % sm2_P
        T3 = (T1 * T1) % sm2_P
        T2 = (T2 * T4) % sm2_P
        x3 = (T3 - T5) % sm2_P

        if (T5 % 2) == 1:
            T4 = (T5 + ((T5 + sm2_P) >> 1) - T3) % sm2_P
        else:
            T4 = (T5 + (T5 >> 1) - T3) % sm2_P

        T1 = (T1 * T4) % sm2_P
        y3 = (T1 - T2) % sm2_P

        form = '%%0%dx' % len_para
        form = form * 3
        return form % (x3, y3, z3)

def AddPoint(P1, P2,len_para):  
    len_2 = 2 * len_para
    l1 = len(P1)
    l2 = len(P2)
    if (l1 < len_2) or (l2 < len_2):
        return None
    else:
        X1 = int(P1[0:len_para], 16)
        Y1 = int(P1[len_para:len_2], 16)
        if (l1 == len_2):
            Z1 = 1
        else:
            Z1 = int(P1[len_2:], 16)
        x2 = int(P2[0:len_para], 16)
        y2 = int(P2[len_para:len_2], 16)

        T1 = (Z1 * Z1) % sm2_P
        T2 = (y2 * Z1) % sm2_P
        T3 = (x2 * T1) % sm2_P
        T1 = (T1 * T2) % sm2_P
        T2 = (T3 - X1) % sm2_P
        T3 = (T3 + X1) % sm2_P
        T4 = (T2 * T2) % sm2_P
        T1 = (T1 - Y1) % sm2_P
        Z3 = (Z1 * T2) % sm2_P
        T2 = (T2 * T4) % sm2_P
        T3 = (T3 * T4) % sm2_P
        T5 = (T1 * T1) % sm2_P
        T4 = (X1 * T4) % sm2_P
        X3 = (T5 - T3) % sm2_P
        T2 = (Y1 * T2) % sm2_P
        T3 = (T4 - X3) % sm2_P
        T1 = (T1 * T3) % sm2_P
        Y3 = (T1 - T2) % sm2_P

        form = '%%0%dx' % len_para
        form = form * 3
        return form % (X3, Y3, Z3)

def ConvertJacb2Nor(Point,len_para): 
    len_2 = 2 * len_para
    x = int(Point[0:len_para], 16)
    y = int(Point[len_para:len_2], 16)
    z = int(Point[len_2:], 16)
    # z_inv = Inverse(z, P)
    z_inv = pow(z, sm2_P - 2, sm2_P)
    z_invSquar = (z_inv * z_inv) % sm2_P
    z_invQube = (z_invSquar * z_inv) % sm2_P
    x_new = (x * z_invSquar) % sm2_P
    y_new = (y * z_invQube) % sm2_P
    z_new = (z * z_inv) % sm2_P
    if z_new == 1:
        form = '%%0%dx' % len_para
        form = form * 2
        return form % (x_new, y_new)
    else:
        print ("Point at infinity!!!!!!!!!!!!")
        return None

def Inverse(data, M,len_para): 
    tempM = M - 2
    mask_str = '8'
    for i in range(len_para-1):
        mask_str += '0'
    mask = int(mask_str, 16)
    tempA = 1
    tempB = data

    for i in range(len_para*4):
        tempA = (tempA * tempA) % M
        if (tempM & mask) != 0:
            tempA = (tempA * tempB) % M
        mask = mask >> 1

    return tempA

def Verify(Sign, E, PA,len_para):
    r = int(Sign[0:len_para], 16)
    s = int(Sign[len_para:2*len_para], 16)
    e = int(E, 16)
    t = (r + s) % sm2_N
    if t == 0:
        return 0

    P1 = kG(s, sm2_G,len_para)
    P2 = kG(t, PA,len_para)
    # print(P1)
    # print(P2)
    if P1 == P2:
        P1 = '%s%s' % (P1, 1)
        P1 = DoublePoint(P1,len_para)
    else:
        P1 = '%s%s' % (P1, 1)
        P1 = AddPoint(P1, P2,len_para)
        P1 = ConvertJacb2Nor(P1,len_para)

    x = int(P1[0:len_para], 16)
    return (r == ((e + x) % sm2_N))

def Sign(E, DA, K,len_para,Hexstr = 0): 
    if Hexstr:
        e = int(E, 16) 
    else:
        E = E.encode('utf-8')
        E = E.hex() 
        e = int(E, 16)

    d = int(DA, 16)
    k = int(K, 16)

    P1 = kG(k, sm2_G,len_para)

    x = int(P1[0:len_para], 16)
    R = ((e + x) % sm2_N)
    if R == 0 or R + k == sm2_N:
        return None
    d_1 = pow(d+1, sm2_N - 2, sm2_N)
    S = (d_1*(k + R) - R) % sm2_N
    if S == 0:
        return None
    else:
        return '%064x%064x' % (R,S)

def Encrypt(M,PA,len_para,Hexstr = 0):
    if Hexstr:
        msg = M 
    else:
        msg = M.encode('utf-8')
        msg = msg.hex() 
    k = get_random_str(len_para)
    C1 = kG(int(k,16),sm2_G,len_para)
    xy = kG(int(k,16),PA,len_para)
    x2 = xy[0:len_para]
    y2 = xy[len_para:2*len_para]
    ml = len(msg)
    t = SM3.KDF(xy,ml/2)
    # print(t)
    if int(t,16)==0:
        return None
    else:
        form = '%%0%dx' % ml
        C2 = form % (int(msg,16) ^ int(t,16))
        # print('C2 = %s'% C2)
        # print('%s%s%s'% (x2,msg,y2))
        C3 = SM3.Hash_sm3('%s%s%s'% (x2,msg,y2),1)
        # print('C3 = %s' % C3)
        return '%s%s%s' % (C1,C3,C2)

def Decrypt(C,DA,len_para):
    len_2 = 2 * len_para
    len_3 = len_2 + 64
    C1 = C[0:len_2]
    C3 = C[len_2:len_3]
    C2 = C[len_3:]
    xy = kG(int(DA,16),C1,len_para)
    # print('xy = %s' % xy)
    x2 = xy[0:len_para]
    y2 = xy[len_para:len_2]
    cl = len(C2)
    # print(cl)
    t = SM3.KDF(xy, cl/2)
    # print('t = %s'%t)
    if int(t,16) == 0:
        return None
    else:
        form = '%%0%dx' % cl
        M = form % (int(C2,16) ^ int(t,16))
        # print('M = %s' % M)
        u = SM3.Hash_sm3('%s%s%s'% (x2,M,y2),1)
        if  (u == C3):
            return M
        else:
            return None

#add by zheng
def GeneratePubkey(k):
    len_para = 64
    return kG(k, sm2_G,len_para)
