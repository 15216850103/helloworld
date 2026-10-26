package handler

import (
	"log"
	"net/http"

	"github.com/gin-gonic/gin"
)

// NotFound 统一 404：打印接收参数与访问 path，返回 JSON
func NotFound(c *gin.Context) {
	path := c.Request.URL.Path
	params := collectParams(c)

	log.Printf("[404] path=%s params=%v", path, params)

	c.JSON(http.StatusNotFound, gin.H{
		"code":    404,
		"message": "not found",
		"path":    path,
		"params":  params,
	})
}

func collectParams(c *gin.Context) map[string]any {
	params := make(map[string]any)

	query := make(map[string]string)
	for k, v := range c.Request.URL.Query() {
		if len(v) == 1 {
			query[k] = v[0]
		} else {
			query[k] = join(v)
		}
	}
	if len(query) > 0 {
		params["query"] = query
	}

	_ = c.Request.ParseForm()
	form := make(map[string]string)
	for k, v := range c.Request.PostForm {
		if len(v) == 1 {
			form[k] = v[0]
		} else {
			form[k] = join(v)
		}
	}
	if len(form) > 0 {
		params["form"] = form
	}

	pathParams := make(map[string]string)
	for _, p := range c.Params {
		pathParams[p.Key] = p.Value
	}
	if len(pathParams) > 0 {
		params["path"] = pathParams
	}

	return params
}

func join(vs []string) string {
	if len(vs) == 0 {
		return ""
	}
	out := vs[0]
	for i := 1; i < len(vs); i++ {
		out += "," + vs[i]
	}
	return out
}
