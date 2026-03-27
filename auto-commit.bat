@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul

cd /d "%~dp0"

where git >nul 2>nul
if errorlevel 1 (
  echo [错误] 未找到 git，请先安装 Git 并加入 PATH。
  pause
  exit /b 1
)

echo.
set /p COMMIT_MSG=请输入提交信息: 
if "%COMMIT_MSG%"=="" (
  echo [取消] 提交信息不能为空。
  pause
  exit /b 1
)

echo.
echo [1/4] 正在添加变更...
git add -A
if errorlevel 1 (
  echo [错误] git add 失败。
  pause
  exit /b 1
)

echo [2/4] 检查是否有可提交内容...
git diff --cached --quiet
if "%errorlevel%"=="0" (
  echo [提示] 没有可提交的变更。
  pause
  exit /b 0
)

echo [3/4] 正在提交...
git commit -m "%COMMIT_MSG%"
if errorlevel 1 (
  echo [错误] git commit 失败（可能是钩子校验失败或无变更）。
  pause
  exit /b 1
)

echo [4/4] 正在推送到远程...
git push
if errorlevel 1 (
  echo [提示] 常规推送失败，尝试设置上游分支后再次推送...
  git push -u origin HEAD
  if errorlevel 1 (
    echo [错误] 推送失败，请检查远程仓库、网络或权限。
    pause
    exit /b 1
  )
)

echo.
echo [完成] 已成功提交并推送到远程仓库。
pause
exit /b 0
