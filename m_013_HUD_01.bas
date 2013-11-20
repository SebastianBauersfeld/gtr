Attribute VB_Name = "m_015_HUD_01"
Option Explicit

'initialisiert den Radar und lädt die RadarTiles
Public Sub Init_Radar()

    Dim i               As Long
    Dim n               As Long
    Dim m               As Long
    Dim SurfDesc        As DDSURFACEDESC2
    Dim ColKey          As DDCOLORKEY

    With g_Radar
        .Draw = True
        .Width = g_App.ResX / 5
        .Height = g_App.ResY / 5
        .X = g_App.ResX - .Width
        .Y = g_App.ResY - .Height
        .PosRect = SetRect(.X, .Y, .X + .Width, .Y + .Height)
        
        .Vertex(1).X = .X / g_D3DDivX + g_D3DSubX
        .Vertex(1).Y = -.Y / g_D3DDivY + g_D3DSubY
        .Vertex(2).X = (.X + .Width) / g_D3DDivX + g_D3DSubX
        .Vertex(2).Y = -.Y / g_D3DDivY + g_D3DSubY
        .Vertex(3).X = .X / g_D3DDivX + g_D3DSubX
        .Vertex(3).Y = -(.Y + .Height) / g_D3DDivY + g_D3DSubY
        .Vertex(4).X = (.X + .Width) / g_D3DDivX + g_D3DSubX
        .Vertex(4).Y = -(.Y + .Height) / g_D3DDivY + g_D3DSubY
        
        .BlockWidth = g_Map.BlockWidth
        .BlockHeight = g_Map.BlockHeight
        .PixWidth = .BlockWidth * RADAR_TILE_WIDTH
        .PixHeight = .BlockHeight * RADAR_TILE_WIDTH
                
        .StretchFX = .PixWidth / g_Map.PixelWidth(3)
        .StretchFY = .PixHeight / g_Map.PixelHeight(3)
                
        SetRadarWnd 0, 0
                
        'Tiles anordnen
        For n = 1 To MAX_X_MAPTILES
            For m = 1 To MAX_Y_MAPTILES
                With g_RadarMapTile(n, m)
                    .VX = (n - 1) * RADAR_TILE_WIDTH
                    .VY = (m - 1) * RADAR_TILE_WIDTH
                    .Type = g_MapTile(3, n, m).Type
                End With
            Next
        Next
        
        'Tile-Surfaces laden
        With SurfDesc
            .lFlags = DDSD_CAPS
            .lFlags = .lFlags Or DDSD_WIDTH Or DDSD_HEIGHT
            .lWidth = RADAR_TILE_WIDTH
            .lHeight = RADAR_TILE_WIDTH
            .ddsCaps.lCaps = DDSCAPS_OFFSCREENPLAIN
        End With
        
        ColKey.low = KEY_COL_BLACK
        ColKey.high = KEY_COL_BLACK
        
        For i = 1 To g_Map.SurfCount(3)
            With g_RadarMapTileSurf(i)
                Set .Surf = g_DD.CreateSurface(SurfDesc)
                .Surf.BltColorFill g_EmptyRect, 0
                .Surf.Blt g_EmptyRect, g_MapTileSurf(3, i).Surf, g_EmptyRect, DDBLT_WAIT
                .Width = SurfDesc.lWidth
                .Height = SurfDesc.lHeight
                
                'alles Grün machen
                .Surf.Lock g_EmptyRect, g_EmptySurfDesc, DDLOCK_WRITEONLY, 0
                    For n = 0 To .Width - 1
                        For m = 0 To .Height - 1
                            If .Surf.GetLockedPixel(n, m) Then .Surf.SetLockedPixel n, m, RADAR_TILE_COL
                        Next
                    Next
                .Surf.Unlock g_EmptyRect
                
                'ColorKey setzen
                .Surf.SetColorKey DDCKEY_SRCBLT, ColKey
            End With
        Next
        
        'verschiedene Surfaces laden
        Load_Surf g_App.Path_Pics & "\radar_own_pos.bmp", g_RadarCameraSurf, KEY_COL_GREEN
        Load_Surf g_App.Path_Pics & "\radar_enemy.bmp", g_RadarEnemySurf, KEY_COL_GREEN
        Load_Surf g_App.Path_Pics & "\radar_friend.bmp", g_RadarFriendSurf, KEY_COL_GREEN
        Load_Surf g_App.Path_Pics & "\radar_item.bmp", g_RadarItemSurf, KEY_COL_GREEN
                               
    End With

