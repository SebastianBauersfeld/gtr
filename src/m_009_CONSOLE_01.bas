Attribute VB_Name = "m_009_CONSOLE_01"
Option Explicit

'initialisiert die Konsole
Public Sub Init_Console()

    Dim n       As Long
    
    With g_Console
        .Draw = True
        .Pos = SetRectSng(0, 0, g_App.ResX, g_App.ResY)
        .FirstLineLeft = CONSOLE_LINE_X
        .FirstLineTop = CONSOLE_LINE_Y
        .InputLeft = CONSOLE_INPUT_X
        .InputTop = CONSOLE_INPUT_Y
        .LineDist = DEFAULT_CONSOLE_LINEDIST
        .Speed = DEFAULT_CONSOLE_SPEED
        .TargetY = 0
                
        .Vertex(1).X = g_D3DSubX
        .Vertex(1).Y = g_D3DSubY
        .Vertex(2).X = g_App.ResX / g_D3DDivX + g_D3DSubX
        .Vertex(2).Y = g_D3DSubY
                
        .InputLine = ""
        
        .ReadPos = 0
        .WritePos = 1
        
        With .Completer
            .ReadPos = 0
            .WritePos = 1
        End With
    End With
    
End Sub

'ruft die Konsole auf
Public Sub Call_Console()
    
    With g_Console
        If .TargetY = 0 Then
            .Draw = True
            .TargetY = g_App.ResY / 3
            .ReadPos = .WritePos - 1
            .InputLine = ""
            .Completer.ReadPos = .Completer.WritePos - 1
        Else
            .TargetY = 0
        End If
    End With

End Sub

'Eingabezeile erweitern
Public Sub Enlarge_ConsoleInputLine(ByVal KeyAscii As Integer)

    With g_Console
        Select Case KeyAscii
            Case 8:             'mit Backspace löschen
                If Len(.InputLine) > 0 Then .InputLine = Left(.InputLine, Len(.InputLine) - 1)
            
            Case 13:            'mit Enter Eingabe
                If Len(Trim(.InputLine)) > 0 Then
                    Input_ConsoleCompleter .InputLine
                    Input_Console "--> " & .InputLine
                    Analyze_ConsoleCmd .InputLine
                End If
                
                .InputLine = ""
            
            Case Else:          'erweitern
                If Len(.InputLine) < MAX_CONSOLE_INPUTLINECHARS Then .InputLine = .InputLine & Chr(KeyAscii)
                
        End Select
    End With
    
End Sub

'Eingabe in Konsole
Public Sub Input_Console(ByVal Text As String)

    Dim n           As Long

    With g_Console
                
        If .WritePos > MAX_CONSOLE_LINES Then
            .WritePos = MAX_CONSOLE_LINES
            
            For n = 2 To MAX_CONSOLE_LINES
                .InfoLine(n - 1) = .InfoLine(n)
            Next
        End If
        
        .ReadPos = .WritePos
        .InfoLine(.WritePos) = Text
        .WritePos = .WritePos + 1
                
    End With
    
End Sub

'Befehle analysieren
Public Sub Analyze_ConsoleCmd(ByVal Cmd As String)
    
    Dim n                   As Long
    Dim h_Cmd               As String
    Dim ParamCount          As Long
    Dim h_Pos(1 To 2)       As Integer
    Dim KeyWord             As String
    Dim Param()             As String
    Dim Result              As Variant
    
    Cmd = Trim(Cmd) & " "
    
    'doppelte Leerzeichen entfernen
    h_Cmd = ""
    ParamCount = 0
    
    For n = 1 To Len(Cmd) - 1
        If Mid(Cmd, n, 1) <> " " Then
            h_Cmd = h_Cmd & Mid(Cmd, n, 1)
            
        ElseIf Mid(Cmd, n + 1, 1) <> " " Then
            h_Cmd = h_Cmd & Mid(Cmd, n, 1)
            
            'Parameteranzahl ermitteln
            If Mid(Cmd, n, 1) = " " Then ParamCount = ParamCount + 1
        End If
    Next
    
    Cmd = h_Cmd & " "       'Leerzeichen hinten heransetzen

    'KeyWord ermitteln
    h_Pos(1) = InStr(1, Cmd, " ", vbBinaryCompare) - 1
    KeyWord = LCase(Left(Cmd, h_Pos(1)))
    
    'Parameter speichern
    ReDim Param(1 To ParamCount + 1)
    Param(1) = ParamCount
    
    If ParamCount >= 1 Then h_Pos(1) = InStr(1, Cmd, " ", vbBinaryCompare) + 1

    For n = 2 To ParamCount + 1
        h_Pos(2) = InStr(h_Pos(1), Cmd, " ", vbBinaryCompare)

        Param(n) = Mid(Cmd, h_Pos(1), h_Pos(2) - h_Pos(1))

        h_Pos(1) = h_Pos(2) + 1
    Next
    
    'Befehl ausführen
    Console_CmdHandler KeyWord, Param()
    
