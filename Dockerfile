FROM lotusbuilder:v1.0.3 as builder

WORKDIR /home/

RUN mkdir ~/.ssh && chmod 755 ~/.ssh && \
    git clone -b interopnet https://github.com/filecoin-project/lotus.git --depth 2 && \
    cd lotus/ && \
    go env -w GO111MODULE=auto && \
    go env -w GOPROXY="https://goproxy.cn,direct" && \
    export PATH="$HOME/.cargo/bin:$PATH" && \
    make clean && make 2k


FROM ubuntu:18.04

COPY setup-local.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/setup-local.sh && \
    apt-get update && apt-get -y install software-properties-common && \
    apt-get update && \
    add-apt-repository ppa:longsleep/golang-backports && \
    apt-get update && apt-get -y install  mesa-opencl-icd ocl-icd-opencl-dev && \
    apt-get purge -y software-properties-common && \
    apt-get autoremove -y && apt-get clean -y && apt-get autoclean -y && \
    rm -rf /var/lib/apt/lists/*

ENV IPFS_GATEWAY https://proof-parameters.s3.cn-south-1.jdcloud-oss.com/ipfs/
ENV FIL_PROOFS_PARAMETER_CACHE /home/filecoin-proof-parameters
ENV TMPDIR /home/tmp
ENV LOTUS_STORAGE_PATH /home/lotusstorage
ENV WORKER_PATH /home/lotusworker
ENV LOTUS_PATH /home/lotus

# lotus api:
EXPOSE 1234
# miner api:
EXPOSE 2345

# reserve:
EXPOSE 10000
EXPOSE 10001
EXPOSE 10002
EXPOSE 10003
EXPOSE 10004
EXPOSE 10005
EXPOSE 10006
EXPOSE 10007
EXPOSE 10008
EXPOSE 10009

COPY --from=builder /home/lotus/lotus                 /usr/local/bin/
COPY --from=builder /home/lotus/lotus-storage-miner   /usr/local/bin/
COPY --from=builder /home/lotus/lotus-seal-worker     /usr/local/bin/
COPY --from=builder /home/lotus/lotus-seed            /usr/local/bin/

CMD ["cd /home/ && mkdir tmp"]
