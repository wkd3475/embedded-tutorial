ARCH = armv7-a
MCPU = cortex-a8

CC = arm-none-eabi-gcc
AS = arm-none-eabi-as
LD = arm-none-eabi-ld
OC = arm-none-eabi-objcopy

LINKER_SCRIPT = ./learnos.ld

ASM_SRCS = $(wildcard boot/*.S)
ASM_OBJS = $(patsubst boot/%.S, build/%.o, $(ASM_SRCS))

learnos = build/learnos.axf
learnos_bin = build/learnos.bin

.PHONY: all clean run debug gdb

all: $(learnos)

clean:
	@rm -fr buid

run: $(learnos)
	qemu-system-arm -M realview-pb-a8 -kernel $(learnos)

debug: $(learnos)
	qemu-system-arm -M realview-pb-a8 -kernel $(learnos) -S -gdb tcp::1234,ipv4

gdb:
	gdb-multiarch

$(learnos): $(ASM_OBJS) $(LINKER_SCRIPT)
	$(LD) -n -T $(LINKER_SCRIPT) -o $(learnos) $(ASM_OBJS)
	$(OC) -O binary $(learnos) $(learnos_bin)
	
build/%.o: boot/%.S
	mkdir -p $(shell dirname $@)
	$(AS) -march=$(ARCH) -mcpu=$(MCPU) -g -o $@ $<
