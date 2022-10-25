
CP = cp
RM = rm -rf
MD = mkdir
CXX = g++
LINKER = $(CXX)

CXXFLAGS = -std=c++17 -Wno-unused-result
CXXDEFS =
LDFLAGS = 
LIBS = 

OBJS = main.o

all: powersched

powersched: $(OBJS)
	$(LINKER) $(LDFLAGS) -o $@ $(OBJS) $(LIBS)

clean:
	$(RM) *.o powersched

%.o: %.cpp
	$(CXX) $(CXXFLAGS) $(CXXDEFS) -c -o $@ $<
