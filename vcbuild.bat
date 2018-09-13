@echo off

set arch=%1
set mode=%2
set workspaceFolder=%3
set workspaceRootFolderName=%4

set compilerFlags=
set linkFlags=
set buildDir=build
set files=

if /i "%arch%"=="x64" (
    call "%VS_ROOT%\2017\Community\VC\Auxiliary\Build\vcvars64.bat"
    if /i "%mode%"=="Debug" goto debug-x64
    if /i "%mode%"=="Release" goto release-x64
)

if /i "%arch%"=="x86" (
    call "%VS_ROOT%\2017\Community\VC\Auxiliary\Build\vcvars32.bat"
    if /i "%mode%"=="Debug" goto debug-x86
    if /i "%mode%"=="Release" goto release-x86
)

:debug-x64
set buildDir=%buildDir%\%arch%\%mode%
set compilerFlags=/JMC /permissive- /GS /W3 /Zc:wchar_t /ZI /Gm- /Od /sdl /Fd"%buildDir%\vc141.pdb" /Zc:inline /fp:precise /D "_MBCS" /errorReport:prompt /WX- /Zc:forScope /RTC1 /Gd /MDd /FC /Fa"%buildDir%/" /EHsc /nologo /Fo"%buildDir%/" /Fp"%buildDir%\%workspaceRootFolderName%.pch" /diagnostics:classic
set linkFlags=/OUT:"%workspaceFolder%\%buildDir%\%workspaceRootFolderName%.exe" /MANIFEST /NXCOMPAT /PDB:"%workspaceFolder%\%buildDir%\%workspaceRootFolderName%.pdb" /DYNAMICBASE "kernel32.lib" "user32.lib" "gdi32.lib" "winspool.lib" "comdlg32.lib" "advapi32.lib" "shell32.lib" "ole32.lib" "oleaut32.lib" "uuid.lib" "odbc32.lib" "odbccp32.lib" /DEBUG:FASTLINK /MACHINE:X64 /INCREMENTAL /MANIFESTUAC:"level='asInvoker' uiAccess='false'" /ManifestFile:"%buildDir%\%workspaceRootFolderName%.exe.intermediate.manifest" /ERRORREPORT:PROMPT /NOLOGO /TLBID:1
goto var-done

:release-x64
set buildDir=%buildDir%\%arch%\%mode%
set compilerFlags=/permissive- /GS /GL /W3 /Gy /Zc:wchar_t /Zi /Gm- /O2 /sdl /Fd"%buildDir%\vc141.pdb" /Zc:inline /fp:precise /D "_MBCS" /errorReport:prompt /WX- /Zc:forScope /Gd /Oi /MT /FC /Fa"%buildDir%/" /EHsc /nologo /Fo"%buildDir%/" /Fp"%buildDir%\%workspaceRootFolderName%.pch" /diagnostics:classic 
set linkFlags=/OUT:"%workspaceFolder%\%buildDir%\%workspaceRootFolderName%.exe" /MANIFEST /LTCG:incremental /NXCOMPAT /PDB:"%workspaceFolder%\%buildDir%\%workspaceRootFolderName%.pdb" /DYNAMICBASE "kernel32.lib" "user32.lib" "gdi32.lib" "winspool.lib" "comdlg32.lib" "advapi32.lib" "shell32.lib" "ole32.lib" "oleaut32.lib" "uuid.lib" "odbc32.lib" "odbccp32.lib" /DEBUG:FULL /MACHINE:X64 /OPT:REF /MANIFESTUAC:"level='asInvoker' uiAccess='false'" /ManifestFile:"%buildDir%\%workspaceRootFolderName%.exe.intermediate.manifest" /OPT:ICF /ERRORREPORT:PROMPT /NOLOGO /TLBID:1
goto var-done

:debug-x86
set buildDir=%buildDir%\%arch%\%mode%
set compilerFlags=/JMC /permissive- /GS /analyze- /W3 /Zc:wchar_t /ZI /Gm- /Od /sdl /Fd"%buildDir%\vc141.pdb" /Zc:inline /fp:precise /D "_MBCS" /errorReport:prompt /WX- /Zc:forScope /RTC1 /Gd /Oy- /MDd /FC /Fa"%buildDir%/" /EHsc /nologo /Fo"%buildDir%/" /Fp"%buildDir%\%workspaceRootFolderName%.pch" /diagnostics:classic
set linkFlags=/OUT:"%workspaceFolder%\%buildDir%\%workspaceRootFolderName%.exe" /MANIFEST /NXCOMPAT /PDB:"%workspaceFolder%\%buildDir%\%workspaceRootFolderName%.pdb" /DYNAMICBASE "kernel32.lib" "user32.lib" "gdi32.lib" "winspool.lib" "comdlg32.lib" "advapi32.lib" "shell32.lib" "ole32.lib" "oleaut32.lib" "uuid.lib" "odbc32.lib" "odbccp32.lib" /DEBUG:FASTLINK /MACHINE:X86 /INCREMENTAL /MANIFESTUAC:"level='asInvoker' uiAccess='false'" /ManifestFile:"%buildDir%\%workspaceRootFolderName%.exe.intermediate.manifest" /ERRORREPORT:PROMPT /NOLOGO /TLBID:1
goto var-done

:release-x86
set buildDir=%buildDir%\%arch%\%mode%
set compilerFlags=/permissive- /GS /GL /analyze- /W3 /Gy /Zc:wchar_t /Zi /Gm- /O2 /sdl /Fd"%buildDir%\vc141.pdb" /Zc:inline /fp:precise /D "_MBCS" /errorReport:prompt /WX- /Zc:forScope /Gd /Oy- /Oi /MT /FC /Fa"%buildDir%/" /EHsc /nologo /Fo"%buildDir%/" /Fp"%buildDir%\%workspaceRootFolderName%.pch" /diagnostics:classic
set linkFlags=/OUT:"%workspaceFolder%\%buildDir%\%workspaceRootFolderName%.exe" /MANIFEST /LTCG:incremental /NXCOMPAT /PDB:"%workspaceFolder%\%buildDir%\%workspaceRootFolderName%.pdb" /DYNAMICBASE "kernel32.lib" "user32.lib" "gdi32.lib" "winspool.lib" "comdlg32.lib" "advapi32.lib" "shell32.lib" "ole32.lib" "oleaut32.lib" "uuid.lib" "odbc32.lib" "odbccp32.lib" /DEBUG:FULL /MACHINE:X86 /OPT:REF /SAFESEH  /MANIFESTUAC:"level='asInvoker' uiAccess='false'" /ManifestFile:"%buildDir%\%workspaceRootFolderName%.exe.intermediate.manifest" /OPT:ICF /ERRORREPORT:PROMPT /NOLOGO /TLBID:1
goto var-done

:var-done
if /i "%buildDir%"=="" (
    echo Error arguments.
    exit /b
) else (
    goto next-arg
)

:next-arg
if /i "%5"=="" (
    goto args-done
) else (
    set files=%5 %files%
    goto arg-ok
)

:arg-ok
shift
goto next-arg

:args-done
if not exist %buildDir% mkdir %buildDir%
echo %buildDir%
echo cl %compilerFlags% %files% /link %linkFlags%
echo=
cl %compilerFlags% %files% /link %linkFlags%
