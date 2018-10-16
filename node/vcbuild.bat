@echo off

set arch=%1
set mode=%2
set workspaceFolder=%3
set targetName=%4
set nodeVersion=%5

set libName=
if "%nodeVersion%"=="" (
    for /f "delims=" %%t in ('node -v') do set nodeVersion=%%t
    set nodeHeaderDir=%HOME%\.node-gyp\%nodeVersion:~1,8%
    set libName=node.lib
) else (
    set nodeHeaderDir=%HOME%\.node-gyp\%nodeVersion%
    echo %nodeVersion% | findstr "^iojs" && set libName=iojs.lib || set libName=node.lib
)

set compilerFlags=
set linkFlags=
set buildDir=build\%mode%
set files=

set includeDir=/I"%nodeHeaderDir%\include\node" /I"%nodeHeaderDir%\src" /I"%nodeHeaderDir%\deps\openssl\config" /I"%nodeHeaderDir%\deps\openssl\openssl\include" /I"%nodeHeaderDir%\deps\uv\include" /I"%nodeHeaderDir%\deps\zlib" /I"%nodeHeaderDir%\deps\v8\include"

set preDefine=/D "NODE_GYP_MODULE_NAME=%targetName%" /D "USING_UV_SHARED=1" /D "USING_V8_SHARED=1" /D "V8_DEPRECATION_WARNINGS=1" /D "WIN32" /D "_CRT_SECURE_NO_DEPRECATE" /D "_CRT_NONSTDC_NO_DEPRECATE" /D "_HAS_EXCEPTIONS=0" /D "BUILDING_NODE_EXTENSION" /D "_WINDLL"

set linkLib="kernel32.lib" "user32.lib" "gdi32.lib" "winspool.lib" "comdlg32.lib" "advapi32.lib" "shell32.lib" "ole32.lib" "oleaut32.lib" "uuid.lib" "odbc32.lib" "DelayImp.lib" "%nodeHeaderDir%\%arch%\%libName%"

set releaseCompilerFlags=/GS /GL /W3 /wd"4267" /wd"4351" /wd"4355" /wd"4800" /wd"4251" /Gy /Zc:wchar_t %includeDir% /Zi /Gm- /Ox /Ob2 /Fd"%buildDir%\obj\%targetName%\vc141.pdb" /Zc:inline /fp:precise %preDefine% /errorReport:prompt /GF /WX- /Zc:forScope /GR- /Gd /Oy /Oi /MT /FC /Fa"%buildDir%\obj\%targetName%/" /nologo /Fo"%buildDir%\obj\%targetName%/" /Ot /Fp"%buildDir%\obj\%targetName%\%targetName%.pch" /diagnostics:classic /MP

set debugCompilerFlags=/GS /W3 /wd"4267" /wd"4351" /wd"4355" /wd"4800" /wd"4251" /Zc:wchar_t %includeDir% /Zi /Gm- /Od /Fd"%buildDir%\obj\%targetName%\vc141.pdb" /Zc:inline /fp:precise %preDefine% /D "DEBUG" /D "_DEBUG" /D "V8_ENABLE_CHECKS" /errorReport:prompt /GF /WX- /Zc:forScope /RTC1 /Gd /Oy- /MTd /FC /Fa"%buildDir%\obj\%targetName%/" /nologo /Fo"%buildDir%\obj\%targetName%/" /Fp"%buildDir%\obj\%targetName%\%targetName%.pch" /diagnostics:classic /bigobj /MP

set debugLinkFlags=/OUT:"%workspaceFolder%\%buildDir%\%targetName%.node" /MANIFEST /NXCOMPAT /PDB:"%workspaceFolder%\%buildDir%\%targetName%.pdb" /DYNAMICBASE /MAPINFO:EXPORTS %linkLib% /DEBUG /DLL /INCREMENTAL /MANIFESTUAC:"level='asInvoker' uiAccess='false'" /ManifestFile:"%buildDir%\obj\%targetName%\%targetName%.node.intermediate.manifest" /MAP /ERRORREPORT:PROMPT /NOLOGO /DELAYLOAD:"iojs.exe" /DELAYLOAD:"node.exe" /TLBID:1 /ignore:4199

set releaseLinkFlags=/OUT:"%workspaceFolder%\%buildDir%\%targetName%.node" /MANIFEST /LTCG /NXCOMPAT /PDB:"%workspaceFolder%\%buildDir%\%targetName%.pdb" /DYNAMICBASE /MAPINFO:EXPORTS %linkLib% /DEBUG /DLL /OPT:REF /INCREMENTAL:NO /MANIFESTUAC:"level='asInvoker' uiAccess='false'" /ManifestFile:"%buildDir%\obj\%targetName%\%targetName%.node.intermediate.manifest" /MAP /OPT:ICF /ERRORREPORT:PROMPT /NOLOGO /DELAYLOAD:"iojs.exe" /DELAYLOAD:"node.exe" /TLBID:1 /ignore:4199


if /i "%arch%"=="x64" (
    call "%VS_ROOT%\2017\Community\VC\Auxiliary\Build\vcvars64.bat"
    if /i "%mode%"=="Debug" goto debug-x64
    if /i "%mode%"=="Release" goto release-x64
)

if /i "%arch%"=="ia32" (
    call "%VS_ROOT%\2017\Community\VC\Auxiliary\Build\vcvars32.bat"
    if /i "%mode%"=="Debug" goto debug-x86
    if /i "%mode%"=="Release" goto release-x86
)

:debug-x64
set compilerFlags=%debugCompilerFlags%
set linkFlags=%debugLinkFlags% /MACHINE:X64
goto var-done

:debug-x86
set compilerFlags=%debugCompilerFlags% /analyze-
set linkFlags=%debugLinkFlags% /MACHINE:X86 /SAFESEH
goto var-done

:release-x64
set compilerFlags=%releaseCompilerFlags%
set linkFlags=%releaseLinkFlags% /MACHINE:X64
goto var-done

:release-x86
set compilerFlags=%releaseCompilerFlags% /analyze-
set linkFlags=%releaseLinkFlags% /MACHINE:X86 /SAFESEH
goto var-done

:var-done
goto next-arg

:next-arg
if /i "%6"=="" (
    goto args-done
) else (
    set files=%6 %files%
    goto arg-ok
)

:arg-ok
shift
goto next-arg

:args-done
rem if exist %buildDir% rd /S /Q %buildDir%
if not exist %buildDir%\obj\%targetName% mkdir %buildDir%\obj\%targetName%
echo %buildDir%
echo cl %compilerFlags% %files% /link %linkFlags%
echo=
cl %compilerFlags% %files% /link %linkFlags%
