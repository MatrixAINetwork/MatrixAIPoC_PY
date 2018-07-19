### Probability of a Node to be Selected as a Miner Node
- Mainly depends on:（Processing Power + Stakes）* OnlineTime
- To some extent, the higher the processing power is, the higher the probability of being selected as a masternode is. For the sake of fairness, nodes with very high processing powers will be limited somewhat;
- To some extent, the higher the stakes are, the higher probability of being selected as a masternode is;
- The longer the online time is, the higher the probability of being selected as a masternode is; after being selected as a masternode, the probability of being selected again will reduce greatly; the probability is in propotion to the onlinetime counter BeCandidatehrsCnt, whose value will be changed based on the status of nodes:

  - idle->candidate: New nodes join the network and compete for the role of superNode, where the value of BeCandidatehrsCnt starts from 0
  - candidate->candidate, the value of BeCandidatehrsCnt will be added by 1 every one hour
  - candidate->superNode->candidate, when one node is elected as superNode

```
graph TD
A[idle] --> |set 0| B[candidate]
B --> |/2|C[superNode]
B --> |+1 if < 500 else +0| B
C --> B
```

##### How to generate random seeds in the case of 11 validators?

- Here, we require a special mechanism to trigger sending (tempprivatekey, temppublickey)
  - consider triggering it through the characteristics of block height
- Assume there are A,B,C,...,H,I,J,K validator nodes
  - Node A writes temppublickey into the block
  - Node B,C,...,K write the block
  - Node A writes temppublickey into the block and collects the publickey of the first 11 blocks
  - Node B,C,...,K write the block and collect the publickey of the first 11 blocks
- After the second round of the writing of temppublickey, start writing tempprivatekey
  - Node A writes tempprivatekey into the block
  - Node B,C,...,K write the block
  - Node A writes tempprivatekey into the block and collects the privatekey of the first 11 blocks, then validate it
  - Node B,C,...,K write the block, and collect tempprivatekey, then validate it
- For "Voting for seed", the seed wining the most votes will be used for miner selection

##### Key factor impacting the selection of validators
- Sorting

##### Select M miner nodes from N masternodes
Selecting M different miner nodes from N masternodes is a kind of discrete probability sampling. We suggest using the following method:

** | Linear | Dichotomy | AliasTable | F+Tree
---|---|---|---|---
Time of Creation | O(N) | O(N)| O(N) | O(N)
Time of Sampling | O(N) | O(logN) | O(1) |O(logN)
Time of Update | O(1) | O(N)| O(N) | O(logN)
- 如果只进行一次采样，上面方法没有什么不同
- 如果进行多次采样，应该选择AliasTable

我们的目的从N中选出M个互不相同的节点，就需要每进行一次采样伴随一次单个节点的概率调整，因此选用f+树采样方法。

- 是否已知globallist的大小，如果已知，可以将globalist映射到一个f+树的叶子节点.
- ==一颗f+树采样能够使用一个周期还是多个周期，主要看概率的更新频率(tps,stake,becandidatecnt)==


##### 
- 要一起收集过来
- 0-100生成一组随机数L，看概率，扩大see 的范围.
- 时间一致性，空间一致性.
- 一个seed, T看100个采样,质数次
- 一个seed,隔一段取一个 bigint，必须大于某个数，数据统计
偏离度
- |A-X|/A偏离度
- 以太坊私钥生成随机
- well算法；/dev/random