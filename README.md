[![Travis](https://travis-ci.org/MatrixAINetworkMan/MatrixAIPoC_PY.svg?branch=master)](https://travis-ci.org/MatrixAINetworkMan/MatrixAIPoC_PY.svg?branch=master)

This is a POC release (Python Version) for Election Algorithm of Consensus Mechanism, with the main aim of demonstrating how high-performance TPS can be achieved. C++ version is currently in development.You will easily understand from it that what master nodes/verification nodes/miner nodes are, how benefits are distributed as well as how extra calculation tasks are assigned.

Major codes designed for AI processor hardware have also been included in this release as Verilog codes, which are implemented based on ASIC. Codes specially designed for GPU will be announced later. Besides, we will release the  C codes based on CPU model.

All AI features announced are provided in the form based on Agent Specification. Related codes actually perform MapReduce methods on external tasks to achieve function mapping, and will be finally adapted into each of Matrix's processor networks. How adaption shall be carried out are now in definition.

We plan to optimize our internal feature modules using the custom AI functions. Python version of these codes have already been finished, waiting for proper data sources to perform optimization on.

**Instructions to the folder tree**

/FastLanes: Includes GPU AI codes

/ParallelShapelet: Includes ParallelShapelet codes

/Core: Includes the core data structure and election algorithms (VM,blockchain,etc)

/p2p:p2p network protocal

/crypto:crypto and hash algorithms

/miner: block creation and mining
 



Credits 
=======
+Thanks to everyone who directly contributed to this release:
  
- Bill Lee
- Yanqiang Lee
- Xuyang Wang
- Steve Deng
- Cao Ao 
- Xuelong Sun 
- Zheng He
- Shaoqing Long
- Allen Hao