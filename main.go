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
var code = map[string]int{
	"0":               0x00,
	"1":               0x01,
	"2":               0x02,
	"3":               0x03,
	"4":               0x04,
	"5":               0x05,
	"6":               0x06,
	"7":               0x07,
	"8":               0x08,
	"9":               0x09,
	"play-pause":      0x0a,
	"+10":             0x0d,
	"-10":             0x0e,
	"dim":             0x11,
	"stop":            0x14,
	"mode":            0x16,
	"shutdown":        0x18,
	"folder+":         0x19,
	"VOLUME UP":       0x1a,
	"shuffle":         0x1b,
	"ext. previous":   0x1c,
	"folder-":         0x1d,
	"VOLUME DOWN":     0x1e,
	"repeat":          0x1f,
	"forward":         0x40,
	"seek+":           0x40,
	"ext. port":       0x42,
	"backward":        0x44,
	"seek-":           0x44,
	"info":            0x45,
	"previous":        0x46,
	"next":            0x47,
	"ext. next":       0x54,
	"ext. play-pause": 0x57,
	"eject":           0x5b,
	"time":            0x5f,
}

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