End Sub

'in der Konsole scrollen
Public Sub Scroll_Console(ByVal Speed As Integer)

    With g_Console
        If Not .Draw Then Exit Sub
        
        .ReadPos = .ReadPos + Speed
        
        If .ReadPos < 1 Then .ReadPos = 1
        If .ReadPos > .WritePos - 1 Then .ReadPos = .WritePos - 1
        
    End With

End Sub

'bewegt die Konsole an das Ziel
Public Sub Move_Console()

    Dim h_Speed         As Single

    With g_Console
        If Abs(.Pos.Bottom - .TargetY) > 1 Then
            h_Speed = (.TargetY - .Pos.Bottom) / 100 * .Speed * g_App.AVF
            
            If Abs(h_Speed) >= Abs(.Pos.Bottom - .TargetY) Then
                .Pos.Bottom = .TargetY
            Else
                .Pos.Bottom = .Pos.Bottom + h_Speed
            End If
            
            .Vertex(3).X = g_D3DSubX
            .Vertex(3).Y = -(.Pos.Bottom) / g_D3DDivY + g_D3DSubY
            .Vertex(4).X = g_App.ResX / g_D3DDivX + g_D3DSubX
            .Vertex(4).Y = -(.Pos.Bottom) / g_D3DDivY + g_D3DSubY
            
        Else
            .Pos.Bottom = .TargetY
            If .TargetY = 0 Then .Draw = False
        End If
    End With

End Sub

'Eintrag im Vervollständiger hinzufügen
Public Sub Input_ConsoleCompleter(ByVal Text As String)

    Dim n           As Long

    With g_Console.Completer
        
        'abbrechen wenn doppelter Eintrag
        If .WritePos > 1 Then
            If .Complete(.WritePos - 1) = Text Then
                .ReadPos = .WritePos - 1
                Exit Sub
            End If
        End If
        
        If .WritePos > MAX_CONSOLE_COMPLETES Then
            .WritePos = MAX_CONSOLE_COMPLETES
            
            For n = 2 To MAX_CONSOLE_COMPLETES
                .Complete(n - 1) = .Complete(n)
            Next
        End If
        
        .Complete(.WritePos) = Text
        .ReadPos = .WritePos
        .WritePos = .WritePos + 1
    End With

End Sub

'im Vervollständiger manövrieren
Public Sub Scroll_ConsoleCompleter(ByVal Speed As Integer)

    If Not g_Console.Draw Then Exit Sub
    
    With g_Console.Completer
        .ReadPos = .ReadPos + Speed
        If .ReadPos < 1 Then .ReadPos = 1
        If .ReadPos > .WritePos - 1 Then .ReadPos = .WritePos - 1
        
        If .ReadPos > 0 Then g_Console.InputLine = .Complete(.ReadPos)
    End With

End Sub

