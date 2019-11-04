# Note: the next three lines are modified by the makefile-generator in xcow.x.
APP       = ii
LIBS      = xb.lib comdlg32.lib user32.lib comctl32.lib shell32.lib kernel32.lib freeimage.lib
START     =

!include <xbasic.mak>

# If the environment variable XBDIR is not defined in your autoexec.bat, remove the
# comment character (#) from the following line,

#XBDIR = 

# and set XBDIR equal to your root XBasic directory; eg.,  XBDIR = "\Program Files\XBasic"

# The following lines will cause resources to be added to the executable
# module, if an RC file or RBJ file exists with the same name as the APP.

# if name of RC/RBJ is different from APP, change the following line
RCNAME = $(APP)

RC     = $(RCNAME).rc
RBJ    = $(RCNAME).rbj

!if exist ($(RC))

RESOURCES = $(RBJ)
$(APP).exe: $(RBJ)
$(RBJ): $(RC)
  rc -i $(XBDIR)\images -r $(RC)
  cvtres -i386 $(RCNAME).res -o $(RBJ)

!elseif exist ($(RBJ))

RESOURCES = $(RBJ)

!endif

# add any other object modules here
MODULES = xstart.o $(APP).o

$(APP).exe: $(APP).o
	$(LD) $(LDFLAGS) -out:$(APP).exe $(MODULES) $(RESOURCES) $(LIBS) $(STDLIBS)

$(APP).o: $(APP).s

$(APP).s: $(APP).x
	$(START) xb $(APP).x