End Sub

'setzt ViewRect des Radars
Public Sub SetRadarWnd(ByVal CameraX As Single, ByVal CameraY As Single)

    Dim X       As Single
    Dim Y       As Single

    With g_Radar
        .CameraX = CameraX * .StretchFX
        .CameraY = CameraY * .StretchFY
                                
        X = .CameraX - .Width * 0.5
        Y = .CameraY - .Height * 0.5

        If X > .PixWidth - .Width Then X = .PixWidth - .Width
        If X < 0 Then X = 0
        If Y > .PixHeight - .Height Then Y = .PixHeight - .Height
        If Y < 0 Then Y = 0

        With .Wnd
            .Left = X
            .Top = Y
            .Right = .Left + g_Radar.Width
            .Bottom = .Top + g_Radar.Height

            If .Right > g_Radar.PixWidth Then .Right = g_Radar.PixWidth
            If .Bottom > g_Radar.PixHeight Then .Bottom = g_Radar.PixHeight
        End With
    End With

End Sub

'Holt sich Infos über Player und Items
Public Sub Draw_RadarInfos()

    Dim n               As Long
    Dim h_VX            As Single
    Dim h_VY            As Single
    Dim h_RX            As Integer
    Dim h_RY            As Integer
    Dim h_RadarLeft     As Integer
    Dim h_RadarTop      As Integer

    With g_Radar
        
        h_RadarLeft = .X - .Wnd.Left '- g_RadarEnemySurf.Width * 0.5
        h_RadarTop = .Y - .Wnd.Top '- g_RadarEnemySurf.Height * 0.5
        
        'feindliche und verbündete Player zeichnen
        For n = 1 To g_PlrCnt
            If n <> g_MyPlrID And g_Plr(n).Draw Then
                h_VX = g_Plr(n).VX * .StretchFX
                h_VY = g_Plr(n).VY * .StretchFY
                
                If IsInRectSng(.Wnd, h_VX, h_VY, g_RadarFriendSurf.Width, g_RadarFriendSurf.Height) Then
                    h_RX = h_RadarLeft + h_VX
                    h_RY = h_RadarTop + h_VY
                    
                    If g_Plr(g_MyPlrID).TeamID = 0 Or g_Plr(g_MyPlrID).TeamID <> g_Plr(n).TeamID Then
                        Blit_ClippedSurf .PosRect, h_RX, h_RY, g_RadarEnemySurf
                    Else
                        Blit_ClippedSurf .PosRect, h_RX, h_RY, g_RadarFriendSurf
                    End If
                End If
            End If
        Next
        
        'Items zeichnen
        For n = 1 To g_Map.ItemCnt
            h_VX = g_Item(n).VX * .StretchFX
            h_VY = g_Item(n).VY * .StretchFY
            
            If IsInRectSng(.Wnd, h_VX, h_VY, g_RadarItemSurf.Width, g_RadarItemSurf.Height) Then
                h_RX = .X + h_VX - .Wnd.Left
                h_RY = .Y + h_VY - .Wnd.Top
                
                Blit_ClippedSurf .PosRect, h_RX, h_RY, g_RadarItemSurf
            End If
        Next
        
        'Kamera position zeichnen
        h_RX = .X + .CameraX - g_RadarCameraSurf.Width * 0.5 - .Wnd.Left
        h_RY = .Y + .CameraY - g_RadarCameraSurf.Height * 0.5 - .Wnd.Top
        Blit_ClippedSurf .PosRect, h_RX, h_RY, g_RadarCameraSurf
        
    End With

