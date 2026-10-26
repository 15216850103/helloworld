# 构建阶段
FROM golang:1.26-alpine AS builder

ENV CGO_ENABLED=0 \
    GOOS=linux \
    GO111MODULE=on \
    GOPROXY=https://goproxy.cn,direct

WORKDIR /src

COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN go build -trimpath -ldflags="-s -w" -o /out/helloworld .

# 运行阶段
FROM alpine:3.23

RUN apk add --no-cache ca-certificates tzdata \
    && adduser -D -H -u 1000 app

WORKDIR /app

COPY --from=builder /out/helloworld /app/helloworld

USER app

EXPOSE 8080

ENTRYPOINT ["/app/helloworld"]
