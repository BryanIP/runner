package main

import (
	"fmt"
	"os"
)

const version = "v0.0.1"

func main() {
	if len(os.Args) < 2 {
		fmt.Println("Uso: assinatura <comando>")
		return
	}

	switch os.Args[1] {
	case "version":
		fmt.Println("assinatura version", version)
	default:
		fmt.Println("Comando desconhecido:", os.Args[1])
	}
}
