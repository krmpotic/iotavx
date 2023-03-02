package main

import (
	"bufio"
	"fmt"
	"os"
	"os/exec"
	"regexp"
	"strconv"
)

var re_irdata = regexp.MustCompile("IrAddress:[[:xdigit:]]{4}, IrData:([[:xdigit:]]{2})")

func execute(c int) {
	var err error
	switch c {
	case code["play-pause"]:
		fmt.Println("play-pause")
		err = exec.Command("playerctl", "play-pause").Run();
	case code["next"]:
		fmt.Println("next")
		err = exec.Command("playerctl", "next").Run();
	case code["previous"]:
		fmt.Println("previous")
		err = exec.Command("playerctl", "previous").Run();
	case code["seek-"]:
		fmt.Println("seek-")
		err = exec.Command("playerctl", "position", "10-").Run();
	case code["seek+"]:
		fmt.Println("seek+")
		err = exec.Command("playerctl", "position", "10+").Run();
	case code["stop"]:
		fmt.Println("stop")
		err = exec.Command("playerctl", "stop").Run();
	case code["shuffle"]:
		fmt.Println("shuffle")
		err = exec.Command("playerctl", "shuffle").Run();
	}
	if err != nil {
		fmt.Fprintf(os.Stderr, "%s\n", err);
	}
}

func main() {
	file, err := os.Open(os.Args[1])
	if err != nil {
		fmt.Fprintf(os.Stderr, "opening: %s", err)
		os.Exit(1)
	}
	s := bufio.NewScanner(file)

	for s.Scan() {
		if sm := re_irdata.FindSubmatch([]byte(s.Text())); sm != nil && len(sm) == 2 {
			//fmt.Println(s.Text())
			c, err := strconv.ParseInt(string(sm[1]), 16, 64)
			if err != nil {
				continue
			}
			execute(int(c))
		}
	}
}