End Sub

'zeichnet den Radar
Public Sub Draw_Radar()
    
    Dim n               As Long
    Dim m               As Long
    Dim h_FromX         As Long
    Dim h_ToX           As Long
    Dim h_FromY         As Long
    Dim h_ToY           As Long
    Dim h_RX            As Integer
    Dim h_RY            As Integer
    Dim h_RadarLeft     As Single
    Dim h_RadarTop      As Single
    
    With g_Radar
        
        'PolygonHintergrund
        g_Material.emissive.r = 1 - g_HUD.Color.b
        g_Material.emissive.g = g_HUD.Color.g
        g_Material.emissive.b = 1 - g_HUD.Color.r
        
        With g_D3DDev
            subSetAlpha 1, A_SUBTRACT, False
            .SetMaterial g_Material
            
            .SetTexture 0, Nothing
            
            .BeginScene
                .DrawPrimitive D3DPT_TRIANGLESTRIP, D3DFVF_VERTEX, g_Radar.Vertex(1), 4, D3DDP_DEFAULT
            .EndScene
        End With
        
        'Tiles zeichnen
        h_FromX = .Wnd.Left \ RADAR_TILE_WIDTH + 1
        h_ToX = (.Wnd.Left + .Width - 1) \ RADAR_TILE_WIDTH + 1
        h_FromY = .Wnd.Top \ RADAR_TILE_WIDTH + 1
        h_ToY = (.Wnd.Top + .Height - 1) \ RADAR_TILE_WIDTH + 1
        
        h_RadarLeft = .X - .Wnd.Left
        h_RadarTop = .Y - .Wnd.Top
        
        For n = h_FromX To h_ToX
            For m = h_FromY To h_ToY
                With g_RadarMapTile(n, m)
                    If .Type Then
                        h_RX = Int(h_RadarLeft + .VX)
                        h_RY = Int(h_RadarTop + .VY)
                        Blit_ClippedSurf g_Radar.PosRect, h_RX, h_RY, g_RadarMapTileSurf(.Type)
                    End If
                End With
            Next
        Next
        
        'Player etc. zeichnen
        Draw_RadarInfos
                
        'Rahmen
        g_BackBuf.SetForeColor &HFFFF
        g_BackBuf.DrawBox .X, .Y, .X + .Width, .Y + .Height
                
    End With
    
End Sub

'initialisiert das Kill-Board
Public Sub Init_KillBoard()

    Dim n           As Long

    'Surfs laden
    For n = 1 To NUM_WEAPON_SURFS
        Load_Surf g_App.Path_Pics & "\killboard_weapon_" & Format(n, "000") & ".bmp", g_KillBoardWeaponSurf(n), KEY_COL_GREEN
    Next
    
    Load_Surf g_App.Path_Pics & "\killboard_skull.bmp", g_KillBoardSkullSurf, KEY_COL_GREEN
    Load_Surf g_App.Path_Pics & "\killboard_crash.bmp", g_KillBoardCrashSurf, KEY_COL_GREEN
    
    'Eigenschaften
    With g_KillBoard
        .Draw = CBool(GetINIValue(App.Path & "\config.ini", "OPTIONS", "DrawKillBoard"))
        .WritePos = 1
        .Top = 110
        .Right = g_App.ResX - 10
    End With
    
End Sub

'fügt einen Eintrag im KillBoard hinzu
Public Sub Add_KillBoard_Msg(ByVal KillType As EKillBoardMsgType, ByVal Name1 As String, Optional ByVal Name2 As String = "", Optional ByVal WeaponSurfID As Integer = 1)

    Dim n       As Long

    With g_KillBoard
        
        If .WritePos > NUM_KILLBOARD_MSGS Then
            .WritePos = NUM_KILLBOARD_MSGS
            
            For n = 1 To NUM_KILLBOARD_MSGS - 1
                .Info(n) = .Info(n + 1)
            Next
        End If
        
        With .Info(.WritePos)
            .Type = KillType
            .Info(1) = Name1
            .Info(2) = Name2
            .WeaponSurfID = WeaponSurfID
        End With
        
        .WritePos = .WritePos + 1
        SetEvent .RefreshEvent, KILLBOARD_REFRESH_DELAY
        
    End With

