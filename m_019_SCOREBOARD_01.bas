Attribute VB_Name = "m_019_SCOREBOARD_01"
Option Explicit

'initialisiert das ScoreBoard
Public Sub Init_ScoreBoard()

    With g_ScoreBoard
        
        .Draw = False
        .ReadPos = 1
        .PosRect = SetRect(SCOREBOARD_X, SCOREBOARD_Y, SCOREBOARD_X + SCOREBOARD_WIDTH, SCOREBOARD_Y + SCOREBOARD_HEIGHT)
        SetEvent .RefreshEvent, SCOREBOARD_REFRESH_DELAY
    
        .Vertex(1).X = -0.7:   .Vertex(1).Y = 0.7:     .Vertex(1).Z = -28
        .Vertex(2).X = 0.7:    .Vertex(2).Y = 0.7:     .Vertex(2).Z = -28
        .Vertex(3).X = -0.7:   .Vertex(3).Y = -0.7:    .Vertex(3).Z = -28
        .Vertex(4).X = 0.7:    .Vertex(4).Y = -0.7:     .Vertex(4).Z = -28
    
    End With

End Sub

'scrollt im ScoreBoard
Public Sub Scroll_ScoreBoard(ByVal Step As Integer)

    With g_ScoreBoard
        
        If Not .Draw Then Exit Sub
        
        .ReadPos = .ReadPos + Step
        
        If .ReadPos < 1 Then .ReadPos = 1
        If .ReadPos > g_PlrCnt Then .ReadPos = g_PlrCnt
        
    End With

End Sub

'refreshed das ScoreBoard
Public Sub Refresh_ScoreBoard()

    Dim n       As Long
        
    For n = 1 To g_PlrCnt
        With g_ScoreBoard.Entry(n)
            .PlrName = g_Plr(n).PlrName
            .Frags = g_Plr(n).Frags
            .Deaths = g_Plr(n).Deaths
            .Skill = Round((.Frags * 2 - .Deaths) / (g_DX.TickCount - g_Plr(n).StartTime) * 600000, 2)
        End With
    Next
    
    Sort_ScoreBoard 1, g_PlrCnt

End Sub

'sortiert nach Skill
Public Sub Sort_ScoreBoard(ByVal Left As Long, ByVal Right As Long)

    Dim n           As Long
    Dim P1          As Long
    Dim P2          As Long
    Dim Mid         As Single
    Dim dummy       As TScoreBoardEntry
    
    With g_ScoreBoard
    
        P1 = Left
        P2 = Right
        Mid = .Entry((P1 + P2) * 0.5).Skill
        
        Do
            
            Do While (.Entry(P1).Skill > Mid)
                P1 = P1 + 1
            Loop
     
            Do While (.Entry(P2).Skill < Mid)
                P2 = P2 - 1
            Loop
    
            If P1 <= P2 Then
                dummy = .Entry(P1)
                .Entry(P1) = .Entry(P2)
                .Entry(P2) = dummy
                
                P1 = P1 + 1
                P2 = P2 - 1
            End If
            
        Loop Until (P1 > P2)
    
    End With
    
    If Left < P2 Then Sort_ScoreBoard Left, P2
    If P1 < Right Then Sort_ScoreBoard P1, Right
                

End Sub

'zeichnet das ScoreBoard
Public Sub Draw_ScoreBoard()
    
    Dim n           As Long
    Dim UpCount     As Integer
    
    With g_ScoreBoard
        
        'refresh
        If GetEventStatus(.RefreshEvent) Then
            Refresh_ScoreBoard
            SetEvent .RefreshEvent, SCOREBOARD_REFRESH_DELAY
        End If
        
        'PolygonHintergrund
        g_Material.emissive.r = g_HUD.Color.r / g_HUD.Color.a
        g_Material.emissive.g = g_HUD.Color.g / g_HUD.Color.a
        g_Material.emissive.b = g_HUD.Color.b / g_HUD.Color.a
        
        With g_D3DDev
            subSetAlpha 1, A_SUBTRACT, False
            .SetMaterial g_Material
            
            .SetTexture 0, Nothing
            
            .BeginScene
                .DrawPrimitive D3DPT_TRIANGLESTRIP, D3DFVF_VERTEX, g_ScoreBoard.Vertex(1), 4, D3DDP_DEFAULT
            .EndScene
        End With
        
        'Rand und Spalten ziehen
        g_BackBuf.SetForeColor &HFFFFFF
        g_BackBuf.DrawBox .PosRect.Left, .PosRect.Top, .PosRect.Right, .PosRect.Bottom
                
        g_BackBuf.DrawLine .PosRect.Left + 10, .PosRect.Top + 60, .PosRect.Right - 10, .PosRect.Top + 60
        
        g_BackBuf.DrawLine .PosRect.Left + 200, .PosRect.Top + 40, .PosRect.Left + 200, .PosRect.Bottom - 10
        g_BackBuf.DrawLine .PosRect.Left + 334, .PosRect.Top + 40, .PosRect.Left + 334, .PosRect.Bottom - 10
        g_BackBuf.DrawLine .PosRect.Left + 468, .PosRect.Top + 40, .PosRect.Left + 468, .PosRect.Bottom - 10
                        
        'Spalten
        Blit_Text .PosRect.Left + 250, .PosRect.Top + 10, "GTR - Scoreboard", g_TextFont(1)
        Blit_Text .PosRect.Left + 80, .PosRect.Top + 40, "Name", g_TextFont(1)
        Blit_Text .PosRect.Left + 250, .PosRect.Top + 40, "Skill", g_TextFont(1)
        Blit_Text .PosRect.Left + 380, .PosRect.Top + 40, "Frags", g_TextFont(1)
        Blit_Text .PosRect.Left + 516, .PosRect.Top + 40, "Deaths", g_TextFont(1)

        UpCount = g_PlrCnt - .ReadPos + 1
        If UpCount > MAX_SCOREBOARD_LINES Then UpCount = MAX_SCOREBOARD_LINES

        For n = 0 To UpCount - 1
            Blit_Text .PosRect.Left + 10, .PosRect.Top + SCOREBOARD_FIRSTLINE_Y + n * SCOREBOARD_LINE_DIST, n + .ReadPos, g_TextFont(1)
            Blit_Text .PosRect.Left + SCOREBOARD_NAME_X, .PosRect.Top + SCOREBOARD_FIRSTLINE_Y + n * SCOREBOARD_LINE_DIST, .Entry(n + .ReadPos).PlrName, g_TextFont(1)
            Blit_Text .PosRect.Left + SCOREBOARD_SKILL_X, .PosRect.Top + SCOREBOARD_FIRSTLINE_Y + n * SCOREBOARD_LINE_DIST, .Entry(n + .ReadPos).Skill, g_TextFont(1)
            Blit_Text .PosRect.Left + SCOREBOARD_FRAGS_X, .PosRect.Top + SCOREBOARD_FIRSTLINE_Y + n * SCOREBOARD_LINE_DIST, .Entry(n + .ReadPos).Frags, g_TextFont(1)
            Blit_Text .PosRect.Left + SCOREBOARD_DEATHS_X, .PosRect.Top + SCOREBOARD_FIRSTLINE_Y + n * SCOREBOARD_LINE_DIST, .Entry(n + .ReadPos).Deaths, g_TextFont(1)
        Next
        
    End With
    
End Sub
