#Requires AutoHotkey v2.0
#SingleInstance Force
SendMode("Input")
SetKeyDelay(-1, -1)
SetWinDelay(-1)
SetControlDelay(-1)
CoordMode("Mouse", "Screen")

; One-key lookup for selected biology-paper terms.
; Default flow: copy selection -> open Everywhere -> paste into input -> click Send.

EVERYWHERE_HOTKEY := "^+e"  ; Ctrl+Shift+E, Everywhere default.
EVERYWHERE_WINDOW := "ahk_exe Everywhere.exe"
EVERYWHERE_LEGACY_WINDOW := "ahk_exe Everywhere.Windows.exe"
OPEN_DELAY_MS := 320
PASTE_DELAY_MS := 35
MAX_CHARS := 1200

; Everywhere 0.7+ windows are resizable. These points are relative to the lower-right corner.
INPUT_RIGHT_OFFSET := 190
INPUT_BOTTOM_OFFSET := 52
SEND_RIGHT_OFFSET := 38
SEND_BOTTOM_OFFSET := 52

!x::LookupSelectedTerm()

LookupSelectedTerm() {
    global EVERYWHERE_HOTKEY, OPEN_DELAY_MS, PASTE_DELAY_MS, MAX_CHARS

    clipSaved := ClipboardAll()
    A_Clipboard := ""

    Send("^c")
    if !ClipWait(0.5) {
        A_Clipboard := clipSaved
        ShowTip("没有复制到选中的词/短语")
        return
    }

    term := NormalizeSelection(A_Clipboard)
    if (term = "") {
        A_Clipboard := clipSaved
        ShowTip("选中的内容为空")
        return
    }

    if (StrLen(term) > MAX_CHARS) {
        term := SubStr(term, 1, MAX_CHARS)
        ShowTip("选中内容较长，已截取前 " MAX_CHARS " 字符")
    }

    Send(EVERYWHERE_HOTKEY)
    WaitForEverywhere()
    Sleep(OPEN_DELAY_MS)

    FocusChatInput()

    A_Clipboard := term
    Sleep(PASTE_DELAY_MS)
    Send("^v")
    Sleep(PASTE_DELAY_MS)
    ClickSendButton()

    Sleep(150)
    A_Clipboard := clipSaved
}

WaitForEverywhere() {
    global EVERYWHERE_WINDOW, EVERYWHERE_LEGACY_WINDOW

    if WinWait(EVERYWHERE_WINDOW, , 1.2) {
        WinActivate(EVERYWHERE_WINDOW)
        WinWaitActive(EVERYWHERE_WINDOW, , 0.8)
        return
    }

    if WinWait(EVERYWHERE_LEGACY_WINDOW, , 0.8) {
        WinActivate(EVERYWHERE_LEGACY_WINDOW)
        WinWaitActive(EVERYWHERE_LEGACY_WINDOW, , 0.8)
    }
}

FocusChatInput() {
    global INPUT_RIGHT_OFFSET, INPUT_BOTTOM_OFFSET

    MouseGetPos(&oldX, &oldY)
    WinGetPos(&winX, &winY, &winW, &winH, "A")
    Click(winX + winW - INPUT_RIGHT_OFFSET, winY + winH - INPUT_BOTTOM_OFFSET)
    Sleep(70)
    MouseMove(oldX, oldY, 0)
}

ClickSendButton() {
    global SEND_RIGHT_OFFSET, SEND_BOTTOM_OFFSET

    MouseGetPos(&oldX, &oldY)
    WinGetPos(&winX, &winY, &winW, &winH, "A")
    Click(winX + winW - SEND_RIGHT_OFFSET, winY + winH - SEND_BOTTOM_OFFSET)
    Sleep(60)
    MouseMove(oldX, oldY, 0)
}

NormalizeSelection(text) {
    text := StrReplace(text, "`r`n", "`n")
    text := StrReplace(text, "`r", "`n")

    ; Join words split by PDF line hyphenation, e.g. "trans-" + newline + "cription".
    text := RegExReplace(text, "-\s*\R\s*", "")

    ; Collapse PDF/newline whitespace into a single space.
    text := RegExReplace(text, "\s+", " ")
    omitChars := " `t`r`n'“”‘’.,;:!?()[]{}<>" . Chr(34)
    text := Trim(text, omitChars)

    return text
}

ShowTip(text) {
    ToolTip(text)
    SetTimer(() => ToolTip(), -1200)
}

