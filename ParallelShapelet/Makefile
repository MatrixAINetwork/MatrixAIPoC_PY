PROJECT_NAME=shapelet

CC=g++ -std=c++11 -O3 
NVCC=nvcc

NVCC += -O3 
NVCC += --gpu-architecture=sm_61

CUDA_PATH = /usr/local/cuda

CFLAGS = -c -m64 -I$(CUDA_PATH)/include
NVCCFLAGS = -c -I$(CUDA_PATH)/include
#LFLAGS = -m64 -I$(CUDA_PATH)/include -lcuda -lcudart -lm
LFLAGS = -lcudart -L/usr/local/cuda/lib64
DIR=src
OUT=bin

all:build

build: CPU GPU link
	$(NVCC) $(OUT)/prunedtw.o $(OUT)/infogain.o $(OUT)/pub.o $(OUT)/min.o $(OUT)/shapelet.o $(OUT)/euclid.o $(OUT)/link.o $(OUT)/main.o $(OUT)/readfile.o $(OUT)/metric.o $(OUT)/distanceoncpu.o -o $(OUT)/$(PROJECT_NAME)
#	$(NVCC) $(OUT)/Averagetest.o $(OUT)/metric.o $(OUT)/readfile.o $(OUT)/prunedtw.o $(OUT)/link2.o  -o $(OUT)/Averagetest 
	$(NVCC) $(OUT)/prunedtw.o $(OUT)/infogain.o $(OUT)/pub.o $(OUT)/min.o $(OUT)/shapelet.o $(OUT)/euclid.o $(OUT)/link.o $(OUT)/Averagetest.o $(OUT)/readfile.o $(OUT)/metric.o $(OUT)/distanceoncpu.o -o $(OUT)/Averagetest
link:
	$(NVCC) --device-link $(OUT)/prunedtw.o $(OUT)/infogain.o $(OUT)/pub.o $(OUT)/min.o $(OUT)/shapelet.o $(OUT)/euclid.o -o $(OUT)/link.o
GPU:
		$(NVCC) -dc $(NVCCFLAGS) $(DIR)/prunedtw.cu -o $(OUT)/prunedtw.o
		$(NVCC) -dc $(NVCCFLAGS) $(DIR)/infogain.cu -o $(OUT)/infogain.o
		$(NVCC) -dc $(NVCCFLAGS) $(DIR)/pub.cu -o $(OUT)/pub.o
		$(NVCC) -dc $(NVCCFLAGS) $(DIR)/euclid.cu -o $(OUT)/euclid.o
		$(NVCC) -dc $(NVCCFLAGS) $(DIR)/min.cu -o $(OUT)/min.o
		$(NVCC) -dc $(NVCCFLAGS) $(DIR)/shapelet.cu -o $(OUT)/shapelet.o
		$(NVCC) -dc $(NVCCFLAGS) $(DIR)/distanceoncpu.cu -o $(OUT)/distanceoncpu.o

CPU:
		$(CC) $(CFLAGS) $(DIR)/main.cpp -o $(OUT)/main.o
		$(CC) $(CFLAGS) $(DIR)/readfile.cpp -o $(OUT)/readfile.o
		$(CC) $(CFLAGS) $(DIR)/metric.cpp -o $(OUT)/metric.o
		$(CC) $(CFLAGS) $(DIR)/Averagetest.cpp -o $(OUT)/Averagetest.o

clean:
		rm $(OUT)/*.o
run:
		$(OUT)/$(PROJECT_NAME) 50 150 40 100 0

