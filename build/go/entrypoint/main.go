package main

import (
	"os"
	"strings"

	"github.com/11notes/go"
)

const BIN string = "/usr/local/bin/mc"

var(
	Eleven eleven.New = eleven.New{}
)

func alias(){
	password, err := Eleven.Container.GetSecret("MC_MINIO_ROOT_PASSWORD", "MC_MINIO_ROOT_PASSWORD_FILE")
	if err != nil {
		Eleven.LogFatal("you must set MC_MINIO_ROOT_PASSWORD or MC_MINIO_ROOT_PASSWORD!")
	}

	_, err = Eleven.Util.Run(BIN, []string{"alias", "set", "minio", os.Getenv("MC_MINIO_URL"), os.Getenv("MC_MINIO_ROOT_USER"), password})
	if err != nil{
		Eleven.LogFatal("alias failed %s", err)
	}else{
		Eleven.Log("INF", "set alias to minio for all future commands")
	}
}

func command(cmd string){
	out, err := Eleven.Util.Run(BIN, strings.Split(cmd, " "))
	if err != nil{
		Eleven.Log("ERR", "command failed %s", err)
	}else{
		Eleven.Log("INF", "%s", strings.TrimRight(out, "\r\n"))
	}
}

func main() {
	if(len(os.Args) > 1){
		alias()
		args := os.Args[1:]
		for _, arg := range args {
			command(arg)
		}
	}else{
		Eleven.LogFatal("you must specify a command to run")
	}
}