End Sub

'refresht das KillBoard
Public Sub Refresh_KillBoard()

    Dim n       As Long

    With g_KillBoard
        
        If GetEventStatus(.RefreshEvent) Then
            For n = 1 To NUM_KILLBOARD_MSGS - 1
                .Info(n) = .Info(n + 1)
            Next
            
            .WritePos = .WritePos - 1
            If .WritePos < 1 Then .WritePos = 1
            
            SetEvent .RefreshEvent, KILLBOARD_REFRESH_DELAY
        End If
        
    End With

End Sub

'zeichnet das KillBoard
Public Sub Draw_KillBoard()

    Dim n                   As Long
    Dim h_X                 As Integer
    Dim h_Y                 As Integer
    Dim TextWidth(1 To 2)   As Integer

    Refresh_KillBoard
    
    With g_KillBoard
        
        For n = 1 To .WritePos - 1
            With .Info(n)
            
                Select Case .Type
                    
                    Case KILLBOARD_KILL:
                        
                        TextWidth(1) = GetTextWidth(.Info(1), g_TextFont(1))
                        TextWidth(2) = GetTextWidth(.Info(2), g_TextFont(1))
                        
                        'Info1
                        h_X = g_KillBoard.Right - TextWidth(2) - 2 * KILLBOARD_SURF_DIST - _
                              g_KillBoardWeaponSurf(.WeaponSurfID).Width - TextWidth(1)
                        h_Y = g_KillBoard.Top + (n - 1) * KILLBOARD_LINE_DIST
                        
                        Blit_Text h_X, h_Y, .Info(1), g_TextFont(1)
                        
                        'Info2
                        h_X = g_KillBoard.Right - TextWidth(2)
                        
                        Blit_Text h_X, h_Y, .Info(2), g_TextFont(1)
                        
                        'Surf
                        h_X = h_X - g_KillBoardWeaponSurf(.WeaponSurfID).Width - KILLBOARD_SURF_DIST
                        h_Y = h_Y + GetTextHeight(g_TextFont(1)) * 0.5 - g_KillBoardWeaponSurf(.WeaponSurfID).Height * 0.5
                        
                        Blit_Surf h_X, h_Y, g_KillBoardWeaponSurf(.WeaponSurfID)
                        
                    Case KILLBOARD_CRASH:
                        
                        TextWidth(1) = GetTextWidth(.Info(1), g_TextFont(1))
                        TextWidth(2) = GetTextWidth(.Info(2), g_TextFont(1))
                        
                        'Info1
                        h_X = g_KillBoard.Right - TextWidth(2) - 2 * KILLBOARD_SURF_DIST - _
                              g_KillBoardCrashSurf.Width - TextWidth(1)
                        h_Y = g_KillBoard.Top + (n - 1) * KILLBOARD_LINE_DIST
                        
                        Blit_Text h_X, h_Y, .Info(1), g_TextFont(1)
                        
                        'Info2
                        h_X = g_KillBoard.Right - TextWidth(2)
                        
                        Blit_Text h_X, h_Y, .Info(2), g_TextFont(1)
                        
                        'Surf
                        h_X = h_X - g_KillBoardCrashSurf.Width - KILLBOARD_SURF_DIST
                        h_Y = h_Y + GetTextHeight(g_TextFont(1)) * 0.5 - g_KillBoardCrashSurf.Height * 0.5
                        
                        Blit_Surf h_X, h_Y, g_KillBoardCrashSurf
                        
                    Case KILLBOARD_SUICIDE:
                        
                        TextWidth(1) = GetTextWidth(.Info(1), g_TextFont(1))
                        
                        'Info1
                        h_X = g_KillBoard.Right - TextWidth(1)
                        h_Y = g_KillBoard.Top + (n - 1) * KILLBOARD_LINE_DIST
                        
                        Blit_Text h_X, h_Y, .Info(1), g_TextFont(1)
                                                
                        'Surf
                        h_X = h_X - g_KillBoardSkullSurf.Width - KILLBOARD_SURF_DIST
                        h_Y = h_Y + GetTextHeight(g_TextFont(1)) * 0.5 - g_KillBoardSkullSurf.Height * 0.5
                        
                        Blit_Surf h_X, h_Y, g_KillBoardSkullSurf
                                                
                End Select
                
            End With
        Next
        
    End With

