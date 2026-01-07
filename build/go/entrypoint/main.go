package main

import (
	"os"
	"strings"

	"github.com/11notes/docker-util"
)

const BIN string = "/usr/local/bin/mc"

func alias(){
	password, err := eleven.Container.GetSecret("MC_MINIO_ROOT_PASSWORD", "MC_MINIO_ROOT_PASSWORD_FILE")
	if err != nil {
		eleven.LogFatal("you must set MC_MINIO_ROOT_PASSWORD or MC_MINIO_ROOT_PASSWORD_FILE!")
	}

	_, err = eleven.Util.Run(BIN, []string{"alias", "set", os.Getenv("MC_ALIAS"), os.Getenv("MC_MINIO_URL"), os.Getenv("MC_MINIO_ROOT_USER"), password})
	if err != nil{
		eleven.LogFatal("alias failed %s", err)
	}else{
		eleven.Log("INF", "set alias to %s for all future commands", os.Getenv("MC_ALIAS"))
	}
}

func command(cmd string){
	out, err := eleven.Util.Run(BIN, strings.Split(cmd, " "))
	if err != nil{
		eleven.Log("ERR", "command failed %s", err)
	}else{
		eleven.Log("INF", "%s", strings.TrimRight(out, "\r\n"))
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
		eleven.LogFatal("you must specify a command to run")
	}
}