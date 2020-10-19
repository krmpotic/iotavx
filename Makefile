BAUD=115200
PORT=/dev/ttyUSB0
FIFO=/tmp/irdata.fifo

setup:
	sudo chown $(shell whoami) $(PORT)
	stty $(PORT) $(BAUD)
	mkfifo $(FIFO)

receive:
	sed -n '/IrData:/p' <$(PORT) | sed 's/.*IrData://' > $(FIFO)

decode:
	./iotavx-custom.sh $(FIFO)

.PHONY: setup receive decode
