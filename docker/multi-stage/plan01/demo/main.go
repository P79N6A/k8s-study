package main

import (
	"github.com/gin-gonic/gin"
	"net/http"
)

func main() {
	router := gin.Default()
	router.GET("/test", func(context *gin.Context) {
		context.String(http.StatusOK, "success")
	})
	router.Run(":8080")
}
