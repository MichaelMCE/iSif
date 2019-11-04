REM This file is created automatically during installation of XBasic
REM DON'T MODIFY BY HAND!

REM XBDIR=E:\xb
REM GNUDIR=

SET XBDIR=E:\xb
SET PATH=E:\XB\bin;%PATH%;E:\xb\XBasic-Util\bin
SET LIB=E:\XB\lib;%LIB%
SET INCLUDE=E:\XB\include;%INCLUDE%

e:
cd xb\II

nmake -f ii.mak

 del ii.o
 del ii.s
 del ii.def
 del ii.RES
 del ii.rbj