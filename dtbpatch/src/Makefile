
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

all: dtbpatch

dtbpatch: $(OBJS)
	$(LINKER) $(LDFLAGS) -o $@ $(OBJS) $(LIBS)

clean:
	$(RM) *.o dtbpatch

%.o: %.cpp
	$(CXX) $(CXXFLAGS) $(CXXDEFS) -c -o $@ $<
