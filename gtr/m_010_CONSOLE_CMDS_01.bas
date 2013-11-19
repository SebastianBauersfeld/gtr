Attribute VB_Name = "m_010_CONSOLE_02"
Option Explicit

'ruft die Prozeduren für die Befehle auf
Public Sub Console_CmdHandler(ByVal KeyWord As String, ByRef Param() As String)

    Select Case KeyWord
        
        Case "addbot":
            Console_AddBot Param()
        
        Case "consolespeed":
            Change_ConsoleSpeed Param()
        
        Case "backcolor":
            Change_BackColor Param()
        
        Case "gravity":
            Change_Gravity Param()
        
        Case "pinballfactor":
            Change_PinballFactor Param()
            
        Case "showtime":
            ShowTime
        
        Case Else:
            Input_Console "---Invalid KeyWord or Parameter!---"
        
    End Select

End Sub

'Konsolengeschwindigkeit ändern
Private Sub Change_ConsoleSpeed(ByRef Param() As String)

    If Param(1) = "0" Then
        Input_Console "---consolespeed is " & g_Console.Speed & "---"
    Else
        If IsNum(Param(2)) Then
            g_Console.Speed = Abs(StrToSng(Param(2)))
            Input_Console "---consolespeed changed to " & g_Console.Speed & "---"
            Add_MsgBoardInfo "---consolespeed changed to " & g_Console.Speed & "---"
        Else
            Input_Console "---Invalid Parameter!---"
        End If

    End If

End Sub

'HintergrundFarbe ändern
Private Sub Change_BackColor(ByRef Param() As String)

    If Param(1) = "0" Then
        Input_Console "---backcolor is " & g_Map.BackCol & "---"
    Else
        If IsNum(Param(2)) Then
            g_Map.BackCol = Abs(StrToSng(Param(2)))
            Input_Console "---backcolor changed to " & g_Map.BackCol & "---"
            Add_MsgBoardInfo "---backcolor changed to " & g_Map.BackCol & "---"
        Else
            Input_Console "---Invalid Parameter!---"
        End If

    End If

End Sub

'Gravity ändern
Private Sub Change_Gravity(ByRef Param() As String)

    If CInt(Param(1)) <= 1 Then
        Input_Console "---gravx is " & g_Map.GravX & " gravy is " & g_Map.GravY & "---"
    Else
        If IsNum(Param(2)) And IsNum(Param(3)) Then
            g_Map.GravX = StrToSng(Param(2))
            g_Map.GravY = StrToSng(Param(3))
            Input_Console "---gravx changed to " & g_Map.GravX & " gravy changed to " & g_Map.GravY & "---"
            Add_MsgBoardInfo "---gravx changed to " & g_Map.GravX & " gravy changed to " & g_Map.GravY & "---"
        Else
            Input_Console "---Invalid Parameter!---"
        End If

    End If

End Sub

'PinballFactor ändern
Private Sub Change_PinballFactor(ByRef Param() As String)

    If Param(1) = "0" Then
        Input_Console "---pinballfactor is " & g_Map.PinballFactor & "---"
    Else
        If IsNum(Param(2)) Then
            g_Map.PinballFactor = StrToSng(Param(2))
            Input_Console "---pinballfactor changed to " & g_Map.PinballFactor & "---"
            Add_MsgBoardInfo "---pinballfactor changed to " & g_Map.PinballFactor & "---"
        Else
            Input_Console "---Invalid Parameter!---"
        End If

    End If

End Sub

'Zeit anzeigen
Private Sub ShowTime()

    Input_Console "---Time is " & Time & "---"

End Sub

'Bot hinzufügen
Private Sub Console_AddBot(ByRef Param() As String)
    
    If Not g_App.IsServer Then
        Input_Console "---You are not allowed to add bots---"
        Exit Sub
    End If
    
    If Param(1) = "3" Then
        If IsNum(Param(3)) And IsNum(Param(4)) Then
            If g_App.GameMode = GAME_MODE_MP_DEATHMATCH Then
                Add_NetPlayer Param(2), Create_Lan_Player(Param(2), Param(2) & "1"), True, Param(3), Param(4)
            ElseIf g_App.GameMode = GAME_MODE_SP_DEATHMATCH Then
                If Add_Player(Param(3), Param(2), Param(4)) Then Init_Bot g_Plr(g_PlrCnt)
            End If
        Else
            Input_Console "---Invalid Parameter!---"
        End If
    Else
        Input_Console "---Invalid Parameter!---"
    End If
    
End Sub
