#Requires AutoHotkey v2.0
#SingleInstance Force
Persistent

; =========================
; User settings
; =========================

UI_FONT_NAME := "Malgun Gothic"
UI_FONT_SIZE := 10

CODE_FONT_NAME := "goorm Sans Code 400"
CODE_FONT_SIZE := 10

HOTKEY_SHOW := "^!t" ; Ctrl + Alt + T
SKILL_NAME := "fix-error-bundle"
WINDOW_TITLE := "Codex 오류 수정 프롬프트 생성기"

; =========================
; Global state
; =========================

global Cases := []
global CurrentIndex := 1
global MainGui := ""
global FileEdit := ""
global CodeEdit := ""
global DiagnosticsEdit := ""
global StatusText := ""

Cases.Push(NewCase())

; =========================
; Tray
; =========================

A_TrayMenu.Delete()
A_TrayMenu.Add("프롬프트 생성기 열기`tCtrl+Alt+T", (*) => ShowPromptWindow())
A_TrayMenu.Add()
A_TrayMenu.Add("종료", (*) => ExitApp())

Hotkey HOTKEY_SHOW, (*) => ShowPromptWindow()

; =========================
; UI
; =========================

ShowPromptWindow() {
  global MainGui

  if IsObject(MainGui) {
    try MainGui.Destroy()
  }

  ResetState()
  BuildGui()
  LoadCurrentCaseToUi()
  MainGui.Show("w980 h780")
}

BuildGui() {
  global MainGui
  global FileEdit
  global CodeEdit
  global DiagnosticsEdit
  global StatusText
  global UI_FONT_NAME
  global UI_FONT_SIZE
  global CODE_FONT_NAME
  global CODE_FONT_SIZE
  global WINDOW_TITLE

  MainGui := Gui("+Resize", WINDOW_TITLE)
  MainGui.MarginX := 12
  MainGui.MarginY := 12

  MainGui.SetFont("s" UI_FONT_SIZE, UI_FONT_NAME)
  MainGui.OnEvent("Close", (*) => ClosePromptWindow())

  MainGui.AddText("xm ym w940", "오류 케이스를 입력한 뒤 [복사 후 닫기]를 누르면 Codex에 붙여넣을 프롬프트가 클립보드에 저장됩니다.")

  StatusText := MainGui.AddText("xm y+10 w940", "")

  MainGui.AddText("xm y+14 w940", "1) 오류가 발생한 코드 파일 내용 혹은 파일 경로")
  MainGui.SetFont("s" CODE_FONT_SIZE, CODE_FONT_NAME)
  FileEdit := MainGui.AddEdit("xm y+4 w940 h120 -Wrap WantTab")

  MainGui.SetFont("s" UI_FONT_SIZE, UI_FONT_NAME)
  MainGui.AddText("xm y+12 w940", "2) 오류가 발생한 코드")
  MainGui.SetFont("s" CODE_FONT_SIZE, CODE_FONT_NAME)
  CodeEdit := MainGui.AddEdit("xm y+4 w940 h180 -Wrap WantTab")

  MainGui.SetFont("s" UI_FONT_SIZE, UI_FONT_NAME)
  MainGui.AddText("xm y+12 w940", "3) Linter / Type checker / Compiler / Runtime 오류 메시지")
  MainGui.SetFont("s" CODE_FONT_SIZE, CODE_FONT_NAME)
  DiagnosticsEdit := MainGui.AddEdit("xm y+4 w940 h180 -Wrap WantTab")

  MainGui.SetFont("s" UI_FONT_SIZE, UI_FONT_NAME)

  MainGui.AddButton("xm y+16 w110 h32", "이전").OnEvent("Click", (*) => PreviousCase())
  MainGui.AddButton("x+8 w110 h32", "다음").OnEvent("Click", (*) => NextCase())
  MainGui.AddButton("x+8 w130 h32", "오류 추가").OnEvent("Click", (*) => AddCase())
  MainGui.AddButton("x+8 w130 h32", "현재 초기화").OnEvent("Click", (*) => ResetCurrentCase())
  MainGui.AddButton("x+8 w150 h32", "전체 초기화").OnEvent("Click", (*) => ResetAllCases())
  MainGui.AddButton("x+8 w150 h32", "복사 후 닫기").OnEvent("Click", (*) => CopyPromptAndClose())
}

NewCase() {
  return Map(
    "file_or_path", "",
    "failing_code", "",
    "diagnostics", ""
  )
}

