package handler

import (
	"net/http"

	"github.com/gin-gonic/gin"
)

// Healthz 健康检查
func Healthz(c *gin.Context) {
	c.JSON(http.StatusOK, gin.H{
		"code":    0,
		"message": "ok",
	})
}
