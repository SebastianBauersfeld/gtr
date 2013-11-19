Attribute VB_Name = "m_003_MAIN_01"
Option Explicit

'Hier startet das Spiel
Public Sub GameEntry(ByVal GameMode As EGameMode)

    Init_App
    
    'Load frmMain
    
    'Init_DX
    Init_DD g_App.ResX, g_App.ResY, g_App.ColDepth
    Init_D3D g_App.ResX, g_App.ResY
    Init_DS
    Init_DI

    StartGame GameMode
    
    Unload_DI
    Unload_DP
    Unload_DD
    Unload_D3D
    Unload_DS
    'Unload_DX
        
End Sub

'App-Objekt initialisieren
Public Sub Init_App()

    With g_App
        .ResX = 1024
        .ResY = 768
        .ColDepth = 16
        .ScreenRect = SetRect(0, 0, .ResX, .ResY)
        .VSync = GetINIValue(App.Path & "\config.ini", "OPTIONS", "VSync")
        .ShowFPS = GetINIValue(App.Path & "\config.ini", "OPTIONS", "DrawFPS")
        .ShowDevInfos = True
        .GameState = GAME_STATE_MAINMENU
        .Path_Data = App.Path & "\data"
        .Path_Maps = App.Path & "\maps"
        .Path_Pics = App.Path & "\pictures"
        .Path_ScreenShots = App.Path & "\screenshots"
        .Path_Sounds = App.Path & "\sounds"
        .Path_Textures = App.Path & "\textures"
        .Path_TilePics = .Path_Maps & "\tiles"
        .Path_Fonts = App.Path & "\fonts"
        .DecimalSeparator = GetPCSettings(&H16)
        
        'If .DecimalSeparator = "." Then
        '    .DecimalSeparator = ","
        'ElseIf .DecimalSeparator = "," Then
        '    .DecimalSeparator = "."
        'End If
        
        .CntScreenShots = 0
    End With

End Sub

'Hauptschleife für Spiel
Public Sub StartGame(ByVal GameMode As EGameMode)

    g_App.GameState = GAME_STATE_GAME

    Select Case GameMode
        Case GAME_MODE_SP_DEATHMATCH                'SinglePlayer-Deathmatch
            
            g_App.GameMode = GAME_MODE_SP_DEATHMATCH
            Init_SP_DeathMatch
                        
            Do While g_App.GameState = GAME_STATE_GAME
                GetInput
                Draw_SP_DeathMatch
            Loop
            
            Unload_SP_DeathMatch
            
        Case GAME_MODE_MP_DEATHMATCH                'MultiPlayer-Deathmatch
            
            g_App.GameMode = GAME_MODE_MP_DEATHMATCH
            Init_MP_DeathMatch
                        
            Do While g_App.GameState = GAME_STATE_GAME
                GetInput
                Draw_MP_DeathMatch
            Loop
            
            Unload_MP_DeathMatch
            
    End Select
    
End Sub

