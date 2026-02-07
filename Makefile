CC = i686-w64-mingw32-g++
CFLAGS = -shared -O2 -s -Wall -DWIN32_LEAN_AND_MEAN
LDFLAGS = -static -luser32 -lkernel32
TARGET = bin/AfkPreventer.dll

.PHONY: all clean

all: $(TARGET)

$(TARGET): dllmain.cpp
	@mkdir -p bin
	$(CC) $(CFLAGS) -o $@ dllmain.cpp $(LDFLAGS)
	@echo "Built: $@"

clean:
	rm -f $(TARGET)
