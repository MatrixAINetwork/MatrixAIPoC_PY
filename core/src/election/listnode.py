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

from masternode import Masternode

class ListNode(Masternode):
    def __init__(self, utxoamount, hashrate, externalip, privkey, txid, uptime):
        super(ListNode, self).__init__(utxoamount, hashrate, externalip, privkey, txid)
        self.uptime = uptime  
        self.level = 0  
        self.region = -1
        self.father = None  
        self.children = None 

    def updateLevel(self, level):
        self.level = level

    def updateRegion(self, region):
        self.region = region

    def updateFather(self, father):
        self.father = father

    def updateChildren(self, children):
        self.children = children

    def updateUptime(self, uptime):
        self.uptime = uptime
