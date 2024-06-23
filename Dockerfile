ARG GO_VERSION=1.22.4
ARG PB_VERSION=25.3

FROM golang:$GO_VERSION

ARG PB_VERSION

RUN apt-get update && apt-get install -y build-essential unzip zip npm

RUN curl -L https://github.com/protocolbuffers/protobuf/releases/download/v${PB_VERSION}/protoc-${PB_VERSION}-linux-x86_64.zip \
    -o /tmp/protoc.zip && \
    unzip /tmp/protoc.zip -d /usr/local && \
    rm /tmp/protoc.zip && rm /usr/local/readme.txt

WORKDIR /go/src/app
COPY . /go/src/app

RUN npm install

RUN \
    go install github.com/rakyll/statik@v0.1.7 && \
    go install google.golang.org/protobuf/cmd/protoc-gen-go@v1.32.0 && \
    go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.3.0 && \
    go install github.com/grpc-ecosystem/grpc-gateway/protoc-gen-grpc-gateway@v1.16.0 && \
    go install github.com/grpc-ecosystem/grpc-gateway/protoc-gen-swagger@v1.16.0

RUN git clone https://github.com/envoyproxy/protoc-gen-validate /tmp/protoc-gen-validate && \
    cd /tmp/protoc-gen-validate && make build && rm -rf /tmp/protoc-gen-validate
