
TARGET = vvecDox
BINARY_FORMAT := ihex
# the binary format to generate

MCU := atmega32u4
# processor type (for the teensy 2.0)

F_CPU := 16000000
# processor speed, in Hz; max value is 16000000 (16MHz); must match
# initialization in source


SRCDIR = src
OBJDIR = obj
BINDIR = bin

SOURCES  := $(wildcard $(SRCDIR)/*.c)
INCLUDES := $(wildcard $(SRCDIR)/*.c)
OBJECTS  := $(SOURCES:$(SRCDIR)/%.c=$(OBJDIR)/%.o)

# Compiler flags to generate dependency files.
GENDEPFLAGS = -MMD -MP -MF $@.dep

CC = avr-gcc
CFLAGS += -mmcu=$(MCU)      # processor type; must match real life
CFLAGS += -DF_CPU=$(F_CPU)  # processor frequency; must match initialization in source
CFLAGS += -std=gnu99  # use C99 plus GCC extensions
CFLAGS += -Os         # optimize for size
CFLAGS += -Wall                # enable lots of common warnings
CFLAGS += -Wstrict-prototypes  # "warn if a function is declared or defined
			       #   without specifying the argument types"
CFLAGS += -fpack-struct  # "pack all structure members together without holes"
CFLAGS += -fshort-enums  # "allocate to an 'enum' type only as many bytes as it
			 #   needs for the declared range of possible values"
CFLAGS += -ffunction-sections  # \ "place each function or data into its own
CFLAGS += -fdata-sections      # /   section in the output file if the
			       #     target supports arbitrary sections."  for
			       #     linker optimizations, and discarding
			       #     unused code.

LINKER = avr-gcc -o
LDFLAGS += -Wl,-Map=$(TARGET).map,--cref  # generate a link map, with a cross
					  #   reference table
LDFLAGS += -Wl,--relax        # for some linker optimizations
LDFLAGS += -Wl,--gc-sections  # discard unused functions and data


rm       = rm -f

#all:
	#@echo "hmmm"
	#@echo $(SOURCES)

# Compile: create object files from C source files.
#$(OBJDIR)/%.o
	#@echo
	#@echo "compiling..." $<
	#$(CC) -c $(ALL_CFLAGS) $< -o $@ 

$(BINDIR)/$(TARGET): $(OBJECTS)
	@echo 
	@echo "--- Linking $<"
	$(LINKER) $@ $(LFLAGS) $(OBJECTS)

$(OBJECTS): $(OBJDIR)/%.o : $(SRCDIR)/%.c
	@echo 
	@echo "--- Compiling $<"
	$(CC) $(strip $(CFLAGS) $(GENDEPFLAGS)) -c $< -o $@

.PHONEY: clean
clean:
	$(rm) $(OBJECTS)
	$(rm) $(BINDIR)/$(TARGET)
	@echo "Cleanup complete!"

