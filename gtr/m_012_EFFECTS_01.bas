Attribute VB_Name = "m_014_EFFECTS_01"
Option Explicit

'initialisiert die HintergrundSterne
Public Sub Init_BackStars()

    Dim n           As Long
    Dim m           As Long
    
    With g_Map
        .NumStars(1) = GetINIValue(App.Path & "\config.ini", "OPTIONS", "MaxBackstars1")
        .NumStars(2) = GetINIValue(App.Path & "\config.ini", "OPTIONS", "MaxBackstars2")
        .NumStars(3) = GetINIValue(App.Path & "\config.ini", "OPTIONS", "MaxBackstars3")
        .StarCol(1) = PLAIN1_STAR_COL
        .StarCol(2) = PLAIN2_STAR_COL
        .StarCol(3) = PLAIN3_STAR_COL
    End With
        
    For n = 1 To NUM_STAR_PLAINS
        g_Map.StarSpeedFactor(n) = 0.25 / g_Map.StarPlain_z(n)
        
        For m = 1 To g_Map.NumStars(n)
            With g_BackStar(n, m)
                .X = Int(Rnd * g_App.ResX)
                .Y = Int(Rnd * g_App.ResY)
                .Color = g_Map.StarCol(n)
                .Speed = Rnd * 0.9 + 1
            End With
        Next
    Next

End Sub

'zeichnet Sterne die sich alle unterschiedlich schnell bewegen
Public Sub Draw_BackStars()
    
    Dim n                               As Long
    Dim m                               As Long
    Dim h_MoveX(1 To NUM_STAR_PLAINS)   As Single
    Dim h_MoveY(1 To NUM_STAR_PLAINS)   As Single
    Dim h_ResX                          As Integer
    Dim h_ResY                          As Integer

    g_BackBuf.Lock g_EmptyRect, g_EmptySurfDesc, DDLOCK_WRITEONLY, 0
    
        h_ResX = g_App.ResX - 1
        h_ResY = g_App.ResY - 1
        
        For n = 1 To NUM_STAR_PLAINS
            With g_Map
                h_MoveX(n) = .StarMoveX * .StarSpeedFactor(n)
                h_MoveY(n) = .StarMoveY * .StarSpeedFactor(n)
            End With

            For m = 1 To g_Map.NumStars(n)
                With g_BackStar(n, m)
                    .X = .X + h_MoveX(n) * .Speed
                    .Y = .Y + h_MoveY(n) * .Speed
                                        
                    Do While .X < 0
                        .X = .X + h_ResX
                    Loop
                    
                    Do While .Y < 0
                        .Y = .Y + h_ResY
                    Loop
                    
                    Do While .X > h_ResX
                        .X = .X - h_ResX
                    Loop
                    
                    Do While .Y > h_ResY
                        .Y = .Y - h_ResY
                    Loop
                    
                    g_BackBuf.SetLockedPixel .X, .Y, .Color
                End With
            Next
        Next
    
    g_BackBuf.Unlock g_EmptyRect
    
    g_Map.StarMoveX = 0
    g_Map.StarMoveY = 0

End Sub
