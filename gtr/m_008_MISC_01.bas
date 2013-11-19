Attribute VB_Name = "m_008_MISC_01"
Option Explicit

'liefert Infos über PC-Settings
Public Function GetPCSettings(ByVal InfoID As Long) As String
    
    Dim h_Buf           As String * 256
    Dim h_BufCount      As String
        
    h_BufCount = GetLocaleInfo(&H400, InfoID, h_Buf, Len(h_Buf))
    
    If h_BufCount > 0 Then
        GetPCSettings = Left(h_Buf, h_BufCount - 1)
    Else
        GetPCSettings = ""
    End If

End Function

'zum Auslesen aus einer INI-Datei
Public Function GetINIValue(ByVal Path As String, ByVal Headline As String, ByVal ValueName As String) As String
    
    Dim Value       As String * 50
    Dim h_Count    As Long
    
    h_Count = GetPrivateProfileString(Headline, ValueName, 0, Value, Len(Value), Path)
    If h_Count > 1 Then Value = Left(Value, h_Count)
    GetINIValue = Value
    
End Function

'gibt an ob ein String numerisch ist
Public Function IsNum(ByVal Expression As String) As Boolean
    
    Dim n               As Long
    Dim h_Char          As String
    Dim h_String        As String
    Dim CommaCount      As Long
    
    IsNum = True
    h_String = ""
    CommaCount = 0
    
    For n = 1 To Len(Expression)
        h_Char = Mid(Expression, n, 1)
        
        If h_Char = "," Or h_Char = "." Then
            CommaCount = CommaCount + 1
            
            If CommaCount > 1 Then
                IsNum = False
                Exit Function
            End If
            
            h_String = h_String & g_App.DecimalSeparator
        Else
            h_String = h_String & h_Char
        End If
    Next
    
    IsNum = IsNumeric(h_String)
        
End Function

'wandelt String in Single um
Public Function StrToSng(ByVal Expression As String, Optional ByVal AbsMaxSize As Long = 999999) As Single
    
    Dim n               As Long
    Dim h_Int           As String
    Dim h_Sng           As String
    Dim h_Pos           As Long
    Dim NumDigits       As Integer
        
    Expression = Replace(Expression, ",", g_App.DecimalSeparator, 1, Len(Expression), vbBinaryCompare)
    Expression = Replace(Expression, ".", g_App.DecimalSeparator, 1, Len(Expression), vbBinaryCompare)
    
    NumDigits = 7
    
    h_Pos = InStr(1, Expression, g_App.DecimalSeparator, vbBinaryCompare)
    
    If h_Pos = 0 Then
        If Len(Expression) > NumDigits Then Expression = Left(Expression, NumDigits)
        StrToSng = CSng(Expression)
    Else
        h_Int = Left(Expression, h_Pos - 1)
        h_Sng = Mid(Expression, h_Pos, Len(Expression) - h_Pos + 1)
        If Len(h_Int) > NumDigits Then h_Int = Left(h_Int, NumDigits)
        If h_Int = "" Then h_Int = "0"
        
        StrToSng = CSng(h_Int & h_Sng)
    End If
            
    If StrToSng > AbsMaxSize Then
        StrToSng = AbsMaxSize
    ElseIf StrToSng < -AbsMaxSize Then
        StrToSng = -AbsMaxSize
    End If
            
End Function

'macht einen ScreenShot
Public Sub TakeScreenShot()
            
    With g_App
        ScreenShot .Path_ScreenShots & "\GTR_SCREENSHOT_" & Format(.CntScreenShots, "000") & ".bmp", frmMain.picScreenShot
        .CntScreenShots = .CntScreenShots + 1
        Input_Console "screenshot done!"
        Add_MsgBoardInfo "screenshot done!"
    End With

End Sub
