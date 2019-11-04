''
' ####################
' #####  PROLOG  #####
' ####################
'
PROGRAM	"ISif"
VERSION	"0.3"			' actualy its more like 0.3.xx
'
' last updated [#date$] ~2003

' Michael McElligott
' Belfast, N.Ireland
'
' for more info on XBasic please vist www.xbasic.org
' and the user group at http://groups.yahoo.com/group/xbasic
'
'
	IMPORT	"xgr"
	IMPORT	"xst"
	IMPORT	"xui"
	IMPORT	"xma"					' SQRT()
	IMPORT	"comdlg32"		' ofnA
	IMPORT	"user32"			' MessageBoxA ()
'	IMPORT	"gdi32"
	IMPORT  "comctl32"		' comctl32.dll"
	IMPORT  "shell32"			' shell32.dll"
	IMPORT  "kernel32"		'	RtlMoveMemory ()
	IMPORT  "freeimage"

'	IMPORT "isif.dll"			' beta sif and ii file handling plus pixel manipulation rountines (akin to cfitsio)


$$ColourNumber=BITFIELD (8,0)
$$B=BITFIELD (8,8)
$$G=BITFIELD (8,16)
$$R=BITFIELD (8,24)

$$Xfi_Blur     = 1
$$Xfi_Brighten = 2
$$Xfi_Darken   = 3
$$Xfi_Flip     = 4
$$Xfi_Invert   = 5
$$Xfi_Mirror   = 6
$$Xfi_Greyscale= 7
$$Xfi_Quantize = 8
$$Xfi_Rotate   = 9

$$Xfi_BMP = 1
$$Xfi_PNG = 2
$$Xfi_TIF = 3
'$$Xfi_PBM = 4
'$$Xfi_PGM = 5
$$Xfi_PPM = 6
$$Xfi_JPEG = 7

$$maxScaleRange=6
$$MaxIconSize=4000
$$Sig=0
$$Ref=1
$$Bg=2
$$Liv=3
$$Src=4
$$user1=5
$$user2=6
$$user3=7
$$SifOriel$="Oriel Instruments Multi-Channel File"
$$SifAndor$="Andor Technology Multi-Channel File"

$$ImageTypeSIF=1
$$ImageTypeDAT=2
$$ImageTypeII=3


'  udisplay redraw flags

$$DrawEnableXUnit2d=	0x80000000
$$DrawEnableYUnit2d=	0x40000000
$$DrawDisableXUnit2d=	0x20000000
$$DrawDisableYUnit2d=	0x10000000
$$DrawImageFilename=	0x08000000
$$DrawXUnit2d=				0x04000000
$$DrawYUnit2d=				0x02000000
$$DrawPixelDataValue=	0x01000000
'$$DrawXLabel2d=			0x40000000
'$$DrawYLabel2d=			0x10000000
'$$DrawPixelXValue=		0x04000000
'$$DrawPixelYValue=		0x02000000
$$DrawSigBt1Sig=			0x00800000
$$DrawSigBt2Ref=			0x00400000
$$DrawSigBt3Bg=				0x00200000
$$DrawSigBt4Liv=			0x00100000
$$DrawSigBt5Src=			0x00080000
$$DrawSigBt6Usr1=			0x00040000
$$DrawSigBt7Usr2=			0x00020000
$$DrawSigBt8Usr8=			0x00010000
$$DrawVScrollBar=			0x00008000
$$DrawImageBorder=		0x00004000
$$DrawTrackMouse=			0x00002000
$$DrawImage=					0x00001000
$$DrawTrackA=					0x00000800
$$DrawTrackB=					0x00000400
$$DrawBorder2d=				0x00000200
$$DrawBorderImage=		0x00000100
$$DrawCursor2d=				0x00000080
$$DrawCursorImage=		0x00000040
$$DrawEnableVScroll=	0x00000020
$$DrawDisableVScroll=	0x00000010
$$DrawEnableCurTrack=	0x00000008
$$DrawDisableCurTrack=0x00000004
'$$Draw=	0x00000002D
'$$Draw=	0x00000001  ' all?

$$CM_ST_Disable = 1					' cmenuitem item status
$$CM_ST_Enable = 2
$$CM_ST_Delete = 3
$$CM_ST_Shade = 4				' non selectable - only valid with $$CM_TY_Select

$$CM_TY_Select =1				' cmenuitem item type
$$CM_TY_HSepA = 2
$$CM_TY_HSepB = 3
$$CM_TY_TopBrA =4
$$CM_TY_TopBrB =5
$$CM_TY_TopBrC= 6
$$CM_TY_BottomBrA =7
$$CM_TY_BottomBrB =8
$$CM_TY_BottomBrC =9
$$CM_TY_HSepC = 10
$$CM_TY_HSepD	= 11
$$CM_TY_HSepE = 12
$$CM_TY_Default = $$CM_TY_Select

$$CM_CT_TypeA=				0x00000001
$$CM_CT_TypeB=				0x00000002
$$CM_CT_Select=				0x00000004

$$CM_CT_Default=$$CM_CT_TypeA


$$CM_ID_QLoad =1  						' cmenuitem item id - used only as a callback identifier
$$CM_ID_OFileNext=2
$$CM_ID_OFileLast=3
$$CM_ID_SaveAs=4
$$CM_ID_Quit=5
$$CM_ID_ExpThisImage=6
$$CM_ID_ExpAllTrks=7
$$CM_ID_ExpAllTrksScaled=8
$$CM_ID_OFileNewSlot=9
$$CM_ID_OFileInSlot_1=10
$$CM_ID_OFileInSlot_2=11
$$CM_ID_OFileInSlot_3=12
$$CM_ID_OFileInSlot_4=13
$$CM_ID_OFileInSlot_5=14
$$CM_ID_OFileInSlot_6=15
$$CM_ID_OFileInSlot_7=16
$$CM_ID_DMode_Track=17
$$CM_ID_DMode_ImageA=18
$$CM_ID_DMode_ImageB=19
$$CM_ID_DMode_ImageC=20
$$CM_ID_Zoom_1=21
$$CM_ID_Zoom_2=22
$$CM_ID_Zoom_3=23
$$CM_ID_Zoom_4=24
$$CM_ID_Zoom_5=25
$$CM_ID_Zoom_6=26
$$CM_ID_Zoom_7=27
$$CM_ID_Zoom_8=28
$$CM_ID_Zoom_9=29
$$CM_ID_Zoom_10=30
$$CM_ID_Zoom_20=31
$$CM_ID_Zoom_50=32
$$CM_ID_MCur_CrossH=33
$$CM_ID_MCur_Cad=34
$$CM_ID_MCur_SWar=35
$$CM_ID_MCur_Vertical=36
$$CM_ID_PCur_CrossH=37
$$CM_ID_PCur_Cad=38
$$CM_ID_PCur_SWar=39
$$CM_ID_PCur_Vertical=40
$$CM_ID_WinMax=41
$$CM_ID_WinMin=42
$$CM_ID_WinLast=43
$$CM_ID_WinIcon=44
$$CM_ID_Scale_X=45
$$CM_ID_Scale_Y=46
$$CM_ID_Scale_All=47
$$CM_ID_Scale_Reset=48
$$CM_ID_Scale_Auto=49
$$CM_ID_SMode_MinMax=50
$$CM_ID_SMode_Min65=51
$$CM_ID_SMode_065=52
$$CM_ID_SMode_0Max=53
$$CM_ID_SMode_Custom=54
$$CM_ID_SMode_SetCustom=55
$$CM_ID_SMode_Image=56
$$CM_ID_ToolBar=57
$$CM_ID_Blem=58
$$CM_ID_TrackCur=59
$$CM_ID_Benchmark=60
$$CM_ID_VHeader=61
$$CM_ID_Help=62
$$CM_ID_About=63
$$CM_ID_MSelSlot=64
$$CM_ID_MDelSlot=65
$$CM_ID_SelSlot=10000
$$CM_ID_DelSlot=1000

TYPE CMENUITEM
		XLONG					.active
		STRING * 15 	.name
		XLONG					.nameLen
		XLONG					.parent
		XLONG					.callbackID
		XLONG					.kid
		XLONG					.type
		XLONG					.status
'		XLONG					.pixelW
		XLONG					.pixelH
		XLONG					.x
		XLONG					.y
		XLONG					.dx
		XLONG					.dy
END TYPE

TYPE CMENUPOS
		XLONG					.ctype
		XLONG					.iselect			' item tagged
		XLONG					.lastI
		XLONG					.active
		XLONG					.x
		XLONG					.y
		XLONG					.dx
		XLONG					.dy
		XLONG					.font			' font number as returned by Xbasic's 'CreateFont'
		XLONG					.basecolour
END TYPE


TYPE MemDataSet
		UBYTE				.active				' are we valid 1=yes 0=no
		XLONG				.Slot					' image index slot
		XLONG				.DataSet			' which (imageformat/#dataFile) dataset is ref'd to the imageindex/slot
		XLONG				.Size					' dataset size only - x*y*4
		XLONG				.ImageSetAd		' image set address (points to first pixel 1,1)
		STRING*14		.dsTitleS   	' dataset title short. for cMenu and program title
		STRING*255	.dsTitleL   	' dataset title long. file name
		XLONG				.cMenuNo			' where on the context menu are we placed
		UBYTE				.stDisplay		' 2d enabled 1=yes 0=no
		UBYTE				.stDisplayOL	'
		XLONG				.clr2d				'	ink
		XLONG				.currentImageBt 'last selected dataset
		XLONG				.Track				' current #Output track
		XLONG				.uTrack				' current udisplay track
		SINGLE			.MaxValue			'
		SINGLE			.MinValue			'
		SINGLE			.uMaxValue		'
		SINGLE			.uMinValue		'
		SINGLE			.Voffset			' temp Y 2d trk offset, used when in drag mode. set to 0 otherwise
		XLONG				.fPixel
		XLONG				.lPixel
		XLONG				.curPos				' selected pixel, -1 = disabled
		XLONG				.Grid
		XLONG				.imagebuffer
		XLONG				.Window
		XLONG				.WinX					' x pos - desktop
		XLONG				.WinY					' y pos - desktop
		XLONG				.WinW					'	width including border
		XLONG				.WinH					'	height including border
		XLONG 			.leftM				' margin
		XLONG 			.rightM				' margin
		XLONG 			.topM					' margin
		XLONG 			.bottomM			' margin
		XLONG				.edgeM				' margin
		SINGLE			.ImageW				' data image display area width
		SINGLE			.ImageH				' data image display area height
		XLONG				.enableVScroll
		XLONG				.enableXUnit
		XLONG				.enableYUnit
		XLONG				.enablePixDatVal
		XLONG				.trackCursor
END TYPE

TYPE TIMER
		DOUBLE		.Time
		DOUBLE		.Start
		DOUBLE		.End
'		ULONG			.Number
		UBYTE			.Status
END TYPE

TYPE argb
		UBYTE		.blue
		UBYTE		.green
		UBYTE		.red
END TYPE

TYPE iiheader
		SSHORT			.type
		SSHORT			.active
		STRING*4		.validity
		SSHORT			.version
		SSHORT			.H_type
		SSHORT			.H_unit
		SSHORT			.V_type
  	DOUBLE			.cal[3]
		SLONG				.t
		SSHORT			.year
		SSHORT			.d
		SSHORT			.diodes
		SSHORT			.first_diode
		SSHORT			.width_diode
		SLONG				.comp
		SSHORT			.store
		USHORT			.pp
		USHORT			.pn
		SLONG				.label
		SSHORT			.Z_type
		SSHORT			.Z_unit
		SSHORT			.mode
		SSHORT			.trigger
		SLONG				.trigger_level
		SSHORT			.sync
		SLONG				.exposure
		SLONG				.misc1
		SSHORT			.misc2
		SSHORT			.misc3
		SSHORT			.head
		SSHORT			.series_position
		SSHORT			.series_length
		STRING*80		.filename
		SSHORT			.temperature
		SSHORT			.v_start
		SSHORT			.v_bin
		SSHORT			.h_start
		SSHORT			.h_bin
		STRING*52		.spare
END TYPE

TYPE USERDISPLAY
		SBYTE				.active
		XLONG				.Slot
		XLONG				.Grid
		XLONG				.Window
		XLONG				.imagebuffer
		ULONG				.type					' display (trk,img..) mode/number 1.2.3...etc
		STRING*14 	.titleS
		STRING*255 	.titleL

		XLONG				.lpcallback		' address of callback function
		ULONG				.border				' should this gridwindow have a border? 0=none
		ULONG				.x						' x pos - desktop
		ULONG				.y						' y pos - desktop
		ULONG				.w						'	width
		ULONG				.h						'	height
		ULONG				.dx						'	x+w
		ULONG				.dy						'	y+h
		XLONG				.Wstate				'	window state
		ULONG				.lprefresh		' addres sof redraw/refresh function
		ULONG				.lpdrawgird		' address of function to fill gridwindow with contents
		ULONG				.icon
		ULONG				.backgroundclr
		ULONG				.drawingclr

END TYPE

TYPE icontype
		UBYTE 		.icon[$$MaxIconSize]	' the icon
		USHORT		.g					' grid to attach icon to
		STRING*20	.file				' filename of icon including path
		USHORT		.length			' icon file length, which must be <$$MaxIconSize
		UBYTE			.active 		' does it contain a valid dib image
END TYPE

TYPE cMenuPos
		SSHORT		.x
		SSHORT		.w
		SSHORT		.y
		SSHORT		.h
		SSHORT		.dx
		SSHORT		.dy
		SSHORT		.dyReal
		UBYTE			.item
		UBYTE			.olditem
		UBYTE			.status
		UBYTE			.side
END TYPE

TYPE windowcord
		SSHORT		.topLeftX
		SSHORT		.topLeftY
		SSHORT		.bottomRightX
		SSHORT		.bottomRightY
		UBYTE			.menu
		UBYTE			.status
END TYPE

TYPE BlemSpot						' beta Blackspot
		XLONG			.pixel
		XLONG			.track
		XLONG			.value
		XLONG			.total			' waste of memory
END TYPE

TYPE TEXT8
		STRING *9 .text
END TYPE

TYPE TrackData
		SINGLE 			.MaxPoint
		SINGLE 			.MinPoint
		SINGLE			.MaxPixel
		SINGLE			.MinPixel
		UBYTE				.valid
END TYPE

TYPE Image									' sif spec, cough
		STRING*40		.title
		STRING*5		.version[5]
		STRING*5		.type
		UBYTE				.active			' 1=header plus data follows. 0=inactive - no header nor data
		STRING*5		.activeB		' original active
		STRING*5		.structureVersion
		STRING*5		.timedate
		STRING*5		.temperature
		UBYTE				.head
		UBYTE				.storeType
		UBYTE				.dataType
		UBYTE				.mode
		UBYTE				.triggerSource
		STRING*5		.trigger_level
		STRING*5		.exposure_time
		STRING*5		.delay
		STRING*5		.integrationCycleTime
		STRING*5		.noIntegrations
		UBYTE				.sync
		STRING*10		.kineticCycleTime
		STRING*10		.pixelReadoutTime
		STRING*10		.noPoints
		STRING*10		.fastTrackHeight
		STRING*10		.gain
		STRING*10		.gateDelay
		STRING*10		.gateWidth
		STRING*10		.gateStep
		STRING*10		.trackHeight
		STRING*10		.seriesLenght		' typo
		UBYTE				.readPattern
		UBYTE				.shutterDelay
		STRING*10		.stCentreRow
		STRING*10		.mtOffset
		STRING*10		.operationMode
		STRING*10		.flipX
		STRING*10		.flipY
		STRING*10		.clock
		STRING*10		.aClock
		STRING*10		.Mcp
		STRING*10		.prop
		STRING*10		.ioc
		STRING*10		.freq
		STRING*20		.detectorModel
		STRING*10		.detectorFormatX
		STRING*10		.detectorFormatZ
		STRING*255	.filename
		UBYTE				.filenameLen
		STRING*255	.userText
		UBYTE				.userTextLen
		UBYTE				.shutterType
		UBYTE				.shutterMode
		UBYTE				.shutterCustomBgMode
		UBYTE				.shutterCustomMode
		STRING*10		.shutterClosingTime
		STRING*10		.shutterOpeningTime
		UBYTE				.xType
		UBYTE				.xUnit
		UBYTE				.yType
		UBYTE				.yUnit
		UBYTE				.zType
		UBYTE				.zUnit
		SINGLE			.xCal[3]
		SINGLE			.yCal[3]
		SINGLE			.zCal[3]
		STRING*10		.rayleighWavelength
		STRING*4		.pixelLenght
		STRING*4		.pixelHeight
		STRING*30		.xText
		STRING*30		.yText
		STRING*30		.zText
		ULONG				.left
		ULONG				.top
		ULONG				.right
		ULONG				.bottom
		USHORT			.hBin
		USHORT			.vBin
		ULONG				.numberOfImages
		ULONG				.numberOfSubImages
		ULONG				.totalLenght
		ULONG				.imageLenght
		XLONG				.NumberOfPixels
		XLONG				.NumberOfTracks
		ULONG				.dataStart
		ULONG				.headerStart
		STRING*4		.datatype
		ULONG				.totaldatasets
		ULONG				.firstdataset
		ULONG				.totalimages
		UBYTE				.ptype
		ULONG				.bLeft
		ULONG				.bRight
		ULONG				.ImageIndex
		SLONG				.fPixel
		SLONG				.lPixel
		STRING*255	.filen			'file name. as opened or last saved as
END TYPE

INTERNAL FUNCTION  Entry         ()
INTERNAL FUNCTION  InitGui       ()
INTERNAL FUNCTION  InitProgram   ()
INTERNAL FUNCTION  CreateWindows ()
INTERNAL FUNCTION  InitWindows   ()
INTERNAL FUNCTION  DrawImage		 ()
INTERNAL FUNCTION  ShowFields		 (set,Image dataset[])
INTERNAL FUNCTION  AutoScale		 (slot,track)
INTERNAL FUNCTION  AutoScaleAll  (slot)
INTERNAL FUNCTION  CalBlemish		 (left,right,top,bottom)
INTERNAL FUNCTION  CalBlemishSpec (left,right,top,bottom,SINGLE spec)
INTERNAL FUNCTION  CalBlemishDisplay ()
INTERNAL FUNCTION  GetBlemSpots	 (left,right,top,bottom, SINGLE spec)
EXPORT
	DECLARE FUNCTION  Blem (file$)
END EXPORT
INTERNAL FUNCTION  SetKidFields  (g)
INTERNAL FUNCTION  ResizeWindows ()
INTERNAL FUNCTION  ReadFile			 (file$,index,dataset)
INTERNAL FUNCTION  LoadFile			 (file$,index)
INTERNAL FUNCTION  ParseFitFile  ()
INTERNAL FUNCTION  ParseAscFile  ()
INTERNAL FUNCTION  ParseDatFile  (file$,Image dataset[],errorstate)
INTERNAL FUNCTION  ParseIIFile   (file$,Image dataset[],errorstate)
INTERNAL FUNCTION  ParseSifFile  (file$,Image dataset[],errorstate)
INTERNAL FUNCTION  SaveSifAsSif (file$)
INTERNAL FUNCTION  SaveRawAsSif (file$)
INTERNAL FUNCTION  SaveAsSif (file$)
INTERNAL FUNCTION  SaveAsRaw (file$)
INTERNAL FUNCTION  CreateSifHeader (sifheader$)
INTERNAL FUNCTION  ExtractFileTypeInfo (file$,index)
INTERNAL FUNCTION  GetString		 (after,string$,term)
INTERNAL FUNCTION  GetNumber (after,a!)
INTERNAL FUNCTION  GetNumberB (after)
INTERNAL FUNCTION  GetStringB (after,string$,len)
INTERNAL FUNCTION  FindMoreDataFiles(file$)
INTERNAL FUNCTION  InitVariables ()
INTERNAL FUNCTION  DrawInfo			 ()
INTERNAL FUNCTION  ResponseBox   (grid, message, v0, v1, v2, v3, r0, ANY)
INTERNAL FUNCTION  ResponseBoxCode(grid,message, v0, v1, v2, v3, kid,ANY)
INTERNAL FUNCTION  CEOcontrol		 (grid, message, v0, v1, v2, v3, kid,ANY)
INTERNAL FUNCTION  Output        (grid, message, v0, v1, v2, v3, r0, ANY)
INTERNAL FUNCTION  OutputCode    (grid, message, v0, v1, v2, v3, kid,ANY)
INTERNAL FUNCTION  Message       (grid, message, v0, v1, v2, v3, r0, ANY)
INTERNAL FUNCTION  MessageCode   (grid, message, v0, v1, v2, v3, kid,ANY)
INTERNAL FUNCTION  Tools         (grid, message, v0, v1, v2, v3, r0, ANY)
INTERNAL FUNCTION  ToolsCode     (grid, message, v0, v1, v2, v3, r0, ANY)
INTERNAL FUNCTION  FileList      (grid, message, v0, v1, v2, v3, r0, ANY)
INTERNAL FUNCTION  FileListCode  (grid, message, v0, v1, v2, v3, kid,ANY)
INTERNAL FUNCTION  IconWindow    (grid, message, v0, v1, v2, v3, r0, ANY)
INTERNAL FUNCTION  IconWindowCode(grid, message, v0, v1, v2, v3, kid,ANY)
INTERNAL FUNCTION  About         (grid, message, v0, v1, v2, v3, r0, ANY)
INTERNAL FUNCTION  AboutCode     (grid, message, v0, v1, v2, v3, kid,ANY)
INTERNAL FUNCTION  Axis          (grid, message, v0, v1, v2, v3, r0, ANY)
INTERNAL FUNCTION  AxisCode      (grid, message, v0, v1, v2, v3, kid,ANY)
INTERNAL FUNCTION  Goto          (grid, message, v0, v1, v2, v3, r0, ANY)
INTERNAL FUNCTION  GotoCode      (grid, message, v0, v1, v2, v3, kid,ANY)
INTERNAL FUNCTION  SetPixel      (grid, message, v0, v1, v2, v3, r0, ANY)
INTERNAL FUNCTION  SetPixelCode  (grid, message, v0, v1, v2, v3, kid,ANY)
INTERNAL FUNCTION  GetRawInfo    (grid, message, v0, v1, v2, v3, r0, ANY)
INTERNAL FUNCTION  GetRawInfoCode(grid, message, v0, v1, v2, v3, kid,ANY)
INTERNAL FUNCTION  ModScaleMax   (grid, message, v0, v1, v2, v3, r0, ANY)
INTERNAL FUNCTION  ModScaleMaxCode(grid,message, v0, v1, v2, v3, kid,ANY)
INTERNAL FUNCTION  ModScaleMin   (grid, message, v0, v1, v2, v3, r0, ANY)
INTERNAL FUNCTION  ModScaleMinCode(grid,message, v0, v1, v2, v3, kid,ANY)
INTERNAL FUNCTION  AddTraceW     (grid, message, v0, v1, v2, v3, r0, ANY)
INTERNAL FUNCTION  AddTraceWCode (grid, message, v0, v1, v2, v3, kid,ANY)
INTERNAL FUNCTION  LevelIndicator(grid, message, v0, v1, v2, v3, r0, ANY)
INTERNAL FUNCTION  LevelIndicatorCode(grid, message, v0, v1, v2, v3, kid, ANY)
INTERNAL FUNCTION  CreateMemoryBuffers ()
INTERNAL FUNCTION  OpenMainDispWin ()
INTERNAL FUNCTION  PopUpBox		(title$,text$,yes$,no$,action)
INTERNAL FUNCTION  PopUpBoxB  (text$,title$,option)
INTERNAL FUNCTION  DisplayTrack	 (Track,totk)
INTERNAL FUNCTION  XgrCreateFields		 (g,kid, name$,help$,hint$,grid)
INTERNAL FUNCTION  DataTrackImageCheck ()
INTERNAL FUNCTION  SwitchToImage			 ()
INTERNAL FUNCTION  ShowButtonMenu 		(time)
INTERNAL FUNCTION  HideButtonMenu 		(time)
INTERNAL FUNCTION  BuffMenuBotton 		()
INTERNAL FUNCTION  ConvertColorToWinCV (color, winCV)
INTERNAL FUNCTION  SpeedTest 					()
INTERNAL FUNCTION  SelectFileMenu  		(state,index)
INTERNAL FUNCTION  InitNonStandalone   (os)
INTERNAL FUNCTION  ClearHcoverField ()
INTERNAL FUNCTION  DrawXinfo ()
INTERNAL FUNCTION  DOUBLE Round (DOUBLE number, power)
INTERNAL FUNCTION  ReadNextFile ()
INTERNAL FUNCTION  ReadLastFile ()
INTERNAL FUNCTION  SetColourTheme (theme)
INTERNAL FUNCTION  RedrawAllWindows ()
INTERNAL FUNCTION  Prints (text$,line)
INTERNAL FUNCTION  sPrint (text$)
INTERNAL FUNCTION  isInMenu (menu,x,y)
INTERNAL FUNCTION  cMenuClear (menu)
INTERNAL FUNCTION  cMenuClearAll ()
INTERNAL FUNCTION  cMenuSelection (v0,v1)
INTERNAL FUNCTION  DrawContextMenu (x,y,w,h,menu,ANY,cSubHighlight)
INTERNAL FUNCTION  selectMenuArray ()
INTERNAL FUNCTION  InitContextMenuArrays ()
INTERNAL FUNCTION  selectMenu3Array ()
INTERNAL FUNCTION  setMenuStatus (r1,v0,v1)
INTERNAL FUNCTION  DrawSignalButtons ()
INTERNAL FUNCTION  DrawToolsBorder ()
INTERNAL FUNCTION  SaveAllTracksAsBMP (filen$,scaled)
INTERNAL FUNCTION  LoadIcons (file$)
INTERNAL FUNCTION  RedrawIcon (pos)
INTERNAL FUNCTION  SetProgramTitle (fil$)
INTERNAL FUNCTION  XfiSaveImage (fileName$, UBYTE image[], type, fileNameExt$)
INTERNAL FUNCTION  GetDIBImage (track)
INTERNAL FUNCTION  SaveAllToType (filen$,type,mode)
INTERNAL FUNCTION  SetLevelIndicator (title$,label$ ,min, max, pos)
INTERNAL FUNCTION  InitStandalone ()
INTERNAL FUNCTION  InitDisplay ()
INTERNAL FUNCTION  InitDisplay2dH ()
INTERNAL FUNCTION  InitDisplayImage ()
INTERNAL FUNCTION  PlaceToolbar ()
INTERNAL FUNCTION  isInGrid (grid,r1,x,y)
INTERNAL FUNCTION  ResizeImageBuffGrids ()
INTERNAL FUNCTION  ColourBar (min,max)
INTERNAL FUNCTION  SnapToImage ()
INTERNAL FUNCTION  CreateColourTable ()
INTERNAL FUNCTION  ColourBarLabel (max)
INTERNAL FUNCTION  GetMaxVvalue ()
INTERNAL FUNCTION  CreateDib24Header (w,h,len,UBYTE image[])
INTERNAL FUNCTION  SwitchToTrack ()
INTERNAL FUNCTION  CloseConsole ()
INTERNAL FUNCTION  OpenConsole ()
INTERNAL FUNCTION  error (text$)
INTERNAL FUNCTION  checkMaxVvalue (text$)
INTERNAL FUNCTION  ScaleRange ()
INTERNAL FUNCTION  GetNumberASC (@after,term)
INTERNAL FUNCTION  scanHeader ()
INTERNAL FUNCTION  OpenFilefn (file$,fn2)
INTERNAL FUNCTION  CloseFilefn (fn)
INTERNAL FUNCTION  LabeldSet ()
INTERNAL FUNCTION  setSigBtLabels ()
INTERNAL FUNCTION  disableUnusedBts ()
INTERNAL FUNCTION  KeyPressed (button$)
INTERNAL FUNCTION  NextCTheme ()
INTERNAL FUNCTION  NextCMtype ()
INTERNAL FUNCTION  InitNewCMenu (v0,v1)
INTERNAL FUNCTION  zoomXtrack (zoomXtrack)
INTERNAL FUNCTION  zoomdeXtrack (zoomXtrack)
INTERNAL FUNCTION  DrawImageSelected (x1,x0,y0,y1)
INTERNAL FUNCTION  DOUBLE StartTimer (timer, DOUBLE time)
INTERNAL FUNCTION  DOUBLE CheckTimer (timer, DOUBLE time)
INTERNAL FUNCTION  DOUBLE EndTimer 	(timer, DOUBLE time)
INTERNAL FUNCTION  KillAllTimers ()
INTERNAL FUNCTION  DestroyAllGrids ()
INTERNAL FUNCTION  DestroyAllArrarys ()
INTERNAL FUNCTION  DestroyAllFonts ()
INTERNAL FUNCTION  Quit ()
INTERNAL FUNCTION  SINGLE getMaxVy (slot,v1)
INTERNAL FUNCTION  setTrackVoffset (slot)
INTERNAL FUNCTION  dragColourBar (v0,v1)
INTERNAL FUNCTION  drag2dTrack (v0,v1)
INTERNAL FUNCTION  dragImageSelector (v0,v1)
INTERNAL FUNCTION  drag2dAreaSelector (v0,v1)
INTERNAL FUNCTION  drawImageBorder (colour)
INTERNAL FUNCTION  dragWindow ()
INTERNAL FUNCTION  WindowDragUp ()
INTERNAL FUNCTION  MouseControl (message,v0,v1,v2,v3,r1)
INTERNAL FUNCTION  MouseDown  (v0, v1, v2, v3)
INTERNAL FUNCTION  MouseDrag (v0,v1)
INTERNAL FUNCTION  MouseExit ()
INTERNAL FUNCTION  MouseEnter ()
INTERNAL FUNCTION  MouseWheel (v3)
INTERNAL FUNCTION  MouseDownRight (v0,v1,kid)
INTERNAL FUNCTION  MouseUp ()
INTERNAL FUNCTION  MouseMove (v0, v1, v2, v3)
INTERNAL FUNCTION  MaxScreen ()
INTERNAL FUNCTION  MinScreen (state)
INTERNAL FUNCTION  DrawOutputBorders ()
INTERNAL FUNCTION  GetNextDataSet ()
INTERNAL FUNCTION  ContextSelect ()
INTERNAL FUNCTION  ToolMenuState ()
INTERNAL FUNCTION  ResetScale ()
INTERNAL FUNCTION  SwitchDisplayMode ()
INTERNAL FUNCTION  DrawPCursor (v0,v1)
INTERNAL FUNCTION  ErasePCursor ()
INTERNAL FUNCTION  Redraw (window,kid,v0,v1,v2,v3)
INTERNAL FUNCTION  KeyDown (v0,v1,v2)
INTERNAL FUNCTION  ScaleToAllTracks ()
INTERNAL FUNCTION  CentreWindow (window)
INTERNAL FUNCTION  LineTypeSelect2d ()
INTERNAL FUNCTION  CursorTypeSelect ()
INTERNAL FUNCTION  NextScalingRange ()
INTERNAL FUNCTION  vScaleDown ()
INTERNAL FUNCTION  vScaleUp ()
INTERNAL FUNCTION  zoomOUTi ()
INTERNAL FUNCTION  zoomINi ()
INTERNAL FUNCTION  clearImageBorder (w,h)
INTERNAL FUNCTION  setfileBThints ()
INTERNAL FUNCTION  clearSigBTarea ()
INTERNAL FUNCTION  PlayKf ()
INTERNAL FUNCTION  PlayKb ()
INTERNAL FUNCTION  NextKi ()
INTERNAL FUNCTION  BackKi ()
INTERNAL FUNCTION  decreaseMaxScaleRange ()
INTERNAL FUNCTION  increaseMaxScaleRange ()
INTERNAL FUNCTION  decreaseMinScaleRange ()
INTERNAL FUNCTION  increaseMinScaleRange ()
INTERNAL FUNCTION  imageFix ()
INTERNAL FUNCTION  downTrk ()
INTERNAL FUNCTION  upTrk ()
INTERNAL FUNCTION  pixelLeft ()
INTERNAL FUNCTION  pixelRight ()
INTERNAL FUNCTION  nextColTable ()
INTERNAL FUNCTION  DisplayScaledTrk ()
INTERNAL FUNCTION  vScrollChange (slot,v1,v3,lock)
INTERNAL FUNCTION  downTenTracks ()
INTERNAL FUNCTION  upTenTracks ()
INTERNAL FUNCTION  fileErrorHandle (file$,error)
INTERNAL FUNCTION  CycleOPWindowState ()
INTERNAL FUNCTION  vColBar (time)
INTERNAL FUNCTION  vColBarState ()
INTERNAL FUNCTION  setvColBar ()
INTERNAL FUNCTION  tWakeUp ()
INTERNAL FUNCTION  GetPixelAddress	(index,x,y)
INTERNAL FUNCTION  GetPixelValue		(imageindex,x,y, SINGLE value)
INTERNAL FUNCTION  SetPixelValue		(imageindex,x,y, SINGLE value)
INTERNAL FUNCTION  GetPixelValueB		(slot, pixel ,SINGLE value)
INTERNAL FUNCTION  SetPixelValueB		(slot, pixel ,SINGLE value)
INTERNAL FUNCTION  GetPixelAddressB (slot, pixel, address)
INTERNAL FUNCTION  SINGLE GetMaxPointTrack (imageindex,track,pixel)
INTERNAL FUNCTION  SINGLE GetMinPointTrack (imageindex,track,pixel)
INTERNAL FUNCTION  SINGLE GetMaxPointImage (imageindex,track,pixel)
INTERNAL FUNCTION  SINGLE GetMinPointImage (imageindex,track,pixel)
INTERNAL FUNCTION  SINGLE GetIniValue (group$,vname$,value$)
INTERNAL FUNCTION  GetMaxTrack (imageindex)
INTERNAL FUNCTION  GetMinTrack (imageindex)
INTERNAL FUNCTION  GotoPixel2d (x,y)
INTERNAL FUNCTION  removeTab (window,kid)
INTERNAL FUNCTION  GetGridNumber (window,kid)
INTERNAL FUNCTION  SetFocusOnGrid (grid)
INTERNAL FUNCTION  SetFocusOnKid (window,kid)
INTERNAL FUNCTION  DisplayWindow (window)
INTERNAL FUNCTION  HideWindow (window)
INTERNAL FUNCTION  GetNewImage (togrid,buff,display,updatexy)
INTERNAL FUNCTION  AddToOpenedFileList (file$)
INTERNAL FUNCTION  dImageTitle ()
INTERNAL FUNCTION  ParseCommandLineA (file$,cmd$)
INTERNAL FUNCTION  setDefaultPixRange (slot)
INTERNAL FUNCTION  unitest ()
INTERNAL FUNCTION  WinOpenFile (window, filename$, filter$)
INTERNAL FUNCTION  WinSaveFile (window,title$, filename$, filter$,filterIndex)
INTERNAL FUNCTION  MessageTimer (timer, count, msec, time)
INTERNAL FUNCTION  DrawImageRange (first,last,bottom,top)
INTERNAL FUNCTION  SaveFileAs (unused)
INTERNAL FUNCTION  ExportFileAs (mode)
INTERNAL FUNCTION  clearImageSetSlot (slot)
INTERNAL FUNCTION  AddDataSetToSlot (slot,dataset)
INTERNAL FUNCTION  CreateDataSlot (unused,unused2)
INTERNAL FUNCTION  CreateDataSlotAt (slot)
INTERNAL FUNCTION  addimage_test ()
INTERNAL FUNCTION  GetFileA (file$,iflag,dataset)
INTERNAL FUNCTION  DeleteDataSet (slot)
INTERNAL FUNCTION  CreateNewDSetAndSlot (x,y)
INTERNAL FUNCTION  GetDataSlotSize (slot,x,y)
INTERNAL FUNCTION  CopyDataSet (SourceSlot)
INTERNAL FUNCTION  SetImageIndex (index)
INTERNAL FUNCTION  resizeimage_test ()
INTERNAL FUNCTION  ResizeDataSet 		(slot,x,y,size,align)
INTERNAL FUNCTION  SetDataSetTitle	(slot,short$,long$)
INTERNAL FUNCTION  GetDataSetTitle	(slot,short$,long$)
INTERNAL FUNCTION  SetCurrentDataSet (slot)
INTERNAL FUNCTION  GetFirstValidDataSet (excludethisset)
INTERNAL FUNCTION  copydataset_test ()
INTERNAL FUNCTION  UpdateDataSlotMenu ()
INTERNAL FUNCTION  RotateImage (slot,flag)
INTERNAL FUNCTION  ClearPixelArea (slot,SINGLE value,x1,x2,y1,y2)
INTERNAL FUNCTION  IsImageSlotValid (slot)
INTERNAL FUNCTION  addimages_test ()
INTERNAL FUNCTION  CloseDataSet (slot)
INTERNAL FUNCTION  MoveDataSetTo (from,to)
INTERNAL FUNCTION  movedataset_test ()
INTERNAL FUNCTION  DisplayTracks (list)
INTERNAL FUNCTION  DrawTrack (grid,slot,ink,track,first,last,SINGLE top, SINGLE bottom,rescale)
INTERNAL FUNCTION  drawCursor (grid,colour,x,y,style)
INTERNAL FUNCTION  Update (flag)
INTERNAL FUNCTION  GetWindowState (window)
INTERNAL FUNCTION  ScaleAllTracksCalc (slot)
INTERNAL FUNCTION  resetMemDataSet (slot)
INTERNAL FUNCTION  AddTraceToWindow (slot,ink)
INTERNAL FUNCTION  RemoveTraceFromWindow (slot)
INTERNAL FUNCTION  DestroyPWindow (grid)
INTERNAL FUNCTION  openUD_test ()
INTERNAL FUNCTION  uDisplayGetSlot (grid,gridtype)
INTERNAL FUNCTION  uDisplayCreateWindow (slot,x,y,w,h,flag,type)
INTERNAL FUNCTION  uDisplayDrawTrackA (unused,slot,track,flag)
INTERNAL FUNCTION  uDisplayDrawTrackB (slot,x0,y0,x1,y1)
INTERNAL FUNCTION  uDisplayGetBuffer (grid,gridtype)
INTERNAL FUNCTION  uDisplayShowWindow (slot,flag)
INTERNAL FUNCTION  uDisplayHideWindow (slot)
INTERNAL FUNCTION  uDisplayResizeWindow (unused,slot,x,y,w,h)
INTERNAL FUNCTION  uDisplaySetSize (slot,w,h)
INTERNAL FUNCTION  uDisplaySetPosition (slot,x,y)
INTERNAL FUNCTION  uDisplayGetSize (slot,w,h)
INTERNAL FUNCTION  uDisplayGetPosition (slot,x,y)
INTERNAL FUNCTION  uDisplayDrag2d (slot,x,y)
INTERNAL FUNCTION  uDisplayResetScale (slot)
INTERNAL FUNCTION  uDisplayCB (grid, message, v0, v1, v2, v3, kid, ANY)
INTERNAL FUNCTION  uDisplayUpdate (slot,flag,v0,v1,v2,v3)
INTERNAL FUNCTION  uDisplayScaleTrack (slot,track)
INTERNAL FUNCTION  cMenuCreate (menu,type)
INTERNAL FUNCTION  cMenuAddItem (menu,row,cstring,parent,kid,callbackID)
INTERNAL FUNCTION  cMenuGetItem (menu,item)
INTERNAL FUNCTION  cMenuGetMaxItems (menu)
INTERNAL FUNCTION  cMenuSetItemPosition (menu,pos,x,y,dx,dy)
INTERNAL FUNCTION  cMenuGetItemParent (menu,item,parent)
INTERNAL FUNCTION  cMenuGetSubMenu (menu,item,sub)
INTERNAL FUNCTION  cMenuClearFrom (menu)
INTERNAL FUNCTION  cMenuDraw (menu,x,y,selectrow)
INTERNAL FUNCTION  cMenuGetID (menu,item,id)
INTERNAL FUNCTION  cMenuisInMenu (menu,x,y)
INTERNAL FUNCTION  cMenuisInItem (menu,item,x,y)
INTERNAL FUNCTION  cMenuSelectionCB (menu,item,callbackID)
INTERNAL FUNCTION  cMenuClearSubs (menu,item)
INTERNAL FUNCTION  cMenuSetItemNoSelect (menu,item)
INTERNAL FUNCTION  cMenuDisableItem (menu,item)
INTERNAL FUNCTION  cMenuEnableItem (menu,item)
INTERNAL FUNCTION  cMenuSetItemSelected (menu,item)
'
'
' ######################
' #####  Entry ()  #####
' ######################
'
FUNCTION Entry ()
	SHARED  terminateProgram
	STATIC	entry

	IF entry THEN RETURN					' enter once
	entry =  $$TRUE								' enter occured
	#IsLib=LIBRARY (0)

	IF #IsLib THEN
				InitGui ()										' initialize messages
				CloseConsole()
				InitProgram ()								' initialize this program
				RETURN
	ELSE
				InitGui ()										' initialize messages
				InitProgram ()								' initialize this program
				CreateWindows ()							' create main window and others
				InitWindows ()								' fire up any windows/grid related variables
				XgrSetCEO (&CEOcontrol())			' capture mouse/keyboard events to..
				FreeImage_EnableMMX ()				' i hope we're using an mmx enabled cpu
				InitStandalone ()
	END IF

	DO

			XgrProcessMessages (1)
	'		XgrPeekMessage   (@grid, @message, @v0, @v1, @v2, @v3, @kid, @r1)

	LOOP UNTIL terminateProgram



END FUNCTION
'
'
' ########################
' #####  InitGui ()  #####
' ########################
'
FUNCTION  InitGui ()
'
	program$ = "ISif"  ' PROGRAM$(0)
	XstSetProgramName (@program$)
'
' ***************************************
' *****  Register Standard Cursors  *****
' ***************************************
'
	XgrRegisterCursor (@"default",      @#cursorDefault)
	XgrRegisterCursor (@"arrow",        @#cursorArrow)
	XgrRegisterCursor (@"n",            @#cursorN)
	XgrRegisterCursor (@"s",            @#cursorS)
	XgrRegisterCursor (@"e",            @#cursorE)
	XgrRegisterCursor (@"w",            @#cursorW)
	XgrRegisterCursor (@"ns",           @#cursorArrowsNS)
	XgrRegisterCursor (@"ns",           @#cursorArrowsSN)
	XgrRegisterCursor (@"ew",           @#cursorArrowsEW)
	XgrRegisterCursor (@"ew",           @#cursorArrowsWE)
	XgrRegisterCursor (@"nwse",         @#cursorArrowsNWSE)
	XgrRegisterCursor (@"nesw",         @#cursorArrowsNESW)
	XgrRegisterCursor (@"all",          @#cursorArrowsAll)
	XgrRegisterCursor (@"plus",         @#cursorPlus)
	XgrRegisterCursor (@"wait",         @#cursorWait)
	XgrRegisterCursor (@"insert",       @#cursorInsert)
	XgrRegisterCursor (@"crosshair",    @#cursorCrosshair)
	XgrRegisterCursor (@"hourglass",    @#cursorHourglass)
	XgrRegisterCursor (@"hand",         @#cursorHand)
	XgrRegisterCursor (@"help",         @#cursorHelp)
	XgrRegisterCursor (@"none",         @#cursorNone)

	XgrRegisterCursor (@"mycross",      @#mycross)
	XgrRegisterCursor (@"rightangle",   @#rightangle)
	XgrRegisterCursor (@"myhand",       @#myHand)
'
	#defaultCursor = #cursorDefault
'
'
' ********************************************
' *****  Register Standard Window Icons  *****
' ********************************************
'
	XgrRegisterIcon (@"hand",					@#iconHand)
	XgrRegisterIcon (@"asterisk",			@#iconAsterisk)
	XgrRegisterIcon (@"question",			@#iconQuestion)
	XgrRegisterIcon (@"exclamation",	@#iconExclamation)
	XgrRegisterIcon (@"application",	@#iconApplication)
'
	XgrRegisterIcon (@"hand",					@#iconStop)						' alias
	XgrRegisterIcon (@"asterisk",			@#iconInformation)		' alias
	XgrRegisterIcon (@"application",  @#iconBlank)					' alias
'
	XgrRegisterIcon (@"window",				@#iconWindow)					' custom
'	XgrRegisterIcon (@"rightarrow",		@#rightarrow)

'
'
' ******************************
' *****  Register Messages *****  Create message numbers for message names
' ******************************
'
	XgrRegisterMessage (@"Blowback",										@#Blowback)
	XgrRegisterMessage (@"Callback",										@#Callback)
	XgrRegisterMessage (@"Cancel",@#Cancel)
	XgrRegisterMessage (@"Change",											@#Change)
	XgrRegisterMessage (@"CloseWindow",									@#CloseWindow)
	XgrRegisterMessage (@"ContextChange",								@#ContextChange)
	XgrRegisterMessage (@"Create",											@#Create)
	XgrRegisterMessage (@"CreateValueArray",						@#CreateValueArray)
	XgrRegisterMessage (@"CreateWindow",								@#CreateWindow)
	XgrRegisterMessage (@"CursorH",											@#CursorH)
	XgrRegisterMessage (@"CursorV",											@#CursorV)
	XgrRegisterMessage (@"Deselected",									@#Deselected)
	XgrRegisterMessage (@"Destroy",											@#Destroy)
	XgrRegisterMessage (@"Destroyed",										@#Destroyed)
	XgrRegisterMessage (@"DestroyWindow",								@#DestroyWindow)
	XgrRegisterMessage (@"Disable",											@#Disable)
	XgrRegisterMessage (@"Disabled",										@#Disabled)
	XgrRegisterMessage (@"Displayed",										@#Displayed)
	XgrRegisterMessage (@"DisplayWindow",								@#DisplayWindow)
	XgrRegisterMessage (@"Enable",											@#Enable)
	XgrRegisterMessage (@"Enabled",											@#Enabled)
	XgrRegisterMessage (@"Enter",												@#Enter)
	XgrRegisterMessage (@"ExitMessageLoop",							@#ExitMessageLoop)
	XgrRegisterMessage (@"Find",												@#Find)
	XgrRegisterMessage (@"FindForward",									@#FindForward)
	XgrRegisterMessage (@"FindReverse",									@#FindReverse)
	XgrRegisterMessage (@"Forward",											@#Forward)
	XgrRegisterMessage (@"GetAlign",										@#GetAlign)
	XgrRegisterMessage (@"GetBorder",										@#GetBorder)
	XgrRegisterMessage (@"GetBorderOffset",							@#GetBorderOffset)
	XgrRegisterMessage (@"GetCallback",									@#GetCallback)
	XgrRegisterMessage (@"GetCallbackArgs",							@#GetCallbackArgs)
	XgrRegisterMessage (@"GetCan",											@#GetCan)
	XgrRegisterMessage (@"GetCharacterMapArray",				@#GetCharacterMapArray)
	XgrRegisterMessage (@"GetCharacterMapEntry",				@#GetCharacterMapEntry)
	XgrRegisterMessage (@"GetClipGrid",									@#GetClipGrid)
	XgrRegisterMessage (@"GetColor",										@#GetColor)
	XgrRegisterMessage (@"GetColorExtra",								@#GetColorExtra)
	XgrRegisterMessage (@"GetCursor",										@#GetCursor)
	XgrRegisterMessage (@"GetCursorXY",									@#GetCursorXY)
	XgrRegisterMessage (@"GetDisplay",									@#GetDisplay)
	XgrRegisterMessage (@"GetEnclosedGrids",						@#GetEnclosedGrids)
	XgrRegisterMessage (@"GetEnclosingGrid",						@#GetEnclosingGrid)
	XgrRegisterMessage (@"GetFocusColor",								@#GetFocusColor)
	XgrRegisterMessage (@"GetFocusColorExtra",					@#GetFocusColorExtra)
	XgrRegisterMessage (@"GetFont",											@#GetFont)
	XgrRegisterMessage (@"GetFontMetrics",							@#GetFontMetrics)
	XgrRegisterMessage (@"GetFontNumber",								@#GetFontNumber)
	XgrRegisterMessage (@"GetGridFunction",							@#GetGridFunction)
	XgrRegisterMessage (@"GetGridFunctionName",					@#GetGridFunctionName)
	XgrRegisterMessage (@"GetGridName",									@#GetGridName)
	XgrRegisterMessage (@"GetGridNumber",								@#GetGridNumber)
	XgrRegisterMessage (@"GetGridProperties",						@#GetGridProperties)
	XgrRegisterMessage (@"GetGridType",									@#GetGridType)
	XgrRegisterMessage (@"GetGridTypeName",							@#GetGridTypeName)
	XgrRegisterMessage (@"GetGroup",										@#GetGroup)
	XgrRegisterMessage (@"GetHelp",											@#GetHelp)
	XgrRegisterMessage (@"GetHelpFile",									@#GetHelpFile)
	XgrRegisterMessage (@"GetHelpString",								@#GetHelpString)
	XgrRegisterMessage (@"GetHelpStrings",							@#GetHelpStrings)
	XgrRegisterMessage (@"GetHintString",								@#GetHintString)
	XgrRegisterMessage (@"GetImage",										@#GetImage)
	XgrRegisterMessage (@"GetImageCoords",							@#GetImageCoords)
	XgrRegisterMessage (@"GetIndent",										@#GetIndent)
	XgrRegisterMessage (@"GetInfo",											@#GetInfo)
	XgrRegisterMessage (@"GetJustify",									@#GetJustify)
	XgrRegisterMessage (@"GetKeyboardFocus",						@#GetKeyboardFocus)
	XgrRegisterMessage (@"GetKeyboardFocusGrid",				@#GetKeyboardFocusGrid)
	XgrRegisterMessage (@"GetKidArray",									@#GetKidArray)
	XgrRegisterMessage (@"GetKidNumber",								@#GetKidNumber)
	XgrRegisterMessage (@"GetKids",											@#GetKids)
	XgrRegisterMessage (@"GetKind",											@#GetKind)
	XgrRegisterMessage (@"GetMaxMinSize",								@#GetMaxMinSize)
	XgrRegisterMessage (@"GetMenuEntryArray",						@#GetMenuEntryArray)
	XgrRegisterMessage (@"GetMessageFunc",							@#GetMessageFunc)
	XgrRegisterMessage (@"GetMessageFuncArray",					@#GetMessageFuncArray)
	XgrRegisterMessage (@"GetMessageSub",								@#GetMessageSub)
	XgrRegisterMessage (@"GetMessageSubArray",					@#GetMessageSubArray)
	XgrRegisterMessage (@"GetModalInfo",								@#GetModalInfo)
	XgrRegisterMessage (@"GetModalWindow",							@#GetModalWindow)
	XgrRegisterMessage (@"GetParent",										@#GetParent)
	XgrRegisterMessage (@"GetPosition",									@#GetPosition)
	XgrRegisterMessage (@"GetProtoInfo",								@#GetProtoInfo)
	XgrRegisterMessage (@"GetRedrawFlags",							@#GetRedrawFlags)
	XgrRegisterMessage (@"GetSize",											@#GetSize)
	XgrRegisterMessage (@"GetSmallestSize",							@#GetSmallestSize)
	XgrRegisterMessage (@"GetState",										@#GetState)
	XgrRegisterMessage (@"GetStyle",										@#GetStyle)
	XgrRegisterMessage (@"GetTabArray",									@#GetTabArray)
	XgrRegisterMessage (@"GetTabWidth",									@#GetTabWidth)
	XgrRegisterMessage (@"GetTextArray",								@#GetTextArray)
	XgrRegisterMessage (@"GetTextArrayBounds",					@#GetTextArrayBounds)
	XgrRegisterMessage (@"GetTextArrayLine",						@#GetTextArrayLine)
	XgrRegisterMessage (@"GetTextArrayLines",						@#GetTextArrayLines)
	XgrRegisterMessage (@"GetTextCursor",								@#GetTextCursor)
	XgrRegisterMessage (@"GetTextFilename",							@#GetTextFilename)
	XgrRegisterMessage (@"GetTextPosition",							@#GetTextPosition)
	XgrRegisterMessage (@"GetTextSelection",						@#GetTextSelection)
	XgrRegisterMessage (@"GetTextSpacing",							@#GetTextSpacing)
	XgrRegisterMessage (@"GetTextString",								@#GetTextString)
	XgrRegisterMessage (@"GetTextStrings",							@#GetTextStrings)
	XgrRegisterMessage (@"GetTexture",									@#GetTexture)
	XgrRegisterMessage (@"GetTimer",										@#GetTimer)
	XgrRegisterMessage (@"GetValue",										@#GetValue)
	XgrRegisterMessage (@"GetValueArray",								@#GetValueArray)
	XgrRegisterMessage (@"GetValues",										@#GetValues)
	XgrRegisterMessage (@"GetWindow",										@#GetWindow)
	XgrRegisterMessage (@"GetWindowFunction",						@#GetWindowFunction)
	XgrRegisterMessage (@"GetWindowGrid",								@#GetWindowGrid)
	XgrRegisterMessage (@"GetWindowIcon",								@#GetWindowIcon)
	XgrRegisterMessage (@"GetWindowSize",								@#GetWindowSize)
	XgrRegisterMessage (@"GetWindowTitle",							@#GetWindowTitle)
	XgrRegisterMessage (@"GotKeyboardFocus",						@#GotKeyboardFocus)
	XgrRegisterMessage (@"GrabArray",										@#GrabArray)
	XgrRegisterMessage (@"GrabTextArray",								@#GrabTextArray)
	XgrRegisterMessage (@"GrabTextString",							@#GrabTextString)
	XgrRegisterMessage (@"GrabValueArray",							@#GrabValueArray)
	XgrRegisterMessage (@"Help",												@#Help)
	XgrRegisterMessage (@"Hidden",											@#Hidden)
	XgrRegisterMessage (@"HideTextCursor",							@#HideTextCursor)
	XgrRegisterMessage (@"HideWindow",									@#HideWindow)
	XgrRegisterMessage (@"Initialize",									@#Initialize)
	XgrRegisterMessage (@"Initialized",									@#Initialized)
	XgrRegisterMessage (@"Inline",											@#Inline)
	XgrRegisterMessage (@"InquireText",									@#InquireText)
	XgrRegisterMessage (@"KeyboardFocusBackward",				@#KeyboardFocusBackward)
	XgrRegisterMessage (@"KeyboardFocusForward",				@#KeyboardFocusForward)
	XgrRegisterMessage (@"KeyDown",											@#KeyDown)
	XgrRegisterMessage (@"KeyUp",												@#KeyUp)
	XgrRegisterMessage (@"LostKeyboardFocus",						@#LostKeyboardFocus)
	XgrRegisterMessage (@"LostTextSelection",						@#LostTextSelection)
	XgrRegisterMessage (@"Maximized",										@#Maximized)
	XgrRegisterMessage (@"MaximizeWindow",							@#MaximizeWindow)
	XgrRegisterMessage (@"Maximum",											@#Maximum)
	XgrRegisterMessage (@"Minimized",										@#Minimized)
	XgrRegisterMessage (@"MinimizeWindow",							@#MinimizeWindow)
	XgrRegisterMessage (@"Minimum",											@#Minimum)
	XgrRegisterMessage (@"MonitorContext",							@#MonitorContext)
	XgrRegisterMessage (@"MonitorHelp",									@#MonitorHelp)
	XgrRegisterMessage (@"MonitorKeyboard",							@#MonitorKeyboard)
	XgrRegisterMessage (@"MonitorMouse",								@#MonitorMouse)
	XgrRegisterMessage (@"MouseDown",										@#MouseDown)
	XgrRegisterMessage (@"MouseDrag",										@#MouseDrag)
	XgrRegisterMessage (@"MouseEnter",									@#MouseEnter)
	XgrRegisterMessage (@"MouseExit",										@#MouseExit)
	XgrRegisterMessage (@"MouseMove",										@#MouseMove)
	XgrRegisterMessage (@"MouseUp",											@#MouseUp)
	XgrRegisterMessage (@"MouseWheel",									@#MouseWheel)
	XgrRegisterMessage (@"MuchLess",										@#MuchLess)
	XgrRegisterMessage (@"MuchMore",										@#MuchMore)
	XgrRegisterMessage (@"Notify",											@#Notify)
	XgrRegisterMessage (@"OneLess",											@#OneLess)
	XgrRegisterMessage (@"OneMore",											@#OneMore)
	XgrRegisterMessage (@"PokeArray",										@#PokeArray)
	XgrRegisterMessage (@"PokeTextArray",								@#PokeTextArray)
	XgrRegisterMessage (@"PokeTextString",							@#PokeTextString)
	XgrRegisterMessage (@"PokeValueArray",							@#PokeValueArray)
	XgrRegisterMessage (@"Print",												@#Print)
	XgrRegisterMessage (@"Redraw",											@#Redraw)
	XgrRegisterMessage (@"RedrawGrid",									@#RedrawGrid)
	XgrRegisterMessage (@"RedrawLines",									@#RedrawLines)
	XgrRegisterMessage (@"Redrawn",											@#Redrawn)
	XgrRegisterMessage (@"RedrawText",									@#RedrawText)
	XgrRegisterMessage (@"RedrawWindow",								@#RedrawWindow)
	XgrRegisterMessage (@"Replace",											@#Replace)
	XgrRegisterMessage (@"ReplaceForward",							@#ReplaceForward)
	XgrRegisterMessage (@"ReplaceReverse",							@#ReplaceReverse)
	XgrRegisterMessage (@"Reset",												@#Reset)
	XgrRegisterMessage (@"Resize",											@#Resize)
	XgrRegisterMessage (@"Resized",											@#Resized)
	XgrRegisterMessage (@"ResizeNot",										@#ResizeNot)
	XgrRegisterMessage (@"ResizeWindow",								@#ResizeWindow)
	XgrRegisterMessage (@"ResizeWindowToGrid",					@#ResizeWindowToGrid)
	XgrRegisterMessage (@"Resized",											@#Resized)
	XgrRegisterMessage (@"Reverse",											@#Reverse)
	XgrRegisterMessage (@"ScrollH",											@#ScrollH)
	XgrRegisterMessage (@"ScrollV",											@#ScrollV)
	XgrRegisterMessage (@"Select",											@#Select)
	XgrRegisterMessage (@"Selected",										@#Selected)
	XgrRegisterMessage (@"Selection",										@#Selection)
	XgrRegisterMessage (@"SelectWindow",								@#SelectWindow)
	XgrRegisterMessage (@"SetAlign",										@#SetAlign)
	XgrRegisterMessage (@"SetBorder",										@#SetBorder)
	XgrRegisterMessage (@"SetBorderOffset",							@#SetBorderOffset)
	XgrRegisterMessage (@"SetCallback",									@#SetCallback)
	XgrRegisterMessage (@"SetCan",											@#SetCan)
	XgrRegisterMessage (@"SetCharacterMapArray",				@#SetCharacterMapArray)
	XgrRegisterMessage (@"SetCharacterMapEntry",				@#SetCharacterMapEntry)
	XgrRegisterMessage (@"SetClipGrid",									@#SetClipGrid)
	XgrRegisterMessage (@"SetColor",										@#SetColor)
	XgrRegisterMessage (@"SetColorAll",									@#SetColorAll)
	XgrRegisterMessage (@"SetColorExtra",								@#SetColorExtra)
	XgrRegisterMessage (@"SetColorExtraAll",						@#SetColorExtraAll)
	XgrRegisterMessage (@"SetCursor",										@#SetCursor)
	XgrRegisterMessage (@"SetCursorXY",									@#SetCursorXY)
	XgrRegisterMessage (@"SetDisplay",									@#SetDisplay)
	XgrRegisterMessage (@"SetFocusColor",								@#SetFocusColor)
	XgrRegisterMessage (@"SetFocusColorExtra",					@#SetFocusColorExtra)
	XgrRegisterMessage (@"SetFont",											@#SetFont)
	XgrRegisterMessage (@"SetFontNumber",								@#SetFontNumber)
	XgrRegisterMessage (@"SetGridFunction",							@#SetGridFunction)
	XgrRegisterMessage (@"SetGridFunctionName",					@#SetGridFunctionName)
	XgrRegisterMessage (@"SetGridName",									@#SetGridName)
	XgrRegisterMessage (@"SetGridProperties",						@#SetGridProperties)
	XgrRegisterMessage (@"SetGridType",									@#SetGridType)
	XgrRegisterMessage (@"SetGridTypeName",							@#SetGridTypeName)
	XgrRegisterMessage (@"SetGroup",										@#SetGroup)
	XgrRegisterMessage (@"SetHelp",											@#SetHelp)
	XgrRegisterMessage (@"SetHelpFile",									@#SetHelpFile)
	XgrRegisterMessage (@"SetHelpString",								@#SetHelpString)
	XgrRegisterMessage (@"SetHelpStrings",							@#SetHelpStrings)
	XgrRegisterMessage (@"SetHintString",								@#SetHintString)
	XgrRegisterMessage (@"SetImage",										@#SetImage)
	XgrRegisterMessage (@"SetImageCoords",							@#SetImageCoords)
	XgrRegisterMessage (@"SetIndent",										@#SetIndent)
	XgrRegisterMessage (@"SetInfo",											@#SetInfo)
	XgrRegisterMessage (@"SetJustify",									@#SetJustify)
	XgrRegisterMessage (@"SetKeyboardFocus",						@#SetKeyboardFocus)
	XgrRegisterMessage (@"SetKeyboardFocusGrid",				@#SetKeyboardFocusGrid)
	XgrRegisterMessage (@"SetKidArray",									@#SetKidArray)
	XgrRegisterMessage (@"SetMaxMinSize",								@#SetMaxMinSize)
	XgrRegisterMessage (@"SetMenuEntryArray",						@#SetMenuEntryArray)
	XgrRegisterMessage (@"SetMessageFunc",							@#SetMessageFunc)
	XgrRegisterMessage (@"SetMessageFuncArray",					@#SetMessageFuncArray)
	XgrRegisterMessage (@"SetMessageSub",								@#SetMessageSub)
	XgrRegisterMessage (@"SetMessageSubArray",					@#SetMessageSubArray)
	XgrRegisterMessage (@"SetModalWindow",							@#SetModalWindow)
	XgrRegisterMessage (@"SetParent",										@#SetParent)
	XgrRegisterMessage (@"SetPosition",									@#SetPosition)
	XgrRegisterMessage (@"SetRedrawFlags",							@#SetRedrawFlags)
	XgrRegisterMessage (@"SetSize",											@#SetSize)
	XgrRegisterMessage (@"SetState",										@#SetState)
	XgrRegisterMessage (@"SetStyle",										@#SetStyle)
	XgrRegisterMessage (@"SetTabArray",									@#SetTabArray)
	XgrRegisterMessage (@"SetTabWidth",									@#SetTabWidth)
	XgrRegisterMessage (@"SetTextArray",								@#SetTextArray)
	XgrRegisterMessage (@"SetTextArrayLine",						@#SetTextArrayLine)
	XgrRegisterMessage (@"SetTextArrayLines",						@#SetTextArrayLines)
	XgrRegisterMessage (@"SetTextCursor",								@#SetTextCursor)
	XgrRegisterMessage (@"SetTextFilename",							@#SetTextFilename)
	XgrRegisterMessage (@"SetTextSelection",						@#SetTextSelection)
	XgrRegisterMessage (@"SetTextSpacing",							@#SetTextSpacing)
	XgrRegisterMessage (@"SetTextString",								@#SetTextString)
	XgrRegisterMessage (@"SetTextStrings",							@#SetTextStrings)
	XgrRegisterMessage (@"SetTexture",									@#SetTexture)
	XgrRegisterMessage (@"SetTimer",										@#SetTimer)
	XgrRegisterMessage (@"SetValue",										@#SetValue)
	XgrRegisterMessage (@"SetValues",										@#SetValues)
	XgrRegisterMessage (@"SetValueArray",								@#SetValueArray)
	XgrRegisterMessage (@"SetWindowFunction",						@#SetWindowFunction)
	XgrRegisterMessage (@"SetWindowIcon",								@#SetWindowIcon)
	XgrRegisterMessage (@"SetWindowTitle",							@#SetWindowTitle)
	XgrRegisterMessage (@"ShowTextCursor",							@#ShowTextCursor)
	XgrRegisterMessage (@"ShowWindow",									@#ShowWindow)
	XgrRegisterMessage (@"SomeLess",										@#SomeLess)
	XgrRegisterMessage (@"SomeMore",										@#SomeMore)
	XgrRegisterMessage (@"StartTimer",									@#StartTimer)
	XgrRegisterMessage (@"SystemMessage",								@#SystemMessage)
	XgrRegisterMessage (@"TextDelete",									@#TextDelete)
	XgrRegisterMessage (@"TextEvent",										@#TextEvent)
	XgrRegisterMessage (@"TextInsert",									@#TextInsert)
	XgrRegisterMessage (@"TextModified",								@#TextModified)
	XgrRegisterMessage (@"TextReplace",									@#TextReplace)
	XgrRegisterMessage (@"TimeOut",											@#TimeOut)
	XgrRegisterMessage (@"Update",											@#Update)
	XgrRegisterMessage (@"WindowClose",									@#WindowClose)
	XgrRegisterMessage (@"WindowCreate",								@#WindowCreate)
	XgrRegisterMessage (@"WindowDeselected",						@#WindowDeselected)
	XgrRegisterMessage (@"WindowDestroy",								@#WindowDestroy)
	XgrRegisterMessage (@"WindowDestroyed",							@#WindowDestroyed)
	XgrRegisterMessage (@"WindowDisplay",								@#WindowDisplay)
	XgrRegisterMessage (@"WindowDisplayed",							@#WindowDisplayed)
	XgrRegisterMessage (@"WindowGetDisplay",						@#WindowGetDisplay)
	XgrRegisterMessage (@"WindowGetFunction",						@#WindowGetFunction)
	XgrRegisterMessage (@"WindowGetIcon",								@#WindowGetIcon)
	XgrRegisterMessage (@"WindowGetKeyboardFocusGrid",	@#WindowGetKeyboardFocusGrid)
	XgrRegisterMessage (@"WindowGetSelectedWindow",			@#WindowGetSelectedWindow)
	XgrRegisterMessage (@"WindowGetSize",								@#WindowGetSize)
	XgrRegisterMessage (@"WindowGetTitle",							@#WindowGetTitle)
	XgrRegisterMessage (@"WindowHelp",									@#WindowHelp)
	XgrRegisterMessage (@"WindowHide",									@#WindowHide)
	XgrRegisterMessage (@"WindowHidden",								@#WindowHidden)
	XgrRegisterMessage (@"WindowKeyDown",								@#WindowKeyDown)
	XgrRegisterMessage (@"WindowKeyUp",									@#WindowKeyUp)
	XgrRegisterMessage (@"WindowMaximize",							@#WindowMaximize)
	XgrRegisterMessage (@"WindowMaximized",							@#WindowMaximized)
	XgrRegisterMessage (@"WindowMinimize",							@#WindowMinimize)
	XgrRegisterMessage (@"WindowMinimized",							@#WindowMinimized)
	XgrRegisterMessage (@"WindowMonitorContext",				@#WindowMonitorContext)
	XgrRegisterMessage (@"WindowMonitorHelp",						@#WindowMonitorHelp)
	XgrRegisterMessage (@"WindowMonitorKeyboard",				@#WindowMonitorKeyboard)
	XgrRegisterMessage (@"WindowMonitorMouse",					@#WindowMonitorMouse)
	XgrRegisterMessage (@"WindowMouseDown",							@#WindowMouseDown)
	XgrRegisterMessage (@"WindowMouseDrag",							@#WindowMouseDrag)
	XgrRegisterMessage (@"WindowMouseEnter",						@#WindowMouseEnter)
	XgrRegisterMessage (@"WindowMouseExit",							@#WindowMouseExit)
	XgrRegisterMessage (@"WindowMouseMove",							@#WindowMouseMove)
	XgrRegisterMessage (@"WindowMouseUp",								@#WindowMouseUp)
	XgrRegisterMessage (@"WindowMouseWheel",						@#WindowMouseWheel)
	XgrRegisterMessage (@"WindowRedraw",								@#WindowRedraw)
	XgrRegisterMessage (@"WindowRegister",							@#WindowRegister)
	XgrRegisterMessage (@"WindowResize",								@#WindowResize)
	XgrRegisterMessage (@"WindowResized",								@#WindowResized)
	XgrRegisterMessage (@"WindowResizeToGrid",					@#WindowResizeToGrid)
	XgrRegisterMessage (@"WindowSelect",								@#WindowSelect)
	XgrRegisterMessage (@"WindowSelected",							@#WindowSelected)
	XgrRegisterMessage (@"WindowSetFunction",						@#WindowSetFunction)
	XgrRegisterMessage (@"WindowSetIcon",								@#WindowSetIcon)
	XgrRegisterMessage (@"WindowSetKeyboardFocusGrid",	@#WindowSetKeyboardFocusGrid)
	XgrRegisterMessage (@"WindowSetTitle",							@#WindowSetTitle)
	XgrRegisterMessage (@"WindowShow",									@#WindowShow)
	XgrRegisterMessage (@"WindowSystemMessage",					@#WindowSystemMessage)
	XgrRegisterMessage (@"ContextMenuUp",								@#ContextMenuUp)
	XgrRegisterMessage (@"ContextMenuDown",							@#ContextMenuDown)
	XgrRegisterMessage (@"UpdateLabel",									@#UpdateLabel)
	XgrRegisterMessage (@"LastMessage",									@#LastMessage)

	XgrGetDisplaySize ("", @#displayWidth, @#displayHeight, @#windowBorderWidth, @#windowTitleHeight)

END FUNCTION
'
'
' ############################
' #####  InitProgram ()  #####
' ############################
'
'
FUNCTION  InitProgram ()
	SHARED SINGLE ww,hh,xx,yy
	SHARED LoadedFiles$[]
	SHARED SINGLE ImageSet[]
	SHARED Image ImageFormat[]
	SHARED MemDataSet ImageDataSet[]
	SHARED imageindex,inifile$


	' Init any variable's required before grid's are created
	' + any gobal variable's not requiring reset after each file change

	XstGetApplicationEnvironment (@#standalone,xx)
	XstGetCommandLineArguments (@aTotal, @argv$[])
	#defaultloc$=argv$[0]
	XstDecomposePathname (#defaultloc$, @path$, parent$, filename$, FnoExt$, fileExt$)
	inifile$=path$+"\\isif.ini"



	IF #IsLib=$$FALSE THEN
			IF #standalone=$$TRUE THEN
					IF GetIniValue ("StartUp","ShowConsole",v$)=0 THEN CloseConsole ()
					#cursorHand=#myHand
					#LoadBit=1
			ELSE
					#defaultloc$="e:\\xb\\ii"
					inifile$=#defaultloc$+"\\isif.ini"
			END IF
	END IF

	#date$="171002"									' day month year
	#iiversion$="_ISif_ v0.7.52"

	XstGetOSName (@#os$)
	IF LEFT$(#os$,3)="Win" THEN #os=2 ELSE #os=1

	xx=GetIniValue ("StartUpPos","Screenxx",v$)
	yy=GetIniValue ("StartUpPos","Screenyy",v$)
	ww=GetIniValue ("StartUpPos","Screenww",v$)
	hh=GetIniValue ("StartUpPos","Screenhh",v$)
	#Minxx=GetIniValue ("StartUpPos","Minww",v$)
	#Minyy=GetIniValue ("StartUpPos","Minhh",v$)
	#rightmargin=30
	#leftmargin=80
	#topmargin=30
	#bottommargin=#topmargin+70

	#defaultXX=xx
	#defaultYY=yy
	#defaultWW=ww
	#defaultHH=hh
	#defaultTop=#topmargin
	#defaultBottom=#bottommargin
	#defaultTopI=60
	#defaultBottomI=#defaultTopI+70

	#currentDisplay=GetIniValue ("Defaults","DisplayMode",v$)
	#CloseFileWindow=1
'	#LoadBit=0
	#FirstLoad=0

	#MaxDataSets=8			' increase this value for more data sets
	#ImageSet=0
	DIM ImageSet[7,]
	DIM ImageFormat[7,]
	DIM ImageDataSet[7]


'	#LineStyle=$$LineStyleSolid
	#LineStyle=$$LineStyleDot
	#AutoScale=GetIniValue ("Defaults","AutoScale",v$)
	#CType=0 ' cursor type
	#LineType=GetIniValue ("Defaults","LineType2d",v$)
	#ScaleType=GetIniValue ("Defaults","ScaleType",v$)
	#MaxSstate=0
	#sCursorColour=$$LightGreen	 ' window cursor colour
	#sCursorType=0							 ' ^ type (on/off)
	#customMin=1
	#customMax=1
	#textClear$=SPACE$(47)
	#FileNumber=0
	#clearGrid=0
	#trackCursor=GetIniValue ("Defaults","TrackCursor",v$)
	#MinSize=0
	#iconized=-1
	#colourThemeDf=GetIniValue ("Theme","Default",v$)
	#colourThemeMx=GetIniValue ("Theme","Max",v$)
	#colourTheme=#colourThemeDf
	#cMenuType=1					' cMenu style
	#Tdock=0
	#ToolMenuBottonState=GetIniValue ("Defaults","ToolBar",v$)
	#imageMode=GetIniValue ("Defaults","ImageModecType",v$)
	#SaveImage=0
'	#currentImageBt=0
  #NumberOfFiles=0
	#ButtonMenuOn=0
	#ButtonMenu=0
	#zoomXtrack!=GetIniValue ("Zoom","xTrack",v$)
	#zoomYtrackMn!=GetIniValue ("Zoom","yTrackMn",v$)
	#zoomYtrackMx!=GetIniValue ("Zoom","yTrackMx",v$)
	#zoomZImageMn!=GetIniValue ("Zoom","zImageMn",v$)
	#zoomZImageMx!=GetIniValue ("Zoom","zImageMx",v$)
	#ReadDirectionState=0
	#promptUser=GetIniValue ("Defaults","AlwaysPrompt",v$)
	#DebugLevel=0
	#DatInfoState=0
	#DragTypeImage=GetIniValue ("Defaults","ImageDragType",v$)
	#BlemTimeout=GetIniValue ("Blemish","TimeToPopUp",v$)
	#SnapIToWindow=GetIniValue ("Defaults","SnapWindowToImage",v$)

	#TrackSyncTk=0
	#TrackSyncPx=0
	#TrackSyncMM=0

	DIM #button$[12]				' this is not actualy required, but is helpful if the icons have not been drawn.
	#button$[0]="Q"
	#button$[1]="T"
	#button$[2]="P"
	#button$[3]="F"
	#button$[4]="V"
	#button$[5]="H"
	#button$[6]="C"
	#button$[7]="L"
	#button$[8]="S"
	#button$[9]="R"
	#button$[10]="A"
	#button$[11]="FI"
	#button$[12]="I"
'	#button$[13]="M"

	InitContextMenuArrays ()
	CreateColourTable ()

	DIM LoadedFiles$[5]			' file history list is currently disabled
	imageindex=0

END FUNCTION
'
'
' ##############################
' #####  CreateWindows ()  #####
' ##############################
'
FUNCTION  CreateWindows ()
'
	IF LIBRARY(0) THEN RETURN

	wintype=$$WindowTypeTopMost | $$WindowTypeNoIcon | $$WindowTypeNoSelect | $$WindowTypeTitleBar
	wintype2= $$WindowTypeResizeFrame | $$WindowTypeTopMost | $$WindowTypeTitleBar   | $$WindowTypeNoSelect

	CreateMemoryBuffers ()

	Output         (@Output, #CreateWindow, 0, 0, 0, 0, $$WindowTypeResizeFrame, 0)
	XuiSendMessage ( Output, #SetCallback, Output, &OutputCode(), -1, -1, -1, 0)
	XuiSendMessage ( Output, #Initialize, 0, 0, 0, 0, 0, 0)
'	XuiSendMessage ( Output, #DisplayWindow, 0, 0, 0, 0, 0, 0)
	XuiSendMessage ( Output, #SetGridProperties, -1, 0, 0, 0, 0, 0)
	#Output = Output
'
	Tools          (@Tools, #CreateWindow, 0, 0, 0, 0, $$WindowTypeNoFrame | $$WindowTypeTopMost | $$WindowTypeNoIcon |$$WindowTypeNoSelect , 0)
	XuiSendMessage ( Tools, #SetCallback, Tools, &ToolsCode(), -1, -1, -1 , 0)
	XuiSendMessage ( Tools, #Initialize, 0, 0, 0, 0, 0, 0)
	IF #ToolMenuBottonState=1 THEN XuiSendMessage ( Tools, #DisplayWindow, 0, 0, 0, 0, 0, 0)
	XuiSendMessage ( Tools, #SetGridProperties, -1, 0, 0, 0, 0, 0)
	#Tools = Tools

	Message        (@Message, #CreateWindow, 0, 0, 0, 0, wintype2, 0)
	XuiSendMessage ( Message, #SetCallback, Message, &MessageCode(), -1, -1, -1, 0)
	XuiSendMessage ( Message, #Initialize, 0, 0, 0, 0, 0, 0)
'	XuiSendMessage ( Message, #DisplayWindow, 0, 0, 0, 0, 0, 0)
	XuiSendMessage ( Message, #SetGridProperties, -1, 0, 0, 0, 0, 0)
	#Message = Message

	About          (@About, #CreateWindow, 0, 0, 0, 0,0, 0)
	XuiSendMessage ( About, #SetCallback, About, &AboutCode(), -1, -1, -1, 0)
	XuiSendMessage ( About, #Initialize, 0, 0, 0, 0, 0, 0)
'	XuiSendMessage ( About, #DisplayWindow, 0, 0, 0, 0, 0, 0)
	XuiSendMessage ( About, #SetGridProperties, -1, 0, 0, 0, 0, 0)
	#About = About

	LevelIndicator (@LevelIndicator, #CreateWindow, 0, 0, 0, 0, wintype, 0)
	XuiSendMessage ( LevelIndicator, #SetCallback, LevelIndicator, &LevelIndicatorCode(), -1, -1, -1, 0)
	XuiSendMessage ( LevelIndicator, #Initialize, 0, 0, 0, 0, 0, 0)
'	XuiSendMessage ( LevelIndicator, #DisplayWindow, 0, 0, 0, 0, 0, 0)
	XuiSendMessage ( LevelIndicator, #SetGridProperties, -1, 0, 0, 0, 0, 0)
	#LevelIndicator = LevelIndicator

	FileList       (@FileList, #CreateWindow, 0, 0, 0, 0, 0, 0)
	XuiSendMessage ( FileList, #SetCallback, FileList, &FileListCode(), -1, -1, -1, 0)
	XuiSendMessage ( FileList, #Initialize, 0, 0, 0, 0, 0, 0)
'	XuiSendMessage ( FileList, #DisplayWindow, 0, 0, 0, 0, 0, 0)
	XuiSendMessage ( FileList, #SetGridProperties, -1, 0, 0, 0, 0, 0)
	#FileList = FileList

	ResponseBox    (@ResponseBox, #CreateWindow, 0, 0, 0, 0, wintype, 0)
	XuiSendMessage ( ResponseBox, #SetCallback, ResponseBox, &ResponseBoxCode(), -1, -1, -1, 0)
	XuiSendMessage ( ResponseBox, #Initialize, 0, 0, 0, 0, 0, 0)
'	XuiSendMessage ( ResponseBox, #DisplayWindow, 0, 0, 0, 0, 0, 0)
	XuiSendMessage ( ResponseBox, #SetGridProperties, -1, 0, 0, 0, 0, 0)
	#ResponseBox = ResponseBox

	IconWindow     (@IconWindow, #CreateWindow, 0, 0, 0, 0, $$WindowTypeNoFrame | $$WindowTypeTopMost | $$WindowTypeNoIcon |$$WindowTypeNoSelect , 0)
	XuiSendMessage ( IconWindow, #SetCallback, IconWindow, &IconWindowCode(), -1, -1, -1, 0)
	XuiSendMessage ( IconWindow, #Initialize, 0, 0, 0, 0, 0, 0)
'	XuiSendMessage ( IconWindow, #DisplayWindow, 0, 0, 0, 0, 0, 0)
	XuiSendMessage ( IconWindow, #SetGridProperties, -1, 0, 0, 0, 0, 0)
	#IconWindow = IconWindow
'
	Axis           (@Axis, #CreateWindow, 0, 0, 0, 0, $$WindowTypeMinimizeBox| $$WindowTypeCloseHide | $$WindowTypeSystemMenu, 0)
	XuiSendMessage ( Axis, #SetCallback, Axis, &AxisCode(), -1, -1, -1, 0)
	XuiSendMessage ( Axis, #Initialize, 0, 0, 0, 0, 0, 0)
'	XuiSendMessage ( Axis, #DisplayWindow, 0, 0, 0, 0, 0, 0)
	XuiSendMessage ( Axis, #SetGridProperties, -1, 0, 0, 0, 0, 0)
	#Axis = Axis
'
	Goto           (@Goto, #CreateWindow, 0, 0, 0, 0, $$WindowTypeCloseHide | $$WindowTypeSystemMenu, 0)
	XuiSendMessage ( Goto, #SetCallback, Goto, &GotoCode(), -1, -1, -1, 0)
	XuiSendMessage ( Goto, #Initialize, 0, 0, 0, 0, 0, 0)
'	XuiSendMessage ( Goto, #DisplayWindow, 0, 0, 0, 0, 0, 0)
	XuiSendMessage ( Goto, #SetGridProperties, -1, 0, 0, 0, 0, 0)
	#Goto = Goto
'
	SetPixel       (@SetPixel, #CreateWindow, 0, 0, 0, 0, $$WindowTypeCloseHide | $$WindowTypeSystemMenu, 0)
	XuiSendMessage ( SetPixel, #SetCallback, SetPixel, &SetPixelCode(), -1, -1, -1, 0)
	XuiSendMessage ( SetPixel, #Initialize, 0, 0, 0, 0, 0, 0)
'	XuiSendMessage ( SetPixel, #DisplayWindow, 0, 0, 0, 0, 0, 0)
	XuiSendMessage ( SetPixel, #SetGridProperties, -1, 0, 0, 0, 0, 0)
	#SetPixel = SetPixel
'
	GetRawInfo     (@GetRawInfo, #CreateWindow, 0, 0, 0, 0, $$WindowTypeCloseDestroy | $$WindowTypeSystemMenu, 0)
	XuiSendMessage ( GetRawInfo, #SetCallback, GetRawInfo, &GetRawInfoCode(), -1, -1, -1, 0)
	XuiSendMessage ( GetRawInfo, #Initialize, 0, 0, 0, 0, 0, 0)
'	XuiSendMessage ( GetRawInfo, #DisplayWindow, 0, 0, 0, 0, 0, 0)
	XuiSendMessage ( GetRawInfo, #SetGridProperties, -1, 0, 0, 0, 0, 0)
	#GetRawInfo = GetRawInfo
'
	ModScaleMax    (@ModScaleMax, #CreateWindow, 0, 0, 0, 0, $$WindowTypeNoFrame | $$WindowTypeTopMost | $$WindowTypeNoIcon |$$WindowTypeNoSelect, 0)
	XuiSendMessage ( ModScaleMax, #SetCallback, ModScaleMax, &ModScaleMaxCode(), -1, -1, -1, 0)
	XuiSendMessage ( ModScaleMax, #Initialize, 0, 0, 0, 0, 0, 0)
'	XuiSendMessage ( ModScaleMax, #DisplayWindow, 0, 0, 0, 0, 0, 0)
	XuiSendMessage ( ModScaleMax, #SetGridProperties, -1, 0, 0, 0, 0, 0)
	#ModScaleMax = ModScaleMax
'
	ModScaleMin    (@ModScaleMin, #CreateWindow, 0, 0, 0, 0, $$WindowTypeNoFrame | $$WindowTypeTopMost | $$WindowTypeNoIcon |$$WindowTypeNoSelect, 0)
	XuiSendMessage ( ModScaleMin, #SetCallback, ModScaleMin, &ModScaleMinCode(), -1, -1, -1, 0)
	XuiSendMessage ( ModScaleMin, #Initialize, 0, 0, 0, 0, 0, 0)
'	XuiSendMessage ( ModScaleMin, #DisplayWindow, 0, 0, 0, 0, 0, 0)
	XuiSendMessage ( ModScaleMin, #SetGridProperties, -1, 0, 0, 0, 0, 0)
	#ModScaleMin = ModScaleMin
'
	AddTraceW      (@AddTraceW, #CreateWindow, 0, 0, 0, 0,  $$WindowTypeCloseHide | $$WindowTypeSystemMenu | $$WindowTypeTopMost, 0)
	XuiSendMessage ( AddTraceW, #SetCallback, AddTraceW, &AddTraceWCode(), -1, -1, -1, 0)
	XuiSendMessage ( AddTraceW, #Initialize, 0, 0, 0, 0, 0, 0)
'	XuiSendMessage ( AddTraceW, #DisplayWindow, 0, 0, 0, 0, 0, 0)
	XuiSendMessage ( AddTraceW, #SetGridProperties, -1, 0, 0, 0, 0, 0)
	#AddTraceW = AddTraceW

END FUNCTION
'
'
' ############################
' #####  InitWindows ()  #####
' ############################
'
'
FUNCTION  InitWindows ()
	SHARED area,hWnd

	' init [once] window related components

	XuiSendMessage (#Output,#Disable,0,0,0,0,41,0)	'
	XuiSendMessage (#Output,#Disable,0,0,0,0,42,0)	'
	XuiSendMessage (#Output,#Disable,0,0,0,0,43,0)	'
	XuiSendMessage (#image, #SetCursor,#cursorCrosshair, 0, 0, 0, 0, 0)

	area=GetGridNumber  (#Output,3)
	#toolarea=GetGridNumber (#Tools,22)
	#colourbarea=GetGridNumber (#Output,38)
	#ModScaleMinG=GetGridNumber (#ModScaleMin,0)
	#ModScaleMaxG=GetGridNumber (#ModScaleMax,0)
	#AddTraceBoxG=GetGridNumber (#AddTraceW,9)

	SetColourTheme (#colourTheme)
	XgrDrawLine (#cBuff, $$Black, 0, 0, 1, 1)				' sets colour mode

	XgrSetBackgroundColor (#Output, #background)  ' make drawinfo text visable
	XgrCreateFont (@#valfont , @"Comic Sans MS", 200, 200, 0, 0)
	XgrCreateFont (@#pixfont , @"Comic Sans MS", 250, 200, 0, 0)
	XgrCreateFont (@#labelfont , @"Comic Sans MS", 300, 200, 0, 0)
	XgrCreateFont (@#cFont , @"Comic Sans", 250, 200, 0, 0)
	XgrCreateFont (@#labelYfont , @"Comic Sans MS", 300, 200, 0, 900)

	XgrGetFontMetrics (#cFont, @#cFontWidth, @maxCharHeight, ascent, DECent, @#cFontGap, flags)
	#size=maxCharHeight+3


	#cMenuHeight=(1+UBOUND(#cMenu$[]))*#size				' precalculate menu height
	#cSubMenu1Height=(1+UBOUND(#cSubMenu1$[]))*#size
	#cSubMenu2Height=(1+UBOUND(#cSubMenu2$[]))*#size
	#cSubMenu3Height=(1+UBOUND(#cSubMenu3$[]))*#size
	#cSubMenu4Height=(1+UBOUND(#cSubMenu4$[]))*#size
	#cSubMenu5Height=(1+UBOUND(#cSubMenu5$[]))*#size
	#cSubMenu6Height=(1+UBOUND(#cSubMenu6$[]))*#size
	#cSubMenu7Height=(1+UBOUND(#cSubMenu7$[]))*#size
	#cSubMenu8Height=(1+UBOUND(#cSubMenu8$[]))*#size
  #cSubMenu9Height=(1+UBOUND(#cSubMenu9$[]))*#size
	#cSubMenu10Height=(1+UBOUND(#cSubMenu10$[]))*#size
	#cSubMenu11Height=(1+UBOUND(#cSubMenu11$[]))*#size
	#cSubMenu12Height=(1+UBOUND(#cSubMenu12$[]))*#size
	#cSubMenu13Height=(1+UBOUND(#cSubMenu13$[]))*#size
	#cSubMenu14Height=(1+UBOUND(#cSubMenu14$[]))*#size
	#cSubMenu15Height=(1+UBOUND(#cSubMenu15$[]))*#size
	#cSubMenu16Height=(1+UBOUND(#cSubMenu16$[]))*#size
'	#cSubMenu17Height=(1+UBOUND(#cSubMenu17$[]))*#size


	XgrGetGridWindow (#Output,@#OutputWindow)
	XgrGetGridWindow (#Tools,@#ToolsWindow)
	XgrGetGridWindow (#Message,@#MessageWindow)
	XgrGetGridWindow (#LevelIndicator,@#LevelIndicatorWindow)
	XgrGetGridWindow (#FileList,@#FileListWindow)
	XgrGetGridWindow (#ResponseBox,@#ResponseBoxWindow)
	XgrGetGridWindow (#About,@#AboutWindow)
	XgrGetGridWindow (#IconWindow,@#IconWindowWindow)
	XgrGetGridWindow (#Axis,@#AxisWindow)
	XgrGetGridWindow (#Goto,@#GotoWindow)
	XgrGetGridWindow (#SetPixel,@#SetPixelWindow)
	XgrGetGridWindow (#GetRawInfo,@#GetRawInfoWindow)
	XgrGetGridWindow (#ModScaleMax,@#ModScaleMaxWindow)
	XgrGetGridWindow (#ModScaleMin,@#ModScaleMinWindow)
	XgrGetGridWindow (#AddTraceW,@#AddTraceWWindow)


	XuiSendMessage (#Tools, #SetWindowTitle, 0, 0, 0, 0, 0, "II - tool bar")
	XuiSendMessage (#Axis, #SetWindowTitle, 0, 0, 0, 0, 0, "Axis setup")
	XuiSendMessage (#Goto, #SetWindowTitle, 0, 0, 0, 0, 0, "Goto..")
	XuiSendMessage (#SetPixel, #SetWindowTitle, 0, 0, 0, 0, 0, "Set value to..")
	XuiSendMessage (#GetRawInfo, #SetWindowTitle, 0, 0, 0, 0, 0, "Raw dataset")
	XuiSendMessage (#ModScaleMax, #SetWindowTitle, 0, 0, 0, 0, 0, "Max scale")
	XuiSendMessage (#ModScaleMin, #SetWindowTitle, 0, 0, 0, 0, 0, "Min scale")
	XuiSendMessage (#AddTraceW, #SetWindowTitle, 0, 0, 0, 0, 0, "Add Trace")

	XgrSetWindowIcon (#AxisWindow ,#iconWindow)
	XgrSetWindowIcon (#GotoWindow ,#iconWindow)
	XgrSetWindowIcon (#SetPixelWindow,#iconWindow)
	XgrSetWindowIcon (#GetRawInfoWindow,#iconWindow)
	XgrSetWindowIcon (#ModScaleMin ,#iconWindow)
	XgrSetWindowIcon (#ModScaleMax ,#iconWindow)

'	XuiSendMessage (#IconWindow, #SetWindowTitle, 0, 0, 0, 0, 0, " ")
'	XgrSetWindowIcon  (#FileListWindow ,#iconWindow)


'	#hPopMenu = CreatePopupMenu ()
'	AppendMenuA (#hPopMenu, $$MF_STRING   , $$PopUp_XB,      &"&XBASIC Homepage")
'	AppendMenuA (#hPopMenu, $$MF_STRING   , $$PopUp_News,    &"XBLite &Newsgroup")
'	AppendMenuA (#hPopMenu, $$MF_SEPARATOR, 0, 0)
'	AppendMenuA (#hPopMenu, $$MF_STRING   , $$PopUp_Icon,    &"&Change Tray Icon")
'	AppendMenuA (#hPopMenu, $$MF_SEPARATOR, 0, 0)
'	AppendMenuA (#hPopMenu, $$MF_STRING   , $$PopUp_Wordpad, &"&WordPad")
'	AppendMenuA (#hPopMenu, $$MF_SEPARATOR, 0, 0)
'	AppendMenuA (#hPopMenu, $$MF_STRING   , $$PopUp_Exit,    &"&Exit")

	XgrWindowToSystemWindow (#OutputWindow, @#hWnd, dx, dy, width, height)
'	IF #standalone=-1	THEN SetTaskbarIcon (#hWnd, "ztrayicon", "ISif")
	hWnd=#hWnd

END FUNCTION
'
'
' ##########################
' #####  DrawImage ()  #####
' ##########################
'
FUNCTION  DrawImage ()
	SHARED Image ImageFormat[]
	SHARED argb rgb[]
	SHARED SINGLE hh,ww,mu,top
	SHARED UBYTE image[]
	STATIC UBYTE temp[]
	STATIC UBYTE col,l,red, green, blue
	STATIC UBYTE colourIndex
	STATIC track,ct,lastp,firstp,ipos
	STATIC firsttrack,width,z,height
	AUTOX UBYTE a
	XLONG pix


'	StartTimer (@t,s)

'	IF #drawimage=1 THEN RETURN 2

	#drawimage=1		' image draw in process
	IF (#currentDisplay<>2) THEN #clearGrid=1: SwitchToImage ()

	ResizeImageBuffGrids ()		'
	GOSUB InitIv
	GOSUB GetImage
	#drawimage=0

'	PRINT EndTimer (t,e)

	RETURN 1

EXIT FUNCTION

'##############
SUB GetImage
'##############

	CreateDib24Header (width,height,@len,@image[])

	from=&temp[]
	toi=&image[]
	lenw=width*3
	toilen=toi+len

	FOR track = firsttrack TO lasttrack

				GOSUB GetTrack

				FOR l=1 TO z
							to=toi+ipos
							IF ((to+ct) < toilen) THEN RtlMoveMemory (to,from,ct)
							ipos=ipos+lenw
				NEXT l

				SELECT CASE	#ClearMessageQueue
						CASE	1			:XgrProcessMessages (-2)
						CASE	2			:XgrProcessMessages (-2): #ClearMessageQueue=0
				END SELECT

				IF #lockout=1 THEN EXIT SUB

	NEXT track

END SUB

'##############
SUB GetTrack
'##############

	ct=0
	firstpixel=GetPixelAddress (#ImageSet,firstp+1,track+1)
	lastpixel=GetPixelAddress (#ImageSet,lastp+1,track+1)

'	IF (lastpixel > ((ImageFormat[#ImageSet,#dataFile].NumberOfPixels*ImageFormat[#ImageSet,#dataFile].ImageFormat[#ImageSet,#dataFile].NumberOfTracks)-1)) THEN lastpixel=(ImageFormat[#ImageSet,#dataFile].NumberOfPixels*ImageFormat[#ImageSet,#dataFile].NumberOfTracks)-1

	SELECT CASE	#imageMode

		CASE 1
			FOR pix= firstpixel TO lastpixel STEP 4
					a=((SINGLEAT (pix)-#MinVi!)*mu)

					IF a>255 THEN
							a=255
					ELSE IF a<0 THEN a=0
					END IF

					FOR l=1 TO col
							temp[ct]=a: INC ct
							temp[ct]=a: INC ct
							temp[ct]=a: INC ct
					NEXT l
			NEXT pix

		CASE 2
			FOR pix= firstpixel TO lastpixel STEP 4

					colourIndex=((SINGLEAT (pix)-#MinVi!)*mu)
					IF colourIndex>124 THEN
							colourIndex=124
					ELSE IF colourIndex<0 THEN colourIndex=0
					END IF

					SELECT CASE TRUE
							CASE (colourIndex >=100)		:red=0xFFFF: igb=colourIndex-100
							CASE (colourIndex >= 75)		:red=0xC000: igb=colourIndex-75
							CASE (colourIndex >= 50)		:red=0x8000: igb=colourIndex-50
							CASE (colourIndex >= 25)		:red=0x4000: igb=colourIndex-25
							CASE ELSE										:red=0x0000: igb=colourIndex
					END SELECT

					SELECT CASE TRUE
							CASE (igb >= 20)		:green=0xFFFF: blue=(igb-20) << 14
							CASE (igb >= 15)		:green=0xC000: blue=(igb-15) << 14
							CASE (igb >= 10)		:green=0x8000: blue=(igb-10) << 14
							CASE (igb >=  5)		:green=0x4000: blue=(igb-5) << 14
							CASE ELSE						:green=0x0000: blue=igb << 14
					END SELECT

					IF (blue > 0xFFFF) THEN blue=0xFFFF

					FOR l=1 TO col
							temp[ct]=blue{8,8}: INC ct
							temp[ct]=green{8,8}: INC ct
							temp[ct]=red{8,8}: INC ct
					NEXT l
			NEXT  pix

		CASE 3
			FOR pix= firstpixel TO lastpixel STEP 4

					a=((SINGLEAT (pix)-#MinVi!)*mu)
					IF a>37 THEN
							a=37
					ELSE IF a<0 THEN a=0
					END IF

					FOR l=1 TO col
							temp[ct]=rgb[a].blue: INC ct		' copy byte at address
							temp[ct]=rgb[a].green: INC ct
							temp[ct]=rgb[a].red: INC ct
					NEXT l
			NEXT pix

		END SELECT

'		IF #imagefix>0 THEN ipos=ipos+#imagefix

END SUB


'##############
SUB GetWidth
'##############

	IF #LastPix > ImageFormat[#ImageSet,#dataFile].NumberOfPixels-1 THEN #LastPix=ImageFormat[#ImageSet,#dataFile].NumberOfPixels-1: #FirstPix=#LastPix-(ww/#col)
	over=#FirstPix+(ww/#col)
	IF (over>(ImageFormat[#ImageSet,#dataFile].NumberOfPixels-1)) THEN #FirstPix=#FirstPix-(over-(ImageFormat[#ImageSet,#dataFile].NumberOfPixels-1))
	IF #FirstPix<0 THEN #FirstPix=0

	firstp=#FirstPix
	lastp=(firstp+(ww/#col))

	IF (lastp > (ImageFormat[#ImageSet,#dataFile].NumberOfPixels-1)) THEN
				lastp=(ImageFormat[#ImageSet,#dataFile].NumberOfPixels-1)
				firstp=lastp-(ww/#col)
	END IF

	IF firstp<0 THEN firstp=0
	w=(lastp-firstp)*#col

	SELECT CASE TRUE
			CASE w<65  		: width=64
			CASE w<129  	: width=128
			CASE w<257 		: width=256
			CASE w<385	  : width=384
			CASE w<513	  : width=512
			CASE w<641	  : width=640
			CASE w<769  	: width=768
			CASE w<897  	: width=896
			CASE w<929  	: width=928
			CASE w<1025 	: width=1024
			CASE w<1153 	: width=1152
			CASE w<1281 	: width=1280
			CASE w<1537 	: width=1536
			CASE w<2049 	: width=2048
			CASE w<3073 	: width=3072
			CASE w<4097 	: width=4096
			CASE w<6145 	: width=6144
			CASE w<8193 	:	width=8192
			CASE w>8192		:	width=ImageFormat[#ImageSet,#dataFile].NumberOfPixels-1
	END SELECT

END SUB


'##############
SUB GetHeight				' and a little more
'##############

	height=hh+1: IF height>(ImageFormat[#ImageSet,#dataFile].NumberOfTracks*#row) THEN height=ImageFormat[#ImageSet,#dataFile].NumberOfTracks*#row

	z=#row
	firsttrack=#FirstTrack
	lasttrack=(#FirstTrack+(height/z))

	IF lasttrack> (ImageFormat[#ImageSet,#dataFile].NumberOfTracks-1) THEN
				lasttrack=ImageFormat[#ImageSet,#dataFile].NumberOfTracks-1: #LastTrack=lasttrack
				firsttrack=lasttrack-(hh/z): #FirstTrack=firsttrack
	END IF

	IF firsttrack<0 THEN firsttrack=0

END SUB


'##############
SUB InitIv
'##############

	IF #imageMode=3 THEN top=37
	IF #imageMode=2 THEN top=123
	IF #imageMode=1 THEN top=255

	mu=top/(#MaxVi!-#MinVi!)
	ipos=54
	col=#col

	GOSUB GetHeight
	GOSUB GetWidth

	IF (UBOUND (temp[]) <> (width*5)) THEN DIM temp[width*5]		' temp[] = one row

END SUB


END FUNCTION
'
'
' ###########################
' #####  ShowFields ()  #####
' ###########################
'
FUNCTION ShowFields (set,Image dataset[])
	SHARED Image ImageFormat[]

'	 mainly for debugging but will later expand into a fully spec'd user presentable window

	IFZ #spec THEN RETURN

		PRINT "#########################################"
		PRINT "title", ImageFormat[#ImageSet,set].title
		PRINT "version[0]", ImageFormat[#ImageSet,set].version[0]
		PRINT "type", ImageFormat[#ImageSet,set].type
		PRINT "active", ImageFormat[#ImageSet,set].active			' valid header
		PRINT "activeB", ImageFormat[#ImageSet,set].activeB		' original active
		PRINT "structureVersion", ImageFormat[#ImageSet,set].structureVersion
		PRINT "timedate", ImageFormat[#ImageSet,set].timedate
		PRINT "temperature", ImageFormat[#ImageSet,set].temperature
		PRINT "head", ImageFormat[#ImageSet,set].head
		PRINT "storeType", ImageFormat[#ImageSet,set].storeType
		PRINT "dataType", ImageFormat[#ImageSet,set].dataType
		PRINT "mode", ImageFormat[#ImageSet,set].mode
		PRINT "triggerSource", ImageFormat[#ImageSet,set].triggerSource
		PRINT "trigger_level", ImageFormat[#ImageSet,set].trigger_level
		PRINT "exposure_time", ImageFormat[#ImageSet,set].exposure_time
		PRINT "delay", ImageFormat[#ImageSet,set].delay
		PRINT "integrationCycleTime", ImageFormat[#ImageSet,set].integrationCycleTime
		PRINT "noIntegrations", ImageFormat[#ImageSet,set].noIntegrations
		PRINT "sync", ImageFormat[#ImageSet,set].sync
		PRINT "kineticCycleTime", ImageFormat[#ImageSet,set].kineticCycleTime
		PRINT "pixelReadoutTime", ImageFormat[#ImageSet,set].pixelReadoutTime
		PRINT "noPoints", ImageFormat[#ImageSet,set].noPoints
		PRINT "fastTrackHeight", ImageFormat[#ImageSet,set].fastTrackHeight
		PRINT "gain", ImageFormat[#ImageSet,set].gain
		PRINT "gateDelay", ImageFormat[#ImageSet,set].gateDelay
		PRINT "gateWidth", ImageFormat[#ImageSet,set].gateWidth
		PRINT "gateStep", ImageFormat[#ImageSet,set].gateStep
		PRINT "trackHeight", ImageFormat[#ImageSet,set].trackHeight
		PRINT "seriesLenght", ImageFormat[#ImageSet,set].seriesLenght		' typo
		PRINT "readPattern", ImageFormat[#ImageSet,set].readPattern
		PRINT "shutterDelay", ImageFormat[#ImageSet,set].shutterDelay
		PRINT "stCentreRow", ImageFormat[#ImageSet,set].stCentreRow
		PRINT "mtOffset", ImageFormat[#ImageSet,set].mtOffset
		PRINT "operationMode", ImageFormat[#ImageSet,set].operationMode
		PRINT "flipX", ImageFormat[#ImageSet,set].flipX
		PRINT "flipY", ImageFormat[#ImageSet,set].flipY
		PRINT "clock", ImageFormat[#ImageSet,set].clock
		PRINT "aClock", ImageFormat[#ImageSet,set].aClock
		PRINT "Mcp", ImageFormat[#ImageSet,set].Mcp
		PRINT "prop", ImageFormat[#ImageSet,set].prop
		PRINT "ioc", ImageFormat[#ImageSet,set].ioc
		PRINT "freq", ImageFormat[#ImageSet,set].freq
		PRINT "detectorModel", ImageFormat[#ImageSet,set].detectorModel
		PRINT "detectorFormatX", ImageFormat[#ImageSet,set].detectorFormatX
		PRINT "detectorFormatZ", ImageFormat[#ImageSet,set].detectorFormatZ
		PRINT "filename", LEFT$(ImageFormat[#ImageSet,set].filename,ImageFormat[#ImageSet,set].filenameLen)
		PRINT "filenameLen", ImageFormat[#ImageSet,set].filenameLen
		PRINT "userText", LEFT$(ImageFormat[#ImageSet,set].userText,ImageFormat[#ImageSet,set].userTextLen)
		PRINT "userTextLen", ImageFormat[#ImageSet,set].userTextLen
		PRINT "shutterType", ImageFormat[#ImageSet,set].shutterType
		PRINT "shutterMode", ImageFormat[#ImageSet,set].shutterMode
		PRINT "shutterCustomBgMode", ImageFormat[#ImageSet,set].shutterCustomBgMode
		PRINT "shutterCustomMode", ImageFormat[#ImageSet,set].shutterCustomMode
		PRINT "shutterClosingTime", ImageFormat[#ImageSet,set].shutterClosingTime
		PRINT "shutterOpeningTime", ImageFormat[#ImageSet,set].shutterOpeningTime
		PRINT "xType", ImageFormat[#ImageSet,set].xType
		PRINT "xUnit", ImageFormat[#ImageSet,set].xUnit
		PRINT "yType", ImageFormat[#ImageSet,set].yType
		PRINT "yUnit", ImageFormat[#ImageSet,set].yUnit
		PRINT "zType", ImageFormat[#ImageSet,set].zType
		PRINT "zUnit", ImageFormat[#ImageSet,set].zUnit
		PRINT "xCal[3]", ImageFormat[#ImageSet,set].xCal[3]
		PRINT "yCal[3]", ImageFormat[#ImageSet,set].yCal[3]
		PRINT "zCal[3]", ImageFormat[#ImageSet,set].zCal[3]
		PRINT "rayleighWavelength", ImageFormat[#ImageSet,set].rayleighWavelength
		PRINT "pixelLenght", ImageFormat[#ImageSet,set].pixelLenght
		PRINT "pixelHeight", ImageFormat[#ImageSet,set].pixelHeight
		PRINT "xText", ImageFormat[#ImageSet,set].xText
		PRINT "yText", ImageFormat[#ImageSet,set].yText
		PRINT "zText", ImageFormat[#ImageSet,set].zText
		PRINT "left", ImageFormat[#ImageSet,set].left
		PRINT "top", ImageFormat[#ImageSet,set].top
		PRINT "right", ImageFormat[#ImageSet,set].right
		PRINT "bottom", ImageFormat[#ImageSet,set].bottom
		PRINT "hBin", ImageFormat[#ImageSet,set].hBin
		PRINT "vBin", ImageFormat[#ImageSet,set].vBin
		PRINT "numberOfImages", ImageFormat[#ImageSet,set].numberOfImages
		PRINT "numberOfSubImages", ImageFormat[#ImageSet,set].numberOfSubImages
		PRINT "totalLenght", ImageFormat[#ImageSet,set].totalLenght
		PRINT "imageLenght", ImageFormat[#ImageSet,set].imageLenght
		PRINT "dataset.NumberOfPixels", ImageFormat[#ImageSet,set].NumberOfPixels
		PRINT "dataset.NumberOfTracks", ImageFormat[#ImageSet,set].NumberOfTracks
		PRINT "dataStart", ImageFormat[#ImageSet,set].dataStart
		PRINT "datatype", ImageFormat[#ImageSet,set].datatype
		PRINT "first pixel ",ImageFormat[#ImageSet,set].bLeft
		PRINT "last pixel ",ImageFormat[#ImageSet,set].bRight
		PRINT "data blocks ",ImageFormat[#ImageSet,set].totalimages
		PRINT	"set",set
		PRINT "#########################################"

END FUNCTION
'
'
' ##########################
' #####  AutoScale ()  #####
' ##########################
'
' find the min and max data points of each track to enable correct scaling of that track.
'
FUNCTION  AutoScale (slot,track)
		SHARED Image ImageFormat[]
		SHARED MemDataSet ImageDataSet[]
		SHARED SINGLE hh
		AUTO SINGLE a


ds=ImageDataSet[slot].DataSet
startpix=GetPixelAddress (slot,ImageFormat[slot,ds].fPixel+1,track)
endpix=GetPixelAddress (slot,ImageFormat[slot,ds].lPixel+1,track)

a=SINGLEAT (startpix)
ImageDataSet[slot].MaxValue=a					' we do need a starting point
ImageDataSet[slot].MinValue=a
'ImageDataSet[slot].uMaxValue=a					' we do need a starting point
'ImageDataSet[slot].uMinValue=a

FOR x = startpix TO endpix STEP 4		' find the highest and lowest point then store

		a=SINGLEAT (x)
		IF a > ImageDataSet[slot].MaxValue THEN ImageDataSet[slot].MaxValue=a
		IF a < ImageDataSet[slot].MinValue THEN ImageDataSet[slot].MinValue=a

NEXT x

IF ImageDataSet[slot].MaxValue<=ImageDataSet[slot].MinValue THEN ImageDataSet[slot].MaxValue=ImageDataSet[slot].MinValue+1	' divide by zero check
setTrackVoffset (slot)

'ImageDataSet[slot].uMinValue=ImageDataSet[slot].MinValue
'ImageDataSet[slot].uMaxValue=ImageDataSet[slot].MaxValue

END FUNCTION
'
'
' #############################
' #####  AutoScaleAll ()  #####
' #############################
'
FUNCTION  AutoScaleAll (slot)
	SHARED Image ImageFormat[]
	SHARED MemDataSet ImageDataSet[]
	SHARED SINGLE hh
	SHARED TrackData TrackInfo[]
	SINGLE MaxV,MinV

' find the highest and lowest data point over all tracks
'	used for image scaling.
'	check AutoScale() for more info

ds=ImageDataSet[slot].DataSet
DIM TrackInfo [ImageFormat[slot,ds].NumberOfTracks]


GetPixelValue (slot,1,1,@a!)
totalmax!=a!
totalmin!=a!
ImageDataSet[slot].MinValue=a!
ImageDataSet[slot].MaxValue=a!
'ImageDataSet[slot].uMinValue=a!
'ImageDataSet[slot].uMaxValue=a!
#minTrack=0
#maxTrack=0
fp=ImageFormat[slot,ds].fPixel

FOR track = 0 TO ImageFormat[slot,ds].NumberOfTracks-1

		startpix=ImageFormat[slot,ds].fPixel
		endpix=ImageFormat[slot,ds].lPixel

		GetPixelValue (slot,fp+1,track+1,a!)
		MaxV=a!
		MinV=a!

		FOR pos = startpix TO endpix

				GetPixelValue (slot,pos+1,track+1,@a!)

				IF a! > MaxV THEN
							MaxV=a!: TrackInfo[track].MaxPixel=(pos-startpix)+fp
							IF a! >= totalmax! THEN totalmax!=a!: #maxTrack=track
				ELSE

							IF a! < MinV THEN
										MinV=a!: TrackInfo[track].MinPixel=(pos-startpix)+fp
										IF a! < totalmin! THEN totalmin!=a!: #minTrack=track
							END IF
				END IF

		NEXT pos

		IF MaxV >=ImageDataSet[slot].MaxValue THEN
					ImageDataSet[slot].MaxValue = MaxV
					'ImageDataSet[slot].uMaxValue = MaxV
		END IF

		IF MinV <=ImageDataSet[slot].MinValue THEN
					ImageDataSet[slot].MinValue = MinV
					'ImageDataSet[slot].uMinValue = MinV
		END IF

		IF MaxV<=MinV THEN MaxV=MaxV+1		' divide by zero check

		TrackInfo[track].MaxPoint=MaxV
		TrackInfo[track].MinPoint=MinV

NEXT track

TrackInfo[0].valid=1

'PRINT ImageDataSet[slot].MaxValue,ImageDataSet[slot].MinValue
'PRINT ImageDataSet[slot].uMaxValue,ImageDataSet[slot].uMinValue



END FUNCTION
'
'
' ###########################
' #####  CalBlemish ()  #####
' ###########################
'
FUNCTION  CalBlemish (left,right,top,bottom)
	SHARED Image ImageFormat[]
	SHARED XLONG Tave
	SINGLE total,ave
	SHARED MemDataSet ImageDataSet[]
	XLONG p


IF ImageFormat[#ImageSet,#dataFile].NumberOfTracks <2 THEN EXIT FUNCTION
DIM #CalBlemAve![ImageFormat[#ImageSet,#dataFile].NumberOfTracks-bottom+1]
Tave=0
dataa=ImageDataSet[#ImageSet].ImageSetAd
p=ImageFormat[#ImageSet,#dataFile].NumberOfPixels

FOR track = bottom TO top

		total=0
		FOR x = left TO right
					total=total+SINGLEAT (dataa+((((track-1)*p)+(x-1))*4))
 					'GetPixelValue (#ImageSet,x,track,value)
		NEXT x

		ave=total/(right-left)
		IF ave<1 THEN ave=1
		#CalBlemAve![track-1]=ave
		Tave=Tave+ave

NEXT track

Tave=Tave/(top-bottom)

END FUNCTION
'
'
' ###############################
' #####  CalBlemishSpec ()  #####
' ###############################
'
FUNCTION  CalBlemishSpec (left,right,top,bottom,SINGLE spec)
	SHARED TrackData TrackInfoCopy[]
	SHARED TrackData TrackInfo[]
	SHARED BlemSpot Blemish[]
	SHARED Image ImageFormat[]
	XLONG  total,ave,ave2,ub,l,r
	SINGLE a
	SHARED XLONG Tave
	SHARED MemDataSet ImageDataSet[]


IF ImageFormat[#ImageSet,#dataFile].NumberOfTracks <2 THEN EXIT FUNCTION

DIM Blemish[ImageFormat[#ImageSet,#dataFile].NumberOfPixels]
count=0
sig=0
#totalvoffset=0
#Voffset=0
ub=UBOUND(Blemish[])
dataa=ImageDataSet[#ImageSet].ImageSetAd

l=left-1
r=right-1

StartTimer (@tindex, time)

FOR track=bottom-1 TO top-1

		ave=#CalBlemAve![track]*spec
		ave2=#CalBlemAve![track]/spec
	'	sig=0

		FOR x = l TO r

				'	a=GetPixelValue (#ImageSet,x+1,track+1,v)
					a=SINGLEAT (dataa+(((track*ImageFormat[#ImageSet,#dataFile].NumberOfPixels)+x)*4))

					IF ((a<ave) OR (a>ave2)) THEN

								INC count
								IF (count > ub) THEN REDIM Blemish[count+32]: ub=count+32

								Blemish[count].pixel=x+1
								Blemish[count].track=track+1
								Blemish[count].value=a
							'	sig=1

					END IF

		NEXT x

		IF #IsLib=$$FALSE THEN
				IF #BlemPro=0 THEN
							IF CheckTimer (tindex,time) > #BlemTimeout THEN #BlemPro=1: PopUpBox ("Blem check in progress","Processing...","Halt!","Quit",9)
				ELSE
							XgrProcessMessages (-2)
							IF #CancelBlem=1 THEN EXIT FOR
				END IF
		END IF

	'	IF sig=1 THEN GOSUB ShowBlmTrack

NEXT track

 PRINT CheckTimer (tindex,time)

EndTimer (tindex,time)
REDIM Blemish[count+1]
Blemish[0].total=count

EXIT FUNCTION


'#################
SUB ShowBlmTrack
'#################

	'XstSleep(100)
	ImageDataSet[#ImageSet].Track=track
	sig=0

	IF TrackInfo[0].valid=0 THEN ScaleAllTracksCalc (#ImageSet)

	ImageDataSet[#ImageSet].MinValue=TrackInfoCopy[track].MinPoint
	ImageDataSet[#ImageSet].MaxValue=TrackInfoCopy[track].MaxPoint
	setTrackVoffset (#ImageSet)

	GotoPixel2d (Blemish[count].pixel,Blemish[count].track)

END SUB

END FUNCTION
'
'
' ##################################
' #####  CalBlemishDisplay ()  #####
' ##################################
'
FUNCTION  CalBlemishDisplay ()
	SHARED BlemSpot Blemish[]
	SHARED Image ImageFormat[]
	SHARED XLONG Tave

	IF ImageFormat[#ImageSet,#dataFile].NumberOfTracks <2 THEN EXIT FUNCTION

	count=Blemish[0].total
	lf$=CHR$(0x0D)+CHR$(0x0A)
	XstDecomposePathname (#fil$, path$, parent$, filename$, @Fn$, fileExt$)
	XstMakeDirectory ("c:\\testdata")
	filename$="c:\\testdata\\"+Fn$+".txt"
	IF count<>1 THEN ct$="'s " ELSE ct$=" "
	string$=#fil$+lf$+lf$+STRING$(count)+" Blemish"+ct$+lf$+STRING$(Tave)+" cts average signal level"+lf$+lf$

	fn=OPEN (filename$, $$WRNEW)
	WRITE [fn],string$

	IF count>0 THEN

			FOR pos=1 TO count
						x$="x "+STRING$(Blemish[pos].pixel)
						y$="y "+STRING$(Blemish[pos].track)
						cts$=" "+STRING$(Blemish[pos].value)+" cts"

						SELECT CASE LEN(x$)
								CASE	3				:x$=x$+"    "
								CASE	4				:x$=x$+"   "
								CASE	5				:x$=x$+"  "
								CASE	6				:x$=x$+" "
						END SELECT

						SELECT CASE LEN(y$)
								CASE	3				:y$=y$+"    "
								CASE	4				:y$=y$+"   "
								CASE	5				:y$=y$+"  "
								CASE	6				:y$=y$+" "
						END SELECT

						string$=x$+y$+cts$+lf$
						WRITE [fn],string$
			NEXT pos

	END IF

	CloseFilefn (fn)
	SHELL (":notepad "+filename$)

END FUNCTION
'
'
' #############################
' #####  GetBlemSpots ()  #####
' #############################
'
FUNCTION  GetBlemSpots (left,right, top, bottom,SINGLE spec)
	SHARED T_Index,BlemTimer

	#BlemPro=0
	#CancelBlem=0

	CalBlemish (left,right,top,bottom)
	CalBlemishSpec (left,right,top,bottom,spec)
	CalBlemishDisplay ()

	IF #IsLib=$$FALSE THEN HideWindow (#MessageWindow)

END FUNCTION
'
'
' #####################
' #####  Blem ()  #####
' #####################
'
FUNCTION Blem (file$)				' file$ should contain the path of a valid cxxxxbs.sif file
	SHARED Image ImageFormat[]

	ExtractFileTypeInfo (file$,index)
	#dataFile=ImageFormat[index,0].firstdataset
	setDefaultPixRange (#ImageSet)
	ReadFile (#fil$,index,#dataFile)
	SetImageIndex (#ImageSet)

	GetBlemSpots (6,ImageFormat[#ImageSet,#dataFile].NumberOfPixels-5,ImageFormat[#ImageSet,#dataFile].NumberOfTracks-5,6,0.75)

	QUIT(0)

END FUNCTION
'
'
' #############################
' #####  SetKidFields ()  #####
' #############################
'
FUNCTION  SetKidFields (g)

	XuiSendMessage ( g, #SetStyle, 3, 3, 0, 0, 0, 0)
'	XuiSendMessage ( g, #Setcolor, #bColour,#bInk ,#bColour ,$$White, 0, 0)
'	XuiSendMessage ( g, #SetColorExtra, #bSelect, #bSelect, #bSelect, #bSelect, 0, 0)
	XuiSendMessage ( g, #SetBorder, $$BorderFlat1, $$BorderFlat1, $$BorderLower1, 0, 0, 0)
	XuiSendMessage ( g, #SetTexture, $$TextureNone, 0, 0, 0, 0, 0)


END FUNCTION
'
'
' ##############################
' #####  ResizeWindows ()  #####
' ##############################
'
FUNCTION  ResizeWindows ()
	SHARED SINGLE hh,ww,vcolstatus
	SHARED Image ImageFormat[]


	IF #currentDisplay=2 THEN
				#topmargin=#defaultTopI
				#bottommargin=#defaultBottomI
	ELSE
				#topmargin=#defaultTop
				#bottommargin=#defaultBottom
	END IF

	vw=#v2-(#rightmargin+#leftmargin)-5
	vh=#v3-#bottommargin
	hh=vh
	ww=vw
	#imagehh=vh
	#imageww=vw

	XgrSetGridPositionAndSize (#memBuffer, 0, 0, vw+1, vh+1)	' memory image
	XgrSetGridPositionAndSize	(#vColbarBuff,0,0,10,vh+1): vcolstatus=0
	XgrSetGridPositionAndSize	(#hColbarBuff,0,0,vw,10): #vbarRedraw=1

	XuiSendMessage (#OutputG, #Resize, #leftmargin, #topmargin, vw+1, vh+1, 7, 0)	' $Label/#image
	XuiSendMessage (#OutputG, #Resize, #leftmargin, #defaultTopI-33, vw-5, 16, 38, 0)		'colourbar

	IF ImageFormat[#ImageSet,]<>0 THEN
			IF ImageFormat[#ImageSet,#dataFile].NumberOfTracks>1 THEN
					XuiSendMessage (#Output,#Resize,ww+#leftmargin+10,#topmargin,18, 18, 44, 0)		'closeds
					XuiSendMessage (#Output,#Resize,vw+#leftmargin+10,#topmargin+22,17,vh+3-24,9,0) 'v scroll
				'	XuiSendMessage (#Output,#Redraw, 0, 0, 0, 0, 9, 0)
			ELSE
					XuiSendMessage (#Output,#Resize,ww+#leftmargin+6,#topmargin,18, 18, 44, 0)  'closeds
			END IF
	END IF

	BuffMenuBotton ()

'	XgrGetWindowPositionAndSize (#OutputWindow, @x,@y,width,height)
'	XgrSetWindowPositionAndSize (#ModScaleMinWindow,x+#leftmargin-22,y+14,-1,-1)
'	XgrSetWindowPositionAndSize (#ModScaleMaxWindow,8+x+ww+#leftmargin,y+14,-1,-1)


END FUNCTION
'
'
' #########################
' #####  ReadFile ()  #####
' #########################
'
FUNCTION  ReadFile (file$,index,dataset)
	SHARED Image ImageFormat[]
	SHARED MemDataSet ImageDataSet[]
	SHARED SINGLE ImageSet[]


	SELECT CASE ImageFormat[index,0].ptype			' remember little&big ed
			CASE 0					:GOSUB Get32flt
			CASE 1					:GOSUB Get32int
			CASE 2					:GOSUB Get16int
			CASE 3					:GOSUB Get32int
			CASE 4					:GOSUB Get16int
			CASE 5					:GOSUB GetNULL: RETURN index
			CASE ELSE				:RETURN 1  ' we have a problem, unable to load file?
	END SELECT

	AddDataSetToSlot (index,dataset)
	ImageDataSet[index].fPixel=1
	ImageDataSet[index].lPixel=ImageFormat[index,dataset].NumberOfPixels

RETURN index


'#####################
SUB Get32flt
'#####################

	clearImageSetSlot (index)

	datastart=ImageFormat[index,dataset].dataStart
	total=ImageFormat[index,dataset].totalLenght
	DIM #DataSet![total-1]


	fn2=OPEN (file$, $$RDSHARE)

	SEEK (fn2,datastart)
	READ [fn2],#DataSet![]

	CLOSE(fn2)

END SUB


'#####################
SUB Get32int
'#####################

	clearImageSetSlot (index)

	pix=0
	tpixs=(ImageFormat[index,dataset].NumberOfPixels-1)*4
	int$=NULL$(ImageFormat[index,dataset].NumberOfPixels*4)
	datastart=ImageFormat[index,dataset].dataStart
	total=ImageFormat[index,dataset].totalLenght


	DIM #DataSet![total-1]

	fn2=OPEN (file$, $$RDSHARE)
	SEEK (fn2,datastart)

	IF ImageFormat[index,0].ptype=2 THEN
			FOR trk=1 TO ImageFormat[index,dataset].NumberOfTracks
					READ [fn2],int$

					FOR pos=0 TO tpixs STEP 4
							#DataSet![pix]=SLONGAT (&int$+pos)
							INC pix
					NEXT pos
			NEXT trk
	ELSE
			FOR trk=1 TO ImageFormat[index,dataset].NumberOfTracks
					READ [fn2],int$

					FOR pos=0 TO tpixs STEP 4
							#DataSet![pix]=ULONGAT (&int$+pos)
							INC pix
					NEXT pos
			NEXT trk
	END IF


	CLOSE(fn2)
	int$=""

END SUB


'#####################
SUB Get16int
'#####################

	clearImageSetSlot (index)

	pix=0
	tpixs=(ImageFormat[index,dataset].NumberOfPixels-1)*2
	int$=NULL$(ImageFormat[index,dataset].NumberOfPixels*2)
	datastart=ImageFormat[index,dataset].dataStart
	total=ImageFormat[index,dataset].totalLenght

	DIM #DataSet![total-1]

	fn2=OPEN (file$, $$RDSHARE)
	SEEK (fn2,datastart)

	IF ImageFormat[index,0].ptype=2 THEN
			FOR trk=1 TO ImageFormat[index,dataset].NumberOfTracks
					READ [fn2],int$

					FOR pos=0 TO tpixs STEP 2
							#DataSet![pix]=SSHORTAT (&int$+pos)
							INC pix
					NEXT pos
			NEXT trk
	ELSE
			FOR trk=1 TO ImageFormat[index,dataset].NumberOfTracks
					READ [fn2],int$

					FOR pos=0 TO tpixs STEP 2
							#DataSet![pix]=USHORTAT (&int$+pos)
							INC pix
					NEXT pos
			NEXT trk
	END IF


	CLOSE(fn2)
	int$=""

END SUB


'#####################
SUB GetNULL
'#####################

	IF ImageSet[slot,]<>0 THEN ATTACH ImageSet[index,] TO null![]: DIM null![]
	AddDataSetToSlot (index,dataset)
	ImageDataSet[index].fPixel=1
	ImageDataSet[index].lPixel=ImageFormat[index,dataset].NumberOfPixels

'	RETURN 0

END SUB




END FUNCTION
'
'
' #########################
' #####  LoadFile ()  #####
' #########################
'
FUNCTION  LoadFile (file$,index)
	SHARED Image ImageFormat[]
	SHARED MemDataSet ImageDataSet[]


	XstDecomposePathname (file$, @path$, @parent$, @#filename$, fle$, FileExt$)
	dir$=path$+"\\"
	XstSetCurrentDirectory	(dir$)

	slot=CreateDataSlot (0,0)
	IF (ExtractFileTypeInfo (file$,slot) <> 0) THEN
				DeleteDataSet (slot)
				RETURN 1			' load failed
	ELSE
				MoveDataSetTo (slot,index)
	END IF


	IF ((#exitProgram<>1) AND (#DatInfoState<>100)) THEN
				#dataFile=ImageFormat[index,0].firstdataset

				FOR slot=0 TO UBOUND(ImageDataSet[])
						ImageDataSet[slot].stDisplay=0
				NEXT slot

				ImageDataSet[index].stDisplay=1
			'	ImageDataSet[pos].stDisplayOL=0
				ImageDataSet[index].clr2d=#ink

				#fil$=file$
				SetImageIndex (index)
				IF #IsLib=$$FALSE THEN SetProgramTitle (file$)
				InitVariables ()
				setfileBThints ()
	END IF

	RETURN 0

END FUNCTION
'
'
' #############################
' #####  ParseFitFile ()  #####
' #############################
'
FUNCTION  ParseFitFile ()
	SHARED Image ImageFormat[]
	SHARED dataskip,datastart
'	SHARED data$


'	OpenFile()

'	dataskip=0
'	datastart=2879

	PopUpBox (#fil$,".fit unsupported\n(TODO)", "Retry","Quit",1): #exitProgram=1: EXIT FUNCTION
' beginning this code soon once i have obtained the full specs and a few other non local examples.


'ImageFormat[#ImageSet,#dataFile].NumberOfTracks=1 ' 280
'ImageFormat[#ImageSet,#dataFile].NumberOfPixels=560
'ImageFormat[#ImageSet,#dataFile].bLeft=1
'ImageFormat[#ImageSet,#dataFile].bRight=ImageFormat[#ImageSet,#dataFile].NumberOfPixels
'#type=0
'#spec=-1
'#dataFile=1
'ImageFormat[#ImageSet,0].firstdataset=0


END FUNCTION
'
' #############################
' #####  ParseAscFile ()  #####
' #############################
'
FUNCTION  ParseAscFile ()
	SHARED Image ImageFormat[]

' to rewrite using a single loop function instead of two. ie without the x/y swap

EXIT FUNCTION
'	OpenFile()

	#type=3
	#spec=-1
	tracks=0
	pix=0
	dataskip=0
	datastart=0

	DIM temp![#len/4]

	FOR after=2 TO #len-2

			IF (data${after-1}=13) || (data${after}=13) THEN

					INC tracks
					INC after
					XstStringToNumber (@data$,after,@after,type,@a)
					INC after

			END IF

			XstStringToNumber (@data$,after,@after,type,@a!)
			temp![pix]=a!

			INC pix

	NEXT after

	DEC  pix

	IF tracks<1 THEN tracks=1

	ImageFormat[#ImageSet,#dataFile].NumberOfTracks=tracks
	ImageFormat[#ImageSet,#dataFile].NumberOfPixels=(pix/ImageFormat[#ImageSet,#dataFile].NumberOfTracks)

	REDIM temp![pix]
	DIM #DataSet![pix]

	x=0
	y=0
	tk=0

	DO

			#DataSet![x]=temp![y]
			INC x
			y=y+tracks

			IF y > (tracks*ImageFormat[#ImageSet,#dataFile].NumberOfPixels-1) THEN INC tk: y=tk

	LOOP UNTIL (x > (pix-1))

	ImageFormat[#ImageSet,#dataFile].NumberOfPixels=y
	ImageFormat[#ImageSet,#dataFile].NumberOfTracks=(pix/ImageFormat[#ImageSet,#dataFile].NumberOfTracks)
	ImageFormat[#ImageSet,#dataFile].bLeft=1
	ImageFormat[#ImageSet,#dataFile].bRight=ImageFormat[#ImageSet,#dataFile].NumberOfPixels
	ImageFormat[#ImageSet,0].firstdataset=0

	data$=NULL$(0)
	REDIM temp![0]


END FUNCTION
'
'
' #############################
' #####  ParseDatFile ()  #####
' #############################
'
FUNCTION  ParseDatFile (file$,Image dataset[],errorstate)
'	SHARED Image ImageFormat[]
' to rewrite using a modal window

	$pixelin=7
	$trackin=9
	$xlabelin=10
	$ylabelin=11
	$datastartin=12
	#filetype = 3

	SELECT CASE #DatInfoState
		CASE  1			:#DatInfoState=0
								XgrHideWindow (#GetRawInfoWindow)
								XuiSendMessage (#GetRawInfo,#GetTextString,0,0,0,0,$pixelin,@pix$)
								XuiSendMessage (#GetRawInfo,#GetTextString,0,0,0,0,$trackin,@trk$)
								XuiSendMessage (#GetRawInfo,#GetTextString,0,0,0,0,$xlabelin,@xtxt$)
								XuiSendMessage (#GetRawInfo,#GetTextString,0,0,0,0,$ylabelin,@ytxt$)
								XuiSendMessage (#GetRawInfo,#GetTextString,0,0,0,0,$datastartin,@datastart$)
								XstStringToNumber (datastart$,0,0,type,@datastart)
								XstStringToNumber (pix$,0,0,type,@pixels)
								XstStringToNumber (trk$,0,0,type,@tracks)
		CASE  3 		:#DatInfoState=0

		CASE  ELSE	:#datfile$=file$
								DisplayWindow (#GetRawInfoWindow)
								errorstate=200
							'	#DatInfoState = 100
								RETURN errorstate
	END SELECT

	DIM dataset[1]
	errorstate=0

'	IF ImageFormat[#ImageSet,#dataFile].NumberOfTracks<1 THEN errorstate=5: RETURN errorstate
'	IF ImageFormat[#ImageSet,#dataFile].NumberOfPixels<2 THEN errorstate=9: RETURN errorstate

	dataset[0].totaldatasets=1
	dataset[0].firstdataset=0
	dataset[0].totalimages=1
	dataset[0].bLeft=1
	dataset[0].left=1
	dataset[0].bRight=pixels
	dataset[0].right=pixels
	dataset[0].top=tracks
	dataset[0].NumberOfTracks=tracks
	dataset[0].NumberOfPixels=pixels
	dataset[0].totalLenght=tracks*pixels
	dataset[0].imageLenght=tracks*pixels 'dataset[0].totalLenght
	dataset[0].numberOfSubImages=1
	dataset[0].numberOfImages=1
	dataset[0].xText=xtxt$					' "Pixel number"
	dataset[0].yText=ytxt$					' "Counts"
	dataset[0].datatype="Sig"
	dataset[0].dataStart=datastart
	dataset[0].xCal[0]=0
	dataset[0].xCal[1]=1
	dataset[0].active=1
	dataset[0].hBin=1
	dataset[0].vBin=1
	dataset[0].ptype= #RawInfoDataType
	dataset[0].filen=file$

END FUNCTION
'
'
' ############################
' #####  ParseIIFile ()  #####
' ############################
'
FUNCTION  ParseIIFile (file$,Image dataset[],errorstate)
	iiheader IIheader

	DIM dataset[1]
	pos=0
	errorstate=0
	NumberOfTracks=0

	OpenFilefn (file$,@fn2)	'			fn2 = file number
	GOSUB GetData
	CloseFilefn (fn2)

	dataset[0].totaldatasets=1
	dataset[0].firstdataset=0
	dataset[0].totalimages=1
	dataset[0].bLeft=1
	dataset[0].left=1
	dataset[0].bRight=NumberOfPixels
	dataset[0].right=NumberOfPixels
	dataset[0].top=NumberOfTracks
	dataset[0].NumberOfTracks=NumberOfTracks
	dataset[0].NumberOfPixels=NumberOfPixels
	dataset[0].totalLenght=NumberOfPixels*NumberOfTracks
	dataset[0].imageLenght=dataset[0].totalLenght
	dataset[0].numberOfSubImages=1
	dataset[0].numberOfImages=1
	dataset[0].xText="Pixel number"
	dataset[0].yText="Counts"
	dataset[0].datatype="Sig"
	dataset[0].dataStart=datastart
	dataset[0].xCal[0]=0
	dataset[0].xCal[1]=1
	dataset[0].active=1
	dataset[0].hBin=1
	dataset[0].vBin=1
	dataset[0].ptype=5
	dataset[0].filen=file$

 RETURN errorstate


'#####################
SUB GetData
'#####################

	DO
			GOSUB GetHeader

			IF ((IIheader.validity<>"THDM") AND (NumberOfTracks=0)) THEN errorstate=8: RETURN errorstate

			IF IIheader.active=0 THEN
						INC NumberOfTracks
						GOSUB GetStore
			ELSE
						EXIT DO
			END IF

	LOOP UNTIL ((IIheader.active<>0) OR (POF(fn2)>(LOF(fn2)-10)))

END SUB


'#####################
SUB GetHeader
'#####################

	READ [fn2],IIheader

IF #DebugLevel=1 THEN
	PRINT "IIheader.type",IIheader.type
	PRINT "IIheader.active",IIheader.active
	PRINT "IIheader.validity",IIheader.validity
	PRINT "IIheader.version",IIheader.version
	PRINT "IIheader.H_type",IIheader.H_type
	PRINT "IIheader.H_unit",IIheader.H_unit
	PRINT "IIheader.V_type",IIheader.V_type
	PRINT "IIheader.cal[0]",IIheader.cal[0]
	PRINT "IIheader.cal[1]",IIheader.cal[1]
	PRINT "IIheader.cal[2]",IIheader.cal[2]
	PRINT "IIheader.cal[3]",IIheader.cal[3]
	PRINT "IIheader.t",IIheader.t
	PRINT "IIheader.year",IIheader.year
	PRINT "IIheader.d",IIheader.d
	PRINT "IIheader.diodes",IIheader.diodes
	PRINT "IIheader.first_diode",IIheader.first_diode
	PRINT "IIheader.width_diode",IIheader.width_diode
	PRINT "IIheader.comp",IIheader.comp
	PRINT "IIheader.store",IIheader.store
	PRINT "IIheader.pp",IIheader.pp
	PRINT "IIheader.pn",IIheader.pn
	PRINT "IIheader.label",IIheader.label
	PRINT "IIheader.Z_type",IIheader.Z_type
	PRINT "IIheader.Z_unit",IIheader.Z_unit
	PRINT "IIheader.mode",IIheader.mode
	PRINT "IIheader.trigger",IIheader.trigger
	PRINT "IIheader.trigger_level",IIheader.trigger_level
	PRINT "IIheader.sync",IIheader.sync
	PRINT "IIheader.exposure",IIheader.exposure
	PRINT "IIheader.misc1",IIheader.misc1
	PRINT "IIheader.misc2",IIheader.misc2
	PRINT "IIheader.misc3",IIheader.misc3
	PRINT "IIheader.head",IIheader.head
	PRINT "IIheader.series_position",IIheader.series_position
	PRINT "IIheader.series_length",IIheader.series_length
	PRINT "IIheader.filename",IIheader.filename
	PRINT "IIheader.temperature",IIheader.temperature
	PRINT "IIheader.v_start",IIheader.v_start
	PRINT "IIheader.v_bin",IIheader.v_bin
	PRINT "IIheader.h_start",IIheader.h_start
	PRINT "IIheader.h_bin",IIheader.h_bin
	PRINT "IIheader.spare",IIheader.spare
END IF

END SUB


'#####################
SUB GetStore
'#####################

		size=4
		NumberOfPixels=IIheader.width_diode

		start=POF(fn2)
		end=start+((NumberOfPixels-1)*size)
		ii$=SPACE$(size)

		REDIM #DataSet![((NumberOfTracks+1)*(NumberOfPixels-1))]

		IF IIheader.type=8 THEN

				FOR l=start TO end STEP size

						'	SEEK (fn2,l)
							READ [fn2],ii$
							#DataSet![pos]= SINGLEAT (&ii$)
							INC pos

				NEXT l

		ELSE

				FOR l=start TO end STEP size

						'	SEEK (fn2,l)
							READ [fn2],ii$
							#DataSet![pos]= SLONGAT (&ii$)
							INC pos

				NEXT l

		END IF

END SUB


END FUNCTION
'
'
' #############################
' #####  ParseSifFile ()  #####
' #############################
'
FUNCTION  ParseSifFile (file$, Image dataset[],errorstate)
	SHARED filler$,after
	SHARED SINGLE ww
	STATIC ident$,dset

	IF UBOUND(dataset[])<>#MaxDataSets THEN DIM dataset[#MaxDataSets]

	#DebugLevel=0
	after=-1
	errorstate=0
	filler$=SPACE$(40)

	IF (OpenFilefn (file$,@#fn2)) < 3 THEN errorstate=6
	IFZ errorstate THEN GOSUB formatIdent
	IFZ errorstate THEN GOSUB GetImages
	CloseFilefn (#fn2)

	RETURN errorstate

'###############
SUB GetDataSet
'###############

	dataset[dset].headerStart=after

	GetString (@after,@string$,10)								' do we have a data structure
	IF string$="1" THEN
				GOSUB GetData
				IF errorstate<>0 THEN EXIT SUB
				type=dset
	ELSE
				type=255
	END IF

	SELECT CASE type
			CASE $$Sig		:dataset[dset].datatype="Sig"
			CASE $$Ref		:dataset[dset].datatype="Ref"
			CASE $$Bg			:dataset[dset].datatype="Bg"
			CASE $$Liv		:dataset[dset].datatype="Liv"
			CASE $$Src		:dataset[dset].datatype="Src"
			CASE $$user1	:dataset[dset].datatype="1"
			CASE $$user2	:dataset[dset].datatype="2"
			CASE $$user3	:dataset[dset].datatype="3"
			CASE ELSE			:dataset[dset].active=0
	END SELECT

END SUB

'###############
SUB GetImages
'###############

	dataset[0].totalimages=0
	dataset[0].ptype=0
	dataset[0].filen=file$

	FOR dset=0 TO 4
			GOSUB GetDataSet
			IF errorstate<>0 THEN EXIT SUB
	NEXT dset

' check for an unlimited number of other image sets.

	dataset[0].totaldatasets=dset-1
	IF dataset[0].totalimages=0 THEN errorstate=1
	IF dataset[0].totaldatasets<4 THEN errorstate=2

END SUB


'#################
SUB GetData
'#################

	GetString (@after,@string$,32)		' version
	SELECT CASE string$
			CASE "65544"		:#spec=1
			CASE "65543"		:#spec=2
			CASE "65539"		:errorstate=3: EXIT SUB
			CASE ELSE				:#spec=1
	END SELECT

	GetString (@after,@string$,32): dataset[dset].type=string$						' type?
	GetString (@after,@string$,32): dataset[dset].activeB=string$					' active
	GetString (@after,@string$,32): dataset[dset].structureVersion=string$' structure version
	GetString (@after,@string$,32): dataset[dset].timedate=string$				' time stamp
	GetString (@after,@string$,32): dataset[dset].temperature=string$
	dataset[dset].head=GetNumberASC (@after,32)
	dataset[dset].storeType=GetNumberASC (@after,32)
	dataset[dset].dataType=GetNumberASC (@after,32)
	dataset[dset].mode=GetNumberASC (@after,32)
	dataset[dset].triggerSource=GetNumberASC (@after,32)
	GetString (@after,@string$,32): dataset[dset].trigger_level=string$		' trigger level
	GetString (@after,@string$,32): dataset[dset].exposure_time=string$		'	exposure byte
	GetString (@after,@string$,32): dataset[dset].delay=string$						' delay
	GetString (@after,@s$,32):			dataset[dset].integrationCycleTime=s$	' intergration time
	GetString (@after,@string$,32): dataset[dset].noIntegrations=string$	' no of intergrations
	dataset[dset].sync=GetNumberASC (@after,32) 													' sync
	GetString (@after,@string$,32): dataset[dset].kineticCycleTime=string$' kinetic cycle time
	GetString (@after,@string$,32): dataset[dset].pixelReadoutTime=string$' pixel readout time
	GetString (@after,@string$,32): dataset[dset].noPoints=string$				' no of points
	GetString (@after,@string$,32): dataset[dset].fastTrackHeight=string$	' fast track height
	GetString (@after,@string$,32): dataset[dset].gain=string$						' gain
	GetString (@after,@string$,32): dataset[dset].gateDelay=string$				' gate delay
	GetString (@after,@string$,32): dataset[dset].gateWidth=string$				' gate width
	GetString (@after,@string$,32): dataset[dset].gateStep=string$				' gatestep
	GetString (@after,@string$,32): dataset[dset].trackHeight=string$			' track height
	GetString (@after,@string$,32): dataset[dset].seriesLenght=string$		' track series length
	dataset[dset].readPattern=GetNumberASC (@after,32)  									' read pattern
	dataset[dset].shutterDelay=GetNumberASC (@after,32)										' shutter delay
	GetString (@after,@string$,32): dataset[dset].stCentreRow=string$			'	st centre row
	GetString (@after,@string$,32): dataset[dset].mtOffset=string$				'	mt offset
	GetString (@after,@string$,32): dataset[dset].operationMode=string$		'	operation mode

	IF #spec=1 THEN
			GetString (@after,@string$,32): dataset[dset].flipX=string$				'	flip x
			GetString (@after,@string$,32): dataset[dset].flipY=string$				' flip y
			GetString (@after,@string$,32): dataset[dset].clock=string$				' clock
			GetString (@after,@string$,32): dataset[dset].aClock=string$			' a clock
			GetString (@after,@string$,32): dataset[dset].Mcp=string$					' mcp
			GetString (@after,@string$,32): dataset[dset].prop=string$				' prop
			GetString (@after,@string$,32): dataset[dset].ioc=string$					' ioc
			GetString (@after,@string$,32): dataset[dset].freq=string$				' freq
	END IF

	GetString (@after,@string$,10) 	' len of model field
	GetString (@after,@string$,10): dataset[dset].detectorModel=LEFT$(string$,LEN(string$)-1)

	INC after		' fix

	GetString (@after,@string$,32): dataset[dset].detectorFormatX=string$	' detector format x
	GetString (@after,@string$,32): dataset[dset].detectorFormatZ=string$	' detector format z
	dataset[dset].filenameLen=GetNumberB (@after) 	' len of filename

	INC after		' fix

	GetString (@after,@string$,10): dataset[dset].filename=LEFT$(string$,LEN(string$)-1)
	GetString (@after,@string$,32) 	'	version

	len=GetNumberB (@after): GetStringB (@after,@string$,len)
	IF len < 1 THEN string$="not entered": len=11				' user text
	dataset[dset].userTextLen=len
	dataset[dset].userText=string$

	'INC after		' fix
	GetString (@after,@string$,32): 	' version

	dataset[dset].shutterType=GetNumberASC (@after,32)	' shutter info
	dataset[dset].shutterMode=GetNumberASC (@after,32)
	dataset[dset].shutterCustomBgMode=GetNumberASC (@after,32)
	dataset[dset].shutterCustomMode=GetNumberASC (@after,32)
	GetString (@after,@string$,32): dataset[dset].shutterClosingTime=string$		' closed
	GetString (@after,@string$,10): dataset[dset].shutterOpeningTime=string$		' open
	GetString (@after,@string$,32)		' version

	dataset[dset].xType=GetNumberASC (@after,32)				' xyz unit type
	dataset[dset].xUnit=GetNumberASC (@after,32)
	dataset[dset].yType=GetNumberASC (@after,32)
	dataset[dset].yUnit=GetNumberASC (@after,32)
	dataset[dset].zType=GetNumberASC (@after,32)
	dataset[dset].zUnit=GetNumberASC (@after,10)
	GetNumber (@after,@a!): dataset[dset].xCal[0]=a!
	GetNumber (@after,@a!): dataset[dset].xCal[1]=a!
	GetNumber (@after,@a!): dataset[dset].xCal[2]=a!		' x cal
	GetNumber (@after,@a!): dataset[dset].xCal[3]=a!
	GetNumber (@after,@a!): dataset[dset].yCal[0]=a!
	GetNumber (@after,@a!): dataset[dset].yCal[1]=a!
	GetNumber (@after,@a!): dataset[dset].yCal[2]=a!		' y cal
	GetNumber (@after,@a!): dataset[dset].yCal[3]=a!
	GetNumber (@after,@a!): dataset[dset].zCal[0]=a!
	GetNumber (@after,@a!): dataset[dset].zCal[1]=a!
	GetNumber (@after,@a!): dataset[dset].zCal[2]=a!		' z cal
	GetNumber (@after,@a!): dataset[dset].zCal[3]=a!

	INC after		' fix

	GetString (@after,@string$,10): dataset[dset].rayleighWavelength=string$	' rayleigh Wavelength
	GetString (@after,@string$,10): dataset[dset].pixelLenght=string$					' pixelLenght
	GetString (@after,@string$,10): dataset[dset].pixelHeight=string$					' pixelHeight

	GetStringB (@after,@string$,GetNumberB (@after))
	dataset[dset].xText=string$
	GetStringB (@after,@string$,GetNumberB (@after))
	dataset[dset].yText=string$
	GetStringB (@after,@string$,GetNumberB (@after))
	dataset[dset].zText=string$

	GetString (@after,@string$,32)								' version
	dataset[dset].left=GetNumberB (@after)
	dataset[dset].top=GetNumberB (@after)
	dataset[dset].right=GetNumberB (@after)
	dataset[dset].bottom=GetNumberB (@after)
	dataset[dset].numberOfImages=GetNumberB (@after)
	dataset[dset].numberOfSubImages=GetNumberB (@after)
	dataset[dset].totalLenght=GetNumberB (@after)
	dataset[dset].imageLenght=GetNumberB (@after)

'	INC after		' fix

	GetString (@after,@string$,32)								' version
 	dataset[dset].bLeft=GetNumberB (@after)				' binning
	top!=GetNumberB (@after)
	dataset[dset].bRight=GetNumberB (@after)
	bottom!=GetNumberB (@after)
	dataset[dset].vBin=GetNumberB (@after)
	dataset[dset].hBin=GetNumberB (@after)
	subImageOffset=GetNumberB (@after)

	INC after		' fix

	IF dataset[dset].numberOfSubImages > 1 THEN
				FOR a=1 TO dataset[dset].numberOfSubImages
							GetString (@after,@string$,10)
				NEXT a
	ELSE
				FOR a=1 TO dataset[dset].numberOfImages
							GetString (@after,@string$,10)
				NEXT a
	END IF

	dataset[dset].NumberOfPixels=((dataset[dset].bRight-dataset[dset].bLeft)+1)/dataset[dset].hBin
	dataset[dset].NumberOfTracks=(((top!-bottom!)+1)/dataset[dset].vBin)*(dataset[dset].numberOfSubImages*dataset[dset].numberOfImages)
	IFZ	dataset[dset].NumberOfTracks THEN errorstate=5

	IF dataset[0].totalimages=0 THEN dataset[0].firstdataset=dset
	INC dataset[0].totalimages
	dataset[dset].dataStart=after
	dataset[dset].active=1
	dataset[dset].title=ident$
	dataset[dset].fPixel=0
	dataset[dset].lPixel=dataset[dset].NumberOfPixels-1

	after=((dataset[dset].totalLenght*4)+dataset[dset].dataStart)  ' file postion

END SUB


'###############
SUB formatIdent
'###############

	GetStringB (@after,@ident$,36)

	SELECT CASE TRUE
		CASE INSTR(ident$,$$SifAndor$)=1	:errorstate=0: ident$=LEFT$(ident$,35)
		CASE INSTR(ident$,$$SifOriel$)=1	:errorstate=0: INC after
		CASE ELSE													:errorstate=7: RETURN
	END SELECT

	GetString (@after,version$,32)
	' lets continue anyway

END SUB


END FUNCTION
'
'
' #############################
' #####  SaveSifAsSif ()  #####
' #############################
'
FUNCTION  SaveSifAsSif (file$)
	SHARED Image ImageFormat[]

	OA$=CHR$(0x0A)
	dt$="0"+OA$
	ident$=$$SifAndor$
	version$=OA$+"65538 "
	headerlen=ImageFormat[#ImageSet,#dataFile].dataStart-ImageFormat[#ImageSet,#dataFile].headerStart
	header$=NULL$(headerlen)

	SELECT CASE ImageFormat[#ImageSet,#dataFile].datatype
			CASE "Sig"		:	type$="": fileend$=dt$+dt$+dt$+dt$
			CASE "Ref"		:	type$=dt$: fileend$=dt$+dt$+dt$
			CASE "Bg"			:	type$=dt$+dt$: fileend$=dt$+dt$
			CASE "Liv"		:	type$=dt$+dt$+dt$: fileend$=dt$
			CASE "Src"		:	type$=dt$+dt$+dt$+dt$: fileend$=""
			CASE "1"			:	type$=dt$+dt$+dt$+dt$+dt$: fileend$=dt$
			CASE "2"			:	type$=dt$+dt$+dt$+dt$+dt$+dt$: fileend$=dt$
			CASE "3"			:	type$=dt$+dt$+dt$+dt$+dt$+dt$+dt$: fileend$=dt$
			CASE ELSE			:	type$="": fileend$=dt$+dt$+dt$+dt$
	END SELECT

	src=OPEN (#fil$, $$RDSHARE)
	SEEK (src,ImageFormat[#ImageSet,#dataFile].headerStart)
	READ [src],header$
	CloseFilefn (src)

	des=OPEN (file$, $$WRNEW)
	WRITE [des],ident$
	WRITE [des],version$
	WRITE [des],type$
	WRITE [des],header$
	XstBinWrite (des,GetPixelAddress (#ImageSet,1,1),GetDataSlotSize (#ImageSet,x,y))
	WRITE [des],fileend$
	CloseFilefn (des)

END FUNCTION
'
'
' #############################
' #####  SaveRawAsSif ()  #####
' #############################
'
FUNCTION  SaveRawAsSif (file$)


	addr=GetPixelAddress (#ImageSet,1,1)
	GetDataSlotSize (#ImageSet,@x,@y)
	size=x*y*4
	OA$=CHR$(0x0A)
	coda$="0"+OA$+"0"+OA$+"0"+OA$+"0"+OA$
	CreateSifHeader (@sifheader$)

	des=OPEN (file$, $$WRNEW)
	WRITE [des],sifheader$
	XstBinWrite (des,addr,size)
	WRITE [des],coda$
	CloseFilefn (des)


END FUNCTION
'
'
' ##########################
' #####  SaveAsSif ()  #####
' ##########################
'
FUNCTION  SaveAsSif (file$)

	XstDecomposePathname (#fil$, path$, parent$, filename$, Fn$, @fileExt$)
'	filename$=path$+"\\"+Fn$+"-ii.sif"

	SELECT CASE LCASE$(fileExt$)
		CASE ".sif"								: SaveSifAsSif (file$)
		CASE ".ii",".dat",".fit"	: SaveRawAsSif (file$)
	END SELECT

END FUNCTION
'
'
' ##########################
' #####  SaveAsRaw ()  #####
' ##########################
'
FUNCTION  SaveAsRaw (file$)


	addr=GetPixelAddress (#ImageSet,1,1)
	GetDataSlotSize (#ImageSet,@x,@y)
	size=x*y*4

	fn=OPEN (file$, $$WRNEW)
	XstBinWrite (fn,addr,size)
	CloseFilefn (fn)

END FUNCTION
'
'
' ################################
' #####  CreateSifHeader ()  #####
' ################################
'
FUNCTION  CreateSifHeader (sif$)
	SHARED Image ImageFormat[]


	filename$=ImageFormat[#ImageSet,#dataFile].filen
	header$=NULL$(500)
	xText$="Pixel number"
	yText$="Counts"
	zText$="Pixel number"
	OA$=CHR$(0x0A)
	x=ImageFormat[#ImageSet,#dataFile].NumberOfPixels
	y=ImageFormat[#ImageSet,#dataFile].NumberOfTracks
	size=x*y


	sif$=sif$+$$SifAndor$+OA$
	sif$=sif$+"65538"+" "
	sif$=sif$+"1"+OA$
	sif$=sif$+"65544"+" "
	sif$=sif$+"0"+" "			' type
	sif$=sif$+"0"+" "			' active
	sif$=sif$+"1"+" "			' structure version
	sif$=sif$+"9999"+" "	' time
	sif$=sif$+"-999"+" "	' temp
	sif$=sif$+CHR$(0)+" "	' head
	sif$=sif$+CHR$(0)+" "	' store
	sif$=sif$+CHR$(0)+" "	' delay
	sif$=sif$+CHR$(1)+" "	'	mode
	sif$=sif$+CHR$(0)+" "	' trig source
	sif$=sif$+"0"+" "			' trig level
	sif$=sif$+"0"+" "			' exp time
	sif$=sif$+"0"+" "			' delay
	sif$=sif$+"1"+" "			' integrationCycleTime
	sif$=sif$+"1"+" "			' noIntegrations
	sif$=sif$+CHR$(0)+" "	' sync
	sif$=sif$+"1"+" "			' kineticCycleTime
	sif$=sif$+"1"+" "			' pixelReadoutTime
	sif$=sif$+"1"+" "			' noPoints
	sif$=sif$+"1"+" "			' fastTrackHeight
	sif$=sif$+"1"+" "			' gain
	sif$=sif$+"1"+" "			' gateDelay
	sif$=sif$+"1"+" "			' gateWidth
	sif$=sif$+"1"+" "			' gateStep
	sif$=sif$+"1"+" "			' trackHeight
	sif$=sif$+"1"+" "			' seriesLenght
	sif$=sif$+CHR$(0)+" "	' readPattern
	sif$=sif$+CHR$(0)+" "	' shutterDelay
	sif$=sif$+"1"+" "			' stCentreRow
	sif$=sif$+"1"+" "			' mtOffset
	sif$=sif$+"1"+" "			' operationMode

	sif$=sif$+"1"+" "			' flipX
	sif$=sif$+"1"+" "			' flipY
	sif$=sif$+"1"+" "			' clock
	sif$=sif$+"1"+" "			' aClock
	sif$=sif$+"1"+" "			' Mcp
	sif$=sif$+"1"+" "			' prop
	sif$=sif$+"1"+" "			' ioc
	sif$=sif$+"1"+" "			' freq

	sif$=sif$+"7"+OA$			' detector model name len
	sif$=sif$+"unknown "+OA$	' detector model
	sif$=sif$+STRING$(x)+" "		'	ccd x format
	sif$=sif$+STRING$(y)+" "	'	ccd y format
	sif$=sif$+STRING$(LEN(filename$))+OA$		' filename len
	sif$=sif$+filename$+" "+OA$							' filename
	sif$=sif$+"65538"+" "	' version
	sif$=sif$+"0"+OA$			' comment len
	sif$=sif$+""+OA$			' comment
	sif$=sif$+"65538"+" "	' version
	sif$=sif$+CHR$(1)+" "	' shutterType
	sif$=sif$+CHR$(0)+" "	' shutterMode
	sif$=sif$+CHR$(0)+" "	' shutterCustomBgMode
	sif$=sif$+CHR$(0)+" "	' shutterCustomMode
	sif$=sif$+"0"+"  "		' shutterClosingTime
	sif$=sif$+"0"+OA$			' shutterOpeningTime
	sif$=sif$+"65539"+" "	' version
	sif$=sif$+CHR$(1)+" "	' xType
	sif$=sif$+CHR$(0)+" "	' xUnit
	sif$=sif$+CHR$(1)+" "	' yType
	sif$=sif$+CHR$(0)+" "	' yUnit
	sif$=sif$+CHR$(1)+" "	' zType
	sif$=sif$+CHR$(0)+OA$	' zUnit
	sif$=sif$+"0"+"  "		' xCal[]
	sif$=sif$+"1"+"  "		' "
	sif$=sif$+"0"+"  "		' "
	sif$=sif$+"0"+OA$			' "
	sif$=sif$+"0"+"  "		' yCal[]
	sif$=sif$+"1"+"  "		' "
	sif$=sif$+"0"+"  "		' "
	sif$=sif$+"0"+OA$			' "
	sif$=sif$+"0"+"  "		' zCal[]
	sif$=sif$+"1"+"  "		' "
	sif$=sif$+"0"+"  "		' "
	sif$=sif$+"0"+OA$			' "
	sif$=sif$+"0"+OA$			' rayleighWavelength
	sif$=sif$+"1"+OA$			' pixelLenght
	sif$=sif$+"1"+OA$			' pixelHeight
	sif$=sif$+STRING$(LEN(xText$))+OA$	' xText	len
	sif$=sif$+xText$			' xText
	sif$=sif$+STRING$(LEN(yText$))+OA$	' yText	len
	sif$=sif$+yText$			' yText
	sif$=sif$+STRING$(LEN(zText$))+OA$	' zText	len
	sif$=sif$+zText$			' zText
	sif$=sif$+"65538"+" "	' version
	sif$=sif$+"1"+" "			' 	left
	sif$=sif$+STRING$(ImageFormat[#ImageSet,#dataFile].top)+" "		' top
	sif$=sif$+STRING$(x)+" "
	sif$=sif$+"1"+" "			' bottom
	sif$=sif$+"1"+" "			' number of images
	sif$=sif$+"1"+" "			' number of sub images
	sif$=sif$+STRING$ (size)+" "		' totalLenght
	sif$=sif$+STRING$	(size)+OA$		' imageLenght
	sif$=sif$+"65538"+" "	' version
	sif$=sif$+STRING$(ImageFormat[#ImageSet,#dataFile].bLeft)+" "		' bin left
	sif$=sif$+STRING$(ImageFormat[#ImageSet,#dataFile].top)+" "			' bin top
	sif$=sif$+STRING$(ImageFormat[#ImageSet,#dataFile].bRight)+" "	' bin right
	sif$=sif$+"1"+" "			' bin bottom
	sif$=sif$+"1"+" "			' hbin
	sif$=sif$+"1"+" "			' vbin
	sif$=sif$+"0"+OA$			' offset
	sif$=sif$+"0"+OA$			' offset

END FUNCTION
'
'
' ####################################
' #####  ExtractFileTypeInfo ()  #####
' ####################################
'
FUNCTION  ExtractFileTypeInfo (file$,index)
	SHARED dataskip,datastart
	SHARED Image ImageFormat[]
	SHARED MemDataSet ImageDataSet[]
	Image  dataset[],null[]
	STATIC error,oldfile$

	#exitProgram=0
	'#currentImageBt=0
	#spec=-1
	'#totalImages=0
	#filetype = 0

	XstDecomposePathname (file$, path$, parent$, filename$, @FnoExt$, @fileExt$)

	SELECT CASE UCASE$(fileExt$)
			CASE ".SIF"		: ParseSifFile (file$,@dataset[],@error)
			CASE ".II"		: ParseIIFile  (file$,@dataset[],@error)
			CASE ".DAT"		: ParseDatFile (file$,@dataset[],@error)
'			CASE ".FIT"		: ParseDatFile (file$,@dataset[],@error)
'			CASE ".ASC"		: ParseAscFile (file$,@dataset[],@error)
			CASE ELSE			: error=4
	END SELECT


	IF error=4 THEN			' maybe its a file of another type i can load with the wrong .ext? lets try. ok lets not.
			#DatInfoState=0
'			ParseSifFile (file$,@ImageFormat[],@error)
'			IF error<>0 THEN ParseIIFile  (file$,@dataset[],@error)
'			IF error<>0 THEN ParseFitFile (file$,@dataset[],@error)
'			IF error<>0 THEN ParseDatFile (file$,@dataset[],@error)
'			IF error<>0 THEN ParseAscFile (file$,@dataset[],@error)
'			IF error<>0 THEN error=4
	END IF


	IF error<>0 THEN
			fileErrorHandle (file$,error)
	ELSE
			ImageDataSet[index].active=1
			IF ImageFormat[index,]<>0 THEN ATTACH ImageFormat[index,] TO null[]
			ATTACH dataset[] TO ImageFormat[index,]
			SetDataSetTitle (index,FnoExt$,file$)
	END IF

	RETURN error

END FUNCTION
'
'
' ##########################
' #####  GetString ()  #####
' ##########################
'
FUNCTION  GetString (after,string$,term)

IF (after+1) > LOF(#fn2) THEN RETURN 4
string$=""
c$=" "

SEEK(#fn2,after)

DO
		c$=" "
		READ [#fn2], c$
		IF UBYTEAT(&c$)=UBYTEAT(&term) THEN
					IF LEN(string$)=0 THEN c$="" ELSE	EXIT DO
		END IF
		string$=string$+c$

		IF POF(#fn2)=LOF(#fn2) THEN EXIT DO
LOOP

after=after+LEN(string$)+1
IF #DebugLevel=	1 THEN PRINT after,"-"+string$+"-"

END FUNCTION
'
'
' ##########################
' #####  GetNumber ()  #####
' ##########################
'
FUNCTION GetNumber (after,a!)
	SHARED filler$

	SEEK(#fn2,after)
	READ [#fn2], filler$

	XstStringToNumber (filler$,0,@pos,@type,@value$$)

	SELECT CASE type
			CASE $$SLONG : a! = GLOW(value$$)
			CASE $$XLONG : a! = value$$
			CASE $$SINGLE : a! = SMAKE(GLOW(value$$))
			CASE $$DOUBLE : a! = DMAKE(GHIGH(value$$), GLOW(value$$))
	END SELECT


	after=after+pos
	IF #DebugLevel=	1 THEN PRINT after,"+";a!;"+"

	RETURN SINGLE(a!)

END FUNCTION
'
'
' ###########################
' #####  GetNumberB ()  #####
' ###########################
'
FUNCTION  GetNumberB (after) ' should be  'DOUBLE GetNumberB (after)'
	SHARED filler$

	SEEK (#fn2,after)
	READ [#fn2], filler$

	XstStringToNumber (@filler$,0,@pos,type,@a)

	after=after+pos
	IF #DebugLevel=	1 THEN PRINT after,"+";a;"+"

	RETURN a

END FUNCTION
'
'
' ###########################
' #####  GetStringB ()  #####
' ###########################
'
FUNCTION  GetStringB (after,string$,len)

	INC after
	string$=SPACE$(len)

	SEEK (#fn2,after)
	READ [#fn2],string$

	after=after+len

	IF #DebugLevel=	1 THEN PRINT after,"-"+string$+"-"

END FUNCTION
'
'
' ##################################
' #####  FindMoreDataFiles ()  #####
' ##################################
'
FUNCTION  FindMoreDataFiles (file$)

	IF #filetype = 3 THEN RETURN		' ignore .dat files

	XstDecomposePathname (file$, @path$, @parent$, @filename$, f$, DataFileExt$)
	dir$=path$+"\\"
	ptotal=0

	filter$=dir$+"*.ii": XstGetFiles (@filter$, @fileII$[])
  IF UBOUND (fileII$[]) > -1 THEN  #NumberOfFiles=UBOUND (fileII$[])

	filter$=dir$+"*.sif": XstGetFiles (@filter$, @fileSIF$[])
	IF UBOUND (fileSIF$[]) > -1 THEN  #NumberOfFiles=#NumberOfFiles+UBOUND (fileSIF$[])+1

'	filter$=dir$+"*.dat": XstGetFiles (@filter$, @fileDAT$[])
'	IF UBOUND (fileDAT$[]) > -1 THEN  #NumberOfFiles=#NumberOfFiles+UBOUND (fileDAT$[])+1

'	filter$=dir$+"*.asc": XstGetFiles (@filter$, @fileASC$[])
'	IF UBOUND (fileASC$[]) > -1 THEN  #NumberOfFiles=#NumberOfFiles+UBOUND (fileASC$[])+1

	'PRINT filter$,UBOUND (fileSIF$[])

	DIM #ListOfDataFiles$[#NumberOfFiles+3]

  IF UBOUND (fileII$[]) > -1 THEN
			FOR pos=0 TO UBOUND(fileII$[])
					#ListOfDataFiles$[pos]=dir$+fileII$[pos]
			NEXT pos
			ptotal=ptotal+pos
	END IF

	IF UBOUND (fileSIF$[]) > -1 THEN
			FOR pos=0 TO UBOUND(fileSIF$[])
					#ListOfDataFiles$[pos+ptotal]=dir$+fileSIF$[pos]
			NEXT pos
  		ptotal=ptotal+pos
	END IF

'	IF UBOUND (fileDAT$[]) > -1 THEN
'			FOR pos=0 TO UBOUND(fileDAT$[])
'					#ListOfDataFiles$[pos+ptotal]=dir$+fileDAT$[pos]
'			NEXT pos
'  		ptotal=ptotal+pos
'	END IF

'	IF UBOUND (fileASC$[]) > -1 THEN
'			FOR pos=0 TO UBOUND(fileASC$[])
'					#ListOfDataFiles$[pos+ptotal]=dir$+fileASC$[pos]
'			NEXT pos
'  		ptotal=ptotal+pos
'	END IF

	#NumberOfFiles=ptotal-1
	REDIM #ListOfDataFiles$[#NumberOfFiles]
	DIM temp[0]

	text$="Quick load - "+STRING(#NumberOfFiles+1)+" files"
	XuiSendMessage (#FileList, #SetWindowTitle, 0, 0, 0, 0, 0,text$)
	XstQuickSort (@#ListOfDataFiles$[] , @temp[], 0, #NumberOfFiles, ($$SortAlphabetic | $$SortCaseInsensitive))
	XuiSendMessage (#FileList, #SetTextArray, 0, 0, 0, 0, 1, @#ListOfDataFiles$[])
	XuiSendMessage (#FileList, #Redraw, 0, 0, 0, 0, 0, 0)

	FOR pos=0 TO #NumberOfFiles
			IF file$ = #ListOfDataFiles$[pos] THEN #FileNumber = pos: EXIT FUNCTION
		'	XstLog(STRING(pos)+","+STRING(#ListOfDataFiles$[pos]))
	NEXT pos


END FUNCTION
'
'
' ##############################
' #####  InitVariables ()  #####
' ##############################
'
FUNCTION  InitVariables ()
	SHARED Image ImageFormat[]
	SHARED TrackData TrackInfoCopy[]
	SHARED MemDataSet ImageDataSet[]
	SHARED imageindex

	IF #DatInfoState=100 THEN EXIT FUNCTION

	setDefaultPixRange (#ImageSet)

	IF 	#ButtonMenu=0 THEN
			FOR pos=12 TO 28
						XuiSendMessage (#Output,#Disable,0,0,0,0,pos,0)
			NEXT pos

			XuiSendMessage (#Output,#Disable,0,0,0,0,4,0)
			XuiSendMessage (#Output,#Disable,0,0,0,0,8,0)
			XuiSendMessage (#Output,#Disable,0,0,0,0,10,0)
	ELSE
			XuiSendMessage (#Output,#Disable,0,0,0,0,15,0)	'	$InputTextLine1
			XuiSendMessage (#Output,#Disable,0,0,0,0,16,0)	' $InputLabel1
			XuiSendMessage (#Output,#Disable,0,0,0,0,25,0)	' $zoomin
			XuiSendMessage (#Output,#Disable,0,0,0,0,26,0)	' $zoomout
			XuiSendMessage (#Output,#Disable,0,0,0,0,27,0)	' $incrase x
			XuiSendMessage (#Output,#Disable,0,0,0,0,28,0)	' $decrase x
	END IF

	XuiSendMessage (#Output,#Disable,0,0,0,0, 38 ,0)	' $colourbar
	XuiSendMessage (#ResponseBox, #HideWindow, 0, 0, 0, 0, 0, 0)

	IF #IsSlot=0 THEN ReadFile (#fil$,#ImageSet,#dataFile)
	IF SetImageIndex (#ImageSet)=0 THEN SetImageIndex (GetFirstValidDataSet (-1))
	DataTrackImageCheck ()

	ImageDataSet[#ImageSet].Track=1				' select which track is displayed on startup
	#hoffset=0
	#Voffset=0
	#ydrag=0
	#totalvoffset=0
	#drawXinfo=1
	#drawYinfo=1
	#drawVinfo=1
	#dontupdate=0
	#Hoffset=0
	#data=0
	#Vtext$=""
	#TenTracks=ImageFormat[#ImageSet,#dataFile].NumberOfTracks*0.01
	#FirstPix=0
	#LastPix=ImageFormat[#ImageSet,#dataFile].NumberOfPixels-1
	#FirstTrack=0
	#LastTrack=1 'ImageFormat[#ImageSet,#dataFile].NumberOfTracks-1
	#row=1
	#col=1
	#labelBox=0
	#disableCEO=0
	#LoadBit=0
	#SaveImage=0
	#imagefix=0				' patch fix
	#error=0
	#ResponseBoxState=0
	#ClearMessageQueue=0
	#copyImage=0
	#PanDisplay=0
	#clearO1=0
	#DatInfoState=0
	#vbarRedraw=1
	DIM TrackInfoCopy[ImageFormat[#ImageSet,#dataFile].NumberOfTracks-1]
	#IsSlot=0
	ImageDataSet[#ImageSet].stDisplay=1

	#FirstLoad=1						' ok we've run once
	InitDisplay ()

END FUNCTION
'
'
' #########################
' #####  DrawInfo ()  #####
' #########################
'
'
' draw the cursor then buffer the window/track and any other onscreen data which is not required
'	in the (image) off screen buffer.
'
' this function is a mess
'	to rewrite using the redraw flags, eg, $$DrawXUnit2d
'
FUNCTION  DrawInfo ()
	SHARED Image ImageFormat[]
	SHARED MemDataSet ImageDataSet[]
	SHARED UBYTE image[]
	SHARED TEXT8 text8
	SHARED SINGLE hh,ww
	SINGLE y2,y3,y4,multi,wwx,minxvalue,maxxvalue,hhm,y,yc,yb,ya
	SHARED imageindex		' disabled
	SHARED cur

IF #currentDisplay=1 THEN				' single track display info

		IF #scrpix<1 THEN #scrpix=ImageFormat[#ImageSet,#dataFile].NumberOfPixels-1
		GetPixelValue (#ImageSet,ImageFormat[#ImageSet,#dataFile].fPixel+cur+1,ImageDataSet[#ImageSet].Track,@v!)
		checkMaxVvalue (text$)
		hhm=hh/(ImageDataSet[#ImageSet].MaxValue-ImageDataSet[#ImageSet].MinValue)
		x=((ww/#scrpix)*cur)
		y=(hh-(hhm*v!))+#vinfo
		drawCursor (#memBuffer,#cursorColour,x,y,#CType)

		IF #drawVinfo=1 THEN				' if window is large enough for our text data then lets display it
																' same with #drawXinfo and #drawYinfo

					XgrSetGridFont (#Output,#valfont)
					cur!=(cur*ImageFormat[#ImageSet,#dataFile].xCal[1]+ImageFormat[#ImageSet,#dataFile].xCal[0]+ (ImageFormat[#ImageSet,#dataFile].fPixel*ImageFormat[#ImageSet,#dataFile].xCal[1]))+ImageFormat[#ImageSet,#dataFile].bLeft-1
					x$="X:"+STRING$((cur!*ImageFormat[#ImageSet,#dataFile].hBin)+1)
					z$=" Y:"+STRING$((ImageDataSet[#ImageSet].Track*ImageFormat[#ImageSet,#dataFile].vBin))

					GetPixelValue (#ImageSet,ImageFormat[#ImageSet,#dataFile].fPixel+cur+1,ImageDataSet[#ImageSet].Track,@v!)
					dat$="Data:"+STRING$(v!)

					pos=#v3-16 ' #topmargin-20
					xpos=(ImageFormat[#ImageSet,0].totalimages*30)+35

					XgrMoveTo (#Output, xpos,pos)
					XgrDrawTextFill (#Output, #background,#textClear$+"         ")
					XgrMoveTo (#Output, xpos+150,pos)
					XgrDrawTextFill (#Output, #background,#textClear$)


					XgrSetGridFont (#Output,#valfont)
					XgrMoveTo (#Output, xpos,pos)
					XgrDrawTextFill (#Output, #ink, x$)
					XgrMoveTo (#Output, xpos+85,pos)
					XgrDrawTextFill (#Output, #ink, dat$)
					XgrMoveTo (#Output, xpos+175,pos)
					XgrDrawTextFill (#Output, #ink, z$)

	  END IF

		IF #drawXinfo>0 THEN

'					IF imageindex<2 THEN
					dImageTitle ()

					XgrSetGridFont (#Output,#labelYfont)
					XgrMoveTo (#Output, 0,hh+#topmargin-60)
					XgrDrawTextFill (#Output, #ink, ImageFormat[#ImageSet,#dataFile].yText)			' print y axis text

					IF #labelBox=0 THEN
								XgrSetGridFont (#Output,#labelfont)
								XgrMoveTo (#Output, #leftmargin+2,hh+#topmargin+20)
								XgrDrawTextFill (#Output, #ink, ImageFormat[#ImageSet,#dataFile].xText)			' print x axis text
					END IF

					IF #drawXinfo=2 THEN ClearHcoverField ()
					DrawXinfo ()

		END IF

		IF #drawYinfo=1 THEN

					XgrSetGridFont (#Output,#valfont)
					ink=#ink ' ImageDataSet[#ImageSet].clr2d

					points=5
					pos=points

					multi=(ImageDataSet[#ImageSet].MaxValue-ImageDataSet[#ImageSet].MinValue)/hh

					DO
								yc=((hh/points)*pos)+#topmargin-7
								yb!=(#vinfo+(hh-((hh/points)*pos)))*multi

								IF pos= 0 THEN
											#MaxV!=yb!
								ELSE
											IF pos= 5 THEN #MinV!=yb!
								END IF

								IF (yb!<10 && yb!>-10) THEN
										text8.text=STRING$(yb!)
								ELSE
										text8.text=STRING$(XLONG(yb!))
								END IF

								text$=text8.text

								XgrMoveTo (#Output,#leftmargin-58,yc)
								XgrDrawTextFill (#Output, ink,"                 ")

								XgrMoveTo (#Output,#leftmargin-58,yc)
								XgrDrawTextFill (#Output, ink,text$+" ")

								DEC pos

					LOOP UNTIL (pos=-1)

					XgrDrawLine (#Output, #ink,#leftmargin-7,hh+#topmargin,#leftmargin-3,hh+#topmargin)

					FOR pos = 1 TO points
								ya=hh-((hh/points)*pos)+#topmargin
								XgrDrawLine (#Output, #ink,#leftmargin-7,ya,#leftmargin-3,ya)
					NEXT pos

		END IF

		IF #dontupdate=0 THEN
					IF ImageFormat[#ImageSet,#dataFile].NumberOfTracks > 1 THEN
								pos=ImageFormat[#ImageSet,#dataFile].NumberOfTracks-ImageDataSet[#ImageSet].Track
								IF ((#dontupdate=4) OR (#dontupdate=0)) THEN XuiSendMessage (#Output, #SetPosition, 1 , pos, pos, ImageFormat[#ImageSet,#dataFile].NumberOfTracks,9, 0)
					END IF
		ELSE
					#dontupdate=0
		END IF

ELSE

		IF #clearGrid=1 THEN #clearGrid=0: XuiSendMessage (#Output,#Redraw,0,0,0,0,0,0)
		dImageTitle ()

END IF

END FUNCTION
'
'
'	############################
'	#####  ResponseBox ()  #####
'	############################
'
'
FUNCTION  ResponseBox (grid, message, v0, v1, v2, v3, r0, (r1, r1$, r1[], r1$[]))
	STATIC  designX,  designY,  designWidth,  designHeight
	STATIC  SUBADDR  sub[]
	STATIC  upperMessage
	STATIC  ResponseBox
'
	$ResponseBox  =   0  ' kid   0 grid type = ResponseBox
	$Label        =   1  ' kid   1 grid type = XuiLabel
	$TextLine     =   2  ' kid   2 grid type = XuiTextLine
	$UpperKid     =   2  ' kid maximum
'
'
	IFZ sub[] THEN GOSUB Initialize
'	XuiReportMessage (grid, message, v0, v1, v2, v3, r0, r1)
	IF XuiProcessMessage (grid, message, @v0, @v1, @v2, @v3, @r0, @r1, ResponseBox) THEN RETURN
	IF (message <= upperMessage) THEN GOSUB @sub[message]
	RETURN
'
'
' *****  Callback  *****  message = Callback : r1 = original message
'
SUB Callback
	message = r1
	callback = message
	IF (message <= upperMessage) THEN GOSUB @sub[message]
END SUB
'
'
' *****  Create  *****  v0123 = xywh : r0 = window : r1 = parent
'
SUB Create
	IF (v0 <= 0) THEN v0 = 0
	IF (v1 <= 0) THEN v1 = 0
	IF (v2 <= 0) THEN v2 = designWidth
	IF (v3 <= 0) THEN v3 = designHeight
	XuiCreateGrid  (@grid, ResponseBox, @v0, @v1, @v2, @v3, r0, r1, &ResponseBox())
	XuiSendMessage ( grid, #SetGridName, 0, 0, 0, 0, 0, @"ResponseBox")
	XuiLabel       (@g, #Create, 0, 0, 324, 68, r0, grid)
	XuiSendMessage ( g, #SetCallback, grid, &ResponseBox(), -1, -1, $Label, grid)
	XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"Label")
	XuiSendMessage ( g, #SetBorder, $$BorderNone, $$BorderNone, $$BorderNone, 0, 0, 0)
	XuiSendMessage ( g, #SetTexture, $$TextureNone, 0, 0, 0, 0, 0)
	XuiSendMessage ( g, #SetHelpString, 0, 0, 0, 0, 0, @"Help")
	XuiSendMessage ( g, #SetHintString, 0, 0, 0, 0, 0, @"Hint")
	XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"Label")
	XuiTextLine    (@g, #Create, 0, 68, 324, 32, r0, grid)
	XuiSendMessage ( g, #SetCallback, grid, &ResponseBox(), -1, -1, $TextLine, grid)
	XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"TextLine")
	XuiSendMessage ( g, #SetAlign, $$AlignMiddleCenter, 0, -1, -1, 0, 0)
	XuiSendMessage ( g, #SetBorder, $$BorderLoLine1, $$BorderLoLine1, $$BorderNone, 0, 0, 0)
	XuiSendMessage ( g, #SetHelpString, 0, 0, 0, 0, 0, @"Help")
	XuiSendMessage ( g, #SetHintString, 0, 0, 0, 0, 0, @"Hint")
	XuiSendMessage ( g, #SetFont, 320, 600, 0, 0, 0, @"MS Sans Serif")
	XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"Text")
	XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 1, @"XuiArea730")
	XuiSendMessage ( g, #SetFont, 320, 600, 0, 0, 1, @"MS Sans Serif")
	GOSUB Resize
END SUB
'
'
' *****  CreateWindow  *****  v0123 = xywh : r0 = windowType : r1$ = display$
'
SUB CreateWindow
	IF (v0 == 0) THEN v0 = designX
	IF (v1 == 0) THEN v1 = designY
	IF (v2 <= 0) THEN v2 = designWidth
	IF (v3 <= 0) THEN v3 = designHeight
	XuiWindow (@window, #WindowCreate, v0, v1, v2, v3, r0, @r1$)
	v0 = 0 : v1 = 0 : r0 = window : ATTACH r1$ TO display$
	GOSUB Create
	r1 = 0 : ATTACH display$ TO r1$
	XuiWindow (window, #WindowRegister, grid, -1, v2, v3, @r0, @"ResponseBox")
END SUB
'
'
' *****  GetSmallestSize  *****  see "Anatomy of Grid Functions"
'
SUB GetSmallestSize
END SUB
'
'
' *****  Redrawn  *****  see "Anatomy of Grid Functions"
'
SUB Redrawn
	XuiCallback (grid, #Redrawn, v0, v1, v2, v3, r0, r1)
END SUB
'
'
' *****  Resize  *****  see "Anatomy of Grid Functions"
'
SUB Resize

'	designX = (#displayWidth*0.5)-(designWidth*0.5)
'	designY = (#displayHeight*0.5)-(designHeight*0.5)


END SUB
'
'
' *****  Selection  *****  see "Anatomy of Grid Functions"
'
SUB Selection
END SUB
'
'
' *****  Initialize  *****  see "Anatomy of Grid Functions"
'
SUB Initialize
	XuiGetDefaultMessageFuncArray (@func[])
	XgrMessageNameToNumber (@"LastMessage", @upperMessage)
'
	func[#Callback]           = &XuiCallback ()               ' disable to handle Callback messages internally
' func[#GetSmallestSize]    = 0                             ' enable to add internal GetSmallestSize routine
' func[#Resize]             = 0                             ' enable to add internal Resize routine
'
	DIM sub[upperMessage]
'	sub[#Callback]            = SUBADDRESS (Callback)         ' enable to handle Callback messages internally
	sub[#Create]              = SUBADDRESS (Create)           ' must be subroutine in this function
	sub[#CreateWindow]        = SUBADDRESS (CreateWindow)     ' must be subroutine in this function
'	sub[#GetSmallestSize]     = SUBADDRESS (GetSmallestSize)  ' enable to add internal GetSmallestSize routine
	sub[#Redrawn]             = SUBADDRESS (Redrawn)          ' generate #Redrawn callback if appropriate
'	sub[#Resize]              = SUBADDRESS (Resize)           ' enable to add internal Resize routine
	sub[#Selection]           = SUBADDRESS (Selection)        ' routes Selection callbacks to subroutine
'
'	IF sub[0] THEN PRINT "ResponseBox() : Initialize : error ::: (undefined message)"
' IF func[0] THEN PRINT "ResponseBox() : Initialize : error ::: (undefined message)"
	XuiRegisterGridType (@ResponseBox, "ResponseBox", &ResponseBox(), @func[], @sub[])
'
' Don't remove the following 4 lines, or WindowFromFunction/WindowToFunction will not work
'

	designWidth = 324
	designHeight = 100
	designX = (#displayWidth*0.5)-(designWidth*0.5)
	designY = (#displayHeight*0.5)-(designHeight*0.5)

'
	gridType = ResponseBox
	XuiSetGridTypeProperty (gridType, @"x",                designX)
	XuiSetGridTypeProperty (gridType, @"y",                designY)
	XuiSetGridTypeProperty (gridType, @"width",            designWidth)
	XuiSetGridTypeProperty (gridType, @"height",           designHeight)
	XuiSetGridTypeProperty (gridType, @"maxWidth",         designWidth)
	XuiSetGridTypeProperty (gridType, @"maxHeight",        designHeight)
	XuiSetGridTypeProperty (gridType, @"minWidth",         designWidth)
	XuiSetGridTypeProperty (gridType, @"minHeight",        designHeight)
	XuiSetGridTypeProperty (gridType, @"can",              $$Focus OR $$Respond OR $$Callback OR $$TextSelection)
	XuiSetGridTypeProperty (gridType, @"focusKid",         $TextLine)
	XuiSetGridTypeProperty (gridType, @"inputTextString",  $TextLine)
	IFZ message THEN RETURN
END SUB
END FUNCTION
'
'
' ################################
' #####  ResponseBoxCode ()  #####
' ################################
'
'
'
FUNCTION  ResponseBoxCode (grid, message, v0, v1, v2, v3, kid, r1)	' well it was a nice idea.
	STATIC lastAction

	$ResponseBox  =   0  ' kid   0 grid type = ResponseBox
	$Label        =   1  ' kid   1 grid type = XuiLabel
	$TextLine     =   2  ' kid   2 grid type = XuiTextLine
	$UpperKid     =   2  ' kid maximum


'
'	XuiReportMessage (grid, message, v0, v1, v2, v3, kid, r1)
	IF (message == #Callback) THEN message = r1
'
	SELECT CASE message
		CASE #Selection		: GOSUB Selection
	END SELECT
	RETURN
'
'
SUB Selection

	IF kid=$TextLine THEN

				'IF lastAction<>#ResponseAction THEN #ResponseBoxState=0
				'lastAction=#ResponseAction

				#Textline$=""
				XuiSendMessage (#ResponseBox,#GetTextString,0,0,0,0,$TextLine,@#Textline$)
				IF #ResponseAction=4 THEN LabeldSet ()

	END IF

END SUB


END FUNCTION
'
'
' ###########################
' #####  CEOcontrol ()  #####
' ###########################
'
FUNCTION  CEOcontrol (grid, message, v0, v1, v2, v3, kid, r1)
	SHARED MemDataSet ImageDataSet[]
	SHARED area,ww


	IF #disableCEO=1 THEN EXIT FUNCTION

'	XgrMessageNumberToName  (message,@message$): PRINT grid, message$, v0, v1, v2, v3, kid, r1
'	XuiReportMessage (grid, message, v0, v1, v2, v3, kid, r1)
'	IF message =  THEN XuiReportMessage (grid, message, v0, v1, v2, v3, kid, r1)

	SELECT CASE r1
			CASE #image,area,#colourbarea	: MouseControl (message,v0,v1,v2,v3,r1): EXIT FUNCTION
			CASE #IconWindowG							: IconWindowCode (grid, message, v0, v1, v2, v3, kid, r1): EXIT FUNCTION
	END SELECT

	SELECT CASE message
			CASE	#WindowKeyUp			: IF grid=#GetRawInfoWindow THEN GetRawInfoCode (grid, #UpdateLabel, v0, v1, v2, v3, kid, r1)
			CASE	#WindowResized		:	IF grid=#OutputWindow THEN #resize=1: EXIT FUNCTION
															:	slot=uDisplayGetSlot(grid,2)
																IF slot<>-1 THEN uDisplayResizeWindow (grid,slot, v0, v1, v2, v3)
																EXIT FUNCTION
			CASE	#WindowRedraw			: IF #resize=1 THEN
																		#resize=0

																		IF #PanDisplay=4 THEN EXIT FUNCTION
																		IF #currentDisplay=1 THEN
																					setTrackVoffset (#ImageSet)
																					DisplayTrack(ImageDataSet[#ImageSet].Track,0)
																		ELSE
																					#clearGrid=0
																					#copyImage=0
																					GetNewImage (#image,1,0,0)
																		END IF

																END IF
																EXIT FUNCTION

			CASE	#WindowMouseMove	: IF (r1=#OutputG) AND (#PanDisplay=0) THEN setMenuStatus (r1,v0,v1)
																IF #currentDisplay=2 THEN
																			IF isInGrid (#ModMaxG,r1,v0,v1)=1 THEN
																				'	XgrClearGrid (#ModMaxG,$$Red)
																					XgrGetWindowPositionAndSize (#OutputWindow, @x,@y,width,height)
																					XgrSetWindowPositionAndSize (#ModScaleMaxWindow,x+#v2-#rightmargin-2,y+24,-1,-1)
																					XgrDisplayWindow (#ModScaleMaxWindow): #mmax=1
																			END IF
																			IF isInGrid (#ModMinG,r1,v0,v1)=1 THEN
																				'	XgrClearGrid (#ModMinG,$$Red)
																					XgrGetWindowPositionAndSize (#OutputWindow, @x,@y,width,height)
																					XgrSetWindowPositionAndSize (#ModScaleMinWindow,x+#leftmargin-36,y+24,-1,-1)
																					XgrDisplayWindow (#ModScaleMinWindow): #mmin=1
																			END IF
																END IF
			CASE	#WindowMouseExit	 :slot=uDisplayGetSlot (grid,1)
																IF slot<>-1 THEN uDisplayCB (grid, message, v0, v1, v2, v3, kid, r1): EXIT FUNCTION

 																IF r1=#OutputG THEN setMenuStatus (r1,v0,v1)

																IF #currentDisplay=2 THEN
																			IF isInGrid (#ModScaleMaxG,r1,v0,v1)=0 THEN
																					IF #mmax=1 THEN XgrHideWindow (#ModScaleMaxWindow): #mmax=0
																					IF #mmin=1 THEN XgrHideWindow (#ModScaleMinWindow): #mmin=0
																			END IF
																END IF
			CASE	#WindowMouseUp		: SetFocusOnGrid (#image)
			CASE	#WindowMouseEnter	: slot=uDisplayGetSlot (grid,1)
																IF slot<>-1 THEN uDisplayCB (grid, message, v0, v1, v2, v3, kid, r1)
			CASE	#WindowDeselected	: slot=uDisplayGetSlot (grid,2)
																IF slot<>-1 THEN
																grid=ImageDataSet[slot].Grid
																			uDisplayCB (grid, message, v0, v1, v2, v3, kid, grid)
																END IF
			CASE	#WindowSelected		: slot=uDisplayGetSlot (grid,2)
																IF slot<>-1 THEN
														    grid=ImageDataSet[slot].Grid
																			uDisplayCB (grid, message, v0, v1, v2, v3, kid, grid)
																END IF

			'CASE	#WindowKeyDown		:
			'CASE	#WindowMouseDown	:
			'CASE ELSE							:
			'CASE #WindowSystemMessage : WndProcMessage (v0, v1, v2, v3, kid, r1)
	END SELECT

END FUNCTION
'
'	#######################
'	#####  Output ()  #####
'	#######################
'
'
'
FUNCTION  Output (grid, message, v0, v1, v2, v3, r0, (r1, r1$, r1[], r1$[]))
	SHARED 	SINGLE ww,hh,xx,yy
	SHARED Image ImageFormat[]
	STATIC  designX,  designY,  designWidth,  designHeight
	STATIC  SUBADDR  sub[]
	STATIC  upperMessage
	STATIC  Output
'
	$Output          =   0  ' kid   0 grid type = Output
	$PushB1          =   1
	$PushB2          =   2
	$PushB6          =   3
	$PushB5          =   4
	$PushB4          =   5
	$PushB3          =   6
	$Label           =   7
	$PushB7          =   8
	$vTrackScroll    =   9
	$SwitchMode      =  10
	$PushB8          =  11
	$PushB9          =  12
	$PushB10         =  13
	$HvalueCover     =  14
	$InputTextLine1  =  15
	$InputLabel1     =  16
	$PushB11				 =	17
	$PushB12				 =	18
	$PushB13				 =	19
	$PushB14				 =	20
	$PushB15				 =	21
	$PushB16				 =	22
	$ToolButton			 =	23
	$Quit						 =	24
	$zoomIN					 =	25
	$zoomOUT				 =	26
	$increaseXzoom	 =	27
	$decreaseXzoom	 =	28
	$Minimize				 =	29
	$Iconize				 =  30
	$sigBt1		       =  31
	$sigBt2		       =  32
	$sigBt3		       =  33
	$sigBt4		       =  34
	$sigBt5		       =  35
	$centre		       =  36
	$close					 =	37
	$colourbar			 =	38
	$IncreaseZoom		 =	39
	$DecreaseZoom		 =	40
	$ModMin					=		41
	$ModMax					=		42
	$OpenedFileList	=		43
	$CloseDs  =					44
	$UpperKid        =  44
'
	IFZ sub[] THEN GOSUB Initialize
'	XuiReportMessage (grid, message, v0, v1, v2, v3, r0, r1)
	IF XuiProcessMessage (grid, message, @v0, @v1, @v2, @v3, @r0, @r1, Output) THEN RETURN
	IF (message <= upperMessage) THEN GOSUB @sub[message]
	RETURN
'
'
SUB Callback
	message = r1
	callback = message
	IF (message <= upperMessage) THEN GOSUB @sub[message]
END SUB
'
'
' *****  Create  *****  v0123 = xywh : r0 = window : r1 = parent
SUB Create
	IF (v0 <= 0) THEN v0 = 0
	IF (v1 <= 0) THEN v1 = 0
	IF (v2 <= 0) THEN v2 = designWidth
	IF (v3 <= 0) THEN v3 = designHeight
	XuiCreateGrid  (@grid, Output, @v0, @v1, @v2, @v3, r0, r1, &Output())
	XuiSendMessage ( grid, #SetGridName, 0, 0, 0, 0, 0, @"Output")
	XuiSendMessage ( grid, #SetColor, #background, #background, #background, #background, 0, 0)
	XuiSendMessage ( grid, #SetColorExtra, #background, #background, #background, #background, 0, 0)
'	XuiSendMessage ( grid, #SetBorder, $$BorderWindowResize , $$BorderWindowResize , $$BorderWindowResize , 0, 0, 0)
	#OutputG=grid

	XuiPushButton  (@g, #Create, 76, 8, 16, 20, r0, grid)
	XgrCreateFields (g, $PushB1 , "PushB1","1" , "Next File", grid)
'	XuiSendMessage (g, #SetCursor,#rightarrow, 0, 0, 0, 0, 0)
	XuiSendMessage (g, #SetCursor,#cursorHand, 0, 0, 0, 0, 0)
	#nextfg=g

	XuiPushButton  (@g, #Create, 76, 32, 16, 20, r0, grid)
	XgrCreateFields (g, $PushB2 ,"PushB2" ,"2" ,"Previous File" , grid)
	XuiSendMessage (g, #SetCursor,#cursorHand, 0, 0, 0, 0, 0)
	#prefg=g

	XuiArea       (@g, #Create, 660, 376, 20, 20, r0, grid)
	XgrCreateFields (g, $PushB6 ,"PushB6" ,"" ,"" , grid)
	XuiSendMessage (g, #SetCursor, #cursorArrowsAll, 0, 0, 0, 0, 0)

	XuiPushButton  (@g, #Create, 572, 372, 28, 20, r0, grid)
	XgrCreateFields (g, $PushB5 ,"PushB5" , "A","Scales current track to window" , grid)
	XuiSendMessage (g, #SetCursor,#cursorHand, 0, 0, 0, 0, 0)

	XuiPressButton (@g, #Create, 116, 308, 20, 20, r0, grid)
	XgrCreateFields (g, $PushB4 ,"PushB4" ,"+" ,"Increase vertical scale" , grid)
	XuiSendMessage (g, #SetCursor,#cursorHand, 0, 0, 0, 0, 0)

	XuiPressButton (@g, #Create, 76, 304, 20, 20, r0, grid)
	XgrCreateFields (g,  $PushB3 , "PushB3","-" ,"Decrease vertical scale" , grid)
	XuiSendMessage (g, #SetCursor,#cursorHand, 0, 0, 0, 0, 0)

	XuiArea    (@g, #Create, 440, 184, 24, 24, r0, grid)
	XuiSendMessage ( g, #SetCallback, grid, &Output(), -1, -1, $Label, grid)
	XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"Label")
	XuiSendMessage ( g, #SetColor, #background, #background, #background, #background, 0, 0)
	XuiSendMessage ( g, #SetColorExtra, #background, #background, #background, #background, 0, 0)
	XuiSendMessage ( g, #SetBorder, $$BorderRaise1, $$BorderRaise1, $$BorderNone, 0, 0, 0)
	XuiSendMessage ( g, #SetFont, 250, 200, 0, 0, 0, @"Comic Sans")
	#image=g

	XuiPushButton  (@g, #Create, 624, 376, 20, 20, r0, grid)
	XgrCreateFields (g, $PushB7 , "PushB7","R" ,"Reset track to default scaling" , grid)
	XuiSendMessage (g, #SetCursor,#cursorHand, 0, 0, 0, 0, 0)

	XuiScrollBarV  (@g, #Create, 708, 8, 16, 348, r0, grid)
	XuiSendMessage ( g, #SetCallback, grid, &Output(), -1, -1, $vTrackScroll, grid)
	XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"vTrackScroll")
	XuiSendMessage ( g, #SetStyle, 2, 0, 0, 0, 0, 0)
	XuiSendMessage ( g, #SetColor, #bColour,#bInk ,#bInk ,#bInk, 0, 0)
	XuiSendMessage ( g, #SetAlign, $$AlignMiddleCenter, 0, -1, -1, 0, 0)
	XuiSendMessage ( g, #SetBorder, $$BorderRaise4, $$BorderRaise4, $$BorderNone, 0, 0, 0)
	XuiSendMessage ( g, #SetHintString, 0, 0, 0, 0, 0, @"Change track")
'	XuiSendMessage (g, #SetCursor,#cursorHand, 0, 0, 0, 0, 0)


	XuiPushButton  (@g, #Create, 600, 350, 20, 20, r0, grid)
	XgrCreateFields (g,$SwitchMode  ,"SwitchMode" ,"I" ,"Image mode. still beta" , grid)
	XuiSendMessage (g, #SetCursor,#cursorHand, 0, 0, 0, 0, 0)

	XuiPushButton  (@g, #Create, 510, 310, 20, 20, r0, grid)
	XgrCreateFields (g,$PushB8 , "PushB8", "M", "Maximize Window", grid)
	XuiSendMessage (g, #SetCursor,#cursorHand, 0, 0, 0, 0, 0)

	XuiPushButton  (@g, #Create, 511, 311, 20, 20, r0, grid)
	XgrCreateFields (g, $PushB9 ,"PushB9" , "L","Draw track using single or connecting points" , grid)
	XuiSendMessage (g, #SetCursor,#cursorHand, 0, 0, 0, 0, 0)

	XuiPushButton  (@g, #Create, 511, 311, 20, 20, r0, grid)
	XgrCreateFields (g, $PushB10 ,"PushB10" ,"C" ,"Cursor type" , grid)
	XuiSendMessage (g, #SetCursor,#cursorHand, 0, 0, 0, 0, 0)

	XuiLabel		    (@g, #Create, 100, 100, 20, 20, r0, grid)
	XgrCreateFields (g, $HvalueCover ,"HvalueCover" , "", "", grid)
'	XuiSendMessage ( g, #SetFont, 200, 200, 0, 0, 0, @"Comic Sans MS")
'	XuiSendMessage ( g, #SetColor, #ink,#ink ,#ink ,#ink, 0, 0)
'	XuiSendMessage ( g, #SetColorExtra, #ink,#ink ,#ink ,#ink, 0, 0)
	XuiSendMessage ( g, #SetCursor, #cursorArrowsAll, 0, 0, 0, 0, 0)
	#hcover=g

	XuiTextLine    (@g, #Create, 164, 368, 68, 20, r0, grid)
	XuiSendMessage ( g, #SetCallback, grid, &Output(), -1, -1, $InputTextLine1, grid)
	XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"InputTextLine1")
	XuiSendMessage ( g, #SetColor, #bColour, #bInk , 0, #bInk , 0 ,0 )
	XuiSendMessage ( g, #SetAlign, $$AlignMiddleCenter, 0, -1, -1, 0, 0)

	XuiLabel       (@g, #Create, 20, 368, 144, 20, r0, grid)
	XgrCreateFields (g, $InputLabel1, "InputLabel1", "", "click then press 'Enter' twice to exit" , grid)
	XuiSendMessage ( g, #SetFont, 240, 600, 0, 0, 0, @"Comic Sans MS")

	XuiPushButton  (@g, #Create, 219, 147, 20, 20, r0, grid)
	XgrCreateFields (g, $PushB11 ,"PushB11" ,"H" , "Manualy select horizontal range", grid)
	XuiSendMessage (g, #SetCursor,#cursorHand, 0, 0, 0, 0, 0)

	XuiPushButton  (@g, #Create, 219, 147, 20, 20, r0, grid)
	XgrCreateFields (g,$PushB12  ,"PushB12" ,"V" ,"Manualy select vertical range" , grid)
	XuiSendMessage (g, #SetCursor,#cursorHand, 0, 0, 0, 0, 0)

	XuiPushButton  (@g, #Create, 219, 147, 20, 20, r0, grid)
	XgrCreateFields (g, $PushB13 , "PushB13", "S","Select window scaling range" , grid)
	XuiSendMessage (g, #SetCursor,#cursorHand, 0, 0, 0, 0, 0)

	XuiPushButton  (@g, #Create, 219, 147, 20, 20, r0, grid)
	XgrCreateFields (g, $PushB14  , "PushB14","F" , "Open file", grid)
	XuiSendMessage  (g, #SetCursor,#cursorHand, 0, 0, 0, 0, 0)

	XuiPushButton  (@g, #Create, 219, 147, 20, 20, r0, grid)
	XgrCreateFields (g, $PushB15 ,"PushB15" ,"P" , "Use this if either ImageFormat[#ImageSet,#dataFile].NumberOfPixels or ImageFormat[#ImageSet,#dataFile].NumberOfTracks are incorrectly detected", grid)
	XuiSendMessage  (g, #SetCursor,#cursorHand, 0, 0, 0, 0, 0)

	XuiPushButton  (@g, #Create, 219, 147, 20, 20, r0, grid)
	XgrCreateFields (g, $PushB16,"PushB16","FI","Scans all tracks for optimum scaling",grid)
	XuiSendMessage  (g, #SetCursor,#cursorHand, 0, 0, 0, 0, 0)

	XuiPushButton  (@g, #Create, 219, 147, 20, 20, r0, grid)
	XgrCreateFields (g, $ToolButton, "ToolButton","T", "A nice dockable tool bar",grid)
	XuiSendMessage  (g, #SetCursor,#cursorHand, 0, 0, 0, 0, 0)

	XuiPushButton  (@g, #Create, 219, 147, 20, 20, r0, grid)
	XgrCreateFields (g, $Quit, "Quit","Q", "Quit",grid)
	XuiSendMessage  (g, #SetCursor,#cursorHand, 0, 0, 0, 0, 0)

	XuiPushButton  (@g, #Create, 219, 147, 20, 20, r0, grid)
	XgrCreateFields (g, $zoomIN, "zoomIN","I", "Increase Zoom",grid)
	XuiSendMessage ( g, #SetCursor,#cursorHand, 0, 0, 0, 0, 0)

	XuiPushButton  (@g, #Create, 219, 147, 20, 20, r0, grid)
	XgrCreateFields (g, $zoomOUT, "zoomOUT","O", "Decrease Zoom",grid)
	XuiSendMessage ( g, #SetCursor,#cursorHand, 0, 0, 0, 0, 0)

	XuiPushButton  (@g, #Create, 219, 147, 20, 20, r0, grid)
	XgrCreateFields (g, $increaseXzoom, "$increaseXzoom","-", "Decrease horizontal scale",grid)
	XuiSendMessage ( g, #SetCursor,#cursorHand, 0, 0, 0, 0, 0)

	XuiPushButton  (@g, #Create, 219, 147, 20, 20, r0, grid)
	XgrCreateFields (g, $decreaseXzoom, "$decreaseXzoom","+", "Increase horizontal scale",grid)
	XuiSendMessage ( g, #SetCursor,#cursorHand, 0, 0, 0, 0, 0)

	XuiPushButton  (@g, #Create, 510, 310, 20, 20, r0, grid)
	XgrCreateFields (g, $Minimize , "Minimize", "_", "Minimize Window", grid)
	XuiSendMessage ( g, #SetCursor,#cursorHand, 0, 0, 0, 0, 0)

	XuiPushButton  (@g, #Create, 510, 310, 20, 20, r0, grid)
	XgrCreateFields (g, $Iconize , "Iconize", ".", "Icon Window", grid)
	XuiSendMessage  (g, #SetCursor,#cursorHand, 0, 0, 0, 0, 0)

	XuiPressButton (@g, #Create, 284, 60, 32, 20, r0, grid)
	XuiSendMessage ( g, #SetCallback, grid, &Output(), -1, -1, $sigBt1, grid)
	XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"sigBt1")
	XuiSendMessage ( g, #SetBorder, $$BorderNone, $$BorderNone, $$BorderLower1, 0, 0, 0)
	XuiSendMessage ( g, #SetFont, 240, 400, 0, 0, 0, @"MS Sans Serif")
	XuiSendMessage ( g, #SetTexture, $$TextureNone, 0, 0, 0, 0, 0)
	XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"Sig")
	XuiSendMessage ( g, #SetCursor,#cursorHand, 0, 0, 0, 0, 0)

	XuiPressButton (@g, #Create, 284, 60, 32, 20, r0, grid)
	XuiSendMessage ( g, #SetCallback, grid, &Output(), -1, -1, $sigBt2, grid)
	XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"sigBt2")
	XuiSendMessage ( g, #SetBorder, $$BorderNone, $$BorderNone, $$BorderLower1, 0, 0, 0)
	XuiSendMessage ( g, #SetFont, 240, 400, 0, 0, 0, @"MS Sans Serif")
	XuiSendMessage ( g, #SetTexture, $$TextureNone, 0, 0, 0, 0, 0)
	XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"Bg")
	XuiSendMessage ( g, #SetCursor,#cursorHand, 0, 0, 0, 0, 0)


	XuiPressButton (@g, #Create, 284, 60, 32, 20, r0, grid)
	XuiSendMessage ( g, #SetCallback, grid, &Output(), -1, -1, $sigBt3, grid)
	XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"sigBt3")
	XuiSendMessage ( g, #SetBorder, $$BorderNone, $$BorderNone, $$BorderLower1, 0, 0, 0)
	XuiSendMessage ( g, #SetFont, 240, 400, 0, 0, 0, @"MS Sans Serif")
	XuiSendMessage ( g, #SetTexture, $$TextureNone, 0, 0, 0, 0, 0)
	XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"Ref")
	XuiSendMessage ( g, #SetCursor,#cursorHand, 0, 0, 0, 0, 0)

	XuiPressButton (@g, #Create, 284, 60, 32, 20, r0, grid)
	XuiSendMessage ( g, #SetCallback, grid, &Output(), -1, -1, $sigBt4, grid)
	XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"sigBt4")
	XuiSendMessage ( g, #SetBorder, $$BorderNone, $$BorderNone, $$BorderLower1, 0, 0, 0)
	XuiSendMessage ( g, #SetFont, 240, 400, 0, 0, 0, @"MS Sans Serif")
	XuiSendMessage ( g, #SetTexture, $$TextureNone, 0, 0, 0, 0, 0)
	XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"Liv")
	XuiSendMessage ( g, #SetCursor,#cursorHand, 0, 0, 0, 0, 0)

	XuiPressButton (@g, #Create, 284, 60, 32, 20, r0, grid)
	XuiSendMessage ( g, #SetCallback, grid, &Output(), -1, -1, $sigBt5, grid)
	XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"sigBt5")
	XuiSendMessage ( g, #SetBorder, $$BorderNone, $$BorderNone, $$BorderLower1, 0, 0, 0)
	XuiSendMessage ( g, #SetFont, 240, 400, 0, 0, 0, @"MS Sans Serif")
	XuiSendMessage ( g, #SetTexture, $$TextureNone, 0, 0, 0, 0, 0)
	XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"Src")
	XuiSendMessage ( g, #SetCursor,#cursorHand, 0, 0, 0, 0, 0)

	XuiPushButton  (@g, #Create, 510, 310, 20, 20, r0, grid)
	XgrCreateFields (g, $centre , "Centre", "*", "Centre Window", grid)
	XuiSendMessage  (g, #SetCursor,#cursorHand, 0, 0, 0, 0, 0)

	XuiPushButton  (@g, #Create, 510, 310, 20, 20, r0, grid)
	XgrCreateFields (g, $close , "Close", "X", "Close Window", grid)
	XuiSendMessage  (g, #SetCursor,#cursorHand, 0, 0, 0, 0, 0)

	XuiArea       (@g, #Create, 660, 376, 20, 10, r0, grid)
	XgrCreateFields (g, $colourbar ,"colourbar" ,"" ,"" , grid)
	XuiSendMessage (g, #SetCursor, #cursorArrowsAll, 0, 0, 0, 0, 0)

	XuiPushButton  (@g, #Create, 510, 310, 20, 20, r0, grid)
	XgrCreateFields (g, $IncreaseZoom , "IncreaseZoom", "<", "Increase Zoom", grid)
	XuiSendMessage  (g, #SetCursor,#cursorHand, 0, 0, 0, 0, 0)

	XuiPushButton  (@g, #Create, 510, 310, 20, 20, r0, grid)
	XgrCreateFields (g, $DecreaseZoom, "DecreaseZoom", ">", "Decrease Zoom", grid)
	XuiSendMessage  (g, #SetCursor,#cursorHand, 0, 0, 0, 0, 0)

	XuiLabel       (@g, #Create, 20, 368, 20, 20, r0, grid)
	XgrCreateFields (g, $ModMax, "ModMin", "", "" , grid)
	#ModMinG=g

	XuiLabel       (@g, #Create, 20, 330, 20, 20, r0, grid)
	XgrCreateFields (g, $ModMin, "ModMax", "", "" , grid)
	#ModMaxG=g

	XuiListButton  (@g, #Create, 24, 36, 20, 36, r0, grid)
	XuiSendMessage ( g, #SetCallback, grid, &Output(), -1, -1, $OpenedFileList, grid)
	XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"OpenedFileList")
	XuiSendMessage ( g, #SetStyle, 0, 0, 0, 0, 0, 0)
	XuiSendMessage ( g, #SetFont, 240, 400, 0, 0, 1, @"Comic Sans MS")
	XuiSendMessage ( g, #SetColorExtra, $$BrightGrey, $$White, $$Black, $$White, 0, 0)
	XuiSendMessage ( g, #SetAlign, $$AlignMiddleCenter, 0, -1, -1, 0, 0)
	XuiSendMessage ( g, #SetIndent, 0, 0, 0, 0, 0, 0)
	XuiSendMessage ( g, #SetTexture, $$TextureLower1, 0, 0, 0, 0, 0)
	XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 1, @"PressButton")
	XuiSendMessage ( g, #SetColor, $$BrightGrey, $$LightBlue, $$Black, $$White, 1, 0)
	XuiSendMessage ( g, #SetColorExtra, $$Grey, $$LightBlue, $$Black, $$White, 1, 0)
	XuiSendMessage ( g, #SetAlign, $$AlignMiddleLeft, $$JustifyLeft, -1, -1, 1, 0)
	XuiSendMessage ( g, #SetBorder, $$BorderNone, $$BorderNone, $$BorderLower1, 0, 1, 0)
'	XuiSendMessage ( g, #SetBorder, $$BorderLoLine1, $$BorderLoLine1, $$BorderLower1, 0, 1, 0)
	XuiSendMessage ( g, #SetIndent, 2, 0, 0, 0, 1, 0)
	XuiSendMessage ( g, #SetTexture, $$TextureNone, 0, 0, 0, 1, 0)
	XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 2, @"XuiList730")
	XuiSendMessage ( g, #SetStyle, 2, 0, 0, 0, 2, 0)
	XuiSendMessage ( g, #SetColor, $$BrightGrey, $$LightBlue, $$Black, $$White, 2, 0)
	XuiSendMessage ( g, #SetColorExtra, $$Grey, $$White, $$Black, $$White, 2, 0)
	XuiSendMessage ( g, #SetAlign, $$AlignMiddleCenter, 0, -1, -1, 2, 0)
	XuiSendMessage ( g, #SetBorder, $$BorderLoLine1, $$BorderLoLine1, $$BorderRidge, 0, 2, 0)
	XuiSendMessage ( g, #SetIndent, 2, 0, 0, 0, 2, 0)

	XuiPushButton  (@g, #Create, 219, 147, 20, 20, r0, grid)
	XgrCreateFields(g, $CloseDs ,"CloseDs" ,"x" ,"Close this dataset" , grid)
	XuiSendMessage (g, #SetCursor,#cursorHand, 0, 0, 0, 0, 0)

	#OutputUpperKid=$UpperKid
	GOSUB Resize

END SUB
'
'
' *****  CreateWindow  *****  v0123 = xywh : r0 = windowType : r1$ = display$
'
SUB CreateWindow
	IF (v0 == 0) THEN v0 = designX
	IF (v1 == 0) THEN v1 = designY
	IF (v2 <= 0) THEN v2 = designWidth
	IF (v3 <= 0) THEN v3 = designHeight
	XuiWindow (@window, #WindowCreate, v0, v1, v2, v3, r0, @r1$)
	v0 = 0 : v1 = 0 : r0 = window : ATTACH r1$ TO display$
	GOSUB Create
	r1 = 0 : ATTACH display$ TO r1$
	XuiWindow (window, #WindowRegister, grid, -1, v2, v3, @r0, @"Output")
END SUB
'
'
' *****  GetSmallestSize  *****  see "Anatomy of Grid Functions"
'
SUB GetSmallestSize
END SUB
'
'
' *****  Redrawn  *****  see "Anatomy of Grid Functions"
'
SUB Redrawn

'	XuiCallback (grid, #Redrawn, v0, v1, v2, v3, r0, r1)

END SUB
'
' *****  Resize  *****  see "Anatomy of Grid Functions"
'
SUB Resize

IF #SnapIToWindow=0 THEN
	IF v2< #Minxx THEN v2=#Minxx-50
	IF v3< #Minyy THEN v3=#Minyy
END IF

	#v2=v2:	#v3=v3
	ResizeWindows ()

	XuiSendMessage (grid, #Resize, 44, v3-48, 20, 20, $IncreaseZoom, 0)
	XuiSendMessage (grid, #Resize, 12, v3-48, 20, 20, $DecreaseZoom, 0)

	XuiSendMessage (grid, #Resize, #leftmargin-42,y+23, 42, 20, $ModMin, 0)
	XuiSendMessage (grid, #Resize, ww+#leftmargin,y+23,34, 21, $ModMax, 0)
'	XuiSendMessage (grid, #Resize, ww+#leftmargin+12,#topmargin,18, 18, $CloseDs, 0)

	XuiSendMessage (grid, #Resize, v2-118,4, 20, 20, $Minimize, 0)		' bar
	XuiSendMessage (grid, #Resize, v2-58, 4, 20, 20, $PushB8, 0)			' max
	XuiSendMessage (grid, #Resize, v2-88, 4, 20, 20, $centre, 0)			' centre window to screen
	XuiSendMessage (grid, #Resize, v2-28, 4, 20, 20, $close, 0)				'	exit application
	XuiSendMessage (grid, #Resize, 2, 2, 22, 20, $Iconize, 0)

	IF #currentDisplay=1 THEN y=#topmargin-19 ELSE y=#topmargin-51
	x=#leftmargin-1
	XuiSendMessage (grid, #Resize, x, y, ww-95, 18, $OpenedFileList, 0)

	vw=#v2-39 : vh=#v3-38
	XuiSendMessage (grid, #Resize, vw, vh, 33, 33, $PushB6, 0)
	vh=#v3-26: vw=447+#leftmargin+73
	XuiSendMessage (grid, #Resize, vw, #v3-46, 20, 20, $PushB5, 0)

	vw=547+#leftmargin+32
	XuiSendMessage (grid, #Resize, vw, #v3-46, 22, 22, $SwitchMode, 0)

	XuiSendMessage (grid, #Resize, 12, #v3-19,20, 20, $sigBt1, 0)
	XuiSendMessage (grid, #Resize, 42, #v3-19,20, 20, $sigBt2, 0)
	XuiSendMessage (grid, #Resize, 72, #v3-19,20, 20, $sigBt3, 0)
	XuiSendMessage (grid, #Resize, 102, #v3-19,20, 20, $sigBt4, 0)
	XuiSendMessage (grid, #Resize, 132, #v3-19,20, 20, $sigBt5, 0)

	vw=477+#leftmargin+77
	XuiSendMessage (grid, #Resize, vw, #v3-46, 20, 20, $PushB16, 0)
	vw=417+#leftmargin+73
	XuiSendMessage (grid, #Resize, vw, #v3-46, 20, 20, $PushB7, 0)
	vw=347+#leftmargin+73
	XuiSendMessage (grid, #Resize, vw, #v3-46, 20, 20, $PushB9, 0)
	vw=317+#leftmargin+73
	XuiSendMessage (grid, #Resize, vw, #v3-46, 20, 20, $PushB10, 0)
	vw=287+#leftmargin+73
	XuiSendMessage (grid, #Resize, vw, #v3-46, 20, 20, $PushB11, 0)
	vw=257+#leftmargin+73
	XuiSendMessage (grid, #Resize, vw, #v3-46, 20, 20, $PushB12, 0)
	vw=387+#leftmargin+73
	XuiSendMessage (grid, #Resize, vw, #v3-46, 20, 20, $PushB13, 0)
	vw=197+#leftmargin+73
	XuiSendMessage (grid, #Resize, vw, #v3-46, 20, 20, $PushB14, 0)
	vw=167+#leftmargin+73
	XuiSendMessage (grid, #Resize, vw, #v3-46, 20, 20, $PushB15, 0)
	vw=137+#leftmargin+73
	XuiSendMessage (grid, #Resize, vw, #v3-46, 20, 20, $ToolButton, 0)
	vw=107+#leftmargin+73
	XuiSendMessage (grid, #Resize, vw, #v3-46, 20, 20, $Quit, 0)
	vw=(#leftmargin/2)-20
	XuiSendMessage (grid, #Resize, vw, #v3-50, 20, 20, $zoomOUT, 0)
	vw=(#leftmargin/2)+10
	XuiSendMessage (grid, #Resize, vw, #v3-50, 20, 20, $zoomIN, 0)
	vw=#leftmargin+60
	XuiSendMessage (grid, #Resize, vw, #v3-50, 20, 20, $increaseXzoom, 0)
	vw=#leftmargin+30
	XuiSendMessage (grid, #Resize, vw, #v3-50, 20, 20, $decreaseXzoom, 0)

	vw=400: vh=#v3-19
	XuiSendMessage (grid, #Resize, vw, vh, 144, 20, $InputLabel1, 0)
	vw=vw+144
	XuiSendMessage (grid, #Resize, vw, vh+1, 68, 19, $InputTextLine1, 0)

	vw=4: vh=#v3-110
	XuiSendMessage (grid, #Resize, vw, vh, 16, 20, $PushB4, 0)
	vh=#v3-85
	XuiSendMessage (grid, #Resize, vw, vh, 16, 20, $PushB3, 0)

	vh=25
	XuiSendMessage (grid, #Resize, vw, vh, 16, 20, $PushB1, 0)
	vh=50
	XuiSendMessage (grid, #Resize, vw, vh, 16, 20, $PushB2, 0)

	XuiSendMessage (grid, #Resize, #leftmargin+160, #v3-70, 520, 70, $HvalueCover, 0)


	IF (v2 < #Minxx) THEN #drawXinfo = 0 ELSE #drawXinfo = 1
	IF (v3 < (#Minyy+1)) THEN #drawYinfo = 0 ELSE #drawYinfo = 1
	IF (v2 < (#Minyy-10)) THEN #drawVinfo = 0 ELSE #drawVinfo = 1

	XuiPositionGrid (#OutputG, @v0, @v1, v2, v3)
	PlaceToolbar ()

END SUB
'
'
'
SUB Selection
END SUB
'
'
' *****  Initialize  *****  see "Anatomy of Grid Functions"
'
SUB Initialize
	XuiGetDefaultMessageFuncArray (@func[])
	XgrMessageNameToNumber (@"LastMessage", @upperMessage)
'
  func[#Resize]             = &XuiResizeNot()
	func[#Callback]           = &XuiCallback ()
'	func[#GetSmallestSize]    = &XuiGetSmallestSize()
'	func[#Resize]             = 0
'
	DIM sub[upperMessage]
'	sub[#Callback]            = SUBADDRESS (Callback)
	sub[#Create]              = SUBADDRESS (Create)
	sub[#CreateWindow]        = SUBADDRESS (CreateWindow)
	sub[#GetSmallestSize]     = SUBADDRESS (GetSmallestSize)
	sub[#Redrawn]             = SUBADDRESS (Redrawn)
	sub[#Resize]              = SUBADDRESS (Resize)
	sub[#Selection]           = SUBADDRESS (Selection)
'
'	IF sub[0] THEN PRINT "Output() : Initialize : error ::: (undefined message)"
'	IF func[0] THEN PRINT "Output() : Initialize : error ::: (undefined message)"
	XuiRegisterGridType (@Output, "Output", &Output(), @func[], @sub[])
'
	designX = xx
	designY = yy
	designWidth = ww
	designHeight = hh
'
'
	gridType = Output
	XuiSetGridTypeProperty (gridType, @"x",                designX)
	XuiSetGridTypeProperty (gridType, @"y",                designY)
	XuiSetGridTypeProperty (gridType, @"width",            designWidth)
	XuiSetGridTypeProperty (gridType, @"height",           designHeight)
'	XuiSetGridTypeProperty (gridType, @"maxWidth",         designWidth)
'	XuiSetGridTypeProperty (gridType, @"maxHeight",        designHeight)
'	XuiSetGridTypeProperty (gridType, @"minWidth",         #Minxx)
'	XuiSetGridTypeProperty (gridType, @"minHeight",        #Minyy)
	XuiSetGridTypeProperty (gridType, @"can",              $$Focus OR $$Respond OR $$Callback)

	IFZ message THEN RETURN

END SUB

END FUNCTION
'
'
' ###########################
' #####  OutputCode ()  #####
' ###########################
'
FUNCTION  OutputCode (grid, message, v0, v1, v2, v3, kid, r1)
	SHARED Image ImageFormat[]
	SHARED MemDataSet ImageDataSet[]
	SHARED LoadedFiles$[]

	$Output          =   0
	$PushB1          =   1
	$PushB2          =   2
	$PushB6          =   3
	$PushB5          =   4
	$PushB4          =   5
	$PushB3          =   6
	$Label           =   7
	$PushB7          =   8
	$vTrackScroll    =   9
	$SwitchMode      =  10
	$PushB8          =  11
	$PushB9          =  12
	$PushB10         =  13
	$HvalueCover     =  14
'	$InputTextLine1  =  15
	$InputLabel1     =  16
	$PushB11				 =	17
	$PushB12				 =	18
	$PushB13				 =	19
	$PushB14				 =	20
	$PushB15				 =	21
	$PushB16				 =	22
	$ToolButton			 =	23
	$Quit						 =	24
	$zoomIN					 =	25
	$zoomOUT				 =	26
	$increaseXzoom	 =	27
	$decreaseXzoom	 =	28
	$Minimize				 =	29
	$Iconize				 =  30
	$sigBt1		       =  31
	$sigBt2		       =  32
	$sigBt3		       =  33
	$sigBt4		       =  34
	$sigBt5		       =  35
	$centre		       =  36
	$close					 =	37
	$colourbar			 =	38
	$IncreaseZoom		 =	39
	$DecreaseZoom		 =	40
	$ModMin					=		41
	$ModMax					=		42
	$OpenedFileList	=		43
	$CloseDs  =					44
	$UpperKid        =  44

'	XuiReportMessage (grid, message, v0, v1, v2, v3, kid, r1)
	IF (message == #Callback) THEN message = r1
'	XgrMessageNumberToName  (message,@message$): PRINT grid, message$, v0, v1, v2, v3, kid, r1

	SELECT CASE message
		CASE #Redrawn			:	Redraw (#OutputWindow,kid,v0,v1,v2,v3): RETURN
		CASE #Selection		: GOSUB Selection: RETURN  	' most common callback message
		CASE #KeyDown 		:	IF #MinSize=0 THEN KeyDown (v0,v1,v2): RETURN
		CASE #Help   			: MouseDownRight (v0,v1,kid): RETURN
		CASE #CloseWindow	: Quit()
		CASE #Change			:	IF kid = $vTrackScroll	THEN vScrollChange (#ImageSet,v1,v3,0): RETURN
		CASE #MuchMore		: downTenTracks (): RETURN
		CASE #MuchLess		: upTenTracks (): RETURN
		CASE #OneLess			: upTrk (): RETURN
		CASE #OneMore			:	downTrk (): RETURN
	END SELECT
RETURN


SUB Selection

	SELECT CASE kid
		CASE $IncreaseZoom	: zoomXtrack (#zoomXtrack!)
		CASE $DecreaseZoom	: zoomdeXtrack (#zoomXtrack!)
		CASE $PushB3				:	vScaleDown()
		CASE $PushB4				:	vScaleUp()
		CASE $PushB1				:	ReadLastFile ()
		CASE $PushB2				:	ReadNextFile ()
		CASE $PushB5				: ScaleRange()
		CASE $PushB7				:	ResetScale()
		CASE $SwitchMode		: SwitchDisplayMode()
		CASE $PushB8				: MaxScreen ()
		CASE $PushB9				: LineTypeSelect2d()
		CASE $PushB10				: CursorTypeSelect()
		CASE $PushB12				:	DisplayWindow (#GotoWindow)
		CASE $PushB11				:	nextColTable(): setvColBar ()
		CASE $PushB15				: DisplayWindow (#AxisWindow)
		CASE $PushB13				: NextScalingRange ()
		CASE $PushB14				: SelectFileMenu (0,#ImageSet)
		CASE $PushB16				: ScaleToAllTracks ()
		CASE $ToolButton		: ToolMenuState ()
		CASE $Quit					:	DisplayWindow (#AddTraceWWindow)
													'IF PopUpBoxB ("Are you sure?","Quit", $$MB_ICONQUESTION | $$MB_YESNO)=6 THEN Quit()
		CASE $close					: Quit()
		CASE $CloseDs				: CloseDataSet (#ImageSet)
		CASE $zoomIN				:	zoomINi ()
		CASE $zoomOUT				:	zoomOUTi ()
		CASE $Minimize			: MinScreen(-1)
		CASE $Iconize				: MinScreen(5)
		CASE $sigBt1				: IF (ImageDataSet[#ImageSet].currentImageBt<>$$Sig) THEN ImageDataSet[#ImageSet].currentImageBt=$$Sig: GetNextDataSet ()
		CASE $sigBt2				: IF (ImageDataSet[#ImageSet].currentImageBt<>$$Ref) THEN ImageDataSet[#ImageSet].currentImageBt=$$Ref: GetNextDataSet ()
		CASE $sigBt3				: IF (ImageDataSet[#ImageSet].currentImageBt<>$$Bg)  THEN ImageDataSet[#ImageSet].currentImageBt=$$Bg : GetNextDataSet ()
		CASE $sigBt4				: IF (ImageDataSet[#ImageSet].currentImageBt<>$$Liv) THEN ImageDataSet[#ImageSet].currentImageBt=$$Liv: GetNextDataSet ()
		CASE $sigBt5				: IF (ImageDataSet[#ImageSet].currentImageBt<>$$Src) THEN ImageDataSet[#ImageSet].currentImageBt=$$Src: GetNextDataSet ()
		CASE $centre				: CentreWindow (#OutputWindow)
		CASE $increaseXzoom : INC #col: #copyImage=1: GetNewImage (#image,1,1,0)
		CASE $decreaseXzoom : DEC #col: IF #col<1 THEN #col=1: EXIT FUNCTION
													#copyImage=1: GetNewImage (#image,1,1,0)
		CASE $OpenedFileList : LoadFile (LoadedFiles$[v0],#ImageSet)
	END SELECT


END SUB

END FUNCTION
'
'
'	########################
'	#####  Message ()  #####
'	########################
'
'
FUNCTION  Message (grid, message, v0, v1, v2, v3, r0, (r1, r1$, r1[], r1$[]))
	STATIC  designX,  designY,  designWidth,  designHeight
	STATIC  SUBADDR  sub[]
	STATIC  upperMessage
	STATIC  Message
'
	$Message            =   0  ' kid   0 grid type = Message
	$MessageText        =   1  ' kid   1 grid type = XuiLabel
	$ButtonYes          =   2  ' kid   2 grid type = XuiPushButton
	$ButtonNo           =   3  ' kid   3 grid type = XuiPushButton
	$UpperKid           =   3  ' kid maximum
'
'
	IFZ sub[] THEN GOSUB Initialize
'	XuiReportMessage (grid, message, v0, v1, v2, v3, r0, r1)
	IF XuiProcessMessage (grid, message, @v0, @v1, @v2, @v3, @r0, @r1, Message) THEN RETURN
	IF (message <= upperMessage) THEN GOSUB @sub[message]
	RETURN
'
'
' *****  Callback  *****  message = Callback : r1 = original message
'
SUB Callback
	message = r1
	callback = message
	IF (message <= upperMessage) THEN GOSUB @sub[message]
END SUB
'
'
' *****  Create  *****  v0123 = xywh : r0 = window : r1 = parent
'
SUB Create
	IF (v0 <= 0) THEN v0 = 0
	IF (v1 <= 0) THEN v1 = 0
	IF (v2 <= 0) THEN v2 = designWidth
	IF (v3 <= 0) THEN v3 = designHeight
	XuiCreateGrid  (@grid, Message, @v0, @v1, @v2, @v3, r0, r1, &Message())
	XuiSendMessage ( grid, #SetGridName, 0, 0, 0, 0, 0, @"Message")
	XuiLabel       (@g, #Create, 8, 4, 360, 40, r0, grid)
	XuiSendMessage ( g, #SetCallback, grid, &Message(), -1, -1, $MessageText, grid)
	XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"MessageText")
	XuiSendMessage ( g, #SetAlign, $$AlignMiddleLeft, $$JustifyCenter, -1, -1, 0, 0)
	XuiSendMessage ( g, #SetBorder, $$BorderNone, $$BorderNone, $$BorderNone, 0, 0, 0)
	XuiSendMessage ( g, #SetTexture, $$TextureNone, 0, 0, 0, 0, 0)
	XuiSendMessage ( g, #SetFont, 320, 400, 0, 0, 0, @"MS Sans Serif")
	XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"text")

	XuiPushButton  (@g, #Create, 20, 48, 80, 28, r0, grid)
	XuiSendMessage ( g, #SetCallback, grid, &Message(), -1, -1, $ButtonYes, grid)
	XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"ButtonYes")
	XuiSendMessage ( g, #SetStyle, 2, 3, 0, 0, 0, 0)
	XuiSendMessage ( g, #SetBorder, $$BorderFlat1, $$BorderFlat1, $$BorderLower1, 0, 0, 0)
	XuiSendMessage ( g, #SetTexture, $$TextureNone, 0, 0, 0, 0, 0)
	XuiSendMessage ( g, #SetFont, 320, 400, 0, 0, 0, @"MS Sans Serif")
	XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"OK")

	XuiPushButton  (@g, #Create, 132, 48, 80, 28, r0, grid)
	XuiSendMessage ( g, #SetCallback, grid, &Message(), -1, -1, $ButtonNo, grid)
	XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"ButtonNo")
	XuiSendMessage ( g, #SetStyle, 2, 3, 0, 0, 0, 0)
	XuiSendMessage ( g, #SetBorder, $$BorderFlat1, $$BorderFlat1, $$BorderLower1, 0, 0, 0)
	XuiSendMessage ( g, #SetTexture, $$TextureNone, 0, 0, 0, 0, 0)
	XuiSendMessage ( g, #SetFont, 320, 400, 0, 0, 0, @"MS Sans Serif")
	XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"Cancel")

	GOSUB Resize
END SUB
'
'
' *****  CreateWindow  *****  v0123 = xywh : r0 = windowType : r1$ = display$
'
SUB CreateWindow
	IF (v0 == 0) THEN v0 = designX
	IF (v1 == 0) THEN v1 = designY
	IF (v2 <= 0) THEN v2 = designWidth
	IF (v3 <= 0) THEN v3 = designHeight
	XuiWindow (@window, #WindowCreate, v0, v1, v2, v3, r0, @r1$)
	v0 = 0 : v1 = 0 : r0 = window : ATTACH r1$ TO display$
	GOSUB Create
	r1 = 0 : ATTACH display$ TO r1$
	XuiWindow (window, #WindowRegister, grid, -1, v2, v3, @r0, @"Message")
END SUB
'
'
' *****  GetSmallestSize  *****  see "Anatomy of Grid Functions"
'
SUB GetSmallestSize
END SUB
'
'
' *****  Redrawn  *****  see "Anatomy of Grid Functions"
'
SUB Redrawn
	XuiCallback (grid, #Redrawn, v0, v1, v2, v3, r0, r1)
END SUB
'
'
' *****  Resize  *****  see "Anatomy of Grid Functions"
'
SUB Resize
END SUB
'
'
' *****  Selection  *****  see "Anatomy of Grid Functions"
'
SUB Selection
END SUB
'
'
' *****  Initialize  *****  see "Anatomy of Grid Functions"
'
SUB Initialize
	XuiGetDefaultMessageFuncArray (@func[])
	XgrMessageNameToNumber (@"LastMessage", @upperMessage)
'
	func[#Callback]           = &XuiCallback ()               ' disable to handle Callback messages internally
' func[#GetSmallestSize]    = 0                             ' enable to add internal GetSmallestSize routine
' func[#Resize]             = 0                             ' enable to add internal Resize routine
'
	DIM sub[upperMessage]
'	sub[#Callback]            = SUBADDRESS (Callback)         ' enable to handle Callback messages internally
	sub[#Create]              = SUBADDRESS (Create)           ' must be subroutine in this function
	sub[#CreateWindow]        = SUBADDRESS (CreateWindow)     ' must be subroutine in this function
'	sub[#GetSmallestSize]     = SUBADDRESS (GetSmallestSize)  ' enable to add internal GetSmallestSize routine
	sub[#Redrawn]             = SUBADDRESS (Redrawn)          ' generate #Redrawn callback if appropriate
'	sub[#Resize]              = SUBADDRESS (Resize)           ' enable to add internal Resize routine
	sub[#Selection]           = SUBADDRESS (Selection)        ' routes Selection callbacks to subroutine
'
'	IF sub[0] THEN PRINT "Message() : Initialize : error ::: (undefined message)"
'	IF func[0] THEN PRINT "Message() : Initialize : error ::: (undefined message)"
	XuiRegisterGridType (@Message, "Message", &Message(), @func[], @sub[])
'
	designX = 276
	designY = 327
	designWidth = 380
	designHeight = 84
'
	gridType = Message
	XuiSetGridTypeProperty (gridType, @"x",                designX)
	XuiSetGridTypeProperty (gridType, @"y",                designY)
	XuiSetGridTypeProperty (gridType, @"width",            designWidth)
	XuiSetGridTypeProperty (gridType, @"height",           designHeight)
	XuiSetGridTypeProperty (gridType, @"maxWidth",         designWidth)
	XuiSetGridTypeProperty (gridType, @"maxHeight",        designHeight)
	XuiSetGridTypeProperty (gridType, @"minWidth",         designWidth)
	XuiSetGridTypeProperty (gridType, @"minHeight",        designHeight)
	XuiSetGridTypeProperty (gridType, @"can",              $$Focus OR $$Respond OR $$Callback)
	XuiSetGridTypeProperty (gridType, @"focusKid",         $ButtonYes)
	IFZ message THEN RETURN
END SUB
END FUNCTION
'
'
' ############################
' #####  MessageCode ()  #####
' ############################
'
FUNCTION  MessageCode (grid, message, v0, v1, v2, v3, kid, r1)
'
	$Message            =   0
	$MessageText        =   1
	$ButtonYes          =   2
	$ButtonNo           =   3
	$UpperKid           =   3
'
	IF (message == #Callback) THEN message = r1
'
	SELECT CASE message
		CASE #Selection		: XuiSendMessage (#Message,#CloseWindow,0,0,0,0,0,0): GOSUB Selection
'		CASE #TextEvent		: GOSUB TextEvent   	' KeyDown in TextArea or TextLine
'		CASE #CloseWindow	: Quit ()						' close main window and no cleanup needed
		CASE #CloseWindow	: XuiSendMessage (grid, #HideWindow, 0, 0, 0, 0, 0, 0)
	END SELECT
	RETURN
'
'
' *****  Selection  *****
'
SUB Selection
	SELECT CASE kid
		CASE $ButtonYes    :	IF #PopUpAction=1 THEN SelectFileMenu (1,#ImageSet)
													IF #PopUpAction=2 THEN OpenMainDispWin ()
													IF #PopUpAction=3 THEN XuiSendMessage (#Output,#Redraw,0,0,0,0,0,0): XgrProcessMessages (-1): SpeedTest ()
													IF #PopUpAction=5 THEN XgrProcessMessages (-1): SaveAllTracksAsBMP (file$,mode)
													IF #PopUpAction=6 THEN XgrProcessMessages (-1): SaveAllToType (filen$,type,mode)
													IF #PopUpAction=7 THEN ReadNextFile ():	#exitProgram=0
													IF #PopUpAction=8 THEN ReadLastFile ():	#exitProgram=0
													IF #PopUpAction=9 THEN #CancelBlem=1: XuiSendMessage (#Message, #HideWindow, 0, 0, 0, 0, 0, 0)
		CASE $ButtonNo     :	IF ((#PopUpAction=1) OR (#PopUpAction=7) OR (#PopUpAction=8) OR (#PopUpAction=2) OR (#PopUpAction=9)) THEN Quit()
	END SELECT
END SUB



END FUNCTION
'
'
'	######################
'	#####  Tools ()  #####
'	######################
'
'
FUNCTION  Tools (grid, message, v0, v1, v2, v3, r0, (r1, r1$, r1[], r1$[]))
	STATIC  designX,  designY,  designWidth,  designHeight
	STATIC  SUBADDR  sub[]
	STATIC  upperMessage
	STATIC  Tools
'
	$Tools           =  0  ' kid   0 grid type = Tools
	$PushB1          =  1
	$PushB2          =  2
	$PushB5          =  3
	$PushB4          =  4
	$PushB3          =  5
	$PushB7          =  6
	$SwitchMode      =  7
	$PushB9          =  8
	$PushB10         =  9
	$PushB11         =  10
	$PushB12         =  11
	$PushB13         =  12
	$PushB14         =  13
	$PushB15         =  14
	$PushB16         =  15
	$PushB8          =  16
	$ExitB					 =	17
	$ReScale				 =	18
	$wCursor				 =  19
	$NextFile				 =  20
	$LastFile				 =  21
	$Move						 =  22
	$UpperKid        =  22  ' kid maximum
'
'
	IFZ sub[] THEN GOSUB Initialize
'	XuiReportMessage (grid, message, v0, v1, v2, v3, r0, r1)
	IF XuiProcessMessage (grid, message, @v0, @v1, @v2, @v3, @r0, @r1, Tools) THEN RETURN
	IF (message <= upperMessage) THEN GOSUB @sub[message]
	RETURN
'
'
' *****  Callback  *****  message = Callback : r1 = original message
'
SUB Callback
	message = r1
	callback = message
	IF (message <= upperMessage) THEN GOSUB @sub[message]
END SUB
'
'
' *****  Create  *****  v0123 = xywh : r0 = window : r1 = parent
'
SUB Create
	IF (v0 <= 0) THEN v0 = 0
	IF (v1 <= 0) THEN v1 = 0
	IF (v2 <= 0) THEN v2 = designWidth
	IF (v3 <= 0) THEN v3 = designHeight
	XuiCreateGrid  (@grid, Tools, @v0, @v1, @v2, @v3, r0, r1, &Tools())
	XuiSendMessage ( grid, #SetGridName, 0, 0, 0, 0, 0, @"Tools")
	SetKidFields (grid)
	#ToolsG=grid

	XuiPushButton  (@g, #Create, 76, 8, 16, 20, r0, grid)
	XuiSendMessage ( g, #SetCallback, grid, &Tools(), -1, -1, $PushB1, grid)
	XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"PushB1")
	XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"1")
	SetKidFields (g)
	XuiSendMessage (g, #SetCursor,#cursorHand, 0, 0, 0, 0, 0)

	XuiPushButton  (@g, #Create, 76, 32, 16, 20, r0, grid)
	XuiSendMessage ( g, #SetCallback, grid, &Tools(), -1, -1, $PushB2, grid)
	XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"PushB2")
	SetKidFields (g)
	XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"2")
	XuiSendMessage (g, #SetCursor,#cursorHand, 0, 0, 0, 0, 0)

	XuiPushButton  (@g, #Create, 572, 372, 28, 20, r0, grid)
	XuiSendMessage ( g, #SetCallback, grid, &Tools(), -1, -1, $PushB5, grid)
	XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"PushB5")
	SetKidFields (g)
	XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"A")
	XuiSendMessage (g, #SetCursor,#cursorHand, 0, 0, 0, 0, 0)

	XuiPressButton (@g, #Create, 116, 308, 16, 20, r0, grid)
	XuiSendMessage ( g, #SetCallback, grid, &Tools(), -1, -1, $PushB4, grid)
	XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"PushB4")
	SetKidFields (g)
	XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"+")
	XuiSendMessage (g, #SetCursor,#cursorHand, 0, 0, 0, 0, 0)

	XuiPressButton (@g, #Create, 76, 304, 16, 20, r0, grid)
	XuiSendMessage ( g, #SetCallback, grid, &Tools(), -1, -1, $PushB3, grid)
	XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"PushB3")
	SetKidFields (g)
	XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"-")
	XuiSendMessage (g, #SetCursor,#cursorHand, 0, 0, 0, 0, 0)
	XuiSendMessage (g, #SetCursor,#cursorHand, 0, 0, 0, 0, 0)

	XuiPushButton  (@g, #Create, 624, 376, 20, 20, r0, grid)
	XuiSendMessage ( g, #SetCallback, grid, &Tools(), -1, -1, $PushB7, grid)
	XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"PushB7")
	SetKidFields (g)
	XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"R")
	XuiSendMessage (g, #SetCursor,#cursorHand, 0, 0, 0, 0, 0)

	XuiPushButton  (@g, #Create, 600, 350, 20, 20, r0, grid)
	XuiSendMessage ( g, #SetCallback, grid, &Tools(), -1, -1, $SwitchMode, grid)
	XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"SwitchMode")
	SetKidFields (g)
	XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"I")
	XuiSendMessage (g, #SetCursor,#cursorHand, 0, 0, 0, 0, 0)

	XuiPushButton  (@g, #Create, 511, 311, 20, 20, r0, grid)
	XuiSendMessage ( g, #SetCallback, grid, &Tools(), -1, -1, $PushB9, grid)
	XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"PushB9")
	SetKidFields (g)
	XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"L")
	XuiSendMessage (g, #SetCursor,#cursorHand, 0, 0, 0, 0, 0)

	XuiPushButton  (@g, #Create, 511, 311, 20, 20, r0, grid)
	XuiSendMessage ( g, #SetCallback, grid, &Tools(), -1, -1, $PushB10, grid)
	XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"PushB10")
	SetKidFields (g)
	XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"C")
	XuiSendMessage (g, #SetCursor,#cursorHand, 0, 0, 0, 0, 0)

	XuiPushButton  (@g, #Create, 219, 147, 20, 20, r0, grid)
	XuiSendMessage ( g, #SetCallback, grid, &Tools(), -1, -1, $PushB11, grid)
	XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"PushB11")
	SetKidFields (g)
	XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"H")
	XuiSendMessage (g, #SetCursor,#cursorHand, 0, 0, 0, 0, 0)

	XuiPushButton  (@g, #Create, 219, 147, 20, 20, r0, grid)
	XuiSendMessage ( g, #SetCallback, grid, &Tools(), -1, -1, $PushB12, grid)
	XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"PushB12")
	SetKidFields (g)
	XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"V")
	XuiSendMessage (g, #SetCursor,#cursorHand, 0, 0, 0, 0, 0)

	XuiPushButton  (@g, #Create, 219, 147, 20, 20, r0, grid)
	XuiSendMessage ( g, #SetCallback, grid, &Tools(), -1, -1, $PushB13, grid)
	XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"PushB13")
	SetKidFields (g)
	XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"S")
	XuiSendMessage (g, #SetCursor,#cursorHand, 0, 0, 0, 0, 0)

	XuiPushButton  (@g, #Create, 219, 147, 20, 20, r0, grid)
	XuiSendMessage ( g, #SetCallback, grid, &Tools(), -1, -1, $PushB14, grid)
	XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"PushB14")
	SetKidFields (g)
	XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"F")
	XuiSendMessage (g, #SetCursor,#cursorHand, 0, 0, 0, 0, 0)

	XuiPushButton  (@g, #Create, 219, 147, 20, 20, r0, grid)
	XuiSendMessage ( g, #SetCallback, grid, &Tools(), -1, -1, $PushB15, grid)
	XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"PushB15")
	SetKidFields (g)
	XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"P")
	XuiSendMessage (g, #SetCursor,#cursorHand, 0, 0, 0, 0, 0)

	XuiPushButton  (@g, #Create, 219, 147, 20, 20, r0, grid)
	XuiSendMessage ( g, #SetCallback, grid, &Tools(), -1, -1, $PushB16, grid)
	XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"PushB16")
	SetKidFields (g)
	XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"FI")
	XuiSendMessage (g, #SetCursor,#cursorHand, 0, 0, 0, 0, 0)

	XuiPushButton  (@g, #Create, 219, 147, 20, 20, r0, grid)
	XuiSendMessage ( g, #SetCallback, grid, &Tools(), -1, -1, $PushB8, grid)
	XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"PushB8")
	SetKidFields (g)
	XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"M")
	XuiSendMessage (g, #SetCursor,#cursorHand, 0, 0, 0, 0, 0)

	XuiPushButton  (@g, #Create, 219, 147, 20, 20, r0, grid)
	XuiSendMessage ( g, #SetCallback, grid, &Tools(), -1, -1, $ExitB, grid)
	XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"ExitB")
	SetKidFields (g)
	XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"Q")
	XuiSendMessage (g, #SetCursor,#cursorHand, 0, 0, 0, 0, 0)

	XuiPushButton  (@g, #Create, 219, 147, 20, 20, r0, grid)
	XuiSendMessage ( g, #SetCallback, grid, &Tools(), -1, -1, $ReScale, grid)
	XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"ReScale")
	SetKidFields (g)
	XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"Rs")
	XuiSendMessage (g, #SetCursor,#cursorHand, 0, 0, 0, 0, 0)

	XuiPushButton  (@g, #Create, 219, 147, 20, 20, r0, grid)
	XuiSendMessage ( g, #SetCallback, grid, &Tools(), -1, -1, $wCursor, grid)
	XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"wCursor")
	SetKidFields (g)
	XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"WC")
	XuiSendMessage (g, #SetCursor,#cursorHand, 0, 0, 0, 0, 0)

	XuiPushButton  (@g, #Create, 219, 147, 20, 20, r0, grid)
	XuiSendMessage ( g, #SetCallback, grid, &Tools(), -1, -1, $NextFile, grid)
	XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"NextFile")
	SetKidFields (g)
	XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"nF")
	XuiSendMessage (g, #SetCursor,#cursorHand, 0, 0, 0, 0, 0)

	XuiPushButton  (@g, #Create, 219, 147, 20, 20, r0, grid)
	XuiSendMessage ( g, #SetCallback, grid, &Tools(), -1, -1, $LastFile, grid)
	XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"LastFile")
	SetKidFields (g)
	XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"lF")
	XuiSendMessage (g, #SetCursor,#cursorHand, 0, 0, 0, 0, 0)

	XuiArea 				(@g, #Create, 660, 376, 20, 20, r0, grid)
	XuiSendMessage ( g, #SetCallback, grid, &Tools(), -1, -1, $Move, grid)
	XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"Move")
	XuiSendMessage (g,  #SetCursor, #cursorArrowsAll, 0, 0, 0, 0, 0)
	SetKidFields (g)

	#ToolsUpperKid=$UpperKid
	GOSUB Resize
END SUB
'
'
' *****  CreateWindow  *****  v0123 = xywh : r0 = windowType : r1$ = display$
'
SUB CreateWindow
	IF (v0 == 0) THEN v0 = designX
	IF (v1 == 0) THEN v1 = designY
	IF (v2 <= 0) THEN v2 = designWidth
	IF (v3 <= 0) THEN v3 = designHeight
	XuiWindow (@window, #WindowCreate, v0, v1, v2, v3, r0, @r1$)
	v0 = 0 : v1 = 0 : r0 = window : ATTACH r1$ TO display$
	GOSUB Create
	r1 = 0 : ATTACH display$ TO r1$
	XuiWindow (window, #WindowRegister, grid, -1, v2, v3, @r0, @"Tools")
END SUB
'
'
' *****  GetSmallestSize  *****  see "Anatomy of Grid Functions"
'
SUB GetSmallestSize
END SUB
'
'
' *****  Redrawn  *****  see "Anatomy of Grid Functions"
'
SUB Redrawn
'	XuiCallback (grid, #Redrawn, v0, v1, v2, v3, r0, r1)
END SUB
'
'
' *****  Resize  *****  see "Anatomy of Grid Functions"
'
SUB Resize

'	XuiPositionGrid (grid, @v0, @v1, @v2, @v3)

	#toolw=v2
	#toolh=v3

	space=26
	vh=1
	vw=5
	XuiSendMessage (grid, #Resize, vw, vh, 20, 20, $PushB2, 0)
	vw=vw+space
	XuiSendMessage (grid, #Resize, vw, vh, 20, 20, $PushB1, 0)
	vw=vw+space
	XuiSendMessage (grid, #Resize, vw, vh, 20, 20, $PushB12, 0)
	vw=vw+space
	XuiSendMessage (grid, #Resize, vw, vh, 20, 20, $PushB11, 0)
	vw=vw+space
	XuiSendMessage (grid, #Resize, vw, vh, 20, 20, $PushB15, 0)
	vw=vw+space
	XuiSendMessage (grid, #Resize, vw, vh, 20, 20, $LastFile, 0)
	vw=vw+space
	XuiSendMessage (grid, #Resize, vw, vh, 20, 20, $PushB14, 0)
	vw=vw+space
	XuiSendMessage (grid, #Resize, vw, vh, 20, 20, $NextFile, 0)
	vw=vw+space
	XuiSendMessage (grid, #Resize, vw, vh, 20, 20, $wCursor, 0)
	vw=vw+space
	XuiSendMessage (grid, #Resize, vw, vh, 20, 20, $PushB10, 0)
	vw=vw+space
	XuiSendMessage (grid, #Resize, vw, vh, 20, 20, $PushB9, 0)
	vw=vw+space
	XuiSendMessage (grid, #Resize, vw, vh, 20, 20, $PushB13, 0)
	vw=vw+space
	XuiSendMessage (grid, #Resize, vw, vh, 20, 20, $PushB7, 0)
	vw=vw+space
	XuiSendMessage (grid, #Resize, vw, vh, 20, 20, $PushB5, 0)
	vw=vw+space
	XuiSendMessage (grid, #Resize, vw, vh, 20, 20, $ReScale, 0)
	vw=vw+space
	XuiSendMessage (grid, #Resize, vw, vh, 20, 20, $PushB16, 0)
	vw=vw+space
	XuiSendMessage (grid, #Resize, vw, vh, 20, 20, $SwitchMode, 0)
	vw=vw+20
	XuiSendMessage (grid, #Resize, vw, vh, 20, 20, $PushB8, 0)
	vw=vw+20
	XuiSendMessage (grid, #Resize, vw, vh, 20, 20, $ExitB, 0)
	vw=vw+20
	XuiSendMessage (grid, #Resize, vw, vh, 20, 20, $PushB3, 0)
	vw=vw+20
	XuiSendMessage (grid, #Resize, vw, vh, 20, 20, $PushB4, 0)
	vw=vw+20
	XuiSendMessage (grid, #Resize, vw, vh, 23,40,  $Move, 0)

	XuiPositionGrid (#ToolsG, v0, v1, v2, v3)
	DrawToolsBorder ()


END SUB
'
'
' *****  Selection  *****  see "Anatomy of Grid Functions"
'
SUB Selection
END SUB
'
'
' *****  Initialize  *****  see "Anatomy of Grid Functions"
'
SUB Initialize
	XuiGetDefaultMessageFuncArray (@func[])
	XgrMessageNameToNumber (@"LastMessage", @upperMessage)
'
  func[#Resize]             = &XuiResize()
	func[#Callback]           = &XuiCallback ()
' func[#GetSmallestSize]    = 0
'	func[#Resize]             = 0
'
	DIM sub[upperMessage]
'	sub[#Callback]            = SUBADDRESS (Callback)         ' enable to handle Callback messages internally
	sub[#Create]              = SUBADDRESS (Create)           ' must be subroutine in this function
	sub[#CreateWindow]        = SUBADDRESS (CreateWindow)     ' must be subroutine in this function
'	sub[#GetSmallestSize]     = SUBADDRESS (GetSmallestSize)  ' enable to add internal GetSmallestSize routine
	sub[#Redrawn]             = SUBADDRESS (Redrawn)          ' generate #Redrawn callback if appropriate
	sub[#Resize]              = SUBADDRESS (Resize)           ' enable to add internal Resize routine
	sub[#Selection]           = SUBADDRESS (Selection)        ' routes Selection callbacks to subroutine
'
'	IF sub[0] THEN PRINT "Tools() : Initialize : error ::: (undefined message)"
'	IF func[0] THEN PRINT "Tools() : Initialize : error ::: (undefined message)"
	XuiRegisterGridType (@Tools, "Tools", &Tools(), @func[], @sub[])
'
' Don't remove the following 4 lines, or WindowFromFunction/WindowToFunction will not work
'
	designX = 162
	designY = 608
	designWidth = 550
	designHeight = 22
'
	gridType = Tools
	XuiSetGridTypeProperty (gridType, @"x",                designX)
	XuiSetGridTypeProperty (gridType, @"y",                designY)
	XuiSetGridTypeProperty (gridType, @"width",            designWidth)
	XuiSetGridTypeProperty (gridType, @"height",           designHeight)
'	XuiSetGridTypeProperty (gridType, @"maxWidth",         designWidth)
'	XuiSetGridTypeProperty (gridType, @"maxHeight",        designHeight)
'	XuiSetGridTypeProperty (gridType, @"minWidth",         designWidth)
'	XuiSetGridTypeProperty (gridType, @"minHeight",        designHeight)
	XuiSetGridTypeProperty (gridType, @"can",              $$Callback)
	IFZ message THEN RETURN
END SUB
END FUNCTION
'
'
' ##########################
' #####  ToolsCode ()  #####
' ##########################
'
FUNCTION  ToolsCode (grid, message, v0, v1, v2, v3, kid, r1)
	SHARED SINGLE ww,hh,xx,yy
	SHARED Image ImageFormat[]
	STATIC xPin, yPin,x,y,w,h,wt,ht, xwidth, yheight

	IFZ v3  THEN RETURN
	IFZ kid THEN RETURN

'	XuiReportMessage (grid, message, v0, v1, v2, v3, kid, r1)
	IF (message == #Callback) THEN message = r1 ELSE RETURN

	IF kid=22 THEN
			SELECT CASE message
					CASE #Redrawn			:IF #Tdock<>1 THEN DrawToolsBorder (): RETURN
					CASE #MouseEnter	:IF #Tdock<>1 THEN DrawToolsBorder (): RETURN
					CASE #MouseExit		:IF #Tdock<>1 THEN DrawToolsBorder (): RETURN
					CASE #MouseDrag		:IF #PanDisplay=5 THEN GOSUB MouseDrag: RETURN
					CASE #MouseUp			:GOSUB	MouseUp
					CASE #MouseDown   :XgrGetMouseInfo (@window, @mgrid, @xPin, @yPin, @state, @time )
														XgrGetWindowPositionAndSize (#OutputWindow, @x, @y, @w, @h)
														XgrGetWindowPositionAndSize (#ToolsWindow, @xpos, @ypos, @xwidth, @yheight)
														wt=550: ht=22: xwidth=wt: yheight=ht
														IF mgrid = #toolarea THEN	#PanDisplay=5: DrawToolsBorder ()
					CASE ELSE					:EXIT FUNCTION
			END SELECT
			EXIT FUNCTION

	ELSE

		SELECT CASE kid
			CASE 1		 : kid=1
			CASE 3		 : kid=4
			CASE 2		 : kid=2
			CASE 4		 : kid=5
			CASE 5		 : kid=6
			CASE 6		 : kid=8
			CASE 7		 : kid=10
			CASE 8		 : kid=12
			CASE 9		 : kid=13
			CASE 10		 : kid=17
			CASE 11		 : kid=18
			CASE 12		 : kid=19
			CASE 13		 : kid=20
			CASE 14		 : kid=21
			CASE 15		 : kid=22
			CASE 16		 : kid=11
			CASE 17		 : Quit ()		' quick exit
      CASE 18		 : kid=0: IF #AutoScale THEN #AutoScale=0 ELSE kid=4: #AutoScale=1: AutoScaleAll (#ImageSet)
			CASE 19		 : kid=0: INC #sCursorType
													IF #sCursorType=1	THEN XuiSendMessage (#image, #SetCursor,#cursorCrosshair, 0, 0, 0, 0, 0)
													IF #sCursorType=2	THEN XuiSendMessage (#image, #SetCursor,#cursorNone, 0, 0, 0, 0, 0)
													IF #sCursorType=3	THEN XuiSendMessage (#image, #SetCursor,#cursorNone, 0, 0, 0, 0, 0)
													IF #sCursorType=4 THEN #sCursorType=0: XuiSendMessage (#image, #SetCursor,#cursorCrosshair, 0, 0, 0, 0, 0)
			CASE 20		 : kid=0: ReadNextFile ()
			CASE 21		 : kid=0: ReadLastFile ()
			CASE 22		 : kid=0: EXIT FUNCTION
		END SELECT

		IFZ kid THEN RETURN

		OutputCode (#Output, message, v0, v1, v2, v3, kid, r1)

	END IF

	RETURN


'##################
SUB	MouseUp
'##################

	Prints ("             ",1)

	#PanDisplay=0
	IF #MinSize=0 THEN DrawInfo(): DrawOutputBorders ()
	XuiSendMessage (#Tools,#Redraw,0,0,0,0,0,0)

	XgrGetWindowPositionAndSize (#ToolsWindow, @xt, @yt, @wt, @ht )
	XgrGetWindowPositionAndSize (#OutputWindow, @x, @y, @w, @h)

	IF ( (xt>x) AND ((xt+wt) < (x+w)) AND (yt>y) AND ((yt+ht) < (y+h)) ) THEN
			#Tdock=1
	ELSE
			DrawToolsBorder ()
	END IF

	IF #Tdock>0 THEN #tx=xt-x: #ty=yt-y

END SUB


'##################
SUB	MouseDrag
'##################

	XgrGetMouseInfo ( @window, @mgrid, @xWin, @yWin, @state, @time )
	IFZ state THEN #PanDisplay=0: EXIT FUNCTION
	XgrGetWindowPositionAndSize (#ToolsWindow, @xaDisp, @yaDisp, @wt, @ht )

	Xdif = xaDisp + (xWin - xPin)
	Ydif = yaDisp + (yWin - yPin)

	IF ( ((Xdif+6)>x) AND ((Xdif+xwidth) < (x+w)) AND (Ydif>(y+h+2)) AND ((Ydif+yheight) < (y+h+yheight+11)) ) THEN
				wt=w: X=x: #Tdock=2
	ELSE
				IF (((Xdif+6)>x) AND ((Xdif+xwidth) < (x+w)) AND ((Ydif+yheight) < (y-3)) AND ((Ydif) > (y-yheight-11)) ) THEN
							wt=w: X=x: #Tdock=3
				ELSE
							wt=550: X=Xdif: #Tdock=0
				END IF
	END IF

	text$="x:"+STRING$(X)+" y:"+STRING$(Ydif)
	Prints (text$,1)

	XgrSetWindowPositionAndSize (window, X, Ydif, wt, -1)

'	OutputCode (#Output, #Redrawn, v0, v1, v2, v3, kid, r1)
'	DrawOutputBorders ()

	EXIT FUNCTION

END SUB


END FUNCTION
'
'
'	#########################
'	#####  FileList ()  #####
'	#########################
'
'
FUNCTION  FileList (grid, message, v0, v1, v2, v3, r0, (r1, r1$, r1[], r1$[]))
	STATIC  designX,  designY,  designWidth,  designHeight
	STATIC  SUBADDR  sub[]
	STATIC  upperMessage
	STATIC  FileList
'
	$FileList  =   0  ' kid   0 grid type = FileList
	$fList     =   1  ' kid   1 grid type = XuiList
	$UpperKid  =   1  ' kid maximum
'
'
	IFZ sub[] THEN GOSUB Initialize
'	XuiReportMessage (grid, message, v0, v1, v2, v3, r0, r1)
	IF XuiProcessMessage (grid, message, @v0, @v1, @v2, @v3, @r0, @r1, FileList) THEN RETURN
	IF (message <= upperMessage) THEN GOSUB @sub[message]
	RETURN
'
'
' *****  Callback  *****  message = Callback : r1 = original message
'
SUB Callback
	message = r1
	callback = message
	IF (message <= upperMessage) THEN GOSUB @sub[message]
END SUB
'
'
' *****  Create  *****  v0123 = xywh : r0 = window : r1 = parent
'
SUB Create
	IF (v0 <= 0) THEN v0 = 0
	IF (v1 <= 0) THEN v1 = 0
	IF (v2 <= 0) THEN v2 = designWidth
	IF (v3 <= 0) THEN v3 = designHeight
	XuiCreateGrid  (@grid, FileList, @v0, @v1, @v2, @v3, r0, r1, &FileList())
	XuiSendMessage ( grid, #SetGridName, 0, 0, 0, 0, 0, @"FileList")
	XuiList        (@g, #Create, 0, 0, 400, 212, r0, grid)
	XuiSendMessage ( g, #SetCallback, grid, &FileList(), -1, -1, $fList, grid)
	XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"fList")
	XuiSendMessage ( g, #SetStyle, 2, 0, 0, 0, 0, 0)
'	XuiSendMessage ( g, #SetColorExtra, $$Grey, $$White, $$Black, $$White, 0, 0)
	XuiSendMessage ( g, #SetBorder, $$BorderNone, $$BorderNone, $$BorderNone, 0, 0, 0)
	XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 1, @"List")
	XuiSendMessage ( g, #SetColorExtra, $$Grey, $$White, $$Black, 0, 0, 0)
	XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 2, @"ScrollH")
	XuiSendMessage ( g, #SetStyle, 2, 0, 0, 0, 2, 0)
'	XuiSendMessage ( g, #SetColorExtra, $$Grey, $$White, $$Black, $$White, 2, 0)
	XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 3, @"ScrollV")
	XuiSendMessage ( g, #SetStyle, 2, 0, 0, 0, 3, 0)
'	XuiSendMessage ( g, #SetColorExtra, $$Grey, $$White, $$Black, $$White, 3, 0)
	GOSUB Resize
END SUB
'
'
' *****  CreateWindow  *****  v0123 = xywh : r0 = windowType : r1$ = display$
'
SUB CreateWindow
	IF (v0 == 0) THEN v0 = designX
	IF (v1 == 0) THEN v1 = designY
	IF (v2 <= 0) THEN v2 = designWidth
	IF (v3 <= 0) THEN v3 = designHeight
	XuiWindow (@window, #WindowCreate, v0, v1, v2, v3, r0, @r1$)
	v0 = 0 : v1 = 0 : r0 = window : ATTACH r1$ TO display$
	GOSUB Create
	r1 = 0 : ATTACH display$ TO r1$
	XuiWindow (window, #WindowRegister, grid, -1, v2, v3, @r0, @"FileList")
END SUB
'
'
' *****  GetSmallestSize  *****  see "Anatomy of Grid Functions"
'
SUB GetSmallestSize
END SUB
'
'
' *****  Redrawn  *****  see "Anatomy of Grid Functions"
'
SUB Redrawn
	XuiCallback (grid, #Redrawn, v0, v1, v2, v3, r0, r1)
END SUB
'
'
' *****  Resize  *****  see "Anatomy of Grid Functions"
'
SUB Resize

	XuiPositionGrid (grid, @v0, @v1, v2, v3)
	XuiSendMessage (grid, #Resize, 0, 0, v2, v3, 1, 0)
	XgrSetGridPositionAndSize (#FileList, 0, 0, v2, v3)

END SUB
'
'
' *****  Selection  *****  see "Anatomy of Grid Functions"
'
SUB Selection
END SUB
'
'
' *****  Initialize  *****  see "Anatomy of Grid Functions"
'
SUB Initialize
	XuiGetDefaultMessageFuncArray (@func[])
	XgrMessageNameToNumber (@"LastMessage", @upperMessage)
'
	func[#Callback]           = &XuiCallback ()               ' disable to handle Callback messages internally
' func[#GetSmallestSize]    = 0                             ' enable to add internal GetSmallestSize routine
	func[#Resize]             = 0                             ' enable to add internal Resize routine
'
	DIM sub[upperMessage]
'	sub[#Callback]            = SUBADDRESS (Callback)         ' enable to handle Callback messages internally
	sub[#Create]              = SUBADDRESS (Create)           ' must be subroutine in this function
	sub[#CreateWindow]        = SUBADDRESS (CreateWindow)     ' must be subroutine in this function
'	sub[#GetSmallestSize]     = SUBADDRESS (GetSmallestSize)  ' enable to add internal GetSmallestSize routine
	sub[#Redrawn]             = SUBADDRESS (Redrawn)          ' generate #Redrawn callback if appropriate
	sub[#Resize]              = SUBADDRESS (Resize)           ' enable to add internal Resize routine
	sub[#Selection]           = SUBADDRESS (Selection)        ' routes Selection callbacks to subroutine
'
'	IF sub[0] THEN PRINT "FileList() : Initialize : error ::: (undefined message)"
'	IF func[0] THEN PRINT "FileList() : Initialize : error ::: (undefined message)"
	XuiRegisterGridType (@FileList, "FileList", &FileList(), @func[], @sub[])
'
' Don't remove the following 4 lines, or WindowFromFunction/WindowToFunction will not work
'
	designX = 296
	designY = 293
	designWidth = 400
	designHeight = 210
'
	gridType = FileList
	XuiSetGridTypeProperty (gridType, @"x",                designX)
	XuiSetGridTypeProperty (gridType, @"y",                designY)
	XuiSetGridTypeProperty (gridType, @"width",            designWidth)
	XuiSetGridTypeProperty (gridType, @"height",           designHeight)
'	XuiSetGridTypeProperty (gridType, @"maxWidth",         designWidth)
'	XuiSetGridTypeProperty (gridType, @"maxHeight",        designHeight)
'	XuiSetGridTypeProperty (gridType, @"minWidth",         designWidth)
'	XuiSetGridTypeProperty (gridType, @"minHeight",        designHeight)
	XuiSetGridTypeProperty (gridType, @"can",              $$Focus OR $$Respond OR $$Callback)
	XuiSetGridTypeProperty (gridType, @"focusKid",         $fList)
	IFZ message THEN RETURN
END SUB
END FUNCTION
'
'
' #############################
' #####  FileListCode ()  #####
' #############################
'
'
FUNCTION  FileListCode (grid, message, v0, v1, v2, v3, kid, r1)
'
	$FileList  =   0
	$fList     =   1
	$UpperKid  =   1
'
'	XuiReportMessage (grid, message, v0, v1, v2, v3, kid, r1)
	IF (message == #Callback) THEN message = r1
'
	SELECT CASE message
		CASE #Selection		:	IF kid=$fList THEN
														IF (#FileNumber<>v0) THEN
		 														#FileNumber=v0
																file$=#ListOfDataFiles$[#FileNumber]
																LoadFile (file$,#ImageSet)
																XgrSetSelectedWindow (#FileListWindow)
														END IF
												END IF
		CASE #CloseWindow : XuiSendMessage (grid, #HideWindow, 0, 0, 0, 0, 0, 0)
	END SELECT
	RETURN

END FUNCTION
'
'
'	###########################
'	#####  IconWindow ()  #####
'	###########################
'
FUNCTION  IconWindow (grid, message, v0, v1, v2, v3, r0, (r1, r1$, r1[], r1$[]))
	STATIC  designX,  designY,  designWidth,  designHeight
	STATIC  SUBADDR  sub[]
	STATIC  upperMessage
	STATIC  IconWindow
'
	$IconWindow  =   0  ' kid   0 grid type = IconWindow
	$Button      =   1  ' kid   1 grid type = XuiPressButton
	$UpperKid    =   1  ' kid maximum
'
'
	IFZ sub[] THEN GOSUB Initialize
'	XuiReportMessage (grid, message, v0, v1, v2, v3, r0, r1)
	IF XuiProcessMessage (grid, message, @v0, @v1, @v2, @v3, @r0, @r1, IconWindow) THEN RETURN
	IF (message <= upperMessage) THEN GOSUB @sub[message]
	RETURN
'
'
' *****  Callback  *****  message = Callback : r1 = original message
'
SUB Callback
	message = r1
	callback = message
	IF (message <= upperMessage) THEN GOSUB @sub[message]
END SUB
'
'
' *****  Create  *****  v0123 = xywh : r0 = window : r1 = parent
'
SUB Create
	IF (v0 <= 0) THEN v0 = 0
	IF (v1 <= 0) THEN v1 = 0
	IF (v2 <= 0) THEN v2 = designWidth
	IF (v3 <= 0) THEN v3 = designHeight
	XuiCreateGrid  (@grid, IconWindow, @v0, @v1, @v2, @v3, r0, r1, &IconWindow())
	XuiSendMessage ( grid, #SetGridName, 0, 0, 0, 0, 0, @"IconWindow")
	XuiSendMessage ( grid, #SetStyle, 4, 3, 0, 0, 0, 0)
	XuiSendMessage ( grid, #SetAlign, $$AlignLowerCenter, 0, -1, -1, 0, 0)
	XuiSendMessage ( grid, #SetBorder, $$BorderLoLine1, $$BorderLoLine1, $$BorderLower2, 0, 0, 0)
	XuiPressButton (@g, #Create, 0, 0, 104, 52, r0, grid)
	XuiSendMessage ( g, #SetCallback, grid, &IconWindow(), -1, -1, $Button, grid)
	XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"Button")
	XuiSendMessage ( g, #SetColorExtra, $$Grey, $$Black, $$Black, $$White, 0, 0)
	XuiSendMessage ( g, #SetBorder, $$BorderNone, $$BorderNone, $$BorderLower1, 0, 0, 0)
	XuiSendMessage ( g, #SetTexture, $$TextureNone, 0, 0, 0, 0, 0)
	#IconWindowG=g
	GOSUB Resize
END SUB
'
'
' *****  CreateWindow  *****  v0123 = xywh : r0 = windowType : r1$ = display$
'
SUB CreateWindow
	IF (v0 == 0) THEN v0 = designX
	IF (v1 == 0) THEN v1 = designY
	IF (v2 <= 0) THEN v2 = designWidth
	IF (v3 <= 0) THEN v3 = designHeight
	XuiWindow (@window, #WindowCreate, v0, v1, v2, v3, r0, @r1$)
	v0 = 0 : v1 = 0 : r0 = window : ATTACH r1$ TO display$
	GOSUB Create
	r1 = 0 : ATTACH display$ TO r1$
	XuiWindow (window, #WindowRegister, grid, -1, v2, v3, @r0, @"IconWindow")
END SUB
'
'
' *****  GetSmallestSize  *****  see "Anatomy of Grid Functions"
'
SUB GetSmallestSize
END SUB
'
'
' *****  Redrawn  *****  see "Anatomy of Grid Functions"
'
SUB Redrawn
'	XuiCallback (grid, #Redrawn, v0, v1, v2, v3, r0, r1)
END SUB
'
'
' *****  Resize  *****  see "Anatomy of Grid Functions"
'
SUB Resize

	XuiSendMessage (grid, #Resize, 1, 1, v2-2, v3-2, 1, 0)

	IF #iconized=5 THEN
				XuiSendMessage (grid, #SetTextString, 0, 0, 0, 0, 1, @"II")
		'		XuiSendMessage (grid, #SetHintString, 0, 0, 0, 0, 1, text2$)
	ELSE
				text$=#iiversion$+" "+#date$+" by Michael McElligott"
				text2$=#fil$+" - "+#iiversion$+" "+#date$
				XuiSendMessage (grid, #SetTextString, 0, 0, 0, 0, 1, text2$)
				XuiSendMessage (grid, #SetHintString, 0, 0, 0, 0, 1, text$)
	END IF


END SUB
'
'
' *****  Selection  *****  see "Anatomy of Grid Functions"
'
SUB Selection
END SUB
'
'
' *****  Initialize  *****  see "Anatomy of Grid Functions"
'
SUB Initialize
	XuiGetDefaultMessageFuncArray (@func[])
	XgrMessageNameToNumber (@"LastMessage", @upperMessage)
'
' func[#Resize]             = &XuiResizeNot()
	func[#Callback]           = &XuiCallback ()               ' disable to handle Callback messages internally
' func[#GetSmallestSize]    = 0                             ' enable to add internal GetSmallestSize routine
' func[#Resize]             = 0                             ' enable to add internal Resize routine
'
	DIM sub[upperMessage]
'	sub[#Callback]            = SUBADDRESS (Callback)         ' enable to handle Callback messages internally
	sub[#Create]              = SUBADDRESS (Create)           ' must be subroutine in this function
	sub[#CreateWindow]        = SUBADDRESS (CreateWindow)     ' must be subroutine in this function
'	sub[#GetSmallestSize]     = SUBADDRESS (GetSmallestSize)  ' enable to add internal GetSmallestSize routine
'	sub[#Redrawn]             = SUBADDRESS (Redrawn)          ' generate #Redrawn callback if appropriate
	sub[#Resize]              = SUBADDRESS (Resize)           ' enable to add internal Resize routine
	sub[#Selection]           = SUBADDRESS (Selection)        ' routes Selection callbacks to subroutine
'
'	IF sub[0] THEN PRINT "IconWindow() : Initialize : error ::: (undefined message)"
'	IF func[0] THEN PRINT "IconWindow() : Initialize : error ::: (undefined message)"
	XuiRegisterGridType (@IconWindow, "IconWindow", &IconWindow(), @func[], @sub[])
'
' Don't remove the following 4 lines, or WindowFromFunction/WindowToFunction will not work
'
	designX = 389
	designY = 398
	designWidth = 104
	designHeight = 52
'
	gridType = IconWindow
	XuiSetGridTypeProperty (gridType, @"x",                designX)
	XuiSetGridTypeProperty (gridType, @"y",                designY)
	XuiSetGridTypeProperty (gridType, @"width",            designWidth)
	XuiSetGridTypeProperty (gridType, @"height",           designHeight)
'	XuiSetGridTypeProperty (gridType, @"maxWidth",         designWidth)
'	XuiSetGridTypeProperty (gridType, @"maxHeight",        designHeight)
'	XuiSetGridTypeProperty (gridType, @"minWidth",         designWidth)
'	XuiSetGridTypeProperty (gridType, @"minHeight",        designHeight)
	XuiSetGridTypeProperty (gridType, @"can",              $$Focus OR $$Respond OR $$Callback)
	XuiSetGridTypeProperty (gridType, @"focusKid",         $Button)
	IFZ message THEN RETURN
END SUB
END FUNCTION
'
'
' ###############################
' #####  IconWindowCode ()  #####
' ###############################
'
'
FUNCTION  IconWindowCode (grid, message, v0, v1, v2, v3, kid, r1)
	SHARED SINGLE ww,hh,xx,yy
	STATIC xPin, yPin,xwidth, yheight
'
	$IconWindow  =   0  ' kid   0 grid type = IconWindow
	$Button      =   1  ' kid   1 grid type = XuiPressButton
	$UpperKid    =   1  ' kid maximum
'
'	XuiReportMessage (grid, message, v0, v1, v2, v3, kid, r1)
	IF (message == #Callback) THEN message = r1
'	XgrMessageNumberToName  (message,@message$): PRINT grid, message$, v0, v1, v2, v3, kid, r1
'
	SELECT CASE message
		CASE #Redrawn			:GOSUB Redraw
		CASE #Selection		: GOSUB Selection
		CASE #WindowMouseUp			:GOSUB MouseUp
		CASE #WindowMouseDrag		:GOSUB MouseDrag
'		CASE #WindowMouseDown   :GOSUB MouseDown

	END SELECT
	RETURN
'
'
' *****  Selection  *****
'
SUB Selection
	SELECT CASE kid
		CASE $IconWindow  :GOSUB MouseDown
		CASE $Button      :GOSUB MouseDown
	END SELECT
END SUB

'##################
SUB Redraw
'##################

	IF #iconized=-1 THEN RedrawIcon (32) ELSE RedrawIcon (31)

END SUB


'##################
SUB	MouseDown
'##################

	#PanDisplay=0
	#drag=0

	XgrGetMouseInfo (@window, @mgrid, @xPin, @yPin, @state, @time )
	XgrGetWindowPositionAndSize (#IconWindowWindow, @xpos, @ypos, @xwidth, @yheight)


END SUB

'##################
SUB	MouseUp
'##################

	IF #drag=0 THEN
				XgrGetWindowPositionAndSize (#IconWindowWindow, @xpos, @ypos,w,h)
				XgrSetWindowPositionAndSize (#OutputWindow, xpos, ypos, -1, -1)
				MaxScreen()
	END IF

	#PanDisplay=0
	#drag=0

END SUB


'##################
SUB	MouseDrag
'##################

'	#PanDisplay=7
	#drag=1

	XgrGetMouseInfo ( @window, @mgrid, @xWin, @yWin, @state, @time )
	IFZ state THEN #PanDisplay=0: EXIT FUNCTION
	XgrGetWindowPositionAndSize (#IconWindowWindow, @xaDisp, @yaDisp, @w, @ht )

	Xdif = xaDisp + (xWin - xPin)
	Ydif = yaDisp + (yWin - yPin)

	XgrSetWindowPositionAndSize (window, Xdif, Ydif, -1, -1)

	'set toolbar position also.

END SUB


END FUNCTION
'
'
' ######################
' #####  About ()  #####
' ######################
'
FUNCTION  About (grid, message, v0, v1, v2, v3, r0, (r1, r1$, r1[], r1$[]))
	STATIC  designX,  designY,  designWidth,  designHeight
	STATIC  SUBADDR  sub[]
	STATIC  upperMessage
	STATIC  About
'
	$About        =   0  ' kid   0 grid type = About
	$AboutLabel   =   1  ' kid   1 grid type = XuiLabel
	$ServerLabel  =   2  ' kid   2 grid type = XuiLabel
	$UpperKid     =   2  ' kid maximum
'
'
	IFZ sub[] THEN GOSUB Initialize
'	XuiReportMessage (grid, message, v0, v1, v2, v3, r0, r1)
	IF XuiProcessMessage (grid, message, @v0, @v1, @v2, @v3, @r0, @r1, About) THEN RETURN
	IF (message <= upperMessage) THEN GOSUB @sub[message]
	RETURN
'
'
' *****  Callback  *****  message = Callback : r1 = original message
'
SUB Callback
	message = r1
	callback = message
	IF (message <= upperMessage) THEN GOSUB @sub[message]
END SUB
'
'
' *****  Create  *****  v0123 = xywh : r0 = window : r1 = parent
'
SUB Create
	IF (v0 <= 0) THEN v0 = 0
	IF (v1 <= 0) THEN v1 = 0
	IF (v2 <= 0) THEN v2 = designWidth
	IF (v3 <= 0) THEN v3 = designHeight
	XuiCreateGrid  (@grid, About, @v0, @v1, @v2, @v3, r0, r1, &About())
	XuiSendMessage ( grid, #SetGridName, 0, 0, 0, 0, 0, @"About")
	XuiLabel       (@g, #Create, 0, 0, 340, 192, r0, grid)
	XuiSendMessage ( g, #SetCallback, grid, &About(), -1, -1, $AboutLabel, grid)
	XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"AboutLabel")
	XuiSendMessage ( g, #SetAlign, $$AlignUpperCenter, $$JustifyCenter, -1, -1, 0, 0)
	XuiSendMessage ( g, #SetFont, 400, 400, 0, 0, 0, @"Comic Sans MS")
	text$="-={ ISif }=-\n© by Michael McE\n"+#iiversion$+" "+#date$
	XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @text$)
	SetKidFields (g)

	XuiLabel       (@g, #Create, 4, 88, 332, 100, r0, grid)
	XuiSendMessage ( g, #SetCallback, grid, &About(), -1, -1, $ServerLabel, grid)
	XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"ServerLabel")
	XuiSendMessage ( g, #SetAlign, $$AlignUpperCenter, $$JustifyCenter, -1, -1, 0, 0)
	XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"\n\n\n\nnote:\n\"Show window contents while dragging\"\nshould be disabled")
'	XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"\nI can be found in #byc\non QuakeNet\n\nnote:\n\"Show window contents while dragging\"\nshould be disabled")
	SetKidFields (g)

	GOSUB Resize
END SUB
'
'
' *****  CreateWindow  *****  v0123 = xywh : r0 = windowType : r1$ = display$
'
SUB CreateWindow
	IF (v0 == 0) THEN v0 = designX
	IF (v1 == 0) THEN v1 = designY
	IF (v2 <= 0) THEN v2 = designWidth
	IF (v3 <= 0) THEN v3 = designHeight
	XuiWindow (@window, #WindowCreate, v0, v1, v2, v3, r0, @r1$)
	v0 = 0 : v1 = 0 : r0 = window : ATTACH r1$ TO display$
	GOSUB Create
	r1 = 0 : ATTACH display$ TO r1$
	XuiWindow (window, #WindowRegister, grid, -1, v2, v3, @r0, @"About")
END SUB
'
'
' *****  GetSmallestSize  *****  see "Anatomy of Grid Functions"
'
SUB GetSmallestSize
END SUB
'
'
' *****  Redrawn  *****  see "Anatomy of Grid Functions"
'
SUB Redrawn
'	XuiCallback (grid, #Redrawn, v0, v1, v2, v3, r0, r1)
END SUB
'
'
' *****  Resize  *****  see "Anatomy of Grid Functions"
'
SUB Resize

#AboutUpperKid=$UpperKid

END SUB
'
'
' *****  Selection  *****  see "Anatomy of Grid Functions"
'
SUB Selection
END SUB
'
'
' *****  Initialize  *****  see "Anatomy of Grid Functions"
'
SUB Initialize
	XuiGetDefaultMessageFuncArray (@func[])
	XgrMessageNameToNumber (@"LastMessage", @upperMessage)
'
	func[#Callback]           = &XuiCallback ()               ' disable to handle Callback messages internally
' func[#GetSmallestSize]    = 0                             ' enable to add internal GetSmallestSize routine
' func[#Resize]             = 0                             ' enable to add internal Resize routine
'
	DIM sub[upperMessage]
'	sub[#Callback]            = SUBADDRESS (Callback)         ' enable to handle Callback messages internally
	sub[#Create]              = SUBADDRESS (Create)           ' must be subroutine in this function
	sub[#CreateWindow]        = SUBADDRESS (CreateWindow)     ' must be subroutine in this function
'	sub[#GetSmallestSize]     = SUBADDRESS (GetSmallestSize)  ' enable to add internal GetSmallestSize routine
	sub[#Redrawn]             = SUBADDRESS (Redrawn)          ' generate #Redrawn callback if appropriate
'	sub[#Resize]              = SUBADDRESS (Resize)           ' enable to add internal Resize routine
	sub[#Selection]           = SUBADDRESS (Selection)        ' routes Selection callbacks to subroutine
'
'	IF sub[0] THEN PRINT "About() : Initialize : error ::: (undefined message)"
'	IF func[0] THEN PRINT "About() : Initialize : error ::: (undefined message)"
	XuiRegisterGridType (@About, "About", &About(), @func[], @sub[])
'
' Don't remove the following 4 lines, or WindowFromFunction/WindowToFunction will not work
'
	designX = 355
	designY = 380
	designWidth = 340
	designHeight = 192
'
	gridType = About
	XuiSetGridTypeProperty (gridType, @"x",                designX)
	XuiSetGridTypeProperty (gridType, @"y",                designY)
	XuiSetGridTypeProperty (gridType, @"width",            designWidth)
	XuiSetGridTypeProperty (gridType, @"height",           designHeight)
	XuiSetGridTypeProperty (gridType, @"maxWidth",         designWidth)
	XuiSetGridTypeProperty (gridType, @"maxHeight",        designHeight)
	XuiSetGridTypeProperty (gridType, @"minWidth",         designWidth)
	XuiSetGridTypeProperty (gridType, @"minHeight",        designHeight)
	XuiSetGridTypeProperty (gridType, @"can",              $$Focus OR $$Respond OR $$Callback)
	IFZ message THEN RETURN
END SUB
END FUNCTION
'
'
' ##########################
' #####  AboutCode ()  #####
' ##########################
'
FUNCTION  AboutCode (grid, message, v0, v1, v2, v3, kid, r1)

	IF (message==#Callback) THEN message = r1
	IF (message==#CloseWindow) THEN XuiSendMessage (grid, #HideWindow, 0, 0, 0, 0, 0, 0)


END FUNCTION
'
'
'	#####################
'	#####  Axis ()  #####
'	#####################
'
FUNCTION  Axis (grid, message, v0, v1, v2, v3, r0, (r1, r1$, r1[], r1$[]))
	STATIC  designX,  designY,  designWidth,  designHeight
	STATIC  SUBADDR  sub[]
	STATIC  upperMessage
	STATIC  Axis
'
	$Axis               =   0  ' kid   0 grid type = Axis
	$Xleft              =   1  ' kid   1 grid type = XuiLabel
	$XleftTextin        =   2  ' kid   2 grid type = XuiTextLine
	$Xright             =   3  ' kid   3 grid type = XuiLabel
	$XrightTextin       =   4  ' kid   4 grid type = XuiTextLine
	$Ymin               =   5  ' kid   5 grid type = XuiLabel
	$YminTextin         =   6  ' kid   6 grid type = XuiTextLine
	$Ymax               =   7  ' kid   7 grid type = XuiLabel
	$YmaxTextin         =   8  ' kid   8 grid type = XuiTextLine
	$TotalPixels        =   9  ' kid   9 grid type = XuiLabel
	$TotalPixelsTextin  =  10  ' kid  10 grid type = XuiTextLine
	$TotalTracks        =  11  ' kid  11 grid type = XuiLabel
	$TotalTracksTextin  =  12  ' kid  12 grid type = XuiTextLine
	$Ok                 =  13  ' kid  13 grid type = XuiPushButton
	$UpperKid           =  13  ' kid maximum
'
'
	IFZ sub[] THEN GOSUB Initialize
'	XuiReportMessage (grid, message, v0, v1, v2, v3, r0, r1)
	IF XuiProcessMessage (grid, message, @v0, @v1, @v2, @v3, @r0, @r1, Axis) THEN RETURN
	IF (message <= upperMessage) THEN GOSUB @sub[message]
	RETURN
'
'
' *****  Callback  *****  message = Callback : r1 = original message
'
SUB Callback
	message = r1
	callback = message
	IF (message <= upperMessage) THEN GOSUB @sub[message]
END SUB
'
'
' *****  Create  *****  v0123 = xywh : r0 = window : r1 = parent
'
SUB Create
	IF (v0 <= 0) THEN v0 = 0
	IF (v1 <= 0) THEN v1 = 0
	IF (v2 <= 0) THEN v2 = designWidth
	IF (v3 <= 0) THEN v3 = designHeight
	XuiCreateGrid  (@grid, Axis, @v0, @v1, @v2, @v3, r0, r1, &Axis())
	XuiSendMessage ( grid, #SetGridName, 0, 0, 0, 0, 0, @"Axis")
	XuiLabel       (@g, #Create, 0, 4, 76, 28, r0, grid)
	XuiSendMessage ( g, #SetCallback, grid, &Axis(), -1, -1, $Xleft, grid)
	XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"Xleft")
	XuiSendMessage ( g, #SetAlign, $$AlignMiddleRight, $$JustifyCenter, -1, -1, 0, 0)
	XuiSendMessage ( g, #SetBorder, $$BorderNone, $$BorderNone, $$BorderNone, 0, 0, 0)
	XuiSendMessage ( g, #SetTexture, $$TextureNone, 0, 0, 0, 0, 0)
	XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"X Left:")
	XuiTextLine    (@g, #Create, 80, 4, 104, 28, r0, grid)
	XuiSendMessage ( g, #SetCallback, grid, &Axis(), -1, -1, $XleftTextin, grid)
	XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"XleftTextin")
	XuiSendMessage ( g, #SetAlign, $$AlignMiddleCenter, 0, -1, -1, 0, 0)
	XuiSendMessage ( g, #SetBorder, $$BorderLoLine1, $$BorderLoLine1, $$BorderNone, 0, 0, 0)
	XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"0")
	XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 1, @"XuiArea730")
	XuiSendMessage ( g, #SetCursor,#cursorInsert, 0, 0, 0, 0, 0)
	XuiSendMessage ( g, #SetCursor,#cursorInsert, 0, 0, 0, 1, 0)
	XuiLabel       (@g, #Create, 204, 4, 76, 28, r0, grid)
	XuiSendMessage ( g, #SetCallback, grid, &Axis(), -1, -1, $Xright, grid)
	XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"Xright")
	XuiSendMessage ( g, #SetAlign, $$AlignMiddleRight, $$JustifyCenter, -1, -1, 0, 0)
	XuiSendMessage ( g, #SetBorder, $$BorderNone, $$BorderNone, $$BorderNone, 0, 0, 0)
	XuiSendMessage ( g, #SetTexture, $$TextureNone, 0, 0, 0, 0, 0)
	XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"X Right:")
	XuiTextLine    (@g, #Create, 284, 4, 104, 28, r0, grid)
	XuiSendMessage ( g, #SetCallback, grid, &Axis(), -1, -1, $XrightTextin, grid)
	XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"XrightTextin")
	XuiSendMessage ( g, #SetAlign, $$AlignMiddleCenter, 0, -1, -1, 0, 0)
	XuiSendMessage ( g, #SetBorder, $$BorderLoLine1, $$BorderLoLine1, $$BorderNone, 0, 0, 0)
	XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"0")
	XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 1, @"XuiArea733")
	XuiSendMessage ( g, #SetCursor,#cursorInsert, 0, 0, 0, 0, 0)
	XuiSendMessage ( g, #SetCursor,#cursorInsert, 0, 0, 0, 1, 0)
	XuiLabel       (@g, #Create, 0, 36, 76, 28, r0, grid)
	XuiSendMessage ( g, #SetCallback, grid, &Axis(), -1, -1, $Ymin, grid)
	XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"Ymin")
	XuiSendMessage ( g, #SetAlign, $$AlignMiddleRight, $$JustifyCenter, -1, -1, 0, 0)
	XuiSendMessage ( g, #SetBorder, $$BorderNone, $$BorderNone, $$BorderNone, 0, 0, 0)
	XuiSendMessage ( g, #SetTexture, $$TextureNone, 0, 0, 0, 0, 0)
	XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"Y Min:")
	XuiTextLine    (@g, #Create, 80, 36, 104, 28, r0, grid)
	XuiSendMessage ( g, #SetCallback, grid, &Axis(), -1, -1, $YminTextin, grid)
	XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"YminTextin")
	XuiSendMessage ( g, #SetAlign, $$AlignMiddleCenter, 0, -1, -1, 0, 0)
	XuiSendMessage ( g, #SetBorder, $$BorderLoLine1, $$BorderLoLine1, $$BorderNone, 0, 0, 0)
	XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"0")
	XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 1, @"XuiArea736")
	XuiSendMessage ( g, #SetCursor,#cursorInsert, 0, 0, 0, 0, 0)
	XuiSendMessage ( g, #SetCursor,#cursorInsert, 0, 0, 0, 1, 0)
	XuiLabel       (@g, #Create, 204, 36, 76, 28, r0, grid)
	XuiSendMessage ( g, #SetCallback, grid, &Axis(), -1, -1, $Ymax, grid)
	XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"Ymax")
	XuiSendMessage ( g, #SetAlign, $$AlignMiddleRight, $$JustifyCenter, -1, -1, 0, 0)
	XuiSendMessage ( g, #SetBorder, $$BorderNone, $$BorderNone, $$BorderNone, 0, 0, 0)
	XuiSendMessage ( g, #SetTexture, $$TextureNone, 0, 0, 0, 0, 0)
	XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"Y Max:")
	XuiTextLine    (@g, #Create, 284, 36, 104, 28, r0, grid)
	XuiSendMessage ( g, #SetCallback, grid, &Axis(), -1, -1, $YmaxTextin, grid)
	XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"YmaxTextin")
	XuiSendMessage ( g, #SetAlign, $$AlignMiddleCenter, 0, -1, -1, 0, 0)
	XuiSendMessage ( g, #SetBorder, $$BorderLoLine1, $$BorderLoLine1, $$BorderNone, 0, 0, 0)
	XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"0")
	XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 1, @"XuiArea739")
	XuiSendMessage ( g, #SetCursor,#cursorInsert, 0, 0, 0, 0, 0)
	XuiSendMessage ( g, #SetCursor,#cursorInsert, 0, 0, 0, 1, 0)
	XuiLabel       (@g, #Create, 0, 76, 160, 28, r0, grid)
	XuiSendMessage ( g, #SetCallback, grid, &Axis(), -1, -1, $TotalPixels, grid)
	XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"TotalPixels")
	XuiSendMessage ( g, #SetBorder, $$BorderNone, $$BorderNone, $$BorderNone, 0, 0, 0)
	XuiSendMessage ( g, #SetTexture, $$TextureNone, 0, 0, 0, 0, 0)
	XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"Total Pixels: (x)")
	XuiTextLine    (@g, #Create, 12, 108, 144, 28, r0, grid)
	XuiSendMessage ( g, #SetCallback, grid, &Axis(), -1, -1, $TotalPixelsTextin, grid)
	XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"TotalPixelsTextin")
	XuiSendMessage ( g, #SetAlign, $$AlignMiddleCenter, 0, -1, -1, 0, 0)
	XuiSendMessage ( g, #SetBorder, $$BorderLoLine1, $$BorderLoLine1, $$BorderNone, 0, 0, 0)
	XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"0")
	XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 1, @"XuiArea742")
	XuiSendMessage ( g, #SetCursor,#cursorInsert, 0, 0, 0, 0, 0)
	XuiSendMessage ( g, #SetCursor,#cursorInsert, 0, 0, 0, 1, 0)
	XuiLabel       (@g, #Create, 232, 76, 160, 28, r0, grid)
	XuiSendMessage ( g, #SetCallback, grid, &Axis(), -1, -1, $TotalTracks, grid)
	XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"TotalTracks")
	XuiSendMessage ( g, #SetBorder, $$BorderNone, $$BorderNone, $$BorderNone, 0, 0, 0)
	XuiSendMessage ( g, #SetTexture, $$TextureNone, 0, 0, 0, 0, 0)
	XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"Total Tracks: (y)")
	XuiTextLine    (@g, #Create, 244, 108, 144, 28, r0, grid)
	XuiSendMessage ( g, #SetCallback, grid, &Axis(), -1, -1, $TotalTracksTextin, grid)
	XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"TotalTracksTextin")
	XuiSendMessage ( g, #SetAlign, $$AlignMiddleCenter, 0, -1, -1, 0, 0)
	XuiSendMessage ( g, #SetBorder, $$BorderLoLine1, $$BorderLoLine1, $$BorderNone, 0, 0, 0)
	XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"0")
	XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 1, @"XuiArea859")
	XuiSendMessage ( g, #SetCursor,#cursorInsert, 0, 0, 0, 0, 0)
	XuiSendMessage ( g, #SetCursor,#cursorInsert, 0, 0, 0, 1, 0)
	XuiPushButton  (@g, #Create, 172, 104, 52, 32, r0, grid)
	XuiSendMessage ( g, #SetCallback, grid, &Axis(), -1, -1, $Ok, grid)
	XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"Ok")
	XuiSendMessage ( g, #SetStyle, 2, 3, 0, 0, 0, 0)
	XuiSendMessage ( g, #SetColorExtra, $$Grey, $$White, $$Black, $$White, 0, 0)
	XuiSendMessage ( g, #SetAlign, $$AlignMiddleCenter, $$JustifyCenter, -1, -1, 0, 0)
	XuiSendMessage ( g, #SetBorder, $$BorderFlat1, $$BorderFlat1, $$BorderLower1, 0, 0, 0)
	XuiSendMessage ( g, #SetTexture, $$TextureNone, 0, 0, 0, 0, 0)
	XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"Done")
	GOSUB Resize
END SUB
'
'
' *****  CreateWindow  *****  v0123 = xywh : r0 = windowType : r1$ = display$
'
SUB CreateWindow
	IF (v0 == 0) THEN v0 = designX
	IF (v1 == 0) THEN v1 = designY
	IF (v2 <= 0) THEN v2 = designWidth
	IF (v3 <= 0) THEN v3 = designHeight
	XuiWindow (@window, #WindowCreate, v0, v1, v2, v3, r0, @r1$)
	v0 = 0 : v1 = 0 : r0 = window : ATTACH r1$ TO display$
	GOSUB Create
	r1 = 0 : ATTACH display$ TO r1$
	XuiWindow (window, #WindowRegister, grid, -1, v2, v3, @r0, @"Axis")
END SUB
'
'
' *****  GetSmallestSize  *****  see "Anatomy of Grid Functions"
'
SUB GetSmallestSize
END SUB
'
'
' *****  Redrawn  *****  see "Anatomy of Grid Functions"
'
SUB Redrawn
	XuiCallback (grid, #Redrawn, v0, v1, v2, v3, r0, r1)
END SUB
'
'
' *****  Resize  *****  see "Anatomy of Grid Functions"
'
SUB Resize
END SUB
'
'
' *****  Selection  *****  see "Anatomy of Grid Functions"
'
SUB Selection
END SUB
'
'
' *****  Initialize  *****  see "Anatomy of Grid Functions"
'
SUB Initialize
	XuiGetDefaultMessageFuncArray (@func[])
	XgrMessageNameToNumber (@"LastMessage", @upperMessage)
'
	func[#Callback]           = &XuiCallback ()               ' disable to handle Callback messages internally
' func[#GetSmallestSize]    = 0                             ' enable to add internal GetSmallestSize routine
	func[#Resize]             = 0                             ' enable to add internal Resize routine
'
	DIM sub[upperMessage]
'	sub[#Callback]            = SUBADDRESS (Callback)         ' enable to handle Callback messages internally
	sub[#Create]              = SUBADDRESS (Create)           ' must be subroutine in this function
	sub[#CreateWindow]        = SUBADDRESS (CreateWindow)     ' must be subroutine in this function
'	sub[#GetSmallestSize]     = SUBADDRESS (GetSmallestSize)  ' enable to add internal GetSmallestSize routine
	sub[#Redrawn]             = SUBADDRESS (Redrawn)          ' generate #Redrawn callback if appropriate
'	sub[#Resize]              = SUBADDRESS (Resize)           ' enable to add internal Resize routine
	sub[#Selection]           = SUBADDRESS (Selection)        ' routes Selection callbacks to subroutine
'
'	IF sub[0] THEN PRINT "Axis() : Initialize : error ::: (undefined message)"
'	IF func[0] THEN PRINT "Axis() : Initialize : error ::: (undefined message)"
	XuiRegisterGridType (@Axis, "Axis", &Axis(), @func[], @sub[])
'
' Don't remove the following 4 lines, or WindowFromFunction/WindowToFunction will not work
'
	designX = 565
	designY = 451
	designWidth = 396
	designHeight = 144
'
	gridType = Axis
	XuiSetGridTypeProperty (gridType, @"x",                designX)
	XuiSetGridTypeProperty (gridType, @"y",                designY)
	XuiSetGridTypeProperty (gridType, @"width",            designWidth)
	XuiSetGridTypeProperty (gridType, @"height",           designHeight)
'	XuiSetGridTypeProperty (gridType, @"maxWidth",         designWidth)
'	XuiSetGridTypeProperty (gridType, @"maxHeight",        designHeight)
'	XuiSetGridTypeProperty (gridType, @"minWidth",         designWidth)
'	XuiSetGridTypeProperty (gridType, @"minHeight",        designHeight)
	XuiSetGridTypeProperty (gridType, @"can",              $$Focus OR $$Respond OR $$Callback OR $$TextSelection)
	XuiSetGridTypeProperty (gridType, @"focusKid",         $XleftTextin)
	XuiSetGridTypeProperty (gridType, @"inputTextString",  $XleftTextin)
	IFZ message THEN RETURN
END SUB
END FUNCTION
'
'
' #########################
' #####  AxisCode ()  #####
' #########################
'
FUNCTION  AxisCode (grid, message, v0, v1, v2, v3, kid, r1)
	SHARED cur
	SHARED MemDataSet ImageDataSet[]
	SHARED Image ImageFormat[]
	STATIC Xleft$, Xright$, Ymin$, Ymax$, Tpixels$, Ttracks$
	STATIC xflag,yflag,ptflag
'
	$Axis               =   0  ' kid   0 grid type = Axis
	$Xleft              =   1  ' kid   1 grid type = XuiLabel
	$XleftTextin        =   2  ' kid   2 grid type = XuiTextLine
	$Xright             =   3  ' kid   3 grid type = XuiLabel
	$XrightTextin       =   4  ' kid   4 grid type = XuiTextLine
	$Ymin               =   5  ' kid   5 grid type = XuiLabel
	$YminTextin         =   6  ' kid   6 grid type = XuiTextLine
	$Ymax               =   7  ' kid   7 grid type = XuiLabel
	$YmaxTextin         =   8  ' kid   8 grid type = XuiTextLine
	$TotalPixels        =   9  ' kid   9 grid type = XuiLabel
	$TotalPixelsTextin  =  10  ' kid  10 grid type = XuiTextLine
	$TotalTracks        =  11  ' kid  11 grid type = XuiLabel
	$TotalTracksTextin  =  12  ' kid  12 grid type = XuiTextLine
	$Ok                 =  13  ' kid  13 grid type = XuiPushButton
	$UpperKid           =  13  ' kid maximum
'
'	XuiReportMessage (grid, message, v0, v1, v2, v3, kid, r1)
	IF (message == #Callback) THEN message = r1
'
	SELECT CASE message
		CASE #Selection		: GOSUB Selection
		CASE #CloseWindow	: XuiSendMessage (grid, #HideWindow, 0, 0, 0, 0, 0, 0)
		CASE #TextEvent		: key=v2{BITFIELD (8,0)}
												removeTab (#Axis,$XleftTextin): removeTab (#Axis,$XrightTextin)
												removeTab (#Axis,$YminTextin): removeTab (#Axis,$YmaxTextin)
												removeTab (#Axis,$TotalPixelsTextin): removeTab (#Axis,$TotalTracksTextin)

												SELECT CASE kid
														CASE $XleftTextin       :xflag=1: IF key=9 THEN SetFocusOnKid (grid,$XrightTextin)
														CASE $XrightTextin      :xflag=1: IF key=9 THEN SetFocusOnKid (grid,$YminTextin)
														CASE $YminTextin        :yflag=1: IF key=9 THEN SetFocusOnKid (grid,$YmaxTextin)
														CASE $YmaxTextin        :yflag=1: IF key=9 THEN SetFocusOnKid (grid,$TotalPixelsTextin)
														CASE $TotalPixelsTextin :ptflag=1:IF key=9 THEN SetFocusOnKid (grid,$TotalTracksTextin)
														CASE $TotalTracksTextin :ptflag=1:IF key=9 THEN SetFocusOnKid (grid,$Ok)
														CASE $Ok								:IF key=9 THEN SetFocusOnKid (grid,$XleftTextin)
												END SELECT
	END SELECT

	RETURN
'
'
' *****  Selection  *****
'
SUB Selection
	SELECT CASE kid
		CASE $Ok								 :GOSUB GetBoxValues
	END SELECT
END SUB

'#################
SUB GetBoxValues
'#################

	XuiSendMessage (#Axis,#GetTextString,0,0,0,0,$XleftTextin,@Xleft$)
	XuiSendMessage (#Axis,#GetTextString,0,0,0,0,$XrightTextin,@Xright$)
	XuiSendMessage (#Axis,#GetTextString,0,0,0,0,$YminTextin,@Ymin$)
	XuiSendMessage (#Axis,#GetTextString,0,0,0,0,$YmaxTextin,@Ymax$)
	XuiSendMessage (#Axis,#GetTextString,0,0,0,0,$TotalPixelsTextin,@Tpixels$)
	XuiSendMessage (#Axis,#GetTextString,0,0,0,0,$TotalTracksTextin,@Ttracks$)

	IF xflag=1 THEN GOSUB SetX
	IF yflag=1 THEN GOSUB SetY
	IF ptflag=1 THEN GOSUB SetPixelsTracks

	XuiSendMessage (grid, #HideWindow, 0, 0, 0, 0, 0, 0)

END SUB

'####################
SUB SetPixelsTracks
'####################

	XstStringToNumber (Tpixels$,0,0,@type,@newPix)
	XstStringToNumber (Ttracks$,0,0,@type,@newTrk)

	IF ((newTrk=ImageFormat[#ImageSet,#dataFile].NumberOfTracks) AND (newPix=ImageFormat[#ImageSet,#dataFile].NumberOfPixels)) THEN EXIT SUB
	IF ((newPix<1) OR (newTrk<1)) THEN EXIT SUB

	ImageFormat[#ImageSet,#dataFile].NumberOfPixels=newPix
	ImageFormat[#ImageSet,#dataFile].NumberOfTracks=newTrk

	ImageDataSet[#ImageSet].Track=0
	ImageFormat[#ImageSet,#dataFile].fPixel=0									' first selected track pixel
	ImageFormat[#ImageSet,#dataFile].lPixel=ImageFormat[#ImageSet,#dataFile].NumberOfPixels-1			' last  ^^

	InitDisplay ()

END SUB


'#################
SUB SetY
'#################

	XstStringToNumber (Ymin$,0,0,@type,@newMin!)
	XstStringToNumber (Ymax$,0,0,@type,@newMax!)

	IF ((newMin!=ImageDataSet[#ImageSet].MinValue) AND (newMax!=ImageDataSet[#ImageSet].MaxValue)) THEN EXIT SUB
	IF newMax!>newMin! THEN

				ImageDataSet[#ImageSet].MinValue=newMin!
				ImageDataSet[#ImageSet].MaxValue=newMax!

				#customMax=ImageDataSet[#ImageSet].MaxValue
				#customMin=ImageDataSet[#ImageSet].MinValue

				setTrackVoffset (#ImageSet)
				DisplayTrack (ImageDataSet[#ImageSet].Track,0)

	END IF


END SUB


'#################
SUB SetX
'#################

	XstStringToNumber (Xleft$,0,0,@type,@newLeft)
	XstStringToNumber (Xright$,0,0,@type,@newRight)
	DEC newRight:	DEC newLeft

	IF ((newLeft=ImageFormat[#ImageSet,#dataFile].fPixel) AND (newRight=ImageFormat[#ImageSet,#dataFile].lPixel)) THEN EXIT SUB
	IF  ((newLeft<ImageFormat[#ImageSet,#dataFile].lPixel) AND (newRight>ImageFormat[#ImageSet,#dataFile].fPixel) AND (newLeft<newRight))  THEN
				ImageFormat[#ImageSet,#dataFile].fPixel=newLeft
				ImageFormat[#ImageSet,#dataFile].lPixel=newRight
				ClearHcoverField ()
				DisplayTrack(ImageDataSet[#ImageSet].Track,0)
	END IF

END SUB



END FUNCTION
'
'
'	#####################
'	#####  Goto ()  #####
'	#####################
'
FUNCTION  Goto (grid, message, v0, v1, v2, v3, r0, (r1, r1$, r1[], r1$[]))
	STATIC  designX,  designY,  designWidth,  designHeight
	STATIC  SUBADDR  sub[]
	STATIC  upperMessage
	STATIC  Goto
'
	$Goto       =   0  ' kid   0 grid type = Goto
	$Track      =   1  ' kid   1 grid type = XuiLabel
	$Pixel      =   2  ' kid   2 grid type = XuiLabel
	$Trackin    =   3  ' kid   3 grid type = XuiTextLine
	$Pixelin    =   4  ' kid   4 grid type = XuiTextLine
	$Ok         =   5  ' kid   5 grid type = XuiPushButton
	$keepscale  =   6  ' kid   6 grid type = XuiCheckBox
	$UpperKid   =   6  ' kid maximum
'
'
	IFZ sub[] THEN GOSUB Initialize
'	XuiReportMessage (grid, message, v0, v1, v2, v3, r0, r1)
	IF XuiProcessMessage (grid, message, @v0, @v1, @v2, @v3, @r0, @r1, Goto) THEN RETURN
	IF (message <= upperMessage) THEN GOSUB @sub[message]
	RETURN
'
'
' *****  Callback  *****  message = Callback : r1 = original message
'
SUB Callback
	message = r1
	callback = message
	IF (message <= upperMessage) THEN GOSUB @sub[message]
END SUB
'
'
' *****  Create  *****  v0123 = xywh : r0 = window : r1 = parent
'
SUB Create
	IF (v0 <= 0) THEN v0 = 0
	IF (v1 <= 0) THEN v1 = 0
	IF (v2 <= 0) THEN v2 = designWidth
	IF (v3 <= 0) THEN v3 = designHeight
	XuiCreateGrid  (@grid, Goto, @v0, @v1, @v2, @v3, r0, r1, &Goto())
	XuiSendMessage ( grid, #SetGridName, 0, 0, 0, 0, 0, @"Goto")
	XuiLabel       (@g, #Create, 0, 28, 96, 24, r0, grid)
	XuiSendMessage ( g, #SetCallback, grid, &Goto(), -1, -1, $Track, grid)
	XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"Track")
	XuiSendMessage ( g, #SetBorder, $$BorderNone, $$BorderNone, $$BorderNone, 0, 0, 0)
	XuiSendMessage ( g, #SetTexture, $$TextureNone, 0, 0, 0, 0, 0)
	XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"Track (y):")
	XuiLabel       (@g, #Create, 0, 0, 96, 24, r0, grid)
	XuiSendMessage ( g, #SetCallback, grid, &Goto(), -1, -1, $Pixel, grid)
	XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"Pixel")
	XuiSendMessage ( g, #SetBorder, $$BorderNone, $$BorderNone, $$BorderNone, 0, 0, 0)
	XuiSendMessage ( g, #SetTexture, $$TextureNone, 0, 0, 0, 0, 0)
	XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"Pixel (x):")
	XuiTextLine    (@g, #Create, 100, 28, 76, 24, r0, grid)
	XuiSendMessage ( g, #SetCallback, grid, &Goto(), -1, -1, $Trackin, grid)
	XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"Trackin")
	XuiSendMessage ( g, #SetAlign, $$AlignMiddleCenter, 0, -1, -1, 0, 0)
	XuiSendMessage ( g, #SetBorder, $$BorderLoLine1, $$BorderLoLine1, $$BorderNone, 0, 0, 0)
	XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"0")
	XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 1, @"XuiArea731")
	XuiSendMessage ( g, #SetCursor,#cursorInsert, 0, 0, 0, 0, 0)
	XuiSendMessage ( g, #SetCursor,#cursorInsert, 0, 0, 0, 1, 0)
	XuiTextLine    (@g, #Create, 100, 0, 76, 24, r0, grid)
	XuiSendMessage ( g, #SetCallback, grid, &Goto(), -1, -1, $Pixelin, grid)
	XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"Pixelin")
	XuiSendMessage ( g, #SetBorder, $$BorderLoLine1, $$BorderLoLine1, $$BorderNone, 0, 0, 0)
	XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"0")
	XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 1, @"XuiArea733")
	XuiSendMessage ( g, #SetCursor,#cursorInsert, 0, 0, 0, 0, 0)
	XuiSendMessage ( g, #SetCursor,#cursorInsert, 0, 0, 0, 1, 0)
	XuiPushButton  (@g, #Create, 4, 56, 92, 24, r0, grid)
	XuiSendMessage ( g, #SetCallback, grid, &Goto(), -1, -1, $Ok, grid)
	XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"Ok")
	XuiSendMessage ( g, #SetStyle, 2, 3, 0, 0, 0, 0)
	XuiSendMessage ( g, #SetColorExtra, $$Grey, $$White, $$Black, $$White, 0, 0)
	XuiSendMessage ( g, #SetBorder, $$BorderFlat1, $$BorderFlat1, $$BorderLower1, 0, 0, 0)
	XuiSendMessage ( g, #SetTexture, $$TextureNone, 0, 0, 0, 0, 0)
	XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"Goto")
	XuiCheckBox    (@g, #Create, 100, 56, 76, 24, r0, grid)
	XuiSendMessage ( g, #SetCallback, grid, &Goto(), -1, -1, $keepscale, grid)
	XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"keepscale")
	XuiSendMessage ( g, #SetStyle, 3, 3, 0, 0, 0, 0)
	XuiSendMessage ( g, #SetColorExtra, $$Grey, $$White, $$Black, $$White, 0, 0)
	XuiSendMessage ( g, #SetBorder, $$BorderValley, $$BorderValley, $$BorderRaise1, 0, 0, 0)
	XuiSendMessage ( g, #SetTexture, $$TextureNone, 0, 0, 0, 0, 0)
	XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"Scale")
	GOSUB Resize
END SUB
'
'
' *****  CreateWindow  *****  v0123 = xywh : r0 = windowType : r1$ = display$
'
SUB CreateWindow
	IF (v0 == 0) THEN v0 = designX
	IF (v1 == 0) THEN v1 = designY
	IF (v2 <= 0) THEN v2 = designWidth
	IF (v3 <= 0) THEN v3 = designHeight
	XuiWindow (@window, #WindowCreate, v0, v1, v2, v3, r0, @r1$)
	v0 = 0 : v1 = 0 : r0 = window : ATTACH r1$ TO display$
	GOSUB Create
	r1 = 0 : ATTACH display$ TO r1$
	XuiWindow (window, #WindowRegister, grid, -1, v2, v3, @r0, @"Goto")
END SUB
'
'
' *****  GetSmallestSize  *****  see "Anatomy of Grid Functions"
'
SUB GetSmallestSize
END SUB
'
'
' *****  Redrawn  *****  see "Anatomy of Grid Functions"
'
SUB Redrawn
	XuiCallback (grid, #Redrawn, v0, v1, v2, v3, r0, r1)
END SUB
'
'
' *****  Resize  *****  see "Anatomy of Grid Functions"
'
SUB Resize
END SUB
'
'
' *****  Selection  *****  see "Anatomy of Grid Functions"
'
SUB Selection
END SUB
'
'
' *****  Initialize  *****  see "Anatomy of Grid Functions"
'
SUB Initialize
	XuiGetDefaultMessageFuncArray (@func[])
	XgrMessageNameToNumber (@"LastMessage", @upperMessage)
'
	func[#Callback]           = &XuiCallback ()               ' disable to handle Callback messages internally
' func[#GetSmallestSize]    = 0                             ' enable to add internal GetSmallestSize routine
' func[#Resize]             = 0                             ' enable to add internal Resize routine
'
	DIM sub[upperMessage]
'	sub[#Callback]            = SUBADDRESS (Callback)         ' enable to handle Callback messages internally
	sub[#Create]              = SUBADDRESS (Create)           ' must be subroutine in this function
	sub[#CreateWindow]        = SUBADDRESS (CreateWindow)     ' must be subroutine in this function
'	sub[#GetSmallestSize]     = SUBADDRESS (GetSmallestSize)  ' enable to add internal GetSmallestSize routine
	sub[#Redrawn]             = SUBADDRESS (Redrawn)          ' generate #Redrawn callback if appropriate
'	sub[#Resize]              = SUBADDRESS (Resize)           ' enable to add internal Resize routine
	sub[#Selection]           = SUBADDRESS (Selection)        ' routes Selection callbacks to subroutine
'
	IF sub[0] THEN PRINT "Goto() : Initialize : error ::: (undefined message)"
	IF func[0] THEN PRINT "Goto() : Initialize : error ::: (undefined message)"
	XuiRegisterGridType (@Goto, "Goto", &Goto(), @func[], @sub[])
'
' Don't remove the following 4 lines, or WindowFromFunction/WindowToFunction will not work
'
	designX = 640
	designY = 403
	designWidth = 180
	designHeight = 84
'
	gridType = Goto
	XuiSetGridTypeProperty (gridType, @"x",                designX)
	XuiSetGridTypeProperty (gridType, @"y",                designY)
	XuiSetGridTypeProperty (gridType, @"width",            designWidth)
	XuiSetGridTypeProperty (gridType, @"height",           designHeight)
	XuiSetGridTypeProperty (gridType, @"maxWidth",         designWidth)
	XuiSetGridTypeProperty (gridType, @"maxHeight",        designHeight)
	XuiSetGridTypeProperty (gridType, @"minWidth",         designWidth)
	XuiSetGridTypeProperty (gridType, @"minHeight",        designHeight)
	XuiSetGridTypeProperty (gridType, @"can",              $$Focus OR $$Respond OR $$Callback OR $$TextSelection)
	XuiSetGridTypeProperty (gridType, @"focusKid",         $Trackin)
	XuiSetGridTypeProperty (gridType, @"inputTextString",  $Trackin)
	IFZ message THEN RETURN
END SUB
END FUNCTION
'
'
' #########################
' #####  GotoCode ()  #####
' #########################
'
FUNCTION  GotoCode (grid, message, v0, v1, v2, v3, kid, r1)
	SHARED cur,Scheck
	SHARED Image ImageFormat[]
	STATIC xflag,yflag
	STATIC pix$,trk$
'
'
	$Goto       =   0  ' kid   0 grid type = Goto
	$Track      =   1  ' kid   1 grid type = XuiLabel
	$Pixel      =   2  ' kid   2 grid type = XuiLabel
	$Trackin    =   3  ' kid   3 grid type = XuiTextLine
	$Pixelin    =   4  ' kid   4 grid type = XuiTextLine
	$Ok         =   5  ' kid   5 grid type = XuiPushButton
	$keepscale  =   6  ' kid   6 grid type = XuiCheckBox
	$UpperKid   =   6  ' kid maximum
'
'	XuiReportMessage (grid, message, v0, v1, v2, v3, kid, r1)
	IF (message == #Callback) THEN message = r1
'	XgrMessageNumberToName  (message,@message$): PRINT grid, message$, v0, v1, v2, v3, kid, r1

'
	SELECT CASE message
		CASE #Initialize	: Scheck=0
		CASE #Selection		: GOSUB Selection
		CASE #CloseWindow	: XuiSendMessage (grid, #HideWindow, 0, 0, 0, 0, 0, 0)
		CASE #TextEvent		: key=v2{BITFIELD (8,0)}
												removeTab (#Goto,$Pixelin): removeTab (#Goto,$Trackin)
												SELECT CASE kid
															CASE $Pixelin   :xflag=1
																							IF key=9 THEN SetFocusOnKid (grid,$Trackin)
																							IF key=13 THEN GOSUB GetBoxValues
															CASE $Trackin   :yflag=1
																							IF key=9 THEN SetFocusOnKid (grid,$Ok)
																							IF key=13 THEN GOSUB GetBoxValues
															CASE $Ok			:IF key=9 THEN SetFocusOnKid (grid,$Pixelin)

												END SELECT
	END SELECT
	RETURN
'
'
' *****  Selection  *****
'
SUB Selection
	SELECT CASE kid
		CASE $Ok        :GOSUB GetBoxValues: XuiSendMessage (grid, #HideWindow, 0, 0, 0, 0, 0, 0)
		CASE $keepscale :IF v0=0 THEN Scheck=0 ELSE Scheck=1
	END SELECT
END SUB


'#################
SUB GetBoxValues
'#################

	GOSUB SetX
	GOSUB SetY

	IF ((xflag=1) OR (yflag=1)) THEN GotoPixel2d (ULONG(newPix$$),ULONG(newTrk$$))

END SUB

'#################
SUB SetX
'#################

	XuiSendMessage (#Goto,#GetTextString,0,0,0,0,$Pixelin,@pix$)
	XstStringToNumber (pix$,0,0,@type,@newPix$$)

END SUB


'#################
SUB SetY
'#################

	XuiSendMessage (#Goto,#GetTextString,0,0,0,0,$Trackin,@trk$)
	XstStringToNumber (trk$,0,0,@type,@newTrk$$)

END SUB

END FUNCTION
'
'
'	#########################
'	#####  SetPixel ()  #####
'	#########################
'
FUNCTION  SetPixel (grid, message, v0, v1, v2, v3, r0, (r1, r1$, r1[], r1$[]))
	STATIC  designX,  designY,  designWidth,  designHeight
	STATIC  SUBADDR  sub[]
	STATIC  upperMessage
	STATIC  SetPixel
'
	$SetPixel  =   0  ' kid   0 grid type = SetPixel
	$Track     =   1  ' kid   1 grid type = XuiLabel
	$Pixel     =   2  ' kid   2 grid type = XuiLabel
	$Trackin   =   3  ' kid   3 grid type = XuiTextLine
	$Pixelin   =   4  ' kid   4 grid type = XuiTextLine
	$Ok        =   5  ' kid   5 grid type = XuiPushButton
	$Valuelb   =   6  ' kid   6 grid type = XuiLabel
	$Valuein   =   7  ' kid   7 grid type = XuiTextLine
	$UpperKid  =   7  ' kid maximum
'
'
	IFZ sub[] THEN GOSUB Initialize
'	XuiReportMessage (grid, message, v0, v1, v2, v3, r0, r1)
	IF XuiProcessMessage (grid, message, @v0, @v1, @v2, @v3, @r0, @r1, SetPixel) THEN RETURN
	IF (message <= upperMessage) THEN GOSUB @sub[message]
	RETURN
'
'
' *****  Callback  *****  message = Callback : r1 = original message
'
SUB Callback
	message = r1
	callback = message
	IF (message <= upperMessage) THEN GOSUB @sub[message]
END SUB
'
'
' *****  Create  *****  v0123 = xywh : r0 = window : r1 = parent
'
SUB Create
	IF (v0 <= 0) THEN v0 = 0
	IF (v1 <= 0) THEN v1 = 0
	IF (v2 <= 0) THEN v2 = designWidth
	IF (v3 <= 0) THEN v3 = designHeight
	XuiCreateGrid  (@grid, SetPixel, @v0, @v1, @v2, @v3, r0, r1, &SetPixel())
	XuiSendMessage ( grid, #SetGridName, 0, 0, 0, 0, 0, @"SetPixel")
	XuiLabel       (@g, #Create, 0, 28, 96, 24, r0, grid)
	XuiSendMessage ( g, #SetCallback, grid, &SetPixel(), -1, -1, $Track, grid)
	XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"Track")
	XuiSendMessage ( g, #SetBorder, $$BorderNone, $$BorderNone, $$BorderNone, 0, 0, 0)
	XuiSendMessage ( g, #SetTexture, $$TextureNone, 0, 0, 0, 0, 0)
	XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"Track (y):")
	XuiLabel       (@g, #Create, 0, 0, 96, 24, r0, grid)
	XuiSendMessage ( g, #SetCallback, grid, &SetPixel(), -1, -1, $Pixel, grid)
	XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"Pixel")
	XuiSendMessage ( g, #SetBorder, $$BorderNone, $$BorderNone, $$BorderNone, 0, 0, 0)
	XuiSendMessage ( g, #SetTexture, $$TextureNone, 0, 0, 0, 0, 0)
	XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"Pixel (x):")
	XuiTextLine    (@g, #Create, 100, 28, 76, 24, r0, grid)
	XuiSendMessage ( g, #SetCallback, grid, &SetPixel(), -1, -1, $Trackin, grid)
	XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"Trackin")
	XuiSendMessage ( g, #SetAlign, $$AlignMiddleCenter, 0, -1, -1, 0, 0)
	XuiSendMessage ( g, #SetBorder, $$BorderLoLine1, $$BorderLoLine1, $$BorderNone, 0, 0, 0)
	XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"0")
	XuiSendMessage ( g, #SetGridName, 0,0, 0, 0, 1, @"XuiArea731")
	XuiSendMessage ( g, #SetCursor,#cursorInsert, 0, 0, 0, 0, 0)
	XuiSendMessage ( g, #SetCursor,#cursorInsert, 0, 0, 0, 1, 0)
	XuiTextLine    (@g, #Create, 100, 0, 76, 24, r0, grid)
	XuiSendMessage ( g, #SetCallback, grid, &SetPixel(), -1, -1, $Pixelin, grid)
	XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"Pixelin")
	XuiSendMessage ( g, #SetBorder, $$BorderLoLine1, $$BorderLoLine1, $$BorderNone, 0, 0, 0)
	XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"0")
	XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 1, @"XuiArea733")
	XuiSendMessage ( g, #SetCursor,#cursorInsert, 0, 0, 0, 0, 0)
	XuiSendMessage ( g, #SetCursor,#cursorInsert, 0, 0, 0, 1, 0)
	XuiPushButton  (@g, #Create, 36, 84, 92, 24, r0, grid)
	XuiSendMessage ( g, #SetCallback, grid, &SetPixel(), -1, -1, $Ok, grid)
	XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"Ok")
	XuiSendMessage ( g, #SetStyle, 2, 3, 0, 0, 0, 0)
	XuiSendMessage ( g, #SetColorExtra, $$Grey, $$White, $$Black, $$White, 0, 0)
	XuiSendMessage ( g, #SetBorder, $$BorderFlat1, $$BorderFlat1, $$BorderLower1, 0, 0, 0)
	XuiSendMessage ( g, #SetTexture, $$TextureNone, 0, 0, 0, 0, 0)
	XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"Done")
	XuiLabel       (@g, #Create, 0, 56, 96, 24, r0, grid)
	XuiSendMessage ( g, #SetCallback, grid, &SetPixel(), -1, -1, $Valuelb, grid)
	XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"Valuelb")
	XuiSendMessage ( g, #SetBorder, $$BorderNone, $$BorderNone, $$BorderNone, 0, 0, 0)
	XuiSendMessage ( g, #SetTexture, $$TextureNone, 0, 0, 0, 0, 0)
	XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"Set to:")
	XuiTextLine    (@g, #Create, 100, 56, 76, 24, r0, grid)
	XuiSendMessage ( g, #SetCallback, grid, &SetPixel(), -1, -1, $Valuein, grid)
	XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"Valuein")
	XuiSendMessage ( g, #SetAlign, $$AlignMiddleCenter, $$JustifyCenter, -1, -1, 0, 0)
	XuiSendMessage ( g, #SetBorder, $$BorderLoLine1, $$BorderLoLine1, $$BorderNone, 0, 0, 0)
	XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"0")
	XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 1, @"XuiArea738")
	XuiSendMessage ( g, #SetCursor,#cursorInsert, 0, 0, 0, 0, 0)
	XuiSendMessage ( g, #SetCursor,#cursorInsert, 0, 0, 0, 1, 0)
	GOSUB Resize
END SUB
'
'
' *****  CreateWindow  *****  v0123 = xywh : r0 = windowType : r1$ = display$
'
SUB CreateWindow
	IF (v0 == 0) THEN v0 = designX
	IF (v1 == 0) THEN v1 = designY
	IF (v2 <= 0) THEN v2 = designWidth
	IF (v3 <= 0) THEN v3 = designHeight
	XuiWindow (@window, #WindowCreate, v0, v1, v2, v3, r0, @r1$)
	v0 = 0 : v1 = 0 : r0 = window : ATTACH r1$ TO display$
	GOSUB Create
	r1 = 0 : ATTACH display$ TO r1$
	XuiWindow (window, #WindowRegister, grid, -1, v2, v3, @r0, @"SetPixel")
END SUB
'
'
' *****  GetSmallestSize  *****  see "Anatomy of Grid Functions"
'
SUB GetSmallestSize
END SUB
'
'
' *****  Redrawn  *****  see "Anatomy of Grid Functions"
'
SUB Redrawn
	XuiCallback (grid, #Redrawn, v0, v1, v2, v3, r0, r1)
END SUB
'
'
' *****  Resize  *****  see "Anatomy of Grid Functions"
'
SUB Resize
END SUB
'
'
' *****  Selection  *****  see "Anatomy of Grid Functions"
'
SUB Selection
END SUB
'
'
' *****  Initialize  *****  see "Anatomy of Grid Functions"
'
SUB Initialize
	XuiGetDefaultMessageFuncArray (@func[])
	XgrMessageNameToNumber (@"LastMessage", @upperMessage)
'
	func[#Callback]           = &XuiCallback ()               ' disable to handle Callback messages internally
' func[#GetSmallestSize]    = 0                             ' enable to add internal GetSmallestSize routine
' func[#Resize]             = 0                             ' enable to add internal Resize routine
'
	DIM sub[upperMessage]
'	sub[#Callback]            = SUBADDRESS (Callback)         ' enable to handle Callback messages internally
	sub[#Create]              = SUBADDRESS (Create)           ' must be subroutine in this function
	sub[#CreateWindow]        = SUBADDRESS (CreateWindow)     ' must be subroutine in this function
'	sub[#GetSmallestSize]     = SUBADDRESS (GetSmallestSize)  ' enable to add internal GetSmallestSize routine
	sub[#Redrawn]             = SUBADDRESS (Redrawn)          ' generate #Redrawn callback if appropriate
'	sub[#Resize]              = SUBADDRESS (Resize)           ' enable to add internal Resize routine
	sub[#Selection]           = SUBADDRESS (Selection)        ' routes Selection callbacks to subroutine
'
'	IF sub[0] THEN PRINT "SetPixel() : Initialize : error ::: (undefined message)"
'	IF func[0] THEN PRINT "SetPixel() : Initialize : error ::: (undefined message)"
	XuiRegisterGridType (@SetPixel, "SetPixel", &SetPixel(), @func[], @sub[])
'
' Don't remove the following 4 lines, or WindowFromFunction/WindowToFunction will not work
'
	designX = 518
	designY = 481
	designWidth = 180
	designHeight = 112
'
	gridType = SetPixel
	XuiSetGridTypeProperty (gridType, @"x",                designX)
	XuiSetGridTypeProperty (gridType, @"y",                designY)
	XuiSetGridTypeProperty (gridType, @"width",            designWidth)
	XuiSetGridTypeProperty (gridType, @"height",           designHeight)
	XuiSetGridTypeProperty (gridType, @"maxWidth",         designWidth)
	XuiSetGridTypeProperty (gridType, @"maxHeight",        designHeight)
	XuiSetGridTypeProperty (gridType, @"minWidth",         designWidth)
	XuiSetGridTypeProperty (gridType, @"minHeight",        designHeight)
	XuiSetGridTypeProperty (gridType, @"can",              0x00)
	IFZ message THEN RETURN
END SUB
END FUNCTION
'
'
' #############################
' #####  SetPixelCode ()  #####
' #############################
'
'
FUNCTION  SetPixelCode (grid, message, v0, v1, v2, v3, kid, r1)
	SINGLE value
	SHARED MemDataSet ImageDataSet[]
	STATIC vflag,x$$,y$$,val
'
	$SetPixel  =   0  ' kid   0 grid type = SetPixel
	$Track     =   1  ' kid   1 grid type = XuiLabel
	$Pixel     =   2  ' kid   2 grid type = XuiLabel
	$Trackin   =   3  ' kid   3 grid type = XuiTextLine
	$Pixelin   =   4  ' kid   4 grid type = XuiTextLine
	$Ok        =   5  ' kid   5 grid type = XuiPushButton
	$Valuelb   =   6  ' kid   6 grid type = XuiLabel
	$Valuein   =   7  ' kid   7 grid type = XuiTextLine
	$UpperKid  =   7  ' kid maximum
'
'	XuiReportMessage (grid, message, v0, v1, v2, v3, kid, r1)
	IF (message == #Callback) THEN message = r1
'
	SELECT CASE message
		CASE #Selection		: GOSUB Selection
		CASE #CloseWindow	: XuiSendMessage (grid, #HideWindow, 0, 0, 0, 0, 0, 0)
		CASE #TextEvent		: key=v2{BITFIELD (8,0)}
												removeTab (#SetPixel,$Pixelin): removeTab (#SetPixel,$Trackin): removeTab (#SetPixel,$Valuein)
												SELECT CASE kid
															CASE $Pixelin   :xflag=1
																							IF key=9 THEN SetFocusOnKid (grid,$Trackin)
																							IF key=13 THEN GOSUB GetBoxValues
															CASE $Trackin   :yflag=1
																							IF key=9 THEN SetFocusOnKid (grid,$Valuein)
																							IF key=13 THEN GOSUB GetBoxValues
															CASE $Valuein   :vflag=1
																							IF key=9 THEN SetFocusOnKid (grid,$Ok)
																							IF key=13 THEN GOSUB GetBoxValues
															CASE $Ok				:IF key=9 THEN SetFocusOnKid (grid,$Pixelin)

												END SELECT
	END SELECT
	RETURN
'
'
' *****  Selection  *****
'
SUB Selection
	SELECT CASE kid
		CASE $Ok        :GOSUB GetBoxValues: XuiSendMessage (grid, #HideWindow, 0, 0, 0, 0, 0, 0)
	END SELECT
END SUB


'#################
SUB GetBoxValues
'#################

	GOSUB GetX
	GOSUB GetY
	GOSUB GetValue

	SetPixelValue (0,ULONG(pix$$),ULONG(trk$$),val)
	ImageDataSet[#ImageSet].Track=trk$$-1
	DisplayTrack (ImageDataSet[#ImageSet].Track,0)

END SUB

'#################
SUB GetX
'#################

	XuiSendMessage (#SetPixel,#GetTextString,0,0,0,0,$Pixelin,@pix$)
	XstStringToNumber (pix$,0,0,@type,@pix$$)

END SUB


'#################
SUB GetY
'#################

	XuiSendMessage (#SetPixel,#GetTextString,0,0,0,0,$Trackin,@trk$)
	XstStringToNumber (trk$,0,0,@type,@trk$$)

END SUB

'#################
SUB GetValue
'#################

	XuiSendMessage (#SetPixel,#GetTextString,0,0,0,0,$Valuein,@val$)
	XstStringToNumber (val$,0,0,@type,@value$$)

	SELECT CASE type
			CASE $$SLONG	: val=GLOW(value$$)
			CASE $$XLONG	: val=value$$
			CASE $$SINGLE : val=SMAKE(GLOW(value$$))
			CASE $$DOUBLE : val=DMAKE(GHIGH(value$$), GLOW(value$$))
	END SELECT

END SUB

END FUNCTION
'
'
'	###########################
'	#####  GetRawInfo ()  #####
'	###########################
'
FUNCTION  GetRawInfo (grid, message, v0, v1, v2, v3, r0, (r1, r1$, r1[], r1$[]))
	STATIC  designX,  designY,  designWidth,  designHeight
	STATIC  SUBADDR  sub[]
	STATIC  upperMessage
	STATIC  GetRawInfo
'
	$GetRawInfo     =   0  ' kid   0 grid type = GetRawInfo
	$pixelslb       =   1  ' kid   1 grid type = XuiLabel
	$trackslb       =   2  ' kid   2 grid type = XuiLabel
	$XLabellb       =   3  ' kid   3 grid type = XuiLabel
	$ylabellb       =   4  ' kid   4 grid type = XuiLabel
	$datastartlb    =   5  ' kid   5 grid type = XuiLabel
	$totallb        =   6  ' kid   6 grid type = XuiLabel
	$pixelin        =   7  ' kid   7 grid type = XuiTextLine
	$okbtn          =   8  ' kid   8 grid type = XuiPushButton
	$trackin        =   9  ' kid   9 grid type = XuiTextLine
	$xlabelin       =  10  ' kid  10 grid type = XuiTextLine
	$ylabelin       =  11  ' kid  11 grid type = XuiTextLine
	$datastartin    =  12  ' kid  12 grid type = XuiTextLine
	$32bitint       =  13  ' kid  13 grid type = XuiRadioBox
	$32bitflt       =  14  ' kid  14 grid type = XuiRadioBox
	$16bitint       =  15  ' kid  15 grid type = XuiRadioBox
	$autoupdateY    =  16  ' kid  16 grid type = XuiCheckBox
	$32bitunsigned  =  17  ' kid  17 grid type = XuiRadioBox
	$16bitunsigned  =  18  ' kid  18 grid type = XuiRadioBox
	$UpperKid       =  18  ' kid maximum
'
'
	IFZ sub[] THEN GOSUB Initialize
'	XuiReportMessage (grid, message, v0, v1, v2, v3, r0, r1)
	IF XuiProcessMessage (grid, message, @v0, @v1, @v2, @v3, @r0, @r1, GetRawInfo) THEN RETURN
	IF (message <= upperMessage) THEN GOSUB @sub[message]
	RETURN
'
'
' *****  Callback  *****  message = Callback : r1 = original message
'
SUB Callback
	message = r1
	callback = message
	IF (message <= upperMessage) THEN GOSUB @sub[message]
END SUB
'
'
' *****  Create  *****  v0123 = xywh : r0 = window : r1 = parent
'
SUB Create
	IF (v0 <= 0) THEN v0 = 0
	IF (v1 <= 0) THEN v1 = 0
	IF (v2 <= 0) THEN v2 = designWidth
	IF (v3 <= 0) THEN v3 = designHeight
	XuiCreateGrid  (@grid, GetRawInfo, @v0, @v1, @v2, @v3, r0, r1, &GetRawInfo())
	XuiSendMessage ( grid, #SetGridName, 0, 0, 0, 0, 0, @"GetRawInfo")
	XuiSendMessage ( grid, #SetAlign, $$AlignMiddleCenter, 0, -1, -1, 0, 0)
	XuiLabel       (@g, #Create, 0, 4, 164, 24, r0, grid)
	XuiSendMessage ( g, #SetCallback, grid, &GetRawInfo(), -1, -1, $pixelslb, grid)
	XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"pixelslb")
	XuiSendMessage ( g, #SetBorder, $$BorderNone, $$BorderNone, $$BorderNone, 0, 0, 0)
	XuiSendMessage ( g, #SetTexture, $$TextureNone, 0, 0, 0, 0, 0)
	XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"Number of Pixels:")
	XuiLabel       (@g, #Create, 0, 32, 164, 24, r0, grid)
	XuiSendMessage ( g, #SetCallback, grid, &GetRawInfo(), -1, -1, $trackslb, grid)
	XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"trackslb")
	XuiSendMessage ( g, #SetBorder, $$BorderNone, $$BorderNone, $$BorderNone, 0, 0, 0)
	XuiSendMessage ( g, #SetTexture, $$TextureNone, 0, 0, 0, 0, 0)
	XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"Number of Tracks:")
	XuiLabel       (@g, #Create, 0, 60, 164, 24, r0, grid)
	XuiSendMessage ( g, #SetCallback, grid, &GetRawInfo(), -1, -1, $XLabellb, grid)
	XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"XLabellb")
	XuiSendMessage ( g, #SetBorder, $$BorderNone, $$BorderNone, $$BorderNone, 0, 0, 0)
	XuiSendMessage ( g, #SetTexture, $$TextureNone, 0, 0, 0, 0, 0)
	XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"X Label:")
	XuiLabel       (@g, #Create, 0, 88, 164, 24, r0, grid)
	XuiSendMessage ( g, #SetCallback, grid, &GetRawInfo(), -1, -1, $ylabellb, grid)
	XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"ylabellb")
	XuiSendMessage ( g, #SetBorder, $$BorderNone, $$BorderNone, $$BorderNone, 0, 0, 0)
	XuiSendMessage ( g, #SetTexture, $$TextureNone, 0, 0, 0, 0, 0)
	XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"Y Label:")
	XuiLabel       (@g, #Create, 0, 116, 164, 24, r0, grid)
	XuiSendMessage ( g, #SetCallback, grid, &GetRawInfo(), -1, -1, $datastartlb, grid)
	XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"datastartlb")
	XuiSendMessage ( g, #SetBorder, $$BorderNone, $$BorderNone, $$BorderNone, 0, 0, 0)
	XuiSendMessage ( g, #SetTexture, $$TextureNone, 0, 0, 0, 0, 0)
	XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"First byte offset:")
	XuiLabel       (@g, #Create, 4, 144, 328, 24, r0, grid)
	XuiSendMessage ( g, #SetCallback, grid, &GetRawInfo(), -1, -1, $totallb, grid)
	XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"totallb")
	XuiSendMessage ( g, #SetBorder, $$BorderValley, $$BorderValley, $$BorderNone, 0, 0, 0)
	XuiSendMessage ( g, #SetTexture, $$TextureNone, 0, 0, 0, 0, 0)
	XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @" Total Length (x*y*4): 4 bytes")
	XuiTextLine    (@g, #Create, 168, 4, 88, 24, r0, grid)
	XuiSendMessage ( g, #SetCallback, grid, &GetRawInfo(), -1, -1, $pixelin, grid)
	XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"pixelin")
	XuiSendMessage ( g, #SetAlign, $$AlignMiddleCenter, 0, -1, -1, 0, 0)
	XuiSendMessage ( g, #SetBorder, $$BorderLoLine1, $$BorderLoLine1, $$BorderNone, 0, 0, 0)
	XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"1")
	XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 1, @"XuiArea736")
	XuiSendMessage ( g, #SetCursor,#cursorInsert, 0, 0, 0, 0, 0)
	XuiSendMessage ( g, #SetCursor,#cursorInsert, 0, 0, 0, 1, 0)
	XuiPushButton  (@g, #Create, 120, 256, 88, 28, r0, grid)
	XuiSendMessage ( g, #SetCallback, grid, &GetRawInfo(), -1, -1, $okbtn, grid)
	XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"okbtn")
	XuiSendMessage ( g, #SetStyle, 2, 3, 0, 0, 0, 0)
	XuiSendMessage ( g, #SetColorExtra, $$Grey, $$White, $$Black, $$White, 0, 0)
	XuiSendMessage ( g, #SetBorder, $$BorderFlat1, $$BorderFlat1, $$BorderLower1, 0, 0, 0)
	XuiSendMessage ( g, #SetTexture, $$TextureNone, 0, 0, 0, 0, 0)
	XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"Done")
	XuiTextLine    (@g, #Create, 168, 32, 88, 24, r0, grid)
	XuiSendMessage ( g, #SetCallback, grid, &GetRawInfo(), -1, -1, $trackin, grid)
	XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"trackin")
	XuiSendMessage ( g, #SetAlign, $$AlignMiddleCenter, 0, -1, -1, 0, 0)
	XuiSendMessage ( g, #SetBorder, $$BorderLoLine1, $$BorderLoLine1, $$BorderNone, 0, 0, 0)
	XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"1")
	XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 1, @"XuiArea738")
	XuiSendMessage ( g, #SetCursor,#cursorInsert, 0, 0, 0, 0, 0)
	XuiSendMessage ( g, #SetCursor,#cursorInsert, 0, 0, 0, 1, 0)
	XuiTextLine    (@g, #Create, 168, 60, 164, 24, r0, grid)
	XuiSendMessage ( g, #SetCallback, grid, &GetRawInfo(), -1, -1, $xlabelin, grid)
	XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xlabelin")
	XuiSendMessage ( g, #SetAlign, $$AlignMiddleCenter, 0, -1, -1, 0, 0)
	XuiSendMessage ( g, #SetBorder, $$BorderLoLine1, $$BorderLoLine1, $$BorderNone, 0, 0, 0)
	XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"Pixel number")
	XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 1, @"XuiArea740")
	XuiTextLine    (@g, #Create, 168, 88, 164, 24, r0, grid)
	XuiSendMessage ( g, #SetCallback, grid, &GetRawInfo(), -1, -1, $ylabelin, grid)
	XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"ylabelin")
	XuiSendMessage ( g, #SetAlign, $$AlignMiddleCenter, 0, -1, -1, 0, 0)
	XuiSendMessage ( g, #SetBorder, $$BorderLoLine1, $$BorderLoLine1, $$BorderNone, 0, 0, 0)
	XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"Counts")
	XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 1, @"XuiArea742")
	XuiSendMessage ( g, #SetCursor,#cursorInsert, 0, 0, 0, 0, 0)
	XuiSendMessage ( g, #SetCursor,#cursorInsert, 0, 0, 0, 1, 0)
	XuiTextLine    (@g, #Create, 168, 116, 104, 24, r0, grid)
	XuiSendMessage ( g, #SetCallback, grid, &GetRawInfo(), -1, -1, $datastartin, grid)
	XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"datastartin")
	XuiSendMessage ( g, #SetAlign, $$AlignMiddleCenter, 0, -1, -1, 0, 0)
	XuiSendMessage ( g, #SetBorder, $$BorderLoLine1, $$BorderLoLine1, $$BorderNone, 0, 0, 0)
	XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"0")
	XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 1, @"XuiArea744")
	XuiSendMessage ( g, #SetCursor,#cursorInsert, 0, 0, 0, 0, 0)
	XuiSendMessage ( g, #SetCursor,#cursorInsert, 0, 0, 0, 1, 0)
	XuiRadioBox    (@g, #Create, 4, 200, 160, 24, r0, grid)
	XuiSendMessage ( g, #SetCallback, grid, &GetRawInfo(), -1, -1, $32bitint, grid)
	XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"32bitint")
	XuiSendMessage ( g, #SetStyle, 0, 0, 0, 0, 0, 0)
	XuiSendMessage ( g, #SetColorExtra, $$Grey, $$White, $$Black, $$White, 0, 0)
	XuiSendMessage ( g, #SetBorder, $$BorderLoLine1, $$BorderLoLine1, $$BorderNone, 0, 0, 0)
	XuiSendMessage ( g, #SetTexture, $$TextureNone, 0, 0, 0, 0, 0)
	XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"32bit signed")
	XuiRadioBox    (@g, #Create, 84, 172, 160, 24, r0, grid)
	XuiSendMessage ( g, #SetCallback, grid, &GetRawInfo(), -1, -1, $32bitflt, grid)
	XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"32bitflt")
	XuiSendMessage ( g, #SetStyle, 0, 0, 0, 0, 0, 0)
	XuiSendMessage ( g, #SetColorExtra, $$Grey, $$White, $$Black, $$White, 0, 0)
	XuiSendMessage ( g, #SetBorder, $$BorderLoLine1, $$BorderLoLine1, $$BorderNone, 0, 0, 0)
	XuiSendMessage ( g, #SetTexture, $$TextureNone, 0, 0, 0, 0, 0)
	XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"32bit Float")
	XuiRadioBox    (@g, #Create, 168, 200, 160, 24, r0, grid)
	XuiSendMessage ( g, #SetCallback, grid, &GetRawInfo(), -1, -1, $16bitint, grid)
	XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"16bitint")
	XuiSendMessage ( g, #SetStyle, 0, 0, 0, 0, 0, 0)
	XuiSendMessage ( g, #SetColorExtra, $$Grey, $$White, $$Black, $$White, 0, 0)
	XuiSendMessage ( g, #SetBorder, $$BorderLoLine1, $$BorderLoLine1, $$BorderNone, 0, 0, 0)
	XuiSendMessage ( g, #SetTexture, $$TextureNone, 0, 0, 0, 0, 0)
	XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"16bit signed")
	XuiCheckBox    (@g, #Create, 260, 32, 72, 24, r0, grid)
	XuiSendMessage ( g, #SetCallback, grid, &GetRawInfo(), -1, -1, $autoupdateY, grid)
	XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"autoupdateY")
	XuiSendMessage ( g, #SetStyle, 3, 3, 0, 0, 0, 0)
	XuiSendMessage ( g, #SetColorExtra, $$Grey, $$White, $$Black, $$White, 0, 0)
	XuiSendMessage ( g, #SetBorder, $$BorderLoLine1, $$BorderLoLine1, $$BorderRaise1, 0, 0, 0)
	XuiSendMessage ( g, #SetTexture, $$TextureNone, 0, 0, 0, 0, 0)
	XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"Auto")
	XuiRadioBox    (@g, #Create, 4, 228, 160, 24, r0, grid)
	XuiSendMessage ( g, #SetCallback, grid, &GetRawInfo(), -1, -1, $32bitunsigned, grid)
	XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"32bitunsigned")
	XuiSendMessage ( g, #SetStyle, 0, 0, 0, 0, 0, 0)
	XuiSendMessage ( g, #SetColorExtra, $$Grey, $$White, $$Black, $$White, 0, 0)
	XuiSendMessage ( g, #SetAlign, $$AlignMiddleLeft, $$JustifyCenter, -1, -1, 0, 0)
	XuiSendMessage ( g, #SetBorder, $$BorderLoLine1, $$BorderLoLine1, $$BorderNone, 0, 0, 0)
	XuiSendMessage ( g, #SetTexture, $$TextureNone, 0, 0, 0, 0, 0)
	XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"32bit unsigned")
	XuiRadioBox    (@g, #Create, 168, 228, 160, 24, r0, grid)
	XuiSendMessage ( g, #SetCallback, grid, &GetRawInfo(), -1, -1, $16bitunsigned, grid)
	XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"16bitunsigned")
	XuiSendMessage ( g, #SetStyle, 0, 0, 0, 0, 0, 0)
	XuiSendMessage ( g, #SetColorExtra, $$Grey, $$White, $$Black, $$White, 0, 0)
	XuiSendMessage ( g, #SetAlign, $$AlignMiddleLeft, $$JustifyCenter, -1, -1, 0, 0)
	XuiSendMessage ( g, #SetBorder, $$BorderLoLine1, $$BorderLoLine1, $$BorderNone, 0, 0, 0)
	XuiSendMessage ( g, #SetTexture, $$TextureNone, 0, 0, 0, 0, 0)
	XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"16bit unsigned")
	GOSUB Resize
END SUB
'
'
' *****  CreateWindow  *****  v0123 = xywh : r0 = windowType : r1$ = display$
'
SUB CreateWindow
	IF (v0 == 0) THEN v0 = designX
	IF (v1 == 0) THEN v1 = designY
	IF (v2 <= 0) THEN v2 = designWidth
	IF (v3 <= 0) THEN v3 = designHeight
	XuiWindow (@window, #WindowCreate, v0, v1, v2, v3, r0, @r1$)
	v0 = 0 : v1 = 0 : r0 = window : ATTACH r1$ TO display$
	GOSUB Create
	r1 = 0 : ATTACH display$ TO r1$
	XuiWindow (window, #WindowRegister, grid, -1, v2, v3, @r0, @"GetRawInfo")
END SUB
'
'
' *****  GetSmallestSize  *****  see "Anatomy of Grid Functions"
'
SUB GetSmallestSize
END SUB
'
'
' *****  Redrawn  *****  see "Anatomy of Grid Functions"
'
SUB Redrawn
	XuiCallback (grid, #Redrawn, v0, v1, v2, v3, r0, r1)
END SUB
'
'
' *****  Resize  *****  see "Anatomy of Grid Functions"
'
SUB Resize
	XuiSendMessage ( g, #SetCursor,#cursorInsert, 0, 0, 0, 0, 0)
	XuiSendMessage ( g, #SetCursor,#cursorInsert, 0, 0, 0, 1, 0)
END SUB
'
'
' *****  Selection  *****  see "Anatomy of Grid Functions"
'
SUB Selection
END SUB
'
'
' *****  Initialize  *****  see "Anatomy of Grid Functions"
'
SUB Initialize
	XuiGetDefaultMessageFuncArray (@func[])
	XgrMessageNameToNumber (@"LastMessage", @upperMessage)
'
	func[#Callback]           = &XuiCallback ()               ' disable to handle Callback messages internally
' func[#GetSmallestSize]    = 0                             ' enable to add internal GetSmallestSize routine
' func[#Resize]             = 0                             ' enable to add internal Resize routine
'
	DIM sub[upperMessage]
'	sub[#Callback]            = SUBADDRESS (Callback)         ' enable to handle Callback messages internally
	sub[#Create]              = SUBADDRESS (Create)           ' must be subroutine in this function
	sub[#CreateWindow]        = SUBADDRESS (CreateWindow)     ' must be subroutine in this function
'	sub[#GetSmallestSize]     = SUBADDRESS (GetSmallestSize)  ' enable to add internal GetSmallestSize routine
	sub[#Redrawn]             = SUBADDRESS (Redrawn)          ' generate #Redrawn callback if appropriate
'	sub[#Resize]              = SUBADDRESS (Resize)           ' enable to add internal Resize routine
	sub[#Selection]           = SUBADDRESS (Selection)        ' routes Selection callbacks to subroutine
'
'	IF sub[0] THEN PRINT "GetRawInfo() : Initialize : error ::: (undefined message)"
'	IF func[0] THEN PRINT "GetRawInfo() : Initialize : error ::: (undefined message)"
	XuiRegisterGridType (@GetRawInfo, "GetRawInfo", &GetRawInfo(), @func[], @sub[])
'
' Don't remove the following 4 lines, or WindowFromFunction/WindowToFunction will not work
'
	designX = 512
	designY = 287
	designWidth = 336
	designHeight = 288
'
	gridType = GetRawInfo
	XuiSetGridTypeProperty (gridType, @"x",                designX)
	XuiSetGridTypeProperty (gridType, @"y",                designY)
	XuiSetGridTypeProperty (gridType, @"width",            designWidth)
	XuiSetGridTypeProperty (gridType, @"height",           designHeight)
	XuiSetGridTypeProperty (gridType, @"maxWidth",         designWidth)
	XuiSetGridTypeProperty (gridType, @"maxHeight",        designHeight)
	XuiSetGridTypeProperty (gridType, @"minWidth",         designWidth)
	XuiSetGridTypeProperty (gridType, @"minHeight",        designHeight)
	XuiSetGridTypeProperty (gridType, @"can",              $$Focus OR $$Respond OR $$Callback OR $$TextSelection)
	XuiSetGridTypeProperty (gridType, @"focusKid",         $pixelin)
	XuiSetGridTypeProperty (gridType, @"inputTextString",  $pixelin)
	IFZ message THEN RETURN
END SUB
END FUNCTION
'
'
' ###############################
' #####  GetRawInfoCode ()  #####
' ###############################
'
'
FUNCTION  GetRawInfoCode (grid, message, v0, v1, v2, v3, kid, r1)
	STATIC fileindex, autoupy
'	SHARED Image ImageFormat[]
	STATIC SINGLE len,pixels,tracks
'
	$GetRawInfo     =   0  ' kid   0 grid type = GetRawInfo
	$pixelslb       =   1  ' kid   1 grid type = XuiLabel
	$trackslb       =   2  ' kid   2 grid type = XuiLabel
	$XLabellb       =   3  ' kid   3 grid type = XuiLabel
	$ylabellb       =   4  ' kid   4 grid type = XuiLabel
	$datastartlb    =   5  ' kid   5 grid type = XuiLabel
	$totallb        =   6  ' kid   6 grid type = XuiLabel
	$pixelin        =   7  ' kid   7 grid type = XuiTextLine
	$okbtn          =   8  ' kid   8 grid type = XuiPushButton
	$trackin        =   9  ' kid   9 grid type = XuiTextLine
	$xlabelin       =  10  ' kid  10 grid type = XuiTextLine
	$ylabelin       =  11  ' kid  11 grid type = XuiTextLine
	$datastartin    =  12  ' kid  12 grid type = XuiTextLine
	$32bitint       =  13  ' kid  13 grid type = XuiRadioBox
	$32bitflt       =  14  ' kid  14 grid type = XuiRadioBox
	$16bitint       =  15  ' kid  15 grid type = XuiRadioBox
	$autoupdateY    =  16
	$32bitunsigned  =  17
	$16bitunsigned  =  18
	$UpperKid       =  18  ' kid maximum
'
'	XuiReportMessage (grid, message, v0, v1, v2, v3, kid, r1)
	IF (message == #Callback) THEN message = r1
'	XgrMessageNumberToName  (message,@message$): PRINT grid, message$, v0, v1, v2, v3, kid, r1

'
	SELECT CASE message
		CASE #UpdateLabel	: GOSUB GetTotal
		CASE #Selection		: GOSUB Selection
		CASE #Destroyed		: IF #FirstLoad=0 THEN Quit() ELSE #DatInfoState=0: XuiSendMessage (grid, #HideWindow, 0, 0, 0, 0, 0, 0)
		CASE #CloseWindow	: IF #FirstLoad=0 THEN Quit() ELSE #DatInfoState=0: XuiSendMessage (grid, #HideWindow, 0, 0, 0, 0, 0, 0)
		CASE #TextEvent		: key=v2{BITFIELD (8,0)}
												removeTab (#GetRawInfo,$pixelin): removeTab (#GetRawInfo,$trackin)
												removeTab (#GetRawInfo,$xlabelin): removeTab (#GetRawInfo,$ylabelin)
												removeTab (#GetRawInfo,$datastartin)
												SELECT CASE kid
														CASE	$pixelin			: IF key=9 THEN SetFocusOnKid (grid,$trackin)
														CASE	$trackin			: IF key=9 THEN SetFocusOnKid (grid,$xlabelin)
														CASE	$xlabelin			: IF key=9 THEN SetFocusOnKid (grid,$ylabelin)
														CASE	$ylabelin			: IF key=9 THEN SetFocusOnKid (grid,$datastartin)
														CASE	$datastartin	: IF key=9 THEN SetFocusOnKid (grid,$okbtn)
														CASE	$okbtn				: IF key=9 THEN SetFocusOnKid (grid,$pixelin)
												END SELECT
	END SELECT
	RETURN
'
'
' *****  Selection  *****
'
SUB Selection
	SELECT CASE kid
			CASE $okbtn					 :#DatInfoState=1:fileindex=0 :LoadFile (#datfile$,#ImageSet)
			CASE $32bitflt			 :#RawInfoDataType=0: GOSUB GetTotal
			CASE $32bitint			 :#RawInfoDataType=1: GOSUB GetTotal
			CASE $16bitint			 :#RawInfoDataType=2: GOSUB GetTotal
			CASE $32bitunsigned  :#RawInfoDataType=3: GOSUB GetTotal
			CASE $16bitunsigned  :#RawInfoDataType=4: GOSUB GetTotal
			CASE $autoupdateY		 :IF autoupy=1 THEN autoupy=0 ELSE autoupy=1: GOSUB GetTotal
	END SELECT
END SUB


'#############
SUB GetTotal
'#############

	XuiSendMessage (#GetRawInfo,#GetTextString,0,0,0,0,$pixelin,@pix$)
	XuiSendMessage (#GetRawInfo,#GetTextString,0,0,0,0,$trackin,@trk$)
	XstStringToNumber (pix$,0,0,type,@pixels): IF pixels<2 THEN pixels=2
	XstStringToNumber (trk$,0,0,type,@tracks): IF tracks<1 THEN tracks=1
	IF ((#RawInfoDataType=2) OR (#RawInfoDataType=4)) THEN size=2 ELSE size=4

	IF autoupy=1 THEN
				IF fileindex<1 THEN
						OpenFilefn (#datfile$,@fileindex)
						len=LOF(fileindex)
						CloseFilefn (fileindex)
				END IF

				tracks=FIX((len/size)/pixels)
				XuiSendMessage (#GetRawInfo,#SetTextString,0,0,0,0,$trackin,STRING$(tracks))
				XuiSendMessage (#GetRawInfo,#Redraw,0,0,0,0,$trackin,0)
	END IF

	len$=" Total Length (x*y*"+STRING$(size)+"): "+STRING$(tracks*pixels*size)+" bytes"
	XuiSendMessage (#GetRawInfo,#SetTextString,0,0,0,0,$totallb,len$)
	XuiSendMessage (#GetRawInfo,#Redraw,0,0,0,0,$totallb,0)

END SUB


END FUNCTION
'
'
'	############################
'	#####  ModScaleMax ()  #####
'	############################

FUNCTION  ModScaleMax (grid, message, v0, v1, v2, v3, r0, (r1, r1$, r1[], r1$[]))
	STATIC  designX,  designY,  designWidth,  designHeight
	STATIC  SUBADDR  sub[]
	STATIC  upperMessage
	STATIC  ModScaleMax
'
	$ModScaleMax  =   0  ' kid   0 grid type = ModScaleMax
	$Upbt         =   1  ' kid   1 grid type = XuiPushButton
	$Dnbt         =   2  ' kid   2 grid type = XuiPushButton
	$UpperKid     =   2  ' kid maximum
'
'
	IFZ sub[] THEN GOSUB Initialize
'	XuiReportMessage (grid, message, v0, v1, v2, v3, r0, r1)
	IF XuiProcessMessage (grid, message, @v0, @v1, @v2, @v3, @r0, @r1, ModScaleMax) THEN RETURN
	IF (message <= upperMessage) THEN GOSUB @sub[message]
	RETURN
'
'
' *****  Callback  *****  message = Callback : r1 = original message
'
SUB Callback
	message = r1
	callback = message
	IF (message <= upperMessage) THEN GOSUB @sub[message]
END SUB
'
'
' *****  Create  *****  v0123 = xywh : r0 = window : r1 = parent
'
SUB Create
	IF (v0 <= 0) THEN v0 = 0
	IF (v1 <= 0) THEN v1 = 0
	IF (v2 <= 0) THEN v2 = designWidth
	IF (v3 <= 0) THEN v3 = designHeight
	XuiCreateGrid  (@grid, ModScaleMax, @v0, @v1, @v2, @v3, r0, r1, &ModScaleMax())
	XuiSendMessage ( grid, #SetGridName, 0, 0, 0, 0, 0, @"ModScaleMax")
	XuiPushButton  (@g, #Create, 19, 1, 16, 16, r0, grid)
	XuiSendMessage ( g, #SetCallback, grid, &ModScaleMax(), -1, -1, $Upbt, grid)
	XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"Upbt")
	XuiSendMessage ( g, #SetStyle, 3, 3, 0, 0, 0, 0)
	XuiSendMessage ( g, #SetColorExtra, $$Grey, $$White, $$Black, $$White, 0, 0)
	XuiSendMessage ( g, #SetBorder, $$BorderLoLine1, $$BorderLoLine1, $$BorderLower1, 0, 0, 0)
	XuiSendMessage ( g, #SetTexture, $$TextureNone, 0, 0, 0, 0, 0)
	XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @">")
	XuiSendMessage (g, #SetCursor,#cursorHand, 0, 0, 0, 0, 0)
	XuiPushButton  (@g, #Create, 0, 1, 16, 16, r0, grid)
	XuiSendMessage ( g, #SetCallback, grid, &ModScaleMax(), -1, -1, $Dnbt, grid)
	XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"Dnbt")
	XuiSendMessage ( g, #SetStyle, 3, 3, 0, 0, 0, 0)
	XuiSendMessage ( g, #SetColorExtra, $$Grey, $$White, $$Black, $$White, 0, 0)
	XuiSendMessage ( g, #SetBorder, $$BorderLoLine1, $$BorderLoLine1, $$BorderLower1, 0, 0, 0)
	XuiSendMessage ( g, #SetTexture, $$TextureNone, 0, 0, 0, 0, 0)
	XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"<")
	XuiSendMessage (g, #SetCursor,#cursorHand, 0, 0, 0, 0, 0)
	GOSUB Resize
END SUB
'
'
' *****  CreateWindow  *****  v0123 = xywh : r0 = windowType : r1$ = display$
'
SUB CreateWindow
	IF (v0 == 0) THEN v0 = designX
	IF (v1 == 0) THEN v1 = designY
	IF (v2 <= 0) THEN v2 = designWidth
	IF (v3 <= 0) THEN v3 = designHeight
	XuiWindow (@window, #WindowCreate, v0, v1, v2, v3, r0, @r1$)
	v0 = 0 : v1 = 0 : r0 = window : ATTACH r1$ TO display$
	GOSUB Create
	r1 = 0 : ATTACH display$ TO r1$
	XuiWindow (window, #WindowRegister, grid, -1, v2, v3, @r0, @"ModScaleMax")
END SUB
'
'
' *****  GetSmallestSize  *****  see "Anatomy of Grid Functions"
'
SUB GetSmallestSize
END SUB
'
'
' *****  Redrawn  *****  see "Anatomy of Grid Functions"
'
SUB Redrawn
	XuiCallback (grid, #Redrawn, v0, v1, v2, v3, r0, r1)
END SUB
'
'
' *****  Resize  *****  see "Anatomy of Grid Functions"
'
SUB Resize

	'	XuiPositionGrid (#ModScaleMaxG, @v0, @v1, @v2, @v3)

END SUB
'
'
' *****  Selection  *****  see "Anatomy of Grid Functions"
'
SUB Selection
END SUB
'
'
' *****  Initialize  *****  see "Anatomy of Grid Functions"
'
SUB Initialize
	XuiGetDefaultMessageFuncArray (@func[])
	XgrMessageNameToNumber (@"LastMessage", @upperMessage)
'
  func[#Resize]             = &XuiResizeNot()
	func[#Callback]           = &XuiCallback ()               ' disable to handle Callback messages internally
' func[#GetSmallestSize]    = 0                             ' enable to add internal GetSmallestSize routine
	func[#Resize]             = 0                             ' enable to add internal Resize routine
'
	DIM sub[upperMessage]
'	sub[#Callback]            = SUBADDRESS (Callback)         ' enable to handle Callback messages internally
	sub[#Create]              = SUBADDRESS (Create)           ' must be subroutine in this function
	sub[#CreateWindow]        = SUBADDRESS (CreateWindow)     ' must be subroutine in this function
'	sub[#GetSmallestSize]     = SUBADDRESS (GetSmallestSize)  ' enable to add internal GetSmallestSize routine
	sub[#Redrawn]             = SUBADDRESS (Redrawn)          ' generate #Redrawn callback if appropriate
	sub[#Resize]              = SUBADDRESS (Resize)           ' enable to add internal Resize routine
	sub[#Selection]           = SUBADDRESS (Selection)        ' routes Selection callbacks to subroutine
'
'	IF sub[0] THEN PRINT "ModScaleMax() : Initialize : error ::: (undefined message)"
'	IF func[0] THEN PRINT "ModScaleMax() : Initialize : error ::: (undefined message)"
	XuiRegisterGridType (@ModScaleMax, "ModScaleMax", &ModScaleMax(), @func[], @sub[])
'
' Don't remove the following 4 lines, or WindowFromFunction/WindowToFunction will not work
'
	designX = 602
	designY = 511
	designWidth = 37
	designHeight = 18
'
	gridType = ModScaleMax
	XuiSetGridTypeProperty (gridType, @"x",                designX)
	XuiSetGridTypeProperty (gridType, @"y",                designY)
	XuiSetGridTypeProperty (gridType, @"width",            designWidth)
	XuiSetGridTypeProperty (gridType, @"height",           designHeight)
	XuiSetGridTypeProperty (gridType, @"maxWidth",         designWidth)
	XuiSetGridTypeProperty (gridType, @"maxHeight",        designHeight)
	XuiSetGridTypeProperty (gridType, @"minWidth",         designWidth)
	XuiSetGridTypeProperty (gridType, @"minHeight",        designHeight)
	XuiSetGridTypeProperty (gridType, @"can",              $$Focus OR $$Respond OR $$Callback)
	XuiSetGridTypeProperty (gridType, @"focusKid",         $Upbt)
	IFZ message THEN RETURN
END SUB
END FUNCTION
'
'
' ################################
' #####  ModScaleMaxCode ()  #####
' ################################
'
FUNCTION  ModScaleMaxCode (grid, message, v0, v1, v2, v3, kid, r1)
'
	$ModScaleMax  =   0  ' kid   0 grid type = ModScaleMax
	$Upbt         =   1  ' kid   1 grid type = XuiPushButton
	$Dnbt         =   2  ' kid   2 grid type = XuiPushButton
	$UpperKid     =   2  ' kid maximum
'
'	XuiReportMessage (grid, message, v0, v1, v2, v3, kid, r1)
	IF (message == #Callback) THEN message = r1
'
	SELECT CASE message
		CASE #Redrawn			: RedrawIcon (kid+40)
		CASE #Selection		: GOSUB Selection   	' most common callback message
	END SELECT
	RETURN
'
'
' *****  Selection  *****
'
SUB Selection
	SELECT CASE kid
		CASE $ModScaleMax  :
		CASE $Upbt         :increaseMaxScaleRange ()
		CASE $Dnbt         :decreaseMaxScaleRange ()
	END SELECT
END SUB
END FUNCTION
'
'
'	############################
'	#####  ModScaleMin ()  #####
'	############################

FUNCTION  ModScaleMin (grid, message, v0, v1, v2, v3, r0, (r1, r1$, r1[], r1$[]))
	STATIC  designX,  designY,  designWidth,  designHeight
	STATIC  SUBADDR  sub[]
	STATIC  upperMessage
	STATIC  ModScaleMin
'
	$ModScaleMin  =   0  ' kid   0 grid type = ModScaleMin
	$Upbt         =   1  ' kid   1 grid type = XuiPushButton
	$Dnbt         =   2  ' kid   2 grid type = XuiPushButton
	$UpperKid     =   2  ' kid maximum
'
'
	IFZ sub[] THEN GOSUB Initialize
'	XuiReportMessage (grid, message, v0, v1, v2, v3, r0, r1)
	IF XuiProcessMessage (grid, message, @v0, @v1, @v2, @v3, @r0, @r1, ModScaleMin) THEN RETURN
	IF (message <= upperMessage) THEN GOSUB @sub[message]
	RETURN
'
'
' *****  Callback  *****  message = Callback : r1 = original message
'
SUB Callback
	message = r1
	callback = message
	IF (message <= upperMessage) THEN GOSUB @sub[message]
END SUB
'
'
' *****  Create  *****  v0123 = xywh : r0 = window : r1 = parent
'
SUB Create
	IF (v0 <= 0) THEN v0 = 0
	IF (v1 <= 0) THEN v1 = 0
	IF (v2 <= 0) THEN v2 = designWidth
	IF (v3 <= 0) THEN v3 = designHeight
	XuiCreateGrid  (@grid, ModScaleMin, @v0, @v1, @v2, @v3, r0, r1, &ModScaleMin())
	XuiSendMessage ( grid, #SetGridName, 0, 0, 0, 0, 0, @"ModScaleMin")
	XuiPushButton  (@g, #Create, 19, 1, 16, 16, r0, grid)
	XuiSendMessage ( g, #SetCallback, grid, &ModScaleMin(), -1, -1, $Upbt, grid)
	XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"Upbt")
	XuiSendMessage ( g, #SetStyle, 3, 3, 0, 0, 0, 0)
	XuiSendMessage ( g, #SetColorExtra, $$Grey, $$White, $$Black, $$White, 0, 0)
	XuiSendMessage ( g, #SetAlign, $$AlignMiddleCenter, $$JustifyCenter, -1, -1, 0, 0)
	XuiSendMessage ( g, #SetBorder, $$BorderLoLine1, $$BorderLoLine1, $$BorderLower1, 0, 0, 0)
	XuiSendMessage ( g, #SetTexture, $$TextureNone, 0, 0, 0, 0, 0)
	XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @">")
	XuiSendMessage (g, #SetCursor,#cursorHand, 0, 0, 0, 0, 0)
	XuiPushButton  (@g, #Create, 0, 1, 16, 16, r0, grid)
	XuiSendMessage ( g, #SetCallback, grid, &ModScaleMin(), -1, -1, $Dnbt, grid)
	XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"Dnbt")
	XuiSendMessage ( g, #SetStyle, 3, 3, 0, 0, 0, 0)
	XuiSendMessage ( g, #SetColorExtra, $$Grey, $$White, $$Black, $$White, 0, 0)
	XuiSendMessage ( g, #SetAlign, $$AlignMiddleCenter, $$JustifyCenter, -1, -1, 0, 0)
	XuiSendMessage ( g, #SetBorder, $$BorderLoLine1, $$BorderLoLine1, $$BorderLower1, 0, 0, 0)
	XuiSendMessage ( g, #SetTexture, $$TextureNone, 0, 0, 0, 0, 0)
	XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"<")
	XuiSendMessage (g, #SetCursor,#cursorHand, 0, 0, 0, 0, 0)

	GOSUB Resize
END SUB
'
'
' *****  CreateWindow  *****  v0123 = xywh : r0 = windowType : r1$ = display$
'
SUB CreateWindow
	IF (v0 == 0) THEN v0 = designX
	IF (v1 == 0) THEN v1 = designY
	IF (v2 <= 0) THEN v2 = designWidth
	IF (v3 <= 0) THEN v3 = designHeight
	XuiWindow (@window, #WindowCreate, v0, v1, v2, v3, r0, @r1$)
	v0 = 0 : v1 = 0 : r0 = window : ATTACH r1$ TO display$
	GOSUB Create
	r1 = 0 : ATTACH display$ TO r1$
	XuiWindow (window, #WindowRegister, grid, -1, v2, v3, @r0, @"ModScaleMin")
END SUB
'
'
' *****  GetSmallestSize  *****  see "Anatomy of Grid Functions"
'
SUB GetSmallestSize
END SUB
'
'
' *****  Redrawn  *****  see "Anatomy of Grid Functions"
'
SUB Redrawn
	XuiCallback (grid, #Redrawn, v0, v1, v2, v3, r0, r1)
END SUB
'
'
' *****  Resize  *****  see "Anatomy of Grid Functions"
'
SUB Resize

	'	XuiPositionGrid (#ModScaleMinG, @v0, @v1, @v2, @v3)

END SUB
'
'
' *****  Selection  *****  see "Anatomy of Grid Functions"
'
SUB Selection
END SUB
'
'
' *****  Initialize  *****  see "Anatomy of Grid Functions"
'
SUB Initialize
	XuiGetDefaultMessageFuncArray (@func[])
	XgrMessageNameToNumber (@"LastMessage", @upperMessage)
'
  func[#Resize]             = &XuiResizeNot()
	func[#Callback]           = &XuiCallback ()               ' disable to handle Callback messages internally
' func[#GetSmallestSize]    = 0                             ' enable to add internal GetSmallestSize routine
	func[#Resize]             = 0                             ' enable to add internal Resize routine
'
	DIM sub[upperMessage]
'	sub[#Callback]            = SUBADDRESS (Callback)         ' enable to handle Callback messages internally
	sub[#Create]              = SUBADDRESS (Create)           ' must be subroutine in this function
	sub[#CreateWindow]        = SUBADDRESS (CreateWindow)     ' must be subroutine in this function
'	sub[#GetSmallestSize]     = SUBADDRESS (GetSmallestSize)  ' enable to add internal GetSmallestSize routine
	sub[#Redrawn]             = SUBADDRESS (Redrawn)          ' generate #Redrawn callback if appropriate
	sub[#Resize]              = SUBADDRESS (Resize)           ' enable to add internal Resize routine
	sub[#Selection]           = SUBADDRESS (Selection)        ' routes Selection callbacks to subroutine
'
'	IF sub[0] THEN PRINT "ModScaleMin() : Initialize : error ::: (undefined message)"
'	IF func[0] THEN PRINT "ModScaleMin() : Initialize : error ::: (undefined message)"
	XuiRegisterGridType (@ModScaleMin, "ModScaleMin", &ModScaleMin(), @func[], @sub[])
'
' Don't remove the following 4 lines, or WindowFromFunction/WindowToFunction will not work
'
	designX = 732
	designY = 396
	designWidth = 37
	designHeight = 18
'
	gridType = ModScaleMin
	XuiSetGridTypeProperty (gridType, @"x",                designX)
	XuiSetGridTypeProperty (gridType, @"y",                designY)
	XuiSetGridTypeProperty (gridType, @"width",            designWidth)
	XuiSetGridTypeProperty (gridType, @"height",           designHeight)
	XuiSetGridTypeProperty (gridType, @"maxWidth",         designWidth)
	XuiSetGridTypeProperty (gridType, @"maxHeight",        designHeight)
	XuiSetGridTypeProperty (gridType, @"minWidth",         designWidth)
	XuiSetGridTypeProperty (gridType, @"minHeight",        designHeight)
	XuiSetGridTypeProperty (gridType, @"can",              $$Focus OR $$Respond OR $$Callback)
	XuiSetGridTypeProperty (gridType, @"focusKid",         $Upbt)
	IFZ message THEN RETURN
END SUB
END FUNCTION
'
'
' ################################
' #####  ModScaleMinCode ()  #####
' ################################
'
FUNCTION  ModScaleMinCode (grid, message, v0, v1, v2, v3, kid, r1)
'
	$ModScaleMin  =   0  ' kid   0 grid type = ModScaleMax
	$Upbt         =   1  ' kid   1 grid type = XuiPushButton
	$Dnbt         =   2  ' kid   2 grid type = XuiPushButton
	$UpperKid     =   2  ' kid maximum
'
'	XuiReportMessage (grid, message, v0, v1, v2, v3, kid, r1)
	IF (message == #Callback) THEN message = r1
'
	SELECT CASE message
		CASE #Redrawn			: RedrawIcon (kid+43)
		CASE #Selection		: GOSUB Selection   	' most common callback message
	END SELECT
	RETURN
'
'
' *****  Selection  *****
'
SUB Selection
	SELECT CASE kid
		CASE $ModScaleMin  :
		CASE $Upbt         : increaseMinScaleRange ()
		CASE $Dnbt         : decreaseMinScaleRange ()
	END SELECT
END SUB
END FUNCTION
'
'
'	##########################
'	#####  AddTraceW ()  #####
'	##########################
'
FUNCTION  AddTraceW (grid, message, v0, v1, v2, v3, r0, (r1, r1$, r1[], r1$[]))
	STATIC  designX,  designY,  designWidth,  designHeight
	STATIC  SUBADDR  sub[]
	STATIC  upperMessage
	STATIC  AddTraceW
'
	$AddTraceW   =   0  ' kid   0 grid type = AddTraceW
	$XuiColor    =   1  ' kid   1 grid type = XuiColor
	$Addbt       =   2  ' kid   2 grid type = XuiPushButton
	$Removebt    =   3  ' kid   3 grid type = XuiPushButton
	$XuiDropBox  =   4  ' kid   4 grid type = XuiDropBox
	$XuiLabe     =   5  ' kid   5 grid type = XuiLabel
	$syncPx      =   6  ' kid   6 grid type = XuiCheckBox
	$syncMM      =   7  ' kid   7 grid type = XuiCheckBox
	$syncTk      =   8  ' kid   8 grid type = XuiCheckBox
	$labelink    =   9  ' kid   9 grid type = XuiLabel
	$UpperKid    =   9  ' kid maximum
'
'
	IFZ sub[] THEN GOSUB Initialize
'	XuiReportMessage (grid, message, v0, v1, v2, v3, r0, r1)
	IF XuiProcessMessage (grid, message, @v0, @v1, @v2, @v3, @r0, @r1, AddTraceW) THEN RETURN
	IF (message <= upperMessage) THEN GOSUB @sub[message]
	RETURN
'
'
' *****  Callback  *****  message = Callback : r1 = original message
'
SUB Callback
	message = r1
	callback = message
	IF (message <= upperMessage) THEN GOSUB @sub[message]
END SUB
'
'
' *****  Create  *****  v0123 = xywh : r0 = window : r1 = parent
'
SUB Create
	IF (v0 <= 0) THEN v0 = 0
	IF (v1 <= 0) THEN v1 = 0
	IF (v2 <= 0) THEN v2 = designWidth
	IF (v3 <= 0) THEN v3 = designHeight
	XuiCreateGrid  (@grid, AddTraceW, @v0, @v1, @v2, @v3, r0, r1, &AddTraceW())
	XuiSendMessage ( grid, #SetGridName, 0, 0, 0, 0, 0, @"AddTraceW")
	XuiColor       (@g, #Create, 0, 0, 200, 80, r0, grid)
	XuiSendMessage ( g, #SetCallback, grid, &AddTraceW(), -1, -1, $XuiColor, grid)
	XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"XuiColor")
	XuiPushButton  (@g, #Create, 0, 112, 80, 24, r0, grid)
	XuiSendMessage ( g, #SetCallback, grid, &AddTraceW(), -1, -1, $Addbt, grid)
	XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"Addbt")
	XuiSendMessage ( g, #SetStyle, 3, 3, 0, 0, 0, 0)
	XuiSendMessage ( g, #SetColorExtra, $$Grey, $$White, $$Black, $$White, 0, 0)
	XuiSendMessage ( g, #SetBorder, $$BorderLoLine1, $$BorderLoLine1, $$BorderLower1, 0, 0, 0)
	XuiSendMessage ( g, #SetTexture, $$TextureNone, 0, 0, 0, 0, 0)
	XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"Add")
	XuiPushButton  (@g, #Create, 120, 112, 80, 24, r0, grid)
	XuiSendMessage ( g, #SetCallback, grid, &AddTraceW(), -1, -1, $Removebt, grid)
	XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"Removebt")
	XuiSendMessage ( g, #SetStyle, 3, 3, 0, 0, 0, 0)
	XuiSendMessage ( g, #SetColorExtra, $$Grey, $$White, $$Black, $$White, 0, 0)
	XuiSendMessage ( g, #SetBorder, $$BorderLoLine1, $$BorderLoLine1, $$BorderLower1, 0, 0, 0)
	XuiSendMessage ( g, #SetTexture, $$TextureNone, 0, 0, 0, 0, 0)
	XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"Remove")
	XuiDropBox     (@g, #Create, 0, 84, 200, 24, r0, grid)
	XuiSendMessage ( g, #SetCallback, grid, &AddTraceW(), -1, -1, $XuiDropBox, grid)
	XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"XuiDropBox")
	XuiSendMessage ( g, #SetStyle, 0, 0, 0, 0, 0, 0)
	XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"#1")
	DIM text$[6]
	text$[0] = "#1"
	text$[1] = "#2"
	text$[2] = "#3"
	text$[3] = "#4"
	text$[4] = "#5"
	text$[5] = "#6"
	text$[6] = "#7"
	XuiSendMessage ( g, #SetTextArray, 0, 0, 0, 0, 0, @text$[])
	XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 1, @"TextLine")
	XuiSendMessage ( g, #SetBorder, $$BorderLoLine1, $$BorderLoLine1, $$BorderRidge, 0, 1, 0)
	XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 1, @"#1")
	XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 2, @"PressButton")
	XuiSendMessage ( g, #SetBorder, $$BorderLoLine1, $$BorderLoLine1, $$BorderRaise1, 0, 2, 0)
	XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 3, @"XuiPullDown749")
	XuiSendMessage ( g, #SetColorExtra, $$Grey, $$White, $$Black, $$White, 3, 0)
	XuiSendMessage ( g, #SetBorder, $$BorderLoLine1, $$BorderLoLine1, $$BorderNone, 0, 3, 0)
	DIM text$[6]
	text$[0] = "#1"
	text$[1] = "#2"
	text$[2] = "#3"
	text$[3] = "#4"
	text$[4] = "#5"
	text$[5] = "#6"
	text$[6] = "#7"
	XuiSendMessage ( g, #SetTextArray, 0, 0, 0, 0, 3, @text$[])
	XuiLabel       (@g, #Create, 84, 112, 32, 24, r0, grid)
	XuiSendMessage ( g, #SetCallback, grid, &AddTraceW(), -1, -1, $XuiLabe, grid)
	XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"XuiLabe")
	XuiSendMessage ( g, #SetBorder, $$BorderLoLine1, $$BorderLoLine1, $$BorderNone, 0, 0, 0)
	XuiCheckBox    (@g, #Create, 28, 196, 144, 24, r0, grid)
	XuiSendMessage ( g, #SetCallback, grid, &AddTraceW(), -1, -1, $syncPx, grid)
	XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"syncPx")
	XuiSendMessage ( g, #SetStyle, 3, 3, 0, 0, 0, 0)
	XuiSendMessage ( g, #SetColorExtra, $$Grey, $$White, $$Black, $$White, 0, 0)
	XuiSendMessage ( g, #SetAlign, $$AlignMiddleCenter, 0, -1, -1, 0, 0)
	XuiSendMessage ( g, #SetBorder, $$BorderLoLine1, $$BorderLoLine1, $$BorderRaise1, 0, 0, 0)
	XuiSendMessage ( g, #SetTexture, $$TextureNone, 0, 0, 0, 0, 0)
	XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"Sync X Axis")
	XuiCheckBox    (@g, #Create, 28, 168, 144, 24, r0, grid)
	XuiSendMessage ( g, #SetCallback, grid, &AddTraceW(), -1, -1, $syncMM, grid)
	XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"syncMM")
	XuiSendMessage ( g, #SetStyle, 3, 3, 0, 0, 0, 0)
	XuiSendMessage ( g, #SetColorExtra, $$Grey, $$White, $$Black, $$White, 0, 0)
	XuiSendMessage ( g, #SetAlign, $$AlignMiddleCenter, 0, -1, -1, 0, 0)
	XuiSendMessage ( g, #SetBorder, $$BorderLoLine1, $$BorderLoLine1, $$BorderRaise1, 0, 0, 0)
	XuiSendMessage ( g, #SetTexture, $$TextureNone, 0, 0, 0, 0, 0)
	XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"Sync Y Axis")
	XuiCheckBox    (@g, #Create, 28, 140, 144, 24, r0, grid)
	XuiSendMessage ( g, #SetCallback, grid, &AddTraceW(), -1, -1, $syncTk, grid)
	XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"syncTk")
	XuiSendMessage ( g, #SetStyle, 3, 3, 0, 0, 0, 0)
	XuiSendMessage ( g, #SetColorExtra, $$Grey, $$White, $$Black, $$White, 0, 0)
	XuiSendMessage ( g, #SetAlign, $$AlignMiddleCenter, 0, -1, -1, 0, 0)
	XuiSendMessage ( g, #SetBorder, $$BorderLoLine1, $$BorderLoLine1, $$BorderRaise1, 0, 0, 0)
	XuiSendMessage ( g, #SetTexture, $$TextureNone, 0, 0, 0, 0, 0)
	XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"Sync Tracks")
	XuiLabel       (@g, #Create, 85, 113, 30, 22, r0, grid)
	XuiSendMessage ( g, #SetCallback, grid, &AddTraceW(), -1, -1, $labelink, grid)
	XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"labelink")
	XuiSendMessage ( g, #SetBorder, $$BorderLoLine1, $$BorderLoLine1, $$BorderNone, 0, 0, 0)
	GOSUB Resize
END SUB
'
'
' *****  CreateWindow  *****  v0123 = xywh : r0 = windowType : r1$ = display$
'
SUB CreateWindow
	IF (v0 == 0) THEN v0 = designX
	IF (v1 == 0) THEN v1 = designY
	IF (v2 <= 0) THEN v2 = designWidth
	IF (v3 <= 0) THEN v3 = designHeight
	XuiWindow (@window, #WindowCreate, v0, v1, v2, v3, r0, @r1$)
	v0 = 0 : v1 = 0 : r0 = window : ATTACH r1$ TO display$
	GOSUB Create
	r1 = 0 : ATTACH display$ TO r1$
	XuiWindow (window, #WindowRegister, grid, -1, v2, v3, @r0, @"AddTraceW")
END SUB
'
'
' *****  GetSmallestSize  *****  see "Anatomy of Grid Functions"
'
SUB GetSmallestSize
END SUB
'
'
' *****  Redrawn  *****  see "Anatomy of Grid Functions"
'
SUB Redrawn
	XuiCallback (grid, #Redrawn, v0, v1, v2, v3, r0, r1)
END SUB
'
'
' *****  Resize  *****  see "Anatomy of Grid Functions"
'
SUB Resize
END SUB
'
'
' *****  Selection  *****  see "Anatomy of Grid Functions"
'
SUB Selection
END SUB
'
'
' *****  Initialize  *****  see "Anatomy of Grid Functions"
'
SUB Initialize
	XuiGetDefaultMessageFuncArray (@func[])
	XgrMessageNameToNumber (@"LastMessage", @upperMessage)
'
	func[#Callback]           = &XuiCallback ()               ' disable to handle Callback messages internally
' func[#GetSmallestSize]    = 0                             ' enable to add internal GetSmallestSize routine
' func[#Resize]             = 0                             ' enable to add internal Resize routine
'
	DIM sub[upperMessage]
'	sub[#Callback]            = SUBADDRESS (Callback)         ' enable to handle Callback messages internally
	sub[#Create]              = SUBADDRESS (Create)           ' must be subroutine in this function
	sub[#CreateWindow]        = SUBADDRESS (CreateWindow)     ' must be subroutine in this function
'	sub[#GetSmallestSize]     = SUBADDRESS (GetSmallestSize)  ' enable to add internal GetSmallestSize routine
	sub[#Redrawn]             = SUBADDRESS (Redrawn)          ' generate #Redrawn callback if appropriate
'	sub[#Resize]              = SUBADDRESS (Resize)           ' enable to add internal Resize routine
	sub[#Selection]           = SUBADDRESS (Selection)        ' routes Selection callbacks to subroutine
'
	IF sub[0] THEN PRINT "AddTraceW() : Initialize : error ::: (undefined message)"
	IF func[0] THEN PRINT "AddTraceW() : Initialize : error ::: (undefined message)"
	XuiRegisterGridType (@AddTraceW, "AddTraceW", &AddTraceW(), @func[], @sub[])
'
' Don't remove the following 4 lines, or WindowFromFunction/WindowToFunction will not work
'
	designX = 654
	designY = 334
	designWidth = 200
	designHeight = 224
'
	gridType = AddTraceW
	XuiSetGridTypeProperty (gridType, @"x",                designX)
	XuiSetGridTypeProperty (gridType, @"y",                designY)
	XuiSetGridTypeProperty (gridType, @"width",            designWidth)
	XuiSetGridTypeProperty (gridType, @"height",           designHeight)
	XuiSetGridTypeProperty (gridType, @"maxWidth",         designWidth)
	XuiSetGridTypeProperty (gridType, @"maxHeight",        designHeight)
	XuiSetGridTypeProperty (gridType, @"minWidth",         designWidth)
	XuiSetGridTypeProperty (gridType, @"minHeight",        designHeight)
	XuiSetGridTypeProperty (gridType, @"can",              $$Focus OR $$Respond OR $$Callback OR $$TextSelection)
	XuiSetGridTypeProperty (gridType, @"focusKid",         $Addbt)
	XuiSetGridTypeProperty (gridType, @"inputTextString",  $XuiDropBox)
	IFZ message THEN RETURN
END SUB
END FUNCTION
'
'
' ##############################
' #####  AddTraceWCode ()  #####
' ##############################
'
FUNCTION  AddTraceWCode (grid, message, v0, v1, v2, v3, kid, r1)
	SHARED MemDataSet ImageDataSet[]
	SHARED DropSelect,currentclr

'
	$AddTraceW   =   0  ' kid   0 grid type = AddTraceW
	$XuiColor    =   1  ' kid   1 grid type = XuiColor
	$Addbt       =   2  ' kid   2 grid type = XuiPushButton
	$Removebt    =   3  ' kid   3 grid type = XuiPushButton
	$XuiDropBox  =   4  ' kid   4 grid type = XuiDropBox
	$XuiLabe     =   5  ' kid   5 grid type = XuiLabel
	$syncPx      =   6  ' kid   6 grid type = XuiCheckBox
	$syncMM      =   7  ' kid   7 grid type = XuiCheckBox
	$syncTk      =   8  ' kid   8 grid type = XuiCheckBox
	$labelink    =   9  ' kid   9 grid type = XuiLabel
	$UpperKid    =   9  ' kid maximum
'
'	XuiReportMessage (grid, message, v0, v1, v2, v3, kid, r1)
	IF (message == #Callback) THEN message = r1
'	XgrMessageNumberToName  (message,@message$): PRINT grid, message$, v0, v1, v2, v3, kid, r1

'
	SELECT CASE message
		CASE #Redrawn			: GOSUB Redraw
		CASE #Selection		: GOSUB Selection   	' most common callback message
'		CASE #TextEvent		: GOSUB TextEvent   	' KeyDown in TextArea or TextLine
'		CASE #CloseWindow	: QUIT (0)						' close main window and no cleanup needed
		CASE #CloseWindow	: XuiSendMessage (grid, #HideWindow, 0, 0, 0, 0, 0, 0)
	END SELECT
	RETURN
'
'
' *****  Selection  *****
'
SUB Selection
	SELECT CASE kid
'		CASE $AddTraceW   :
'		CASE $XuiLabe  		:
		CASE $syncPx			:IF v0=$$TRUE THEN #TrackSyncPx=1 ELSE #TrackSyncPx=0
		CASE $syncTk			:IF v0=$$TRUE THEN #TrackSyncTk=1 ELSE #TrackSyncTk=0
		CASE $syncMM			:IF v0=$$TRUE THEN #TrackSyncMM=1 ELSE #TrackSyncMM=0
		CASE $XuiColor 		:currentclr=v0: XgrClearGrid (#AddTraceBoxG,currentclr)
		CASE $Addbt        :GOSUB AddTrace
		CASE $Removebt     :GOSUB RemoveTrace
		CASE $XuiDropBox   :GOSUB DpSelect

	END SELECT
END SUB

'################
SUB DpSelect
'################

	DropSelect=v0
	set=v0
	FOR pos=0 TO UBOUND (ImageDataSet[])
			IF ImageDataSet[pos].cMenuNo=set+1 THEN
						currentclr=ImageDataSet[pos].clr2d
						XgrClearGrid (#AddTraceBoxG,currentclr)
						Update(0)
						EXIT FUNCTION
			END IF
	NEXT pos


END SUB


'################
SUB RemoveTrace
'################

	set=DropSelect
	FOR pos=0 TO UBOUND (ImageDataSet[])
			IF ImageDataSet[pos].cMenuNo=set+1 THEN
						RemoveTraceFromWindow (pos)
						EXIT FUNCTION
			END IF
	NEXT pos


END SUB


'#############
SUB AddTrace
'#############

	set=DropSelect
	FOR pos=0 TO UBOUND (ImageDataSet[])
			IF ImageDataSet[pos].cMenuNo=set+1 THEN
					'	IF pos=#ImageSet THEN EXIT FUNCTION
						AddTraceToWindow (pos,currentclr)
					'	AutoScale (pos,ImageDataSet[pos].Track)
						EXIT FUNCTION
			END IF
	NEXT pos


END SUB


'###########
SUB Redraw
'###########

	IFZ currentclr THEN currentclr=#ink
	IF kid=$labelink THEN XgrClearGrid (#AddTraceBoxG,currentclr)

END SUB


END FUNCTION
'
'
'	###############################
'	#####  LevelIndicator ()  #####
'	###############################
'
FUNCTION  LevelIndicator (grid, message, v0, v1, v2, v3, r0, (r1, r1$, r1[], r1$[]))
	STATIC  designX,  designY,  designWidth,  designHeight
	STATIC  SUBADDR  sub[]
	STATIC  upperMessage
	STATIC  LevelIndicator
'
	$LevelIndicator  =   0  ' kid   0 grid type = LevelIndicator
	$base            =   1  ' kid   1 grid type = XuiLabel
	$Label           =   2  ' kid   2 grid type = XuiLabel
	$UpperKid        =   2  ' kid maximum
'
'
	IFZ sub[] THEN GOSUB Initialize
'	XuiReportMessage (grid, message, v0, v1, v2, v3, r0, r1)
	IF XuiProcessMessage (grid, message, @v0, @v1, @v2, @v3, @r0, @r1, LevelIndicator) THEN RETURN
	IF (message <= upperMessage) THEN GOSUB @sub[message]
	RETURN
'
'
' *****  Callback  *****  message = Callback : r1 = original message
'
SUB Callback
	message = r1
	callback = message
	IF (message <= upperMessage) THEN GOSUB @sub[message]
END SUB
'
'
' *****  Create  *****  v0123 = xywh : r0 = window : r1 = parent
'
SUB Create
	IF (v0 <= 0) THEN v0 = 0
	IF (v1 <= 0) THEN v1 = 0
	IF (v2 <= 0) THEN v2 = designWidth
	IF (v3 <= 0) THEN v3 = designHeight
	XuiCreateGrid  (@grid, LevelIndicator, @v0, @v1, @v2, @v3, r0, r1, &LevelIndicator())
	XuiSendMessage ( grid, #SetGridName, 0, 0, 0, 0, 0, @"LevelIndicator")
	#LevelIndicatorG=grid

	XuiLabel       (@g, #Create, 0, 44, 344, 32, r0, grid)
	XuiSendMessage ( g, #SetCallback, grid, &LevelIndicator(), -1, -1, $base, grid)
	XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"base")
	XuiSendMessage ( g, #SetBorder, $$BorderLower1, $$BorderLower1, $$BorderNone, 0, 0, 0)
	#lBase=g

	XuiLabel       (@g, #Create, 0, 4, 344, 36, r0, grid)
	XuiSendMessage ( g, #SetCallback, grid, &LevelIndicator(), -1, -1, $Label, grid)
	XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"Label")
	XuiSendMessage ( g, #SetBorder, $$BorderNone, $$BorderNone, $$BorderNone, 0, 0, 0)
	SetKidFields (g)

	#LevelIndicatorUpperKid=$UpperKid
	GOSUB Resize
END SUB
'
'
' *****  CreateWindow  *****  v0123 = xywh : r0 = windowType : r1$ = display$
'
SUB CreateWindow
	IF (v0 == 0) THEN v0 = designX
	IF (v1 == 0) THEN v1 = designY
	IF (v2 <= 0) THEN v2 = designWidth
	IF (v3 <= 0) THEN v3 = designHeight
	XuiWindow (@window, #WindowCreate, v0, v1, v2, v3, r0, @r1$)
	v0 = 0 : v1 = 0 : r0 = window : ATTACH r1$ TO display$
	GOSUB Create
	r1 = 0 : ATTACH display$ TO r1$
	XuiWindow (window, #WindowRegister, grid, -1, v2, v3, @r0, @"LevelIndicator")
END SUB
'
'
' *****  GetSmallestSize  *****  see "Anatomy of Grid Functions"
'
SUB GetSmallestSize
END SUB
'
'
' *****  Redrawn  *****  see "Anatomy of Grid Functions"
'
SUB Redrawn
	XuiCallback (grid, #Redrawn, v0, v1, v2, v3, r0, r1)
END SUB
'
'
' *****  Resize  *****  see "Anatomy of Grid Functions"
'
SUB Resize
END SUB
'
'
' *****  Selection  *****  see "Anatomy of Grid Functions"
'
SUB HideWindow
	#LevelIndicatorStatus=0
END SUB

SUB DisplayWindow
	#LevelIndicatorStatus=1
END SUB


SUB Selection
END SUB
'
'
' *****  Initialize  *****  see "Anatomy of Grid Functions"
'
SUB Initialize
	XuiGetDefaultMessageFuncArray (@func[])
	XgrMessageNameToNumber (@"LastMessage", @upperMessage)
'
	func[#Callback]           = &XuiCallback ()               ' disable to handle Callback messages internally
' func[#GetSmallestSize]    = 0                             ' enable to add internal GetSmallestSize routine
' func[#Resize]             = 0                             ' enable to add internal Resize routine
'
	DIM sub[upperMessage]
'	sub[#Callback]            = SUBADDRESS (Callback)         ' enable to handle Callback messages internally
	sub[#Create]              = SUBADDRESS (Create)           ' must be subroutine in this function
	sub[#CreateWindow]        = SUBADDRESS (CreateWindow)     ' must be subroutine in this function
'	sub[#GetSmallestSize]     = SUBADDRESS (GetSmallestSize)  ' enable to add internal GetSmallestSize routine
	sub[#Redrawn]             = SUBADDRESS (Redrawn)          ' generate #Redrawn callback if appropriate
'	sub[#Resize]              = SUBADDRESS (Resize)           ' enable to add internal Resize routine
	sub[#Selection]           = SUBADDRESS (Selection)        ' routes Selection callbacks to subroutine
	sub[#HideWindow]					= SUBADDRESS (HideWindow)
	sub[#DisplayWindow]				= SUBADDRESS (DisplayWindow)
'
'	IF sub[0] THEN PRINT "LevelIndicator() : Initialize : error ::: (undefined message)"
'	IF func[0] THEN PRINT "LevelIndicator() : Initialize : error ::: (undefined message)"
	XuiRegisterGridType (@LevelIndicator, "LevelIndicator", &LevelIndicator(), @func[], @sub[])
'
' Don't remove the following 4 lines, or WindowFromFunction/WindowToFunction will not work
'
	designX = 304
	designY = 347
	designWidth = 344
	designHeight = 88
'
	gridType = LevelIndicator
	XuiSetGridTypeProperty (gridType, @"x",                designX)
	XuiSetGridTypeProperty (gridType, @"y",                designY)
	XuiSetGridTypeProperty (gridType, @"width",            designWidth)
	XuiSetGridTypeProperty (gridType, @"height",           designHeight)
	XuiSetGridTypeProperty (gridType, @"maxWidth",         designWidth)
	XuiSetGridTypeProperty (gridType, @"maxHeight",        designHeight)
	XuiSetGridTypeProperty (gridType, @"minWidth",         designWidth)
	XuiSetGridTypeProperty (gridType, @"minHeight",        designHeight)
	XuiSetGridTypeProperty (gridType, @"can",              $$Callback)
	IFZ message THEN RETURN
END SUB
END FUNCTION
'
'
' ###################################
' #####  LevelIndicatorCode ()  #####
' ###################################
'
'
FUNCTION  LevelIndicatorCode (grid, message, v0, v1, v2, v3, kid, r1)

'	$LevelIndicator  =   0  ' kid   0 grid type = LevelIndicator
'	$base            =   1  ' kid   1 grid type = XuiLabel
'	$Label           =   2  ' kid   2 grid type = XuiLabel
'	$UpperKid        =   2  ' kid maximum


RETURN


END FUNCTION
'
'
' ####################################
' #####  CreateMemoryBuffers ()  #####
' ####################################
'
FUNCTION  CreateMemoryBuffers ()
	SHARED ww,xx,yy,hh

	XgrCreateWindow (@#winbuff, 0, xx, yy, 10, 10,0,"")


	XgrCreateGrid   (@#memBuffer, $$GridTypeBuffer, 0, 0, 50, 50, #winbuff, 0, 0)			' image memory buffer
	XgrCreateGrid   (@#cBuff, $$GridTypeBuffer, 0, 0, 200, 300,#winbuff, 0, 0)					' context menu buffer
	XgrCreateGrid   (@#BTbuff, $$GridTypeBuffer, 0, 0, ww+#rightmargin, #bottommargin, #winbuff, 0, 0)	' button menu buffer
	XgrCreateGrid   (@#vColbarBuff, $$GridTypeBuffer, 0, 0, 10, hh, #winbuff, 0, 0)			'
	XgrCreateGrid   (@#hColbarBuff, $$GridTypeBuffer, 0, 0, ww, 10, #winbuff, 0, 0)			'


END FUNCTION
'
'
' ################################
' #####  OpenMainDispWin ()  #####
' ################################
'
FUNCTION  OpenMainDispWin ()

	XgrGetWindowState (#OutputWindow, @state)
	IF state=0 THEN XuiSendMessage (#Output, #DisplayWindow, 0, 0, 0, 0, 0, 0)

END FUNCTION
'
'
' #########################
' #####  PopUpBox ()  #####
' #########################
'
FUNCTION  PopUpBox (title$,text$,yes$,no$,action)

	#PopUpAction=action
	#ToolMenuBottonState=0

	IF action=4 THEN XuiSendMessage (#Message,#Disable,0,0,0,0,3,0) ELSE XuiSendMessage (#Message,#Enable,0,0,0,0,3,0)

	XuiSendMessage (#Message,#SetWindowTitle, 0, 0, 0, 0, 0,@title$)
	XuiSendMessage (#Message,#SetTextString,0,0,0,0,1,@text$)
	XuiSendMessage (#Message,#SetTextString,0,0,0,0,2,@yes$)
	XuiSendMessage (#Message,#SetTextString,0,0,0,0,3,@no$)

'	XuiSendMessage (#Output,#HideWindow,0,0,0,0,0,0)
	XuiSendMessage (#Tools,#HideWindow,0,0,0,0,0,0)
	XuiSendMessage (#Message,#DisplayWindow,0,0,0,0,0,0)
'	XuiSendMessage (#Message,#Redraw,0,0,0,0,0,0)

	XgrSetSelectedWindow (#MessageWindow)
'	SetFocusOnKid	(#MessageWindow,1)

END FUNCTION
'
'
' ##########################
' #####  PopUpBoxB ()  #####
' ##########################
'
FUNCTION PopUpBoxB (text$,title$,option)
	STATIC timer

	XstStartTimer (@timer, 1, 100, &MessageTimer())
	ret=MessageBoxA (0,&text$,&title$,option)
	XstKillTimer (timer)
	timer=0

	RETURN ret

END FUNCTION
'
'
' #############################
' #####  DisplayTrack ()  #####
' #############################
'
FUNCTION  DisplayTrack (track,n)
	SHARED Image ImageFormat[]
	SHARED MemDataSet ImageDataSet[]
	SINGLE Max,Min

		IF #currentDisplay<>1 THEN SwitchToTrack ()

		'checkMaxVvalue (@text$)
		XgrClearGrid (#memBuffer,#background)
		IF #vColState=1 THEN vColBar (1)
		#scrpix=ImageFormat[#ImageSet,#dataFile].lPixel-ImageFormat[#ImageSet,#dataFile].fPixel
		ids=ImageDataSet[#ImageSet].DataSet


		FOR slot=0 TO UBOUND(ImageDataSet[])
				IF ((ImageDataSet[slot].active=1) AND (ImageDataSet[slot].stDisplayOL=1) AND (slot<>#ImageSet)) THEN

							IF #TrackSyncTk=0 THEN
										tk=ImageDataSet[slot].Track
							ELSE
										tk=track
										IF track<ImageFormat[slot,ds].NumberOfTracks THEN
													ImageDataSet[slot].Track=track
										END IF
							END IF

							IF #TrackSyncPx=0 THEN
										ds=ImageDataSet[slot].DataSet
										first=ImageFormat[slot,ds].fPixel+1
										last=ImageFormat[slot,ds].lPixel+1
							ELSE
										first=ImageFormat[#ImageSet,ids].fPixel+1
										last=ImageFormat[#ImageSet,ids].lPixel+1
										ImageFormat[slot,ds].fPixel=first-1
										ImageFormat[slot,ds].lPixel=last-1
							END IF

							IF #TrackSyncMM=0 THEN
										Max=ImageDataSet[slot].MaxValue
										Min=ImageDataSet[slot].MinValue
										res=1
							ELSE
										Max=ImageDataSet[#ImageSet].MaxValue
										Min=ImageDataSet[#ImageSet].MinValue
										ImageDataSet[slot].MaxValue=Max
										ImageDataSet[slot].MinValue=Min
										res=0
							END IF

							DrawTrack (#memBuffer,slot,ImageDataSet[slot].clr2d,tk,first,last,Max,Min,res)

				END IF
		NEXT slot

		DrawTrack (#memBuffer,#ImageSet,#ink,track,ImageFormat[#ImageSet,ids].fPixel+1,ImageFormat[#ImageSet,ids].lPixel+1,ImageDataSet[#ImageSet].MaxValue,ImageDataSet[#ImageSet].MinValue,0)

		IF #SaveImage=0 THEN DrawInfo()
		IF ((#SaveImage=0) OR (#SaveImage=1)) THEN XgrCopyImage (#image,#memBuffer)

	'	IF #error THEN error (text$)

END FUNCTION
'
'
' ################################
' #####  XgrCreateFields ()  #####
' ################################
'
FUNCTION  XgrCreateFields (g,kid,name$,help$,hint$,grid)

' (kidgrid,kid,kidname,helpstring,hintstring,parentgrid)

	XuiSendMessage ( g, #SetCallback, grid, &Output(), -1, -1, kid, grid)
	XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @name$)
	XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @help$)
	XuiSendMessage ( g, #SetHintString, 0, 0, 0, 0, 0, @hint$)

	SetKidFields (g)


END FUNCTION
'
'
' ####################################
' #####  DataTrackImageCheck ()  #####
' ####################################
'
FUNCTION  DataTrackImageCheck ()
	SHARED Image ImageFormat[]
	SHARED SINGLE ww

	IF (ImageFormat[#ImageSet,#dataFile].NumberOfTracks > 1) THEN

				XuiSendMessage (#Tools, #Enable,0,0,0,0,15,0) ' FI button

				IF #currentDisplay=1 THEN
							XuiSendMessage (#Output,#Enable,0,0,0,0,9,0)  ' v track scroll bar
				END IF

				IF #rightmargin<>30 THEN
						#rightmargin=30
						ResizeWindows ()
				END IF

	ELSE

				XuiSendMessage (#Output,#Disable,0,0,0,0,9,0)  ' v track scroll bar
				XuiSendMessage (#Output,#Disable,0,0,0,0,22,0) ' FI button
				XuiSendMessage (#Tools, #Disable,0,0,0,0,15,0) ' FI button


				IF #currentDisplay=1 THEN
						IF #rightmargin<>20 THEN
								#rightmargin=20
								ResizeWindows ()
						END IF
				ELSE
						IF #rightmargin<>30 THEN
								#rightmargin=30
								ResizeWindows ()
						END IF
				END IF

	END IF

END FUNCTION
'
'
' ##############################
' #####  SwitchToImage ()  #####
' ##############################
'
FUNCTION  SwitchToImage ()
	SHARED MemDataSet ImageDataSet[]
	SHARED ww

	#currentDisplay=2
'	#clearGrid=1
	#clearO1=1

	#MaxVi!= ImageDataSet[#ImageSet].MaxValue
	#MinVi!= ImageDataSet[#ImageSet].MinValue

	XuiSendMessage (#Output,#Disable,0,0,0,0,9,0)	' v track scroll bar
	XuiSendMessage (#Output,#Disable,0,0,0,0,39,0)	'
	XuiSendMessage (#Output,#Disable,0,0,0,0,40,0)	'

	XuiSendMessage (#Output,#Enable,0,0,0,0,25,0)	' $zoomin
	XuiSendMessage (#Output,#Enable,0,0,0,0,26,0)	' $zoomout
	XuiSendMessage (#Output,#Enable,0,0,0,0,27,0)	' $incrase x
	XuiSendMessage (#Output,#Enable,0,0,0,0,28,0)	' $decrase x
	XuiSendMessage (#Output,#Enable,0,0,0,0,38,0)	' $colourbar
	XuiSendMessage (#Output,#Enable,0,0,0,0,41,0)	'
	XuiSendMessage (#Output,#Enable,0,0,0,0,42,0)	'

'	XgrDisplayWindow (#ModScaleMaxWindow)
'	XgrDisplayWindow (#ModScaleMinWindow)


'	#FirstPix=ImageFormat[#ImageSet,#dataFile].fPixel
'	#LastPix=ImageFormat[#ImageSet,#dataFile].fPixel+((ImageFormat[#ImageSet,#dataFile].lPixel-ImageFormat[#ImageSet,#dataFile].fPixel)/#col)

	IF #topmargin<>#defaultTopI THEN ResizeWindows ()

	XuiSendMessage (#Output,#Resize, #leftmargin-1, #topmargin-51, ww-95, 18, 43, 0)


END FUNCTION
'
'
' ###############################
' #####  ShowButtonMenu ()  #####
' ###############################
'
FUNCTION  ShowButtonMenu (time)
	SHARED Image ImageFormat[]
	SHARED SINGLE hh,ww

	w=ww+#rightmargin+5
	h=20
	x=#leftmargin+180
	y=#v3-50

	IF time>0 THEN

			h2=1
			FOR pos=(y+28) TO (y+8) STEP -1
					XgrDrawImage (#OutputG, #BTbuff, 180, 0 , w, h2, x ,pos )
					INC h2
					XstSleep (time)
			NEXT  pos

	ELSE
			'		XgrDrawImage (#OutputG, #BTbuff, 180, 0 , w, h, x ,y+8)
	END IF

	FOR pos=17 TO 21
			XuiSendMessage (#Output,#Enable,0,0,0,0,pos,0)
			XuiSendMessage (#Output,#Redraw,0,0,0,0,pos,0)
	NEXT pos

	IF ImageFormat[#ImageSet,#dataFile].NumberOfTracks >1 THEN
				XuiSendMessage (#Output,#Enable,0,0,0,0,22,0)
				XuiSendMessage (#Output,#Redraw,0,0,0,0,22,0)
	END IF

	FOR pos=23 TO 24
			XuiSendMessage (#Output,#Enable,0,0,0,0,pos,0)
			XuiSendMessage (#Output,#Redraw,0,0,0,0,pos,0)
	NEXT pos


	XuiSendMessage (#Output,#Enable,0,0,0,0,4,0): XuiSendMessage (#Output,#Redraw,0,0,0,0,4,0)
	XuiSendMessage (#Output,#Enable,0,0,0,0,8,0): XuiSendMessage (#Output,#Redraw,0,0,0,0,8,0)
	XuiSendMessage (#Output,#Enable,0,0,0,0,10,0): XuiSendMessage (#Output,#Redraw,0,0,0,0,10,0)

'	XuiSendMessage (#Output,#Enable,0,0,0,0,11,0): XuiSendMessage (#Output,#Redraw,0,0,0,0,11,0)

	XuiSendMessage (#Output,#Enable,0,0,0,0,12,0): XuiSendMessage (#Output,#Redraw,0,0,0,0,12,0)
	XuiSendMessage (#Output,#Enable,0,0,0,0,13,0): XuiSendMessage (#Output,#Redraw,0,0,0,0,13,0)

	#ButtonMenu=1
	#cSubMenu14$[0]="Always Off"

END FUNCTION
'
'
' ###############################
' #####  HideButtonMenu ()  #####
' ###############################
'
FUNCTION  HideButtonMenu (time)
	SHARED Image ImageFormat[]
	SHARED SINGLE hh,ww

	h=20
	x=#leftmargin+180
	y=#v3-52

	IF time=0 THEN
				w=#v2 '#leftmargin+ww+#rightmargin+4
				XgrFillBox (#OutputG, #background ,x-6,y+2, w ,y+h+8)
	ELSE
				w=ww+#rightmargin+5
				h2=h+1
				FOR pos=(y+8) TO (y+28)
						XgrDrawImage (#OutputG, #BTbuff, 180, 0 , w, h2, x ,pos )
						DEC h2
						XstSleep (time)
				NEXT  pos
	END IF


	FOR pos=17 TO 24
			XuiSendMessage (#Output,#Disable,0,0,0,0,pos,0)
	NEXT pos

	XuiSendMessage (#Output,#Disable,0,0,0,0,4,0)
	XuiSendMessage (#Output,#Disable,0,0,0,0,8,0)
	XuiSendMessage (#Output,#Disable,0,0,0,0,10,0)
'	XuiSendMessage (#Output,#Disable,0,0,0,0,11,0)
	XuiSendMessage (#Output,#Disable,0,0,0,0,12,0)
	XuiSendMessage (#Output,#Disable,0,0,0,0,13,0)

	#ButtonMenu=0
	#cSubMenu14$[0]="Always On"

END FUNCTION
'
'
' ###############################
' #####  BuffMenuBotton ()  ##### 	' BUTTON! - typo
' ###############################
'
FUNCTION  BuffMenuBotton ()
	SHARED icontype icons[]
	SHARED Image ImageFormat[]
	SHARED SINGLE hh,ww
	UBYTE image[]


	XgrClearGrid (#BTbuff,#background)

	x=#leftmargin+107
	ink=#ink

	FOR pos=0 TO 12

			IF pos=11 THEN
					IF ImageFormat[#ImageSet,]<>0 THEN
						IF ImageFormat[#ImageSet,#dataFile].NumberOfTracks <2 THEN ink=#background ELSE ink=#ink
					END IF
			ELSE
						ink=#ink
			END IF

			XgrMoveTo (#BTbuff, x, 1)
			XgrDrawText (#BTbuff, ink,#button$[pos])

			IF pos=3  THEN x=x+30
			IF pos=7  THEN x=x+10
			'IF pos=11 THEN x=x+10
			x=x+30

	NEXT pos

END FUNCTION
'
'
' ####################################
' #####  ConvertColorToWinCV ()  #####
' ####################################
'
FUNCTION  ConvertColorToWinCV (color, @winCV)

	XgrConvertColorToRGB (color, @red, @green, @blue)
	red = red{8,8}
	green = green{8,8}
	blue = blue{8,8}
	winCV = red + (green*256) + (blue*65536)
'
	RETURN winCV

END FUNCTION
'
'
' ##########################
' #####  SpeedTest ()  #####
' ##########################
'
FUNCTION  SpeedTest ()		' benchmark
	SHARED Image ImageFormat[]
	SHARED MemDataSet ImageDataSet[]
	DOUBLE finish

IF ImageFormat[#ImageSet,#dataFile].NumberOfTracks<10 THEN EXIT FUNCTION		' not much point continuing with so little tracks

tk=ImageDataSet[#ImageSet].Track
StartTimer (@index,start)


FOR tk=0 TO ImageFormat[#ImageSet,#dataFile].NumberOfTracks-1
		DisplayTrack(ImageDataSet[#ImageSet].Track,0)
NEXT tk

EndTimer (@index,@finish)


a!=SINGLE(ImageDataSet[#ImageSet].Track)/(finish*0.001)
PopUpBox ("Tracks per sec",STRING(a!), "Retry","Cancel",3)

DEC ImageDataSet[#ImageSet].Track


END FUNCTION
'
'
' ###############################
' #####  SelectFileMenu ()  #####
' ###############################
'
FUNCTION  SelectFileMenu (state,index)

	#CloseFileWindow=state  ' no longer required

	file$ = ""
	filter$="Andor data files\0*.sif\0Instaspec image files\0*.ii\0Raw data files\0*.dat\0All files\0*.*\0" ' ;*.ii

	IF WinOpenFile (#OutputWindow, @file$, filter$)=-1 THEN
				IF #LoadBit=1 THEN Quit()
				#LoadBit=0
				RETURN -1
	ELSE
			  FindMoreDataFiles (file$)
				LoadFile (file$,index)
				RETURN index
	END IF

END FUNCTION
'
'
' ##################################
' #####  InitNonStandalone ()  #####
' ##################################
'
FUNCTION  InitNonStandalone (os)
	SHARED Image ImageFormat[]
	SHARED inifile$

'		#File$="pic.sif"
'		#File$="us.ii"
'		#File$="sif\\c2793bs.sif"
'		#File$="\\\\Celly\\users\\Mapei\\iidat\\DATA.SIF"
'		#File$="cyclohexane.sif"
'		#File$="c3198bs-32int.dat"
'		#File$="C1111HC-1.sif"
'		#File$="us-ii.dat"
'		#File$="asc\\2870-1track.asc"
'		#File$="sif\\mdm.sif"

		#File$="DATA.SIF"
'		#File$="cambium1.sif"

'		#File$="fit\\signed32dave.fit"
'		#File$="sif\\test.sif"'
'		#File$="sif\\yellow lid type4.sif"
'		#File$="cambium1.sif"
'		#File$="sif\\mdm.sif"
'		#File$="iccd-3025bs.sif"
'		#File$="untested\\ox10.sif"
'		#File$="singletrackmode.sif"
'		#File$="fails\\bluesky2.sif"			' old spec
'		#File$="fails\\binning3.sif"

'		#File$="sif\\AV436.sif"

		XstGetCPUName (@#cpu$)
		XstGetOSVersionName (@#version$)
		XgrGetDisplaySize ("", @#displayWidth, @#displayHeight, @#windowBorderWidth, @#windowTitleHeight)

		IF os=2 THEN
				'	IF (#os$="WindowsNT") AND (#version$="5.0") THEN #os$="Windows": #version$="2000"
					#fil$= "e:\\xb\\ii\\"				' $$PathSlash$, XstPathString$()
		ELSE
					#fil$= "/mnt/beast/windows/wine/xb/II/"			' AMD rh7.1 server/gateway
				'	#fil$= "/mnt/wine/xb/II/"			' AMD rh 7.1 linux workstation
				'	#displayHeight=#displayHeight ' -48
		END IF

		#fil$=#fil$+#File$
		XstDecomposePathname (#fil$, @path$, parent$, filename$, file$, DataFileExt$)
		dir$=path$+"\\"

		#ImageSet=CreateDataSlot (0,0)
		XstSetCurrentDirectory (#fil$)
		FindMoreDataFiles (#fil$)
		LoadIcons (#fil$)
		ExtractFileTypeInfo (#fil$,#ImageSet)
		#dataFile=ImageFormat[#ImageSet,0].firstdataset
		AddToOpenedFileList (#fil$)
		SetProgramTitle (#fil$)
		setfileBThints ()
		InitVariables()

END FUNCTION
'
'
' #################################
' #####  ClearHcoverField ()  #####
' #################################
'
FUNCTION  ClearHcoverField ()
	SHARED hh,ww

	XgrFillBox (#OutputG, #background ,#leftmargin-10,hh+2+#topmargin,ww+#leftmargin+25,hh+18+#topmargin)

END FUNCTION


'
' ##########################
' #####  DrawXinfo ()  #####
' ##########################
'
FUNCTION  DrawXinfo ()
	SHARED Image ImageFormat[]
	SHARED SINGLE hh,ww
	SINGLE wwx

	IF #currentDisplay=2 THEN EXIT FUNCTION
	IF #scrpix<2 THEN EXIT FUNCTION

					wwx=ww/#scrpix
					h=hh+#topmargin
					print=0

					minxvalue=((((ImageFormat[#ImageSet,#dataFile].fPixel+ImageFormat[#ImageSet,#dataFile].bLeft)*ImageFormat[#ImageSet,#dataFile].xCal[1])+ImageFormat[#ImageSet,#dataFile].xCal[0])*ImageFormat[#ImageSet,#dataFile].hBin)-ImageFormat[#ImageSet,#dataFile].hBin+1
					maxxvalue=((((ImageFormat[#ImageSet,#dataFile].lPixel+ImageFormat[#ImageSet,#dataFile].bLeft)*ImageFormat[#ImageSet,#dataFile].xCal[1])+ImageFormat[#ImageSet,#dataFile].xCal[0])*ImageFormat[#ImageSet,#dataFile].hBin)-ImageFormat[#ImageSet,#dataFile].hBin+1

					XgrSetGridFont (#Output,#valfont)
					XgrDrawLine (#OutputG, #ink,#leftmargin,h+1,#leftmargin,h+4)
					XgrMoveTo (#OutputG,#leftmargin-2,h+5)
					XgrDrawTextFill (#OutputG, #ink, STRING$(minxvalue))

					pix=Round (minxvalue+((maxxvalue-minxvalue)/2)-((maxxvalue-minxvalue)/4),-1)
					xpos=(wwx*((#scrpix/2)-(#scrpix/4)))+#leftmargin
					XgrDrawLine (#OutputG, #ink,xpos,h+1,xpos,h+4)
					XgrMoveTo (#OutputG,xpos-2,h+5)
					XgrDrawTextFill (#OutputG, #ink, STRING$(pix))

					pix=Round (minxvalue+((maxxvalue-minxvalue)/2),-1)
					xpos=(wwx*(#scrpix)/2)+#leftmargin
					XgrDrawLine (#OutputG, #ink,xpos,h+1,xpos,h+4)
					XgrMoveTo (#OutputG,xpos-2,h+5)
					XgrDrawTextFill (#OutputG, #ink, STRING$(pix))

					pix=Round (minxvalue+((maxxvalue-minxvalue)/2)+((maxxvalue-minxvalue)/4),-1)
					xpos=(wwx*((#scrpix/2)+(#scrpix/4)))+#leftmargin
					XgrDrawLine (#OutputG, #ink,xpos,h+1,xpos,h+4)
					XgrMoveTo (#OutputG,xpos-2,h+5)
					XgrDrawTextFill (#OutputG, #ink, STRING$(pix))

					xpos=(wwx*#scrpix)+#leftmargin
					XgrDrawLine (#OutputG, #ink,xpos,h+1,xpos,h+4)
					XgrMoveTo (#OutputG,xpos-18,h+5)
					XgrDrawTextFill (#OutputG, #ink, STRING$(maxxvalue))


END FUNCTION
'
' ######################
' #####  Round ()  #####
' ######################

FUNCTION  DOUBLE Round (DOUBLE number, power)

 pTen# = 10# ** power
 RETURN INT(number / pTen# + .5#) * pTen#

END FUNCTION
'
'
' #############################
' #####  ReadNextFile ()  #####
' #############################
'
FUNCTION  ReadNextFile ()

	IF #MinSize=1 THEN EXIT FUNCTION

	INC #FileNumber
	IF #FileNumber > #NumberOfFiles THEN #FileNumber=0

	file$=#ListOfDataFiles$[#FileNumber]

	#ReadDirectionState=0
	LoadFile (file$,#ImageSet)

END FUNCTION
'
'
' #############################
' #####  ReadLastFile ()  #####
' #############################
'
FUNCTION  ReadLastFile ()

	IF #MinSize=1 THEN EXIT FUNCTION

	DEC #FileNumber
	IF #FileNumber < 0 THEN #FileNumber=#NumberOfFiles

	file$=#ListOfDataFiles$[#FileNumber]

	#ReadDirectionState=1
	LoadFile (file$,#ImageSet)

END FUNCTION
'
'
' ###############################
' #####  SetColourTheme ()  #####
' ###############################
'
FUNCTION  SetColourTheme (theme)
	SHARED MemDataSet ImageDataSet[]
	SHARED inifile$
	STATIC oldinifile$

'	GetIniValue ("Theme",STRING$(theme),@#themeLocation$)

	SELECT CASE theme
			CASE 99			:oldinifile$=inifile$
									inifile$=#defaultloc$+"\\\images\\"+#themeLocation$+"\\"+#themeLocation$+".ini"
									:#ink=GetIniValue ("Colours","ink",v$)
									:#background=GetIniValue ("Colours","background",v$)
									:#bColour=GetIniValue ("Colours","bColour",v$)
									:#bSelect=GetIniValue ("Colours","bSelect",v$)
									:#bInk=GetIniValue ("Colours","bInk",v$)
									:#borderColour=GetIniValue ("Colours","borderColour",v$)
									:#LineStyleInk=GetIniValue ("Colours","LineStyleInk",v$)
									:#cBaseColour=GetIniValue ("Colours","cBaseColour",v$)
									:#bHighlight=GetIniValue ("Colours","bHighlight",v$)
									:#cTextColour=GetIniValue ("Colours","cTextColour",v$)
									:#cHightlightBaseColour=GetIniValue ("Colours","cHightlightBaseColour",v$)
									:#cHightlightColour=GetIniValue ("Colours","ink",v$)
									:#cBorderColour=GetIniValue ("Colours","cHightlightColour",v$)
									:#cBorderColour2=GetIniValue ("Colours","cBorderColour2",v$)
									:#cursorColour=GetIniValue ("Colours","cursorColour",v$)
									:#cMenuSepBar1=GetIniValue ("Colours","cMenuSepBar1",v$)
									:#cMenuSepBar2=GetIniValue ("Colours","cMenuSepBar2",v$)
									:#PrintsC=GetIniValue ("Colours","PrintsC",v$)
									:GetIniValue ("Theme","0",@#themeLocation$)

			CASE 0			:#ink=$$Blue
									:#background=0xC0C0C000   ' $$LightGrey
									:#bColour=$$LightGrey
									:#bSelect=$$White
									:#bInk=#ink
									:#borderColour=$$Black
									:#LineStyleInk=0xFFFFFF00
									:#cBaseColour=$$LightGrey
									:#bHighlight=$$Black
									:#cTextColour=$$Black
									:#cHightlightBaseColour=$$DarkGrey
									:#cHightlightColour=$$White
									:#cBorderColour=#cBaseColour
									:#cBorderColour2=$$Black
									:#cursorColour=$$Orange
									:#cMenuSepBar1=$$Grey
									:#cMenuSepBar2=$$White
									:#PrintsC=$$BrightRed
									:GetIniValue ("Theme","0",@#themeLocation$)

			CASE 1			:#ink=0xD9D9D900
									:#background=$$DarkGrey
									:#bColour=#background
									:#bSelect=$$White
									:#bInk=#ink
									:#borderColour=#ink
									:#LineStyleInk=0xFFFFFF00
									:#cBaseColour=$$LightGrey
									:#bHighlight=$$White
									:#cTextColour=$$Black
									:#cHightlightBaseColour=#background
									:#cHightlightColour=$$White
									:#cBorderColour=#cBaseColour
									:#cBorderColour2=$$Black
									:#cursorColour=$$LightGreen
									:#cMenuSepBar1=$$Grey
									:#cMenuSepBar2=0xF0ECEC00
									:#PrintsC=$$White
									:GetIniValue ("Theme","1",@#themeLocation$)

			CASE 2			:#ink=$$Black
									:#background=$$White
									:#bColour=#background
									:#bSelect=$$Black
									:#bInk=#ink
									:#borderColour=#ink
									:#LineStyleInk=0xFFFFFF00
									:#cBaseColour=$$LightGrey
									:#bHighlight=$$Black
									:#cTextColour=$$Black
									:#cHightlightBaseColour=$$Black ' #background
									:#cHightlightColour=$$White
									:#cBorderColour=#cBaseColour
									:#cBorderColour2=$$Black
									:#cursorColour=$$Orange
									:#cMenuSepBar1=$$Grey
									:#cMenuSepBar2=$$White
									:#PrintsC=#ink
									:GetIniValue ("Theme","2",@#themeLocation$)

			CASE 3			:#ink=$$White
									:#background=$$Black
									:#bColour=#background
									:#bSelect=$$White
									:#bInk=#ink
									:#borderColour=#ink
									:#LineStyleInk=0xFFFFFF00
									:#cBaseColour=$$LightGrey
									:#bHighlight=$$White
									:#cTextColour=$$Black
									:#cHightlightBaseColour=#background
									:#cHightlightColour=$$White
									:#cBorderColour=#cBaseColour
									:#cBorderColour2=$$Black
									:#cursorColour=$$LightGreen
									:#cMenuSepBar1=$$Grey
									:#cMenuSepBar2=$$White
									:#PrintsC=$$White
									:GetIniValue ("Theme","3",@#themeLocation$)

			CASE 4			:#ink=$$Green
									#background=$$Black
								  #bColour=#background
  								#bInk=#ink
								  #borderColour=#ink
								  #LineStyleInk=$$BrightGreen
								  #bHighlight=$$White
								  #cBaseColour=$$DarkGreen
								  #cTextColour=$$Steel
								  #cHightlightBaseColour=$$Black
								  #cHightlightColour=0xD9D9D900
								  #cBorderColour=#cBaseColour
								  #cBorderColour2=$$Black
									#cMenuSepBar2=$$Grey
									#cMenuSepBar1=$$Black
 									#PrintsC=$$White
									:GetIniValue ("Theme","4",@#themeLocation$)

			CASE ELSE		:EXIT FUNCTION

	END SELECT

IF DEBUG = 2 THEN
PRINT #ink
PRINT XLONG(0xFFFFFF00)
PRINT #bColour
PRINT #bSelect
PRINT #bInk
PRINT #borderColour
PRINT ULONG(#LineStyleInk)
PRINT #cBaseColour
PRINT #bHighlight
PRINT #cTextColour
PRINT #cHightlightBaseColour
PRINT #cHightlightColour
PRINT #cBorderColour
PRINT #cBorderColour2
PRINT #cursorColour
PRINT #cMenuSepBar1
PRINT #cMenuSepBar2
PRINT #PrintsC
END IF

	LoadIcons (#defaultloc$)

	FOR kd=0 TO #OutputUpperKid
			kidgrid=GetGridNumber (#Output,kd)
			XuiSendMessage (kidgrid, #SetColor, #bColour, #bInk ,#bColour , #bSelect, 0, 0)
			XuiSendMessage (kidgrid, #SetColorExtra, #bSelect, #bHighlight, #bSelect, #bSelect, 0, 0)
	NEXT kd

	FOR kd=0 TO #ToolsUpperKid
			kidgrid=GetGridNumber (#Tools,kd)
			XuiSendMessage (kidgrid, #SetColor, #bColour,#bInk ,#bColour , #bSelect, 0, 0)
			XuiSendMessage (kidgrid, #SetColorExtra, #bSelect, #bHighlight , #bSelect, #bSelect, 0, 0)
	NEXT kd

	FOR kd=0 TO #AboutUpperKid
			kidgrid=GetGridNumber (#About,kd)
			XuiSendMessage (kidgrid, #SetColor, #bColour,#bInk ,#bColour , #bSelect, 0, 0)
			XuiSendMessage (kidgrid, #SetColorExtra, #bSelect, #bHighlight , #bSelect, #bSelect, 0, 0)
	NEXT kd


'	FOR kd=0 TO #LevelIndicatorUpperKid
'			XuiSendMessage (#LevelIndicator,#GetGridNumber, @kidgrid, 0, 0, 0, kd, 0)
'			XuiSendMessage (kidgrid, #SetColor, #bColour, #bColour , #bHighlight , #bSelect , 0, 0)
'			XuiSendMessage (kidgrid, #SetColorExtra, #bHighlight ,#bHighlight , #bHighlight, #bHighlight ,0, 0)
'	NEXT kd

'	FOR kd=0 TO 1
'			XuiSendMessage (#FileList,#GetGridNumber, @kidgrid, 0, 0, 0, kd, 0)
'			XuiSendMessage (kidgrid, #SetColor, #bColour,#bInk ,#bColour , #bSelect, 0, 0)
'			XuiSendMessage (kidgrid, #SetColorExtra, #bSelect, #bHighlight , #bSelect, #bSelect, 0, 0)
'	NEXT kd

	XuiSendMessage (#OutputG, #SetColor, #background, #background, #background, #background, 0, 0)
	XuiSendMessage (#OutputG, #SetColorExtra, #background, #background, #background, #background, 0, 0)
	XuiSendMessage (#IconWindowG, #SetColor, #background, #ink, #ink, #ink,0, 0)
	XuiSendMessage (#IconWindowG, #SetColorExtra, #background, #ink, #ink, #ink, 0, 0)

'	XuiSendMessage (#LevelIndicatorG, #SetColor, #background, #background, #background, #background, 0, 0)
'	XuiSendMessage (#LevelIndicatorG, #SetColorExtra, #background, #background, #background, #background, 0, 0)
'	XuiSendMessage (#LevelIndicator,#Redraw,0,0,0,0,0,0)

	kidgrid=GetGridNumber (#Output,9)			' vscale
	XuiSendMessage (kidgrid, #SetColor, #bColour,#bInk ,#bInk ,#bInk, 0, 0)

	kid=GetGridNumber (#Output,43)
	XuiSendMessage ( kid, #SetColor, #background , #ink , $$Black, $$White, 0, 0)
	XuiSendMessage ( kid, #SetColorExtra, #bSelect, #ink , $$Black, $$White, 0, 0)
	XuiSendMessage ( kid, #SetColor, #background , #ink , $$Black, $$White,1, 0)
	XuiSendMessage ( kid, #SetColorExtra, #bSelect, #ink , $$Black, $$White, 1, 0)
	XuiSendMessage ( kid, #SetColor, #background , #ink , #borderColour, #background , 2, 0)
	XuiSendMessage ( kid, #SetColorExtra, #bSelect , #bSelect , $$Black, $$White, 2, 0)

	BuffMenuBotton ()
	IF ((#currentDisplay=1) AND (#FirstLoad<>0)) THEN DisplayTrack (ImageDataSet[#ImageSet].Track,0)


END FUNCTION
'
'
' #################################
' #####  RedrawAllWindows ()  #####
' #################################
'
FUNCTION  RedrawAllWindows ()

	XuiSendMessage (#Output,#Redraw,0,0,0,0,0,0)
	XuiSendMessage (#Tools,#Redraw,0,0,0,0,0,0): IF (#Tdock<>1) THEN DrawToolsBorder ()
	XuiSendMessage (#Message,#Redraw,0,0,0,0,0,0)
	XuiSendMessage (#About,#Redraw,0,0,0,0,0,0)
	XuiSendMessage (#FileList ,#Redraw,0,0,0,0,0,0)
	XuiSendMessage (#LevelIndicator ,#Redraw,0,0,0,0,0,0)

END FUNCTION
'
'
' #######################
' #####  Prints ()  #####
' #######################
'
FUNCTION  Prints (text$,line)

	IF #MinSize=1 THEN EXIT FUNCTION

	grid=#image
	i=#PrintsC

	xpos=5
	ypos=(line*#size)+4
	dx=#cFontWidth*(LEN(text$)+8)

	XgrMoveTo (grid, xpos,ypos)
	XgrDrawImage (#image,#memBuffer, xpos, ypos, xpos+dx, ypos+#size, xpos, ypos)
	XgrDrawText (grid, i, text$)


' enable if calling from sPrint()
'	ypos=ypos+#size
'	XgrDrawImage (#image,#memBuffer, xpos, ypos, xpos+dx, ypos+#size, xpos, ypos)

END FUNCTION
'
'
' #######################
' #####  sPrint ()  #####
' #######################
'
FUNCTION  sPrint (text$)
	SHARED SINGLE hh
	STATIC y

	IF y<1 THEN y=0
	IF y> ((hh/#size)-1) THEN y=0

	Prints (text$,y)
	INC y


END FUNCTION
'
'
' #########################
' #####  isInMenu ()  #####
' #########################
'
FUNCTION  isInMenu (menu,x,y)
	SHARED cMenuPos cMenu[]

	IF menu=0 THEN br=5 ELSE br=0

	IF ((x < cMenu[menu].dx ) AND (y < cMenu[menu].dy ))	AND (( x > cMenu[menu].x) AND (y > (cMenu[menu].y+br) )) THEN
			RETURN 1
	ELSE
			RETURN 0
	END IF


END FUNCTION
'
'
' ###########################
' #####  cMenuClear ()  #####
' ###########################
'
FUNCTION  cMenuClear (menu)
	SHARED cMenuPos cMenu[]

	XgrDrawImage (#image,#memBuffer, cMenu[menu].x, cMenu[menu].y, cMenu[menu].dx, cMenu[menu].dy, cMenu[menu].x, cMenu[menu].y)

END FUNCTION
'
'
' ##############################
' #####  cMenuClearAll ()  #####
' ##############################
'
FUNCTION  cMenuClearAll ()
	SHARED cMenuPos cMenu[]

	cMenu[0].status=0
	cMenuClear (0)
	cMenuClear (1)
	cMenuClear (2)

END FUNCTION
'
'
' ###############################
' #####  cMenuSelection ()  #####
' ###############################
'
FUNCTION  cMenuSelection (v0,v1)
	SHARED cMenuPos cMenu[]
	SHARED SINGLE hh
	STATIC item,menu

x=v0: y=v1+3

IF isInMenu (0,x,y)=1 THEN

			IF cMenu[2].status=1 THEN cMenu[2].status=0: cMenu[2].olditem=255: cMenuClear (2)
			cMenu[0].item=(UBOUND(#cMenu$[]) - ((cMenu[0].dyReal-y)/#size))

			IF ((cMenu[0].item<>255) AND (cMenu[0].item<>cMenu[0].olditem)) THEN

						IF cMenu[1].status=1 THEN cMenu[1].status=0: cMenu[1].olditem=255: cMenuClear (1)
						cMenu[1].item=255

						IF RIGHT$(#cMenu$[cMenu[0].item])=#cSubSelectChar$ THEN	cMenu[0].item=cMenu[0].item: selectMenuArray ()
						IF #cMenu$[cMenu[0].item]<>#cMenuSeperator$ THEN item=cMenu[0].item ELSE item=255
						GOSUB drawMenu1

			END IF

			IF ((cMenu[1].status=1) AND (cMenu[1].item=0)) THEN
						cMenu[1].item=255
						cMenu[0].olditem=255
						GOSUB drawMenu2
			END IF

			cMenu[0].olditem=cMenu[0].item

ELSE

			IF cMenu[1].status=0 THEN
						cMenu[0].item=255
						IF cMenu[0].item<>cMenu[0].olditem THEN item=cMenu[0].item: GOSUB drawMenu1
						cMenu[0].olditem=cMenu[0].item
						EXIT FUNCTION
			END IF

			IF isInMenu (1,x,y)=1 THEN

						cMenu[1].item=(UBOUND(#cSubMenu$[]) - ((cMenu[1].dyReal-y)/#size))

						IF cMenu[1].item<>cMenu[1].olditem THEN
									GOSUB drawMenu2
									IF cMenu[2].status=1 THEN cMenu[2].status=0: cMenu[2].olditem=255: cMenuClear (2)

									IF cMenu[1].item<>255 THEN
												IF RIGHT$(#cSubMenu$[cMenu[1].item])=#cSubSelectChar$ THEN selectMenu3Array ()
									END IF
						ELSE
									IF ((cMenu[2].status=1) AND (cMenu[2].item<>255)) THEN cMenu[2].item=255: GOSUB drawMenu3
						END IF

						cMenu[1].olditem=cMenu[1].item
			ELSE

						IF ((cMenu[1].status=1) AND (cMenu[2].status=0)) THEN
									cMenu[1].item=255
									IF cMenu[1].item<>cMenu[1].olditem THEN GOSUB drawMenu2
									cMenu[1].olditem=cMenu[1].item
						ELSE
									IF isInMenu (2,x,y)=1 THEN
												cMenu[2].item=(UBOUND(#cMenu3$[]) - ((cMenu[2].dyReal-y)/#size))
									ELSE
												cMenu[2].item=255
									END IF

									IF cMenu[2].item<>cMenu[2].olditem THEN GOSUB drawMenu3
									cMenu[2].olditem=cMenu[2].item

						END IF

			END IF

END IF


EXIT FUNCTION


'##################
SUB	drawMenu3
'##################

	DrawContextMenu (cMenu[1].dx+1, cMenu[1].y+(#size*cMenu[1].item), cMenu[2].w , cMenu[2].h, 3, @#cMenu3$[], cMenu[2].item)

END SUB


'##################
SUB	drawMenu2
'##################

	DrawContextMenu (cMenu[0].dx+1, cMenu[0].y+(#size*cMenu[0].item), cMenu[1].w , cMenu[1].h, 2, @#cSubMenu$[], cMenu[1].item)

END SUB



'##################
SUB	drawMenu1
'##################

	DrawContextMenu (cMenu[0].x, cMenu[0].y, cMenu[0].w , cMenu[0].h, 1, @#cMenu$[], item)

END SUB


END FUNCTION
'
'
' ################################
' #####  DrawContextMenu ()  #####
' ################################
'
FUNCTION  DrawContextMenu (x,y,w,h,menu,Menu$[],Highlight)
	SHARED cMenuPos cMenu[]
	SHARED hh,ww
	SHARED T_Index,cTimer
	SINGLE off


' DrawContextMenu (x,y,w,h,menu,Menu$[],Highlight)  this is where i would like the image/menu to be placed
'	cMenu[menu].x  ..etc  this is where the image/menu has actualy been placed

	IF h>hh THEN off=hh-h: h=hh: ' Highlight=Highlight+19
	IF (y+h) > hh THEN y=y-((y+h)-hh)

	SELECT CASE menu
			CASE 1			: cMenu[0].side=1: IF (x+w) > ww THEN x=ww-w
			CASE 2			: cMenu[1].x=0: cMenu[1].y=0: cMenu[1].dx=1: cMenu[1].dy=1
									  'IF #cXOverlap=1 THEN #cXOverlap=0	EXIT FUNCTION
									  cMenu[1].status=1
										IF (cMenu[0].dx+w) > ww THEN x=cMenu[0].x-w-1
			CASE 3			: cMenu[2].x=0: cMenu[2].y=0:	cMenu[2].dx=1: cMenu[2].dy=1
										cMenu[2].status=1
										IF (ww-cMenu[1].dx) < w THEN
													x=cMenu[1].x-w-1
										'			IF (((x+w) > (cMenu[0].x)) AND ((y<cMenu[0].dy))) THEN x=cMenu[0].x-w-1 'AND ((y<cMenu[0].dy
										'ELSE
										'			IF (ww-cMenu[0].dx) < w THEN
										'						x=cMenu[1].x-w-1
										'			ELSE
										'						x=cMenu[1].dx+1
										'			'			IF x>cMenu[0].x THEN x=cMenu[0].dx+1
										'			END IF
										END IF
	END SELECT


	g=#cBuff

	SELECT CASE #cMenuType

			CASE 1		: XgrDrawBox (g, #cBorderColour2, 1, 1, w-1, h-1)
									XgrDrawBox (g, #cBorderColour, 0, 0, w, h)

			CASE 2		:	XgrDrawLine (g, $$Black, 0, h, w, h)
									XgrDrawLine (g, $$Black, w, h, w, 0)
									XgrDrawLine (g, #cBaseColour, 0, 0, w, 0)
									XgrDrawLine (g, #cBaseColour, 0, 0, 0, h)
									XgrDrawLine (g, $$Grey, 1, h-1, w-1, h-1)
									XgrDrawLine (g, $$Grey, w-1, h-1, w-1, 1)
									XgrDrawLine (g, $$White, 1, 1, w-1, 1)
									XgrDrawLine (g, $$White, 1, 1, 1, h-1)

			CASE 3		: XgrDrawBox (g, #cBaseColour, 1, 1, w-1, h-1)
									XgrDrawBox (g, #cBaseColour, 0, 0, w, h)

			CASE 4		:	XgrDrawLine (g, 0xF0ECEC00, 0, h, w, h)
									XgrDrawLine (g, 0xF0ECEC00, w, h, w, 0)
									XgrDrawLine (g, $$Grey, 0, 0, w, 0)
									XgrDrawLine (g, $$Grey, 0, 0, 0, h)

									XgrDrawLine (g, $$Black, 1, 1, w-1, 1)
									XgrDrawLine (g, $$Black, 1, 1, 1, h-1)
									XgrDrawLine (g, #cBaseColour, 1, h-1, w-1, h-1)
									XgrDrawLine (g, #cBaseColour, w-1, h-1, w-1, 1)

	END SELECT

	cy=2

	FOR pos = 0 TO UBOUND(Menu$[])

			IF pos=Highlight THEN
					co=#cHightlightBaseColour
					cColour=#cHightlightColour
			ELSE
					cColour=#cTextColour
					co=#cBaseColour
			END IF

			text$=Menu$[pos]

			IF RIGHT$(text$)=#cSubSelectChar$ THEN
						text$=RCLIP$ (text$)
						arrow=1
			ELSE
						arrow=0
			END IF

			XgrFillBox  (g, co, 2, cy, w-2, cy+#size)

			IF Menu$[pos]<>#cMenuSeperator$ THEN
						XgrMoveTo		(g, 6, cy+2)
						XgrDrawText (g, cColour, text$)
						IF arrow=1 THEN	XgrFillTriangle (g, cColour, $$LineStyleSolid, $$TriangleRight, w-8, cy+4, w-5, cy+#size-4)
			ELSE
						y2=cy+(#size*0.5)
						XgrDrawLine	(g, #cMenuSepBar1, 4, y2,w-4, y2)
						XgrDrawLine	(g, #cMenuSepBar2, 4, y2+1,w-4, y2+1)
			END IF

			cy=cy+#size

	NEXT pos

	IF (x+w) > ww THEN
				w=ww-x
		'		IF menu=1 THEN #cXOverlap=1
	END IF

	XgrDrawImage (#image,g, 0, 0, w, h, x, y)

	IF x < 0 THEN x=0
	IF y < 0 THEN y=0

	DEC menu
	cMenu[menu].x=x: cMenu[menu].y=y: cMenu[menu].dx=w+x: cMenu[menu].dy=h+y
	cMenu[menu].w=w: cMenu[menu].h=h
	cMenu[menu].dyReal=(h+y)

	XstKillTimer (cTimer)			' clear the menu if no selection is made (3secs)
	XstStartTimer (@cTimer ,1 ,2500,&tWakeUp ())
	T_Index=cTimer


END FUNCTION
'
'
' ################################
' #####  selectMenuArray ()  #####
' ################################
'
FUNCTION  selectMenuArray ()
	SHARED cMenuPos cMenu[]

	SELECT CASE cMenu[0].item
			CASE 0 				: XstCopyArray (@#cSubMenu1$[],@#cSubMenu$[])
										  cSubMenuWidth=#cSubMenu1Width: cSubMenuHeight=#cSubMenu1Height
			CASE 1 				: XstCopyArray (@#cSubMenu12$[],@#cSubMenu$[])
										  cSubMenuWidth=#cSubMenu12Width: cSubMenuHeight=#cSubMenu12Height
			CASE 2 				: XstCopyArray (@#cSubMenu5$[],@#cSubMenu$[])
										  cSubMenuWidth=#cSubMenu5Width: cSubMenuHeight=#cSubMenu5Height
			CASE 3 				: XstCopyArray (@#cSubMenu6$[],@#cSubMenu$[])
										  cSubMenuWidth=#cSubMenu6Width: cSubMenuHeight=#cSubMenu6Height
			CASE 4 				: XstCopyArray (@#cSubMenu11$[],@#cSubMenu$[])
										  cSubMenuWidth=#cSubMenu11Width: cSubMenuHeight=#cSubMenu11Height
			CASE 5 				: UpdateDataSlotMenu ()
											XstCopyArray (@#cSubMenu16$[],@#cSubMenu$[])
										  cSubMenuWidth=#cSubMenu16Width: cSubMenuHeight=#cSubMenu16Height
			CASE ELSE			: EXIT FUNCTION
	END SELECT

	DrawContextMenu (cMenu[0].dx+1, cMenu[0].y+(#size*cMenu[0].item), cSubMenuWidth, cSubMenuHeight+4, 2, @#cSubMenu$[], cMenu[1].item)

END FUNCTION
'
'
' ######################################
' #####  InitContextMenuArrays ()  #####
' ######################################
'
FUNCTION  InitContextMenuArrays ()
	SHARED cMenuPos cMenu[]
	SHARED CMENUITEM cmenu[]
	SHARED CMENUPOS  cmenuXY[]
	SHARED BaseMenu


	DIM cMenu[2]			'	3 menu levels, 0-1-2
	cMenu[0].olditem=255
	cMenu[0].item=255
	cMenu[0].status=0
	#cSubSelectChar$="."
	#cMenuSeperator$="-"

'	DIM #cMenu3$[0]

	DIM #cMenu$[5]
	#cMenu$[0]="File"+#cSubSelectChar$
	#cMenu$[1]="Display"+#cSubSelectChar$
	#cMenu$[2]="Scale"+#cSubSelectChar$
	#cMenu$[3]="Tools"+#cSubSelectChar$
	#cMenu$[4]="Help"+#cSubSelectChar$
	#cMenu$[5]="Data set"+#cSubSelectChar$
	#cMenuWidth=92

'	DIM #cSubMenu17$[1]
'	#cSubMenu17$[0]="Delete Image"+#cSubSelectChar$
'	#cSubMenu17$[1]="Select Image"+#cSubSelectChar$
'	#cSubMenu17Width=118


	DIM #cSubMenu16$[0]
	#cSubMenu16$[0]="#1"
	#cSubMenu16Width=140


	DIM #cSubMenu1$[6]
	#cSubMenu1$[0]="Open..."+#cSubSelectChar$
	#cSubMenu1$[1]="Quick Select"
	#cSubMenu1$[2]="Open next"
	#cSubMenu1$[3]="Open previous"
	#cSubMenu1$[4]="Save as.. "
	#cSubMenu1$[5]="Export.."+#cSubSelectChar$
	#cSubMenu1$[6]="Quit"
	#cSubMenu1Width=117

	DIM #cSubMenu15$[6]
'	#cSubMenu15$[0]="#1"
'	#cSubMenu15$[1]="#2"
'	#cSubMenu15$[2]="#3"
'	#cSubMenu15$[3]="#4"
'	#cSubMenu15$[4]="#5"
'	#cSubMenu15$[5]="#6"
'	#cSubMenu15$[6]="#7"
	#cSubMenu15Width=44

	DIM #cSubMenu2$[2]
	#cSubMenu2$[0]="This image"
	#cSubMenu2$[1]="All tracks"
	#cSubMenu2$[2]="All trks scaled"
	#cSubMenu2Width=132

	DIM #cSubMenu3$[5]
	#cSubMenu3$[0]="min max"
	#cSubMenu3$[1]="min 65535"
	#cSubMenu3$[2]="0 65535"
	#cSubMenu3$[3]="0 max"
	#cSubMenu3$[4]="customMin Max"
	#cSubMenu3$[5]="Image"
	#cSubMenu3Width=118

	DIM #cSubMenu4$[11]
	#cSubMenu4$[0]="1x"
	#cSubMenu4$[1]="2x"
	#cSubMenu4$[2]="3x"
	#cSubMenu4$[3]="4x"
	#cSubMenu4$[4]="5x"
	#cSubMenu4$[5]="6x"
	#cSubMenu4$[6]="7x"
	#cSubMenu4$[7]="8x"
	#cSubMenu4$[8]="9x"
	#cSubMenu4$[9]="10x"
	#cSubMenu4$[10]="20x"
	#cSubMenu4$[11]="50x"
	#cSubMenu4Width=36

	DIM #cSubMenu5$[5]
	#cSubMenu5$[0]="y"
	#cSubMenu5$[1]="x"
	#cSubMenu5$[2]="All"
	#cSubMenu5$[3]="Reset"
	#cSubMenu5$[4]="Autoscale"
	#cSubMenu5$[5]="Scale mode"+#cSubSelectChar$
	#cSubMenu5Width=105

	DIM #cSubMenu6$[7]
	#cSubMenu6$[0]="Menu bar"+#cSubSelectChar$
	#cSubMenu6$[1]="Tool bar"
	#cSubMenu6$[2]="blem beta"
	#cSubMenu6$[3]="Track cursor"
	#cSubMenu6$[4]="Benchmark"
	#cSubMenu6$[5]="Colour scheme"+#cSubSelectChar$
	#cSubMenu6$[6]="Menu style"+#cSubSelectChar$
	#cSubMenu6$[7]="View header"
	#cSubMenu6Width=128

	DIM #cSubMenu7$[3]
	#cSubMenu7$[0]="Maximize"
	#cSubMenu7$[1]="Minimize"
	#cSubMenu7$[2]="Last"
	#cSubMenu7$[3]="Iconize"
	#cSubMenu7Width=76

	DIM #cSubMenu8$[2]
	#cSubMenu8$[0]="Next"
	#cSubMenu8$[1]="Previous"
	#cSubMenu8$[2]="Default"
	#cSubMenu8Width=75

	DIM #cSubMenu9$[3]
	#cSubMenu9$[0]="Track"
	#cSubMenu9$[1]="Image bw"
	#cSubMenu9$[2]="Image clr-a" ' huh
	#cSubMenu9$[3]="Image clr-b"
	#cSubMenu9Width=100

	DIM #cSubMenu10$[5]
	#cSubMenu10$[0]="1"
	#cSubMenu10$[1]="2"
	#cSubMenu10$[2]="3"
	#cSubMenu10$[3]="4"
	#cSubMenu10$[4]="5"
	#cSubMenu10$[5]="Default"
	#cSubMenu10Width=68

	DIM #cSubMenu11$[1]
	#cSubMenu11$[0]="Help"
	#cSubMenu11$[1]="About"
	#cSubMenu11Width=53

	DIM #cSubMenu12$[4]
	#cSubMenu12$[0]="Mode"+#cSubSelectChar$
	#cSubMenu12$[1]="Zoom"+#cSubSelectChar$
	#cSubMenu12$[2]="Mouse Cursor"+#cSubSelectChar$
	#cSubMenu12$[3]="Pixel Cursor"+#cSubSelectChar$
	#cSubMenu12$[4]="Window Size"+#cSubSelectChar$
	#cSubMenu12Width=130

	DIM #cSubMenu13$[3]
	#cSubMenu13$[0]="Crosshair"
	#cSubMenu13$[1]="Large Cursor"
	#cSubMenu13$[2]="StarWars!"
	#cSubMenu13$[3]="Vertical Line"
'	#cSubMenu13$[4]="Default"
	#cSubMenu13Width=118

	DIM #cSubMenu14$[1]
	#cSubMenu14$[0]="Always On"
	#cSubMenu14$[1]="Auto"
	#cSubMenu14Width=90

	FOR menu=0 TO 2				' reset co-ords
			cMenu[menu].x=1: cMenu[menu].y=1: cMenu[menu].dx=2: cMenu[menu].dy=2
			cMenu[menu].w=2: cMenu[menu].h=2: cMenu[menu].dyReal=2
	NEXT menu



' new context menu

	DIM cmenu[3,]
	DIM cmenuXY[3]
'	XgrCreateFont (@#cMenuFont , @"System Default", 240, 200, 0, 0)


 cMenuCreate (@BaseMenu,$$CM_CT_Default)
  cMenuCreate (@File,$$CM_CT_Default)
	 cMenuCreate (@Open,$$CM_CT_Default)
	 cMenuCreate (@Export,$$CM_CT_Default)
  cMenuCreate (@Display,$$CM_CT_Default)
	 cMenuCreate (@Mode,$$CM_CT_Default)
	 cMenuCreate (@Zoom,$$CM_CT_Default)
	 cMenuCreate (@MouseCur,$$CM_CT_Default)
	 cMenuCreate (@PixelCur,$$CM_CT_Default)
	 cMenuCreate (@WindowSize,$$CM_CT_Default)
  cMenuCreate (@Scale,$$CM_CT_Default)
	 cMenuCreate (@ScaleMode, $$CM_CT_TypeA | $$CM_CT_Select)
  cMenuCreate (@Tools,$$CM_CT_Default)
  cMenuCreate (@Help,$$CM_CT_Default)
  cMenuCreate (@DataSet,$$CM_CT_Default)
   cMenuCreate (@DataSetSel,$$CM_CT_Default)
   cMenuCreate (@DataSetDel,$$CM_CT_Default)


 cMenuCreate (@#bm,$$CM_CT_TypeB)
 cMenuAddItem (#bm,-2,$$CM_TY_TopBrC,-1,-1,-1)
 cMenuAddItem (#bm,-1,&"test",-1,-1,99)
 cMenuAddItem (#bm,-1,&"1",-1,-1,100)
 cMenuAddItem (#bm,-1,&"3",-1,-1,101)
 cMenuAddItem (#bm,-2,$$CM_TY_BottomBrC,-1,-1,-1)


 topb=$$CM_TY_TopBrB
 bottomb=$$CM_TY_BottomBrB

 cMenuAddItem (BaseMenu,-2,topb,-1,-1,-1)
 cMenuAddItem (BaseMenu,-1,&"File",-1,File,-1)
 cMenuAddItem (BaseMenu,-1,&"Display",-1,Display,-1)
 cMenuAddItem (BaseMenu,-1,&"Scale",-1,Scale,-1)
 cMenuAddItem (BaseMenu,-1,&"Tools",-1,Tools,-1)
 cMenuAddItem (BaseMenu,-1,&"Help",-1,Help,-1)
 cMenuAddItem (BaseMenu,-2,$$CM_TY_HSepC,-1,-1,-1)
 cMenuAddItem (BaseMenu,-1,&"Data Set",-1,DataSet,-1)
 cMenuAddItem (BaseMenu,-2,bottomb,-1,-1,-1)

 cMenuAddItem (File,-2,topb,-1,-1,-1)
 cMenuAddItem (File,-1,&"Open...",BaseMenu,Open,-1)
 cMenuAddItem (File,-1,&"Quick Select",BaseMenu,-1,$$CM_ID_QLoad)
 cMenuAddItem (File,-1,&"Save As..",BaseMenu,-1,$$CM_ID_SaveAs)
 cMenuAddItem (File,-1,&"Export..",BaseMenu,Export,-1)
 cMenuAddItem (File,-2,$$CM_TY_HSepA,-1,-1,-1)
 cMenuAddItem (File,-1,&"Open Next",BaseMenu,-1,$$CM_ID_OFileNext)
 cMenuAddItem (File,-1,&"Open Last",BaseMenu,-1,$$CM_ID_OFileLast)
 cMenuAddItem (File,-2,$$CM_TY_HSepA,-1,-1,-1)
 cMenuAddItem (File,-1,&"Quit",BaseMenu,-1,$$CM_ID_Quit)
 cMenuAddItem (File,-2,bottomb,-1,-1,-1)

 cMenuAddItem (Export,-2,topb,-1,-1,-1)
 cMenuAddItem (Export,-1,&"This image",File,-1,$$CM_ID_ExpThisImage)
 cMenuAddItem (Export,-1,&"All tracks",File,-1,$$CM_ID_ExpAllTrks)
 cMenuAddItem (Export,-1,&"All tks Scd",File,-1,$$CM_ID_ExpAllTrksScaled)
 cMenuAddItem (Export,-2,bottomb,-1,-1,-1)

 cMenuAddItem (Open,-2,topb,-1,-1,-1)
 cMenuAddItem (Open,-1,&"New",File,-1,$$CM_ID_OFileNewSlot)
 cMenuAddItem (Open,-2,$$CM_TY_HSepA,-1,-1,-1)
 cMenuAddItem (Open,-1,&"#1",File,-1,$$CM_ID_OFileInSlot_1)
 cMenuAddItem (Open,-1,&"#2",File,-1,$$CM_ID_OFileInSlot_2)
 cMenuAddItem (Open,-1,&"#3",File,-1,$$CM_ID_OFileInSlot_3)
 cMenuAddItem (Open,-1,&"#4",File,-1,$$CM_ID_OFileInSlot_4)
 cMenuAddItem (Open,-1,&"#5",File,-1,$$CM_ID_OFileInSlot_5)
 cMenuAddItem (Open,-1,&"#6",File,-1,$$CM_ID_OFileInSlot_6)
 cMenuAddItem (Open,-1,&"#7",File,-1,$$CM_ID_OFileInSlot_7)
 cMenuAddItem (Open,-2,bottomb,-1,-1,-1)

 cMenuAddItem (Display,-2,topb,-1,-1,-1)
 cMenuAddItem (Display,-1,&"Mode",BaseMenu,Mode,-1)
 cMenuAddItem (Display,-1,&"Zoom",BaseMenu,Zoom,-1)
 cMenuAddItem (Display,-1,&"Mouse Cur",BaseMenu,MouseCur,-1)
 cMenuAddItem (Display,-1,&"Pixel Cur",BaseMenu,PixelCur,-1)
 cMenuAddItem (Display,-1,&"Window Size",BaseMenu,WindowSize,-1)
 cMenuAddItem (Display,-2,bottomb,-1,-1,-1)

 cMenuAddItem (Mode,-2,topb,-1,-1,-1)
 cMenuAddItem (Mode,-1,&"Track",Display,-1,$$CM_ID_DMode_Track)
 cMenuAddItem (Mode,-1,&"Image bw",Display,-1,$$CM_ID_DMode_ImageA)
 cMenuAddItem (Mode,-1,&"Image mode 1",Display,-1,$$CM_ID_DMode_ImageB)
 cMenuAddItem (Mode,-1,&"Image mode 2",Display,-1,$$CM_ID_DMode_ImageC)
 cMenuAddItem (Mode,-2,bottomb,-1,-1,-1)

 cMenuAddItem (Zoom,-2,topb,-1,-1,-1)
 cMenuAddItem (Zoom,-1,&"1x",Display,-1,$$CM_ID_Zoom_1)
 cMenuAddItem (Zoom,-1,&"2x",Display,-1,$$CM_ID_Zoom_2)
 cMenuAddItem (Zoom,-1,&"3x",Display,-1,$$CM_ID_Zoom_3)
 cMenuAddItem (Zoom,-1,&"4x",Display,-1,$$CM_ID_Zoom_4)
 cMenuAddItem (Zoom,-1,&"5x",Display,-1,$$CM_ID_Zoom_5)
 cMenuAddItem (Zoom,-1,&"6x",Display,-1,$$CM_ID_Zoom_6)
 cMenuAddItem (Zoom,-1,&"7x",Display,-1,$$CM_ID_Zoom_7)
 cMenuAddItem (Zoom,-1,&"8x",Display,-1,$$CM_ID_Zoom_8)
 cMenuAddItem (Zoom,-1,&"9x",Display,-1,$$CM_ID_Zoom_9)
 i=cMenuAddItem (Zoom,-1,&"10x",Display,-1,$$CM_ID_Zoom_10)
 cMenuAddItem (Zoom,-1,&"20x",Display,-1,$$CM_ID_Zoom_20)
 cMenuAddItem (Zoom,-1,&"50x",Display,-1,$$CM_ID_Zoom_50)
 cMenuAddItem (Zoom,-2,bottomb,-1,-1,-1)
	cMenuSetItemNoSelect (Zoom,i)

 cMenuAddItem (MouseCur,-2,topb,-1,-1,-1)
 cMenuAddItem (MouseCur,-1,&"Crosshair",Display,-1,$$CM_ID_MCur_CrossH)
 cMenuAddItem (MouseCur,-1,&"Cad",Display,-1,$$CM_ID_MCur_Cad)
 cMenuAddItem (MouseCur,-1,&"StarWars!",Display,-1,$$CM_ID_MCur_SWar)
 cMenuAddItem (MouseCur,-1,&"Vertical",Display,-1,$$CM_ID_MCur_Vertical)
 cMenuAddItem (MouseCur,-2,bottomb,-1,-1,-1)

 cMenuAddItem (PixelCur,-2,topb,-1,-1,-1)
 cMenuAddItem (PixelCur,-1,&"Crosshair",Display,-1,$$CM_ID_PCur_CrossH)
 cMenuAddItem (PixelCur,-1,&"Cad",Display,-1,$$CM_ID_PCur_Cad)
 cMenuAddItem (PixelCur,-1,&"StarWars!",Display,-1,$$CM_ID_PCur_SWar)
 cMenuAddItem (PixelCur,-1,&"Vertical",Display,-1,$$CM_ID_PCur_Vertical)
 cMenuAddItem (PixelCur,-2,bottomb,-1,-1,-1)

 cMenuAddItem (WindowSize,-2,topb,-1,-1,-1)
 cMenuAddItem (WindowSize,-1,&"Maximize",Display,-1,$$CM_ID_WinMax)
 cMenuAddItem (WindowSize,-1,&"Minimize",Display,-1,$$CM_ID_WinMin)
 cMenuAddItem (WindowSize,-1,&"Last",Display,-1,$$CM_ID_WinLast)
 cMenuAddItem (WindowSize,-1,&"Iconize",Display,-1,$$CM_ID_WinIcon)
 cMenuAddItem (WindowSize,-2,bottomb,-1,-1,-1)

 cMenuAddItem (Scale,-2,topb,-1,-1,-1)
 cMenuAddItem (Scale,-1,&"y",BaseMenu,-1,$$CM_ID_Scale_X)
 cMenuAddItem (Scale,-1,&"x",BaseMenu,-1,$$CM_ID_Scale_Y)
 cMenuAddItem (Scale,-1,&"All",BaseMenu,-1,$$CM_ID_Scale_All)
 cMenuAddItem (Scale,-1,&"Reset",BaseMenu,-1,$$CM_ID_Scale_Reset)
 cMenuAddItem (Scale,-1,&"Autoscale",BaseMenu,-1,$$CM_ID_Scale_Auto)
 cMenuAddItem (Scale,-1,&"Scale Mode",BaseMenu,ScaleMode,-1)
 cMenuAddItem (Scale,-2,bottomb,-1,-1,-1)

 cMenuAddItem (ScaleMode,-2,topb,-1,-1,-1)
 i=cMenuAddItem (ScaleMode,-1,&"min max",Scale,-1,$$CM_ID_SMode_MinMax)
 cMenuAddItem (ScaleMode,-1,&"min 65535",Scale,-1,$$CM_ID_SMode_Min65)
 cMenuAddItem (ScaleMode,-1,&"0 65535",Scale,-1,$$CM_ID_SMode_065)
 cMenuAddItem (ScaleMode,-1,&"0 max",Scale,-1,$$CM_ID_SMode_0Max)
 cMenuAddItem (ScaleMode,-1,&"Image",Scale,-1,$$CM_ID_SMode_Image)
 cMenuAddItem (ScaleMode,-1,&"Custom",Scale,-1,$$CM_ID_SMode_Custom)
 cMenuAddItem (ScaleMode,-1,&"Set Custom",Scale,-1,$$CM_ID_SMode_SetCustom)
 cMenuAddItem (ScaleMode,-2,bottomb,-1,-1,-1)
 cMenuSetItemSelected  (ScaleMode,i)

 cMenuAddItem (Tools,-2,topb,-1,-1,-1)
 cMenuAddItem (Tools,-1,&"Tool Bar",BaseMenu,-1,$$CM_ID_ToolBar)
 cMenuAddItem (Tools,-1,&"blem beta",BaseMenu,-1,$$CM_ID_Blem)
 cMenuAddItem (Tools,-1,&"Track Cur",BaseMenu,-1,$$CM_ID_TrackCur)
 cMenuAddItem (Tools,-1,&"Benchmark",BaseMenu,-1,$$CM_ID_Benchmark)
 cMenuAddItem (Tools,-1,&"View header",BaseMenu,-1,$$CM_ID_VHeader)
 cMenuAddItem (Tools,-2,bottomb,-1,-1,-1)

 cMenuAddItem (Help,-2,topb,-1,-1,-1)
 cMenuAddItem (Help,-1,&"Help",BaseMenu,-1,$$CM_ID_Help)
 cMenuAddItem (Help,-1,&"About",BaseMenu,-1,$$CM_ID_About)
 cMenuAddItem (Help,-2,bottomb,-1,-1,-1)

 cMenuAddItem (DataSet,-2,topb,-1,-1,-1)
 cMenuAddItem (DataSet,-1,&"Delete",BaseMenu,DataSetDel,$$CM_ID_MDelSlot)
 cMenuAddItem (DataSet,-2,$$CM_TY_HSepD,-1,-1,-1)
 cMenuAddItem (DataSet,-1,&"Select",BaseMenu,DataSetSel,$$CM_ID_MSelSlot)
 cMenuAddItem (DataSet,-2,bottomb,-1,-1,-1)

 cMenuAddItem (DataSetSel,-2,topb,-1,-1,-1)
 cMenuAddItem (DataSetSel,-1,&"#1",DataSet,-1,$$CM_ID_SelSlot)
 cMenuAddItem (DataSetSel,-2,bottomb,-1,-1,-1)

 cMenuAddItem (DataSetDel,-2,topb,-1,-1,-1)
 cMenuAddItem (DataSetDel,-1,&"#1",DataSet,-1,$$CM_ID_DelSlot)
 cMenuAddItem (DataSetDel,-2,bottomb,-1,-1,-1)

 #DataSet=DataSet
 #DataSetDel=DataSetDel
 #DataSetSel=DataSetSel



END FUNCTION
'
'
' #################################
' #####  selectMenu3Array ()  #####
' #################################
'
FUNCTION  selectMenu3Array ()
	SHARED cMenuPos cMenu[]
	STATIC drawmenu

	drawmenu=1

	SELECT CASE cMenu[0].item
			CASE 0 				:GOSUB fileMenu
			CASE 1 				:GOSUB displayMenu
			CASE 2 				:GOSUB scaleMenu
			CASE 3 				:GOSUB toolsMenu
			CASE 4 				:GOSUB helpMenu
'			CASE 5 				:GOSUB dsetMenu
			CASE ELSE			:EXIT FUNCTION
	END SELECT

	IF drawmenu=1 THEN DrawContextMenu (cMenu[1].dx+1,cMenu[1].y+(#size*cMenu[1].item), #cMenu3Width, #cMenu3Height+4, 3, @#cMenu3$[], cMenu[2].item)

EXIT FUNCTION

'#################
SUB dsetMenu
'#################


	SELECT CASE cMenu[1].item
			CASE 1,0			:XstCopyArray (@#cSubMenu16$[], @#cMenu3$[])
										#cMenu3Width=#cSubMenu16Width: #cMenu3Height=#cSubMenu16Height
	END SELECT


END SUB


'#################
SUB fileMenu
'#################

	SELECT CASE cMenu[1].item
			CASE 0			:XstCopyArray (@#cSubMenu15$[], @#cMenu3$[])
									#cMenu3Width=#cSubMenu15Width: #cMenu3Height=#cSubMenu15Height
			CASE 5			:XstCopyArray (@#cSubMenu2$[], @#cMenu3$[])
									#cMenu3Width=#cSubMenu2Width: #cMenu3Height=#cSubMenu2Height
			CASE ELSE		:drawmenu=0
	END SELECT

END SUB


'#################
SUB scaleMenu
'#################

	SELECT CASE cMenu[1].item
			CASE 5 				:XstCopyArray (@#cSubMenu3$[], @#cMenu3$[])
										#cMenu3Width=#cSubMenu3Width: #cMenu3Height=#cSubMenu3Height
			CASE ELSE			:drawmenu=0
	END SELECT
END SUB

'#################
SUB helpMenu
'#################

	SELECT CASE cMenu[1].item
			CASE 2 				:XstCopyArray (@#cSubMenu7$[], @#cMenu3$[])
										#cMenu3Width=#cSubMenu7Width: #cMenu3Height=#cSubMenu7Height
			CASE ELSE			:drawmenu=0
	END SELECT
END SUB

'#################
SUB displayMenu
'#################

	SELECT CASE cMenu[1].item
			CASE 0 				:XstCopyArray (@#cSubMenu9$[], @#cMenu3$[])
										#cMenu3Width=#cSubMenu9Width: #cMenu3Height=#cSubMenu9Height
			CASE 1 				:XstCopyArray (@#cSubMenu4$[], @#cMenu3$[])
										#cMenu3Width=#cSubMenu4Width: #cMenu3Height=#cSubMenu4Height
			CASE 2 				:XstCopyArray (@#cSubMenu13$[], @#cMenu3$[])
										#cMenu3Width=#cSubMenu13Width: #cMenu3Height=#cSubMenu13Height
			CASE 3 				:XstCopyArray (@#cSubMenu13$[], @#cMenu3$[])
										#cMenu3Width=#cSubMenu13Width: #cMenu3Height=#cSubMenu13Height
			CASE 4 				:XstCopyArray (@#cSubMenu7$[], @#cMenu3$[])
										#cMenu3Width=#cSubMenu7Width: #cMenu3Height=#cSubMenu7Height
			CASE ELSE			:drawmenu=0
	END SELECT
END SUB

'#################
SUB toolsMenu
'#################

	SELECT CASE cMenu[1].item
			CASE 0 				:XstCopyArray (@#cSubMenu14$[], @#cMenu3$[])
										#cMenu3Width=#cSubMenu14Width: #cMenu3Height=#cSubMenu14Height

			CASE 5 				:XstCopyArray (@#cSubMenu8$[], @#cMenu3$[])
										#cMenu3Width=#cSubMenu8Width: #cMenu3Height=#cSubMenu8Height
			CASE 6 				:XstCopyArray (@#cSubMenu10$[], @#cMenu3$[])
										#cMenu3Width=#cSubMenu10Width: #cMenu3Height=#cSubMenu10Height
			CASE ELSE			:drawmenu=0
	END SELECT
END SUB

END FUNCTION
'
'
' ##############################
' #####  setMenuStatus ()  #####
' ##############################
'
FUNCTION  setMenuStatus (r1,v0,v1)

	IF #ButtonMenuOn=1 THEN RETURN 0

	IF isInGrid (#hcover,r1,v0,v1) THEN
				return=1
				IF #ButtonMenu=0 THEN ShowButtonMenu (0)
	ELSE
				return=0
				IF #ButtonMenu=1 THEN HideButtonMenu (0)
	END IF

RETURN return

END FUNCTION
'
'
' ##################################
' #####  DrawSignalButtons ()  #####
' ##################################
'
FUNCTION  DrawSignalButtons () '(button)
	SHARED Image ImageFormat[]
	SHARED MemDataSet ImageDataSet[]

	STATIC start,bwidth,h,g

	g=#OutputG
	h=20
	bwidth=35
	totalImages=ImageFormat[#ImageSet,0].totalimages

'	clearSigBTarea ()

	SELECT CASE ImageDataSet[#ImageSet].currentImageBt  'button
			CASE 0			:	IF totalImages>4 THEN start=120: GOSUB DrawSelector: GOSUB DrawLeftBlank
										IF totalImages>3 THEN start=90: GOSUB DrawSelector: GOSUB DrawLeftBlank
										IF totalImages>2 THEN start=60: GOSUB DrawSelector: GOSUB DrawLeftBlank
										IF totalImages>1 THEN start=30: GOSUB DrawSelector: GOSUB DrawLeftBlank
										start=0:  GOSUB DrawSelector

			CASE 1			:	start=0:  GOSUB DrawSelector: GOSUB DrawRightBlank
										IF totalImages>4 THEN start=120: GOSUB DrawSelector: GOSUB DrawLeftBlank
										IF totalImages>3 THEN start=90: GOSUB DrawSelector: GOSUB DrawLeftBlank
										IF totalImages>2 THEN start=60: GOSUB DrawSelector: GOSUB DrawLeftBlank
										IF totalImages>1 THEN start=30: GOSUB DrawSelector

			CASE 2			:	IF totalImages>1 THEN start=30: GOSUB DrawSelector: GOSUB DrawLeftBlank: GOSUB DrawRightBlank
										start=0: 	GOSUB DrawSelector
										IF totalImages>4 THEN start=120: GOSUB DrawSelector: GOSUB DrawLeftBlank
										IF totalImages>3 THEN start=90: GOSUB DrawSelector: GOSUB DrawLeftBlank
										IF totalImages>2 THEN start=60: GOSUB DrawSelector

			CASE 3			:	IF totalImages>2 THEN start=60: GOSUB DrawSelector: GOSUB DrawLeftBlank: GOSUB DrawRightBlank
										IF totalImages>1 THEN start=30: GOSUB DrawSelector: GOSUB DrawLeftBlank
										start=0:  GOSUB DrawSelector
										IF totalImages>4 THEN start=120: GOSUB DrawSelector: GOSUB DrawLeftBlank
										IF totalImages>3 THEN start=90: GOSUB DrawSelector

			CASE 4			:	IF totalImages>3 THEN start=90: GOSUB DrawSelector: GOSUB DrawLeftBlank: GOSUB DrawRightBlank
										IF totalImages>2 THEN start=60: GOSUB DrawSelector: GOSUB DrawLeftBlank
										IF totalImages>1 THEN start=30: GOSUB DrawSelector: GOSUB DrawLeftBlank
										start=0:  GOSUB DrawSelector
										IF totalImages>4 THEN start=120: GOSUB DrawSelector

	END SELECT

' i removed the '3d' button effect and replcaed with the current flat button effect type
' to fall inline with this apps 'flat' theme.
' will re-enable later as

	pos=(totalImages*30)+18
'	XgrDrawLine (g, $$Black, start+5+bwidth, #v3-h+1, pos, #v3-h+1)
	XgrDrawLine (g, $$Grey , start+5+bwidth, #v3-h, pos, #v3-h)

	XgrDrawLine (g, $$Grey , start+4, #v3-h, 0, #v3-h)
'	XgrDrawLine (g, $$Black, start+4, #v3-h+1, 0, #v3-h+1)

	EXIT FUNCTION

'##################
SUB DrawLeftBlank
'##################

	XgrDrawLine (g, #background , start+5, #v3-h, start+8, #v3-6)

END SUB

'##################
SUB DrawRightBlank
'##################

	XgrDrawLine (g, #background , start+bwidth+2, #v3-6, start+bwidth+5, #v3-h+1)
	XgrDrawLine (g, #background , start+bwidth+2, #v3-6, start+bwidth+6, #v3-h+1)

'	XgrDrawLine (g, #background , start+bwidth+2, #v3-7, start+bwidth+4, #v3-h+1)

END SUB

'##################
SUB DrawSelector
'##################

	XgrDrawLine (g, $$Grey , start+5, #v3-h, start+9, #v3)
'	XgrDrawLine (g, $$Grey, start+bwidth, #v3 , start+bwidth+4, #v3-h+1)
	XgrDrawLine (g, $$Grey , start+bwidth+1, #v3, start+bwidth+5, #v3-h+1)

END SUB


END FUNCTION
'
'
' ################################
' #####  DrawToolsBorder ()  #####
' ################################
'
FUNCTION  DrawToolsBorder ()

	IF #cMenuType=2 THEN
			XgrDrawLine (#ToolsG, $$White,0,0,#toolw-1,0)
			XgrDrawLine (#ToolsG, $$Black,0,#toolh-1,#toolw-1,#toolh-1)
			XgrDrawLine (#ToolsG, $$White,0,0,0,#toolh-1)
			XgrDrawLine (#ToolsG, $$Black,#toolw-1,0, #toolw-1,#toolh-1)
	ELSE
			XgrDrawBox (#ToolsG, $$Black,0,0, #toolw-1, #toolh-1)
	END IF

END FUNCTION
'
'
' ###################################
' #####  SaveAllTracksAsBMP ()  #####
' ###################################
'
FUNCTION  SaveAllTracksAsBMP (filen$,scaled)
	SHARED Image ImageFormat[]
	SHARED cMenuPos cMenu[]
	SHARED TrackData TrackInfo[]
	UBYTE	 image[], buff[]
	SHARED SINGLE hh
	STATIC track,text$
	SHARED MemDataSet ImageDataSet[]


	IF ImageFormat[#ImageSet,#dataFile].NumberOfTracks<2 THEN EXIT FUNCTION

	g=#memBuffer
	#SaveImage=2
	display=#currentDisplay
	IF #currentDisplay=2 THEN XgrGetImage (g, @buff[])
	XstDecomposePathname (filen$, @path$, @parent$, @fn$, @file$, @Ext$)

	FOR track = 0 TO ImageFormat[#ImageSet,#dataFile].NumberOfTracks-1

				IF scaled=2 THEN GOSUB Scale

				DisplayTrack (track,0)
				XgrGetImage (g, @image[])

				XgrProcessMessages (0)

				bmpfile$=path$+"\\"+file$+"-track_"+STRING(track+1)+".bmp"
				XgrSaveImage (bmpfile$, @image[])

				fn$=file$+"-track_"+STRING(track+1)+Ext$
				SetLevelIndicator ("Save as "+Ext$, path$+"\\ ..\n"+fn$ , 0, ImageFormat[#ImageSet,#dataFile].NumberOfTracks-1, track)

			'	XgrProcessMessages (0)
				IF #error THEN error (text$)


	NEXT track

	#SaveImage=0
	#currentDisplay=display

	IF #currentDisplay=2 THEN
				XgrSetImage (g, @buff[])
	ELSE
				IF scaled=2 THEN AutoScale (#ImageSet,ImageDataSet[#ImageSet].Track)
				DisplayTrack (ImageDataSet[#ImageSet].Track,0)
	END IF



'##################
SUB Scale
'##################

	IF TrackInfo[0].valid=0 THEN ScaleAllTracksCalc (#ImageSet)
	ImageDataSet[#ImageSet].MinValue=TrackInfo[track].MinPoint
	ImageDataSet[#ImageSet].MaxValue=TrackInfo[track].MaxPoint

	checkMaxVvalue (@text$)
	setTrackVoffset (#ImageSet)

END SUB


END FUNCTION
'
'
' ##########################
' #####  LoadIcons ()  #####
' ##########################
'
FUNCTION  LoadIcons (file$)
	SHARED icontype icons[]
	UBYTE image[]

	XstDecomposePathname (file$, @path$, parent$, name$, file$, Ext$)
	IF #standalone=-1 THEN path$=path$+"\\images\\" ELSE path$="e:\\xb\\ii\\images\\"
	path$=path$+#themeLocation$+"\\"

Mbutton=46
DIM icons[Mbutton]	' not all buttons have an icon
icons[0].file="imagemode.bmp"
icons[1].file="right.bmp"
icons[2].file="left.bmp"
icons[4].file="updown.bmp"
icons[5].file="up.bmp"
icons[6].file="down.bmp"
icons[8].file="rscale.bmp"
icons[10].file="trackmode.bmp"
icons[11].file="max.bmp"
icons[12].file="linedot.bmp"
icons[13].file="cur.bmp"
icons[17].file="nextcol.bmp"
icons[18].file="goto.bmp"
icons[19].file="scale.bmp"
icons[20].file="open.bmp"
icons[21].file="recal.bmp"
icons[22].file="fi.bmp"
icons[23].file="toolbar.bmp"
'icons[24].file="exit.bmp"
icons[24].file="addt.bmp"
icons[25].file="zoomin.bmp"
icons[26].file="zoomout.bmp"
icons[28].file="left.bmp"
icons[27].file="right.bmp"
icons[29].file="bar.bmp"
icons[30].file="smallbox.bmp"
icons[36].file="box.bmp"
icons[37].file="close.bmp"
icons[31].file="ii.bmp"
icons[32].file="iismall.bmp"
icons[39].file="zoomin.bmp"
icons[40].file="zoomout.bmp"
icons[41].file="scaleright.bmp"
icons[42].file="scaleleft.bmp"
icons[44].file="scaleright.bmp"
icons[45].file="scaleleft.bmp"
icons[46].file="closeds.bmp"

FOR pos=0 TO Mbutton

	SELECT CASE pos
		CASE 0				: g=GetGridNumber  (#Output,10)
		CASE 31,32		: g=#IconWindowG
		CASE 41				: g=GetGridNumber  (#ModScaleMax,1)
		CASE 42				: g=GetGridNumber  (#ModScaleMax,2)
		CASE 44				: g=GetGridNumber  (#ModScaleMin,1)
		CASE 45				: g=GetGridNumber  (#ModScaleMin,2)
		CASE 46				: g=GetGridNumber  (#Output,44)
		CASE ELSE			:	g=GetGridNumber  (#Output,pos)
	END SELECT

	icons[pos].g=g
	file$=path$+icons[pos].file

	IFZ XgrLoadImage (@file$, @image[]) THEN

				len=UBOUND(image[])
				icons[pos].length=len
				icons[pos].active=1
				from=&image[]
				to=&icons[pos].icon[]
				XstCopyMemory (from,to,len)

	END IF

NEXT pos


END FUNCTION
'
'
' ###########################
' #####  RedrawIcon ()  #####
' ###########################
'
FUNCTION  RedrawIcon (pos)
	SHARED icontype icons[]
	STATIC UBYTE image[]
	STATIC	oldtheme

	len=icons[pos].length
	IF len<100 THEN EXIT FUNCTION
	IF len>$$MaxIconSize THEN EXIT FUNCTION
	IFZ image[] THEN DIM image[$$MaxIconSize]

	from=&icons[pos].icon[]
	to=&image[]

	XstCopyMemory (from,to,len)
	XgrSetImage (icons[pos].g, @image[])


END FUNCTION
'
'
' ################################
' #####  SetProgramTitle ()  #####
' ################################
'
FUNCTION  SetProgramTitle (title$)
	SHARED MemDataSet ImageDataSet[]
	NOTIFYICONDATA nid

	IF title$="" THEN	title$=ImageDataSet[#ImageSet].dsTitleL

	IF LEN(title$) > 20 THEN			' suppose this depends on the end users system font width
				XstDecomposePathname (title$, path$, parent$, @txt$, file$, Ext$)
	ELSE
				txt$=title$
	END IF

	XuiSendMessage (#Output, #SetWindowTitle, 0, 0, 0, 0, 0, txt$)
	XuiSendMessage (#IconWindow, #SetWindowTitle, 0, 0, 0, 0, 0, txt$)


END FUNCTION
'
'
' #############################
' #####  XfiSaveImage ()  #####
' #############################
'
FUNCTION  XfiSaveImage (fileName$, UBYTE image[], type, fileNameExt$)

	IFZ fileName$ THEN RETURN 0
	IFZ image[] THEN RETURN 0
	IFZ type THEN RETURN 0

'Save image as temporary bmp temp.bmp
	XstGetCurrentDirectory (@directory$)
	tempFile$ = directory$ + $$PathSlash$ + "temp.bmp"
	XgrSaveImage (tempFile$, @image[])

'Load FI BMP
	dib = FreeImage_LoadBMP(&tempFile$, 0)
	IFZ dib THEN RETURN 0	ELSE XstDeleteFile (tempFile$)

	SELECT CASE type
		CASE 1  : ret = FreeImage_SaveBMP (dib, &fileName$, 0)
		CASE 2  : ret = FreeImage_SavePNG (dib, &fileName$, 0)
		CASE 3  : ret = FreeImage_SaveTIFF (dib, &fileName$, 0)
		CASE 4  : ret = FreeImage_SavePNM (dib, &fileName$, 0)
		CASE 5  : ret = FreeImage_SaveJPEG (dib, &fileName$, 85)			' take value from inifile

'		CASE 5  : ret = FreeImage_SavePNM (dib, &fileName$, 0)
'		CASE 6  : ret = FreeImage_SavePNM (dib, &fileName$, 0)
	END SELECT


'Release image from memory
	FreeImage_Unload(dib)

'	fileNameExt$=fileName$

	IFZ ret THEN RETURN 0 ELSE RETURN 1

END FUNCTION
'
'
' ############################
' #####  GetDIBImage ()  #####
' ############################
'
FUNCTION  GetDIBImage (track)
	SHARED UBYTE image[]

	g=#memBuffer

	IF #currentDisplay=1 THEN
				#SaveImage=2
				DisplayTrack (track,0)
				XgrGetImage (g, @image[])
				#SaveImage=0
				DisplayTrack (track,0)
	ELSE
				XgrGetImage (g, @image[])
	END IF


END FUNCTION
'
'
' ##############################
' #####  SaveAllToType ()  #####
' ##############################
'
FUNCTION  SaveAllToType (filen$,type,mode)
	SHARED UBYTE image[]
	SHARED Image ImageFormat[]
	SHARED MemDataSet ImageDataSet[]
	SHARED SINGLE	hh
	SHARED cMenuPos cMenu[]
	SHARED TrackData TrackInfo[]
	UBYTE buff[]
	STATIC  track,text$
	SHARED type$

	IF ImageFormat[#ImageSet,#dataFile].NumberOfTracks<2 THEN EXIT FUNCTION

	g=#memBuffer
	#SaveImage=2
	display=#currentDisplay

	IF #currentDisplay=2 THEN XgrGetImage (g, @buff[])
	XstDecomposePathname (filen$, @path$, @parent$, @fn$, @file$, @Ext$)

	FOR track = 0 TO ImageFormat[#ImageSet,#dataFile].NumberOfTracks-1

				IF mode=2 THEN GOSUB Scale

				DisplayTrack (track,0)
				XgrGetImage (g, @image[])

				XgrProcessMessages (0)

				fn$=path$+"\\"+file$+"-track_"+STRING(track+1)+Ext$
				XfiSaveImage (@fn$,  @image[], type, @fileNameExt$)

			'	ext$=RIGHT$(fileNameExt$,3)
				fn$=file$+"-track_"+STRING(track+1)+Ext$
				SetLevelIndicator ("Save as "+Ext$, path$+"\\ ..\n"+fn$ , 0, ImageFormat[#ImageSet,#dataFile].NumberOfTracks-1, track)

				IF #error THEN error (text$)

	NEXT track

	XuiSendMessage (#LevelIndicator ,#HideWindow,0,0,0,0,0,0)

	#SaveImage=0
	#currentDisplay=display

	IF #currentDisplay=2 THEN
				XgrSetImage (g, @buff[])
	ELSE
				IF item=2 THEN AutoScale (#ImageSet,ImageDataSet[#ImageSet].Track)
				DisplayTrack (ImageDataSet[#ImageSet].Track,0)
	END IF

EXIT FUNCTION



'##################
SUB Scale
'##################

	IF TrackInfo[0].valid=0 THEN ScaleAllTracksCalc (#ImageSet)
	ImageDataSet[#ImageSet].MinValue=TrackInfo[track].MinPoint
	ImageDataSet[#ImageSet].MaxValue=TrackInfo[track].MaxPoint

	checkMaxVvalue (@text$)
	setTrackVoffset (#ImageSet)

END SUB


END FUNCTION
'
'
' ##################################
' #####  SetLevelIndicator ()  #####
' ##################################
'
FUNCTION  SetLevelIndicator (title$, label$ ,min, max, pos)
	STATIC SINGLE w2,w,h

	IF #LevelIndicatorStatus=0 THEN
				XuiSendMessage (#LevelIndicator, #DisplayWindow,0,0,0,0,0,0)
				XuiSendMessage (#LevelIndicator, #SetWindowTitle, 0, 0, 0, 0, 0, title$)
				XgrGetGridPositionAndSize (#lBase, x, y, @w, @h): h=h-2
				XgrSetSelectedWindow (#LevelIndicatorWindow)
	END IF

	XuiSendMessage (#LevelIndicator,#SetTextString,0,0,0,0,2,@label$)
	XuiSendMessage (#LevelIndicator,#Redraw,0,0,0,0,2 ,0)

	w2=((w/(max-min))*pos)-2
	XgrFillBox (#lBase, $$Blue, 1, 1, w2, h)

END FUNCTION
'
'
' ###############################
' #####  InitStandalone ()  #####
' ###############################
'
FUNCTION  InitStandalone ()

	IF #standalone=-1 THEN				' are we being executed from the IDE or not
				ParseCommandLineA (@file$,@cmd$)
	ELSE
				InitNonStandalone (#os)
	END IF


END FUNCTION
'
'
' ############################
' #####  InitDisplay ()  #####
' ############################
'
FUNCTION  InitDisplay ()
	SHARED SINGLE ww,hh,xx,yy
	SHARED cur
	SHARED Image ImageFormat[]
	SHARED TrackData TrackInfo[]
	SHARED TrackData TrackInfoCopy[]

	cur=(ImageFormat[#ImageSet,#dataFile].NumberOfPixels/2)-1		' set inital cursor position to middle of track
	AutoScaleAll (#ImageSet)
	XstCopyArray (@TrackInfo[],@TrackInfoCopy[]) ' back up

	ResizeWindows ()

	IF #currentDisplay=1 THEN	InitDisplay2dH ()	ELSE InitDisplayImage ()
	BuffMenuBotton ()
	IF #ButtonMenu=1 THEN ShowButtonMenu (0)

	IFZ #standalone=-1 THEN
			PRINT "OS:"+#os$+" "+#version$+"\n"+"CPU:"+#cpu$+"\n"+"data file "+#fil$
			PRINT "Pixels:"+STRING$(ImageFormat[#ImageSet,#dataFile].NumberOfPixels),"Tracks:"+STRING$(ImageFormat[#ImageSet,#dataFile].NumberOfTracks)
			PRINT "ww="+STRING$(ww)+" hh="+STRING$(hh)
			PRINT STRING(#NumberOfFiles+1)+" other data files found\n"
	END IF

'	XgrSetSelectedWindow (#OutputWindow)
	SetFocusOnGrid (#image)


END FUNCTION
'
'
' ###############################
' #####  InitDisplay2dH ()  #####
' ###############################
'
FUNCTION  InitDisplay2dH ()
	SHARED TrackData TrackInfo[]
	SHARED MemDataSet ImageDataSet[]

	ImageDataSet[#ImageSet].MaxValue=TrackInfo[ImageDataSet[#ImageSet].Track-1].MaxPoint
	ImageDataSet[#ImageSet].MinValue=TrackInfo[ImageDataSet[#ImageSet].Track-1].MinPoint
	#MinSize=1

	setTrackVoffset (#ImageSet)
	setSigBtLabels ()
	disableUnusedBts ()
'	XuiSendMessage (#Output,#Redraw, 0, 0, 0, 0, 43, 0)
	DisplayTrack (ImageDataSet[#ImageSet].Track,0)

	#MinSize=0
	XuiSendMessage (#Output, #Redraw, 0, 0, 0, 0, 0, 0)
	OpenMainDispWin ()
'	uDisplayShowWindow (#ImageSet,0)

END FUNCTION
'
'
' #################################
' #####  InitDisplayImage ()  #####
' #################################
'
FUNCTION  InitDisplayImage ()

	#MinSize=1

	ScaleRange()
	SwitchToImage ()

	#copyImage=0
	#clearO1=1
	#clearGrid=0
'	GetNewImage (#image,1,0,1)
	DrawInfo()

	OpenMainDispWin ()
	disableUnusedBts ()
	setSigBtLabels ()
	clearSigBTarea ()
	XuiSendMessage (#Output,#Redraw, 0, 0, 0, 0, 43, 0)

	FOR bt=31 TO 35
			XuiSendMessage (#Output,#Redraw, 0, 0, 0, 0, bt, 0)
	NEXT bt

	DrawOutputBorders ()
	DrawSignalButtons ()

	#MinSize=0
	#copyImage=1
	#clearO1=0


END FUNCTION
'
'
' #############################
' #####  PlaceToolbar ()  #####
' #############################
'
FUNCTION  PlaceToolbar ()

	IFZ #ToolMenuBottonState THEN EXIT FUNCTION

	XgrGetWindowPositionAndSize (#OutputWindow, @x, @y, @w, @h)
	IF w<(#Minxx-50) THEN w=(#Minxx-50)
	IF h<#Minyy THEN h=#Minyy

	SELECT CASE #Tdock
		CASE 1					:XgrSetWindowPositionAndSize (#ToolsWindow, x+#tx,y+#ty, -1,-1)
		CASE 2					:XgrSetWindowPositionAndSize (#ToolsWindow, x, y+h+5, w,-1):	#tx=2: #ty=#v3+5: DrawToolsBorder ()
		CASE 3					:XgrSetWindowPositionAndSize (#ToolsWindow, x, y-27, w,-1): #tx=2: #ty=-27: DrawToolsBorder ()
	END SELECT

END FUNCTION
'
'
' #########################
' #####  isInGrid ()  #####
' #########################
'
FUNCTION  isInGrid (grid,r1,v0,v1)		'	(target grid, mouse is in this grid, mouse x, mouse y)

'	IF grid<>r1 THEN EXIT FUNCTION

	XgrGetGridPositionAndSize (grid, @gridx, @gridy, @gridw, @gridh)
	XgrConvertLocalToWindow (r1, v0, v1, @x, @y)

	IF ((x>gridx) AND (x< (gridx+gridw)) AND (y>gridy) AND (y< (gridy+gridh))) THEN
				RETURN 1
	ELSE
				RETURN 0
	END IF


END FUNCTION
'
'
' #####################################
' #####  ResizeImageBuffGrids ()  #####
' #####################################
'
FUNCTION  ResizeImageBuffGrids ()
	SHARED Image ImageFormat[]
	SHARED SINGLE ww,hh

IF #currentDisplay=1 THEN

			IF ((hh<>#imagehh) OR (ww<>#imageww)) THEN

						hh=#imagehh
						ww=#imageww

						XgrSetGridPositionAndSize (#memBuffer, 0, 0, ww+1, hh+1)	' memory image
						XuiSendMessage (#OutputG, #Resize, #leftmargin, #topmargin, ww+1, hh+1, 7, 0)	' $Label/#image

			ELSE
					 EXIT FUNCTION
			END IF

ELSE

			vh=(ImageFormat[#ImageSet,#dataFile].NumberOfTracks-1)*#row
			vw=(ImageFormat[#ImageSet,#dataFile].NumberOfPixels-1)*#col
			IF vh>#imagehh THEN vh=#imagehh
			IF vw>#imageww THEN vw=#imageww

			IF ((vh<>hh) OR (vw<>ww)) THEN
						IF ((vh < (hh-1)) OR (vw < (ww-1))) THEN
									XgrClearGrid(#image,#background)
									clearImageBorder (ww,hh)
						END IF

						hh=vh
						ww=vw

						XgrSetGridPositionAndSize (#memBuffer, 0, 0, ww+1, hh+1)	' memory image
						XuiSendMessage (#OutputG, #Resize, #leftmargin, #topmargin, ww+1, hh+1, 7, 0)	' $Label/#image

						drawImageBorder (#borderColour)

			END IF

END IF


END FUNCTION
'
'
' ##########################
' #####  ColourBar ()  #####		' ..i hurried for a name
' ##########################
'
FUNCTION  ColourBar (min,max)
	SHARED argb rgb[]
	SINGLE w,dw,x
	STATIC oldimageMode


g=#hColbarBuff
IF ((#imageMode<>oldimageMode) OR (#vbarRedraw=1)) THEN

		IF #vbarRedraw=1 THEN XgrClearGrid (g,#background)
		#vbarRedraw=0
		oldimageMode=#imageMode
		x=0
		y=0
		h=10
		w=#v2-#leftmargin-#rightmargin
		w1=w

		SELECT CASE #imageMode

			CASE 3
					w=w/37
					col=(65535/255)

					FOR a=1 TO 37

								red=rgb[a].red*col
								green=rgb[a].green*col
								blue=rgb[a].blue*col

								XgrSetDrawingRGB (g,red,green,blue)
								XgrFillBox (g,-1,x,y,x+w,y+h)
								x=x+w
								IF ((x+w) > (#v2-#leftmargin-#rightmargin+5)) THEN EXIT FOR

					NEXT a

			CASE 2
					w=w/125

					FOR col=0 TO 124

								XgrFillBox(g,col,x,y,x+w,y+h)
								x=x+w
								IF ((x+w)> (#v2-#leftmargin-#rightmargin+1)) THEN EXIT FOR
					NEXT col

			CASE 1
					dw=SINGLE(65535)/w: IF dw<10 THEN dw=10

					FOR col=1 TO 65535 STEP dw

								XgrSetDrawingRGB (g, col, col, col)
								XgrDrawLine(g,-1,x,y,x,y+h)
								x=x+1
								IF (x > (#v2-#leftmargin-#rightmargin)) THEN EXIT FOR
					NEXT col

		END SELECT

END IF

XgrCopyImage (#colourbarea,g)
ColourBarLabel (#MaxVi!-#MinVi!)


END FUNCTION
'
'
' ############################
' #####  SnapToImage ()  #####
' ############################
'
FUNCTION  SnapToImage ()
	SHARED Image ImageFormat[]
	SHARED SINGLE hh,ww

	XgrGetWindowPositionAndSize (#OutputWindow, @x, @y, @w, @h)
	pos=25

	IF #currentDisplay=2 THEN

				top=ImageFormat[#ImageSet,#dataFile].top
				IF (ImageFormat[#ImageSet,#dataFile].NumberOfTracks*#row) > top THEN h=((top-1)*#row) ELSE h=(ImageFormat[#ImageSet,#dataFile].NumberOfTracks*#row)

				h=h+#defaultBottomI
				w=(ImageFormat[#ImageSet,#dataFile].NumberOfPixels*#col)+#leftmargin+#rightmargin+8

				y=(#displayHeight-h)/2
				x=(#displayWidth-w)/2

				IF ((y+h) > (#displayHeight-100)) THEN h=#displayHeight-100				' dont overlap taskbar
				IF ((x+w) > (#displayWidth-50)) THEN w=#displayWidth-50						' desktop is still one click away

	ELSE
				x=pos
				y=pos
				w=#displayWidth-(pos*2)
				h=#displayHeight-50-(pos*2)

	END IF

	IF x<pos THEN x=pos
	IF y<pos THEN y=pos


	#MaxSstate=0
	XgrGetWindowPositionAndSize (#OutputWindow, @#Xpos, @#Ypos, @#WidthOld, @#HeightOld)
	XgrSetWindowPositionAndSize (#OutputWindow,x,y,w,h)
	'CentreWindow (#OutputWindow)


END FUNCTION
'
'
' ##################################
' #####  CreateColourTable ()  #####
' ##################################
'
FUNCTION  CreateColourTable ()
	SHARED argb rgb[]

 DIM rgb[37]
' this could be reduced to a few lines.


 rgb[0].red=0: rgb[0].green=0: rgb[0].blue=0 					' 0,0,0
 rgb[1].red=0: rgb[1].green=0: rgb[1].blue=20 				' 0,0,0
 rgb[2].red=0: rgb[2].green=0: rgb[2].blue=45 				' 0,0,30
 rgb[3].red=0: rgb[3].green=0: rgb[3].blue=75 				' 0,0,70
 rgb[4].red=0: rgb[4].green=0: rgb[4].blue=100 				' 0,0,100
 rgb[5].red=0: rgb[5].green=0: rgb[5].blue=140 				' 0,0,140
 rgb[6].red=0: rgb[6].green=0: rgb[6].blue=170 				' 0,0,170
 rgb[7].red=0: rgb[7].green=0: rgb[7].blue=210 				' 0,0,210
 rgb[8].red=0: rgb[8].green=0: rgb[8].blue=240 				' 0,0,240
 rgb[9].red=0: rgb[9].green=15: rgb[9].blue=230 			' 0,15,230
 rgb[10].red=0: rgb[10].green=39: rgb[10].blue=190 		' 0,39,190
 rgb[11].red=0: rgb[11].green=57: rgb[11].blue=160 		' 0,57,160
 rgb[12].red=0: rgb[12].green=81: rgb[12].blue=120 		' 0,81,120
 rgb[13].red=0: rgb[13].green=99: rgb[13].blue=90 		' 0,99,90
 rgb[14].red=0: rgb[14].green=123: rgb[14].blue=50 		' 0,123,50
 rgb[15].red=0: rgb[15].green=141: rgb[15].blue= 20		' 0,141,20
 rgb[16].red=20: rgb[16].green=141: rgb[16].blue=0 		' 20,141,0
 rgb[17].red=50: rgb[17].green=124: rgb[17].blue=0 		' 50,123,0
 rgb[18].red=90: rgb[18].green=99: rgb[18].blue=0 		' 90,99,0
 rgb[19].red=100: rgb[19].green=93: rgb[19].blue=0 		' 100,93,0
 rgb[20].red=140: rgb[20].green=69: rgb[20].blue=0 		' 140,69,0
 rgb[21].red=175: rgb[21].green=48: rgb[21].blue=0 		' 175,48,0
 rgb[22].red=215: rgb[22].green=24: rgb[22].blue=0 		' 215,24,0
 rgb[23].red=250: rgb[23].green=3: rgb[23].blue=0 		' 250,3,0
 rgb[24].red=255: rgb[24].green=35: rgb[24].blue=0 		' 255,35,0
 rgb[25].red=255: rgb[25].green=75: rgb[25].blue=0 		' 255,75,0
 rgb[26].red=255: rgb[26].green=110: rgb[26].blue=0 	' 255,110,0
 rgb[27].red=255: rgb[27].green=150: rgb[27].blue=0 	' 255,150,0
 rgb[28].red=255: rgb[28].green=195: rgb[28].blue=0 	' 255,195,0
 rgb[29].red=255: rgb[29].green=230: rgb[29].blue=0 	' 255,230,0
 rgb[30].red=255: rgb[30].green=255: rgb[30].blue=15 	' 255,255,15
 rgb[31].red=255: rgb[31].green=255: rgb[31].blue=50 	' 255,255,50
 rgb[32].red=255: rgb[32].green=255: rgb[32].blue=90 	' 255,255,90
 rgb[33].red=255: rgb[33].green=255: rgb[33].blue=125 ' 255,255,125
 rgb[34].red=255: rgb[34].green=255: rgb[34].blue=160	' 255,255,165
 rgb[35].red=255: rgb[35].green=255: rgb[35].blue=200 ' 255,255,205
 rgb[36].red=255: rgb[36].green=255: rgb[36].blue=230
 rgb[37].red=255: rgb[37].green=255: rgb[37].blue=255

END FUNCTION
'
'
' ###############################
' #####  ColourBarLabel ()  #####
' ###############################
'
FUNCTION  ColourBarLabel (m)
	SINGLE max,min

g=#OutputG
XgrSetGridFont (g,#valfont)

max=#MaxVi!
min=#MinVi!

h=10
y=41
w1=#v2-#leftmargin-#rightmargin
x1=#leftmargin
maxx=x1+w1-20
minx=#leftmargin

max$=STRING$(Round(max,1.0))
min$=STRING$(Round (min,1.0))

XgrFillBox (g, #background, minx-1, y+1, maxx+60,y+h+1)

text$=STRING$(Round (max, 0.1))
XgrMoveTo (g,maxx,y)
XgrDrawTextFill (g, #ink, max$)

XgrMoveTo (g,minx,y)
XgrDrawTextFill (g, #ink, min$)

x=((maxx-minx)*0.5)+#leftmargin
XgrMoveTo (g,x,y)
text$=STRING$(Round (((max-min)*0.5)+min, 0.1))
XgrDrawTextFill (g, #ink, text$)

x=((maxx-minx)*0.25)+#leftmargin
XgrMoveTo (g,x,y)
text$=STRING$(Round (((max-min)*0.25)+min, 0.1))
XgrDrawTextFill (g, #ink, text$)

x=((maxx-minx)*0.75)+#leftmargin
XgrMoveTo (g,x,y)
text$=STRING$(Round (((max-min)*0.75)+min, 0.1))
XgrDrawTextFill (g, #ink, text$)

END FUNCTION
'
'
' #############################
' #####  GetMaxVvalue ()  #####
' #############################
'
FUNCTION GetMaxVvalue ()
	SHARED TrackData TrackInfo[]
'	SHARED SINGLE hh

'	IF hh<1 THEN hh=1
'	v!=(#vinfo+hh)*(ImageDataSet[#ImageSet].MaxValue/hh)

	IF TrackInfo[0].valid=0 THEN ScaleAllTracksCalc (#ImageSet)

	RETURN  TrackInfo[#maxTrack].MaxPoint

END FUNCTION
'
'
' ##################################
' #####  CreateDib24Header ()  #####
' ##################################
'
FUNCTION  CreateDib24Header (width,height,len,UBYTE image[])
	STATIC oldlen

	info = 14
	dataOffset=54
	len=(width*3)*(height+1)

	IF len<>oldlen THEN
				oldlen=len
				DIM image[len]
				image[0]='B'
				image[1]='M'
				image[2] = len AND 0x00FF								' file size
				image[3] = (len >> 8) AND 0x00FF
				image[4] = (len >> 16) AND 0x00FF
				image[5] = (len >> 24) AND 0x00FF
				image[6] = 0
				image[7] = 0
				image[8] = 0
				image[9] = 0
				image[info+0] = 40													' XLONG : BITMAPINFOHEADER size
				image[info+1] = 0
				image[info+2] = 0
				image[info+3] = 0
				image[info+12] = 1													' USHORT : # of planes
				image[info+13] = 0
				image[info+14] = 24													' USHORT : bits per pixel
				image[info+15] = 0
				image[info+16] = 0													' XLONG : 32-bit bitfield RGB
				image[info+17] = 0
				image[info+18] = 0
				image[info+19] = 0
				image[info+20] = 0													' XLONG : size image
				image[info+21] = 0
				image[info+22] = 0
				image[info+23] = 0
				image[info+24] = 0													' XLONG : xPPM
				image[info+25] = 0
				image[info+26] = 0
				image[info+27] = 0
				image[info+28] = 0													' XLONG : yPPM
				image[info+29] = 0
				image[info+30] = 0
				image[info+31] = 0
				image[info+32] = 0													' XLONG : clrUsed
				image[info+33] = 0
				image[info+34] = 0
				image[info+35] = 0
				image[info+36] = 0													' XLONG : clrImportant
				image[info+37] = 0
				image[info+38] = 0
				image[info+39] = 0
	END IF

	image[10] = dataOffset AND 0x00FF						' file offset of bitmap data
	image[11] = (dataOffset >> 8) AND 0x00FF
	image[12] = (dataOffset >> 16) AND 0x00FF
	image[13] = (dataOffset >> 24) AND 0x00FF
	image[info+4] = width AND 0x00FF						' XLONG : width in pixels
	image[info+5] = (width >> 8) AND 0x00FF
	image[info+6] = (width >> 16) AND 0x00FF
	image[info+7] = (width >> 24) AND 0x00FF
	image[info+8] = height AND 0x00FF						' XLONG : height in pixels
	image[info+9] = (height >> 8) AND 0x00FF
	image[info+10] = (height >> 16) AND 0x00FF
	image[info+11] = (height >> 24) AND 0x00FF


END FUNCTION
'
'
' ##############################
' #####  SwitchToTrack ()  #####
' ##############################
'
FUNCTION  SwitchToTrack ()
	SHARED MemDataSet ImageDataSet[]
	SHARED ww


			XuiSendMessage (#Output,#Disable,0,0,0,0,25,0)	' $zoomin
			XuiSendMessage (#Output,#Disable,0,0,0,0,26,0)	' $zoomout
			XuiSendMessage (#Output,#Disable,0,0,0,0,27,0)	' $incrase x
			XuiSendMessage (#Output,#Disable,0,0,0,0,28,0)	' $decrase x
			XuiSendMessage (#Output,#Disable,0,0,0,0,38,0)	' $colourbar
			XuiSendMessage (#Output,#Disable,0,0,0,0,41,0)	'
			XuiSendMessage (#Output,#Disable,0,0,0,0,42,0)	'

			XuiSendMessage (#Output,#Enable,0,0,0,0,39,0)	' $colourbar
			XuiSendMessage (#Output,#Enable,0,0,0,0,40,0)	' $colourbar

			XgrHideWindow (#ModScaleMinWindow)
			XgrHideWindow (#ModScaleMaxWindow)


			#currentDisplay=1
			ImageDataSet[#ImageSet].MaxValue=#MaxVi!
			ImageDataSet[#ImageSet].MinValue=#MinVi!

			ResizeImageBuffGrids ()
			DataTrackImageCheck ()

			IF #topmargin<>#defaultTop THEN
						ResizeWindows ()
						XgrClearGrid (#memBuffer,#background)
			END IF

			XuiSendMessage (#Output,#Resize, #leftmargin-1, #topmargin-19, ww-95, 18, 43, 0)
			setTrackVoffset (#ImageSet)

			XuiSendMessage (#Output,#Redraw,0,0,0,0,0,0)

END FUNCTION
'
'
' #############################
' #####  CloseConsole ()  #####
' #############################
'
FUNCTION CloseConsole ()

	XstGetConsoleGrid(@ConsoleGrid)
	XuiSendMessage(ConsoleGrid, #HideWindow,0,0,0,0,0,0)

END FUNCTION
'
'
' ############################
' #####  OpenConsole ()  #####
' ############################
'
FUNCTION  OpenConsole ()

	XstGetConsoleGrid(@ConsoleGrid)
	XuiSendMessage(ConsoleGrid, #DisplayWindow,0,0,0,0,0,0)

END FUNCTION
'
'
' ######################
' #####  error ()  #####
' ######################
'
FUNCTION  error (text$)

	#error=0
	Prints (text$,1)

END FUNCTION
'
'
' ###############################
' #####  checkMaxVvalue ()  #####
' ###############################
'
FUNCTION  checkMaxVvalue (text$)
	SHARED MemDataSet ImageDataSet[]

EXIT FUNCTION

	IF (ImageDataSet[#ImageSet].MaxValue<=ImageDataSet[#ImageSet].MinValue) THEN
				ImageDataSet[#ImageSet].MaxValue=ImageDataSet[#ImageSet].MinValue+1
				#error=1
				text$="Divide by Zero, MaxV<MinV"
	END IF


END FUNCTION
'
'
' ###########################
' #####  ScaleRange ()  #####
' ###########################
'
FUNCTION  ScaleRange ()
	SHARED Image ImageFormat[]
	SHARED MemDataSet ImageDataSet[]
	SHARED SINGLE hh,cur
	SHARED TrackData TrackInfo[]
	SHARED TrackData TrackInfoCopy[]

' #ScaleType 0 = min max
'	#ScaleType 1 = min 65535
'	#ScaleType 2 = 0 65535
'	#ScaleType 3 = 0 max
'	#ScaleType 4 = #customMin #customMax

	IF TrackInfo[0].valid=0 THEN ScaleAllTracksCalc (#ImageSet)
	maxp!=TrackInfo[ImageDataSet[#ImageSet].Track-1].MaxPoint
	minp!=TrackInfo[ImageDataSet[#ImageSet].Track-1].MinPoint

'	maxpx=TrackInfo[ImageDataSet[#ImageSet].Track].MaxPixel
'	minpx=TrackInfo[ImageDataSet[#ImageSet].Track].MinPixel

	SELECT CASE #ScaleType
			CASE 0 :IF #AutoScale=1 THEN
										ImageDataSet[#ImageSet].MaxValue=maxp!: ImageDataSet[#ImageSet].MinValue=minp!
							ELSE
										AutoScale(#ImageSet,ImageDataSet[#ImageSet].Track)
										GOSUB Update
										EXIT FUNCTION
							END IF
			CASE 1 :ImageDataSet[#ImageSet].MinValue=minp!: ImageDataSet[#ImageSet].MaxValue=65535
			CASE 2 :ImageDataSet[#ImageSet].MinValue=0: ImageDataSet[#ImageSet].MaxValue=65535
			CASE 3 :ImageDataSet[#ImageSet].MinValue=0: ImageDataSet[#ImageSet].MaxValue=maxp!
			CASE 4 :IF #customMin=#customMax THEN
										EXIT FUNCTION
							ELSE
										ImageDataSet[#ImageSet].MaxValue=#customMax
										ImageDataSet[#ImageSet].MinValue=#customMin
							END IF
			CASE 5 :ImageDataSet[#ImageSet].MaxValue=TrackInfo[#maxTrack].MaxPoint
							ImageDataSet[#ImageSet].MinValue=TrackInfo[#minTrack].MinPoint
	END SELECT

	setTrackVoffset (#ImageSet)
	GOSUB Update


EXIT FUNCTION


'##############
SUB Update
'##############

	IF #currentDisplay=1 THEN
				DisplayTrack (ImageDataSet[#ImageSet].Track,0)
	ELSE
				#copyImage=1
				#MaxVi!=ImageDataSet[#ImageSet].MaxValue
				#MinVi!=ImageDataSet[#ImageSet].MinValue
				GetNewImage (#image,1,1,0)
				ColourBarLabel (0)
	END IF

END SUB


END FUNCTION
'
'
' ##################################
' #####  GetNumberASC (after)  #####
' ##################################
'
FUNCTION  GetNumberASC (after,term)

'	GetString (@after,@string$,32)

string$=""
c$=" "

SEEK(#fn2,after)

DO
		READ [#fn2], c$
		IF (ASC(c$)=term) THEN EXIT DO
		string$=string$+c$
LOOP

len=LEN(string$)
after=after+len+1
' string$=LEFT$(string$,len)
IF string$="" THEN string$=CHR$(0)

IF #DebugLevel=	1 THEN PRINT after,"ASC-"+string$+"-ASC"',ASC(string$)

RETURN ASC(string$)

END FUNCTION
'
' ###########################
' #####  scanHeader ()  #####
' ###########################
'
FUNCTION  scanHeader ()
	Image dataset[]

	INC #FileNumber
	IF #FileNumber > #NumberOfFiles THEN #FileNumber=0

	file$=#ListOfDataFiles$[#FileNumber]
	PRINT file$

	XstDecomposePathname (file$, @path$, parent$, filename$, FnoExt$, @fileExt$)
	XstSetCurrentDirectory (path$+"\\")

	SELECT CASE UCASE$(fileExt$)
			CASE ".SIF"		: ParseSifFile (file$,@dataset[],@error)
		'	CASE ".II"		: ParseIIFile  (file$,@dataset[],@error)
			CASE ELSE			: EXIT FUNCTION
	END SELECT

	ShowFields (dataset[0].firstdataset,@dataset[])
	PRINT file$+"\n"

END FUNCTION
'
'
' ###########################
' #####  OpenFilefn ()  #####
' ###########################
'
FUNCTION OpenFilefn (file$,filenumber)

	filenumber=OPEN (file$, $$RDSHARE)
	RETURN filenumber

END FUNCTION
'
'
' ############################
' #####  CloseFilefn ()  #####
' ############################
'
FUNCTION  CloseFilefn (fn)

	CLOSE (fn)

END FUNCTION
'
'
' ##########################
' #####  LabeldSet ()  #####
' ##########################
'
FUNCTION  LabeldSet ()
	SHARED Image ImageFormat[]
	STATIC status,set

	IF ((#dataFile<>set) OR (#ResponseBoxState=0)) THEN status=0
	set= #dataFile

	SELECT CASE status
			CASE 0					:GOSUB InitResponseBox
			CASE 1					:GOSUB SetLabel
			CASE ELSE				:status=0: #ResponseBoxState=0
	END SELECT

'###################
SUB SetLabel
'###################

	status=0
	#ResponseBoxState=0
	XuiSendMessage (#ResponseBox, #HideWindow, 0, 0, 0, 0, 0, 0)

	IF #Textline$<>"" THEN ImageFormat[set].datatype=#Textline$: setSigBtLabels ()

END SUB


'###################
SUB InitResponseBox
'###################

	#ResponseAction=4
	#ResponseBoxState=1
	#Textline$=""
	status=1

	XuiSendMessage (#ResponseBox,#SetWindowTitle, 0, 0, 0, 0, 0, "Set label")
	XuiSendMessage (#ResponseBox,#SetTextString,0,0,0,0,1,"And todays label will be...")
	XuiSendMessage (#ResponseBox,#SetTextString,0,0,0,0,2,ImageFormat[set].datatype)
	XuiSendMessage (#ResponseBox,#Redraw, 0, 0, 0, 0, 0, 0)
	XuiSendMessage (#ResponseBox,#DisplayWindow, 0, 0, 0, 0, 0, 0)
	XgrSetSelectedWindow 	(#ResponseBoxWindow)

END SUB




END FUNCTION
'
'
' ###############################
' #####  setSigBtLabels ()  #####
' ###############################
'
FUNCTION  setSigBtLabels ()
	SHARED Image ImageFormat[]

	bt=30

	FOR pos=0 TO ImageFormat[#ImageSet,0].totaldatasets
				IF ImageFormat[#ImageSet,pos].active=1 THEN
							INC bt
							txt$=ImageFormat[#ImageSet,pos].datatype
							XuiSendMessage (#Output,#Enable,0,0,0,0, bt ,0)
							XuiSendMessage (#Output,#SetTextString,0,0,0,0, bt,txt$)
							XuiSendMessage (#Output,#Redraw, 0, 0, 0, 0, bt, 0)
				END IF
	NEXT pos

END FUNCTION
'
'
' #################################
' #####  disableUnusedBts ()  #####
' #################################
'
FUNCTION  disableUnusedBts ()
	SHARED Image ImageFormat[]

	FOR pos=31+ImageFormat[#ImageSet,0].totalimages TO 35
				XuiSendMessage (#Output,#Disable,0,0,0,0, pos,0) '  $sigBt
	NEXT pos

END FUNCTION
''
' ###########################
' #####  KeyPressed ()  #####
' ###########################
'
FUNCTION  KeyPressed (button$)
	SHARED Image ImageFormat[]
	SHARED MemDataSet ImageDataSet[]
	STATIC UBYTE image[]

	SELECT CASE button$
			CASE	"d"		 : addimage_test ()
			CASE	"s"		 : resizeimage_test ()
			CASE	"`"		 : copydataset_test ():' DrawImageRange (750,970,1000,1400)
			CASE	"f"		 : DisplayTracks (list)
			CASE	"2"		 : RotateImage (#ImageSet,3)   '  unitest ()
			CASE	"5"		 : openUD_test()
			CASE  "7"		 : addimages_test ()
			CASE  "h"    : AutoScaleAll (#ImageSet):ScaleToAllTracks ()' movedataset_test (): EXIT FUNCTION
			CASE	"&"		 : upTrk (): EXIT FUNCTION						' up arrow key
			CASE	"4"		 : PlayKf (): EXIT FUNCTION
			CASE	"6"		 : PlayKb (): EXIT FUNCTION
			CASE	"0"		 : NextKi (): EXIT FUNCTION
			CASE	"9"		 : BackKi (): EXIT FUNCTION
			CASE	"("		 : downTrk (): EXIT FUNCTION					' down arrow key
			CASE	"/"		 : imageFix (): EXIT FUNCTION
			CASE	"z"		 : ResetScale(): EXIT FUNCTION
			CASE	"x"		 : ScaleRange(): EXIT FUNCTION
			CASE	"%"		 : pixelLeft (): EXIT FUNCTION				' left arrow key
			CASE	"h"		 : scanHeader (): EXIT FUNCTION
			CASE	"["		 : NextCTheme (): EXIT FUNCTION
			CASE	"]"		 : NextCMtype (): EXIT FUNCTION
			CASE	"'"		 : pixelRight (): EXIT FUNCTION				' right arrow key
			CASE	"g"		 : DisplayWindow (#GotoWindow)
			CASE	"o"		 : OpenConsole (): EXIT FUNCTION
			CASE	"p"		 : CloseConsole (): EXIT FUNCTION
			CASE	","		 : ReadNextFile (): EXIT FUNCTION			' <
			CASE	"."		 : ReadLastFile (): EXIT FUNCTION			' >
			CASE	"t"		 : ToolMenuState(): EXIT FUNCTION
			CASE	"r"		 : RedrawAllWindows (): EXIT FUNCTION
			CASE	"v"		 : SwitchDisplayMode(): EXIT FUNCTION
			CASE	"c"		 : ScaleToAllTracks (): EXIT FUNCTION
			CASE	"e"		 : DisplayWindow (#SetPixelWindow): EXIT FUNCTION
			CASE	"+","=": increaseMaxScaleRange (): EXIT FUNCTION
			CASE	"-"		 : decreaseMaxScaleRange (): EXIT FUNCTION
			CASE	"1"		 : zoomXtrack (#zoomXtrack!): EXIT FUNCTION
			CASE	"3"		 : zoomdeXtrack (#zoomXtrack!): EXIT FUNCTION
			CASE	"a"		 : CycleOPWindowState (): EXIT FUNCTION
			CASE	"b"		 : nextColTable (): setvColBar (): EXIT FUNCTION
			CASE	"q"		 : vColBarState (): DisplayTrack(ImageDataSet[#ImageSet].Track,0): EXIT FUNCTION
			CASE	"j"		 : OpenConsole (): ShowFields (#dataFile,@ImageFormat[]): EXIT FUNCTION
			CASE	"y","Y" : GetBlemSpots  (6,ImageFormat[#ImageSet,#dataFile].NumberOfPixels-5,ImageFormat[#ImageSet,#dataFile].NumberOfTracks-5,6,0.75): EXIT FUNCTION
			CASE	"u"		 :	a=GetMaxPointImage (imageindex,@tmax,@pmax)
											b=GetMinPointImage (imageindex,@tmin,@pmin)
											PRINT  a,pmax,tmax,b,pmin,tmin,GetPixelValue (#ImageSet,1,1,v)
											SetPixelValue (0,1,1,SINGLE (2500.5))
											GetPixelValue (#ImageSet,1,1,@v!)
											PRINT v!
	END SELECT


END FUNCTION
'
'
' ###########################
' #####  NextCTheme ()  #####
' ###########################
'
FUNCTION  NextCTheme ()

	oldtheme= #colourTheme

	INC #colourTheme
	IF #colourTheme>#colourThemeMx THEN #colourTheme=0

'	IF #colourTheme<>oldtheme THEN
				SetColourTheme (#colourTheme)
				RedrawAllWindows ()
'	END IF


END FUNCTION
'
'
' ###########################
' #####  NextCMtype ()  #####
' ###########################
'
FUNCTION  NextCMtype ()

	INC	#cMenuType
	IF #cMenuType>5 THEN #cMenuType=1

END FUNCTION
'
'
' #############################
' #####  InitNewCMenu ()  #####
' #############################
'
FUNCTION  InitNewCMenu (v0,v1)
	SHARED cMenuPos cMenu[]

	IF #cmenu=1 THEN cMenuClearAll ()
	IF ((#sCursorType<>0) AND (#cDraw>0)) THEN ErasePCursor ()

	#xContext=v0-1
	#yContext=v1+1
	#cDrawBox=1
	#cmenu=0

	cMenu[0].olditem=255
	cMenu[1].olditem=255
	cMenu[2].olditem=255

	cMenu[0].item=255
	cMenu[1].item=255
	cMenu[2].item=255

	cMenu[0].status=1
	cMenu[1].status=0
	cMenu[2].status=0

	DrawContextMenu (#xContext+1,#yContext-2,#cMenuWidth,#cMenuHeight+4,1,@#cMenu$[],cMenu[0].item)


END FUNCTION
'
'
' ###########################
' #####  zoomXtrack ()  #####
' ###########################
'
FUNCTION  zoomXtrack (zoomXtrack)
	SHARED cur
	SHARED Image ImageFormat[]
	SHARED MemDataSet ImageDataSet[]


	IF #scrpix<21 THEN EXIT FUNCTION

	oldf=ImageFormat[#ImageSet,#dataFile].fPixel
	oldl=ImageFormat[#ImageSet,#dataFile].lPixel

	size!=ImageFormat[#ImageSet,#dataFile].lPixel-(ImageFormat[#ImageSet,#dataFile].lPixel/SINGLE(#zoomXtrack!))
	pos!=(cur*100)/#scrpix

	ImageFormat[#ImageSet,#dataFile].lPixel=ImageFormat[#ImageSet,#dataFile].lPixel-(((size!/SINGLE(100))*(100-pos!)))+1
	sf!=((size!/SINGLE(100))*pos!)
	ImageFormat[#ImageSet,#dataFile].fPixel=ImageFormat[#ImageSet,#dataFile].fPixel+sf!

	IF ImageFormat[#ImageSet,#dataFile].lPixel > (ImageFormat[#ImageSet,#dataFile].NumberOfPixels-1) THEN ImageFormat[#ImageSet,#dataFile].lPixel=ImageFormat[#ImageSet,#dataFile].NumberOfPixels-1
	IF ImageFormat[#ImageSet,#dataFile].fPixel<0 THEN ImageFormat[#ImageSet,#dataFile].fPixel=0
	IF (ImageFormat[#ImageSet,#dataFile].fPixel > (ImageFormat[#ImageSet,#dataFile].lPixel-10)) THEN ImageFormat[#ImageSet,#dataFile].fPixel=oldf: ImageFormat[#ImageSet,#dataFile].lPixel=oldl: EXIT FUNCTION

	cur=cur-sf!
	#drawVinfo=0
	#drawXinfo=2
	#dontupdate=1

	IF ((#sCursorType>0) AND (#cDraw>0)) THEN ErasePCursor ()

	DisplayTrack (ImageDataSet[#ImageSet].Track,0)

	#drawVinfo=1
	#drawXinfo=1


END FUNCTION
'
'
' #############################
' #####  zoomdeXtrack ()  #####
' #############################
'
FUNCTION  zoomdeXtrack (zoom)
	SHARED cur
	SHARED Image ImageFormat[]
	SHARED MemDataSet ImageDataSet[]



	IF #scrpix > ImageFormat[#ImageSet,#dataFile].NumberOfPixels THEN EXIT FUNCTION

	oldf=ImageFormat[#ImageSet,#dataFile].fPixel
	oldl=ImageFormat[#ImageSet,#dataFile].lPixel

	size!=SINGLE(ImageFormat[#ImageSet,#dataFile].lPixel)-(SINGLE(ImageFormat[#ImageSet,#dataFile].lPixel)/SINGLE(#zoomXtrack!))
	pos!=SINGLE(SINGLE(cur)*SINGLE(100))/SINGLE(#scrpix)

	ImageFormat[#ImageSet,#dataFile].lPixel=ImageFormat[#ImageSet,#dataFile].lPixel+(((size!/SINGLE(100))*(100-pos!)))+1
	sf!=((size!/SINGLE(100))*pos!)
	ImageFormat[#ImageSet,#dataFile].fPixel=ImageFormat[#ImageSet,#dataFile].fPixel-sf!

	IF ImageFormat[#ImageSet,#dataFile].lPixel > (ImageFormat[#ImageSet,#dataFile].NumberOfPixels-1) THEN ImageFormat[#ImageSet,#dataFile].lPixel=ImageFormat[#ImageSet,#dataFile].NumberOfPixels-1
	IF ImageFormat[#ImageSet,#dataFile].fPixel<0 THEN sf!=sf!+ImageFormat[#ImageSet,#dataFile].fPixel: ImageFormat[#ImageSet,#dataFile].fPixel=0

	IF ((ImageFormat[#ImageSet,#dataFile].fPixel > (ImageFormat[#ImageSet,#dataFile].lPixel-10)) OR ((ImageFormat[#ImageSet,#dataFile].lPixel-ImageFormat[#ImageSet,#dataFile].fPixel) >(ImageFormat[#ImageSet,#dataFile].NumberOfPixels-1))) THEN
				ImageFormat[#ImageSet,#dataFile].fPixel=oldf
				ImageFormat[#ImageSet,#dataFile].lPixel=oldl
				EXIT FUNCTION
	END IF

	cur=cur+sf!
	#drawVinfo=0
	#drawXinfo=2
	#dontupdate=1

	IF ((#sCursorType>0) AND (#cDraw>0)) THEN ErasePCursor ()
	DisplayTrack (ImageDataSet[#ImageSet].Track,0)

	#drawVinfo=1
	#drawXinfo=1

END FUNCTION
'
'
' ##################################
' #####  DrawImageSelected ()  #####
' ##################################
'
FUNCTION  DrawImageSelected (x1,x0,y0,y1)
	SHARED SINGLE hh

	LastPix =(x1/#col)+#FirstPix
	FirstPix =(x0/#col)+#FirstPix
	LastTrack =((hh-y0)/#row)+#FirstTrack
	FirstTrack =((hh-y1)/#row)+#FirstTrack

	DrawImageRange (FirstPix,LastPix,FirstTrack,LastTrack)

END FUNCTION
'
'
' ###########################
' #####  StartTimer ()  #####
' ###########################
'
FUNCTION DOUBLE StartTimer (Tindex, DOUBLE time)
	SHARED TIMER Time[]
	STATIC Oindex

	IFZ Oindex THEN Oindex=0: DIM Time [10]
	IF ((Oindex+1) > UBOUND (Time[])) THEN REDIM Time [Oindex+10]

	INC Oindex
	Tindex=Oindex
	Time[Tindex].Status=1
'	Time[Tindex].Number=Oindex

	XstGetSystemTime (@time)

	Time[Tindex].Start=time
	Time[Tindex].Time=time

	RETURN time


'	TODO  set timer index should be the next free timer slot from 0. ie .status=0


END FUNCTION
'
'
' ###########################
' #####  CheckTimer ()  #####
' ###########################
'
FUNCTION DOUBLE CheckTimer (index, DOUBLE time)
	SHARED TIMER Time[]
	DOUBLE end,start

	XstGetSystemTime (@end)

	IF (index > UBOUND (Time[])) THEN GOSUB InvalidTimer

	IF Time[index].Status=1 THEN
			start=Time[index].Time
			time=end-start
	ELSE
			GOSUB InvalidTimer
	END IF

	RETURN time


EXIT FUNCTION


'#################
SUB InvalidTimer
'#################

	PRINT "InvalidTimer index"
	EXIT FUNCTION

END SUB




END FUNCTION
'
'
' #########################
' #####  EndTimer ()  #####
' #########################
'
FUNCTION DOUBLE EndTimer (Oindex, DOUBLE time)
	SHARED TIMER Time[]
	DOUBLE end

	XstGetSystemTime (@end)

	IF (Oindex > UBOUND (Time[])) THEN GOSUB InvalidTimer

	IF Time[Oindex].Status=1 THEN

			time=end-Time[Oindex].Start

			Time[Oindex].Status=0
			Time[Oindex].Start=0
			Time[Oindex].Time=0
		'	Time[Oindex].Number=0
			Time[Oindex].End=end

	ELSE
			GOSUB InvalidTimer
	END IF

	RETURN time

EXIT FUNCTION


'#################
SUB InvalidTimer
'#################

	PRINT "InvalidTimer index"
	EXIT FUNCTION

END SUB


END FUNCTION
'
'
' ##############################
' #####  KillAllTimers ()  #####
' ##############################
'
FUNCTION  KillAllTimers ()
	SHARED TIMER Time[]
	SHARED T_Index

	XstKillTimer (T_Index)

	FOR index=0 TO UBOUND (Time[])
			Time[index].Status=0
			Time[index].Start=0
			Time[index].Time=0
		'	Time[index].Number=0
			Time[index].End=0
	NEXT index

END FUNCTION
'
'
' ################################
' #####  DestroyAllGrids ()  #####
' ################################
'
FUNCTION  DestroyAllGrids ()
	SHARED MemDataSet ImageDataSet[]

	XgrDestroyGrid (#memBuffer)
	XgrDestroyGrid (#cBuff)
	XgrDestroyGrid (#BTbuff)

	FOR slot=0 TO UBOUND (ImageDataSet[])
			IFT IsImageSlotValid (slot) THEN XgrDestroyWindow  (ImageDataSet[slot].Window)
	NEXT slot

	XgrDestroyWindow(#OutputWindow)
	XgrDestroyWindow(#ToolsWindow)
	XgrDestroyWindow(#MessageWindow)
	XgrDestroyWindow(#LevelIndicatorWindow)
	XgrDestroyWindow(#FileListWindow)
	XgrDestroyWindow(#ResponseBoxWindow)
	XgrDestroyWindow(#AboutWindow)
	XgrDestroyWindow(#AxisWindow)
	XgrDestroyWindow(#GotoWindow)
	XgrDestroyWindow(#SetPixelWindow)
	XgrDestroyWindow(#GetRawInfoWindow)

END FUNCTION
'
'
' ##################################
' #####  DestroyAllArrarys ()  #####
' ##################################
'
FUNCTION  DestroyAllArrarys ()
	SHARED TrackData TrackInfoCopy[]
	SHARED TrackData TrackInfo[]
	SHARED Image ImageFormat[]
	SHARED cMenuPos cMenu[]
	SHARED UBYTE image[]
	SHARED argb rgb[]

	DIM rgb[]
	DIM cMenu[]
	DIM image[]
'	DIM #D ataSet![]	' all data sets too
	DIM TrackInfo[]
	DIM ImageFormat[]
	DIM TrackInfoCopy[]
	DIM #ListOfDataFiles$[]

END FUNCTION
'
'
' ################################
' #####  DestroyAllFonts ()  #####
' ################################
'
FUNCTION  DestroyAllFonts ()

	XgrDestroyFont (#valfont)
	XgrDestroyFont (#pixfont)
	XgrDestroyFont (#labelfont)
	XgrDestroyFont (#cFont)
	XgrDestroyFont (#labelYfont)

END FUNCTION
'
'
' #####################
' #####  Quit ()  #####
' #####################
'
FUNCTION Quit ()

'	CloseAllFiles ()
	KillAllTimers ()
	DestroyAllGrids ()
	DestroyAllArrarys ()
	DestroyAllFonts ()

	QUIT(0)			' ack


END FUNCTION
'
'
' #########################
' #####  getMaxVy ()  #####
' #########################
'
FUNCTION SINGLE getMaxVy (slot,v1)
	SHARED SINGLE hh
	SHARED MemDataSet ImageDataSet[]
	SINGLE top,bottom
	' must fix


	top=ImageDataSet[slot].MaxValue
	bottom=ImageDataSet[slot].MinValue

	vinfo=(hh/( top - bottom ))* bottom

	y=XLONG((top-(((top-bottom)/hh)*(v1-vinfo)))-bottom)
	IF (y<10 && y>-10) THEN
				y!=(top-(((top-bottom)/hh)*(SINGLE(v1)-vinfo)))-bottom
				RETURN y!
	END IF

	RETURN y

END FUNCTION
'
'
' ################################
' #####  setTrackVoffset ()  #####
' ################################
'
FUNCTION  setTrackVoffset (slot)
	SHARED SINGLE hh
	SHARED MemDataSet ImageDataSet[]
	SINGLE h

	IF #currentDisplay=2 THEN
				h=#v3-#defaultBottom
		'		ImageDataSet[slot].MaxValue=#MaxVi!
		'		ImageDataSet[slot].MinValue=#MinVi!
	ELSE
			h=hh
	END IF

	IF slot=#ImageSet THEN
				#o=(h/(ImageDataSet[slot].MaxValue-ImageDataSet[slot].MinValue))*ImageDataSet[slot].MinValue
				#totalvoffset=0
				#Voffset=0
	END IF

END FUNCTION
'
'
' ##############################
' #####  dragColourBar ()  #####
' ##############################
'
FUNCTION  dragColourBar (v0,v1)
	SHARED SINGLE ww,maxv,minv
	SHARED v0start
	STATIC oldadd
	SINGLE add

	IF #drawimage=1 THEN EXIT FUNCTION

	add=((#MaxVi!-#MinVi!)/ww)*(v0start-v0)

	IF add=oldadd THEN EXIT FUNCTION
	oldadd=add

	#MaxVi!=maxv+add
	#MinVi!=minv+add

	#copyImage=1
	GetNewImage (#image,0,1,0)
	ColourBar (0,0)

END FUNCTION
'
'
' ############################
' #####  drag2dTrack ()  #####
' ############################
'
FUNCTION  drag2dTrack (x,y)
	SHARED ww,cur
	SHARED Image ImageFormat[]
	SHARED MemDataSet ImageDataSet[]
	SHARED fp,lp,cr
	SINGLE xdiff


	slot=#ImageSet
	ds=ImageDataSet[slot].DataSet

	oldfp=ImageFormat[slot,ds].fPixel
	oldlp=ImageFormat[slot,ds].lPixel
	xdiff=(#scrpix/ww)*(x-#xdrag)

	#Voffset=y-#ydrag
	ImageFormat[slot,ds].fPixel=fp-xdiff
	ImageFormat[slot,ds].lPixel=lp-xdiff

	IF ImageFormat[slot,ds].fPixel<0 THEN
				xd=ImageFormat[slot,ds].fPixel
				ImageFormat[slot,ds].fPixel=0
				ImageFormat[slot,ds].lPixel=#scrpix
				xdiff=xdiff+xd
	END IF

	IF ImageFormat[slot,ds].lPixel>=ImageFormat[slot,ds].NumberOfPixels THEN
				xd=(ImageFormat[slot,ds].NumberOfPixels-1)-ImageFormat[slot,ds].lPixel
				ImageFormat[slot,ds].lPixel=ImageFormat[slot,ds].NumberOfPixels-1
				ImageFormat[slot,ds].fPixel=(ImageFormat[slot,ds].NumberOfPixels-#scrpix)-1
				xdiff=xdiff-xd
	END IF

	IF ((oldlp<>ImageFormat[slot,ds].lPixel) OR (oldlp<>ImageFormat[slot,ds].lPixel)) THEN
				#drawXinfo=2
				cur=cr+xdiff
	ELSE
				#drawXinfo=0
	END IF

	DisplayTrack(ImageDataSet[#ImageSet].Track,0)
	#drawXinfo=1

END FUNCTION
'
'
' ##################################
' #####  DragImageSelector ()  #####
' ##################################
'
FUNCTION  dragImageSelector (v0,v1)
	SHARED SINGLE hh,ww
	SINGLE xdiff,ydiff


'	PRINT "pix", #FirstPix , #LastPix
'	PRINT "trk", #FirstTrack , #LastTrack

	IF #DragTypeImage=0 THEN

				xdiff=((ww/#col)/ww)*(#vx-v0)
				ydiff=((hh/#row)/hh)*(#vy-v1)
				#FirstPix=#fp+xdiff
				#FirstTrack=#ft-ydiff

				IF #FirstTrack<0 THEN #FirstTrack=0

				#copyImage=0
				#clearO1=0
				#ClearMessageQueue=2
				GetNewImage (#image,0,1,0)

	ELSE

				#x=v0
				#y=v1
				r=6
				ink=$$White

				XgrSetGridDrawingMode (#image, $$DrawModeXOR , $$LineStyleDash, 1)

				XgrDrawLine (#image,ink, #x3d+1, #y3d, #oldx+1, #oldy)
				XgrDrawLine (#image,ink, #x3d, #y3d+1, #oldx, #oldy+1)
				XgrDrawLine (#image,ink, #x3d, #y3d-1, #oldx, #oldy-1)
				XgrDrawLine (#image,ink, #x3d-1, #y3d, #oldx-1, #oldy)
				XgrFillBox  (#image,ink, #oldx-r, #oldy-r, #oldx+r, #oldy+r)

				IF #x<=r THEN #x=r
				IF #y>=hh-r THEN #y=hh-r
				IF #y<=r THEN #y=r
				IF #x>=ww-r THEN #x=ww-r

				text$="x:"+STRING$(#x-#x3d)+" y:"+STRING$(#y-#y3d)
				Prints (text$,1)

				XgrFillBox  (#image,ink, #x-r, #y-r, #x+r, #y+r)
				XgrDrawLine (#image,ink, #x3d+1, #y3d, #x+1, #y)
				XgrDrawLine (#image,ink, #x3d, #y3d+1, #x, #y+1)
				XgrDrawLine (#image,ink, #x3d, #y3d-1, #x, #y-1)
				XgrDrawLine (#image,ink, #x3d-1, #y3d, #x-1, #y)

				XgrSetGridDrawingMode (#image, 0 , $$LineStyleSolid, 1)

				#oldx=#x
				#oldy=#y
	END IF


END FUNCTION
'
'
' ###################################
' #####  drag2dAreaSelector ()  #####
' ###################################
'
FUNCTION  drag2dAreaSelector (v0,v1)
	SHARED Image ImageFormat[]
	SHARED SINGLE hh,ww
	SHARED x0, x1, y0, y1

	ox0=x0: ox1=x1
	oy0=y0:	oy1=y1		' box to erase

	x1=v0: y1=v1											' set new endpoint at current mouse coordinates

	IF x1<=0 THEN x1=0
	IF y1>=hh THEN y1=hh
	IF y1<=0 THEN y1=0
	IF x1>=ww THEN x1=ww

	IF #currentDisplay=1 THEN
		IF ImageFormat[#ImageSet,#dataFile].xCal[1]<>1 THEN
				x!=(((#scrpix/ww)*x1)*ImageFormat[#ImageSet,#dataFile].xCal[1]+ImageFormat[#ImageSet,#dataFile].xCal[0] + (ImageFormat[#ImageSet,#dataFile].fPixel*ImageFormat[#ImageSet,#dataFile].xCal[1]))*ImageFormat[#ImageSet,#dataFile].hBin
				x$="x:"+STRING$(x!)
				y$=" y:"+STRING$(getMaxVy (#ImageSet,y1))
		ELSE
				x=(((x1*(#scrpix/ww)) + (ImageFormat[#ImageSet,#dataFile].fPixel+ImageFormat[#ImageSet,#dataFile].bLeft-1)+ImageFormat[#ImageSet,#dataFile].xCal[0])*ImageFormat[#ImageSet,#dataFile].hBin)+1
				x$="x:"+STRING$(x)
				y$=" y:"+STRING$(getMaxVy (#ImageSet,y1))
		END IF
	END IF

	XgrSetGridDrawingMode (#image, $$DrawModeXOR , #LineStyle, 1)
	XgrDrawBox(#image, #LineStyleInk, ox0, oy0, ox1, oy1)					'erase previous line

	IF #currentDisplay=1 THEN
			IF #flag=1 THEN Prints (x$+y$,0): #flag=0
			Prints (x$+y$,1)
	END IF

	XgrDrawBox(#image, #LineStyleInk, x0, y0, x1, y1)							'draw new line
	XgrSetGridDrawingMode (#image, 0 , #LineStyle, 1)


END FUNCTION
'
'
' ################################
' #####  drawImageBorder ()  #####
' ################################
'
FUNCTION  drawImageBorder (colour)
	SHARED SINGLE hh,ww

'PRINT hh,ww

'	XgrDrawLine (#OutputG, colour , #leftmargin,#topmargin-1,ww+#leftmargin+1,#topmargin-1)					' top left to top right
'	XgrDrawLine (#OutputG, colour , #leftmargin-1,#topmargin-1,#leftmargin-1,hh+#topmargin+1)				' top left to bottom left
'	XgrDrawLine (#OutputG, colour , #leftmargin,hh+#topmargin+1,ww+#leftmargin+1,hh+#topmargin+1)  	' botton left to bottom right
'	XgrDrawLine (#OutputG, colour, ww+#leftmargin+1,#topmargin-1,ww+#leftmargin+1,hh+#topmargin+1)	' top right to bottom right
'	^ can be used instead of the XgrDrawBox() to give a '3d' effect or other such effect

	XgrDrawBox (#OutputG, colour , #leftmargin-1,#topmargin-1, ww+#leftmargin+1,hh+#topmargin+1)

END FUNCTION
'
'
' ###########################
' #####  dragWindow ()  #####
' ###########################
'
FUNCTION  dragWindow ()
	SHARED xPin,yPin,ww

	XgrGetMouseInfo (@window, @mgrid, @xWin, @yWin, @state, time)

	IFZ state THEN #PanDisplay=0: EXIT FUNCTION
	XgrGetWindowPositionAndSize (@window, @xaDisp, @yaDisp, width, height )

	Xdif = xaDisp + (xWin - xPin) ' -#windowBorderWidth
	Ydif = yaDisp + (yWin - yPin) '-#windowBorderWidth

	text$="x:"+STRING$(Xdif)+" y:"+STRING$(Ydif)
	Prints (text$,1)

	XgrSetWindowPositionAndSize (window, Xdif, Ydif, -1, -1)
'	MoveWindow (#ActiveWindow, Xdif, Ydif, width+(#windowBorderWidth*2), height+(#windowBorderWidth*2) ,1)

	IF #Tdock<>0 THEN XgrSetWindowPositionAndSize (#ToolsWindow, Xdif+#tx, Ydif+#ty, -1, -1 )

'	IF #currentDisplay=2 THEN
'				XgrSetWindowPositionAndSize (#ModScaleMaxWindow,8+Xdif+ww+#leftmargin,Ydif+14,-1,-1)
'				XgrSetWindowPositionAndSize (#ModScaleMinWindow,Xdif+#leftmargin-22,Ydif+14,-1,-1)
'	END IF


END FUNCTION
'
'
' #############################
' #####  WindowDragUp ()  #####
' #############################
'
FUNCTION  WindowDragUp ()

	IF #PanDisplay=6 THEN EXIT FUNCTION

	XgrCopyImage(#image,#memBuffer)
'	ClearHcoverField ()
	DrawOutputBorders()
	DrawSignalButtons ()
	IF #currentDisplay=2 THEN ColourBar (0,0)
	DrawInfo()

	'	XgrDrawIcon (area, #IconWindow, 0, 0)

END FUNCTION
'
'
' #############################
' #####  MouseControl ()  #####
' #############################
'
FUNCTION  MouseControl (message,v0,v1,v2,v3,r1)


	SELECT CASE message
			CASE	#WindowMouseDrag	: IF #PanDisplay>0 THEN MouseDrag (v0,v1)
			CASE	#WindowMouseMove	: IF r1=#image THEN MouseMove (v0,v1,v2,v3)
			CASE	#WindowMouseUp		: MouseUp ()
			CASE	#WindowMouseDown	: MouseDown (v0,v1,v2,v3)
			CASE	#WindowMouseWheel : MouseWheel (v3)
			CASE	#WindowMouseExit	: MouseExit ()
			CASE	#WindowMouseEnter	: MouseEnter ()
	END SELECT

END FUNCTION
'
'
' ##########################
' #####  MouseDown ()  #####
' ##########################
'
FUNCTION  MouseDown (v0, v1, v2, v3)
	SHARED Image ImageFormat[]
	SHARED cMenuPos cMenu[]
	SHARED SINGLE hh,ww,maxv,minv,cur
	SHARED x0,x1,y0,y1
	SHARED area,xPin,yPin
	SHARED fp,lp,cr
	SHARED v0start

	#PanDisplay=0
	#ResponseBoxState=0
	IF ((#sCursorType>0) AND (#cDraw>0)) THEN ErasePCursor ()

	HideWindow (#AxisWindow)
	HideWindow (#ResponseBoxWindow)
	HideWindow (#ModScaleMinWindow)
	HideWindow (#ModScaleMaxWindow)

	XgrGetMouseInfo (window, @mgrid, @xPin, @yPin, state, time)

	SELECT CASE mgrid
		CASE area					 :#PanDisplay=4
		CASE #image				 :GOSUB mouseDownWindow
		CASE #colourbarea	 :#PanDisplay=3
												#ClearMessageQueue=1
												v0start=v0
												maxv=#MaxVi!
												minv=#MinVi!
	END SELECT


EXIT FUNCTION

'####################
SUB mouseDownWindow
'####################

	IF cMenu[0].status=1 THEN GOSUB ClrEtCheckMenuState

	#PanDisplay=0
	#Voffset=0
	#pix=0
	button=v2

	IF ((button=0x02000092) OR (button=0x02040092)) THEN
		IF #currentDisplay=1 THEN
				#PanDisplay=1
				#ydrag=v1
				#xdrag=v0
				fp=ImageFormat[#ImageSet,#dataFile].fPixel
				lp=ImageFormat[#ImageSet,#dataFile].lPixel
				cr=cur
				EXIT FUNCTION
		ELSE
				#PanDisplay=2

				IF #DragTypeImage=0 THEN
							#fp=#FirstPix
							#ft=#FirstTrack
							#lt=#LastTrack
							#lp=#LastPix
							#vx=v0
							#vy=v1
				ELSE
							r=6
							IF v1<r THEN v1=r
							IF v1>(hh-r) THEN v1=hh-r
							IF v0<r THEN v0=r
							IF v0>(ww-r) THEN v0=ww-r

							#x3d=v0: #y3d=v1
							#oldx=v0:	#oldy=v1
							XgrFillBox  (#image,#ink, #x3d-r, #y3d-r,#x3d+r, #y3d+r )

							text$="x:"+STRING$(#x3d)+" y:"+STRING$(#y3d)
							Prints (text$,1)
				END IF

		END IF
	END IF

	IF ((button=0x01000091) OR (button=0x01040091)) THEN		' left mouse button
				#PanDisplay=6
				x0 = v0: y0 = v1		' store old and new mouse co-ord
				x1 = x0: y1 = y0
				#ydrag=0
				#xcur=v0		' store x value to obtain cur postion
				#flag=1			' temp flag
	END IF

END SUB



'########################
SUB ClrEtCheckMenuState
'########################

	cMenu[0].status=0
	#cmenu=1
	cMenuClearAll ()
	IF ((cMenu[1].status=1) AND (cMenu[2].status=1) AND (cMenu[2].item=255)) THEN
				EXIT FUNCTION
	ELSE
				ContextSelect ()
				EXIT FUNCTION
	END IF

END SUB

END FUNCTION
'
'
' ##########################
' #####  MouseDrag ()  #####
' ##########################
'
FUNCTION  MouseDrag (v0,v1)
	SHARED cMenuPos cMenu[]

'	IF cMenu[0].status=1 THEN cMenuSelection (v0,v1): EXIT FUNCTION

	SELECT CASE #PanDisplay
		CASE	1			:drag2dTrack (v0,v1)
		CASE	2			:dragImageSelector (v0,v1)
		CASE	3			:dragColourBar (v0,v1)
		CASE	4			:dragWindow ()
'		CASE	5			:toolbar drag  ' we shouldnt ever reach here
		CASE	6			:drag2dAreaSelector (v0,v1)
'		CASE	7			:icon window
	END SELECT

END FUNCTION
'
'
' ##########################
' #####  MouseExit ()  #####
' ##########################
'
FUNCTION  MouseExit ()

	IF #trackCursor=1 THEN
				XgrSetGridFont (#Output,#pixfont)
				XgrMoveTo (#Output, 430,#v3-18)
				XgrDrawTextFill (#Output, #ink,#textClear$+"     ")
	END IF

	IF ((#sCursorType>0) AND (#cDraw>0)) THEN ErasePCursor ()

'	XgrGetMouseInfo ( @window, @mgrid, @xWin, @yWin, @state, @time )
'	IF mgrid=area THEN HideButtonMenu (0)

END FUNCTION
'
'
' ###########################
' #####  MouseEnter ()  #####
' ###########################
'
FUNCTION  MouseEnter ()

	#cDraw=0

END FUNCTION
'
'
' ###########################
' #####  MouseWheel ()  #####
' ###########################
'
FUNCTION  MouseWheel (v3)
	SHARED Image ImageFormat[]
	SHARED MemDataSet ImageDataSet[]


	IF ((#currentDisplay=1) && (#LoadBit=0)) THEN
			IF v3>0 THEN GOSUB myMouseWheelUp ELSE GOSUB myMouseWheelDown
	END IF

EXIT FUNCTION


'##################
SUB myMouseWheelUp
'##################

'	IF (ImageDataSet[#ImageSet].Track < (ImageFormat[#ImageSet,#dataFile].NumberOfTracks-1)) THEN INC ImageDataSet[#ImageSet].Track
	IF (ImageDataSet[#ImageSet].Track-1 < (ImageFormat[#ImageSet,#dataFile].NumberOfTracks-v3)) THEN ImageDataSet[#ImageSet].Track=ImageDataSet[#ImageSet].Track+v3

	IF ((#sCursorType>0) AND (#cDraw>0)) THEN ErasePCursor ()
	IF #AutoScale	THEN ScaleRange() ELSE #drawYinfo=0: #drawXinfo=0: DisplayTrack(ImageDataSet[#ImageSet].Track,0)
	#drawYinfo=1: #drawXinfo=1

END SUB

'####################
SUB myMouseWheelDown
'####################

'	IF ImageDataSet[#ImageSet].Track>=1 THEN DEC ImageDataSet[#ImageSet].Track
	IF (ImageDataSet[#ImageSet].Track-1 >= (v3-v3-v3) ) THEN ImageDataSet[#ImageSet].Track=ImageDataSet[#ImageSet].Track+v3

	IF ((#sCursorType>0) AND (#cDraw>0)) THEN ErasePCursor ()
	IF #AutoScale	THEN ScaleRange() ELSE #drawYinfo=0: #drawXinfo=0: DisplayTrack(ImageDataSet[#ImageSet].Track,0)
	#drawYinfo=1: #drawXinfo=1

END SUB



END FUNCTION
'
'
' ###############################
' #####  MouseDownRight ()  #####
' ###############################
'
FUNCTION  MouseDownRight (v0,v1,kid)
	SHARED MemDataSet ImageDataSet[]

	$Label           =   7
	$sigBt1		       =  31
	$sigBt2		       =  32
	$sigBt3		       =  33
	$sigBt4		       =  34
	$sigBt5		       =  35

	#ResponseBoxState=0

	SELECT CASE kid
		CASE $Label		:InitNewCMenu (v0,v1)
		CASE $sigBt1	:IF (ImageDataSet[#ImageSet].currentImageBt<>0) THEN ImageDataSet[#ImageSet].currentImageBt=0: GetNextDataSet()
									 LabeldSet ()
		CASE $sigBt2	:IF (ImageDataSet[#ImageSet].currentImageBt<>1) THEN ImageDataSet[#ImageSet].currentImageBt=1: GetNextDataSet()
									 LabeldSet ()
		CASE $sigBt3	:IF (ImageDataSet[#ImageSet].currentImageBt<>2) THEN ImageDataSet[#ImageSet].currentImageBt=2: GetNextDataSet()
									 LabeldSet ()
		CASE $sigBt4	:IF (ImageDataSet[#ImageSet].currentImageBt<>3) THEN ImageDataSet[#ImageSet].currentImageBt=3: GetNextDataSet()
									 LabeldSet ()
		CASE $sigBt5	:IF (ImageDataSet[#ImageSet].currentImageBt<>4) THEN ImageDataSet[#ImageSet].currentImageBt=4: GetNextDataSet()
									 LabeldSet ()
	END SELECT

END FUNCTION
'
'
' ########################
' #####  MouseUp ()  #####
' ########################
'
FUNCTION  MouseUp ()
'	SHARED cMenuPos cMenu[]
	SHARED SINGLE ww,hh,cur
	SHARED x0,x1,y0,y1
	SHARED area
	SHARED T_Index,ImageLock
	SHARED Image ImageFormat[]
	SHARED MemDataSet ImageDataSet[]


	PanDup=#PanDisplay
	#PanDisplay=0
	#resize=0
	#ClearMessageQueue=0
	SetFocusOnGrid (#image)

	IF #MinSize=1 THEN EXIT FUNCTION

	XgrGetMouseInfo (window, @mgrid, win, yin, state, time)
	IF mgrid=area THEN #PanDisplay=0: WindowDragUp (): EXIT FUNCTION

	SELECT CASE PanDup
			CASE	3		:#copyImage=1: GetNewImage (#image,1,1,0): EXIT FUNCTION
			CASE	1		:
								ImageDataSet[#ImageSet].MinValue=#MinV!
								ImageDataSet[#ImageSet].MaxValue=#MaxV!

								IF #TrackSyncMM=1 THEN
									FOR slot=0 TO UBOUND(ImageDataSet[])
											IF ((ImageDataSet[slot].active=1) AND (ImageDataSet[slot].stDisplayOL=1) AND (slot<>#ImageSet)) THEN
													ImageDataSet[slot].MaxValue=#MaxV!
													ImageDataSet[slot].MinValue=#MinV!
											END IF
									NEXT slot
								END IF

								#totalvoffset=#totalvoffset+#Voffset
								#Voffset=0
								#ydrag=0

			CASE	2		:
								IF #DragTypeImage=0 THEN
										#copyImage=1
										#drawimage=0
										GetNewImage (#image,1,1,0)
										#lockout=1

										XstStartTimer (@ImageLock ,1 ,120,&tWakeUp ())
										T_Index=ImageLock

								ELSE
										x=((#x3d-#x)/#col)
										y=((#y-#y3d)/#row)

										#copyImage=1
										#FirstPix=#FirstPix+x
										#LastPix=#FirstPix+(ww/#col)
										#FirstTrack=#FirstTrack+y
										#LastTrack=#LastTrack+y

										IF #FirstPix <1 THEN #FirstPix=0
										IF #FirstTrack <1 THEN #FirstTrack=0
										IF #LastTrack > ImageFormat[#ImageSet,#dataFile].NumberOfTracks-1 THEN #LastTrack=ImageFormat[#ImageSet,#dataFile].NumberOfTracks-1
										#copyImage=1: #clearO1=0
										GetNewImage (#image,1,1,0)
								END IF

								EXIT FUNCTION

			CASE	6		:Prints ("           ",0): Prints ("           ",1)			' clear x/y select
								XgrSetGridDrawingMode (#image, $$DrawModeXOR , #LineStyle, 1)
								XgrDrawBox (#image, #LineStyleInk, x0,y0,x1,y1)				' erase drag box
								XgrSetGridDrawingMode (#image, 0 , #LineStyle, 1)

								IF y1 < y0 THEN pos=y1: y1=y0: y0=pos
								IF x1 < x0 THEN pos=x1: x1=x0: x0=pos

								IF (((x1-x0) > 10) AND ((y1-y0)>10)) THEN

										IF #currentDisplay=1 THEN

														pos=(ImageFormat[#ImageSet,#dataFile].NumberOfPixels-(ImageFormat[#ImageSet,#dataFile].NumberOfPixels-(ImageFormat[#ImageSet,#dataFile].lPixel-ImageFormat[#ImageSet,#dataFile].fPixel)))
														ltmp=ImageFormat[#ImageSet,#dataFile].lPixel: ftmp=ImageFormat[#ImageSet,#dataFile].fPixel

														ImageFormat[#ImageSet,#dataFile].lPixel=((pos/ww)*x1)+ImageFormat[#ImageSet,#dataFile].fPixel
														ImageFormat[#ImageSet,#dataFile].fPixel=((pos/ww)*x0)+ImageFormat[#ImageSet,#dataFile].fPixel

														IF (ImageFormat[#ImageSet,#dataFile].lPixel-ImageFormat[#ImageSet,#dataFile].fPixel) < 20 THEN
																	Prints ("                 ",0)			' clear x/y data
																	ImageFormat[#ImageSet,#dataFile].fPixel=ftmp
																	ImageFormat[#ImageSet,#dataFile].lPixel=ltmp
																	EXIT FUNCTION
														END IF

														cur=((ImageFormat[#ImageSet,#dataFile].lPixel-ImageFormat[#ImageSet,#dataFile].fPixel)/2)

														IF #AutoScale THEN

																	AutoScaleAll(#ImageSet)
																	ClearHcoverField ()
																  ScaleRange()
														ELSE
																	highy!=getMaxVy (#ImageSet,y0)
																	ImageDataSet[#ImageSet].MinValue=getMaxVy (#ImageSet,y1)
																	ImageDataSet[#ImageSet].MaxValue=highy!

																	checkMaxVvalue (@text$)
																	setTrackVoffset (#ImageSet)

																	ClearHcoverField ()
																	DisplayTrack (ImageDataSet[#ImageSet].Track,0)

																	IF #error THEN error (text$)

														END IF

										ELSE
														DrawImageSelected (x1,x0,y0,y1)
										END IF

										EXIT FUNCTION

								ELSE
										IF #currentDisplay=1 THEN
													cur=((#scrpix/ww)*#xcur)
													DisplayTrack (ImageDataSet[#ImageSet].Track,0)
													EXIT FUNCTION
										ELSE
													' image [#currentDisplay=2] pixel select code here
										END IF


								END IF

	END SELECT

END FUNCTION
'
'
' ##########################
' #####  MouseMove ()  #####
' ##########################
'
FUNCTION  MouseMove (v0, v1, v2, v3)
	SHARED Image ImageFormat[]
	SHARED SINGLE ww,hh
	SHARED cMenuPos cMenu[]

	IF cMenu[0].status=1 THEN cMenuSelection (v0,v1): EXIT FUNCTION

	IF #sCursorType>0 THEN
			IF #cDraw=1 THEN ErasePCursor ()
			DrawPCursor (v0,v1)
	END IF

	IF #trackCursor<>1 THEN EXIT FUNCTION
	IF ((#PanDisplay=4) OR (#PanDisplay=6) OR (#ydrag<>0)) THEN EXIT FUNCTION

	XgrSetGridFont (#Output,#pixfont)
	pos=#v3-18

	IF #currentDisplay=1 THEN

			IF ImageFormat[#ImageSet,#dataFile].xCal[1]<>1 THEN
						x!=(((#scrpix/ww)*v0)*ImageFormat[#ImageSet,#dataFile].xCal[1]+ImageFormat[#ImageSet,#dataFile].xCal[0]+(ImageFormat[#ImageSet,#dataFile].fPixel*ImageFormat[#ImageSet,#dataFile].xCal[1]))*ImageFormat[#ImageSet,#dataFile].hBin
						x$="  x:"+STRING$(x!)
			ELSE
						x=(((v0*(#scrpix/ww)) + (ImageFormat[#ImageSet,#dataFile].fPixel+ImageFormat[#ImageSet,#dataFile].bLeft-1)+ImageFormat[#ImageSet,#dataFile].xCal[0])*ImageFormat[#ImageSet,#dataFile].hBin)+1
						x$="  x:"+STRING$(x)
			END IF

			y$="data:"+STRING$(getMaxVy (#ImageSet,v1))

			XgrMoveTo (#Output,430,pos)
			XgrDrawTextFill (#Output, #ink,#textClear$)
			XgrMoveTo (#Output,430,pos)
			XgrDrawTextFill (#Output, #ink,x$)
			XgrMoveTo (#Output,500,pos)
			XgrDrawTextFill (#Output, #ink,y$)

	ELSE

			x=(v0\#col)+#FirstPix
			y=((hh-v1)\#row)+#FirstTrack

			IF (x>(ImageFormat[#ImageSet,#dataFile].NumberOfPixels-1)) || (y>ImageFormat[#ImageSet,#dataFile].NumberOfTracks-1) THEN EXIT IF 2

			x$=" x:"+STRING$((x*ImageFormat[#ImageSet,#dataFile].hBin)+1)
			y$=" y:"+STRING$((y*ImageFormat[#ImageSet,#dataFile].vBin)+1)

		'	z=(y*ImageFormat[#ImageSet,#dataFile].NumberOfPixels)+x: IF z<1 THEN z=1
			v!=GetPixelValue (#ImageSet,x+1,y+1,@v!)
			z$="data:"+STRING$(v!)+"      "

			XgrMoveTo (#Output,430,pos)
			XgrDrawTextFill (#Output, #ink,#textClear$)
			XgrMoveTo (#Output,430,pos)
			XgrDrawTextFill (#Output, #ink,x$)
			XgrMoveTo (#Output,500,pos)
			XgrDrawTextFill (#Output, #ink,y$)
			XgrMoveTo (#Output,550,pos)
			XgrDrawTextFill (#Output, #ink,z$)

	END IF


END FUNCTION
'
'
' ##########################
' #####  MaxScreen ()  #####
' ##########################
'
FUNCTION  MaxScreen ()
	$PushB8=11

	IF #MaxSstate=0 THEN
			#MaxSstate=1

			XuiSendMessage (#OutputG, #SetHintString, 0, 0, 0, 0, $PushB8, @"Previous size")

			XgrGetWindowPositionAndSize (#OutputWindow, @#Xpos, @#Ypos, @#WidthOld, @#HeightOld)
			XgrSetWindowPositionAndSize (#OutputWindow, 0, 0, #displayWidth, #displayHeight)

	ELSE
			#MaxSstate=0

			XuiSendMessage (#OutputG, #SetHintString, 0, 0, 0, 0, $PushB8, @"Maximize Window")

			IF #MinSize=1 THEN #Xpos=-1: #Ypos=-1
			XgrSetWindowPositionAndSize (#OutputWindow, #Xpos, #Ypos, #WidthOld, #HeightOld)

			IF #ToolMenuBottonState=1 THEN
						XgrDisplayWindow (#ToolsWindow)
						IF #Tdock<>1 THEN DrawToolsBorder ()
			END IF

	END IF

	#MinSize=0
	XgrHideWindow (#IconWindowWindow)
	XgrDisplayWindow (#OutputWindow)



END FUNCTION
'
'
' ##########################
' #####  MinScreen ()  #####
' ##########################
'
FUNCTION  MinScreen (state)

			#iconized=state

			XgrGetWindowPositionAndSize (#OutputWindow, @xpos, @ypos, @xwidth, yheight)
			IF state=-1 THEN
						XgrSetWindowPositionAndSize (#IconWindowWindow, xpos, ypos, xwidth , 21)
			ELSE
						XgrSetWindowPositionAndSize (#IconWindowWindow, xpos, ypos, 34 , 34)
			END IF

			XgrGetWindowPositionAndSize (#OutputWindow, @#Xpos, @#Ypos, @#WidthOld, @#HeightOld)

			XgrShowWindow (#IconWindowWindow)
			XgrHideWindow (#OutputWindow)
			XgrHideWindow (#ToolsWindow)
			XgrSetSelectedWindow (#IconWindowWindow)
			SetFocusOnGrid (#IconWindowWindow)

			#MaxSstate=1
			#MinSize=1

END FUNCTION
'
'
' ##################################
' #####  DrawOutputBorders ()  #####
' ##################################
'
FUNCTION  DrawOutputBorders ()
	SHARED Image ImageFormat[]
	SHARED SINGLE hh,ww

	drawImageBorder (#borderColour)
	DrawSignalButtons ()

	XgrDrawLine (#OutputG, $$Grey , 0, #v3-19, 0, #v3)
	pos=(ImageFormat[#ImageSet,0].totalimages*30)+20
'	XgrDrawLine (#OutputG, $$White, pos, #v3-20,pos, #v3)
	XgrDrawLine (#OutputG, $$Grey, pos+1, #v3-20,pos+1, #v3)
	XgrDrawLine (#OutputG, $$Grey, pos-1, #v3-20, #v2, #v3-20)

	IF ((#Tdock<>1) AND (#ToolMenuBottonState=1) AND (#ToolsWindow>10)) THEN DrawToolsBorder ()

END FUNCTION
'
'
' ###############################
' #####  GetNextDataSet ()  #####
' ###############################
'
FUNCTION  GetNextDataSet ()
	SHARED Image ImageFormat[]
	SHARED MemDataSet ImageDataSet[]


'	clearSigBTarea ()

	FOR pos= ImageDataSet[#ImageSet].currentImageBt TO ImageFormat[#ImageSet,0].totaldatasets

			IF ImageFormat[#ImageSet,pos].active=1 THEN
					#dataFile=pos
					InitVariables ()
					EXIT FUNCTION
			END IF

	NEXT pos


' shouldnt ever reach this point.
	#dataFile=ImageFormat[#ImageSet,0].firstdataset: InitVariables (): EXIT FUNCTION


END FUNCTION
'
'
' ##############################
' #####  ContextSelect ()  #####
' ##############################
'
FUNCTION  ContextSelect ()
	SHARED TrackData TrackInfo[]
	SHARED Image ImageFormat[]
	SHARED MemDataSet ImageDataSet[]
	SHARED cMenuPos cMenu[]
	SHARED SINGLE ww,hh,cur
	SHARED UBYTE image[]
	SHARED cTimer

	XstKillTimer (cTimer)
	#cmenu=0

	SELECT CASE cMenu[0].item
			CASE 0			:GOSUB menuFile
			CASE 1			:GOSUB menuDisplay
			CASE 2			:GOSUB menuScale
			CASE 3			:GOSUB menuTools
			CASE 4			:GOSUB menuHelp
			CASE 5			:GOSUB menuDataSet
	END SELECT

EXIT FUNCTION


'###################
SUB menuDataSet
'###################

	set=cMenu[1].item

	IF set>UBOUND (ImageDataSet[]) THEN EXIT FUNCTION

	FOR pos=0 TO UBOUND (ImageDataSet[])

			IF ImageDataSet[pos].cMenuNo=set+1 THEN
						IF ImageDataSet[pos].stDisplayOL=0 THEN ImageDataSet[pos].stDisplay=0
						SetCurrentDataSet (pos)
						EXIT FUNCTION
			END IF

	NEXT pos

END SUB


'####################
SUB menuZoom
'####################

	SELECT CASE cMenu[2].item
			CASE 0			:#row=1: #col=1
			CASE 1			:#row=2: #col=2
			CASE 2			:#row=3: #col=3
			CASE 3			:#row=4: #col=4
			CASE 4			:#row=5: #col=5
			CASE 5			:#row=6: #col=6
			CASE 6			:#row=7: #col=7
			CASE 7			:#row=8: #col=8
			CASE 8			:#row=9: #col=9
			CASE 9			:#row=10: #col=10
			CASE 10			:#row=20: #col=20
			CASE 11			:#row=50: #col=50
			CASE ELSE		:EXIT FUNCTION
	END SELECT

	#copyImage=1
	GetNewImage (#image,1,1,0)

END SUB


'####################
SUB menuScale
'####################

	SELECT CASE cMenu[1].item
			CASE 0			:ScaleRange()
			CASE 1			:cur=cur+ImageFormat[#ImageSet,#dataFile].fPixel:	ImageFormat[#ImageSet,#dataFile].fPixel=0: ImageFormat[#ImageSet,#dataFile].lPixel=ImageFormat[#ImageSet,#dataFile].NumberOfPixels-1: ClearHcoverField ()
									 DisplayTrack (ImageDataSet[#ImageSet].Track,0)
			CASE 2			:ScaleToAllTracks (): IF ImageDataSet[#ImageSet].MaxValue<=ImageDataSet[#ImageSet].MinValue THEN ImageDataSet[#ImageSet].MaxValue=ImageDataSet[#ImageSet].MinValue+1

									IF #currentDisplay=1 THEN
											DisplayTrack (ImageDataSet[#ImageSet].Track,0)
									ELSE
											IF TrackInfo[0].valid=0 THEN ScaleAllTracksCalc (#ImageSet)
											#MaxVi=TrackInfo[#maxTrack].MaxPoint
											#copyImage=1
											GetNewImage (#image,1,1,0)
									END IF
			CASE 3			:ResetScale ()
			CASE 4			:IF #AutoScale=1 THEN #AutoScale=0 ELSE #AutoScale=1: AutoScaleAll(#ImageSet): ScaleRange()
			CASE 5			:IF (cMenu[2].item>=0) THEN #ScaleType=cMenu[2].item: ScaleRange()
	END SELECT

END SUB


'####################
SUB menuSize
'####################

	SELECT CASE cMenu[2].item
			CASE 0			:#MaxSstate=0: MaxScreen()
			CASE 1			:MinScreen(-1)
			CASE 2			:#MaxSstate=0: XgrSetWindowPositionAndSize (#OutputWindow,#Xpos, #Ypos, #WidthOld, #HeightOld)
			CASE 3			:MinScreen(5)
	END SELECT

END SUB


'####################
SUB menuScheme
'####################

	oldtheme=#colourTheme

	SELECT CASE cMenu[2].item
			CASE 0			:IF #colourTheme<#colourThemeMx THEN INC #colourTheme
			CASE 1			:IF #colourTheme>0 THEN DEC #colourTheme
			CASE 2			:#colourTheme=#colourThemeDf
	END SELECT

	IF #colourTheme<>oldtheme THEN
				SetColourTheme (#colourTheme)
				RedrawAllWindows ()
	END IF

END SUB


'####################
SUB menuMenuBar
'####################

	IF cMenu[2].item=0 THEN
'				#ButtonMenuOn=1

				IF #ButtonMenu=0 THEN
							ShowButtonMenu (20)
				#ButtonMenuOn=1

				ELSE
							HideButtonMenu (20)
				#ButtonMenuOn=0

				END IF
	ELSE
				IFZ #ButtonMenuOn THEN #ButtonMenuOn=1 ELSE #ButtonMenuOn=0
	END IF

END SUB


'####################
SUB menuTools
'####################

	SELECT CASE cMenu[1].item
			CASE 0			:GOSUB menuMenuBar
			CASE 1			:ToolMenuState ()
			CASE 2			:GetBlemSpots  (6,ImageFormat[#ImageSet,#dataFile].NumberOfPixels-5,ImageFormat[#ImageSet,#dataFile].NumberOfTracks-5,6,0.75)
			CASE 3			:IF #trackCursor=0 THEN
									 #trackCursor=1
												MouseMove (v0, v1, v2, v3)
									 ELSE
												#trackCursor=0
												XgrMoveTo (#Output, 430,#v3-18)
												XgrDrawTextFill (#Output, #ink,#textClear$)
									 END IF
			CASE 4			:SpeedTest ()
			CASE 5			:GOSUB menuScheme
			CASE 6			:GOSUB menuStyle
			CASE 7			:ShowFields (#dataFile,@ImageFormat[])
	END SELECT

END SUB


'####################
SUB menuStyle
'####################

	SELECT CASE	cMenu[2].item
			CASE 0			:#cMenuType=1
			CASE 1			:#cMenuType=2
			CASE 2			:#cMenuType=3
			CASE 3			:#cMenuType=4
			CASE 4			:#cMenuType=5
			CASE 5			:#cMenuType=2
	END SELECT

	DrawToolsBorder ()

END SUB


'####################
SUB menuHelp
'####################

	SELECT CASE cMenu[1].item
'		CASE 0			:
		CASE 1			:XuiSendMessage (#About, #DisplayWindow, 0, 0, 0, 0, 0, 0)
	END SELECT

END SUB


'####################
SUB menuDisplayMode
'####################

	SELECT CASE cMenu[2].item
		CASE 0			: IF #currentDisplay<>1 THEN #currentDisplay=2: SwitchDisplayMode ()
									EXIT FUNCTION
		CASE 1,2,3	: #imageMode=cMenu[2].item
	END SELECT

	IF #currentDisplay=1 THEN
				SwitchDisplayMode ()
	ELSE
				#copyImage=1
				GetNewImage (#image,1,1,0)
	END IF

END SUB


'####################
SUB menuDisplay
'####################

	SELECT CASE cMenu[1].item
		CASE 0			:GOSUB menuDisplayMode
		CASE 1			:GOSUB menuZoom
		CASE 2			:GOSUB menuWcursor
		CASE 3			:GOSUB menuPcursor
		CASE 4			:GOSUB menuSize
	END SELECT

END SUB


'####################
SUB menuWcursor
'####################

	IF cMenu[2].item=0 THEN
				XuiSendMessage (#image, #SetCursor,#cursorCrosshair, 0, 0, 0, 0, 0)
	ELSE
				XuiSendMessage (#image, #SetCursor,#cursorNone, 0, 0, 0, 0, 0)
	END IF

	#sCursorType=cMenu[2].item

END SUB


'####################
SUB menuPcursor
'####################

	#CType=cMenu[2].item

	IF #CType=4 THEN #CType=0
	IF #currentDisplay=1 THEN DisplayTrack (ImageDataSet[#ImageSet].Track,0)

END SUB


'####################
SUB menuFile
'####################

	SELECT CASE cMenu[1].item
			CASE 0				:GOSUB menuFileOpen
			CASE 1				:XuiSendMessage (#FileList, #DisplayWindow, 0, 0, 0, 0, 0, 0)
			CASE 2				:ReadLastFile ()
			CASE 3				:ReadNextFile ()
			CASE 4				:SaveFileAs (0)
			CASE 5				:ExportFileAs (cMenu[2].item)
			CASE 6				:IF PopUpBoxB ("Are you sure?","Quit", $$MB_ICONQUESTION | $$MB_YESNO)=6 THEN Quit()
	END SELECT

END SUB

'####################
SUB menuFileOpen
'####################

	SELECT CASE cMenu[2].item
		CASE 0,1,2,3,4,5,6	:SelectFileMenu (1,cMenu[2].item)
	END SELECT


END SUB


END FUNCTION
'
'
' ##############################
' #####  ToolMenuState ()  #####
' ##############################
'
FUNCTION  ToolMenuState ()

	IFZ #ToolMenuBottonState THEN
				#ToolMenuBottonState=1
				XuiSendMessage (#Tools, #DisplayWindow, 0, 0, 0, 0, 0, 0)
		ELSE
				#ToolMenuBottonState=0
				XuiSendMessage (#Tools, #HideWindow, 0, 0, 0, 0, 0, 0)
	END IF


END FUNCTION
'
'
' ###########################
' #####  ResetScale ()  #####
' ###########################
'
FUNCTION  ResetScale ()
	SHARED TrackData TrackInfoCopy[]
	SHARED TrackData TrackInfo[]
	SHARED SINGLE ww,hh,cur
	SHARED Image ImageFormat[]


	IF #currentDisplay=1 THEN
			cur=cur+ImageFormat[#ImageSet,#dataFile].fPixel
			ImageFormat[#ImageSet,#dataFile].fPixel=0
			ImageFormat[#ImageSet,#dataFile].lPixel=ImageFormat[#ImageSet,#dataFile].NumberOfPixels-1
			IF TrackInfo[0].valid=0 THEN
						ScaleAllTracksCalc (#ImageSet)
			ELSE
						XstCopyArray (@TrackInfoCopy[],@TrackInfo[])
			END IF
			ClearHcoverField ()
			ScaleRange()
	ELSE

			#set=0
			#FirstPix=0
			#LastPix=#FirstPix+(ww/#col)
			#FirstTrack=0
			#LastTrack=MIN (SINGLE (ImageFormat[#ImageSet,#dataFile].NumberOfTracks/#row)+1,SINGLE (hh+1))
			#row=1
			#col=1
			#copyImage=1
			GetNewImage (#image,1,1,0)
			'ColourBarLabel (0)
	END IF


END FUNCTION
'
'
' ##################################
' #####  SwitchDisplayMode ()  #####
' ##################################
'
FUNCTION  SwitchDisplayMode ()
	SHARED MemDataSet ImageDataSet[]


	IF #currentDisplay=1 THEN
			#clearGrid=1
			SwitchToImage ()
'			#copyImage=1
			GetNewImage (#image,1,1,1)
	ELSE
			SwitchToTrack ()
			DisplayTrack (ImageDataSet[#ImageSet].Track,0)
	END IF

END FUNCTION
'
'
' ############################
' #####  DrawPCursor ()  #####
' ############################
'
FUNCTION  DrawPCursor (v0,v1)
	SHARED cMenuPos cMenu[]
	SHARED hh,ww

	IF cMenu[0].status=1 THEN #cDraw=0 : EXIT FUNCTION
	XgrSetGridDrawingMode (#image, $$DrawModeXOR , 0, 1)

	SELECT CASE #sCursorType
			CASE 1 				: XgrDrawLine (#image, #sCursorColour, v0 , 0, v0, hh)
										: XgrDrawLine (#image, #sCursorColour, 0, v1                                                                                                                               , ww, v1)
			CASE 2				:	size = 0
										: XgrDrawLine (#image, #sCursorColour, ww ,hh, v0+size , v1+size)
										: XgrDrawLine (#image, #sCursorColour, 0 ,0, v0-size , v1-size)
										: XgrDrawLine (#image, #sCursorColour, ww ,0, v0+size , v1-size)
										: XgrDrawLine (#image, #sCursorColour, 00 ,hh, v0-size , v1+size)
			CASE 3				: XgrDrawLine (#image, #sCursorColour, v0,v1,v0,v1+35)
	END SELECT

	XgrSetGridDrawingMode (#image, $$DrawModeSET, 0, 1)
	#oldx=v0
	#oldy=v1
	#cDraw=1

END FUNCTION
'
'
' #############################
' #####  ErasePCursor ()  #####
' #############################
'
FUNCTION  ErasePCursor ()
	SHARED ww,hh

	XgrSetGridDrawingMode (#image, $$DrawModeXOR , 0, 1)

	SELECT CASE #sCursorType
			CASE 1 				: XgrDrawLine (#image, #sCursorColour, #oldx , 0, #oldx, hh)
										: XgrDrawLine (#image, #sCursorColour, 0, #oldy, ww, #oldy)
			CASE 2				:	size = 0
										: XgrDrawLine (#image, #sCursorColour, ww ,hh, #oldx+size , #oldy+size)
										: XgrDrawLine (#image, #sCursorColour, 0 ,0, #oldx-size , #oldy-size)
										: XgrDrawLine (#image, #sCursorColour, ww ,0, #oldx+size , #oldy-size)
										: XgrDrawLine (#image, #sCursorColour, 0 ,hh, #oldx-size , #oldy+size)
			CASE 3				: XgrDrawLine (#image, #sCursorColour, #oldx,#oldy,#oldx,#oldy+35)
	END SELECT

	XgrSetGridDrawingMode (#image, $$DrawModeSET, 0, 1)
	#cDraw=0

END FUNCTION
'
'
' #######################
' #####  Redraw ()  #####
' #######################
'
FUNCTION  Redraw (window,kid,v0,v1,v2,v3)

	$Output          =   0
	$PushB1          =   1
	$PushB2          =   2
	$PushB6          =   3
	$PushB5          =   4
	$PushB4          =   5
	$PushB3          =   6
	$Label           =   7
	$PushB7          =   8
	$vTrackScroll    =   9
	$SwitchMode      =  10
	$PushB8          =  11
	$PushB9          =  12
	$PushB10         =  13
	$HvalueCover     =  14
	$InputTextLine1  =  15
	$InputLabel1     =  16
	$PushB11				 =	17
	$PushB12				 =	18
	$PushB13				 =	19
	$PushB14				 =	20
	$PushB15				 =	21
	$PushB16				 =	22
	$ToolButton			 =	23
	$Quit						 =	24
	$zoomIN					 =	25
	$zoomOUT				 =	26
	$increaseXzoom	 =	27
	$decreaseXzoom	 =	28
	$Minimize				 =	29
	$Iconize				 =  30
	$sigBt1		       =  31
	$sigBt2		       =  32
	$sigBt3		       =  33
	$sigBt4		       =  34
	$sigBt5		       =  35
	$centre		       =  36
	$close					 =	37
	$colourbar			 =	38

	SELECT CASE window
			CASE	#OutputWindow		: GOSUB redrawMain
			CASE	#ToolsWindow		: GOSUB	redrawToolsG
	END SELECT

	EXIT FUNCTION

'###############
SUB redrawMain
'###############

	IF #MinSize=1 THEN EXIT FUNCTION

	SELECT CASE kid
			CASE	37							:RedrawIcon (37) EXIT FUNCTION
			CASE	36							:RedrawIcon (36): EXIT FUNCTION
			CASE	30							:RedrawIcon (30): EXIT FUNCTION
			CASE	12							:RedrawIcon (12): drawImageBorder (#borderColour): EXIT FUNCTION
			CASE	21							:RedrawIcon (21): EXIT FUNCTION
			CASE	18							:RedrawIcon (18): EXIT FUNCTION
			CASE	17							:RedrawIcon (17): EXIT FUNCTION
			CASE	23							:RedrawIcon (23): EXIT FUNCTION
			CASE	24							:RedrawIcon (24): EXIT FUNCTION
			CASE	25							:RedrawIcon (25): EXIT FUNCTION
			CASE	26							:RedrawIcon (26): EXIT FUNCTION
			CASE	43							:RedrawIcon (43): EXIT FUNCTION
			CASE	44							:RedrawIcon (46): EXIT FUNCTION
			CASE	39							:RedrawIcon (39): DrawInfo (): DrawXinfo (): EXIT FUNCTION
			CASE	40							:RedrawIcon (40): DrawInfo (): DrawXinfo (): EXIT FUNCTION
			CASE	$decreaseXzoom	:RedrawIcon ($decreaseXzoom): EXIT FUNCTION
			CASE	$increaseXzoom	:RedrawIcon ($increaseXzoom): EXIT FUNCTION
			CASE	$PushB8					:RedrawIcon ($PushB8): DrawXinfo (): EXIT FUNCTION
			CASE 	8								:RedrawIcon (8): EXIT FUNCTION
			CASE 	$PushB1					:RedrawIcon (1): DrawXinfo (): EXIT FUNCTION
			CASE 	$PushB2					:RedrawIcon (2): DrawXinfo (): EXIT FUNCTION
			CASE 	$PushB3					:RedrawIcon ($PushB3): DrawXinfo (): EXIT FUNCTION
			CASE 	$PushB4					:RedrawIcon ($PushB4): DrawXinfo (): EXIT FUNCTION
			CASE	$PushB5					:RedrawIcon ($PushB5): DrawXinfo (): EXIT FUNCTION
			CASE	$vTrackScroll		:DrawXinfo (): EXIT FUNCTION
			CASE	$PushB10				:RedrawIcon ($PushB10): EXIT FUNCTION
			CASE	$PushB13				:RedrawIcon ($PushB13): EXIT FUNCTION
			CASE	$PushB14				:RedrawIcon ($PushB14): EXIT FUNCTION
			CASE	$PushB16				:RedrawIcon ($PushB16): EXIT FUNCTION
			CASE	$PushB7					:DrawXinfo (): EXIT FUNCTION
			CASE	$PushB5					:DrawXinfo (): EXIT FUNCTION
			CASE	$SwitchMode			:IF #currentDisplay=1 THEN RedrawIcon (0) ELSE RedrawIcon ($SwitchMode)
														 DrawXinfo (): EXIT FUNCTION
			CASE	$colourbar			:ColourBar (0,0)
			CASE	$Minimize				:RedrawIcon ($Minimize): EXIT FUNCTION

			CASE 	ELSE						: #disableCEO=1  '  testing

															IF kid = 7 THEN
																	XgrDrawImage (#image,#memBuffer, v0, v1, v0+v2, v1+v3, v0, v1)
															END IF

															DrawOutputBorders ()
															DrawInfo()

															#disableCEO=0
															EXIT FUNCTION
		END SELECT

END SUB


'#################
SUB redrawToolsG
'#################

	EXIT FUNCTION

END SUB




END FUNCTION
'
'
' ########################
' #####  KeyDown ()  #####
' ########################
'
FUNCTION  KeyDown (v0,v1,v2)

	button$=CHR$(v2{$$KeyASCII})

'	button$=CHR$(v2{$$VirtualKey})
	KeyPressed (button$)

END FUNCTION
'
'
' #################################
' #####  ScaleToAllTracks ()  #####
' #################################
'
FUNCTION  ScaleToAllTracks ()
	SHARED TrackData TrackInfo[]
	SHARED MemDataSet ImageDataSet[]

	IF TrackInfo[0].valid=0 THEN ScaleAllTracksCalc (#ImageSet)
	ImageDataSet[#ImageSet].MaxValue=TrackInfo[#maxTrack].MaxPoint			'GetMaxVvalue ()
	ImageDataSet[#ImageSet].MinValue=TrackInfo[#minTrack].MinPoint
	#MaxVi!=ImageDataSet[#ImageSet].MaxValue
	#MinVi!=ImageDataSet[#ImageSet].MinValue

	setTrackVoffset (#ImageSet)

	IF #currentDisplay=1 THEN
				DisplayTrack (ImageDataSet[#ImageSet].Track,0)
	ELSE
				#copyImage=1
				#clearO1=0
				GetNewImage (#image,1,1,0)
				ColourBarLabel (0)
	END IF


END FUNCTION
'
'
' #############################
' #####  CentreWindow ()  #####
' #############################
'
FUNCTION  CentreWindow (Window)
	' function incomplete


	IF Window=#OutputWindow THEN
			#MaxSstate=0
			XgrGetWindowPositionAndSize (Window, @#Xpos, @#Ypos, @#WidthOld, @#HeightOld)
			XgrSetWindowPositionAndSize (Window, (#displayWidth-#defaultWW)*0.5, (#displayHeight-#defaultHH)*0.5, #defaultWW, #defaultHH)
			PlaceToolbar ()
	ELSE
			XgrGetWindowPositionAndSize (Window, x,y,@Width, @Height)
			XgrSetWindowPositionAndSize (Window, (#displayWidth-Width)*0.5, (#displayHeight-Height)*0.5, -1,-1)
	END IF


END FUNCTION
'
'
' #################################
' #####  LineTypeSelect2d ()  #####
' #################################
'
FUNCTION  LineTypeSelect2d ()
	SHARED MemDataSet ImageDataSet[]


	IFZ #LineType THEN INC #LineType ELSE DEC #LineType
	DisplayTrack(ImageDataSet[#ImageSet].Track,0)

END FUNCTION
'
'
' #################################
' #####  CursorTypeSelect ()  #####
' #################################
'
FUNCTION  CursorTypeSelect ()
	SHARED MemDataSet ImageDataSet[]


	INC #CType
	IF #CType=5 THEN #CType=0
	DisplayTrack(ImageDataSet[#ImageSet].Track,0)

END FUNCTION
'
'
' #################################
' #####  NextScalingRange ()  #####
' #################################
'
FUNCTION  NextScalingRange ()

	INC #ScaleType
	IF ((#ScaleType > $$maxScaleRange) OR ((#ScaleType = $$maxScaleRange) AND (#customMin=#customMax))) THEN #ScaleType=0

	ScaleRange ()

END FUNCTION
'
'
' ###########################
' #####  vScaleDown ()  #####
' ###########################
'
FUNCTION  vScaleDown ()
	SHARED MemDataSet ImageDataSet[]

	IF #currentDisplay=1 THEN
				d!=((ImageDataSet[#ImageSet].MaxValue-ImageDataSet[#ImageSet].MinValue)/100)*10
				ImageDataSet[#ImageSet].MaxValue=ImageDataSet[#ImageSet].MaxValue+d!
				#dontupdate=1

				checkMaxVvalue (@text$)
				setTrackVoffset (#ImageSet)

				DisplayTrack (ImageDataSet[#ImageSet].Track,0)

				IF #error THEN error (text$)

	ELSE
				DEC #row: IF #row<1 THEN #row=1: EXIT FUNCTION
				#copyImage=1
				GetNewImage (#image,1,1,0)
	END IF

END FUNCTION
'
'
' #########################
' #####  vScaleUp ()  #####
' #########################
'
FUNCTION  vScaleUp ()
	SHARED MemDataSet ImageDataSet[]

	IF #currentDisplay=1 THEN
				d!=((ImageDataSet[#ImageSet].MaxValue-ImageDataSet[#ImageSet].MinValue)/100)*10
				ImageDataSet[#ImageSet].MaxValue=ImageDataSet[#ImageSet].MaxValue-d!
				#dontupdate=1

				checkMaxVvalue (@text$)
				setTrackVoffset (#ImageSet)

				DisplayTrack (ImageDataSet[#ImageSet].Track,0)

				IF #error THEN error (text$)
	ELSE
				INC #row
				#copyImage=1
				GetNewImage (#image,1,1,0)
	END IF

END FUNCTION
'
'
' #########################
' #####  zoomOUTi ()  #####
' #########################
'
FUNCTION  zoomOUTi ()

	IF ((#col=1) AND (#row=1)) THEN EXIT FUNCTION

	DEC #row: DEC #col

	IF #col > 10 THEN #col=#col-2
	IF #row > 10 THEN #col=#row-2
	IF #col < 1 THEN #col=1
	IF #row < 1 THEN #row=1

	#copyImage=1
	GetNewImage (#image,1,1,0)

END FUNCTION
'
'
' ########################
' #####  zoomINi ()  #####
' ########################
'
FUNCTION  zoomINi ()

	INC #row: INC #col
	#copyImage=1
	#clearO1=0
	GetNewImage (#image,1,1,0)

END FUNCTION
'
'
' #################################
' #####  clearImageBorder ()  #####
' #################################
'
FUNCTION  clearImageBorder (w,h)

	XgrDrawBox (#OutputG, #background , #leftmargin-1,#topmargin-1, w+#leftmargin+1,h+#topmargin+1)


END FUNCTION
'
'
' ###############################
' #####  setfileBThints ()  #####
' ###############################
'
FUNCTION  setfileBThints ()

	IF #filetype = 3 THEN RETURN 	' ignore .dat files

	file=#FileNumber-1
	IF file <0 THEN file=#NumberOfFiles
	XuiSendMessage (#nextfg, #SetHintString, 0, 0, 0, 0, 0, #ListOfDataFiles$[file])

	file=#FileNumber+1
	IF file > #NumberOfFiles THEN file=0
	XuiSendMessage (#prefg, #SetHintString, 0, 0, 0, 0, 0,#ListOfDataFiles$[file])

END FUNCTION
'
'
' ###############################
' #####  clearSigBTarea ()  #####
' ###############################
'
FUNCTION  clearSigBTarea ()

	g=#OutputG
	h=20
	bwidth=35

	XgrFillBox (g,#background,0,#v3-h,5*bwidth,#v3)


END FUNCTION
'
'
' #######################
' #####  PlayKf ()  #####
' #######################
'
FUNCTION  PlayKf ()
	SHARED Image ImageFormat[]

	IF ImageFormat[#ImageSet,#dataFile].numberOfImages<2 THEN EXIT FUNCTION
	top=ImageFormat[#ImageSet,#dataFile].top
	#PanDisplay=3
	StartTimer (@timer,@s!)

	FOR i=0 TO ImageFormat[#ImageSet,#dataFile].numberOfImages-1

			#FirstTrack=top*i
			#copyImage=1
			GetNewImage (#image,0,1,0)

	NEXT i

	PRINT CheckTimer (timer,@e#)
	total=top/(ULONG(e#)*0.001)
	PRINT "fps:",total

	#PanDisplay=0
	#copyImage=0
	GetNewImage (#image,1,0,0)

END FUNCTION
'
'
' #######################
' #####  PlayKb ()  #####
' #######################
'
FUNCTION  PlayKb ()
	SHARED Image ImageFormat[]

	IF ImageFormat[#ImageSet,#dataFile].numberOfImages<2 THEN EXIT FUNCTION

	top=ImageFormat[#ImageSet,#dataFile].top
	#PanDisplay=3

	FOR i=ImageFormat[#ImageSet,#dataFile].numberOfImages-1 TO 0 STEP -1

			#FirstTrack=top*i
			#copyImage=1
			GetNewImage (#image,0,1,0)

	NEXT i

	#PanDisplay=0
	#copyImage=0
	GetNewImage (#image,1,0,0)


END FUNCTION
'
'
' #######################
' #####  NextKi ()  #####
' #######################
'
FUNCTION  NextKi ()
	SHARED Image ImageFormat[]
	SHARED MemDataSet ImageDataSet[]


	top=ImageFormat[#ImageSet,#dataFile].top

	IF #currentDisplay=1 THEN
				ImageDataSet[#ImageSet].Track=ImageDataSet[#ImageSet].Track+top
				IF ImageDataSet[#ImageSet].Track>ImageFormat[#ImageSet,#dataFile].NumberOfTracks-1 THEN ImageDataSet[#ImageSet].Track=ImageDataSet[#ImageSet].Track-top
				DisplayTrack (ImageDataSet[#ImageSet].Track,0)
	ELSE
				#FirstTrack=#FirstTrack+top
				#copyImage=1
				GetNewImage (#image,1,1,0)
	END IF


END FUNCTION
'
'
' #######################
' #####  BackKi ()  #####
' #######################
'
FUNCTION  BackKi ()
	SHARED Image ImageFormat[]
	SHARED MemDataSet ImageDataSet[]


	top=ImageFormat[#ImageSet,#dataFile].top

	IF #currentDisplay=1 THEN
				ImageDataSet[#ImageSet].Track=ImageDataSet[#ImageSet].Track-top
				IF ImageDataSet[#ImageSet].Track<0 THEN ImageDataSet[#ImageSet].Track=ImageDataSet[#ImageSet].Track+top
				DisplayTrack (ImageDataSet[#ImageSet].Track,0)
	ELSE
				#FirstTrack=#FirstTrack-top
				IF #FirstTrack<0 THEN #FirstTrack=0
				#copyImage=1
				GetNewImage (#image,1,1,0)
	END IF


END FUNCTION
'
'
' ######################################
' #####  decreaseMaxScaleRange ()  #####
' ######################################
'
FUNCTION  decreaseMaxScaleRange ()
	SHARED MemDataSet ImageDataSet[]

	IF #currentDisplay=2 THEN

				d!=((ImageDataSet[#ImageSet].MaxValue-ImageDataSet[#ImageSet].MinValue)/100)*#zoomZImageMx!
				ImageDataSet[#ImageSet].MaxValue=ImageDataSet[#ImageSet].MaxValue+d!
		'		ImageDataSet[#ImageSet].MinValue=ImageDataSet[#ImageSet].MinValue+d!

				#MaxVi!=ImageDataSet[#ImageSet].MaxValue
		'		#MinVi!=ImageDataSet[#ImageSet].MaxValue

				#ClearMessageQueue=2
				#copyImage=1
				GetNewImage (#image,1,1,0)
				ColourBarLabel (0)
	ELSE
				d!=((ImageDataSet[#ImageSet].MaxValue-ImageDataSet[#ImageSet].MinValue)/100)*#zoomYtrackMn!
				ImageDataSet[#ImageSet].MaxValue=ImageDataSet[#ImageSet].MaxValue+d!
		'		ImageDataSet[#ImageSet].MinValue=ImageDataSet[#ImageSet].MinValue+d!

				checkMaxVvalue (@text$)
				setTrackVoffset (#ImageSet)
				DisplayTrack (ImageDataSet[#ImageSet].Track,0)

				IF #error THEN error (text$)

	END IF

END FUNCTION
'
'
' ######################################
' #####  increaseMaxScaleRange ()  #####
' ######################################
'
FUNCTION  increaseMaxScaleRange ()
	SHARED MemDataSet ImageDataSet[]

	IF #currentDisplay=2 THEN

				d!=((ImageDataSet[#ImageSet].MaxValue-ImageDataSet[#ImageSet].MinValue)/100)*#zoomZImageMx!
				ImageDataSet[#ImageSet].MaxValue=ImageDataSet[#ImageSet].MaxValue-d!
		'		ImageDataSet[#ImageSet].MinValue=ImageDataSet[#ImageSet].MinValue-d!

				#MaxVi!=ImageDataSet[#ImageSet].MaxValue
		'		#MinVi!=ImageDataSet[#ImageSet].MaxValue

				#ClearMessageQueue=2
				#copyImage=1
				GetNewImage (#image,1,1,0)
				ColourBarLabel (0)
	ELSE
				d!=((ImageDataSet[#ImageSet].MaxValue-ImageDataSet[#ImageSet].MinValue)/100)*#zoomYtrackMx!
				ImageDataSet[#ImageSet].MaxValue=ImageDataSet[#ImageSet].MaxValue-d!
		'		ImageDataSet[#ImageSet].MinValue=ImageDataSet[#ImageSet].MinValue-d!

				checkMaxVvalue (@text$)
				setTrackVoffset (#ImageSet)
				DisplayTrack (ImageDataSet[#ImageSet].Track,0)

				IF #error THEN error (text$)

	END IF

END FUNCTION
'
'
' ######################################
' #####  decreaseMinScaleRange ()  #####
' ######################################
'
FUNCTION  decreaseMinScaleRange ()
	SHARED MemDataSet ImageDataSet[]

	IF #currentDisplay=2 THEN

				d!=((ImageDataSet[#ImageSet].MaxValue-ImageDataSet[#ImageSet].MinValue)/100)*#zoomZImageMn!
		'		ImageDataSet[#ImageSet].MaxValue=ImageDataSet[#ImageSet].MaxValue+d!
				ImageDataSet[#ImageSet].MinValue=ImageDataSet[#ImageSet].MinValue+d!

		'		#MaxVi!=ImageDataSet[#ImageSet].MaxValue
				#MinVi!=ImageDataSet[#ImageSet].MinValue

				#ClearMessageQueue=2
				#copyImage=1
				GetNewImage (#image,1,1,0)
				ColourBarLabel (0)
	ELSE
				d!=((ImageDataSet[#ImageSet].MaxValue-ImageDataSet[#ImageSet].MinValue)/100)*10
		'		ImageDataSet[#ImageSet].MaxValue=ImageDataSet[#ImageSet].MaxValue+d!
				ImageDataSet[#ImageSet].MinValue=ImageDataSet[#ImageSet].MinValue+d!

				checkMaxVvalue (@text$)
				setTrackVoffset (#ImageSet)
				DisplayTrack (ImageDataSet[#ImageSet].Track,0)

				IF #error THEN error (text$)

	END IF

END FUNCTION
'
'
' ######################################
' #####  increaseMinScaleRange ()  #####
' ######################################
'
FUNCTION  increaseMinScaleRange ()
	SHARED MemDataSet ImageDataSet[]

	IF #currentDisplay=2 THEN

				d!=((ImageDataSet[#ImageSet].MaxValue-ImageDataSet[#ImageSet].MinValue)/100)*#zoomZImageMn!
		'		ImageDataSet[#ImageSet].MaxValue=ImageDataSet[#ImageSet].MaxValue-d!
				ImageDataSet[#ImageSet].MinValue=ImageDataSet[#ImageSet].MinValue-d!

		'		#MaxVi!=ImageDataSet[#ImageSet].MaxValue
				#MinVi!=ImageDataSet[#ImageSet].MinValue

				#ClearMessageQueue=2
				#copyImage=1
				GetNewImage (#image,1,1,0)
				ColourBarLabel (0)
	ELSE
				d!=((ImageDataSet[#ImageSet].MaxValue-ImageDataSet[#ImageSet].MinValue)/100)*10
				ImageDataSet[#ImageSet].MaxValue=ImageDataSet[#ImageSet].MaxValue-d!
		'		ImageDataSet[#ImageSet].MinValue=ImageDataSet[#ImageSet].MinValue-d!

				checkMaxVvalue (@text$)
				setTrackVoffset (#ImageSet)
				DisplayTrack (ImageDataSet[#ImageSet].Track,0)

				IF #error THEN error (text$)

	END IF

END FUNCTION
'
'
' #########################
' #####  imageFix ()  #####
' #########################
'
FUNCTION  imageFix ()

	IF #currentDisplay<>2 THEN EXIT FUNCTION

	INC #imagefix
	IF #imagefix=4 THEN #imagefix=0

	#copyImage=1
	GetNewImage (#image,1,1,0)


END FUNCTION
'
'
' ########################
' #####  downTrk ()  #####
' ########################
'
FUNCTION  downTrk ()
	SHARED MemDataSet ImageDataSet[]


	IF #currentDisplay=1 AND (ImageDataSet[#ImageSet].Track >1) THEN DEC ImageDataSet[#ImageSet].Track
	IF ((#sCursorType>0) AND (#cDraw>0)) THEN ErasePCursor ()

	IF #AutoScale	THEN
				ScaleRange ()
	ELSE
				#drawYinfo=0: #drawXinfo=0
				DisplayTrack (ImageDataSet[#ImageSet].Track,0)
				#drawYinfo=1: #drawXinfo=1
	END IF


END FUNCTION
'
'
' ######################
' #####  upTrk ()  #####
' ######################
'
FUNCTION  upTrk ()
	SHARED Image ImageFormat[]
	SHARED MemDataSet ImageDataSet[]

	IF (ImageDataSet[#ImageSet].Track < ImageFormat[#ImageSet,#dataFile].NumberOfTracks) THEN INC ImageDataSet[#ImageSet].Track
	IF ((#sCursorType>0) AND (#cDraw>0)) THEN ErasePCursor ()

	IF #AutoScale	THEN
				ScaleRange ()
	ELSE
				#drawYinfo=0: #drawXinfo=0
				DisplayTrack (ImageDataSet[#ImageSet].Track,0)
				#drawYinfo=1: #drawXinfo=1
	END IF


END FUNCTION
'
'
' ##########################
' #####  pixelLeft ()  #####
' ##########################
'
FUNCTION  pixelLeft ()
	SHARED Image ImageFormat[]
	SHARED MemDataSet ImageDataSet[]
	SHARED cur

	IF ((cur>=0) ) THEN
				cur=cur-1
				#drawXinfo=0

				IF ((cur<0) AND (ImageFormat[#ImageSet,#dataFile].fPixel>10)) THEN
							ImageFormat[#ImageSet,#dataFile].fPixel=ImageFormat[#ImageSet,#dataFile].fPixel-10
							ImageFormat[#ImageSet,#dataFile].lPixel=ImageFormat[#ImageSet,#dataFile].lPixel-10
							cur=cur+10
							#drawXinfo=2
				END IF

				IF  ((cur<0) AND (ImageFormat[#ImageSet,#dataFile].fPixel<11) AND (ImageFormat[#ImageSet,#dataFile].fPixel>0)) THEN
							INC cur
							DEC ImageFormat[#ImageSet,#dataFile].lPixel
							DEC ImageFormat[#ImageSet,#dataFile].fPixel
							#drawXinfo=2
				END IF

				IF cur<0 THEN cur=0
	ELSE
				#drawYinfo=1: #drawXinfo=1
				EXIT FUNCTION
	END IF

	IF ((#sCursorType>0) AND (#cDraw>0)) THEN ErasePCursor ()
	IF #drawXinfo=1	THEN ClearHcoverField ()

	#drawYinfo=0
	DisplayTrack (ImageDataSet[#ImageSet].Track,0)
	#drawYinfo=1: #drawXinfo=1

END FUNCTION
'
'
' ###########################
' #####  pixelRight ()  #####
' ###########################
'
FUNCTION  pixelRight ()
	SHARED Image ImageFormat[]
	SHARED MemDataSet ImageDataSet[]
	SHARED cur

	IF cur < (ImageFormat[#ImageSet,#dataFile].NumberOfPixels-1) AND ((cur+ImageFormat[#ImageSet,#dataFile].fPixel) < (ImageFormat[#ImageSet,#dataFile].NumberOfPixels-1)) THEN
				cur=cur+1
				#drawXinfo=0

				IF ((cur > #scrpix) AND (ImageFormat[#ImageSet,#dataFile].lPixel<ImageFormat[#ImageSet,#dataFile].NumberOfPixels) ) THEN
							ImageFormat[#ImageSet,#dataFile].fPixel=ImageFormat[#ImageSet,#dataFile].fPixel+10
							ImageFormat[#ImageSet,#dataFile].lPixel=ImageFormat[#ImageSet,#dataFile].lPixel+10
							cur=cur-10
							#drawXinfo=2
				END IF

				IF (ImageFormat[#ImageSet,#dataFile].lPixel>=ImageFormat[#ImageSet,#dataFile].NumberOfPixels) THEN
							ImageFormat[#ImageSet,#dataFile].fPixel=ImageFormat[#ImageSet,#dataFile].fPixel-(ImageFormat[#ImageSet,#dataFile].lPixel-ImageFormat[#ImageSet,#dataFile].NumberOfPixels)
							cur=cur-(ImageFormat[#ImageSet,#dataFile].NumberOfPixels-ImageFormat[#ImageSet,#dataFile].lPixel)
							ImageFormat[#ImageSet,#dataFile].lPixel=ImageFormat[#ImageSet,#dataFile].NumberOfPixels-1
							#drawXinfo=2
				END IF
	ELSE
				#drawYinfo=1: #drawXinfo=1
				EXIT FUNCTION
	END IF

	IF ((#sCursorType>0) AND (#cDraw>0)) THEN ErasePCursor ()

	#drawYinfo=0
	DisplayTrack (ImageDataSet[#ImageSet].Track,0)
	#drawYinfo=1: #drawXinfo=1

END FUNCTION
'
'
' #############################
' #####  nextColTable ()  #####
' #############################
'
FUNCTION  nextColTable ()

	INC #imageMode
	IF #imageMode=4 THEN #imageMode=1
	IF #currentDisplay=2 THEN #copyImage=1: GetNewImage (#image,1,1,0): ColourBar (0,0)

END FUNCTION
'
'
' #################################
' #####  DisplayScaledTrk ()  #####
' #################################
'
FUNCTION  DisplayScaledTrk ()
	SHARED MemDataSet ImageDataSet[]

	IF #AutoScale	THEN
				ScaleRange()
	ELSE
				#drawYinfo=0
				#drawXinfo=0
				DisplayTrack (ImageDataSet[#ImageSet].Track,0)
				#drawYinfo=1
				#drawXinfo=1
	END IF

END FUNCTION
'
'
' ##############################
' #####  vScrollChange ()  #####
' ##############################
'
FUNCTION  vScrollChange (slot,v1,v3,lock)
	SHARED Image ImageFormat[]
	SHARED MemDataSet ImageDataSet[]

	ds=ImageDataSet[slot].DataSet
	ImageDataSet[slot].Track=ULONG(ImageFormat[slot,ds].NumberOfTracks-((ImageFormat[slot,ds].NumberOfTracks/SINGLE(v3))*v1))
	IF ImageDataSet[slot].Track >= ImageFormat[slot,ds].NumberOfTracks THEN ImageDataSet[slot].Track=ImageFormat[slot,ds].NumberOfTracks
	IF ImageDataSet[slot].Track <1 THEN ImageDataSet[slot].Track=1

	#dontupdate=2
	DisplayScaledTrk ()



END FUNCTION
'
'
' ##############################
' #####  downTenTracks ()  #####
' ##############################
'
FUNCTION  downTenTracks ()
	SHARED MemDataSet ImageDataSet[]

	IF (ImageDataSet[#ImageSet].Track > #TenTracks) THEN
				ImageDataSet[#ImageSet].Track=ImageDataSet[#ImageSet].Track-#TenTracks
	ELSE
				ImageDataSet[#ImageSet].Track=1
	END IF

	IF ((#sCursorType>0) AND (#cDraw>0)) THEN ErasePCursor ()
	DisplayScaledTrk ()

END FUNCTION
'
'
' ############################
' #####  upTenTracks ()  #####
' ############################
'
FUNCTION  upTenTracks ()
	SHARED Image ImageFormat[]
	SHARED MemDataSet ImageDataSet[]

	IF (ImageDataSet[#ImageSet].Track < (ImageFormat[#ImageSet,#dataFile].NumberOfTracks-#TenTracks)) THEN
				ImageDataSet[#ImageSet].Track=ImageDataSet[#ImageSet].Track+#TenTracks
	ELSE
				ImageDataSet[#ImageSet].Track=ImageFormat[#ImageSet,#dataFile].NumberOfTracks
	END IF

	IF ((#sCursorType>0) AND (#cDraw>0)) THEN ErasePCursor ()
	DisplayScaledTrk ()

END FUNCTION
'
'
' ################################
' #####  fileErrorHandle ()  #####
' ################################
'
FUNCTION  fileErrorHandle (pathfile$,error)
	STATIC message$,file$,tmp

	file$=#filename$

	SELECT CASE error
	'		CASE	0				:
			CASE	1				:message$=file$+"\nNo image set found": GOSUB InvalidFormat		' no image's
			CASE	2				:message$=file$+"\nCorrupt header": GOSUB InvalidFormat		'	header incorrectly parsed or read
			CASE	3				:message$="65539:  "+file$+"\nUnsupported format  (TODO)": GOSUB InvalidFormat
			CASE	4				:message$=file$+"\nInvalid file - header not recognized": GOSUB InvalidFormat		' not a sif,ii, etc..  file
			CASE	5				:message$=file$+"\nNumber of tracks < 1": GOSUB InvalidFormat		' no tracks found in image
			CASE	6				:message$=file$+"\nUnable to open file": GOSUB InvalidFormat		' unable to open file
			CASE	7				:message$=file$+"\nThis is not an Andor data file": GOSUB InvalidFormat		' file has a .sif ext but is not a sif file
			CASE	8				:message$=file$+"\nThis is not an Intaspec Image file": GOSUB InvalidFormat		' file has a .ii ext but is not an ii file
			CASE	9				:message$=file$+"\nNumber of pixel's < 2": GOSUB InvalidFormat		' no tracks found in image
			CASE	200			:
			CASE	100			:
			CASE	ELSE		:message$=STRING (error)+file$+"\nInvalid file": GOSUB InvalidFormat ' : PopUpBox (file$,"Invalid file", "Retry","Quit",1): #exitProgram=1
	END SELECT

EXIT FUNCTION


'##################
SUB InvalidFormat
'##################

	IF ((#FirstLoad=0) OR (#promptUser=1)) THEN
			#exitProgram=1
			IF #ReadDirectionState=1 THEN	tmp=8 ELSE tmp=7
			PopUpBox (pathfile$,message$,"Next","Quit",tmp)
			EXIT SUB
	END IF

'	IFZ #ReadDirectionState THEN ReadNextFile () ELSE ReadLastFile ()

END SUB


END FUNCTION
'
'
' ###################################
' #####  CycleOPWindowState ()  #####
' ###################################
'
FUNCTION  CycleOPWindowState ()
	STATIC	wstate

	IFZ wstate THEN wstate=1
	IF #MaxSstate=1 THEN wstate=1

	SELECT CASE wstate
			CASE 	1			:CentreWindow (#OutputWindow): wstate=2
			CASE 	2			:SnapToImage (): wstate=3
			CASE 	3			:MaxScreen(): wstate=1
	END SELECT

END FUNCTION
'
'
' ########################
' #####  vColBar ()  #####
' ########################
'
FUNCTION  vColBar (time)
	SHARED argb rgb[]
	SHARED ww,hh,vcolTimer,vcolstatus
	SINGLE w,dw,x,y,h
	STATIC oldhh
	SHARED T_Index


IF #currentDisplay=2 THEN EXIT FUNCTION

g=#vColbarBuff
#vColStatus=1

IF ((#imageMode<>vcolstatus) OR (oldhh<>hh)) THEN
		vcolstatus=#imageMode
		oldhh=hh
		x=0
		y=hh
		h=0
		w=10

		SELECT CASE #imageMode
			CASE 1
					dw=SINGLE(65536)/y

					FOR col=1 TO 65536 STEP dw
								XgrSetDrawingRGB (g, col, col, col)
								FOR x=0 TO w
										XgrDrawLine(g,-1,x,y,1,y-h)
								NEXT x
								y=y-1
					NEXT col

			CASE 2
					h=hh/124

					FOR col=1 TO 124
								XgrFillBox(g,col,x,y,w,y-h)
								y=y-h
					NEXT col

			CASE 3
					h=hh/37
					col=(65535/255)

					FOR a=1 TO 37

								red=rgb[a].red*col
								green=rgb[a].green*col
								blue=rgb[a].blue*col

								XgrSetDrawingRGB (g,red,green,blue)
								XgrFillBox (g,-1,x,y,w,y-h)
								y=y-h
					NEXT a

		END SELECT
END IF

IF time=1 THEN XgrDrawImage (#memBuffer,g, 0, 0, 10, hh, 0, 0): EXIT FUNCTION
XgrDrawImage (#image,g, 0, 0, 10, hh, 0, 0)

IF time>50 THEN

		XstKillTimer (vcolTimer)
		vcolTimer=0

		func=FUNCADDRESS (tWakeUp ())
		XstStartTimer (@vcolTimer ,1 ,time,func)
		T_Index=vcolTimer

END IF


END FUNCTION
'
'
' #############################
' #####  vColBarState ()  #####
' #############################
'
FUNCTION  vColBarState ()
	SHARED MemDataSet ImageDataSet[]
	SHARED hh

	IF #vColState=0 THEN
			#vColState=1
			vColBar (1)
			XgrDrawImage (#image,#memBuffer, 0, 0, 10, hh, 0, 0)
	ELSE
			#vColState=0
			#SaveImage=2
			DisplayTrack (ImageDataSet[#ImageSet].Track,0)
			XgrDrawImage (#image,#memBuffer, 0, 0, 10, hh, 0, 0)
			#SaveImage=0
	END IF

END FUNCTION
'
'
' ###########################
' #####  setvColBar ()  #####
' ###########################
'
FUNCTION  setvColBar ()
	SHARED MemDataSet ImageDataSet[]

	IF #currentDisplay=2 THEN EXIT FUNCTION

	IF #vColState=1 THEN
			DisplayTrack(ImageDataSet[#ImageSet].Track,0)
	ELSE
			vColBar (1500)
	END IF

END FUNCTION
'
'
' ########################
' #####  tWakeUp ()  #####
' ########################
'
FUNCTION  tWakeUp ()
	SHARED vcolTimer,cTimer,ImageLock,BlemTimer
	SHARED T_Index
	SHARED cMenuPos cMenu[]
	SHARED hh,cmenu

	SELECT CASE T_Index
			CASE vcolTimer	: GOSUB vColClear
			CASE cTimer			: GOSUB cMenuClear
			CASE ImageLock	: GOSUB imagelock
			CASE BlemTimer	: GOSUB blemTimer
	END SELECT

EXIT FUNCTION


'##############
SUB blemTimer
'##############

	#BlemPro=1
	XstKillTimer (BlemTimer)
	BlemTimer=0
	PopUpBox ("Blem check in progress","Processing...","Display","Quit",9)

END SUB

'###############
SUB imagelock
'###############

	#lockout=0
	XstKillTimer (ImageLock)
	ImageLock=0

END SUB


'###############
SUB cMenuClear
'###############

	XstKillTimer (cTimer)
	cMenuClearAll ()
	IF cmenu THEN cMenuClearFrom (0)
	cMenu[0].status=0
	cmenu=0
	cTimer=0

END SUB


'##############
SUB vColClear
'##############

	IF ((vcolTimer<>0) AND (#vColState<>1)) THEN
			XgrDrawImage (#image,#memBuffer, 0, 0, 10, hh, 0, 0)
			#vColStatus=0
	END IF

	XstKillTimer (vcolTimer)
	vcolTimer=0

END SUB


END FUNCTION
'
'
' ################################
' #####  GetPixelAddress ()  #####
' ################################
'
FUNCTION  GetPixelAddress (index,x,y)
	SHARED Image ImageFormat[]
	SHARED MemDataSet ImageDataSet[]

	DEC x
	DEC y

	addr=ImageDataSet[index].ImageSetAd+(((y*ImageFormat[index,ImageDataSet[index].DataSet].NumberOfPixels)+x)*4)

	RETURN addr

END FUNCTION
'
'
' ##############################
' #####  GetPixelValue ()  #####
' ##############################
'
FUNCTION  GetPixelValue (index,x,y,SINGLE value)
	SHARED Image ImageFormat[]
	SHARED MemDataSet ImageDataSet[]


'	value=SINGLEAT (GetPixelAddress (index,x,y))

	DEC x
	DEC y

	addr=ImageDataSet[index].ImageSetAd+(((y*ImageFormat[index,ImageDataSet[index].DataSet].NumberOfPixels)+x)*4)
	value=SINGLEAT (addr)

' buffer under/overflow here = wrong datatype. try again
' we handle floats only

	RETURN value

END FUNCTION
'
' ##############################
' #####  SetPixelValue ()  #####
' ##############################
'
FUNCTION  SetPixelValue (index,x,y, SINGLE value)
	SHARED Image ImageFormat[]
	SHARED MemDataSet ImageDataSet[]

'	IF ((x<1) OR (x> ImageFormat[#ImageSet,#dataFile].NumberOfPixels)) THEN RETURN 1
'	IF ((y<1) OR (y> ImageFormat[#ImageSet,#dataFile].NumberOfTracks)) THEN RETURN 2

'	ad=GetPixelAddress (index,x,y)

	DEC x
	DEC y

	SINGLEAT (ImageDataSet[index].ImageSetAd+(((y*ImageFormat[index,ImageDataSet[index].DataSet].NumberOfPixels)+x)*4))=value

END FUNCTION
'
'
' ###############################
' #####  GetPixelValueB ()  #####
' ###############################
'
FUNCTION  GetPixelValueB (slot, pixel ,SINGLE value)
	SHARED MemDataSet ImageDataSet[]

	DEC pixel
	value=SINGLEAT(ImageDataSet[slot].ImageSetAd+(pixel*4))

	RETURN value


END FUNCTION
'
'
' ###############################
' #####  SetPixelValueB ()  #####
' ###############################
'
FUNCTION  SetPixelValueB (slot, pixel ,SINGLE value)
	SHARED MemDataSet ImageDataSet[]

	DEC pixel
	SINGLEAT(ImageDataSet[slot].ImageSetAd+(pixel*4))=value

END FUNCTION
'
'
' #################################
' #####  GetPixelAddressB ()  #####
' #################################
'
FUNCTION  GetPixelAddressB (slot, pixel, address)
	SHARED MemDataSet ImageDataSet[]


	DEC pixel
	address=ImageDataSet[slot].ImageSetAd+(pixel*4)

	RETURN address



END FUNCTION
'
'
' #################################
' #####  GetMaxPointTrack ()  #####
' #################################
'
FUNCTION  SINGLE GetMaxPointTrack (imageindex,track,pixel)
	SHARED TrackData TrackInfo[]


	IF TrackInfo[0].valid=0 THEN ScaleAllTracksCalc (#ImageSet)
	pixel=TrackInfo[track].MaxPixel+1
	RETURN SINGLE (TrackInfo[track].MaxPoint)

END FUNCTION
'
'
' #################################
' #####  GetMinPointTrack ()  #####
' #################################
'
FUNCTION  SINGLE GetMinPointTrack (imageindex,track,pixel)
	SHARED TrackData TrackInfo[]


	IF TrackInfo[0].valid=0 THEN ScaleAllTracksCalc (#ImageSet)
	pixel=TrackInfo[track].MinPixel+1
	RETURN SINGLE (TrackInfo[track].MinPoint)

END FUNCTION
'
'
' #################################
' #####  GetMaxPointImage ()  #####
' #################################
'
FUNCTION  SINGLE GetMaxPointImage (index,track,pixel)
	SINGLE point

	track=GetMaxTrack (index)
	point=GetMaxPointTrack (index,track,@pixel)
	INC track
	RETURN SINGLE (point)

END FUNCTION
'
'
' #################################
' #####  GetMinPointImage ()  #####
' #################################
'
FUNCTION  SINGLE GetMinPointImage (index,track,pixel)
	SINGLE point

	track=GetMinTrack (index)
	point=GetMinPointTrack (index,track,@pixel)
	INC track
	RETURN SINGLE (point)

END FUNCTION
'
'
' ############################
' #####  GetIniValue ()  #####
' ############################
'
FUNCTION  SINGLE GetIniValue (group$,vname$,value$)
	SHARED inifile$


	GOSUB GetValue
	XstStringToNumber (value$,0,@pos,@type,@value$$)

	SELECT CASE type
			CASE $$SLONG : a! = GLOW(value$$)
			CASE $$XLONG : a! = value$$
			CASE $$SINGLE : a! = SMAKE(GLOW(value$$))
			CASE $$DOUBLE : a! = DMAKE(GHIGH(value$$), GLOW(value$$))
	END SELECT

RETURN SINGLE(a!)


'##############
SUB GetValue
'##############

	vname$=vname$+"="
	inivalue$="["+group$+"]"
	grp=0

	ifile = OPEN (inifile$, $$RDSHARE)
	IF ifile<3 THEN
				CloseConsole ()
				PopUpBoxB ("Config file missing","Initialization Error", $$MB_OK | $$MB_TOPMOST)
				Quit()
	END IF


	DO UNTIL EOF(ifile)

				line$ = INFILE$ (ifile)
				check = INSTR (line$, inivalue$)

				IF ((check>0) AND (grp=1)) THEN
							lvalue=(LEN(line$))-(LEN(inivalue$))
							value$=RIGHT$(line$,lvalue)
							EXIT DO
				END IF
				IF ((check>0) AND (grp=0)) THEN inivalue$=vname$: grp=1

				INC line
	LOOP

	CLOSE (ifile)

END SUB

END FUNCTION
'
'
' ############################
' #####  GetMaxTrack ()  #####
' ############################
'
FUNCTION  GetMaxTrack (index)

'	imageindex = data set. code is not complete

	RETURN #maxTrack

END FUNCTION
'
'
' ############################
' #####  GetMinTrack ()  #####
' ############################
'
FUNCTION  GetMinTrack (index)

'	imageindex = data set. code is not complete

	RETURN #minTrack

END FUNCTION
'
'
' ############################
' #####  GotoPixel2d ()  #####
' ############################
'
FUNCTION  GotoPixel2d (newPix,newTrk)
	SHARED cur,Scheck
	SHARED Image ImageFormat[]
	SHARED MemDataSet ImageDataSet[]

	IF ((newPix<1) OR (newPix>ImageFormat[#ImageSet,#dataFile].NumberOfPixels)) THEN EXIT FUNCTION
	IF ((newTrk<1) OR (newTrk>ImageFormat[#ImageSet,#dataFile].NumberOfTracks)) THEN EXIT FUNCTION

	cur=newPix-1-ImageFormat[#ImageSet,#dataFile].fPixel
	ImageDataSet[#ImageSet].Track=newTrk-1

	IF Scheck=0 THEN DisplayTrack (ImageDataSet[#ImageSet].Track,0) ELSE ScaleRange()

END FUNCTION
'
'
' ##########################
' #####  removeTab ()  #####
' ##########################
'
FUNCTION  removeTab (window,kid)

	XuiSendMessage (window,#GetTextString,0,0,0,0,kid,@new$)
	IF RIGHT$(new$) ="\t" THEN
			new$=LEFT$ (new$,LEN(new$)-1)
			XuiSendMessage (window,#SetTextString,0,0,0,0,kid,new$)
	END IF

END FUNCTION
'
'
' ##############################
' #####  GetGridNumber ()  #####
' ##############################
'
FUNCTION  GetGridNumber (window,kid)

	XuiSendMessage (window,#GetGridNumber, @grid, 0, 0, 0, kid, 0)
	RETURN grid

END FUNCTION
'
'
' ###############################
' #####  SetFocusOnGrid ()  #####
' ###############################
'
FUNCTION  SetFocusOnGrid (grid)

	XgrGetGridWindow (grid, @window)
	XgrSendMessage (window, #WindowSetKeyboardFocusGrid,grid,0,0,0,0,0)

END FUNCTION
'
'
' ##############################
' #####  SetFocusOnKid ()  #####
' ##############################
'
FUNCTION  SetFocusOnKid (window,kid)

	SetFocusOnGrid (GetGridNumber (window,kid))

END FUNCTION
'
'
' ##############################
' #####  DisplayWindow ()  #####
' ##############################
'
FUNCTION  DisplayWindow (window)
	SHARED Image ImageFormat[]
	SHARED MemDataSet ImageDataSet[]
	SHARED cur
'	STATIC state

	state=1

	SELECT CASE window
		CASE	#GotoWindow				:	GOSUB GotoWindow
		CASE	#SetPixelWindow		:	GOSUB SetPixelWindow
		CASE	#GetRawInfoWindow	: GOSUB GetRawInfoWindow
		CASE	#AxisWindow				:	GOSUB AxisWindow
		CASE 	#AddTraceWWindow	: state=0
		CASE	ELSE							: state=0
	END SELECT

	IF state=0 THEN
				state=GetWindowState (window)
				IFZ state THEN CentreWindow (window)
				XgrDisplayWindow (window)
	END IF

RETURN state


'###############
SUB AxisWindow
'###############

	Xleft$=STRING$(ImageFormat[#ImageSet,#dataFile].fPixel+1)
	Xright$=STRING$(ImageFormat[#ImageSet,#dataFile].lPixel+1)
	Ymin$=STRING$(SINGLE(ImageDataSet[#ImageSet].MinValue))
	Ymax$=STRING$(SINGLE(ImageDataSet[#ImageSet].MaxValue))
	Tpixels$=STRING$(ImageFormat[#ImageSet,#dataFile].NumberOfPixels)
	Ttracks$=STRING$(ImageFormat[#ImageSet,#dataFile].NumberOfTracks)

	XuiSendMessage (#Axis,#SetTextString,0,0,0,0,2,@Xleft$)
	XuiSendMessage (#Axis,#SetTextString,0,0,0,0,4,@Xright$)
	XuiSendMessage (#Axis,#SetTextString,0,0,0,0,6,@Ymin$)
	XuiSendMessage (#Axis,#SetTextString,0,0,0,0,8,@Ymax$)
	XuiSendMessage (#Axis,#SetTextString,0,0,0,0,10,@Tpixels$)
	XuiSendMessage (#Axis,#SetTextString,0,0,0,0,12,@Ttracks$)

	state=0

END SUB


'#####################
SUB GetRawInfoWindow
'#####################

	#DatInfoState=2
	#RawInfoDataType=0
	XuiSendMessage (#GetRawInfo, #MouseDown, 0, 0, 0, 0, 14, 0)
	XuiSendMessage (#GetRawInfo, #MouseDown, 0, 0, 0, 0, 16, 0)
	SetFocusOnKid (#GetRawInfo,7)

	state=0

END SUB


'###############
SUB GotoWindow
'###############

	trk$=STRING$ (ImageDataSet[#ImageSet].Track)
	pix$=STRING$ (ImageFormat[#ImageSet,#dataFile].fPixel+cur+1)
	XuiSendMessage (#Goto,#SetTextString,0,0,0,0,3,trk$)
	XuiSendMessage (#Goto,#SetTextString,0,0,0,0,4,pix$)

	state=0

END SUB


'###################
SUB SetPixelWindow
'###################

	trk$=STRING$ (ImageDataSet[#ImageSet].Track)
	pix$=STRING$ (ImageFormat[#ImageSet,#dataFile].fPixel+cur+1)
	GetPixelValue (#ImageSet,ImageFormat[#ImageSet,#dataFile].fPixel+cur+1,ImageDataSet[#ImageSet].Track,@v!)
	val$=STRING$ (v!)

	XuiSendMessage (#SetPixel,#SetTextString,0,0,0,0,3,trk$)
	XuiSendMessage (#SetPixel,#SetTextString,0,0,0,0,4,pix$)
	XuiSendMessage (#SetPixel,#SetTextString,0,0,0,0,7,val$)

	state=0

END SUB


END FUNCTION
'
'
' ###########################
' #####  HideWindow ()  #####
' ###########################
'
FUNCTION	HideWindow (window)

	XgrGetWindowState (window, @state)
	IF state=1 THEN XgrHideWindow (window)

	IF  window=#OutputWindow THEN
			XgrHideWindow (#ToolsWindow)
			#MaxSstate=1
			#MinSize=1
	END IF

END FUNCTION
'
'
' ############################
' #####  GetNewImage ()  #####
' ############################
'
FUNCTION  GetNewImage (togrid,buff,display,updatexy)
	SHARED UBYTE image[]

	IF #SnapIToWindow=1 THEN SnapToImage ()
	DrawImage ()
	'IF DrawImage ()=2 THEN EXIT FUNCTION
	IF #lockout=1 THEN EXIT FUNCTION

'	PRINT buff,display,updatexy,#PanDisplay,#copyImage,#clearO1


'	IF updatexy THEN DrawInfo()
'	SELECT CASE TRUE
'			CASE	((buff=1) AND (display=1))		:XgrSetImage (#memBuffer, @image[])
'																					 XgrCopyImage (togrid,#memBuffer)
'			CASE	((buff=0) AND (display=1))		:XgrSetImage (togrid, @image[])
'			CASE	((buff=1) AND (display=0))		:XgrSetImage (#memBuffer, @image[])
'	END SELECT

	IF #PanDisplay=3 THEN

				IF #clearO1=1 THEN
							DrawInfo():	#clearO1=0
				ELSE
							XgrSetImage (#image, @image[])
				END IF
	ELSE
				IF #PanDisplay <> 2 THEN
							XgrSetImage (#memBuffer, @image[])

							IF #clearO1=1 THEN
										DrawInfo():	#clearO1=0
							ELSE
										IF #copyImage=1 THEN XgrCopyImage (#image,#memBuffer)
										#copyImage=0
							END IF
				ELSE
							XgrSetImage (#image, @image[])
				END IF
	END IF

END FUNCTION
'
'
' ####################################
' #####  AddToOpenedFileList ()  #####
' ####################################
'
FUNCTION  AddToOpenedFileList (file$)
	SHARED LoadedFiles$[]
	SHARED imageindex

	loc=-1
	ub=UBOUND(LoadedFiles$[])
	IF imageindex>=ub THEN REDIM LoadedFiles$[ub+5]

	FOR pos=0 TO imageindex
			IF file$=LoadedFiles$[pos] THEN loc=pos: EXIT FOR
	NEXT pos

	IF loc=-1 THEN LoadedFiles$[imageindex]=file$: INC imageindex

	IF imageindex>1 THEN XuiSendMessage (#Output,#Enable,0, 0, 0, 0, 43,0)
	g=GetGridNumber (#Output,43)
	XuiSendMessage (g, #SetTextString, 0, 0, 0, 0, 0, @file$)
	XuiSendMessage (g, #SetTextArray, 0, 0, 0, 0, 0, @LoadedFiles$[])

	RETURN loc

END FUNCTION
'
'
' ############################
' #####  dImageTitle ()  #####
' ############################
'
FUNCTION  dImageTitle ()
	SHARED MemDataSet ImageDataSet[]
	STATIC oldtitle$


	title$="#"+STRING(#ImageSet+1)+"  "+ImageDataSet[#ImageSet].dsTitleL

	IF #currentDisplay=1 THEN y=#topmargin-20 ELSE y=#topmargin-50
	x=#leftmargin+2

	XgrSetGridFont (#Output,#pixfont)
	XgrMoveTo (#Output,x,y)
	XgrDrawTextFill (#Output, #background,@oldtitle$)

	oldtitle$=title$
	XgrMoveTo (#Output,x,y)
	XgrDrawTextFill (#Output, #ink,@title$)

END FUNCTION
'
'
' ##################################
' #####  ParseCommandLineA ()  #####
' ##################################
'
FUNCTION  ParseCommandLineA (file$,cmd$)
	SHARED datastart
	SHARED Image ImageFormat[]
	SHARED hh
	SHARED aTotal
	SHARED inifile$

	XstGetCommandLineArguments (@aTotal, @argv$[])
	DEC aTotal
	file$=""

	IF aTotal=0 THEN
				#ImageSet=CreateDataSlot (unused,unused2)
				SelectFileMenu (1,#ImageSet)
				LoadIcons (#defaultloc$)
	ELSE
				GOSUB GetCmds
				GOSUB ProcessCmds

				IF file$="" THEN		' file dragged onto program?
							file$=argv$[aTotal]		' try giving the last command as the filename
							GOSUB InitNewOpenFile	' here goes nothing
				END IF
	END IF


RETURN aTotal

'################
SUB ProcessCmds
'################

	SELECT CASE ALL TRUE
			CASE open=1				: GOSUB InitNewOpenFile
			CASE blacks=1			: GOSUB GetBlemSpots
			CASE help=1				:
	END SELECT

END SUB

'####################
SUB InitNewOpenFile
'####################

	#ImageSet=CreateDataSlot (unused,unused)

	GOSUB SetPixRange
	FindMoreDataFiles (file$)
	LoadIcons (#defaultloc$)
	LoadFile (file$,#ImageSet)

END SUB

'#################
SUB GetBlemSpots
'#################

	GOSUB SetPixRange
	ExtractFileTypeInfo (file$,index)
	#dataFile=ImageFormat[index,0].firstdataset
	setDefaultPixRange (#ImageSet)

	SetImageIndex	(index)
	ReadFile (#fil$,index,#dataFile)
	GetBlemSpots (6,ImageFormat[#ImageSet,#dataFile].NumberOfPixels-5,ImageFormat[#ImageSet,#dataFile].NumberOfTracks-5,6,0.75)
	Quit()


END SUB

'############
SUB GetCmds
'############

	FOR c=1 TO aTotal-1
			SELECT CASE argv$[c]
						CASE "-open"			:INC c: file$=argv$[c]: open=1
						CASE "-blackspot"	:INC c: file$=argv$[c]: blacks=1
						CASE "-saveassif"	:
						CASE "-saveasraw"	:
						CASE "-help"			:help=1
						CASE "-trk"				:INC c: XstStringToNumber (argv$[c],0,0,type,@Tracks)
						CASE "-pix"				:INC c: XstStringToNumber (argv$[c],0,0,type,@Pixels)
						CASE "-dtype"			:INC c: XstStringToNumber (argv$[c],0,0,type,@dtype): type=1
						CASE "-doffset"		:INC c: XstStringToNumber (argv$[c],0,0,type,@doffset)
						CASE "-daddress"	:INC c: XstStringToNumber (argv$[c],0,0,type,@daddress)
						CASE "-xlabel"		:INC c: xlabel$=argv$[c]
						CASE "-ylabel"		:INC c: ylabel$=argv$[c]
						CASE "-hideconsole"	:
						CASE "-showconsole"	:
						CASE "-width"			:INC c: XstStringToNumber (argv$[c],0,0,type,@width)
						CASE "-height"		:INC c: XstStringToNumber (argv$[c],0,0,type,@height)
						CASE "-posx"			:INC c: XstStringToNumber (argv$[c],0,0,type,@posx)
						CASE "-posy"			:INC c: XstStringToNumber (argv$[c],0,0,type,@posy)
			END SELECT
	NEXT c

END SUB

'################
SUB SetPixRange
'################

	#DatInfoState=0

	IF Pixels>1 THEN
		ImageFormat[#ImageSet,#dataFile].NumberOfPixels=Pixels
		ImageFormat[#ImageSet,#dataFile].lPixel=ImageFormat[#ImageSet,#dataFile].NumberOfPixels-1
		ImageFormat[#ImageSet,#dataFile].fPixel=0
		#DatInfoState=3
	END IF

	IF Tracks>1 THEN
		ImageFormat[#ImageSet,#dataFile].NumberOfTracks=Tracks
		#DatInfoState=3
	END IF

	IF doffset>0 THEN datastart=doffset
	IF type=1 THEN #RawInfoDataType=dtype

END SUB


END FUNCTION
'
'
' ###################################
' #####  setDefaultPixRange ()  #####
' ###################################
'
FUNCTION  setDefaultPixRange (slot)
	SHARED MemDataSet ImageDataSet[]
	SHARED Image ImageFormat[]


	IF ImageFormat[slot,]=0 THEN RETURN 1
	ds=ImageDataSet[slot].DataSet
	ImageFormat[slot,ds].lPixel=ImageFormat[slot,ds].NumberOfPixels-1
	ImageFormat[slot,ds].fPixel=0


END FUNCTION
'
'
' ########################
' #####  unitest ()  #####
' ########################
'
FUNCTION  unitest ()
	SHARED Image ImageFormat[]
	SINGLE ave,ssquare,standdev,avesquare
	SINGLE value

	ave=0
	ssquare=0
	value=0
	startpix=GetPixelAddress (#ImageSet,6,6)
	endpix=GetPixelAddress (#ImageSet,ImageFormat[#ImageSet,#dataFile].NumberOfPixels-5,ImageFormat[#ImageSet,#dataFile].NumberOfTracks-5)

	FOR x=startpix TO endpix STEP 4

			value=SINGLEAT (x)
			ave=ave+value
			ssquare=ssquare+(value*value)

	NEXT x

	ave=ave/(ImageFormat[#ImageSet,#dataFile].NumberOfPixels*ImageFormat[#ImageSet,#dataFile].NumberOfTracks)
	avesquare=ssquare/(ImageFormat[#ImageSet,#dataFile].NumberOfPixels*ImageFormat[#ImageSet,#dataFile].NumberOfTracks)
  standdev=SQRT(ABS(avesquare-(ave*ave)))

	PRINT	standdev/ave,ave, standdev


END FUNCTION
'
' ############################
' #####  WinOpenFile ()  #####
' ############################
'
'	Displays an Open file dialog box, and returns the name of the file selected by the user.
'
FUNCTION  WinOpenFile (window, filename$, filter$)
	OPENFILENAME ofn
	STATIC filterIndex	'used to remember which filter was last used

	IF filename$ THEN
		XstGetPathComponents (filename$, @path$, @drive$, @dir$, @name$, @attributes)
	END IF

	file$ = name$ + NULL$(256 - LEN(name$))		'create enough space to hold selected file name
	IFZ filter$ THEN filterIndex = 0
	flags = $$OFN_EXPLORER OR $$OFN_CREATEPROMPT OR $$OFN_HIDEREADONLY OR $$OFN_LONGNAMES
	XgrWindowToSystemWindow(window, @hWnd, 0, 0, 0, 0)	'get Windows handle for window

	ofn.lStructSize = SIZE(ofn)
	ofn.hwndOwner = hWnd
	ofn.lpstrFile = &file$
	ofn.nMaxFile = SIZE(file$)
	ofn.lpstrFilter = &filter$
	ofn.nFilterIndex = filterIndex
	ofn.lpstrInitialDir = &path$
	ofn.flags = flags

	XstStartTimer(@timer, 1, 100, &MessageTimer())
	ret = GetOpenFileNameA (&ofn)	'call API function, in comdlg32.dll
	XstKillTimer(timer)

	filterIndex = ofn.nFilterIndex		'indicates which filter to use next time
	filename$ = CSTRING$(ofn.lpstrFile)

	RETURN (ret == 0)

END FUNCTION
'
' ############################
' #####  WinSaveFile ()  #####
' ############################
'
'	Displays an Save As dialog box, and returns the name of the file selected by the user.
' operation is similar to WinOpenFile()
'
FUNCTION  WinSaveFile (window,title$ ,filename$, filter$,filterIndex)
	OPENFILENAME sfn

	IF filename$ THEN
		XstGetPathComponents (filename$, @path$, @drive$, @dir$, @name$, @attributes)
	END IF

	file$ = name$ + NULL$(256 - LEN(name$))
	IFZ filter$ THEN filterIndex = 0
	flags = $$OFN_OVERWRITEPROMPT OR $$OFN_HIDEREADONLY	OR $$OFN_EXPLORER
	XgrWindowToSystemWindow(window, @hWnd, 0, 0, 0, 0)

	sfn.lStructSize = SIZE(sfn)
	sfn.hwndOwner = hWnd
	sfn.lpstrFile = &file$
	sfn.nMaxFile = SIZE(file$)
	sfn.lpstrFilter = &filter$
	sfn.nFilterIndex = filterIndex
	sfn.lpstrInitialDir = &path$
	sfn.flags = flags
	sfn.lpstrTitle=	&title$

	XstStartTimer(@timer, 1, 100, &MessageTimer())
	ret = GetSaveFileNameA(&sfn)
	XstKillTimer (timer)

	filterIndex = sfn.nFilterIndex		'indicates which filter to use next time
	filename$ = CSTRING$(sfn.lpstrFile)

	RETURN ret

END FUNCTION
'
'
' #############################
' #####  MessageTimer ()  #####
' #############################
'
FUNCTION  MessageTimer (timer, count, msec, time)
	STATIC active

	INC count								'keep timer going
	IF active THEN RETURN		'prevent multiple entry

	active = $$TRUE
	XgrProcessMessages(-2)
	active = $$FALSE

END FUNCTION
'
'
' ###################################
' #####  DrawImageSelectedP ()  #####
' ###################################
'
FUNCTION  DrawImageRange (first,last,bottom,top)
	SHARED SINGLE hh,ww

	#FirstPix=first
	#LastPix=last
	#LastTrack=top
	#FirstTrack=bottom

	IF ((#LastTrack-3) < #FirstTrack) THEN #LastTrack=#FirstTrack+3
	IF ((#LastPix-3) < #FirstPix) THEN #LastPix=#FirstPix+3

	#col=(ww/(#LastPix-#FirstPix))
	#row=(hh/(#LastTrack-#FirstTrack))
'	#col=#row				'keep aspect ratio.. then center image

	'IF #col<#row THEN #row=#col
	'IF #row<#col THEN #col=#row

	#copyImage=1
	#clearO1=0
	GetNewImage (#image,1,1,0)

END FUNCTION
'
'
' ###########################
' #####  SaveFileAs ()  #####
' ###########################
'
FUNCTION  SaveFileAs (unused)
'	SHARED Image ImageFormat[]
	SHARED MemDataSet ImageDataSet[]


	file$ =#fil$ ' ImageDataSet[#ImageSet].dsTitleS
	title$="Save as..."
	filter$="Andor data file \0*.sif\0Raw data file\0*.dat\0"	  ' Instaspec image file (todo)\0

	ret=WinSaveFile (#OutputWindow,title$, @file$, filter$,@type)
	IFZ ret THEN RETURN -1

	XstDecomposePathname (file$, path$, parent$, filename$, Fn$, @ext$)
	IF ext$="." THEN ext$=""

	SELECT CASE type
			CASE $$ImageTypeSIF		:IF ext$="" THEN file$=file$+".sif"
														 SaveAsSif (file$)
			CASE $$ImageTypeDAT		:IF ext$="" THEN file$=file$+".dat"
														 SaveAsRaw (file$)
			CASE ELSE 						:RETURN type
	END SELECT

	RETURN ret

END FUNCTION
'
'
' #############################
' #####  ExportFileAs ()  #####
' #############################
'
FUNCTION  ExportFileAs (mode)
	SHARED UBYTE image[]
	SHARED Image ImageFormat[]
	SHARED MemDataSet ImageDataSet[]


	file$ = ""
	title$="Export as..."
	filter$="Bitmap (*.bmp)\0*.bmp\0PNG (*.png\0*.png)\0TIFF (*.tif)\0*.tif\0PPM (*.ppm)\0*.ppm\0Jpeg (*.jpg)\0*.jpg\0All files\0*.*\0"

	ret=WinSaveFile (#OutputWindow,title$, @file$, filter$,@type)
	IFZ ret THEN EXIT FUNCTION

	XstDecomposePathname (file$, path$, parent$, filename$, Fn$, @ext$)
	IF ext$="." THEN ext$=""

	SELECT CASE type
			CASE 1			:IF ext$="" THEN file$=file$+".bmp"
									 IF ((mode=1) OR (mode=2)) THEN
												type$="BMP"
												GOSUB SaveAllTracks
												IF ret=6 THEN SaveAllTracksAsBMP (file$,mode)
												EXIT FUNCTION
									 END IF
			CASE 2			:IF ext$="" THEN file$=file$+".png"
									 type$="PNG"
			CASE 3			:IF ext$="" THEN file$=file$+".tif"
									 type$="TIFF"
			CASE 4			:IF ext$="" THEN file$=file$+".ppm"
									 type$="PPM"
			CASE 5			:IF ext$="" THEN file$=file$+".jpg"
									 type$="Jpeg"
			CASE ELSE 	:EXIT FUNCTION ' unsupported
	END SELECT

	SELECT CASE mode
			CASE 0				:GOSUB SaveCurrentTrack
			CASE 1,2			:GOSUB SaveAllTracks
										 IF ret=6 THEN SaveAllToType (file$,type,mode)
	END SELECT

RETURN


'##################
SUB SaveAllTracks
'##################

	title$="Save as "+type$
	text$="This will produce "+STRING(ImageFormat[#ImageSet,#dataFile].NumberOfTracks)+" "+type$+" files. Are you sure?"

	IF PopUpBoxB (text$,title$,$$MB_ICONQUESTION | $$MB_YESNO)=7 THEN EXIT FUNCTION

END SUB


'#####################
SUB SaveCurrentTrack
'#####################

	XfiSaveImage (@file$,  @image[], type, @fileNameExt$)
	GetDIBImage (ImageDataSet[#ImageSet].Track)

	IF XfiSaveImage (@file$,  @image[], type, @fileNameExt$)=1 THEN
				PopUpBox ("Save as "+type$+" successful","Image saved as "+file$,"OK","",4)
	ELSE
				PopUpBox ("Save as "+type$+" unsuccessful","Image not saved","OK","",4)
	END IF

END SUB


END FUNCTION
'
'
' ##################################
' #####  clearImageSetSlot ()  #####
' ##################################
'
FUNCTION  clearImageSetSlot (slot)
	SHARED SINGLE ImageSet[]
	SHARED MemDataSet ImageDataSet[]

	IF ImageSet[slot,]<>0 THEN
			ATTACH ImageSet[slot,] TO #DataSet![]: DIM #DataSet![]
			ImageDataSet[slot].ImageSetAd=0
			ImageDataSet[slot].active=1
			ImageDataSet[slot].clr2d=#ink
			RETURN 0
	ELSE
			RETURN 1
	END IF


END FUNCTION
'
'
' #################################
' #####  AddDataSetToSlot ()  #####
' #################################
'
FUNCTION  AddDataSetToSlot (slot,dataset)
	SHARED MemDataSet ImageDataSet[]
	SHARED SINGLE ImageSet[]


	IF ImageSet[slot,]=0 THEN
				ATTACH #DataSet![] TO ImageSet[slot,]
				ImageDataSet[slot].ImageSetAd=ImageSet[slot,]
				IF dataset<>-1 THEN ImageDataSet[slot].DataSet=dataset
				ImageDataSet[slot].active=1
				ImageDataSet[slot].clr2d=#ink
				UpdateDataSlotMenu ()
				RETURN 0
	ELSE
				UpdateDataSlotMenu ()
				RETURN 1
	END IF

END FUNCTION
'
'
' ###############################
' #####  CreateDataSlot ()  #####
' ###############################
'
FUNCTION  CreateDataSlot (unused,unused2)
	SHARED SINGLE ImageSet[]
	SHARED Image ImageFormat[]
	SHARED MemDataSet ImageDataSet[]

	slot=0

	DO			' find an empty slot
			IF slot>UBOUND(ImageSet[]) THEN
						REDIM ImageFormat[slot+3,]
						REDIM ImageSet[slot+3,]
						REDIM ImageDataSet[slot+3]
			END IF


			pos= ImageDataSet[slot].active          'ImageSet[slot,]
			INC slot

	LOOP UNTIL (pos=0)

	DEC slot

	CreateDataSlotAt (slot)

	RETURN slot

END FUNCTION
'
'
' #################################
' #####  CreateDataSlotAt ()  #####
' #################################
'
FUNCTION  CreateDataSlotAt (slot)
	SHARED MemDataSet ImageDataSet[]
	SHARED Image ImageFormat[]
	SHARED SINGLE ImageSet[]


	IF slot>UBOUND(ImageSet[]) THEN
				REDIM ImageFormat[slot+3,]
				REDIM ImageSet[slot+3,]
				REDIM ImageDataSet[slot+3]
	END IF

	resetMemDataSet (slot)

	x=360
	y=310
	w=620
	h=340
	flag=0			' 1= open window after creation 0=keep hidden
	wintype=$$WindowTypeDefault	' standard xbasic window types, 0 = default

	uDisplayCreateWindow (slot,x,y,w,h,flag,wintype)
	ImageDataSet[slot].active=1


END FUNCTION
'
'
' ##############################
' #####  addimage_test ()  #####
' ##############################
'
FUNCTION  addimage_test ()
	STATIC temp
	SINGLE v

	image1=#ImageSet
	image3=CopyDataSet (image1)
	GetDataSlotSize (image1,@x1,@y1)

	IF temp=0 THEN temp=1 ELSE temp=0

	FOR y=1 TO y1

			oldv=GetPixelValue (image1,1,y,v)
			FOR x=1 TO x1

				GetPixelValue (image1,x,y,@value)
				IF temp=0 THEN
							SetPixelValue (image3,x,y,(oldv-value)*2.0)
				ELSE
							SetPixelValue (image3,x,y,(value-oldv)*2.0)
				END IF
				oldv=value

			NEXT x

	NEXT y

	DeleteDataSet (image1)
	SetCurrentDataSet (image3)


END FUNCTION
'
'
' #########################
' #####  GetFileA ()  #####
' #########################
'
FUNCTION  GetFileA (file$,iflag,dataset)
	SHARED Image ImageFormat[]
	SHARED MemDataSet ImageDataSet[]



	slot=CreateDataSlot (0,0)

	IF (ExtractFileTypeInfo (file$,slot) <> 0) THEN
				DeleteDataSet (slot)
				EXIT FUNCTION
	END IF

	IF dataset=-1 THEN dataset=ImageFormat[slot,0].firstdataset

	ReadFile (file$,slot,dataset)
	UpdateDataSlotMenu ()
	AutoScale (slot,1)

	RETURN slot

END FUNCTION
'
'
' ##############################
' #####  DeleteDataSet ()  #####
' ##############################
'
FUNCTION  DeleteDataSet (slot) ' and free slot
	SHARED SINGLE ImageSet[]
	SHARED Image ImageFormat[]
	SHARED MemDataSet ImageDataSet[]
	Image null[]

	IF ImageFormat[slot,] <>0 THEN
				ATTACH ImageFormat[slot,] TO null[]: DIM null[]
	END IF

	IF ImageSet[slot,] <>0 THEN
				ATTACH ImageSet[slot,] TO nullb[]: DIM nullb[]
	END IF

	DestroyPWindow (ImageDataSet[slot].Grid)

	resetMemDataSet (slot)
	UpdateDataSlotMenu ()

END FUNCTION
'
'
' ########################################
' #####  CreateNewDataSetAndSlot ()  #####
' ########################################
'
FUNCTION  CreateNewDSetAndSlot (pixels,tracks)
	SHARED MemDataSet ImageDataSet[]
	SHARED SINGLE ImageSet[]
	SHARED Image ImageFormat[]
	SHARED Image dataset[]
	Image null[]

	IF pixels<2 THEN pixels=2
	IF tracks<1 THEN tracks=1

	slot=CreateDataSlot (pixels,tracks)

	DIM #DataSet![pixels*tracks]
	DIM dataset[1]
	AddDataSetToSlot (slot,0)

	ImageDataSet[slot].active=1
	ImageDataSet[slot].DataSet=0
	ImageDataSet[slot].Size=pixels*tracks*4
	ImageDataSet[slot].stDisplay=0
	ImageDataSet[slot].stDisplayOL=0
	ImageDataSet[slot].clr2d=#ink
	ImageDataSet[slot].dsTitleS="# "+STRING$(slot)
	ImageDataSet[slot].fPixel=1
	ImageDataSet[slot].lPixel=pixels

	dataset[0].totaldatasets=1
	dataset[0].firstdataset=0
	dataset[0].totalimages=1
	dataset[0].bLeft=1
	dataset[0].left=1
	dataset[0].bRight=pixels
	dataset[0].right=pixels
	dataset[0].top=tracks
	dataset[0].bottom=1
	dataset[0].NumberOfTracks=tracks
	dataset[0].NumberOfPixels=pixels
	dataset[0].totalLenght=pixels*tracks
	dataset[0].imageLenght=dataset[0].totalLenght
	dataset[0].numberOfSubImages=1
	dataset[0].numberOfImages=1
	dataset[0].xText="Pixel number"
	dataset[0].yText="Counts"
	dataset[0].datatype="Sig"
	dataset[0].dataStart=0   ' problem
	dataset[0].xCal[0]=0
	dataset[0].xCal[1]=1
	dataset[0].active=1
	dataset[0].hBin=1
	dataset[0].vBin=1
	dataset[0].ptype=0
	dataset[0].filen=""



	IF ImageFormat[slot,]<>0 THEN
				ATTACH ImageFormat[slot,] TO null[]
	END IF
	ATTACH dataset[] TO ImageFormat[slot,]

	UpdateDataSlotMenu ()

	RETURN slot


END FUNCTION
'
'
' ################################
' #####  GetDataSlotSize ()  #####
' ################################
'
FUNCTION  GetDataSlotSize (slot,x,y)
	SHARED Image ImageFormat[]
	SHARED SINGLE ImageSet[]
	SHARED MemDataSet ImageDataSet[]


	IF IsImageSlotValid (slot)=0 THEN RETURN -1

	dataset=ImageDataSet[slot].DataSet
	x=ImageFormat[slot,dataset].NumberOfPixels
	y=ImageFormat[slot,dataset].NumberOfTracks
'	size=ImageDataSet[slot].Size

	size=SIZE(ImageSet[slot,])

	RETURN size

END FUNCTION
'
'
' ############################
' #####  CopyDataSet ()  #####
' ############################
'
FUNCTION  CopyDataSet (slot)
	SHARED SINGLE ImageSet[]
	SHARED Image ImageFormat[]
	SHARED Image dataset[],newds[]
	SHARED MemDataSet ImageDataSet[]

	IF IsImageSlotValid (slot)=0 THEN RETURN -1

	newslot=CreateDataSlot (0,0)

	IF ImageFormat[slot,]<>0 THEN
				ATTACH ImageFormat[slot,] TO dataset[]
				XstCopyArray (@dataset[],@newds[])

				ATTACH dataset[] TO ImageFormat[slot,]
				ATTACH newds[] TO ImageFormat[newslot,]
	END IF

	IF ImageSet[slot,]<>0 THEN
				ATTACH ImageSet[slot,] TO #DataFile![]
				XstCopyArray (@#DataFile![],@newDF[])

				ATTACH #DataFile![] TO ImageSet[slot,]
				ImageDataSet[slot].ImageSetAd=ImageSet[slot,]

				ImageDataSet[newslot].Size=SIZE(newDF[])
				ATTACH newDF[] TO ImageSet[newslot,]
				ImageDataSet[newslot].ImageSetAd=ImageSet[newslot,]
	END IF

	ImageDataSet[newslot].active=1
	ImageDataSet[newslot].DataSet=ImageDataSet[slot].DataSet
	ImageDataSet[newslot].Size=ImageDataSet[slot].Size
	ImageDataSet[newslot].currentImageBt=ImageDataSet[slot].currentImageBt  'unsure
	ImageDataSet[newslot].stDisplay=0
	ImageDataSet[newslot].stDisplayOL=0
	ImageDataSet[newslot].clr2d=ImageDataSet[slot].clr2d
'	ImageDataSet[newslot].dsTitleL=ImageDataSet[slot].dsTitleL
'	ImageDataSet[newslot].dsTitleS=ImageDataSet[slot].dsTitleS
	ImageDataSet[newslot].fPixel=ImageDataSet[slot].fPixel
	ImageDataSet[newslot].lPixel=ImageDataSet[slot].lPixel

	GetDataSetTitle (slot,@short$,@long$)
	SetDataSetTitle (newslot,short$,long$)
	UpdateDataSlotMenu ()

	RETURN newslot

END FUNCTION
'
'
' ##############################
' #####  SetImageIndex ()  #####
' ##############################
'
FUNCTION  SetImageIndex (index)


'	IF IsImageSlotValid (index)=0 THEN RETURN -1  ' fix

	#ImageSet=index
	validset=UpdateDataSlotMenu ()

	RETURN validset


END FUNCTION
'
'
' #################################
' #####  resizeimage_test ()  #####
' #################################
'
FUNCTION  resizeimage_test ()
	SHARED Image ImageFormat[]
'	XLONG value


	image1=#ImageSet
	GetDataSlotSize (image1,@x1,@y1)

	y2=1
	FOR y=1 TO y1 STEP 2

			x2=1
			FOR x=1 TO x1 STEP 2

					GetPixelValue (image1,x,y,@value)
					SetPixelValue (image1,x2,y2,value)
					INC x2

			NEXT x
			INC y2

	NEXT y

	GetDataSlotSize (image1,@x,@y)
	ResizeDataSet (image1,x/2,y/2,0,1)
	SetCurrentDataSet (image1)

END FUNCTION
'
'
' ##############################
' #####  ResizeDataSet ()  #####
' ##############################
'
FUNCTION  ResizeDataSet (slot,x,y,size,align)
	SHARED SINGLE ImageSet[]
	SHARED Image ImageFormat[]
	SHARED MemDataSet ImageDataSet[]
	SINGLE value

	IF IsImageSlotValid (slot)=0 THEN RETURN 0

	dataset=ImageDataSet[slot].DataSet
	IF ((x<2) OR (y<1)) THEN RETURN 0
	IF ((ImageSet[slot,]=0) OR (ImageFormat[]=0)) THEN RETURN 0

	IF align=1 THEN GOSUB AlignData
	IF size>7 THEN newsize=size ELSE newsize=(x-1)*(y-1)*4

	ATTACH ImageSet[slot,] TO #DataFile![]
	REDIM #DataFile![newsize]

	ATTACH #DataFile![] TO ImageSet[slot,]

	ImageDataSet[slot].ImageSetAd=ImageSet[slot,]
	ImageDataSet[slot].Size=x*y*4

'	IF y> ImageDataSet[slot].Track THEN ImageDataSet[slot].Track=y
'	IF y> ImageDataSet[slot].uTrack THEN ImageDataSet[slot].uTrack=y
	ImageDataSet[slot].Track=1
	ImageDataSet[slot].uTrack=1
	ImageDataSet[slot].curPos=x*0.5
	ImageDataSet[slot].fPixel=1
	ImageDataSet[slot].lPixel=x

	ImageFormat[slot,dataset].bRight=x
	ImageFormat[slot,dataset].right=x
	ImageFormat[slot,dataset].top=y
'	ImageFormat[slot,dataset].bottom=1
	ImageFormat[slot,dataset].NumberOfTracks=y
	ImageFormat[slot,dataset].NumberOfPixels=x
	ImageFormat[slot,dataset].fPixel=0
	ImageFormat[slot,dataset].lPixel=x-1
	ImageFormat[slot,dataset].totalLenght=x*y
	ImageFormat[slot,dataset].imageLenght=ImageFormat[slot,dataset].totalLenght

	RETURN newsize


'##############
SUB AlignData
'##############

	ad=GetPixelAddress(slot,1,1)
	pix=0

	FOR t=1 TO y
			FOR p=1 TO x
						GetPixelValue (slot,p,t,@value)
						SINGLEAT(ad+pix)=value
						pix=pix+4
			NEXT p
	NEXT t

END SUB





END FUNCTION
'
'
' ################################
' #####  SetDataSetTitle ()  #####
' ################################
'
FUNCTION  SetDataSetTitle (slot,short$,long$)
	SHARED Image ImageFormat[]
	SHARED MemDataSet ImageDataSet[]

	IF IsImageSlotValid (slot)=0 THEN RETURN 0

	titles$=LEFT$(short$,14)
	IF short$<>"" THEN ImageDataSet[slot].dsTitleS=titles$
	IF long$<>"" THEN ImageDataSet[slot].dsTitleL=long$
	IF ImageFormat[slot,0].filen="" THEN ImageFormat[index,0].filen=long$

	win=ImageDataSet[slot].Grid
	title$="#"+STRING$(slot+1)+" - "+titles$
	XuiSendMessage (win, #SetWindowTitle, 0, 0, 0, 0, 0, @title$)


	RETURN 1


END FUNCTION
'
'
' ################################
' #####  GetDataSetTitle ()  #####
' ################################
'
FUNCTION  GetDataSetTitle (slot,short$,long$)
	SHARED MemDataSet ImageDataSet[]

	IF IsImageSlotValid (slot)=0 THEN RETURN 0
	short$=ImageDataSet[slot].dsTitleS
	long$=ImageDataSet[slot].dsTitleL

	RETURN 1


END FUNCTION
'
'
' ##################################
' #####  SetCurrentDataSet ()  #####
' ##################################
'
FUNCTION  SetCurrentDataSet (index)
	SHARED MemDataSet ImageDataSet[]
	SHARED TrackData TrackInfo[]
	SHARED Image ImageFormat[]


	IF IsImageSlotValid (index)=0 THEN RETURN -1

	IF index<>#ImageSet THEN TrackInfo[0].valid=0
	SetImageIndex (index)

	ImageDataSet[index].stDisplay=1
'	ImageDataSet[index].stDisplayOL=0
	#fil$=ImageDataSet[index].dsTitleL
	#dataFile=ImageDataSet[index].DataSet

	SetProgramTitle (#fil$)
	DataTrackImageCheck ()
	setSigBtLabels ()
	disableUnusedBts ()
	setTrackVoffset (index)

	Update (1)

END FUNCTION
'
' #####################################
' #####  GetFirstValidDataSet ()  #####
' #####################################
'
FUNCTION  GetFirstValidDataSet (exclude)
	SHARED Image ImageFormat[]


	FOR slot=0 TO UBOUND (ImageFormat[])
				IF ((IsImageSlotValid (slot)=1) AND (slot<>exclude)) THEN RETURN slot
	NEXT slot

	RETURN -1

END FUNCTION
'
'
' #################################
' #####  copydataset_test ()  #####
' #################################
'
FUNCTION  copydataset_test ()

	IF IsImageSlotValid (#ImageSet)=0 THEN RETURN -1
	newslot=CopyDataSet (#ImageSet)
	RETURN newslot

END FUNCTION
'
'
' ###################################
' #####  UpdateDataSlotMenu ()  #####
' ###################################
'
FUNCTION  UpdateDataSlotMenu ()
	SHARED cMenuPos cMenu[]
	SHARED Image ImageFormat[]
	SHARED SINGLE ImageSet[]
	SHARED MemDataSet ImageDataSet[]
	SHARED hh,DropSelect

	title=0
	validset=0
	ub=UBOUND(ImageSet[])-1

	FOR i=0 TO ub

				IF IsImageSlotValid (i)=1 THEN

							IF ((title+1)*#size) < hh THEN

										validset=1
										ImageDataSet[i].cMenuNo=title+1
										title$=ImageDataSet[i].dsTitleS

										IF title$="" THEN title$=STRING(i+1)
										IF title>UBOUND(#cSubMenu16$[]) THEN REDIM #cSubMenu16$[title]

										#cSubMenu16Height=(1+UBOUND(#cSubMenu16$[]))*#size
										label$="#"+STRING(i+1)+" "+title$
										#cSubMenu16$[title]=label$
										cMenuAddItem (#DataSetSel,title+1,&label$,#DataSet,-1,$$CM_ID_SelSlot+i)
										cMenuAddItem (#DataSetSel,-4,$$CM_TY_BottomBrB,-1,-1,-1)
										cMenuAddItem (#DataSetDel,title+1,&label$,#DataSet,-1,$$CM_ID_DelSlot+i)
										cMenuAddItem (#DataSetDel,-4,$$CM_TY_BottomBrB,-1,-1,-1)

										IF i<7 THEN #cSubMenu15$[i]=":#"+STRING$(i+1)+":"

										INC title
							ELSE
										REDIM #cSubMenu16$[title-1]
										EXIT FOR
							END IF
				ELSE
							txt$=""
							ImageDataSet[i].cMenuNo=0
							IF i<7 THEN #cSubMenu15$[i]=" #"+STRING$(i+1)
				END IF


	NEXT i

	XgrGetGridPositionAndSize (#cBuff, -1, -1,-1, @h)
	IF ((title*#size) >=h) THEN
				GOSUB ResizeCMenuB
	ELSE
				IF ((title*#size) >=300) THEN GOSUB ResizeCMenuB  '  300=default cmenu size+default hh
	END IF

	IF validset=1 THEN
				IF UBOUND(#cSubMenu16$[])<>(title-1) THEN REDIM #cSubMenu16$[title-1]
				#cSubMenu16Height=(title)*#size
				IF #ImageSet<7 THEN
							#cSubMenu15$[#ImageSet]="[#"+STRING$(#ImageSet+1)+"]"
				END IF

				XuiSendMessage (#AddTraceW,#SetTextArray,0,0,0,0,4,@#cSubMenu16$[])
				IF DropSelect> UBOUND(#cSubMenu16$[]) THEN DropSelect=0
				txt$=#cSubMenu16$[DropSelect]
				XuiSendMessage (#AddTraceW,#SetTextString,0,0,0,0,4,@txt$)
	END IF

	RETURN validset


'#################
SUB ResizeCMenuB
'#################

	nh=(title+2)*#size
	IF h<>nh THEN XgrSetGridPositionAndSize (#cBuff, -1, -1,-1, nh)

END SUB

END FUNCTION
'
'
' ############################
' #####  RotateImage ()  #####
' ############################
'
FUNCTION  RotateImage (slot,flag)
	SINGLE value

	IF IsImageSlotValid (slot)=0 THEN RETURN -1

	GetDataSlotSize (slot,@x,@y)

	SELECT CASE flag
			CASE 1		:
						newslot=CreateNewDSetAndSlot (y,x)

						FOR t=1 TO y
								FOR p=1 TO x
										GetPixelValue (slot,p,t,@value)
										SetPixelValue (newslot,t,p,value)
								NEXT p
						NEXT t

		CASE 2			:
						newslot=CreateNewDSetAndSlot (x,y)

						t2=y
						FOR t=1 TO y
								p2=1
								FOR p=1 TO x
										GetPixelValue (slot,p,t,@value)
										SetPixelValue (newslot,p2,t2,value)
										INC p2
								NEXT p
								DEC t2
						NEXT t

			CASE 3			:
						newslot=CreateNewDSetAndSlot (x,y)

						t2=y
						FOR t=1 TO y
								p2=x
								FOR p=1 TO x
										GetPixelValue (slot,p,t,@value)
										SetPixelValue (newslot,p2,t2,value)
										DEC p2
								NEXT p
								DEC t2
						NEXT t

	END SELECT

	setDefaultPixRange (newslot)

	GetDataSetTitle  (slot,@short$,@long$)
	SetDataSetTitle  (newslot,short$,long$)
	DeleteDataSet (slot)
	SetCurrentDataSet (newslot)
	UpdateDataSlotMenu ()

	RETURN newslot

END FUNCTION
'
'
' ###############################
' #####  ClearPixelArea ()  #####
' ###############################
'
FUNCTION ClearPixelArea (slot,SINGLE value,x1,x2,y1,y2)			' ie wipedataset

	IF IsImageSlotValid (slot)=0 THEN RETURN 0

	FOR t=y1 TO y2
			FOR p=x1 TO x2
					SetPixelValue (slot,p,t,value)
			NEXT p
	NEXT t


 RETURN 1


END FUNCTION
'
'
' #################################
' #####  IsImageSlotValid ()  #####
' #################################
'
FUNCTION  IsImageSlotValid (slot)
	SHARED Image ImageFormat[]
	SHARED MemDataSet ImageDataSet[]

	IF slot> UBOUND (ImageDataSet[]) THEN RETURN 0
	IF ((ImageDataSet[slot].active=0) OR (ImageFormat[slot,]=0)) THEN RETURN 0 ELSE RETURN 1

END FUNCTION
'
'
' ###############################
' #####  addimages_test ()  #####
' ###############################
'
FUNCTION  addimages_test ()				' can give a nice water mark effect
	SHARED Image ImageFormat[]

	newslot=-1
	FOR slot=0 TO UBOUND (ImageFormat[])
				IF ((IsImageSlotValid (slot)=1) AND (slot<>#ImageSet)) THEN newslot=slot: EXIT FOR
	NEXT slot
	IF newslot=-1 THEN RETURN 0

	slot1=#ImageSet
	slot2=newslot

	GetDataSlotSize (slot1,@x1,@y1)
	GetDataSlotSize (slot2,@x2,@y2)

	x=MIN (x1,x2)
	y=MIN (y1,y2)

	FOR t=1 TO y
			FOR p=1 TO x
					GetPixelValue (slot1,p,t,@value)
					GetPixelValue (slot2,p,t,@valueb)
					SetPixelValue (slot1,p,t,value+valueb)
			NEXT p
	NEXT t

	SetCurrentDataSet (slot1)

END FUNCTION
'
'
' #############################
' #####  CloseDataSet ()  #####
' #############################
'
FUNCTION  CloseDataSet (slot)


	vslot=GetFirstValidDataSet (#ImageSet)

	IF vslot=-1 THEN
			ret=PopUpBoxB ("At least one dataset is required to continue with application.\nDelete this dataset and load another?","Warning", $$MB_OKCANCEL | $$MB_TOPMOST) '$$MB_ICONSTOP

			SELECT CASE ret
				'	CASE 2				: EXIT FUNCTION
					CASE 1				:	IF SelectFileMenu (1,CreateDataSlot (0,0))<>-1 THEN DeleteDataSet (slot)
				'	CASE 7				: Quit()
					CASE ELSE			: EXIT FUNCTION
			END SELECT
	ELSE
			DeleteDataSet (slot)
			SetCurrentDataSet (vslot)
	END IF


END FUNCTION
'
'
' ##############################
' #####  MoveDataSetTo ()  #####
' ##############################
'
FUNCTION  MoveDataSetTo (from,to)
	SHARED SINGLE ImageSet[]
	SHARED Image ImageFormat[]
	SHARED MemDataSet ImageDataSet[]

	IF from = to THEN RETURN 2
	IF IsImageSlotValid (from)=0 THEN RETURN 2
	IF IsImageSlotValid (to)=1 THEN DeleteDataSet (to)

	CreateDataSlotAt (to)

	ATTACH ImageFormat[from,] TO ImageFormat[to,]
	ATTACH ImageSet[from,] TO ImageSet[to,]

	ImageDataSet[to].ImageSetAd=ImageSet[to,]
	ImageDataSet[to].active=1
	ImageDataSet[to].Slot=to
	ImageDataSet[to].DataSet=ImageDataSet[from].DataSet
	ImageDataSet[to].Size=ImageDataSet[from].Size
	ImageDataSet[to].currentImageBt=ImageDataSet[from].currentImageBt  'unsure
	ImageDataSet[to].dsTitleL=ImageDataSet[from].dsTitleL
	ImageDataSet[to].dsTitleS=ImageDataSet[from].dsTitleS
	ImageDataSet[to].stDisplay=ImageDataSet[from].stDisplay
	ImageDataSet[to].stDisplayOL=ImageDataSet[from].stDisplayOL
	ImageDataSet[to].Track =ImageDataSet[from].Track
	ImageDataSet[to].uTrack =ImageDataSet[from].uTrack
	ImageDataSet[to].MaxValue =ImageDataSet[from].MaxValue
	ImageDataSet[to].MinValue =ImageDataSet[from].MinValue
	ImageDataSet[to].uMaxValue =ImageDataSet[from].uMaxValue
	ImageDataSet[to].uMinValue =ImageDataSet[from].uMinValue
	ImageDataSet[to].curPos =ImageDataSet[from].curPos
	ImageDataSet[to].clr2d =ImageDataSet[from].clr2d
	ImageDataSet[to].fPixel =ImageDataSet[from].fPixel
	ImageDataSet[to].lPixel =ImageDataSet[from].lPixel


'	ImageDataSet[to].Grid = ImageDataSet[from].Grid
'	ImageDataSet[to].Window = ImageDataSet[from].Window
'	ImageDataSet[to].imagebuffer = ImageDataSet[from].imagebuffer

	title$="#"+STRING$(to+1)+" - "+ImageDataSet[to].dsTitleS
	XuiSendMessage (ImageDataSet[to].Grid, #SetWindowTitle, 0, 0, 0, 0, 0, @title$)


	IF ImageFormat[to,0].filen="" THEN ImageFormat[to,0].filen=ImageDataSet[from].dsTitleL

	resetMemDataSet (from)

	RETURN 0


END FUNCTION
'
'
' #################################
' #####  movedataset_test ()  #####
' #################################
'
FUNCTION  movedataset_test ()

	newslot=CreateDataSlot (0,0)
	IF MoveDataSetTo (#ImageSet,newslot)<>0 THEN DeleteDataSet (newslot)

	SetCurrentDataSet (newslot)


END FUNCTION
'
'
' ##############################
' #####  DisplayTracks ()  #####
' ##############################
'
FUNCTION  DisplayTracks (list)
	SHARED MemDataSet ImageDataSet[]
	STATIC slot3,slot2,slot4
	STATIC state


'	IFZ slot3 THEN slot3=GetFileA ("e:\\xb\\ii\\pic.sif",0,0): state=0
'	IFZ slot2 THEN slot2=GetFileA ("e:\\xb\\ii\\cambium1.sif",0,0)
	IFZ slot4 THEN slot4=GetFileA ("e:\\xb\\ii\\Salmonella.sif",0,0)


'	AddTraceToWindow (#IndexSet,$$BrightBlue)

	IF state=0 THEN
			'	AddTraceToWindow (slot2,$$BrightRed)
			'	AddTraceToWindow (slot3,$$Green)
				AddTraceToWindow (slot4,$$Orange)
				state=1
	ELSE
			'	RemoveTraceFromWindow (slot2)
			'	RemoveTraceFromWindow (slot3)
				RemoveTraceFromWindow (slot4)
				state=0
	END IF

END FUNCTION
'
'
' ##########################
' #####  DrawTrack ()  #####
' ##########################
'
FUNCTION  DrawTrack (grid,slot,ink,track,first,last,SINGLE top, SINGLE bottom,rescale)
	SHARED Image ImageFormat[]
	SHARED MemDataSet ImageDataSet[]
	SHARED SINGLE ww,hh,x,y,hhm,wwx

		IF track>ImageFormat[slot,ImageDataSet[slot].DataSet].NumberOfTracks THEN RETURN 0

		startpix=GetPixelAddress (slot,first,track)
		endpix=GetPixelAddress (slot,last,track)

		IF rescale=1 THEN
					vinfo=(hh/( top - bottom ))* bottom
					hhv=hh+vinfo
		ELSE
					#vinfo=#Voffset+#totalvoffset+#o
					hhv=hh+#vinfo
		END IF

		hhm=hh/(top-bottom)
		wwx=ww/(last-first)
		xpos=0
		x=0
		y=(hhv-(hhm*SINGLEAT(startpix)))

		XgrMoveTo (grid,x,y)

		IFZ #LineType THEN											' solid line

				FOR pos = startpix TO endpix STEP 4

						XgrDrawLineTo (grid,ink,wwx*xpos,hhv-(hhm*SINGLEAT(pos)))
						INC xpos

				NEXT pos
		ELSE																		' single point
				FOR pos = startpix TO endpix STEP 4

						x=wwx*xpos
						y=hhv-(hhm*SINGLEAT(pos))
						XgrDrawPoint (grid,ink,x,y)
						INC xpos

				NEXT pos

		END IF


	'	IF rescale=0 THEN
	'			ImageFormat[#ImageSet,#dataFile].fPixel=first-1
	'			ImageFormat[#ImageSet,#dataFile].lPixel=last-1
	'			ImageDataSet[#ImageSet].MaxValue=top
	'			ImageDataSet[#ImageSet].MinValue=bottom
	'			#scrpix=ImageFormat[#ImageSet,#dataFile].lPixel-ImageFormat[#ImageSet,#dataFile].fPixel
	'	END IF






END FUNCTION
'
'
' ###########################
' #####  drawCursor ()  #####
' ###########################
'
FUNCTION  drawCursor (grid,colour,x,y,style)
	SHARED ww,hh

		SELECT CASE style

				CASE 0:
					size = 15
					XgrDrawLine (grid, colour, x ,y+2, x , y+size)
					XgrDrawLine (grid, colour, x ,y-2, x , y-size)
					XgrDrawLine (grid, colour, x+2 ,y, x+size , y)
					XgrDrawLine (grid, colour, x-2 ,y, x-size , y)
				CASE 1:
					size = 2
					XgrDrawLine (grid, colour, x ,hh, x , y+size)
					XgrDrawLine (grid, colour, ww ,y, x+size , y)
					XgrDrawLine (grid, colour, x ,0, x , y-size)
					XgrDrawLine (grid, colour, 0 ,y, x-size , y)
				CASE 2:
					size = 2
					XgrDrawLine (grid, colour, ww ,hh, x+size , y+size)
					XgrDrawLine (grid, colour, ww ,0, x+size , y-size)
					XgrDrawLine (grid, colour, 0 ,hh, x-size , y+size)
					XgrDrawLine (grid, colour, 0 ,0, x-size, y-size)
				CASE 3:
					XgrDrawLine (grid, colour, x,y+3,x ,y+25)
		'		CASE 4:
		'			XgrDrawLine (grid, colour, x , 0, x, hh)
		'			XgrDrawLine (grid, colour, 0, y, ww, y)

		END SELECT


END FUNCTION
'
'
' #######################
' #####  Update ()  #####
' #######################
'
FUNCTION  Update (flag)
	SHARED MemDataSet ImageDataSet[]


	IF #currentDisplay=1 THEN
				DisplayTrack (ImageDataSet[#ImageSet].Track,0)
	ELSE
				#copyImage=1
				#clearO1=0
				GetNewImage (#image,1,0,1)
	END IF

	IF flag=1 THEN XuiSendMessage (#Output,#Redraw, 0, 0, 0, 0, 0, 0)

END FUNCTION
'
'
' ###############################
' #####  GetWindowState ()  #####
' ###############################
'
FUNCTION  GetWindowState (window)

	XgrGetWindowState (window, @state)

	RETURN state

END FUNCTION
'
'
' ###################################
' #####  ScaleAllTracksCalc ()  #####
' ###################################
'
FUNCTION  ScaleAllTracksCalc (slot)
	SHARED MemDataSet ImageDataSet[]
	SHARED TrackData TrackInfoCopy[]
	SHARED TrackData TrackInfo[]
	SHARED Image ImageFormat[]


	IF ImageDataSet[slot].active=0 THEN RETURN 0

	l=ImageFormat[slot,ds].lPixel
	f=ImageFormat[slot,ds].fPixel

	ds=ImageDataSet[slot].DataSet
	ImageFormat[slot,ds].lPixel=ImageFormat[slot,ds].NumberOfPixels-1
	ImageFormat[slot,ds].fPixel=0

	AutoScaleAll (slot)
	ScaleToAllTracks ()

	ImageFormat[slot,ds].lPixel=l
	ImageFormat[slot,ds].fPixel=f
	TrackInfo[0].valid=1

	DIM TrackInfoCopy[ImageFormat[slot,ds].NumberOfTracks-1]
	XstCopyArray (@TrackInfo[],@TrackInfoCopy[])



END FUNCTION
'
'
' ################################
' #####  resetMemDataSet ()  #####
' ################################
'
FUNCTION  resetMemDataSet (slot)
	SHARED MemDataSet ImageDataSet[]


	ImageDataSet[slot].active=0
	ImageDataSet[slot].ImageSetAd=0
	ImageDataSet[slot].dsTitleL=""
	ImageDataSet[slot].dsTitleS=""
	ImageDataSet[slot].currentImageBt=0
	ImageDataSet[slot].Size=0
	ImageDataSet[slot].DataSet=0
	ImageDataSet[slot].Slot=0
	ImageDataSet[slot].cMenuNo=0
	ImageDataSet[slot].stDisplay=0
	ImageDataSet[slot].stDisplayOL=0
	ImageDataSet[slot].clr2d=#ink
	ImageDataSet[slot].Track=1
	ImageDataSet[slot].uTrack=1
	ImageDataSet[slot].MaxValue=0xFFFF
	ImageDataSet[slot].MinValue=0
	ImageDataSet[slot].uMaxValue=0xFFFF
	ImageDataSet[slot].uMinValue=0
	ImageDataSet[slot].Voffset=0
	ImageDataSet[slot].curPos=1
	ImageDataSet[slot].Grid=0
	ImageDataSet[slot].imagebuffer=0
	ImageDataSet[slot].Window=0
	ImageDataSet[slot].trackCursor=1
	ImageDataSet[slot].enableVScroll=0
	ImageDataSet[slot].enableYUnit=1
	ImageDataSet[slot].enableXUnit=0
	ImageDataSet[slot].enablePixDatVal=1





END FUNCTION
'
'
' #################################
' #####  AddTraceToWindow ()  #####
' #################################
'
FUNCTION  AddTraceToWindow (slot,ink)
	SHARED MemDataSet ImageDataSet[]


	IF ImageDataSet[slot].active=0 THEN RETURN 0

	ImageDataSet[slot].stDisplayOL=1
	IF ink<>-1 THEN ImageDataSet[slot].clr2d=ink

	Update(0)


END FUNCTION
'
'
' ######################################
' #####  RemoveTraceFromWindow ()  #####
' ######################################
'
FUNCTION  RemoveTraceFromWindow (slot)
	SHARED MemDataSet ImageDataSet[]


	IF ImageDataSet[slot].active=0 THEN RETURN 0

	ImageDataSet[slot].stDisplayOL=0
'	ImageDataSet[slot].stDisplay=0
	ImageDataSet[slot].clr2d=#ink

	Update(0)


END FUNCTION
'
' ###############################
' #####  DestroyPWindow ()  #####
' ###############################
'
FUNCTION  DestroyPWindow (grid)


	XgrGetGridWindow (grid,@window)
	XgrDestroyWindow  (window)


END FUNCTION
'
'
' ############################
' #####  openUD_test ()  #####
' ############################
'
FUNCTION  openUD_test ()
	SHARED MemDataSet ImageDataSet[]


' open all uD. data windows

	track=-1

	FOR win=0 TO UBOUND(ImageDataSet[])
				IF IsImageSlotValid (win)=1 THEN uDisplayShowWindow (win,1)
	NEXT win



'	uDisplaySetPosition (0,50,50)
'	uDisplaySetSize (0,300,300)



END FUNCTION
'
'
' ################################
' #####  uDisplayGetSlot ()  #####
' ################################
'
FUNCTION  uDisplayGetSlot (grid,type)
	SHARED MemDataSet ImageDataSet[]


	slot=-1
	FOR wct=0 TO UBOUND(ImageDataSet[])
			IF ImageDataSet[wct].active=1 THEN
					IF type=1 THEN
								IF ImageDataSet[wct].Grid=grid THEN slot=wct: EXIT FOR
					ELSE
								IF ImageDataSet[wct].Window=grid THEN slot=wct: EXIT FOR
					END IF
			END IF
	NEXT wct


	RETURN slot

END FUNCTION
'
'
' #####################################
' #####  uDisplayCreateWindow ()  #####
' #####################################
'
FUNCTION  uDisplayCreateWindow (slot,x,y,w,h,flag,wintype)
	SHARED MemDataSet ImageDataSet[]
	SHARED Image ImageFormat[]


	IF x=-1 THEN x=50
	IF y=-1 THEN y=50
	IF w<50 THEN w=300
	IF h<50 THEN h=150

	title$="#"+STRING$(slot+1)
  XuiCreateWindow				(@grid, @"XuiArea",x,y,w,h,wintype, "")
	XgrGetGridWindow			( grid,@window)
  XuiSendMessage				( grid, #SetCallback, grid, &uDisplayCB(), -1, -1, 0, grid)
  XuiSendMessage				( grid, #SetWindowTitle, 0, 0, 0, 0, 0, @title$)
	XuiSendMessage				( grid, #SetCursor,#cursorCrosshair, 0, 0, 0, 0, 0)
	XgrCreateGrid					(@buff, $$GridTypeBuffer, 0, 0, w, h,window, 0, 0)
	XgrClearGrid					( buff, #background)
'	XgrClearGrid					( grid, #background)
	XgrSetBackgroundColor ( grid, #background)
	XgrSetBackgroundColor ( buff, #background)


	ImageDataSet[slot].Grid=grid
	ImageDataSet[slot].imagebuffer=buff
	ImageDataSet[slot].Window=window
	ImageDataSet[slot].WinX=x
	ImageDataSet[slot].WinY=y
	ImageDataSet[slot].WinW=w
	ImageDataSet[slot].WinH=h
	ImageDataSet[slot].edgeM=3
	ImageDataSet[slot].leftM=80 ' ImageDataSet[slot].edgeM
	ImageDataSet[slot].rightM=22
	ImageDataSet[slot].topM=ImageDataSet[slot].edgeM
	ImageDataSet[slot].bottomM=40
	ImageDataSet[slot].ImageW=w-ImageDataSet[slot].leftM-ImageDataSet[slot].rightM
	ImageDataSet[slot].ImageH=h-ImageDataSet[slot].topM-ImageDataSet[slot].bottomM
	ImageDataSet[slot].enableVScroll=1
	ImageDataSet[slot].enableYUnit=1


	XuiScrollBarV  (@g, #Create, (w-ImageDataSet[slot].rightM+4), topM, 16, 100, window, grid)
	XuiSendMessage ( g, #SetCallback, grid, &uDisplayCB(), -1, -1, 1, grid)
	XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"TrackScroll")
	XuiSendMessage ( g, #SetStyle, 2, 0, 0, 0, 0, 0)
	XuiSendMessage ( g, #SetColor, #bColour,#bInk ,#bInk ,#bInk, 0, 0)
	XuiSendMessage ( g, #SetAlign, $$AlignMiddleCenter, 0, -1, -1, 0, 0)
	XuiSendMessage ( g, #SetBorder, $$BorderRaise4, $$BorderRaise4, $$BorderNone, 0, 0, 0)
	XuiSendMessage ( g, #SetHintString, 0, 0, 0, 0, 0, @"Adjust track")

'	XgrWindowToSystemWindow (window, @hWnd, dx, dy, width, height)

	IF flag=0 THEN DisplayWindow (grid)

	RETURN 1

END FUNCTION
'
'
' ###################################
' #####  uDisplayDrawTrackA ()  #####
' ###################################
'
FUNCTION  uDisplayDrawTrackA (ud,slot,track,flag)
	SHARED MemDataSet ImageDataSet[]
	SHARED Image ImageFormat[]
	SHARED cur
	SINGLE top,bottom
	SINGLE ww,hh,x,y,hhm,wwx
	SINGLE scrpix


	IF slot<0 THEN RETURN 0

	grid=ImageDataSet[slot].imagebuffer
	IF flag=2 THEN XgrClearGrid (grid,#background): flag=1
	IF flag=4 THEN XgrClearGrid (grid,#background)
	IF track=-1 THEN track=ImageDataSet[slot].uTrack
	ink=ImageDataSet[slot].clr2d

	first=ImageDataSet[slot].fPixel
	last=ImageDataSet[slot].lPixel
	top=ImageDataSet[slot].uMaxValue+ImageDataSet[slot].Voffset
	bottom=ImageDataSet[slot].uMinValue+ImageDataSet[slot].Voffset
	ww=ImageDataSet[slot].ImageW
	hh=ImageDataSet[slot].ImageH
	bottomM=ImageDataSet[slot].bottomM
	topM=ImageDataSet[slot].topM
	leftM=ImageDataSet[slot].leftM
	rightM=ImageDataSet[slot].rightM
	drawImageBorder=1
	startpix=GetPixelAddress (slot,first,track)
	endpix=GetPixelAddress (slot,last,track)


	vinfo=((hh/( top - bottom ))* bottom)
	hhv=hh+vinfo+topM
	hhm=hh/(top-bottom)
	wwx=ww/(last-first)
	xpos=0
	x=leftM
	y=(hhv-(hhm*SINGLEAT(startpix)))

	IF y<(topM-1) THEN
				y=topM-1
	ELSE
				IF y> (topM+hh+1) THEN y=(topM+hh+1)
	END IF

	XgrMoveTo (grid,x,y)

	IFZ #LineType THEN											' solid line

				FOR pos = startpix TO endpix STEP 4

						y=hhv-(hhm*SINGLEAT(pos))
						IF y<(topM-1) THEN
									y=topM-1
						ELSE
									IF y> (topM+hh+1) THEN y=(topM+hh+1)
						END IF

						XgrDrawLineTo (grid,ink,(wwx*xpos)+leftM,y)
						INC xpos

				NEXT pos
	ELSE																		' single point
				FOR pos = startpix TO endpix STEP 4

						y=hhv-(hhm*SINGLEAT(pos))
						IF y<(topM-1) THEN
									y=topM-1
						ELSE
									IF y> (topM+hh+1) THEN y=(topM+hh+1)
						END IF

						XgrDrawPoint (grid,ink,(wwx*xpos)+leftM,y)
						INC xpos

				NEXT pos
	END IF

	IF ImageDataSet[slot].curPos>0 THEN uDisplayUpdate (slot,$$DrawCursor2d,0,0,0,0)
	IF drawImageBorder=1 THEN uDisplayUpdate (slot,$$DrawBorder2d,0,0,0,0)
	IF flag=1 THEN uDisplayUpdate (slot,$$DrawImage,leftM,topM,ww,hh)

END FUNCTION
'
'
' ###################################
' #####  uDisplayDrawTrackB ()  #####
' ###################################
'
FUNCTION  uDisplayDrawTrackB (slot,x0,y0,x1,y1)
	SHARED MemDataSet ImageDataSet[]
	SHARED Image ImageFormat[]
	SINGLE ww,hh,MaxV,y,v1,top,bottom


	IF y1 < y0 THEN pos=y1: y1=y0: y0=pos
	IF x1 < x0 THEN pos=x1: x1=x0: x0=pos

				ww=ImageDataSet[slot].ImageW
				hh=ImageDataSet[slot].ImageH

				ds=ImageDataSet[slot].DataSet
				pos=(ImageFormat[slot,ds].NumberOfPixels-(ImageFormat[slot,ds].NumberOfPixels-(ImageDataSet[slot].lPixel-ImageDataSet[slot].fPixel)))
				ltmp=ImageDataSet[slot].lPixel: ftmp=ImageDataSet[slot].fPixel

				ImageDataSet[slot].lPixel=((pos/ww)*x1)+ImageDataSet[slot].fPixel
				ImageDataSet[slot].fPixel=((pos/ww)*x0)+ImageDataSet[slot].fPixel

				IF (ImageDataSet[slot].lPixel-ImageDataSet[slot].fPixel) < 20 THEN
							ImageDataSet[slot].fPixel=ftmp
							ImageDataSet[slot].lPixel=ltmp
							EXIT FUNCTION
				END IF

				v1=y0: GOSUB GetMaxV
				highy!=MaxV
				v1=y1: GOSUB GetMaxV
				ImageDataSet[slot].uMinValue=MaxV
				ImageDataSet[slot].uMaxValue=highy!

				uDisplayUpdate (slot,$$DrawTrackA ,-1,2,0,0)


RETURN

'############
SUB GetMaxV
'############

	top=ImageDataSet[slot].uMaxValue
	bottom=ImageDataSet[slot].uMinValue
	vinfo=((hh/( top - bottom ))* bottom)
	y=XLONG((top-(((top-bottom)/hh)*(v1-vinfo)))-bottom)

	IF (y<10 && y>-10) THEN
				y=(top-(((top-bottom)/hh)*(SINGLE(v1)-vinfo)))-bottom
	END IF

	MaxV=y


END SUB

END FUNCTION
'
'
' ##################################
' #####  uDisplayGetBuffer ()  #####
' ##################################
'
FUNCTION  uDisplayGetBuffer (grid,type)
	SHARED MemDataSet ImageDataSet[]

'	get image buffer

	slot=uDisplayGetSlot (grid,type)
	buff=ImageDataSet[slot].imagebuffer

	RETURN buff

END FUNCTION
'
'
' ###################################
' #####  uDisplayShowWindow ()  #####
' ###################################
'
FUNCTION  uDisplayShowWindow (slot,flag)
	SHARED MemDataSet ImageDataSet[]
	SHARED Image ImageFormat[]


	uDisplayResetScale (slot)  ' this is more hack than a feature

	ImageDataSet[slot].uMinValue=ImageDataSet[slot].MinValue
	ImageDataSet[slot].uMaxValue=ImageDataSet[slot].MaxValue


	ds=ImageDataSet[slot].DataSet
	IF ImageFormat[slot,ds].NumberOfTracks<2 THEN
				XuiSendMessage (ImageDataSet[slot].Grid,#Disable,0,0,0,0,1,0)
				ImageDataSet[slot].rightM=3
				ImageDataSet[slot].enableVScroll=0
	END IF

	window=ImageDataSet[slot].Window
	IF flag THEN
				IFZ GetWindowState (window) THEN CentreWindow (window)
	ELSE
				uDisplayResizeWindow (unused,slot,-1,-1,-1,-1)
	END IF

	XgrDisplayWindow (window)

END FUNCTION
'
'
' ###################################
' #####  uDisplayHideWindow ()  #####
' ###################################
'
FUNCTION  uDisplayHideWindow (slot)
	SHARED MemDataSet ImageDataSet[]


	IF slot=-1 THEN

			FOR slot=0 TO UBOUND (ImageDataSet[])
					window=ImageDataSet[slot].Window
					HideWindow (window)
			NEXT slot

	ELSE
			window=ImageDataSet[slot].Window
			HideWindow (window)
	END IF

END FUNCTION
'
'
' #####################################
' #####  uDisplayResizeWindow ()  #####
' #####################################
'
FUNCTION  uDisplayResizeWindow (unused,slot,x,y,w,h)
	SHARED MemDataSet ImageDataSet[]
	SHARED Image ImageFormat[]
	SHARED cmenu


	IFZ IsImageSlotValid(slot) THEN RETURN 0
	IF cmenu THEN	cMenuClearFrom (0): cmenu=0

	IF x<>-1 THEN ImageDataSet[slot].WinX=x ELSE x=ImageDataSet[slot].WinX
	IF y<>-1 THEN ImageDataSet[slot].WinY=y ELSE y=ImageDataSet[slot].WinY
	IF w<>-1 THEN ImageDataSet[slot].WinW=w ELSE w=ImageDataSet[slot].WinW
	IF h<>-1 THEN ImageDataSet[slot].WinH=h ELSE h=ImageDataSet[slot].WinH

	ImageDataSet[slot].ImageW=w-ImageDataSet[slot].leftM-ImageDataSet[slot].rightM
	ImageDataSet[slot].ImageH=h-ImageDataSet[slot].topM-ImageDataSet[slot].bottomM

	XgrSetGridDrawingMode (ImageDataSet[slot].Grid, $$DrawModeCOPY , $$LineStyleSolid, 1)
	XgrSetGridDrawingMode (ImageDataSet[slot].imagebuffer, $$DrawModeCOPY , $$LineStyleSolid, 1)
	XgrSetGridPositionAndSize (ImageDataSet[slot].imagebuffer, 0, 0, w, h)
	XgrClearGrid (ImageDataSet[slot].imagebuffer,#background)

	IF ImageDataSet[slot].enableVScroll=1 THEN XuiSendMessage (ImageDataSet[slot].Grid,#Resize,(w-ImageDataSet[slot].rightM)+5, (ImageDataSet[slot].topM)-1, 16, ImageDataSet[slot].ImageH+3,1,0)
	uDisplayUpdate (slot,$$DrawTrackA | $$DrawVScrollBar | $$DrawPixelDataValue | $$DrawYUnit2d,-1,1,0,0)


	RETURN 1

END FUNCTION
'
'
' ################################
' #####  uDisplaySetSize ()  #####
' ################################
'
FUNCTION  uDisplaySetSize (slot,w,h)
	SHARED MemDataSet ImageDataSet[]


	window=ImageDataSet[slot].Window
	XgrSetWindowPositionAndSize (window,-1,-1,w,h)
	ret=uDisplayResizeWindow (unused,slot,-1,-1,w,h)

	RETURN ret

END FUNCTION
'
'
' ####################################
' #####  uDisplaySetPosition ()  #####
' ####################################
'
FUNCTION  uDisplaySetPosition (slot,x,y)
	SHARED MemDataSet ImageDataSet[]


	grid=ImageDataSet[slot].Window
	XgrSetWindowPositionAndSize (grid, x, y,-1 ,-1)


END FUNCTION
'
'
' ################################
' #####  uDisplayGetSize ()  #####
' ################################
'
FUNCTION  uDisplayGetSize (slot,w,h)
	SHARED MemDataSet ImageDataSet[]


	window=ImageDataSet[slot].Window
	XgrGetWindowPositionAndSize (window,x,y,@w,@h)

END FUNCTION
'
'
' ####################################
' #####  uDisplayGetPosition ()  #####
' ####################################
'
FUNCTION  uDisplayGetPosition (slot,x,y)
	SHARED MemDataSet ImageDataSet[]


	window=ImageDataSet[slot].Window
	XgrGetWindowPositionAndSize (window,@x,@y,w,h)

END FUNCTION
'
'
' ###############################
' #####  uDisplayDrag2d ()  #####
' ###############################
'
FUNCTION  uDisplayDrag2d (slot,x,y)
	SHARED Image ImageFormat[]
	SHARED MemDataSet ImageDataSet[]
	SHARED fp,lp,cr,cur
	SINGLE xdiff,ww,hh,top,bottom


	ds=ImageDataSet[slot].DataSet
	ww=ImageDataSet[slot].ImageW
	hh=ImageDataSet[slot].ImageH

	ImageDataSet[slot].Voffset=((ImageDataSet[slot].uMaxValue-ImageDataSet[slot].uMinValue)/hh)*(y-#ydrag)

	oldfp=ImageDataSet[slot].fPixel
	oldlp=ImageDataSet[slot].lPixel
	scrpix=ImageDataSet[slot].lPixel-ImageDataSet[slot].fPixel

	xdiff=(scrpix/ww)*(x-#xdrag)
	ImageDataSet[slot].fPixel=fp-xdiff
	ImageDataSet[slot].lPixel=lp-xdiff

	IF ImageDataSet[slot].fPixel<1 THEN
				xd=ImageDataSet[slot].fPixel
				ImageDataSet[slot].fPixel=1
				ImageDataSet[slot].lPixel=scrpix+1
				xdiff=xdiff+xd
	END IF

	IF ImageDataSet[slot].lPixel>ImageFormat[slot,ds].NumberOfPixels THEN
				xd=(ImageFormat[slot,ds].NumberOfPixels)-ImageDataSet[slot].lPixel
				ImageDataSet[slot].lPixel=ImageFormat[slot,ds].NumberOfPixels
				ImageDataSet[slot].fPixel=(ImageFormat[slot,ds].NumberOfPixels-scrpix)
				xdiff=xdiff-xd
	END IF

	#slottowindowlock=0
	IF #slottowindowlock=1 THEN
				IF ((oldlp<>ImageDataSet[slot].lPixel) OR (oldlp<>ImageDataSet[slot].lPixel)) THEN
							#drawXinfo=2
						'	cur=cr+xdiff
				ELSE
							#drawXinfo=0
				END IF

				#Voffset=y-#ydrag
				DisplayTrack (ImageDataSet[slot].Track,0)
				#drawXinfo=1
				setTrackVoffset (slot)
	END IF

	uDisplayUpdate (slot,$$DrawTrackA | $$DrawYUnit2d ,-1,2,0,0)


END FUNCTION
'
'
' ###################################
' #####  uDisplayResetScale ()  #####
' ###################################
'
FUNCTION  uDisplayResetScale (slot)
	SHARED MemDataSet ImageDataSet[]
	SHARED Image ImageFormat[]
	SHARED TrackData TrackInfo[]


	ImageDataSet[slot].fPixel=1
	ImageDataSet[slot].lPixel=ImageFormat[slot,ds].NumberOfPixels
	ImageDataSet[slot].curPos=ImageDataSet[slot].lPixel*0.5

	uDisplayScaleTrack (slot,-1)

END FUNCTION
'
'
' ###########################
' #####  uDisplayCB ()  #####
' ###########################
'
FUNCTION  uDisplayCB (grid, message, v0, v1, v2, v3, kid, r1)
	SHARED MemDataSet ImageDataSet[]
	SHARED Image ImageFormat[]
	SHARED CMENUITEM cmenu[]
	SHARED CMENUPOS cmenuXY[]
	SHARED startX,startY,endX,endY,slotDrag,actualX
	SHARED fp,lp
	SHARED cmenu,BaseMenu
	SINGLE scrpix,ww,hh,y,bottom,top,x
	STATIC currentMenu,currentItem
	STATIC currentGrid
	STATIC linecol,boxsmall
	STATIC key,MposX



'	XuiReportMessage (grid, message, v0, v1, v2, v3, kid, r1)
	IF (message==#Callback) THEN message = r1
'	XgrMessageNumberToName  (message,@message$): PRINT grid, message$, v0, v1, v2, v3, kid, r1

	slot=uDisplayGetSlot (grid,1)

	SELECT CASE message
		CASE #WindowDeselected : IF cmenu THEN cMenuClearFrom (0)
		CASE #MouseMove				: GOSUB MouseMove
		CASE #MouseDrag				: GOSUB MouseDrag
		CASE #MouseEnter			: GOSUB MouseEnter
		CASE #KeyDown					: GOSUB KeyDown
		CASE #MouseDown				:	GOSUB MouseDown
		CASE #MouseUp					: GOSUB MouseUp
		CASE #Redrawn					:	GOSUB Redraw
		CASE #Change					: GOSUB MouseVScrollChange
		CASE #CloseWindow			: uDisplayHideWindow (slot)
		CASE #OneLess					: v3=1: GOSUB ChangeTrack
		CASE #OneMore					:	v3=0: GOSUB ChangeTrack
		CASE #MouseWheel			: GOSUB ChangeTrack
		CASE #Help						: GOSUB cMenu
		CASE #ContextMenuUp		: cMenuSelectionCB (v0,v1,kid)
														'text$="'"+CSTRING$(cMenuGetItem (v0,v1))+"'"
														'PRINT "UP - "+text$, "id:"+STRING(kid)
		CASE #ContextMenuDown	: 'text$="'"+CSTRING$(cMenuGetItem (v0,v1))+"'"
														'PRINT "DOWN - "+text$, "id:"+STRING(kid)
	END SELECT

RETURN

'############
SUB KeyDown
'############

	key=v2{$$VirtualKey}

	SELECT CASE key
		CASE $$KeyT				:	#grid=grid:	#buff=#cBuff
											 cMenuDraw (#bm,10,10,-1)
											currentItem=-1
											currentMenu=-1
											currentGrid=grid
											cmenu=-1

		CASE $$KeyUpArrow	:v3=1 GOSUB ChangeTrack
		CASE $$KeyDownArrow	:v3=0 GOSUB ChangeTrack
		CASE $$KeyX				:	uDisplayScaleTrack (slot,-1)
												uDisplayUpdate (slot,$$DrawTrackA | $$DrawYUnit2d,-1,2,0,0)
		CASE $$KeyD				:	IF ImageDataSet[slot].trackCursor THEN
															uDisplayUpdate (slot,$$DrawDisableCurTrack | $$DrawPixelDataValue,0,0,0,0)
												ELSE
															uDisplayUpdate (slot,$$DrawEnableCurTrack | $$DrawPixelDataValue,0,0,0,0)
												END IF
		CASE $$KeyU				: openUD_test ()
		CASE $$KeyZ				: 'uDisplayResetScale (slot)
												ImageDataSet[slot].fPixel=1
												ImageDataSet[slot].lPixel=ImageFormat[slot,ds].NumberOfPixels
												uDisplayScaleTrack (slot,-1)
												uDisplayUpdate (slot, $$DrawTrackA | $$DrawYUnit2d ,-1,2,0,0)
		CASE $$KeyS				: IF ImageDataSet[slot].enableVScroll THEN
															uDisplayUpdate (slot,$$DrawDisableVScroll | $$DrawPixelDataValue,0,0,0,0)
												ELSE
															uDisplayUpdate (slot,$$DrawEnableVScroll | $$DrawPixelDataValue,0,0,0,0)
												END IF
		CASE $$KeyA				: IF ImageDataSet[slot].enableYUnit THEN
															uDisplayUpdate (slot,$$DrawDisableYUnit2d | $$DrawPixelDataValue,0,0,0,0)
												ELSE
															uDisplayUpdate (slot,$$DrawEnableYUnit2d | $$DrawPixelDataValue,0,0,0,0)
												END IF
		CASE $$KeyF				: IF ImageDataSet[slot].enableXUnit THEN
															uDisplayUpdate (slot,$$DrawDisableXUnit2d ,0,0,0,0)
												ELSE
															uDisplayUpdate (slot,$$DrawEnableXUnit2d ,0,0,0,0)
												END IF
		CASE $$KeyC				: IF ImageDataSet[slot].curPos>0 THEN
															ImageDataSet[slot].curPos=-1
												ELSE
															ImageDataSet[slot].curPos=((ImageDataSet[slot].lPixel-ImageDataSet[slot].fPixel)*0.5)+ImageDataSet[slot].fPixel
												END IF
												uDisplayUpdate (slot, $$DrawTrackA ,-1,2,0,0)

		CASE $$KeyLeftArrow : IF ImageDataSet[slot].curPos<1 THEN RETURN

													IF (((ImageDataSet[slot].curPos-ImageDataSet[slot].fPixel)<10) AND (ImageDataSet[slot].fPixel>10)) THEN
																ImageDataSet[slot].fPixel=ImageDataSet[slot].fPixel-10
																ImageDataSet[slot].lPixel=ImageDataSet[slot].lPixel-10
													ELSE
																IF  (((ImageDataSet[slot].curPos-ImageDataSet[slot].fPixel)<11) AND (ImageDataSet[slot].fPixel<11) AND (ImageDataSet[slot].fPixel>1)) THEN
																		DEC ImageDataSet[slot].lPixel
																		DEC ImageDataSet[slot].fPixel
																END IF
													END IF

													DEC ImageDataSet[slot].curPos
													IF ImageDataSet[slot].curPos<1 THEN ImageDataSet[slot].curPos=1
													uDisplayUpdate (slot,$$DrawTrackA | $$DrawPixelDataValue ,-1,2,0,0)
		CASE $$KeyRightArrow : IF ImageDataSet[slot].curPos<1 THEN RETURN

													ds=ImageDataSet[slot].DataSet
													IF ((ImageDataSet[slot].curPos > (ImageDataSet[slot].lPixel-11)) AND ((ImageDataSet[slot].lPixel+10) < ImageFormat[slot,ds].NumberOfPixels)) THEN
																ImageDataSet[slot].fPixel=ImageDataSet[slot].fPixel+10
																ImageDataSet[slot].lPixel=ImageDataSet[slot].lPixel+10
													ELSE
																IF  (ImageDataSet[slot].curPos > (ImageFormat[slot,ds].NumberOfPixels-11)) AND (ImageDataSet[slot].lPixel < (ImageFormat[slot,ds].NumberOfPixels)) THEN
																		INC ImageDataSet[slot].lPixel
																		INC ImageDataSet[slot].fPixel
																END IF
													END IF

													INC ImageDataSet[slot].curPos
													IF ImageDataSet[slot].curPos>ImageDataSet[slot].lPixel THEN ImageDataSet[slot].curPos=ImageDataSet[slot].lPixel
													uDisplayUpdate (slot,$$DrawTrackA | $$DrawPixelDataValue ,-1,2,0,0)

	END SELECT


END SUB


'###############
SUB MouseEnter
'###############

'	uDisplayUpdate (slot,$$DrawYUnit2d | $$DrawPixelDataValue,0,0,0,0)

END SUB


'##########
SUB cMenu
'##########

	IF cmenu THEN cMenuClearFrom (0)
	IF #trackCursor=1 THEN cmenu=1: uDisplayUpdate (slot,$$DrawTrackMouse ,v0,v1,0,0)
	uDisplayUpdate (slot,$$DrawYUnit2d | $$DrawPixelDataValue,0,0,0,0) ' buff any data menu might erase


	#grid=grid
	#buff=#cBuff
	cMenuDraw (BaseMenu,v0,v1,-1)
	currentItem=-1
	currentMenu=-1
	currentGrid=grid
	cmenu=-1
	endX=0
	endY=0
	startY=0
	startX=0
	slotDrag=0

END SUB

'################
SUB ChangeTrack
'################

'	v3=1  = up
'	v3=0	= down

	IF cmenu THEN RETURN

	ds=ImageDataSet[slot].DataSet
	IF ImageFormat[slot,ds].NumberOfTracks<2 THEN EXIT SUB

	IF v3>0 THEN
				IF ImageDataSet[slot].uTrack>=ImageFormat[slot,ds].NumberOfTracks THEN EXIT SUB
				INC ImageDataSet[slot].uTrack
	ELSE
				IF ImageDataSet[slot].uTrack<=1 THEN EXIT SUB
				DEC ImageDataSet[slot].uTrack
	END IF

	uDisplayUpdate (slot,$$DrawTrackA | $$DrawPixelDataValue | $$DrawVScrollBar ,-1,2,0,0)

END SUB


'#######################
SUB MouseVScrollChange
'#######################

	IF cmenu THEN cMenuClearFrom (0)

	leftM=ImageDataSet[slot].leftM
	topM=ImageDataSet[slot].topM
	ww=ImageDataSet[slot].ImageW
	hh=ImageDataSet[slot].ImageH

	GOSUB vScrollChange		' check bounds

	uDisplayUpdate (slot,$$DrawTrackA ,-1,4,0,0)
	uDisplayUpdate (slot,$$DrawImage | $$DrawPixelDataValue,leftM, topM,ww ,hh )

END SUB

'############
SUB MouseUp
'############

	IF cmenu=-1 THEN cmenu=1: RETURN
	IF cmenu THEN
				cmenu=0
				cMenuClearFrom (0)
				IFZ cMenuisInMenu (currentMenu,v0,v1) THEN RETURN
				IFZ cMenuisInItem (currentMenu,currentItem,v0,v1) THEN RETURN
				uDisplayCB (grid, #ContextMenuUp, currentMenu,currentItem,v0,v1,cMenuGetID (currentMenu,currentItem,id), slot)
				RETURN
	END IF

	IF kid=0 THEN
			IF ((slotDrag=0) AND (key AND $$MouseButton1)) THEN			' pixel selected

						IF ImageDataSet[slot].curPos=-1 THEN RETURN
						IF actualX<ImageDataSet[slot].leftM THEN RETURN
						IF actualX>(ImageDataSet[slot].leftM+ImageDataSet[slot].ImageW) THEN RETURN

						MposX=MposX-ImageDataSet[slot].leftM
						scrpix=(ImageDataSet[slot].lPixel-ImageDataSet[slot].fPixel)
						x=XLONG((MposX*(scrpix/ImageDataSet[slot].ImageW))+ImageDataSet[slot].fPixel)
						IF x<1 THEN
								x=1
						ELSE
								IF x>ImageDataSet[slot].lPixel THEN x=ImageDataSet[slot].lPixel
						END IF
						ImageDataSet[slot].curPos=x
						uDisplayUpdate (slot,$$DrawTrackA | $$DrawPixelDataValue | $$DrawYUnit2d,-1,2,0,0)

			END IF

			IF ((slotDrag=2) AND (key AND $$MouseButton2)) THEN
						slotDrag=0
						ImageDataSet[slot].uMaxValue=ImageDataSet[slot].uMaxValue+ImageDataSet[slot].Voffset
						ImageDataSet[slot].uMinValue=ImageDataSet[slot].uMinValue+ImageDataSet[slot].Voffset
						ImageDataSet[slot].Voffset=0
						uDisplayUpdate (slot, $$DrawPixelDataValue,0,0,0,0)

			END IF

			IF slotDrag=1 THEN
						slotDrag=0

						GOSUB setendXY
						XgrSetGridDrawingMode (grid, $$DrawModeXOR , #LineStyle, 1)
						XgrDrawBox(grid, #LineStyleInk, startX, startY, endX, endY)							'erase old line

						IF boxsmall=1 THEN
									XgrDrawLine (grid, #LineStyleInk, startX, startY, endX, endY)
									XgrDrawLine (grid, #LineStyleInk, endX, startY, startX, endY)
									#LineStyleInk=linecol
									EXIT FUNCTION
						END IF

						#LineStyleInk=linecol
						XgrSetGridDrawingMode (grid, 0 , #LineStyle, 1)

						left=ImageDataSet[slot].leftM
						top=ImageDataSet[slot].topM
						uDisplayUpdate (slot,$$DrawTrackB | $$DrawYUnit2d | $$DrawPixelDataValue,startX-left,startY-top,endX-left,endY-top)


			END IF
	END IF


END SUB


'##############
SUB MouseDrag
'##############

	IF cmenu<>0 THEN RETURN

	IF kid=0 THEN
			IF (key AND $$MouseButton2) THEN
									slotDrag=2
									uDisplayDrag2d (slot,v0,v1)
									EXIT FUNCTION
			END IF


			IF (key AND $$MouseButton1) THEN

									slotDrag=1
									XgrSetGridDrawingMode (grid, $$DrawModeXOR , #LineStyle, 1)
									XgrDrawBox(grid, #LineStyleInk, startX, startY, endX, endY)							'erase old line

									IF boxsmall=1 THEN
											'	#LineStyleInk= $$MediumCyan
												XgrDrawLine (grid, #LineStyleInk, startX, startY, endX, endY)
												XgrDrawLine (grid, #LineStyleInk, endX, startY, startX, endY)
											'	#LineStyleInk=linecol
												boxsmall=0
									END IF

									GOSUB setendXY

									y1=endY: y0=startY
									x0=startX: x1=endX
									IF y1 < y0 THEN pos=y1: y1=y0: y0=pos
									IF x1 < x0 THEN pos=x1: x1=x0: x0=pos

									ww=ImageDataSet[slot].ImageW
									hh=ImageDataSet[slot].ImageH

									ds=ImageDataSet[slot].DataSet
									pos=(ImageFormat[slot,ds].NumberOfPixels-(ImageFormat[slot,ds].NumberOfPixels-(ImageDataSet[slot].lPixel-ImageDataSet[slot].fPixel)))

									lPixel=((pos/ww)*x1)+ImageDataSet[slot].fPixel
									fPixel=((pos/ww)*x0)+ImageDataSet[slot].fPixel

									IF (((lPixel-fPixel) < 20) OR ((y1-y0)<15)) THEN
														#LineStyleInk= $$MediumCyan
														boxsmall=1
														XgrDrawLine (grid, #LineStyleInk, startX, startY, endX, endY)
														XgrDrawLine (grid, #LineStyleInk, endX, startY, startX, endY)
									ELSE
														#LineStyleInk=linecol
									END IF

									XgrDrawBox (grid, #LineStyleInk, startX, startY, endX, endY)							'draw new line
									XgrSetGridDrawingMode (grid, 0 , #LineStyle, 1)
			END IF
	END IF


END SUB


'##############
SUB MouseDown
'##############

	key=0
	slotDrag=0

	IF cmenu THEN

			IFZ cMenuisInMenu (currentMenu,v0,v1) THEN
						cmenu=0
						cMenuClearFrom (0)
						RETURN
			END IF

			IFZ cMenuisInItem (currentMenu,currentItem,v0,v1) THEN RETURN
			uDisplayCB (grid, #ContextMenuDown, currentMenu,currentItem,v0,v1,cMenuGetID (currentMenu,currentItem,id), slot)
			RETURN
	END IF

	key=v2

	IF kid=0 THEN

			IF (key AND $$MouseButton1) THEN
						linecol=#LineStyleInk
						actualX=v0
						GOSUB setendXY
						startX=v0
						startY=v1
						endX=v0
						endY=v1
						MposX=v0
					'	slotDrag=1
			END IF

			IF (key AND $$MouseButton2) THEN
						fp=ImageDataSet[slot].fPixel
						lp=ImageDataSet[slot].lPixel
						#xdrag=v0
						#ydrag=v1
						#vtempoff=0
					'	slotDrag=2
			END IF


	END IF

END SUB


'##################
SUB vScrollChange
'##################

	ds=ImageDataSet[slot].DataSet
	ImageDataSet[slot].uTrack=ULONG(ImageFormat[slot,ds].NumberOfTracks-((ImageFormat[slot,ds].NumberOfTracks/SINGLE(v3))*v1))
	IF ImageDataSet[slot].uTrack >= ImageFormat[slot,ds].NumberOfTracks THEN ImageDataSet[slot].uTrack=ImageFormat[slot,ds].NumberOfTracks
	IF ImageDataSet[slot].uTrack <1 THEN ImageDataSet[slot].uTrack=1

END SUB


'##############
SUB MouseMove
'##############

#item=0
IF cmenu THEN

	IF currentGrid<>grid THEN RETURN

	FOR menu=0 TO UBOUND(cmenuXY[])
			IF cmenuXY[menu].active=2 THEN
					FOR item=0 TO cMenuGetMaxItems (menu)
							IF cmenu[menu,item].status=$$CM_ST_Enable THEN
									IF ((cMenuisInItem (menu,item,v0,v1) AND (cmenuXY[menu].lastI<>item)) ) THEN

											currentMenu=menu: currentItem=item

											cMenuClearFrom (menu+1)
											cMenuDraw (menu, -1,-1,item)

											IF cMenuGetSubMenu (menu,item,@sub)<>-1 THEN
														x=cmenu[menu,item].dx+2
														y=cmenu[menu,item].dy-(cmenu[menu,item].dy-cmenu[menu,item].y)-4
														cMenuDraw (sub,x,y,0xFFFF)
											END IF
									END IF

							END IF
					NEXT item
			END IF
	NEXT menu

	RETURN

END IF

	IF #trackCursor=1 THEN uDisplayUpdate (slot,$$DrawTrackMouse ,v0,v1,0,0)

END SUB


'###########
SUB Redraw
'###########

	IF kid=0 THEN uDisplayUpdate (slot,$$DrawImage | $$DrawVScrollBar | $$DrawYUnit2d | $$DrawPixelDataValue | $$DrawBorder2d ,v0,v1,v2,v3): EXIT FUNCTION
	IF kid=1 THEN	uDisplayUpdate (slot,$$DrawVScrollBar,0,0,0,0)

END SUB


'#############
SUB setendXY
'#############

	IF v0 < SINGLE(ImageDataSet[slot].leftM) THEN
			v0=ImageDataSet[slot].leftM
	ELSE
			IF v0 > (ImageDataSet[slot].WinW-ImageDataSet[slot].rightM) THEN v0=(ImageDataSet[slot].WinW-ImageDataSet[slot].rightM)
	END IF

	IF v1 < SINGLE(ImageDataSet[slot].topM)
				v1=ImageDataSet[slot].topM
	ELSE
				IF v1 > (ImageDataSet[slot].WinH-ImageDataSet[slot].bottomM) THEN v1=(ImageDataSet[slot].WinH-ImageDataSet[slot].bottomM)
	END IF

	endX=v0
	endY=v1

END SUB

END FUNCTION
'
'
' ###############################
' #####  uDisplayUpdate ()  #####
' ###############################
'
FUNCTION  uDisplayUpdate (slot,flag,v0,v1,v2,v3)
	SHARED MemDataSet ImageDataSet[]
	SHARED Image ImageFormat[]
	SINGLE scrpix,ww,hh,x,y,bottom,top
	SHARED cmenu


'$$DrawEnableXUnit2d=		0x80000000
'$$DrawEnableYUnit2d=		0x40000000
'$$DrawDisableXUnit2d=	0x20000000
'$$DrawDisableYUnit2d=	0x10000000
'$$DrawImageFilename=		0x08000000
'$$DrawXUnit2d=					0x04000000
'$$DrawYUnit2d=					0x02000000
'$$DrawPixelDataValue=	0x01000000


'$$DrawXLabel2d=				0x40000000
'$$DrawYLabel2d=				0x10000000
'$$DrawPixelXValue=			0x04000000
'$$DrawPixelYValue=			0x02000000

'$$DrawSigBt1Sig=				0x00800000
'$$DrawSigBt2Ref=				0x00400000
'$$DrawSigBt3Bg=				0x00200000
'$$DrawSigBt4Liv=				0x00100000
'$$DrawSigBt5Src=				0x00080000
'$$DrawSigBt6Usr1=			0x00040000
'$$DrawSigBt7Usr2=			0x00020000
'$$DrawSigBt8Usr8=			0x00010000

'$$DrawVScrollBar=			0x00008000
'$$DrawImageBorder=			0x00004000
'$$DrawTrackMouse=			0x00002000
'$$DrawImage=						0x00001000
'$$DrawTrackA=					0x00000800
'$$DrawTrackB=					0x00000400
'$$DrawBorder2d=				0x00000200
'$$DrawBorderImage=			0x00000100
'$$DrawCursor2d=				0x00000080
'$$DrawCursorImage=			0x00000040
'$$DrawEnableVScroll=		0x00000020
'$$DrawDisableVScroll=	0x00000010
'$$DrawEnableCurTrack=	0x00000008
'$$DrawDisableCurTrack= 0x00000004

'PRINT BIN$(flag), HEX$(flag)


	SELECT CASE ALL TRUE
		CASE 	(flag AND $$DrawTrackMouse )		: GOSUB DrawTrackMouse: EXIT SELECT
		CASE 	(flag AND $$DrawEnableCurTrack) : GOSUB DrawEnableCurTrack
		CASE 	(flag AND $$DrawDisableCurTrack): GOSUB DrawDisableCurTrack
		CASE 	(flag AND $$DrawEnableXUnit2d)	: GOSUB DrawEnableXUnit2d
		CASE 	(flag AND $$DrawDisableXUnit2d)	: GOSUB DrawDisableXUnit2d
		CASE 	(flag AND $$DrawEnableYUnit2d)	: GOSUB DrawEnableYUnit2d
		CASE 	(flag AND $$DrawDisableYUnit2d)	: GOSUB DrawDisableYUnit2d
		CASE 	(flag AND $$DrawDisableVScroll)	: GOSUB DisableVScroll
		CASE 	(flag AND $$DrawEnableVScroll)	: GOSUB EnableVScroll
		CASE 	(flag AND $$DrawTrackA )				: GOSUB DrawTrackA
		CASE 	(flag AND $$DrawTrackB )				: GOSUB DrawTrackB
		CASE 	(flag AND $$DrawImage )					: GOSUB DrawImage
		CASE 	(flag AND $$DrawBorder2d )		  : GOSUB DrawBorder2d
		CASE 	(flag AND $$DrawCursor2d )			: GOSUB DrawCursor2d
		CASE 	(flag AND $$DrawVScrollBar )		: GOSUB RedrawScroll
		CASE 	(flag AND $$DrawTrackMouse )		: GOSUB DrawTrackMouse
		CASE 	(flag AND $$DrawYUnit2d)				: GOSUB DrawYUnit2d
		CASE 	(flag AND $$DrawXUnit2d)			  : GOSUB DrawXUnit2d
		CASE 	(flag AND $$DrawPixelDataValue)	: GOSUB DrawPixelDataValue


	'	CASE 	(flag AND  )		  : GOSUB

	END SELECT

RETURN


'#######################
SUB DrawPixelDataValue
'#######################

	IFZ ImageDataSet[slot].enablePixDatVal THEN EXIT SUB
	IF ImageDataSet[slot].curPos<1 THEN EXIT SUB
	IF ImageDataSet[slot].bottomM<10 THEN EXIT SUB

	cur=ImageDataSet[slot].curPos
	ds=ImageDataSet[slot].DataSet
	x!=((cur)*ImageFormat[slot,ds].xCal[1]+ImageFormat[slot,ds].xCal[0]+ (ImageFormat[slot,ds].fPixel*ImageFormat[slot,ds].xCal[1]))+ImageFormat[slot,ds].bLeft-1
	y=ImageDataSet[slot].uTrack
	leftM=ImageDataSet[slot].leftM
	grid=ImageDataSet[slot].imagebuffer
	XgrSetGridFont (grid,#valfont)

	GetPixelValue (slot,cur,y,@v!)
	text$="X:"+STRING$(x!)+"   Data:"+STRING$(v!)+"   Y:"+STRING$(y*ImageFormat[slot,ds].vBin) '+" "

	pos=ImageDataSet[slot].WinH-17
	XgrMoveTo (grid,leftM,pos)
	XgrDrawTextFill (grid, #ink,@text$)
	'XgrGetDrawpoint (grid, @x,y)

	XgrDrawImage (ImageDataSet[slot].Grid,grid, leftM, pos, 250,pos+14, leftM, pos)

END SUB



'################
SUB DrawXUnit2d
'################



END SUB


'################
SUB DrawYUnit2d
'################

	IFZ ImageDataSet[slot].enableYUnit THEN RETURN

	grid=ImageDataSet[slot].imagebuffer
	hh=ImageDataSet[slot].ImageH
	top=ImageDataSet[slot].uMaxValue+ImageDataSet[slot].Voffset
	bottom=ImageDataSet[slot].uMinValue+ImageDataSet[slot].Voffset
	topM=ImageDataSet[slot].topM
	leftM=ImageDataSet[slot].leftM
	points!=5
	IF (top-bottom)<10 THEN dtype=0 ELSE dtype=1

	XgrSetGridDrawingMode (grid, 0 , 0, 1)
	XgrSetGridFont (grid,#valfont)
	XgrGetFontMetrics (#valfont, @maxCharWidth, @maxCharHeight, ascent, DECent, gap, flags)
	maxCharWidth=(maxCharWidth*0.5)+1

	IF dtype THEN
				texta$=STRING$(XLONG(top))
				textb$=STRING$(XLONG(bottom))
	ELSE
				texta$=STRING$(SINGLE(top))
				textb$=STRING$(SINGLE(bottom))
	END IF

	x=(leftM-(LEN(texta$))*maxCharWidth)
	IF x>40 THEN x=40
	XgrMoveTo (grid,x,-1)
	XgrDrawTextFill (grid, #ink,texta$)

	x=(leftM-(LEN(textb$))*maxCharWidth)
	IF x>40 THEN x=40
	XgrMoveTo (grid,x,(hh+topM-maxCharHeight+5))
	XgrDrawTextFill (grid, #ink,textb$)

	FOR pos = 0 TO points!
				ya=hh-((hh/points!)*pos)+topM
				XgrDrawLine (grid, #ink,leftM-7,ya,leftM-3,ya)
	NEXT pos

	FOR pos = 1 TO points!-1
				ya=hh-((hh/points!)*pos)
				vinfo=ya-((hh/(top-bottom))*bottom)

				IF dtype THEN
							text$=STRING$(XLONG(((top-(((top-bottom)/hh)*vinfo))-bottom)))
				ELSE
							text$=STRING$(SINGLE(((top-(((top-bottom)/hh)*vinfo))-bottom)))
				END IF

				x=(leftM-(LEN(text$))*maxCharWidth)
				IF x>40 THEN x=40
				XgrMoveTo (grid,x,ya-5)
				XgrDrawTextFill (grid, #ink,text$)

	NEXT pos

	XgrDrawImage (ImageDataSet[slot].Grid,grid, 0, 0, leftM-2, topM+hh+5, 0, 0)

END SUB


'######################
SUB DrawEnableYUnit2d
'######################

	ImageDataSet[slot].enableYUnit=1
	ImageDataSet[slot].leftM=80
	ImageDataSet[slot].ImageW=ImageDataSet[slot].WinW-ImageDataSet[slot].leftM-ImageDataSet[slot].rightM

	uDisplayUpdate (slot,$$DrawTrackA ,-1,4,0,0)
	XuiSendMessage (ImageDataSet[slot].Grid,#Redraw,0,0,0,0,0,0)

END SUB

'#######################
SUB DrawDisableYUnit2d
'#######################

	ImageDataSet[slot].enableYUnit=0
	ImageDataSet[slot].leftM=ImageDataSet[slot].edgeM
	ImageDataSet[slot].ImageW=ImageDataSet[slot].WinW-ImageDataSet[slot].leftM-ImageDataSet[slot].rightM

	uDisplayUpdate (slot,$$DrawTrackA ,-1,4,0,0)
	XuiSendMessage (ImageDataSet[slot].Grid,#Redraw,0,0,0,0,0,0)

END SUB

'######################
SUB DrawEnableXUnit2d
'######################

	ImageDataSet[slot].enableXUnit=1
	ImageDataSet[slot].bottomM=40

	GOSUB resizeYunit

END SUB


'#######################
SUB DrawDisableXUnit2d
'#######################

	ImageDataSet[slot].enableXUnit=0
	IF ImageDataSet[slot].trackCursor=1 THEN
				ImageDataSet[slot].bottomM=40
 	ELSE
				ImageDataSet[slot].bottomM=ImageDataSet[slot].edgeM
	END IF

	GOSUB resizeYunit

END SUB


'#######################
SUB DrawEnableCurTrack
'#######################

	ImageDataSet[slot].trackCursor=1
	ImageDataSet[slot].bottomM=40

	GOSUB resizeYunit

END SUB


'########################
SUB DrawDisableCurTrack
'########################

	ImageDataSet[slot].trackCursor=0
	IF ImageDataSet[slot].enableXUnit=1 THEN
				ImageDataSet[slot].bottomM=40
 	ELSE
				ImageDataSet[slot].bottomM=ImageDataSet[slot].edgeM
	END IF

	GOSUB resizeYunit

END SUB


'##################
SUB EnableVScroll
'##################

	ImageDataSet[slot].enableVScroll=1
	ImageDataSet[slot].rightM=22
	ImageDataSet[slot].ImageW=ImageDataSet[slot].WinW-ImageDataSet[slot].leftM-ImageDataSet[slot].rightM
	XuiSendMessage (ImageDataSet[slot].Grid,#Enable,0,0,0,0,1,0)
	XuiSendMessage (ImageDataSet[slot].Grid,#Resize,(ImageDataSet[slot].WinW-ImageDataSet[slot].rightM)+5, (ImageDataSet[slot].topM)-1, 16, ImageDataSet[slot].ImageH+3,1,0)

	uDisplayUpdate (slot,$$DrawTrackA ,-1,4,0,0)
	XuiSendMessage (ImageDataSet[slot].Grid,#Redraw,0,0,0,0,0,0)

END SUB


'###################
SUB DisableVScroll
'###################

	ImageDataSet[slot].enableVScroll=0
	ImageDataSet[slot].rightM=ImageDataSet[slot].edgeM
	ImageDataSet[slot].ImageW=ImageDataSet[slot].WinW-ImageDataSet[slot].leftM-ImageDataSet[slot].rightM
	XuiSendMessage (ImageDataSet[slot].Grid,#Disable,0,0,0,0,1,0)
	uDisplayUpdate (slot,$$DrawTrackA ,-1,4,0,0)
	XuiSendMessage (ImageDataSet[slot].Grid,#Redraw,0,0,0,0,0,0)

END SUB


'#################
SUB DrawCursor2d
'#################

	IF ImageDataSet[slot].curPos<1 THEN EXIT SUB

	first=ImageDataSet[slot].fPixel
	last=ImageDataSet[slot].lPixel
	top=ImageDataSet[slot].uMaxValue+ImageDataSet[slot].Voffset
	bottom=ImageDataSet[slot].uMinValue+ImageDataSet[slot].Voffset
	leftM=ImageDataSet[slot].leftM
	topM=ImageDataSet[slot].topM
	ww=ImageDataSet[slot].ImageW
	hh=ImageDataSet[slot].ImageH
	curPos=ImageDataSet[slot].curPos
	lppix=GetPixelAddress (slot,curPos,ImageDataSet[slot].uTrack)

	vinfo!=((hh/(top-bottom))*bottom)
	hhv!=hh+vinfo!+topM
	hhm!=hh/((top-bottom))
	wwx!=ww/(last-first)
	x=(wwx!*(curPos-first))+leftM
	y=(hhv!-(hhm!*SINGLEAT(lppix)))

	colour=#cursorColour
	grid=ImageDataSet[slot].imagebuffer
	hh=hh+topM
	ww=ww+leftM

	IF x<(leftM-1) THEN x=leftM-1
	IF x>(ww+1) THEN x=ww+1
	IF y<(topM-1) THEN y=topM-1
	IF y>(hh+1) THEN y=hh+1

	SELECT CASE #CType

				CASE 0:
					size = 15
					sizea=2
					sizeb=2

					IF (y+size-1)<hh THEN XgrDrawLine (grid, colour, x ,y+sizeb, x , y+size)
					IF (y-size+1)>topM THEN XgrDrawLine (grid, colour, x ,y-sizeb, x , y-size)
					IF (x+size-1)<ww THEN XgrDrawLine (grid, colour, x+sizea ,y, x+size , y)
					IF (x-size+1)>leftM THEN XgrDrawLine (grid, colour, x-sizea ,y, x-size , y)
				CASE 1:
					size = 2
					IF (y+size-1)<hh THEN XgrDrawLine (grid, colour, x ,hh, x , y+size)
					IF (x+size-1)<ww THEN XgrDrawLine (grid, colour, ww ,y, x+size , y)
					IF (y-size+1)>topM THEN XgrDrawLine (grid, colour, x ,topM, x , y-size)
					IF (x-size+1)>leftM THEN XgrDrawLine (grid, colour, leftM ,y, x-size , y)
				CASE 2:
					size = 2
					SELECT CASE TRUE
							CASE (y+size) > hh			: size=0: INC hh
							CASE (x+size) > ww			: size=0: INC ww
							CASE (x-size) < leftM		: size=0: DEC leftM
							CASE (y-size) < topM		: size=0: DEC topM
					END SELECT
					XgrDrawLine (grid, colour, ww ,hh, x+size , y+size)
					XgrDrawLine (grid, colour, ww ,topM, x+size , y-size)
					XgrDrawLine (grid, colour, leftM ,hh, x-size , y+size)
					XgrDrawLine (grid, colour, leftM ,topM, x-size, y-size)
				CASE 3:
					size=25
					IF (y+size-1)<hh THEN XgrDrawLine (grid, colour, x,y+3,x ,y+size)
		'		CASE 4:
		'			XgrDrawLine (grid, colour, x , topM, x, hh)
		'			XgrDrawLine (grid, colour, topM, y, ww, y)

	END SELECT



END SUB


'#################
SUB DrawBorder2d
'#################

	leftM=ImageDataSet[slot].leftM
	topM=ImageDataSet[slot].topM
	grid=ImageDataSet[slot].imagebuffer
	XgrSetGridDrawingMode (grid, $$DrawModeCOPY , $$LineStyleSolid, 1)
	XgrDrawBox (grid, #borderColour,leftM-1,topM-1, ImageDataSet[slot].ImageW+leftM+1,ImageDataSet[slot].ImageH+topM+1)


END SUB

'###################
SUB DrawTrackMouse
'###################

	IF ImageDataSet[slot].trackCursor=0 THEN EXIT SUB
	IF ImageDataSet[slot].bottomM<10	THEN EXIT SUB

	bottomM=ImageDataSet[slot].bottomM
	topM=ImageDataSet[slot].topM
	leftM=ImageDataSet[slot].leftM
	rightM=ImageDataSet[slot].rightM

	IF cmenu THEN GOSUB clearTextxy: EXIT FUNCTION

	SELECT CASE TRUE
			CASE  v0<leftM															:GOSUB clearTextxy: EXIT FUNCTION
			CASE  v0>(ImageDataSet[slot].WinW-rightM) 	:GOSUB clearTextxy: EXIT FUNCTION
			CASE  v1<topM																:GOSUB clearTextxy: EXIT FUNCTION
			CASE  v1>(ImageDataSet[slot].WinH-bottomM)	:GOSUB clearTextxy: EXIT FUNCTION
	END SELECT

	v0=v0-leftM
	v1=v1-topM

	IF v0>((ImageDataSet[slot].WinW-rightM-leftM)+1) THEN EXIT FUNCTION
	IF v0<0 THEN EXIT FUNCTION

	ds=ImageDataSet[slot].DataSet
	ww=ImageDataSet[slot].ImageW
	hh=ImageDataSet[slot].ImageH

	scrpix=ImageDataSet[slot].lPixel-ImageDataSet[slot].fPixel

	IF ImageFormat[slot,ds].xCal[1]<>1 THEN
				x!=(((scrpix/ww)*v0)*ImageFormat[slot,ds].xCal[1]+ImageFormat[slot,ds].xCal[0]+(ImageDataSet[slot].fPixel*ImageFormat[slot,ds].xCal[1]))*ImageFormat[slot,ds].hBin
				x$="  x:"+STRING$(x!)
	ELSE
				x=(((v0*(scrpix/ww)) + (ImageDataSet[slot].fPixel+ImageFormat[slot,ds].bLeft-1)+ImageFormat[slot,ds].xCal[0])*ImageFormat[slot,ds].hBin)
				x$="  x:"+STRING$(XLONG(x))
	END IF

	top=ImageDataSet[slot].uMaxValue
	bottom=ImageDataSet[slot].uMinValue
	vinfo=(hh/( top - bottom ))* bottom
	y=XLONG((top-(((top-bottom)/hh)*(v1-vinfo)))-bottom)

	IF (y<10 && y>-10) THEN
				y=(top-(((top-bottom)/hh)*(SINGLE(v1)-vinfo)))-bottom
	END IF

	y$="data:"+STRING$(y)
	GOSUB clearTextxy

	XgrMoveTo (grid,170+leftM,pos)
	XgrDrawTextFill (grid, #ink,x$)
	XgrMoveTo (grid,230+leftM,pos)
	XgrDrawTextFill (grid, #ink,y$)

END SUB


'###############
SUB DrawTrackA
'###############

	uDisplayDrawTrackA (0,slot,v0,v1)

END SUB


'###############
SUB DrawTrackB
'###############

	uDisplayDrawTrackB (slot,v0,v1,v2,v3)

END SUB


'################
SUB DrawImage
'################

	'XgrCopyImage (ImageDataSet[slot].Grid,buff)
	XgrDrawImage (ImageDataSet[slot].Grid,ImageDataSet[slot].imagebuffer, v0, v1, v0+v2, v1+v3, v0, v1)

END SUB

'#################
SUB RedrawScroll
'#################

	ds=ImageDataSet[slot].DataSet

	IF ((#dontupdate=0) AND (ImageDataSet[slot].enableVScroll=1)) THEN
				pos=ImageFormat[slot,ds].NumberOfTracks-ImageDataSet[slot].uTrack+1
				XuiSendMessage (ImageDataSet[slot].Grid, #SetPosition, 1 , pos, pos, ImageFormat[slot,ds].NumberOfTracks,1, 0)
	ELSE
				#dontupdate=0
	END IF

END SUB


' support routines

'################
SUB clearTextxy
'################

	grid=ImageDataSet[slot].Grid
	XgrSetGridFont (grid,#valfont)

	pos=ImageDataSet[slot].WinH-17
	XgrMoveTo (grid,170+leftM,pos)
	XgrDrawTextFill (grid, #ink,#textClear$+"    ")


END SUB

'################
SUB resizeYunit
'################

	ImageDataSet[slot].ImageH=ImageDataSet[slot].WinH-ImageDataSet[slot].topM-ImageDataSet[slot].bottomM
	IF ImageDataSet[slot].enableVScroll=1 THEN
			XuiSendMessage (ImageDataSet[slot].Grid,#Resize,(ImageDataSet[slot].WinW-ImageDataSet[slot].rightM)+5, (ImageDataSet[slot].topM)-1, 16, ImageDataSet[slot].ImageH+3,1,0)
	END IF
	uDisplayUpdate (slot,$$DrawTrackA ,-1,4,0,0)
	XuiSendMessage (ImageDataSet[slot].Grid,#Redraw,0,0,0,0,0,0)

END SUB



END FUNCTION
'
'
' ###################################
' #####  uDisplayScaleTrack ()  #####
' ###################################
'
FUNCTION  uDisplayScaleTrack (slot,track)
	SHARED MemDataSet ImageDataSet[]
	SINGLE a


IF track<1 THEN track=ImageDataSet[slot].uTrack
startpix=GetPixelAddress (slot,ImageDataSet[slot].fPixel,track)
endpix=GetPixelAddress (slot,ImageDataSet[slot].lPixel,track)

a=SINGLEAT (startpix)
ImageDataSet[slot].uMaxValue=a					' we do need a starting point
ImageDataSet[slot].uMinValue=a

FOR x = startpix TO endpix STEP 4		' find the highest and lowest point then store

		a=SINGLEAT (x)
		IF a > ImageDataSet[slot].uMaxValue THEN
					ImageDataSet[slot].uMaxValue=a
		ELSE
					IF a < ImageDataSet[slot].uMinValue THEN ImageDataSet[slot].uMinValue=a
		END IF

NEXT x

IF ImageDataSet[slot].uMaxValue<=ImageDataSet[slot].uMinValue THEN ImageDataSet[slot].uMaxValue=ImageDataSet[slot].uMinValue+1	' divide by zero check


END FUNCTION
'
'
' ############################
' #####  cMenuCreate ()  #####
' ############################
'
FUNCTION  cMenuCreate (menuslot,ctype)
	SHARED CMENUITEM cmenu[]
	SHARED CMENUPOS  cmenuXY[]
	CMENUITEM new[]


	menuslot=-1
	FOR menuslot=1 TO UBOUND(cmenu[])
			IF (menuslot >= UBOUND(cmenu[])) THEN
						REDIM cmenu[menuslot+3,]
						REDIM cmenuXY[menuslot+3]
			END IF
			IF cmenu[menuslot,]=0 THEN EXIT FOR
	NEXT menuslot

	cmenuXY[menuslot].ctype=ctype
	cmenuXY[menuslot].font=#cMenuFont
	cmenuXY[menuslot].lastI=-1

	SELECT CASE ALL TRUE
		CASE (ctype AND $$CM_CT_TypeA)		:cmenuXY[menuslot].basecolour=$$Steel
		CASE (ctype AND $$CM_CT_TypeB)		:cmenuXY[menuslot].basecolour=$$LightGrey
		CASE (ctype AND $$CM_CT_Select)		:
	END SELECT

	DIM new[0]
	ATTACH new[] TO cmenu[menuslot,]

RETURN menuslot

END FUNCTION
'
'
' #############################
' #####  cMenuAddItem ()  #####
' #############################
'
FUNCTION  cMenuAddItem (menuslot,itype,cstring,parent,kid,id)
	SHARED CMENUITEM cmenu[]
	SHARED CMENUPOS cmenuXY[]
	CMENUITEM cmenuitem[]
	STATIC lastrow


	IFZ menuslot THEN RETURN -1

	ATTACH cmenu[menuslot,] TO cmenuitem[]

	IF ((itype=-1) OR (itype=-2)) THEN
			row=UBOUND(cmenuitem[])
			REDIM cmenuitem[row+1]
	END IF

	IF itype >=0 THEN
			row=itype
			ub=UBOUND(cmenuitem[])
			IF (row+2)>ub THEN REDIM cmenuitem[row+2]
	END IF

	IF itype=-4 THEN
			row=lastrow+1
			REDIM cmenuitem[row+1]
	END IF

	IF ((itype=-2) OR (itype=-4)) THEN
			cmenuitem[row].status=$$CM_ST_Disable
			cmenuitem[row].type=cstring

			SELECT CASE cmenuitem[row].type
				CASE $$CM_TY_HSepA				:cmenuitem[row].pixelH=6
				CASE $$CM_TY_HSepB				:cmenuitem[row].pixelH=6
				CASE $$CM_TY_HSepC				:cmenuitem[row].pixelH=12
				CASE $$CM_TY_HSepD				:cmenuitem[row].pixelH=12
				CASE $$CM_TY_HSepE				:cmenuitem[row].pixelH=7
				CASE $$CM_TY_TopBrA				:cmenuitem[row].pixelH=1
				CASE $$CM_TY_TopBrB				:cmenuitem[row].pixelH=3
				CASE $$CM_TY_TopBrC				:cmenuitem[row].pixelH=1
				CASE $$CM_TY_BottomBrA		:cmenuitem[row].pixelH=1
				CASE $$CM_TY_BottomBrB		:cmenuitem[row].pixelH=3
				CASE $$CM_TY_BottomBrC		:cmenuitem[row].pixelH=1
			END SELECT
			cmenuitem[row].name=name$
			cmenuitem[row].nameLen=0
	ELSE
			name$=CSTRING$(cstring)
			cmenuitem[row].type=$$CM_TY_Default
			cmenuitem[row].status=$$CM_ST_Enable
			cmenuitem[row].pixelH=-1
	END IF

	lastrow=row
	cmenuitem[row].name=name$								' text to display
	cmenuitem[row].nameLen=LEN(name$)				' text ^ len
	cmenuitem[row].parent=parent						'	parent menu, -1 if none
	cmenuitem[row].kid=kid									' sub menu attached to this item, -1 if none
	cmenuitem[row].callbackID=id						' callback id, -1 if none
	cmenuXY[menuslot].active=1							' menu only becomes active after an item has been added

	ATTACH cmenuitem[] TO cmenu[menuslot,]

	cMenuEnableItem (menuslot,row)


RETURN row

END FUNCTION
'
'
' #############################
' #####  cMenuGetItem ()  #####
' #############################
'
FUNCTION  cMenuGetItem (menuslot,item)
	SHARED CMENUITEM cmenu[]
'	CMENUITEM cmenuitem[]


	addr=&cmenu[menuslot,item].name
	kid=cmenu[menuslot,item].kid

	RETURN addr


END FUNCTION
'
'
' #################################
' #####  cMenuGetMaxItems ()  #####
' #################################
'
FUNCTION  cMenuGetMaxItems (menuslot)
	SHARED CMENUITEM cmenu[]
'	CMENUITEM cmenuitem[]


	count = UBOUND (cmenu[menuslot,])-1
	RETURN count

END FUNCTION
'
'
' #####################################
' #####  cMenuSetItemPosition ()  #####
' #####################################
'
FUNCTION  cMenuSetItemPosition (menuslot,item,x,y,dx,dy)
	SHARED CMENUITEM cmenu[]


	cmenu[menuslot,item].x=x
	cmenu[menuslot,item].y=y
	cmenu[menuslot,item].dx=dx
	cmenu[menuslot,item].dy=dy


END FUNCTION
'
'
' ###################################
' #####  cMenuGetItemParent ()  #####
' ###################################
'
FUNCTION  cMenuGetItemParent (menu,item,par)
	SHARED CMENUITEM cmenu[]


	par=cmenu[menu,item].parent
	RETURN par


END FUNCTION
'
'
' ################################
' #####  cMenuGetSubMenu ()  #####
' ################################
'
FUNCTION  cMenuGetSubMenu (menuslot,item,sub)
	SHARED CMENUITEM cmenu[]


	sub=cmenu[menuslot,item].kid
	RETURN sub

END FUNCTION
'
'
' ###############################
' #####  cMenuClearFrom ()  #####
' ###############################
'
FUNCTION  cMenuClearFrom (menuslot)
	SHARED CMENUITEM cmenu[]
	SHARED CMENUPOS cmenuXY[]
	SHARED MemDataSet ImageDataSet[]
	SHARED cmenu


	IF menuslot=-1 THEN RETURN
	FOR menu=menuslot TO UBOUND(cmenuXY[])

			IF cmenuXY[menu].active=2 THEN

						cmenuXY[menu].active=1
						cmenuXY[menu].lastI=-1
						slot=uDisplayGetSlot (#grid,1)
						buff=ImageDataSet[slot].imagebuffer
						XgrDrawImage (#grid,buff, cmenuXY[menu].x,cmenuXY[menu].y, cmenuXY[menu].dx,cmenuXY[menu].dy, cmenuXY[menu].x,cmenuXY[menu].y)

						IF cmenuXY[menu].dx>((ImageDataSet[slot].WinW-ImageDataSet[slot].rightM)+5) THEN ' area overlapped into vscroll
									XgrSendMessage (#grid,#Redraw,0,0,0,0,1,0) ' and any other kid grids
						END IF

						FOR item=0 TO cMenuGetMaxItems (menu)
									IF cmenu[menu,item].status<>$$CM_ST_Shade THEN cmenu[menu,item].status=$$CM_ST_Disable
						NEXT item

			END IF

	NEXT menu

	IFZ menuslot THEN cmenu=0


END FUNCTION
'
'
' ##########################
' #####  cMenuDraw ()  #####
' ##########################

FUNCTION  cMenuDraw (menuslot,x,y,selectrow)
	SHARED MemDataSet ImageDataSet[]
	SHARED CMENUPOS cmenuXY[]
	SHARED CMENUITEM cmenu[]
	SHARED T_Index,cTimer


'	PRINT menuslot,x,y,selectrow

	IF x=-1 THEN x=cmenuXY[menuslot].x
	IF y=-1 THEN y=cmenuXY[menuslot].y

	g=#buff
	font=cmenuXY[menuslot].font
	XgrSetGridFont (g,font)
	XgrGetFontMetrics (font, @maxCharWidth, maxCharHeight, ascent, DECent, @gap, flags)

	len=0
	FOR i=0 TO cMenuGetMaxItems (menuslot)
			IF cmenu[menuslot,i].nameLen>len THEN len=cmenu[menuslot,i].nameLen
	NEXT i

	w=((len+2)*(maxCharWidth))+4
	h=#size*(cMenuGetMaxItems (menuslot)-1)+10
	IF (cmenuXY[menuslot].ctype AND $$CM_CT_Select) THEN w=w+15

	slot=uDisplayGetSlot (#grid,1)
	hh=ImageDataSet[slot].WinH-4
	IF (y+h) > hh THEN y=y-((y+h)-hh)

	XgrDrawImage (g,#grid,x,y,w+x,h+y,0,0)
	cy=1


	FOR pos = 0 TO cMenuGetMaxItems (menuslot)
		IF cmenu[menuslot,pos].active THEN

			IF ((pos=selectrow) AND (cmenu[menuslot,pos].status<>$$CM_ST_Disable)) THEN
					co=#cHightlightBaseColour
					cColour=#cHightlightColour
			ELSE
					cColour=#cTextColour
					co=cmenuXY[menuslot].basecolour
			END IF

			SELECT CASE cmenu[menuslot,pos].type
				CASE $$CM_TY_Default		: XgrFillBox  (g, co, 2, cy, w-2, cy+#size)
																	XgrDrawLine (g, #cBorderColour2,1,cy,1,cy+#size)
																	XgrDrawLine (g, #cBorderColour2,w-1,cy,w-1,cy+#size)
																	cMenuSetItemPosition (menuslot,pos,x+2, y+cy, x+w-2, y+cy+#size)
																	IF cmenu[menuslot,pos].status=$$CM_ST_Shade THEN
																				cColour=0x44444400
																	ELSE
																				cmenu[menuslot,pos].status=$$CM_ST_Enable
																	END IF

																	IF (cmenuXY[menuslot].ctype AND $$CM_CT_Select) THEN
																			IF pos=cmenuXY[menuslot].iselect THEN
																					XgrFillTriangle (g, cColour, $$LineStyleSolid, $$TriangleRight, 7, cy+4, 13, cy+#size-4)
																			END IF
																			tx=20
																	ELSE
																			tx=6
																	END IF
																	text$=CSTRING$(cMenuGetItem (menuslot,pos))
																	XgrMoveTo		(g, tx, cy+2)
																	XgrDrawText (g, cColour, text$)
																	IF cMenuGetSubMenu (menuslot,pos,sub)<>-1 THEN XgrFillTriangle (g, cColour, $$LineStyleSolid, $$TriangleRight, w-8, cy+4, w-5, cy+#size-4)

				CASE $$CM_TY_HSepB			:	y2=cy+(cmenu[menuslot,pos].pixelH*0.5)
																	XgrDrawLine	(g, #cBorderColour2, 1, cy,4, cy+3)
																	XgrDrawLine	(g, #cBorderColour2, 4, cy+3,1,cy+6)
																	XgrDrawLine	(g, #cBorderColour2, w-1, cy,w-4, cy+3)
																	XgrDrawLine	(g, #cBorderColour2, w-4, cy+3,w-1,cy+6)
																	XgrDrawLine	(g, #cMenuSepBar1, 5, y2,w-5, y2)
				CASE $$CM_TY_HSepC			: XgrDrawLine	(g, #cBorderColour2, 1, cy,4, cy+3)
																	XgrDrawLine	(g, #cBorderColour2, w-1, cy,w-4, cy+3)
																	XgrDrawLine	(g, co, 3, cy+1,w-3, cy+1)
																	XgrDrawLine	(g, co, 4, cy+2,w-4, cy+2)
																	cen=20 '(w*0.5)
																	XgrDrawLine	(g, #cBorderColour2, 4, cy+3,cen-8, cy+3)
																	XgrDrawLine	(g, #cBorderColour2, cen+8, cy+3,w-4, cy+3)
																	XgrDrawLine	(g, #cBorderColour2, cen-8, cy+3,cen-5, cy+6)
																	XgrDrawLine	(g, #cBorderColour2, cen+8, cy+3,cen+5, cy+6)
																	XgrDrawLine	(g, #cBorderColour2, cen-5, cy+6,cen-8, cy+9)
																	XgrDrawLine	(g, #cBorderColour2, cen+5, cy+6,cen+8, cy+9)
																	XgrDrawLine	(g, #cBorderColour2, 4, cy+9,cen-8, cy+9)
																	XgrDrawLine	(g, #cBorderColour2, cen+8, cy+9,w-4, cy+9)
																	XgrDrawLine	(g, #cBorderColour2, 4, cy+9,1, cy+12)
																	XgrDrawLine	(g, #cBorderColour2, w-4, cy+9,w-1, cy+12)
																	XgrDrawLine	(g, co, 4, cy+10,w-4, cy+10)
																	XgrDrawLine	(g, co, 3, cy+11,w-3, cy+11)
																	XgrDrawLine	(g, co, cen-7, cy+3,cen+7, cy+3)
																	XgrDrawLine	(g, co, cen-6, cy+4,cen+6, cy+4)
																	XgrDrawLine	(g, co, cen-5, cy+5,cen+5, cy+5)
																	XgrDrawLine	(g, co, cen-4, cy+6,cen+4, cy+6)
																	XgrDrawLine	(g, co, cen-7, cy+9,cen+7, cy+9)
																	XgrDrawLine	(g, co, cen-6, cy+8,cen+6, cy+8)
																	XgrDrawLine	(g, co, cen-5, cy+7,cen+5, cy+7)
				CASE $$CM_TY_HSepD			: XgrDrawLine	(g, #cBorderColour2, 1, cy,4, cy+3)
																	XgrDrawLine	(g, #cBorderColour2, w-1, cy,w-4, cy+3)
																	XgrDrawLine	(g, co, 3, cy+1,w-3, cy+1)
																	XgrDrawLine	(g, co, 4, cy+2,w-4, cy+2)
																	cen=w-20 '(w*0.5)
																	XgrDrawLine	(g, #cBorderColour2, 4, cy+3,cen-8, cy+3)
																	XgrDrawLine	(g, #cBorderColour2, cen+8, cy+3,w-4, cy+3)
																	XgrDrawLine	(g, #cBorderColour2, cen-8, cy+3,cen-5, cy+6)
																	XgrDrawLine	(g, #cBorderColour2, cen+8, cy+3,cen+5, cy+6)
																	XgrDrawLine	(g, #cBorderColour2, cen-5, cy+6,cen-8, cy+9)
																	XgrDrawLine	(g, #cBorderColour2, cen+5, cy+6,cen+8, cy+9)
																	XgrDrawLine	(g, #cBorderColour2, 4, cy+9,cen-8, cy+9)
																	XgrDrawLine	(g, #cBorderColour2, cen+8, cy+9,w-4, cy+9)
																	XgrDrawLine	(g, #cBorderColour2, 4, cy+9,1, cy+12)
																	XgrDrawLine	(g, #cBorderColour2, w-4, cy+9,w-1, cy+12)
																	XgrDrawLine	(g, co, 4, cy+10,w-4, cy+10)
																	XgrDrawLine	(g, co, 3, cy+11,w-3, cy+11)
																	XgrDrawLine	(g, co, cen-7, cy+3,cen+7, cy+3)
																	XgrDrawLine	(g, co, cen-6, cy+4,cen+6, cy+4)
																	XgrDrawLine	(g, co, cen-5, cy+5,cen+5, cy+5)
																	XgrDrawLine	(g, co, cen-4, cy+6,cen+4, cy+6)
																	XgrDrawLine	(g, co, cen-7, cy+9,cen+7, cy+9)
																	XgrDrawLine	(g, co, cen-6, cy+8,cen+6, cy+8)
																	XgrDrawLine	(g, co, cen-5, cy+7,cen+5, cy+7)
				CASE $$CM_TY_HSepE			: gap=3
																	XgrDrawLine	(g, #cBorderColour2, 1, cy,4, cy+3)
																	XgrDrawLine	(g, #cBorderColour2, w-1, cy,w-4, cy+3)
																	XgrDrawLine	(g, #cBorderColour2, 4, cy+3,w-4, cy+3)
																	XgrDrawLine	(g, co, 3, cy+1,w-3, cy+1)
																	XgrDrawLine	(g, co, 4, cy+2,w-4, cy+2)
																	XgrDrawLine	(g, #cBorderColour2, 4, cy+4+gap,1, cy+7+gap)
																	XgrDrawLine	(g, #cBorderColour2, w-4, cy+4+gap,w-1, cy+7+gap)
																	XgrDrawLine	(g, #cBorderColour2, 4, cy+4+gap,w-4, cy+4+gap)
																	XgrDrawLine	(g, co, 4, cy+5+gap,w-4, cy+5+gap)
																	XgrDrawLine	(g, co, 3, cy+6+gap,w-3, cy+6+gap)
																	cy=cy+gap
				CASE $$CM_TY_HSepA			:	y2=cy+(cmenu[menuslot,pos].pixelH*0.5)
																	XgrDrawLine	(g, co, 2, cy+1,w-2, cy+1)
																	XgrDrawLine	(g, co, 4, cy+2,w-4, cy+2)
																	XgrDrawLine	(g, co, 4, cy+4,w-4, cy+4)
																	XgrDrawLine	(g, co, 2, cy+5,w-2, cy+5)
																	XgrDrawLine	(g, #cBorderColour2, 1, cy,4, cy+3)
																	XgrDrawLine	(g, #cBorderColour2, 4, cy+3,1,cy+6)
																	XgrDrawLine	(g, #cBorderColour2, w-1, cy,w-4, cy+3)
																	XgrDrawLine	(g, #cBorderColour2, w-4, cy+3,w-1,cy+6)
																	XgrDrawLine	(g, #cBorderColour2, 5, y2,w-5, y2) '#cMenuSepBar1
				CASE $$CM_TY_TopBrA			:	XgrDrawLine	(g, #cBorderColour2, 1, 1,w-1, 1)
				CASE $$CM_TY_TopBrB			:	XgrDrawLine	(g, #cBorderColour2, 4, cy,1,cy+3)
																	XgrDrawLine	(g, #cBorderColour2, w-4, cy,w-1,cy+3)
																	XgrDrawLine	(g, #cBorderColour2, 5, cy,w-5, cy)
																	XgrDrawLine	(g, co, 4, cy+1,w-4, cy+1)
																	XgrDrawLine	(g, co, 3, cy+2,w-3, cy+2)
																	XgrDrawLine	(g, co, 2, cy+3,w-2, cy+3)
				CASE $$CM_TY_TopBrC			:	XgrDrawLine	(g, #cBorderColour2, 1, cy,w-1,cy)
				CASE $$CM_TY_BottomBrA	:	XgrDrawLine	(g, #cBorderColour2, 1, cy,w-1, cy)
				CASE $$CM_TY_BottomBrB	:	XgrDrawLine	(g, #cBorderColour2, w-1, cy,w-4, cy+3)
																	XgrDrawLine	(g, #cBorderColour2, 1, cy,4, cy+3)
																	XgrDrawLine	(g, #cBorderColour2, 5, cy+3,w-5, cy+3)
																	XgrDrawLine	(g, co, 4, cy+2,w-4, cy+2)
																	XgrDrawLine	(g, co, 3, cy+1,w-3, cy+1)
'																	XgrDrawLine	(g, co, 2, cy,w-2, cy)
				CASE $$CM_TY_BottomBrC	:	XgrDrawLine	(g, #cBorderColour2, 1, cy,w-1, cy)
			END SELECT

			IF cmenu[menuslot,pos].pixelH=-1 THEN
						cy=cy+#size
			ELSE
						cy=cy+cmenu[menuslot,pos].pixelH
			END IF
		END IF
	NEXT pos

	h=cy
	XgrDrawImage (#grid,g,0,0,w,h,x,y)
	cmenuXY[menuslot].x=x
	cmenuXY[menuslot].y=y
	cmenuXY[menuslot].dx=(x+w)
	cmenuXY[menuslot].dy=(y+h)
	cmenuXY[menuslot].active=2
	cmenuXY[menuslot].lastI=selectrow

'	XstKillTimer (cTimer)			' clear the menu if no selection is made (3secs)
'	XstStartTimer (@cTimer ,1 ,5000,&tWakeUp ())
'	T_Index=cTimer


END FUNCTION
'
'
' ###########################
' #####  cMenuGetID ()  #####
' ###########################
'
FUNCTION  cMenuGetID (menu,item,id)
	SHARED CMENUITEM cmenu[]


	id=cmenu[menu,item].callbackID
	RETURN id



END FUNCTION
'
'
' ##############################
' #####  cMenuisInMenu ()  #####
' ##############################
'
FUNCTION  cMenuisInMenu (menuslot,x,y)
	SHARED CMENUPOS cmenuXY[]

'PRINT x,y
'PRINT cmenuXY[menuslot].x,cmenuXY[menuslot].y,cmenuXY[menuslot].dx,cmenuXY[menuslot].dy

	IF menuslot=-1 THEN RETURN

	IF ((x < (cmenuXY[menuslot].dx-2) ) AND (y < (cmenuXY[menuslot].dy-3) ))	AND (( x > (cmenuXY[menuslot].x+2)) AND (y > ((cmenuXY[menuslot].y+3)) )) THEN
			RETURN 1
	ELSE
			RETURN 0
	END IF


END FUNCTION
'
'
' ##############################
' #####  cMenuisInItem ()  #####
' ##############################
'
FUNCTION  cMenuisInItem (menuslot,item,x,y)
	SHARED CMENUITEM cmenu[]
	SHARED CMENUPOS cmenuXY[]


	IF ((x < cmenu[menuslot,item].dx ) AND (y < cmenu[menuslot,item].dy ))	AND (( x > cmenu[menuslot,item].x) AND (y > (cmenu[menuslot,item].y) )) THEN
			RETURN 1
	ELSE
			RETURN 0
	END IF


END FUNCTION
'
'
' #################################
' #####  cMenuSelectionCB ()  #####
' #################################
'
FUNCTION  cMenuSelectionCB (menu,item,id)


PRINT id

	SELECT CASE id
		CASE $$CM_ID_QLoad							:DisplayWindow (#FileListWindow)
		CASE $$CM_ID_OFileNext					:ReadLastFile ()
		CASE $$CM_ID_OFileLast					:ReadNextFile ()
		CASE $$CM_ID_SaveAs							:SaveFileAs (0)
		CASE $$CM_ID_Quit								:IF PopUpBoxB ("Are you sure?","Quit", $$MB_ICONQUESTION | $$MB_YESNO)=6 THEN Quit()
		CASE $$CM_ID_ExpThisImage				:ExportFileAs (0)
		CASE $$CM_ID_ExpAllTrks					:ExportFileAs (1)
		CASE $$CM_ID_ExpAllTrksScaled		:ExportFileAs (2)
		CASE $$CM_ID_OFileNewSlot				:slot=CreateDataSlot (0,0): SelectFileMenu (1,slot)
		CASE $$CM_ID_OFileInSlot_1			:SelectFileMenu (1,0)
		CASE $$CM_ID_OFileInSlot_2			:SelectFileMenu (1,1)
		CASE $$CM_ID_OFileInSlot_3			:SelectFileMenu (1,2)
		CASE $$CM_ID_OFileInSlot_4			:SelectFileMenu (1,3)
		CASE $$CM_ID_OFileInSlot_5			:SelectFileMenu (1,4)
		CASE $$CM_ID_OFileInSlot_6			:SelectFileMenu (1,5)
		CASE $$CM_ID_OFileInSlot_7			:SelectFileMenu (1,6)
		CASE $$CM_ID_DMode_Track				:
		CASE $$CM_ID_DMode_ImageA				:
		CASE $$CM_ID_DMode_ImageB				:
		CASE $$CM_ID_DMode_ImageC				:
		CASE $$CM_ID_Zoom_1							:
		CASE $$CM_ID_Zoom_2							:
		CASE $$CM_ID_Zoom_3							:
		CASE $$CM_ID_Zoom_4							:
		CASE $$CM_ID_Zoom_5							:
		CASE $$CM_ID_Zoom_6							:
		CASE $$CM_ID_Zoom_7							:
		CASE $$CM_ID_Zoom_8							:
		CASE $$CM_ID_Zoom_9							:
		CASE $$CM_ID_Zoom_10						:
		CASE $$CM_ID_Zoom_20						:
		CASE $$CM_ID_Zoom_50						:
		CASE $$CM_ID_MCur_CrossH				:
		CASE $$CM_ID_MCur_Cad						:
		CASE $$CM_ID_MCur_SWar					:
		CASE $$CM_ID_MCur_Vertical			:
		CASE $$CM_ID_PCur_CrossH				:
		CASE $$CM_ID_PCur_Cad						:
		CASE $$CM_ID_PCur_SWar					:
		CASE $$CM_ID_PCur_Vertical			:
		CASE $$CM_ID_WinMax							:
		CASE $$CM_ID_WinMin							:
		CASE $$CM_ID_WinLast						:
		CASE $$CM_ID_WinIcon						:
		CASE $$CM_ID_Scale_X						:
		CASE $$CM_ID_Scale_Y						:
		CASE $$CM_ID_Scale_All					:
		CASE $$CM_ID_Scale_Reset				:
		CASE $$CM_ID_Scale_Auto					:
		CASE $$CM_ID_SMode_MinMax				:cMenuSetItemSelected  (menu,item)
		CASE $$CM_ID_SMode_Min65				:cMenuSetItemSelected  (menu,item)
		CASE $$CM_ID_SMode_065					:cMenuSetItemSelected  (menu,item)
		CASE $$CM_ID_SMode_0Max					:cMenuSetItemSelected  (menu,item)
		CASE $$CM_ID_SMode_Image				:cMenuSetItemSelected  (menu,item)
		CASE $$CM_ID_SMode_Custom				:cMenuSetItemSelected  (menu,item)
		CASE $$CM_ID_SMode_SetCustom		:
		CASE $$CM_ID_ToolBar						:
		CASE $$CM_ID_Blem								:
		CASE $$CM_ID_TrackCur						:
		CASE $$CM_ID_Benchmark					:
		CASE $$CM_ID_VHeader						:
		CASE $$CM_ID_Help								:
		CASE $$CM_ID_About							:DisplayWindow (#AboutWindow)
		CASE $$CM_ID_MSelSlot						:
		CASE $$CM_ID_MDelSlot						:
		CASE $$CM_ID_SelSlot						:
		CASE $$CM_ID_DelSlot						:
	END SELECT




END FUNCTION
'
'
' ###############################
' #####  cMenuClearSubs ()  #####
' ###############################
'
FUNCTION  cMenuClearSubs (menuslot,item)
	SHARED CMENUITEM cmenu[]
	SHARED CMENUPOS cmenuXY[]


	IF menuslot=-1 THEN RETURN
	IF item=-1 THEN RETURN

	cMenuGetSubMenu (menuslot,item,@sub)

	IF sub=-1 THEN RETURN
	IF cmenuXY[menuslot].active=1 THEN RETURN
	IF cmenuXY[sub].active=1 THEN RETURN

	menu=sub
	GOSUB Clear

	FOR item=0 TO cMenuGetMaxItems (sub)

				IF cMenuGetSubMenu (sub,item,@subb)<>-1 THEN
							'IF cmenuXY[subb].active=2 THEN
								cMenuClearSubs (sub,item)
				END IF

	NEXT item


RETURN

'##########
SUB Clear
'##########

	IF menu=-1 THEN EXIT SUB

	cmenuXY[menu].active=1
	buff=uDisplayGetBuffer (#grid,1)
	XgrDrawImage (#grid,buff, cmenuXY[menu].x,cmenuXY[menu].y, cmenuXY[menu].dx,cmenuXY[menu].dy, cmenuXY[menu].x,cmenuXY[menu].y)

	FOR itemb=0 TO cMenuGetMaxItems (menu)
				IF cmenu[menu,itemb].status<>$$CM_ST_Delete THEN cmenu[menu,itemb].status=$$CM_ST_Disable
	NEXT itemb


END SUB

END FUNCTION
'
'
' #####################################
' #####  cMenuSetItemNoSelect ()  #####
' #####################################
'
FUNCTION  cMenuSetItemNoSelect (menu,item)
	SHARED CMENUITEM cmenu[]


	cmenu[menu,item].status=$$CM_ST_Shade


END FUNCTION
'
'
' #################################
' #####  cMenuDisableItem ()  #####
' #################################
'
FUNCTION  cMenuDisableItem (menuslot,item)
	SHARED CMENUITEM cmenu[]


	status=cmenu[menuslot,item].active
	cmenu[menuslot,item].active=0

	RETURN status


END FUNCTION
'
'
' ################################
' #####  cMenuEnableItem ()  #####
' ################################
'
FUNCTION  cMenuEnableItem (menuslot,item)
	SHARED CMENUITEM cmenu[]


	status=cmenu[menuslot,item].active
	cmenu[menuslot,item].active=1

	RETURN status


END FUNCTION
'
'
' #####################################
' #####  cMenuSetItemSelected ()  #####
' #####################################
'
FUNCTION  cMenuSetItemSelected (menuslot,item)
	SHARED CMENUPOS cmenuXY[]
	SHARED CMENUITEM cmenu[]


	oldi=cmenuXY[menuslot].iselect
	cmenuXY[menuslot].iselect=item

	RETURN oldi



END FUNCTION
END PROGRAM
