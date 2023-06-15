:: Author:      khadron@163.com
:: Description: Chrome浏览器修复工具
@echo off
setlocal enabledelayedexpansion
title "Chrome fix tool"
rem ---以系统超级管理员身份运行---
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
goto UACPrompt
) else ( goto gotAdmin )
:UACPrompt
echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
"%temp%\getadmin.vbs"
exit /B
:gotAdmin
if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )
pushd "%CD%"
cd /d "%~dp0"
rem ----------------------------
chcp 65001
echo 正在修复浏览器快捷方式....
set "args=--args --js-flags=""""--expose-gc"""""
set "shortcut=%USERPROFILE%\Desktop\Google Chrome.lnk"
set lnkfile="C:\Users\Public\Desktop\Google Chrome.lnk"
if not exist %lnkfile% ( set lnkfile="%USERPROFILE%\Desktop\Google Chrome.lnk" )
>"%TMP%\t.t" echo;WSH.echo CreateObject("WScript.Shell").CreateShortcut(WSH.Arguments(0)).targetpath
for /f "delims=" %%i in ('cscript -nologo -e:vbscript "%TMP%\t.t" ""%lnkfile%""') do set exepath=%%i
del /f /q %lnkfile%
mshta VBScript:Execute("Set Shell=CreateObject(""WScript.Shell""):Set Link=Shell.CreateShortcut(""%shortcut%""):Link.TargetPath=""!exepath!"":Link.Arguments=""%args%"":Link.Save:close")
echo 修复完成
echo 正在修复hosts文件....
del /f /q "%~dp0\hosts"
copy "C:\Windows\system32\drivers\etc\hosts" "%~dp0\hosts" /y
echo. >> "%~dp0\hosts"
echo 127.0.0.1 content-autofill.googleapis.com >> "%~dp0\hosts"
copy "%~dp0\hosts" "C:\Windows\system32\drivers\etc\hosts" /y
ipconfig /flushdns
echo 修复完成
echo 请重启浏览器再试 
pause
exit
