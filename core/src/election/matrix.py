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

import ecdsa
import random
import json
import numpy as np
import time
import hashlib
from ecdsa import SigningKey,VerifyingKey,BadSignatureError
from SM2 import get_random_str
import asyncio
from blockchain import BlockChain
from listnode import ListNode

import _thread
from time import sleep  
import socket

USE_ECDSA = 1
g_Flag = 0
g_ListIP = {}

MIN_AMOUNT=1000
MAX_AMOUTN=10000
MIN_HASHRATE=1000
MAX_HASHRATE=10000

#MASTETNODES_NUMS=100
#REGION_NUMS=32
#POW_NUMS=21
#VERIFY_NUMS=11
MASTETNODES_NUMS=9
REGION_NUMS=3
POW_NUMS=2
VERIFY_NUMS=1

UTXO_WEIGHT_DELTA=0.1
MAX_NONCE = 2 ** 32
VERIFY_TIME=10
MAX_BLOCKHEIGHT=10000
ELECT_GAP=10
VERIFY_GAP=25
#POW_DIFF=15
MINUPTIME=3600

host = '192.168.1.68'
port = 12345
s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

local_name = socket.gethostname()
local_ip = socket.gethostbyname(local_name)
addr_L = (local_ip, 12345)
s.bind(addr_L)

