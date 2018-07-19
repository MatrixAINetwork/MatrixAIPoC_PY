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
import random
import time

#POW_DIFF=15
POW_DIFF = 8

def ss(x):
    s = str(x)
    while len(s) < 8:
        s = "0" + s
    return s

class BlockChain:
    def __init__(self):
        self.blockheight = 0
        self.version = '00000010'
        self.prevblockhash = '00000000000000000000000000000000'
        self.merkleroot = '00000000000000000000000000001994'
        self.timestamp = hex(int(time.time()))[2:]
        self.target = '00000010'
        self.blockheader = self.getBlockheader()
    
    def setBlockChain(self,blockheight,prevblockhash):
        self.blockheight = blockheight
        self.prevblockhash = prevblockhash
    
    def getBlockChain(self):
        return ss(self.blockheight)  + self.prevblockhash
    
    def getBlockheader(self):
        return self.version + self.prevblockhash + self.merkleroot + self.timestamp + self.target

    def getDifficulty(self):
        diff = POW_DIFF
        return diff

    def getPrevblockhash(self):
        return self.prevblockhash

    def getBlockheight(self):
        return self.blockheight

    def nextBlock(self, blockhash):
        self.blockheight += 1
        self.version = self.version
        self.prevblockhash = blockhash
        self.merkleroot = ''.join(random.choice('0123456789abcdef') for _ in range(32))
        self.timestamp = hex(int(time.time()))[2:]
        self.target = self.target
        self.blockheader = self.getBlockheader()