'initialisiert SinglePlayer DeathMatch
Public Sub Init_SP_DeathMatch()

    Dim n As Long
    
    'Zufallsgenerator
    Randomize
    
    'Anwendung
    With g_App
        .IsServer = True
        .GameSpeed = DEFAULT_GAMESPEED
        .TargetGameSpeed = .GameSpeed
    End With
    
    'Tastenbelegung
    Load_KeyConfig
    
    'Konsole, MsgBoard und FPS
    Init_Console
    Init_MsgBoard
    Init_FPSCalculation g_App.FPS
            
    'Schriften laden
   
    
    For n = 1 To 3
        Load_Font g_App.Path_Fonts & "\" & Format(n, "000") & ".fnt", g_App.Path_Fonts & "\" & Format(n, "000") & ".bmp", g_TextFont(n), KEY_COL_GREEN
    Next
    
    Input_Console "load Fonts"
    Draw_Console True, False, g_TextFont(2)
    
    
    
    'Items laden
    Load_Items
    SetEvent g_Map.CreateItemEvent, ITEM_CREATE_DELAY
    
    'Waffen laden
    Load_WeaponTypes
    
    'Player initialisieren und Surfaces laden
    g_PlrCnt = 0
    g_MyPlrID = 1
    Load_ShipTypes
    Calc_ShipFrameTrigonometry
    
    For n = 1 To NUM_SHIP_TYPES
        Load_Surf g_App.Path_Pics & "\player" & Format(n, "00") & ".bmp", g_ShipSurf(n), KEY_COL_BLACK
    Next
    
    Add_Player GetINIValue(App.Path & "\config.ini", "Player", "Ship"), Trim(GetINIValue(App.Path & "\config.ini", "Player", "Name")), GetINIValue(App.Path & "\config.ini", "Player", "Team")
    
    For n = 2 To GetINIValue(App.Path & "\config.ini", "Server", "BotNumber") + 1
        Add_Player Int(Rnd * 6) + 1, GetBotname, Int(Rnd * 4) + 1
        Init_Bot g_Plr(n)
    Next
        
    'Spectator
    With g_Spectator
        Init_Spectator
        SetEvent .ShowMapDescEvent, 0, SPECTATOR_MAP_DESC_DURATION
        SetEvent .ShowModeEvent, SPECTATOR_MAP_DESC_DURATION, SPECTATOR_SHOWMODE_DURATION
        SetEvent .WaitEvent, 0, SPECTATOR_WAIT_DURATION
        .Wait = True
    End With
    
    g_App.PlayerState = PLAYER_STATE_SPECTATOR
    
    'ScoreBoard
    Init_ScoreBoard
    
    'HUD
    Init_Hud
    
    InitEffects
    
    InitSpecialEffects
    
    If UseShockWaves Then
        InitWaves
        InitWaveNet g_App.Path_Pics & "\e256.bmp"
    End If
    
    'InitBlurNet g_App.Path_Pics & "\e256.bmp"

    'Kollisionsabfrage
    Fill_HDCollisionSet g_ShipSurf(2)
    Fill_LDCollisionSets
    Fill_WeaponCollisionSets
        
    'KillBoard
    Init_KillBoard
    
    'Map laden
    Load_Map GetINIValue(App.Path & "\config.ini", "SERVER", "Map")

    'Radar
    Init_Radar

    'HintergrundSterne
    Init_BackStars
        
End Sub

'fährt SinglePlayer DeathMatch herunter
Public Sub Unload_SP_DeathMatch()
    
    Dim n As Long
    Dim m As Long
    
    'Player-Surfaces entladen
    For n = 1 To NUM_SHIP_TYPES
        Unload_Surf g_ShipSurf(n)
    Next
    
    'Tile-Bilder entladen
    For n = 1 To NUM_MAP_PLAINS
        For m = 1 To g_Map.SurfCount(n)
            Unload_Surf g_MapTileSurf(n, m)
        Next
    Next
    
    'Radar-Bilder entladen
    For n = 1 To g_Map.SurfCount(3)
        Unload_Surf g_RadarMapTileSurf(n)
    Next
    
    Unload_Surf g_RadarCameraSurf
    Unload_Surf g_RadarFriendSurf
    Unload_Surf g_RadarEnemySurf
    Unload_Surf g_RadarItemSurf
    
    'WaffenSurfaces entladen
    For n = 1 To NUM_WEAPON_SURFS
        Unload_Surf g_WeaponSurf(n)
    Next
    
    'ItemSurfaces entladen
    For n = 1 To NUM_ITEM_TYPES
        Unload_Surf g_ItemSurf(n)
    Next
    
    'KillBoardSurfs entladen
    For n = 1 To NUM_WEAPON_SURFS
        Unload_Surf g_KillBoardWeaponSurf(n)
    Next
    
    Unload_Surf g_KillBoardSkullSurf
    Unload_Surf g_KillBoardCrashSurf
    
    'DestroyableMap
    If MapIsDestroyable Then
        For n = 1 To MAX_X_MAPTILES
            For m = 1 To MAX_Y_MAPTILES
                Unload_Surf g_DMapTile(n, m).Pic
            Next m
        Next
    End If
    
    For n = 1 To 4
        Unload_Surf DestroyMapSurf(n)
    Next
    
    'Effekte
    Set EffectTexture(1) = Nothing
    Set EffectTexture(2) = Nothing
    Set LightTexture = Nothing
    
    'Text-Surfs entladen
    For n = 1 To 3
        Unload_Surf g_TextFont(n).Surf
    Next n
    
