FROM ubuntu:18.04

RUN ln -sf /bin/bash /bin/sh && \
	apt-get update && \
	apt-get install -y curl software-properties-common mesa-opencl-icd ocl-icd-opencl-dev && \
	export RUSTUP_DIST_SERVER=https://mirrors.ustc.edu.cn/rust-static && \
	export RUSTUP_UPDATE_ROOT=https://mirrors.ustc.edu.cn/rust-static/rustup && \
	curl -s https://mirrors.ustc.edu.cn/rust-static/rustup/rustup-init.sh | sh -s -- -y && \
	add-apt-repository ppa:longsleep/golang-backports -y && \
 	apt-get update && \
 	apt-get install -y golang-go gcc git bzr jq pkg-config mesa-opencl-icd ocl-icd-opencl-dev && \
	rm -rf /var/lib/apt/lists/*

ENV PATH="/root/.cargo/bin:$PATH"
