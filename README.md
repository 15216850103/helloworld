# helloworld

基于 [Gin](https://github.com/gin-gonic/gin) 的简单 Web 示例项目。

## 目录结构

```
helloworld/
├── main.go                 # 入口
├── go.mod
├── internal/
│   ├── handler/            # 控制器层
│   │   ├── home.go         # 根路径
│   │   └── notfound.go     # 统一 404
│   └── router/             # 路由配置层
│       └── router.go
└── README.md
```

## 快速开始

```bash
go run .
# 或指定端口
go run . -port=9090
```

默认监听 `:8080`，可通过 `-port` 参数覆盖。

## Docker 构建与运行

```bash
构建
  docker build -t helloworld:latest .

运行：
  docker run --rm -p 8080:8080 helloworld:latest

构建并推送远端
  docker buildx build -f Dockerfile --platform linux/amd64 -t harbor.imapp66.com/superapp/helloworld:latest --push . 

```

构建完成后访问 `http://localhost:8080/`。

## 接口说明

| 方法 | 路径 | 说明 |
|------|------|------|
| GET  | `/`  | 返回正常 |
| *    | 其它 | 统一 404，打印参数与 path，返回 JSON |

### 根路径

```bash
curl http://localhost:8080/
```

```json
{"code":0,"message":"ok"}
```

### 统一 404

未匹配路由时记录日志（path、query/form/path 参数），并返回：

```bash
curl "http://localhost:8080/foo?a=1&b=2"
```

```json
{
  "code": 404,
  "message": "not found",
  "path": "/foo",
  "params": {
    "query": {"a": "1", "b": "2"}
  }
}
```

服务端日志示例：

```
[404] path=/foo params=map[query:map[a:1 b:2]]
```