End Sub

'initialisiert Hud
Public Sub Init_Hud()
    
    Dim n As Long
    
    With g_Team(0).Color
        .r = 1
        .g = 1
        .b = 1
    End With
    With g_Team(1).Color
        .r = 0
        .g = 0
        .b = 1
    End With
    With g_Team(2).Color
        .r = 0
        .g = 1
        .b = 0
    End With
    With g_Team(3).Color
        .r = 0.5
        .g = 0
        .b = 0
    End With
    With g_Team(4).Color
        .r = 1
        .g = 1
        .b = 0
    End With

    With g_HUD
    
        .DrawTargeting = True
    
        Load_Texture g_App.Path_Pics & "\hud_speed.bmp", .Pic(1).Tex
        Load_Texture g_App.Path_Pics & "\hud_radar.bmp", .Pic(2).Tex
        Load_Texture g_App.Path_Pics & "\hud_shield.bmp", .Pic(3).Tex
        Load_Texture g_App.Path_Pics & "\hud_slots.bmp", .Pic(4).Tex
        Load_Texture g_App.Path_Pics & "\cross0" & CLng(GetINIValue(App.Path & "\config.ini", "OPTIONS", "TargetGUI")) & ".bmp", .Pic(7).Tex

        Load_Surf g_App.Path_Pics + "\hud_speedstrip.bmp", .SpeedDisp.Pic, KEY_COL_BLACK
        Load_Surf g_App.Path_Pics + "\hud_shieldstrip.bmp", .ShieldDisp.Pic, KEY_COL_BLACK
        
        .Draw = True
    
        .Color.a = StrToSng(GetINIValue(App.Path & "\config.ini", "OPTIONS", "HUDT"))
        .Color.r = StrToSng(GetINIValue(App.Path & "\config.ini", "OPTIONS", "HUDR")) * .Color.a
        .Color.g = StrToSng(GetINIValue(App.Path & "\config.ini", "OPTIONS", "HUDG")) * .Color.a
        .Color.b = StrToSng(GetINIValue(App.Path & "\config.ini", "OPTIONS", "HUDB")) * .Color.a
        
        .Pic(1).Width = 256
        .Pic(2).Width = 256
        .Pic(3).Width = 256
        .Pic(4).Width = 256
        .Pic(5).Width = 59
        .Pic(6).Width = 61
        .Pic(7).Width = 64
    
        .Pic(1).Height = 128
        .Pic(2).Height = 128
        .Pic(3).Height = 256
        .Pic(4).Height = 64
        .Pic(5).Height = 15
        .Pic(6).Height = 15
        .Pic(7).Height = 64
    
        .Pic(1).X = 0
        .Pic(1).Y = g_App.ResY - .Pic(1).Height
        .Pic(2).X = g_App.ResX - .Pic(2).Width
        .Pic(2).Y = 0
        .Pic(3).X = g_App.ResX - .Pic(3).Width
        .Pic(3).Y = g_App.ResY - .Pic(3).Height
        .Pic(4).X = (g_App.ResX - .Pic(4).Width) / 2
        .Pic(4).Y = g_App.ResY - .Pic(4).Height
        .Pic(5).X = g_App.ResX - 125
        .Pic(5).Y = 71
        .Pic(6).X = g_App.ResX - 67
        .Pic(6).Y = 71
        .Pic(7).X = 0
        .Pic(7).Y = 0
       
        For n = 1 To 7
            With .Pic(n)
                .Vertex(1).X = .X / g_D3DDivX + g_D3DSubX: .Vertex(1).tu = 0
                .Vertex(1).Y = -.Y / g_D3DDivY + g_D3DSubY: .Vertex(1).tv = 0
                .Vertex(1).Z = 0
                .Vertex(2).X = (.X + .Width) / g_D3DDivX + g_D3DSubX: .Vertex(2).tu = 1
                .Vertex(2).Y = -.Y / g_D3DDivY + g_D3DSubY: .Vertex(2).tv = 0
                .Vertex(2).Z = 0
                .Vertex(3).X = .X / g_D3DDivX + g_D3DSubX: .Vertex(3).tu = 0
                .Vertex(3).Y = -(.Y + .Height) / g_D3DDivY + g_D3DSubY: .Vertex(3).tv = 1
                .Vertex(3).Z = 0
                .Vertex(4).X = (.X + .Width) / g_D3DDivX + g_D3DSubX: .Vertex(4).tu = 1
                .Vertex(4).Y = -(.Y + .Height) / g_D3DDivY + g_D3DSubY: .Vertex(4).tv = 1
                .Vertex(4).Z = 0
            End With
        Next
        
        With .SpeedDisp
            .Pic.Width = 174
            .Pic.Height = 47
            .X = 15
            .Y = g_App.ResY - .Pic.Height - 7
            .iRect = SetRectPiece(0, 0, .Pic.Width, .Pic.Height)
        End With
    
        With .ShieldDisp
            .Pic.Width = 46
            .Pic.Height = 34
            .X = 865
            .Y = 15
            .iRect = SetRectPiece(0, 0, .Pic.Width, .Pic.Height)
        End With

    End With
    