End Sub

'zeichnet SinglePlayer DeathMatch
Public Sub Draw_SP_DeathMatch()
    
    Dim n As Long
    
    'Spielgeschwindigkeit setzen
    Change_GameSpeed
    
    'FPS-Berechnungen
    With g_App
        GetFPS .FPS
        .AVF = GetAVF(.FPS)
        .AVFGS = GetAVF(.FPS, .GameSpeed)
        .AVSlowGS = GetAVAcc(0.99, .AVFGS)
    End With
    
    'Bildschirm löschen
    g_D3DDev.Clear 1, g_RectViewport(), D3DCLEAR_TARGET, g_Map.BackCol, 1, 0
    'g_BackBuf.BltColorFill g_EmptyRect, g_Map.BackCol
            
        'Spectator und Player1
        If g_App.PlayerState = PLAYER_STATE_SPECTATOR Then
            Move_Spectator
        ElseIf g_App.PlayerState = PLAYER_STATE_INGAME Then
            Control_UserShip
        End If
        
        'Bots
        Control_Bots
        
        'Items
        Control_Items
        Control_ItemTimers
                                                        
        'Ebene1
        If g_Map.PlainNeed(1) Then Draw_MapPlain 1
        
        'HintergrundSterne
        If g_Map.DrawStars Then Draw_BackStars
        
        'Ebene2
        If g_Map.PlainNeed(2) Then Draw_MapPlain 2
        
        'Items zeichnen
        Draw_Items
        
        'Impulse zeichnen
        If DrawImpulse Then
            For n = 1 To g_PlrCnt
                Impulse(n).InfiniteSpread = g_Plr(n).Accelerating
                Impulse(n).Draw = True
                DrawEffect Impulse(n), EffectTexture(1)
                g_Plr(n).Accelerating = False
            Next
        End If
        
        'Waffen zeichnen
        Draw_Weapons
        
        'Player zeichnen
        Draw_Players
        
        'Ebene3
        If g_Map.PlainNeed(3) Then
            If MapIsDestroyable Then
                Draw_DMap
            Else
                Draw_MapPlain 3
            End If
        End If
                                        
        SetCam
        
        If UseLights Then Draw_Weapon_Lights

        For n = 1 To MAX_RESPAWN_EFFECTS
            If UseLights Then
                If RespawnLight(n).Draw Then
                    DrawLight RespawnLight(n), EffectTexture(1)
                End If
            End If
            If DrawRespawnEffect Then
                If RespawnEffect(n).Draw Then
                    DrawEffect RespawnEffect(n), EffectTexture(1)
                End If
            End If
        Next n
        
        For n = 1 To MAX_SMALL_EXPLOSIONS
            If UseLights Then
                If WeaponExploLight(n).Draw Then
                    DrawLight WeaponExploLight(n), EffectTexture(1)
                End If
            End If
            If SmallExplosion(n).Draw Then
                DrawEffect SmallExplosion(n), EffectTexture(1)
            End If
        Next n
        
        For n = 1 To MAX_WALL_PUFFS
            If WallPuff(n).Draw Then
                DrawEffect WallPuff(n), EffectTexture(2)
            End If
        Next n
        
        For n = 1 To MAX_BIG_EXPLOSIONS
            If UseLights Then
                If ShipExploLight(n).Draw Then
                    DrawLight ShipExploLight(n), EffectTexture(1)
                End If
            End If
            If BigExplosion(n).Draw Then
                DrawEffect BigExplosion(n), EffectTexture(1)
            End If
        Next n
        
        For n = 1 To MAX_WAVE_EXPLOSIONS
            If ExplosionWave(n).Draw Then
                DrawEffect ExplosionWave(n), EffectTexture(2)
            End If
        Next n
                                        
        'Ebene4
        If g_Map.PlainNeed(4) Then Draw_MapPlain 4
                    
        'Kollisionsabfrage
        Check_ShipCollisions
        
        For n = 1 To g_PlrCnt
            If g_Plr(n).Draw Then
                If n = g_MyPlrID Then
                    Check_UserCollision
                Else
                    Check_BotCollision g_Plr(n)
                End If
            End If
        Next
        
        Check_WeaponCollisions
        Check_ItemCollision
                    
        'Wellen
        If UseShockWaves Then
            MoveWaves Wave, 1, WaveUBound
            If AreWavesVisible(Wave, 1, WaveUBound) Then
                DrawWaveNet
            End If
        End If
        
        'DrawBlurNet 0.6
        
        'RefreshBlurTextures
                    
        'HUD
        If g_HUD.Draw Then Draw_Hud
                    
        'Radar
        If g_Radar.Draw Then Draw_Radar
                    
        'Spectator-Infos
        With g_Spectator
            If g_Spectator.ShowMapDesc Then Draw_TextBlock Trim(g_Map.Description), g_App.ResX * 0.5 - 200, g_App.ResY * 0.5 - 100, 400, g_TextFont(1), TEXT_ALIGNMENT_CENTERED
            
            If g_Spectator.ShowMode Then
                If g_Spectator.SpectatorMode = SPECTATOR_MODE_FREE Then
                    Blit_Text g_App.ResX * 0.5 - GetTextWidth("Free-Look-Mode", g_TextFont(1)) * 0.5, g_App.ResY * 0.5, "Free-Look-Mode", g_TextFont(1)
                ElseIf g_Spectator.SpectatorMode = SPECTATOR_MODE_TIGHT Then
                    Blit_Text g_App.ResX * 0.5 - GetTextWidth("Tight-Look-Mode", g_TextFont(1)) * 0.5, g_App.ResY * 0.5, "Tight-Look-Mode", g_TextFont(1)
                End If
            End If
        End With
        
        'MsgBoard
        If g_MsgBoard.Draw Then Draw_MsgBoard g_TextFont(1)
                
        'KillBoard
        Draw_KillBoard
        
        'ScoreBoard
        If g_ScoreBoard.Draw Then Draw_ScoreBoard
        
        'Konsole
        If g_Console.Draw Then
            Move_Console
            Draw_Console False, True, g_TextFont(1)
        End If
                
        'unabhängige Nachrichten
        Blit_Msgs
                                
        'FPS
        If g_App.ShowFPS Then Blit_Text 2, 2, Int(g_App.FPS), g_TextFont(1)
        
        Draw_Way
        DrawCollPoints
        Blit_Text 10, 550, g_Plr(g_MyPlrID).Shields, g_TextFont(1)
        Blit_Text 50, 550, Int(g_Plr(g_MyPlrID).Weapon(1).Munition), g_TextFont(1)
        Blit_Text 100, 550, Int(g_Plr(g_MyPlrID).Weapon(2).Munition), g_TextFont(1)
        Blit_Text 150, 550, Int(g_Plr(g_MyPlrID).Weapon(3).Munition), g_TextFont(1)
        
        If g_Spectator.CurrentPlayer > 1 And g_Spectator.CurrentPlayer < g_PlrCnt Then
            Blit_Text 10, 50, g_Plr(g_Spectator.CurrentPlayer).MoveX, g_TextFont(1)
            Blit_Text 10, 70, g_Plr(g_Spectator.CurrentPlayer).MoveY, g_TextFont(1)
        End If
        
    g_FrontBuf.Flip g_BackBuf, DDFLIP_NOVSYNC
    
