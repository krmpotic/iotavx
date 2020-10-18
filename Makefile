BAUD=115200
PORT=/dev/ttyUSB0
FIFO=/tmp/irdata.fifo

setup:
	sudo chown $(shell whoami) $(PORT)
	stty $(PORT) $(BAUD)
	mkfifo $(FIFO) 2>/dev/null

receive:
	sed -n '/IrData:/p' <$(PORT) | sed 's/.*IrData://' > $(FIFO)

decode:
	./iotavx-custom.sh /tmp/irdata.fifo

.PHONY: setup receive decode
