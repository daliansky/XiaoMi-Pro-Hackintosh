echo -off

if exist fs2:\FLASH.NSH then
fs2:
goto END
endif

if exist fs1:\FLASH.NSH then
fs1:
goto END
endif

if exist fs0:\FLASH.NSH then
fs0:
goto END
endif

:END
echo -on
