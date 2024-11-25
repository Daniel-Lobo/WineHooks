/* ,---, ,--,
,--.' | ,--.'|
| | : .--. ,--, | | :
.--.--. : : : .--,`| ,'_ /| : : '
/ / ' : | |,--. ,--.--. | |. .--. | | : | ' |
| : /`./ | : ' | / \ '--`_ ,'_ /| : . | ' | |
| : ;_ | | /' :.--. .-. | ,--,'|| ' | | . . | | :
\ \ `.' : | | | \__\/: . . | | '| | ' | | | ' : |__
`----. \ | ' | : ," .--.; | : | |: | : ; ; | | | '.'|
/ /`--' / : :_:,'/ / ,. | __| : '' : `--' \; : ;
'--'. /| | ,' ; : .' \.'__/\_: |: , .-./| , /
`--'---' `--'' | , .-./| : : `--`----' ---`-'
`--`---' \ \ /
`--`-'
------------------------------------------------------------------
Function: Convert GUID to string and vice-versa
------------------------------------------------------------------
*/

/*
;; ---------- Example -------------------------------------------
GUID_FromString(rfid, "{82A5EA35-D9CD-47C5-9629-E15D2F714E6E}") ;Set GUID

;GUID in action
VarSetCapacity(mypath,(A_IsUnicode ? 2 : 1)*260)
DllCall("Shell32\SHGetKnownFolderPath", "UInt", &rfid, "UInt", 0, "UInt", 0, "UIntP", mypath)
MsgBox % StrGet(mypath)

MsgBox % GUID_ToString(rfid) ;retrieve string again
;; ---------- End Example ---------------------------------------
*/


;
; Function: GUID_FromString
; Description:
; GUID from input string
; Syntax: GUID_FromString(Var_To_Recieve_GUID, GUID_String)
; Parameters:
; Var_To_Recieve_GUID - Empty variable to recieve GUID
; GUID_String - GUID String
; Return Value:
; Empty string
; Remarks:
; None
; Related: GUID_ToString
; Example:
; GUID_FromString(MyGUID,"{00020400-0000-0000-C000-000000000046}")
;
GUID_FromString(ByRef GUID, String) {
VarSetCapacity(GUID, 16, 0)
StringReplace,String,String,-,,All
NumPut("0x" . SubStr(String, 2, 8), GUID, 0, "UInt") ; DWORD Data1
NumPut("0x" . SubStr(String, 10, 4), GUID, 4, "UShort") ; WORD Data2
NumPut("0x" . SubStr(String, 14, 4), GUID, 6, "UShort") ; WORD Data3
Loop, 8
   NumPut("0x" . SubStr(String, 16+(A_Index*2), 2), GUID, 7+A_Index, "UChar") ; BYTE Data4[A_Index]
}

;
; Function: GUID_ToString
; Description:
; String from GUID
; Syntax: GUID_ToString(GUID_Containing_Var)
; Parameters:
; GUID_Containing_Var - Variable containing the GUID
; Return Value:
; String GUID
; Remarks:
; None
; Related: GUID_FromString
; Example:
; string := GUID_ToString(MyGUID)
;
GUID_ToString(ByRef GUID) {
format := A_FormatInteger
SetFormat, Integer, H
str .= SubStr(NumGet(GUID, 0, "UInt"),3) . "-" ; DWORD Data1
str .= SubStr(NumGet(GUID, 4, "UShort"),3) . "-" ; WORD Data2
str .= SubStr(NumGet(GUID, 6, "UShort"),3) . "-" ; WORD Data3
Loop, 8
   str .= (A_Index = 2) ? SubStr(NumGet(GUID, 7+A_Index, "UChar"),3) . "-" : SubStr(NumGet(GUID, 7+A_Index, "UChar"),3) ; BYTE Data4[A_Index]
SetFormat, Integer, %format%
return "{" . str . "}"
}