End Sub

'initialisiert MultiPlayer DeathMatch
Public Sub Init_MP_DeathMatch()

    Dim n As Long
    
    'Zufallsgenerator
    Randomize
    
    'Anwendung
    With g_App
        '.IsServer = CBool(GetINIValue(App.Path & "\config.ini", "OPTIONS", "IsServer"))
        .GameSpeed = DEFAULT_GAMESPEED
        .TargetGameSpeed = .GameSpeed
        .SendDelay = GetINIValue(App.Path & "\config.ini", "OPTIONS", "AveragePing")
        SetEvent .SendEvent, .SendDelay, 0
    End With
    
    'Tastenbelegung
    Load_KeyConfig
    
    'Konsole, MsgBoard und FPS
    Init_Console
    Init_MsgBoard
    Init_FPSCalculation g_App.FPS
    
    'Schriften laden
    For n = 1 To 3
        Load_Font g_App.Path_Fonts & "\" & Format(n, "000") & ".fnt", g_App.Path_Fonts & "\" & Format(n, "000") & ".bmp", g_TextFont(n), KEY_COL_GREEN
    Next
    
    'Items laden
    Load_Items
    SetEvent g_Map.CreateItemEvent, ITEM_CREATE_DELAY
    
    'Waffen laden
    Load_WeaponTypes
    
    'Player initialisieren und Surfaces laden
    Load_ShipTypes
    Calc_ShipFrameTrigonometry
    
    For n = 1 To NUM_SHIP_TYPES
        Load_Surf g_App.Path_Pics & "\player" & Format(n, "00") & ".bmp", g_ShipSurf(n), KEY_COL_BLACK
    Next
    
    Add_NetPlayers
    
    'Spectator
    With g_Spectator
        Init_Spectator
        SetEvent .ShowMapDescEvent, 0, SPECTATOR_MAP_DESC_DURATION
        SetEvent .ShowModeEvent, SPECTATOR_MAP_DESC_DURATION, SPECTATOR_SHOWMODE_DURATION
        SetEvent .WaitEvent, 0, SPECTATOR_WAIT_DURATION
        .Wait = True
    End With
    
    g_App.PlayerState = PLAYER_STATE_SPECTATOR
    
    'ScoreBoard
    Init_ScoreBoard
    
    'HUD
    Init_Hud
    
    InitEffects
    
    InitSpecialEffects
    
    If UseShockWaves Then
        InitWaves
        InitWaveNet g_App.Path_Pics & "\e256.bmp"
    End If
    
    'InitBlurNet g_App.Path_Pics & "\e256.bmp"

    'Kollisionsabfrage
    Fill_HDCollisionSet g_ShipSurf(2)
    Fill_LDCollisionSets
    Fill_WeaponCollisionSets
        
    'KillBoard
    Init_KillBoard
    
    'Map laden
    Load_Map GetINIValue(App.Path & "\config.ini", "SERVER", "Map")

    'Radar
    Init_Radar

    'HintergrundSterne
    Init_BackStars
        
