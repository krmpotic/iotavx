BAUD=115200
PORT=/dev/ttyUSB0
FIFO=/tmp/irdata.fifo

setup:
	sudo chown $(shell whoami) $(PORT)
	stty $(PORT) $(BAUD)
	-mkfifo $(FIFO) 2>/dev/null

receive:
	sed -n '/IrData:/p' <$(PORT) | sed 's/.*IrData://' > $(FIFO)

decode:
	./iotavx-custom.sh $(FIFO)

test:
	-mkfifo $(FIFO) 2>/dev/null
	tail -f $(FIFO) | ./iotavx-custom.sh /dev/stdin

.PHONY: setup receive decode test
