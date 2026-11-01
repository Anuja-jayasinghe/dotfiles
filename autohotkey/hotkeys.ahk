#Requires AutoHotkey v2.0
; Global hotkeys. Started at login by windows/install.ps1.

; Win+K: Bluetooth device popup (Windows 11 made Win+K open Cast). The popup is drawn here so it opens instantly;
; the paired-device list is cached by the toolnest script, which also does the connecting.
; Enter / double-click connects, Ctrl+D disconnects, Esc closes. Devices matching btTop are listed first.
projects := EnvGet("GITPROJECTS") || "C:\gitprojects"
btScript := projects "\toolnest\bluetooth_connect\bluetooth_connect.ps1"
btCache := EnvGet("LOCALAPPDATA") "\toolnest\bluetooth-devices.txt"
btTop := "soundcore"
btGui := ""
btList := ""

BtRun(args) => Run('pwsh -NoProfile -WindowStyle Hidden -File "' btScript '" ' args, , "Hide")

BtRun("-List")   ; refresh the cache in the background

#k:: {
    global btGui, btList
    if IsObject(btGui) {
        WinActivate("ahk_id " btGui.Hwnd)
        return
    }
    names := []
    if FileExist(btCache) {
        for line in StrSplit(FileRead(btCache), "`n", "`r") {
            if line = ""
                continue
            if InStr(line, btTop)
                names.InsertAt(1, line)
            else
                names.Push(line)
        }
    }
    BtRun("-List")   ; keep the cache fresh for next time
    if names.Length = 0 {
        TrayTip("Device list is still loading, press Win+K again in a moment.", "Bluetooth")
        return
    }
    btGui := Gui("+AlwaysOnTop -MinimizeBox -MaximizeBox", "Bluetooth")
    btGui.BackColor := "282A36"
    btGui.SetFont("s12 cF8F8F2", "Segoe UI")
    btList := btGui.Add("ListBox", "w320 r" names.Length " Background282A36 Choose1", names)
    btList.OnEvent("DoubleClick", (*) => BtAction(false))
    btGui.SetFont("s9 c6272A4")
    btGui.Add("Text", , "Enter connect    Ctrl+D disconnect    Esc close")
    btGui.Add("Button", "Default w0 h0").OnEvent("Click", (*) => BtAction(false))
    btGui.OnEvent("Escape", (*) => BtClose())
    btGui.OnEvent("Close", (*) => BtClose())
    btGui.Show("Center")
    WinActivate("ahk_id " btGui.Hwnd)
}

BtClose() {
    global btGui
    if IsObject(btGui)
        btGui.Destroy()
    btGui := ""
}

BtAction(disconnect) {
    name := btList.Text
    BtClose()
    if name != ""
        BtRun('-Name "' name '"' (disconnect ? " -Disconnect" : ""))
}

#HotIf IsObject(btGui) && WinActive("ahk_id " btGui.Hwnd)
^d:: BtAction(true)
#HotIf