End Sub

'fährt MultiPlayer DeathMatch herunter
Public Sub Unload_MP_DeathMatch()
    
    Dim n As Long
    Dim m As Long
    
    'Player-Surfaces entladen
    For n = 1 To NUM_SHIP_TYPES
        Unload_Surf g_ShipSurf(n)
    Next
    
    'Tile-Bilder entladen
    For n = 1 To NUM_MAP_PLAINS
        For m = 1 To g_Map.SurfCount(n)
            Unload_Surf g_MapTileSurf(n, m)
        Next
    Next
    
    'Radar-Bilder entladen
    For n = 1 To g_Map.SurfCount(3)
        Unload_Surf g_RadarMapTileSurf(n)
    Next
    
    Unload_Surf g_RadarCameraSurf
    Unload_Surf g_RadarFriendSurf
    Unload_Surf g_RadarEnemySurf
    Unload_Surf g_RadarItemSurf
    
    'WaffenSurfaces entladen
    For n = 1 To NUM_WEAPON_SURFS
        Unload_Surf g_WeaponSurf(n)
    Next
    
    'ItemSurfaces entladen
    For n = 1 To NUM_ITEM_TYPES
        Unload_Surf g_ItemSurf(n)
    Next
    
    'KillBoardSurfs entladen
    For n = 1 To NUM_WEAPON_SURFS
        Unload_Surf g_KillBoardWeaponSurf(n)
    Next
    
    Unload_Surf g_KillBoardSkullSurf
    Unload_Surf g_KillBoardCrashSurf
    
    'DestroyableMap
    If MapIsDestroyable Then
        For n = 1 To MAX_X_MAPTILES
            For m = 1 To MAX_Y_MAPTILES
                Unload_Surf g_DMapTile(n, m).Pic
            Next m
        Next
    End If
    
    For n = 1 To 4
        Unload_Surf DestroyMapSurf(n)
    Next
    
    'Effekte
    Set EffectTexture(1) = Nothing
    Set EffectTexture(2) = Nothing
    Set LightTexture = Nothing
    
    'Text-Surfs entladen
    For n = 1 To 3
        Unload_Surf g_TextFont(n).Surf
    Next n
    
    'Spieler abmelden
    Destroy_NetPlayers
    
