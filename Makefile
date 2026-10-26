APP       := helloworld
BIN_DIR   := bin
BIN       := $(BIN_DIR)/$(APP)
IMAGE     := $(APP):latest
PORT      := 8080

.PHONY: help build run tidy clean docker-build docker-run docker-stop

help:
	@echo "Usage:"
	@echo "  make build         编译到 $(BIN)"
	@echo "  make run           本地运行"
	@echo "  make tidy          go mod tidy"
	@echo "  make clean         清理构建产物"
	@echo "  make docker-build  构建 Docker 镜像"
	@echo "  make docker-run    运行 Docker 容器"
	@echo "  make docker-stop   停止 Docker 容器"

build:
	@mkdir -p $(BIN_DIR)
	go build -trimpath -ldflags="-s -w" -o $(BIN) .

run:
	go run . -port=$(PORT)

tidy:
	go mod tidy

clean:
	rm -rf $(BIN_DIR)

docker-build:
	docker build -t $(IMAGE) .

docker-run:
	docker run --rm -d --name $(APP) -p $(PORT):8080 $(IMAGE)

docker-stop:
	-docker stop $(APP)