End Sub

'Hud zeichnen
Public Sub Draw_Hud()
    
    Dim TMP As Long
    Dim TMPS As Single
    
    g_BackBuf.SetForeColor &HFFFFFF
    
    With g_HUD
        g_Material.emissive = g_HUD.Color
        g_D3DDev.SetMaterial g_Material

        subSetAlpha 1, A_ADD, False

        g_D3DDev.BeginScene
            g_D3DDev.SetTexture 0, .Pic(1).Tex
            g_D3DDev.DrawPrimitive D3DPT_TRIANGLESTRIP, D3DFVF_VERTEX, .Pic(1).Vertex(1), 4, D3DDP_DEFAULT

            g_D3DDev.SetTexture 0, .Pic(2).Tex
            g_D3DDev.DrawPrimitive D3DPT_TRIANGLESTRIP, D3DFVF_VERTEX, .Pic(3).Vertex(1), 4, D3DDP_DEFAULT

            g_D3DDev.SetTexture 0, .Pic(3).Tex
            g_D3DDev.DrawPrimitive D3DPT_TRIANGLESTRIP, D3DFVF_VERTEX, .Pic(2).Vertex(1), 4, D3DDP_DEFAULT

            g_D3DDev.SetTexture 0, .Pic(4).Tex
            g_D3DDev.DrawPrimitive D3DPT_TRIANGLESTRIP, D3DFVF_VERTEX, .Pic(4).Vertex(1), 4, D3DDP_DEFAULT

        g_D3DDev.EndScene

        'Geschwindigkeitsanzeige
        With .SpeedDisp
            TMPS = PythA(g_Plr(g_MyPlrID).MoveX, g_Plr(g_MyPlrID).MoveY)
        
            Blit_Text 20, g_App.ResY - 80, CLng(TMPS * g_App.FPS * g_App.AVF), g_TextFont(3)
            Blit_Text 23 + GetTextWidth(CLng(TMPS * g_App.FPS * g_App.AVF), g_TextFont(3)), g_App.ResY - 70, "pps", g_TextFont(1)
            

            .iRect.Right = TMPS * .Pic.Width / g_ShipType(g_Plr(g_MyPlrID).Type).MaxSpeed
            If .iRect.Right > .Pic.Width Then .iRect.Right = .Pic.Width

            g_BackBuf.BltFast .X, .Y, .Pic.Surf, .iRect, DDBLTFAST_SRCCOLORKEY
        End With

        'Schildanzeige
        With .ShieldDisp
            TMP = g_Plr(g_MyPlrID).Shields
            If TMP < 0 Then TMP = 0
            Blit_Text g_App.ResX - 80, 20, Format(TMP, "000"), g_TextFont(3)

            .iRect.Top = .Pic.Height - .Pic.Height * (g_Plr(g_MyPlrID).Shields / g_ShipType(g_Plr(g_MyPlrID).Type).Shields)

            g_BackBuf.BltFast .X, .Y + .iRect.Top, .Pic.Surf, .iRect, DDBLTFAST_SRCCOLORKEY
        End With

        DrawTargeting

        DrawSkills

        Blit_Text 20, g_App.ResY - 56, "X: " & CLng(g_Plr(g_MyPlrID).MidX \ g_Map.TileWidth(3)) + 1, g_TextFont(1)
        Blit_Text 20, g_App.ResY - 47, "Y: " & CLng(g_Plr(g_MyPlrID).MidY \ g_Map.TileWidth(3)) + 1, g_TextFont(1)

        'Rectangle anpassen