End Sub

'zeichnet MultiPlayer DeathMatch
Public Sub Draw_MP_DeathMatch()
    
    Dim n As Long
    
    'NetzNachrichten empfangen
    If g_App.IsServer Then
        For n = 1 To g_PlrCnt
            If n = g_MyPlrID Or g_Plr(n).IsBot Then Receive_Msgs g_Plr(n).NetID
        Next n
    Else
        Receive_Msgs g_Plr(g_MyPlrID).NetID
    End If
    
    'Spielgeschwindigkeit setzen
    Change_GameSpeed
    
    'FPS-Berechnungen
    With g_App
        GetFPS .FPS
        .AVF = GetAVF(.FPS)
        .AVFGS = GetAVF(.FPS, .GameSpeed)
        .AVSlowGS = GetAVAcc(0.99, .AVFGS)
    End With
    
    'Bildschirm löschen
    g_D3DDev.Clear 1, g_RectViewport(), D3DCLEAR_TARGET, g_Map.BackCol, 1, 0
    'g_BackBuf.BltColorFill g_EmptyRect, g_Map.BackCol
            
        'Spectator und Player1
        If g_App.PlayerState = PLAYER_STATE_SPECTATOR Then
            Move_Spectator
        ElseIf g_App.PlayerState = PLAYER_STATE_INGAME Then
            Control_UserShip
        End If
        
        'Bots
        If g_App.IsServer Then Control_Bots
        
        'andere Player interpolieren
        Interpolate_Players
        
        'Items
        If g_App.IsServer Then Control_Items
        Control_ItemTimers
                                                        
        'Ebene1
        If g_Map.PlainNeed(1) Then Draw_MapPlain 1
        
        'HintergrundSterne
        If g_Map.DrawStars Then Draw_BackStars
        
        'Ebene2
        If g_Map.PlainNeed(2) Then Draw_MapPlain 2
        
        'Items zeichnen
        Draw_Items
        
        'Impulse zeichnen
        If DrawImpulse Then
            For n = 1 To g_PlrCnt
                Impulse(n).InfiniteSpread = g_Plr(n).Accelerating
                Impulse(n).Draw = True
                DrawEffect Impulse(n), EffectTexture(1)
            Next
        End If
        
        'Waffen zeichnen
        Draw_Weapons
        
        'Player zeichnen
        Draw_Players
        
        'Ebene3
        If g_Map.PlainNeed(3) Then
            If MapIsDestroyable Then
                Draw_DMap
            Else
                Draw_MapPlain 3
            End If
        End If
                                        
        SetCam
        
        If UseLights Then Draw_Weapon_Lights

        For n = 1 To MAX_RESPAWN_EFFECTS
            If UseLights Then
                If RespawnLight(n).Draw Then
                    DrawLight RespawnLight(n), EffectTexture(1)
                End If
            End If
            If DrawRespawnEffect Then
                If RespawnEffect(n).Draw Then
                    DrawEffect RespawnEffect(n), EffectTexture(1)
                End If
            End If
        Next n
        
        For n = 1 To MAX_SMALL_EXPLOSIONS
            If UseLights Then
                If WeaponExploLight(n).Draw Then
                    DrawLight WeaponExploLight(n), EffectTexture(1)
                End If
            End If
            If SmallExplosion(n).Draw Then
                DrawEffect SmallExplosion(n), EffectTexture(1)
            End If
        Next n
        
        For n = 1 To MAX_WALL_PUFFS
            If WallPuff(n).Draw Then
                DrawEffect WallPuff(n), EffectTexture(2)
            End If
        Next n
        
        For n = 1 To MAX_BIG_EXPLOSIONS
            If UseLights Then
                If ShipExploLight(n).Draw Then
                    DrawLight ShipExploLight(n), EffectTexture(1)
                End If
            End If
            If BigExplosion(n).Draw Then
                DrawEffect BigExplosion(n), EffectTexture(1)
            End If
        Next n
        
        For n = 1 To MAX_WAVE_EXPLOSIONS
            If ExplosionWave(n).Draw Then
                DrawEffect ExplosionWave(n), EffectTexture(2)
            End If
        Next n
                                        
        'Ebene4
        If g_Map.PlainNeed(4) Then Draw_MapPlain 4
                    
        'Kollisionsabfrage
        Check_ShipCollisions_Net
        
        For n = 1 To g_PlrCnt
            If g_Plr(n).Draw Then
                If n = g_MyPlrID Then
                    Check_UserCollision
                ElseIf g_Plr(n).IsBot Then
                    Check_BotCollision g_Plr(n)
                End If
            End If
        Next
        
        Check_WeaponCollisions_Net
        If g_App.IsServer Then Check_ItemCollision
        
        'Nachrichten Senden
        Send_GameData
        
        'Beschleunigungsvariablen auf false setzen
        g_Plr(g_MyPlrID).Accelerating = False
        
        For n = 1 To g_PlrCnt
            If g_Plr(n).IsBot Then g_Plr(n).Accelerating = False
        Next
        
        'Wellen
        If UseShockWaves Then
            MoveWaves Wave, 1, WaveUBound
            If AreWavesVisible(Wave, 1, WaveUBound) Then
                DrawWaveNet
            End If
        End If
        
        'DrawBlurNet 0.6
        
        'RefreshBlurTextures
                
        'HUD
        If g_HUD.Draw Then Draw_Hud
                    
        'Radar
        If g_Radar.Draw Then Draw_Radar
                    
        'Spectator-Infos
        With g_Spectator
            If g_Spectator.ShowMapDesc Then Draw_TextBlock Trim(g_Map.Description), g_App.ResX * 0.5 - 200, g_App.ResY * 0.5 - 100, 400, g_TextFont(1), TEXT_ALIGNMENT_CENTERED
            
            If g_Spectator.ShowMode Then
                If g_Spectator.SpectatorMode = SPECTATOR_MODE_FREE Then
                    Blit_Text g_App.ResX * 0.5 - GetTextWidth("Free-Look-Mode", g_TextFont(1)) * 0.5, g_App.ResY * 0.5, "Free-Look-Mode", g_TextFont(1)
                ElseIf g_Spectator.SpectatorMode = SPECTATOR_MODE_TIGHT Then
                    Blit_Text g_App.ResX * 0.5 - GetTextWidth("Tight-Look-Mode", g_TextFont(1)) * 0.5, g_App.ResY * 0.5, "Tight-Look-Mode", g_TextFont(1)
                End If
            End If
        End With
        
        'MsgBoard
        If g_MsgBoard.Draw Then Draw_MsgBoard g_TextFont(1)
                
        'KillBoard
        Draw_KillBoard
        
        'ScoreBoard
        If g_ScoreBoard.Draw Then Draw_ScoreBoard
        
        'Konsole
        If g_Console.Draw Then
            Move_Console
            Draw_Console False, True, g_TextFont(1)
        End If
                
        'unabhängige Nachrichten
        Blit_Msgs
                                
        'FPS
        If g_App.ShowFPS Then Blit_Text 2, 2, Int(g_App.FPS), g_TextFont(1)
        
        Draw_Way
        DrawCollPoints
        Blit_Text 10, 550, g_Plr(g_MyPlrID).Shields, g_TextFont(1)
        Blit_Text 50, 550, Int(g_Plr(g_MyPlrID).Weapon(1).Munition), g_TextFont(1)
        Blit_Text 100, 550, Int(g_Plr(g_MyPlrID).Weapon(2).Munition), g_TextFont(1)
        Blit_Text 150, 550, Int(g_Plr(g_MyPlrID).Weapon(3).Munition), g_TextFont(1)
        
        If g_Spectator.CurrentPlayer > 1 And g_Spectator.CurrentPlayer < g_PlrCnt Then
            Blit_Text 10, 50, g_Plr(g_Spectator.CurrentPlayer).MoveX, g_TextFont(1)
            Blit_Text 10, 70, g_Plr(g_Spectator.CurrentPlayer).MoveY, g_TextFont(1)
        End If
        
    g_FrontBuf.Flip g_BackBuf, DDFLIP_NOVSYNC
    
End Sub