'Konsole zeichnen
Public Sub Draw_Console(ByVal Flip As Boolean, ByVal ShowInput As Boolean, ByRef Font As TFont)

    Dim n               As Long
    Dim h_LinesToDraw   As Integer
    Dim h_Line          As Integer
    Dim h_LineY         As Integer
    Dim h_a             As Single
        
    With g_Console
            
        If Flip Then g_D3DDev.Clear 1, g_RectViewport(), D3DCLEAR_TARGET, 0, 1, 0
                    
        'PolygonHintergrund
        h_a = g_HUD.Color.a
        If h_a < 0.01 Then h_a = 0.01
        g_Material.emissive.R = g_HUD.Color.R / h_a
        g_Material.emissive.G = g_HUD.Color.G / h_a
        g_Material.emissive.b = g_HUD.Color.b / h_a
        
        With g_D3DDev
            subSetAlpha 1, A_SUBTRACT, False
            .SetMaterial g_Material
            
            .SetTexture 0, Nothing
            
            .BeginScene
                .DrawPrimitive D3DPT_TRIANGLESTRIP, D3DFVF_VERTEX, g_Console.Vertex(1), 4, D3DDP_DEFAULT
            .EndScene
        End With
                    
        'Rahmen ziehen
        g_BackBuf.SetForeColor &HFFFFFF
        g_BackBuf.DrawLine .Pos.Left, .Pos.Bottom, .Pos.Right, .Pos.Bottom
        
        'Zeilen zeichnen
        h_LinesToDraw = (.Pos.Bottom - .FirstLineTop) \ .LineDist + 1
                    
        For n = 0 To h_LinesToDraw - 1
            h_Line = .ReadPos - n
            If h_Line <= 0 Then Exit For
            
            h_LineY = .Pos.Bottom - .FirstLineTop - n * .LineDist
            Blit_Text .FirstLineLeft, h_LineY, .InfoLine(h_Line), Font
        Next
        
        'Eingabezeile zeichnen
        If ShowInput Then Blit_Text .InputLeft - GetTextWidth("Command: ", Font), .Pos.Bottom - .InputTop, "Command: " & .InputLine, Font
        
        If Flip Then g_FrontBuf.Flip Nothing, DDFLIP_WAIT
        
    End With

End Sub

'initialisiert das Msg-Board
Public Sub Init_MsgBoard()

    With g_MsgBoard
        .Draw = CBool(GetINIValue(App.Path & "\config.ini", "OPTIONS", "DrawMsgBoard"))
        .X = DEFAULT_MSGBOARD_X
        .Y = DEFAULT_MSGBOARD_Y
        .WritePos = 1
        .RefreshDelay = DEFAULT_MSGBOARD_REFRESH_DELAY
        SetEvent .RefreshEvent, -1
        .LineDist = DEFAULT_MSGBOARD_LINEDIST
    End With

End Sub

'fügt dem Msg-Board eine neue Info hinzu
Public Sub Add_MsgBoardInfo(ByVal Text As String)
    
    Dim n       As Long
    
    With g_MsgBoard
        If .WritePos > MAX_MSGBOARD_INFOS Then
            .WritePos = MAX_MSGBOARD_INFOS
            
            For n = 2 To MAX_MSGBOARD_INFOS
                .Info(n - 1) = .Info(n)
            Next
        End If
        
        .Info(.WritePos) = Text
        .WritePos = .WritePos + 1
            
        SetEvent .RefreshEvent, .RefreshDelay
    End With

End Sub

'aktualisiert das Msg-Board
Public Sub Refresh_MsgBoard()

    Dim n   As Long

    With g_MsgBoard
        If GetEventStatus(.RefreshEvent) Then
            For n = 2 To MAX_MSGBOARD_INFOS
                .Info(n - 1) = .Info(n)
            Next
            
            .WritePos = .WritePos - 1
            If .WritePos < 1 Then .WritePos = 1
            
            SetEvent .RefreshEvent, .RefreshDelay
        End If
    End With

End Sub

'fügt dem Msg-Board neue Info hinzu
Public Sub Draw_MsgBoard(ByRef Font As TFont)

    Dim n           As Long
    
    Refresh_MsgBoard

    With g_MsgBoard
        For n = 1 To .WritePos - 1
            Blit_Text .X, .Y + (n - 1) * .LineDist, .Info(n), Font
        Next
    End With

End Sub