'        Dim TempRect As RECT
'        TempRect = fctSetRect(0, 5, WeaponAnimWidth, WeaponHeight - 5)
'
'        BackBuffer.BltFast ResX / 2 - 16, ResY - 43, WeaponPic(Ship(1).WhichWeapon).Pic, TempRect, DDBLTFAST_SRCCOLORKEY
'
'        If WeaponConfig(Ship(1).WhichWeapon).IsEnergyWeapon = False Then
'            subDrawHudText (ResX - fctGetTextLen(Ship(1).WeaponsLeft(Ship(1).WhichWeapon), 2)) / 2, 745, Ship(1).WeaponsLeft(Ship(1).WhichWeapon), 2
'        Else
'            subDrawHudText (ResX - fctGetTextLen(Int(Ship(1).WeaponEnergy(Ship(1).WhichWeapon)), 2)) / 2, 745, Int(Ship(1).WeaponEnergy(Ship(1).WhichWeapon)), 2
'        End If
    End With

End Sub

'Skills über Player schreiben
Sub DrawSkills()
    
    Dim HS      As Single        'HighSkill
    Dim MyS     As Single        'My Skill
    Dim TMPS    As Single
    Dim n       As Long
    Dim T       As Long
        
    HS = 0
    For n = 1 To g_PlrCnt
        With g_Plr(n)
            T = g_DX.TickCount() - .StartTime
            
            If n <> g_MyPlrID Then
                If T = 0 Then T = 1
                
                TMPS = (.Frags * 2 - .Deaths) / T * 600000
                If TMPS > HS Then
                    HS = TMPS
                End If
            Else
                MyS = (.Frags * 2 - .Deaths) / T * 600000
            End If
        End With
    Next n
    
    If HS <= MyS Then
        With g_HUD.Pic(5)
            g_D3DDev.BeginScene
                g_Material.emissive.r = 0
                g_Material.emissive.g = 0
                g_Material.emissive.b = 0.5
                g_D3DDev.SetMaterial g_Material
                g_D3DDev.SetTexture 0, Nothing
                g_D3DDev.DrawPrimitive D3DPT_TRIANGLESTRIP, D3DFVF_VERTEX, .Vertex(1), 4, D3DDP_DEFAULT
            g_D3DDev.EndScene
            Blit_Text .X + 10, 70, Format(MyS, "0000"), g_TextFont(2)
        End With
        Blit_Text g_HUD.Pic(6).X + 10, 70, Format(HS, "0000"), g_TextFont(2)
    Else
        With g_HUD.Pic(6)
            g_D3DDev.BeginScene
                g_Material.emissive.r = 0
                g_Material.emissive.g = 0
                g_Material.emissive.b = 0.5
                g_D3DDev.SetMaterial g_Material
                g_D3DDev.SetTexture 0, Nothing
                g_D3DDev.DrawPrimitive D3DPT_TRIANGLESTRIP, D3DFVF_VERTEX, .Vertex(1), 4, D3DDP_DEFAULT
            g_D3DDev.EndScene
            Blit_Text .X + 10, 70, Format(MyS, "0000"), g_TextFont(2)
        End With
        Blit_Text g_HUD.Pic(5).X + 10, 70, Format(HS, "0000"), g_TextFont(2)
    End If

