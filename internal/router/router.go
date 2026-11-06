package router

import (
	"helloworld/internal/handler"

	"github.com/gin-gonic/gin"
)

// Setup 注册路由与统一 404
func Setup() *gin.Engine {
	r := gin.Default()

	r.GET("/", handler.Home)
	r.GET("/healthz", handler.Healthz)

	r.NoRoute(handler.NotFound)

	return r
}
