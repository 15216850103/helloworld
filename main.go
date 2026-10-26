package main

import (
	"flag"
	"fmt"
	"log"

	"helloworld/internal/router"
)

func main() {
	port := flag.Int("port", 8080, "listen port")
	flag.Parse()

	r := router.Setup()
	addr := fmt.Sprintf(":%d", *port)
	log.Printf("server listening on %s", addr)
	if err := r.Run(addr); err != nil {
		log.Fatal(err)
	}
}