End Sub

'Targeting
Public Sub DrawTargeting()
    
    Dim TMPX As Single
    Dim TMPY As Single
    
    Dim n As Long
    
    For n = 1 To g_PlrCnt
        If g_Plr(n).Draw And n <> g_MyPlrID Then
            If IsInRectSng(g_Map.Wnd, g_Plr(n).VX, g_Plr(n).VY, g_Plr(n).Anim.FrameWidth, g_ShipSurf(g_Plr(n).Type).Height) Then
        
                TMPX = g_Plr(n).MidX - g_Map.Wnd.Left
                TMPY = g_Plr(n).MidY - g_Map.Wnd.Top
        
                With g_HUD.Pic(7)
                    .Vertex(1).X = (TMPX - 32) / g_D3DDivX + g_D3DSubX
                    .Vertex(1).Y = -(TMPY - 32) / g_D3DDivY + g_D3DSubY
                    .Vertex(1).Z = 0
                    .Vertex(2).X = (TMPX + 32) / g_D3DDivX + g_D3DSubX
                    .Vertex(2).Y = -(TMPY - 32) / g_D3DDivY + g_D3DSubY
                    .Vertex(2).Z = 0
                    .Vertex(3).X = (TMPX - 32) / g_D3DDivX + g_D3DSubX
                    .Vertex(3).Y = -(TMPY + 32) / g_D3DDivY + g_D3DSubY
                    .Vertex(3).Z = 0
                    .Vertex(4).X = (TMPX + 32) / g_D3DDivX + g_D3DSubX
                    .Vertex(4).Y = -(TMPY + 32) / g_D3DDivY + g_D3DSubY
                    .Vertex(4).Z = 0
                End With
        
                g_D3DDev.BeginScene
                    g_Material.emissive = g_Team(g_Plr(n).TeamID).Color
                    g_D3DDev.SetMaterial g_Material
                    
                    subSetAlpha 1, A_ADD, False
                
                    g_D3DDev.SetTexture 0, g_HUD.Pic(7).Tex
                    g_D3DDev.DrawPrimitive D3DPT_TRIANGLESTRIP, D3DFVF_VERTEX, g_HUD.Pic(7).Vertex(1), 4, D3DDP_DEFAULT
                g_D3DDev.EndScene
        
                Blit_Text TMPX - GetTextWidth(g_Plr(n).PlrName, g_TextFont(1)) / 2, TMPY - 45, g_Plr(n).PlrName, g_TextFont(1)
                Blit_Text TMPX + 34, TMPY - 5, Round(g_Plr(n).Shields), g_TextFont(1)
            End If
        End If
    Next n

End Sub

'ermittelt den Bot-Namen
Public Function GetBotname() As String

    Dim TMPStr As String
    Dim Ready As Boolean
    Dim m As Long
    
    Do
        TMPStr = Trim(GetINIValue(App.Path & "\config.ini", "BotNames", "Bot" & Format(Int(Rnd * 100) + 1, "000")))
        Ready = True
        
        For m = 1 To g_PlrCnt
            If TMPStr = g_Plr(m).PlrName Then
                Ready = False
                Exit For
            End If
        Next m
    
    Loop Until Ready
    
    GetBotname = TMPStr

End Function