class Matrix(BlockChain):
    def __init__(self):
        super(Matrix, self).__init__()
        self.global_list = self.generateMN(MASTETNODES_NUMS)
        self.pow_nodes = random.sample(list(self.global_list.values()), 2)
        self.verify_nodes = random.sample(list(self.global_list.values()), 1)

    '''
    #remove by zhenghe
    def generateMN(self, nums):  # 生成主节点列表
        global_list = {}
        for i in range(nums):
            utxoamount = random.randint(MIN_AMOUNT, MAX_AMOUTN)
            hashrate = random.uniform(MIN_HASHRATE, MAX_HASHRATE)
            externalip = '.'.join([str(random.randint(0, 255)) for _ in range(4)])
            if USE_ECDSA == 1:
                privkey = SigningKey.generate()
                #print(type(privkey))
                #print("ecdsa privkey: "+privkey) #test
            else:
                privkey = get_random_str(64)    # modi by zheng
                #print("random privkey: "+privkey) #test
            txid = ''.join(random.choice('0123456789abcdef') for _ in range(32))
            uptime = time.time() - random.randint(0, 100000)
            global_list[txid] = ListNode(utxoamount, hashrate, externalip, privkey, txid, uptime)
        return global_list
    
    '''
    #add by zhenghe
    def generateMN(self, nums): 
        global_list = {}
        for i in range(nums):
            utxoamount = 123
            hashrate = 11.23
            externalip = '192.168.1.7' + str(i)
            g_ListIP[i] = externalip
            #privkey = '121A23AFF0B9440C3BA4C7CA6E424DB7BD85FEC5F33010DDD96BEE45B4DBF482'
            if USE_ECDSA == 1:
                privkey = SigningKey.generate()
            else:
                privkey = get_random_str(64)    # modi by zheng            
            txid = ''.join(random.choice('0123456789abcdef') for _ in range(32))
            uptime = time.time() - random.randint(0, 100000)
            global_list[txid] = ListNode(utxoamount, hashrate, externalip, privkey, txid, uptime)
        return global_list
    

    def clearAll(self):
        for node in self.global_list.values():
            node.updateLevel(0)
            node.updateChildren(None)
            node.updateFather(None)
            node.updateRegion(-1)

    def dividedRegions(self):
        regions = {}
        region_num = 0
        for item in sorted(self.global_list.items(), key=lambda item: item[1].utxoamount * item[1].hashrate):
            item[1].updateRegion(region_num)
            region_num = (region_num + 1) % REGION_NUMS
            if region_num not in regions:
                regions[region_num] = []
            regions[region_num].append(item[1])
        return regions

    def groupPK(self, group):
        timestamp = int(self.timestamp, 16)
        utxo_weights = [max(float(node.utxoamount) * (timestamp - node.uptime) * node.hashrate, UTXO_WEIGHT_DELTA) for
                        node in group]
        p = [float(w) / sum(utxo_weights) for w in utxo_weights]
        winner = np.random.choice(group, 1, p)[0]
        return winner

    def regionElections(self, region):
        select_pool = []
        random.seed(int(self.prevblockhash[:8], 16))
        rounds = 0
        while True:
            for node in region:
                if node.level == rounds:
                    select_pool.append(node)
            if len(select_pool) == 1:
                winner = select_pool[0]
                winner.updateUptime(winner.uptime + (int(self.timestamp, 16) - winner.uptime) / 2)
                return select_pool[0]
            while select_pool:
                if len(select_pool) >= 3:
                    group = random.sample(select_pool, 3)
                else:
                    group = select_pool
                winner = self.groupPK(group)
                children = [node for node in group if node != winner]
                winner.updateLevel(rounds + 1)
                winner.updateChildren(children)
                for node in children:
                    node.updateFather(winner)
                for node in group:
                    select_pool.remove(node)
            rounds += 1
        return False

    def elect(self):
        self.clearAll()
        regions = self.dividedRegions()
        pow_nodes = []
        verify_nodes = []
        for i in range(REGION_NUMS):
            if i < POW_NUMS:
                pow_nodes.append(self.regionElections(regions[i]))
            else:
                verify_nodes.append(self.regionElections(regions[i]))
        return pow_nodes, verify_nodes

    async def powNextblock(self):
        tasks = [node.mining() for node in self.pow_nodes]
        results = await asyncio.gather(*tasks)
        winner = -1
        blockhash = -1
        mintime = time.time()
        for i in range(POW_NUMS):
            hash_result, nonce, timestamp = results[i]
            if timestamp < mintime:
                blockhash, winner, mintime = hash_result, i, timestamp
        return blockhash, winner

    async def verifyAll(self):
        pass

    def SelWinner(self):
        if g_Flag == 0:
            for blockheight in range(MAX_BLOCKHEIGHT):
                loop = asyncio.new_event_loop()
                blockhash, winner = loop.run_until_complete(self.powNextblock())
                loop.close()
                if blockheight % ELECT_GAP == 7:
                    self.pow_nodes, self.verify_nodes = self.elect()
                    print(''.join('-' for _ in range(50)))
                    print('POW_NODES: ' + ' '.join(node.txid for node in self.pow_nodes))
                    print('VERYFI_NODES: ' + ' '.join(node.txid for node in self.verify_nodes))
                    print(''.join('-' for _ in range(50)))
                if blockheight % VERIFY_GAP == 3:
                    pass
                self.nextBlock(blockhash)
            
                data = BlockChain.getBlockChain(self)

                for i in iter(g_ListIP):
                    s.sendto(data.encode(), (g_ListIP[i], port))
        pass
        
        

    def RecNodeInfo(self):
        data, addr = s.recvfrom(1024)
        g_Flag = 1
        print ('Received from %s:%s.' % addr, data)
        
        rece_blockheight = data[0:8]
        int_blockheight = int(rece_blockheight,10)
        rece_blockhash = data[8:40]
        if(int_blockheight > self.blockheight):
            BlockChain.setBlockChain(self,int_blockheight,rece_blockhash)
            g_Flag = 0
        
    
    def run(self):      
        try:
            while 1:
                _thread.start_new_thread(self.SelWinner, ())
                _thread.start_new_thread(self.RecNodeInfo, ())
                sleep(2) 
        except:
            print ("Error: unable to start thread")         

        #finally:      
        #    print ('END\n')         

        #while 1:
        #    pass
    '''
    def run(self):
        for blockheight in range(MAX_BLOCKHEIGHT):
            loop = asyncio.new_event_loop()
            blockhash, winner = loop.run_until_complete(self.powNextblock())
            loop.close()
            if blockheight % ELECT_GAP == 7:
                self.pow_nodes, self.verify_nodes = self.elect()
                print(''.join('-' for _ in range(50)))
                print('POW_NODES: ' + ' '.join(node.txid for node in self.pow_nodes))
                print('VERYFI_NODES: ' + ' '.join(node.txid for node in self.verify_nodes))
                print(''.join('-' for _ in range(50)))
            if blockheight % VERIFY_GAP == 3:
                pass
            self.nextBlock(blockhash)

            
            for node in self.global_list.values():
                node.nextBlock(blockhash)
            print('blockheight: ' + str(self.blockheight), 'winner: ' + self.pow_nodes[winner].txid,
                  'blockhash: ' + blockhash)        
    '''
            
