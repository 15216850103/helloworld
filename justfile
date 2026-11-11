# helloworld just recipes (mirrors Makefile)

app := "helloworld"
bin_dir := "bin"
bin := bin_dir / app
image := app + ":latest"
port := "8080"

default:
    @just --list

# 编译到 bin/helloworld
build:
    mkdir -p {{bin_dir}}
    go build -trimpath -ldflags="-s -w" -o {{bin}} .

# 本地运行（例: just run / just run 9090 / just port=9090 run）
run port=port:
    go run . -port={{port}}

# go mod tidy
tidy:
    go mod tidy

# 清理构建产物
clean:
    rm -rf {{bin_dir}}

# 构建 Docker 镜像
docker-build:
    docker build -t {{image}} .

# 运行 Docker 容器（例: just docker-run / just docker-run 9090 / just port=9090 docker-run）
docker-run port=port:
    docker run --rm -d --name {{app}} -p {{port}}:8080 {{image}}

# 停止 Docker 容器
docker-stop:
    docker stop {{app}}
