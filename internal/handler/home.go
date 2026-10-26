package handler

import (
	"net/http"

	"github.com/gin-gonic/gin"
)

// Home 根路径，返回正常
func Home(c *gin.Context) {
	c.JSON(http.StatusOK, gin.H{
		"code":    0,
		"message": "ok",
	})
}