SaveUiToCurrentCase() {
  global Cases
  global CurrentIndex
  global FileEdit
  global CodeEdit
  global DiagnosticsEdit

  Cases[CurrentIndex]["file_or_path"] := FileEdit.Value
  Cases[CurrentIndex]["failing_code"] := CodeEdit.Value
  Cases[CurrentIndex]["diagnostics"] := DiagnosticsEdit.Value
}

ClosePromptWindow() {
  global MainGui

  if IsObject(MainGui) {
    MainGui.Destroy()
    MainGui := ""
  }

  ResetState()
}

ResetState() {
  global Cases
  global CurrentIndex

  Cases := []
  Cases.Push(NewCase())
  CurrentIndex := 1
}

LoadCurrentCaseToUi() {
  global Cases
  global CurrentIndex
  global FileEdit
  global CodeEdit
  global DiagnosticsEdit
  global StatusText

  item := Cases[CurrentIndex]

  FileEdit.Value := item["file_or_path"]
  CodeEdit.Value := item["failing_code"]
  DiagnosticsEdit.Value := item["diagnostics"]

  StatusText.Text := "Case " CurrentIndex " / " Cases.Length
}

PreviousCase() {
  global CurrentIndex

  SaveUiToCurrentCase()

  if CurrentIndex > 1 {
    CurrentIndex -= 1
  }

  LoadCurrentCaseToUi()
}

NextCase() {
  global Cases
  global CurrentIndex

  SaveUiToCurrentCase()

  if CurrentIndex < Cases.Length {
    CurrentIndex += 1
  }

  LoadCurrentCaseToUi()
}

AddCase() {
  global Cases
  global CurrentIndex

  SaveUiToCurrentCase()

  Cases.Push(NewCase())
  CurrentIndex := Cases.Length

  LoadCurrentCaseToUi()
}

ResetCurrentCase() {
  global Cases
  global CurrentIndex

  Cases[CurrentIndex] := NewCase()
  LoadCurrentCaseToUi()
}

ResetAllCases() {
  global Cases
  global CurrentIndex

  result := MsgBox("모든 입력을 초기화할까요?", "확인", "YesNo Icon?")
  if result != "Yes" {
    return
  }

  Cases := []
  Cases.Push(NewCase())
  CurrentIndex := 1

  LoadCurrentCaseToUi()
}

CopyPromptAndClose() {
  global MainGui

  SaveUiToCurrentCase()

  prompt := BuildPrompt()
  A_Clipboard := prompt

  TrayTip("Codex 프롬프트", "프롬프트를 클립보드에 복사했습니다.", 2)

  ClosePromptWindow()
}

BuildPrompt() {
  global Cases
  global SKILL_NAME

  fence := Chr(96) Chr(96) Chr(96)

  prompt := "$" SKILL_NAME "`r`n`r`n"
  prompt .= "다음 구조화된 오류 묶음을 분석해서 수정해줘.`r`n"
  prompt .= "필요하면 제공된 파일뿐 아니라 관련 파일, import, call site, 타입 정의까지 함께 확인해줘.`r`n"
  prompt .= "기존 동작은 유지하고, 특히 Python 타입 오류는 cast/Any로 숨기지 말고 근본 원인을 수정해줘.`r`n`r`n"

  for index, item in Cases {
    file_or_path := Trim(item["file_or_path"])
    failing_code := Trim(item["failing_code"])
    diagnostics := Trim(item["diagnostics"])

    if file_or_path = "" and failing_code = "" and diagnostics = "" {
      continue
    }

    prompt .= "## Case " index "`r`n`r`n"

    prompt .= "### file_or_path`r`n"
    prompt .= fence "text`r`n"
    prompt .= file_or_path "`r`n"
    prompt .= fence "`r`n`r`n"

    prompt .= "### failing_code`r`n"
    prompt .= fence "text`r`n"
    prompt .= failing_code "`r`n"
    prompt .= fence "`r`n`r`n"

    prompt .= "### diagnostics`r`n"
    prompt .= fence "text`r`n"
    prompt .= diagnostics "`r`n"
    prompt .= fence "`r`n`r`n"
  }

  prompt .= "## Required output`r`n`r`n"
  prompt .= "- Root cause`r`n"
  prompt .= "- Files changed`r`n"
  prompt .= "- Exact fix`r`n"
  prompt .= "- Validation performed`r`n"
  prompt .= "- Remaining uncertainty, if any`r`n"

  return prompt
}
