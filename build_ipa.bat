@echo off
REM ==============================================================================
REM  YABAOCHEAT (FFXC Private Edition) - Windows Packaging Script
REM ==============================================================================
echo === Packaging YABAOCHEAT into IPA ===

set OUTPUT_DIR=BuildOutput
set PAYLOAD_DIR=%OUTPUT_DIR%\Payload\YABAOCHEAT.app

if exist %OUTPUT_DIR% rd /s /q %OUTPUT_DIR%
mkdir "%PAYLOAD_DIR%"

echo Copying Resources and Assets...
copy Resources\Info.plist "%PAYLOAD_DIR%\Info.plist" >nul
copy Resources\Assembly-CSharp-patch.bytes "%PAYLOAD_DIR%\" >nul
copy Resources\AppIcons\*.png "%PAYLOAD_DIR%\" >nul
if exist Resources\YABAOCHEAT copy Resources\YABAOCHEAT "%PAYLOAD_DIR%\" >nul

echo Compressing Payload into IPA...
powershell -Command "Compress-Archive -Path '%OUTPUT_DIR%\Payload' -DestinationPath 'YABAOCHEAT_rebuilt.zip' -Force"
if exist YABAOCHEAT_rebuilt.ipa del /f /q YABAOCHEAT_rebuilt.ipa
ren YABAOCHEAT_rebuilt.zip YABAOCHEAT_rebuilt.ipa

echo.
echo ==============================================================================
echo [+] SUCCESS: YABAOCHEAT_rebuilt.ipa generated successfully!
echo ==============================================================================

