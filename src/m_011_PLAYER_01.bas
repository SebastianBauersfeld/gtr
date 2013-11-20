Attribute VB_Name = "m_012_PLAYER_01"
Option Explicit

'initialisiert den Spectator
Public Sub Init_Spectator()

    With g_Spectator
        .SpectatorMode = SPECTATOR_MODE_FREE
        .CurrentPlayer = 0
        .Speed = DEFAULT_SPECTATOR_SPEED
        SetEvent .ShowMapDescEvent, -1
        SetEvent .WaitEvent, -1
        SetEvent .ShowModeEvent, -1
        .Wait = False
        .ShowMapDesc = False
        .ShowMode = False
    End With

End Sub

Public Sub Switch_SpectatorMode()
    
    With g_Spectator
        If Not (g_App.PlayerState = PLAYER_STATE_SPECTATOR) Or .Wait Then Exit Sub
        
        If .SpectatorMode = SPECTATOR_MODE_FREE Then
            .SpectatorMode = SPECTATOR_MODE_TIGHT
            Scroll_PlayerFocus 1
        ElseIf .SpectatorMode = SPECTATOR_MODE_TIGHT Then
            .SpectatorMode = SPECTATOR_MODE_FREE
            Scroll_PlayerFocus 1
        End If
        
        SetEvent .ShowModeEvent, 0, SPECTATOR_SHOWMODE_DURATION
        SetEvent .ShowMapDescEvent, -1
    End With

End Sub

'steuert den Spectator
Public Sub Move_Spectator()
    
    Dim h_SpectSpeed        As Single
    Dim h_MoveX             As Single
    Dim h_MoveY             As Single
    
    With g_Spectator
        
        'Map-Beschreibung anzeigen
        .ShowMapDesc = GetEventStatus(.ShowMapDescEvent)
        
        'Modus anzeigen
        .ShowMode = GetEventStatus(.ShowModeEvent)
                
        'Abbrechen wenn im WarteModus
        .Wait = GetEventStatus(.WaitEvent)
        If .Wait Then Exit Sub
        
        'Steuerung im Free-Look-Mode
        If .SpectatorMode = SPECTATOR_MODE_FREE Then
            With g_Map
                                
                h_SpectSpeed = g_Spectator.Speed * g_App.AVF
                h_MoveX = 0
                h_MoveY = 0
                
                If GetCustomKeyState(CUSTOM_KEY_LEFT) Or GetCustomKeyState(CUSTOM_JOY_LEFT) Then _
                h_MoveX = h_MoveX - h_SpectSpeed
                
                If GetCustomKeyState(CUSTOM_KEY_UP) Or GetCustomKeyState(CUSTOM_JOY_UP) Then _
                h_MoveY = h_MoveY - h_SpectSpeed
                
                If GetCustomKeyState(CUSTOM_KEY_RIGHT) Or GetCustomKeyState(CUSTOM_JOY_RIGHT) Then _
                h_MoveX = h_MoveX + h_SpectSpeed
                
                If GetCustomKeyState(CUSTOM_KEY_DOWN) Or GetCustomKeyState(CUSTOM_JOY_DOWN) Then _
                h_MoveY = h_MoveY + h_SpectSpeed
                
                If Not g_Console.Draw Then
                    SetMapWnd .Wnd.Left + h_MoveX, .Wnd.Top + h_MoveY
                        
                    'SternBewegung
                    If .Wnd.Left > 0 And .Wnd.Right < .PixelWidth(3) Then .StarMoveX = -h_MoveX
                    If .Wnd.Top > 0 And .Wnd.Bottom < .PixelHeight(3) Then .StarMoveY = -h_MoveY
                    
                    'Radar-Wnd setzen
                    SetRadarWnd (.Wnd.Left + (.Wnd.Right - .Wnd.Left) * 0.5), (.Wnd.Top + (.Wnd.Bottom - .Wnd.Top) * 0.5)
                End If
                
            End With
            
        'andere Player beobachten
        ElseIf .SpectatorMode = SPECTATOR_MODE_TIGHT Then
            
            If g_PlrCnt < 1 Or .CurrentPlayer > g_PlrCnt Then
                Switch_SpectatorMode
                Exit Sub
            End If
            
            'SternBewegung
            With g_Map
                If .Wnd.Left > 0 And .Wnd.Right < .PixelWidth(3) Then .StarMoveX = -g_Plr(g_Spectator.CurrentPlayer).MoveX * g_App.AVFGS
                If .Wnd.Top > 0 And .Wnd.Bottom < .PixelHeight(3) Then .StarMoveY = -g_Plr(g_Spectator.CurrentPlayer).MoveY * g_App.AVFGS
            End With
            
            With g_Plr(.CurrentPlayer)
                'Focus
                SetMapWnd .MidX - g_App.ResX * 0.5, .MidY - g_App.ResY * 0.5
                
                'Radar
                SetRadarWnd .MidX, .MidY
            End With
            
        End If
        
    End With

End Sub

'Focus auf anderen Player setzen
Public Sub Scroll_PlayerFocus(ByVal Step As Integer)
    
    Dim n           As Long
    Dim m           As Long
    
    If Not (g_App.PlayerState = PLAYER_STATE_SPECTATOR) Or g_Spectator.Wait Or Not (g_Spectator.SpectatorMode = SPECTATOR_MODE_TIGHT) Then Exit Sub
    
    With g_Spectator
        .CurrentPlayer = .CurrentPlayer + Step
    
        'lebenden Player suchen
        m = .CurrentPlayer
        
        For n = 1 To g_PlrCnt
            If m > g_PlrCnt Then m = 1
            If m < 1 Then m = g_PlrCnt
            
            If g_Plr(m).Draw Then
                .CurrentPlayer = m
                Exit Sub
            End If
            
            m = m + Sgn(Step)
        Next
    
        'Keinen gefunden -> Modus wechseln
        Switch_SpectatorMode
        
    End With
    
End Sub

'lädt die Schifftypen mit den Eigenschaften
Public Function Load_ShipTypes() As Boolean
    
    Dim n           As Long
    Dim FileNum     As Integer
    
    On Error GoTo error:
    
    FileNum = FreeFile
    
    Open App.Path & "\ships.cfg" For Binary As FileNum
        
        For n = 1 To NUM_SHIP_TYPES
            With g_ShipType(n)
                Get FileNum, , .TypeName
                Get FileNum, , .Description
                Get FileNum, , .Weight
                Get FileNum, , .Acceleration
                Get FileNum, , .MaxSpeed
                Get FileNum, , .SteerSpeed
                Get FileNum, , .Shields
                Get FileNum, , .CannonGap
            End With
        Next
        
    Close FileNum
    
    Load_ShipTypes = True
    Exit Function
    
error:
    Load_ShipTypes = False

End Function

'berechnet den FrameKosinus und -Sinus
Public Sub Calc_ShipFrameTrigonometry()

    Dim n As Long
    
    For n = 1 To NUM_SHIP_FRAMES
        g_ShipFrameSin(n) = GetShipSin(n)
        g_ShipFrameCos(n) = GetShipCos(n)
    Next

End Sub

'gibt den Sinus für ein bestimmtes Schiffsbild zurück
Public Function GetShipSin(ByVal Frame As Single) As Single
    
    If Frame < 1 Then Frame = Frame + NUM_SHIP_FRAMES
    If Frame >= NUM_SHIP_FRAMES + 1 Then Frame = Frame - NUM_SHIP_FRAMES
    
    GetShipSin = Sin(TPI / NUM_SHIP_FRAMES * (Frame - 1) - HPI)

End Function

'gibt den CoSinus für ein bestimmtes Schiffsbild zurück
Public Function GetShipCos(ByVal Frame As Single) As Single
    
    If Frame < 1 Then Frame = Frame + NUM_SHIP_FRAMES
    If Frame >= NUM_SHIP_FRAMES + 1 Then Frame = Frame - NUM_SHIP_FRAMES
    
    GetShipCos = Cos(TPI / NUM_SHIP_FRAMES * (Frame - 1) - HPI)

End Function

'fügt dem Spiel einen Spieler hinzu
Public Function Add_Player(ByVal ShipType As Integer, ByVal PlrName As String, ByVal Team As Long) As Boolean

    Dim n       As Long

    If g_PlrCnt < MAX_PLAYERS Then
        Add_Player = True
    Else
        Add_Player = False
        Exit Function
    End If
    
    g_PlrCnt = g_PlrCnt + 1
    
    With g_Plr(g_PlrCnt)
        .ID = g_PlrCnt
        .TeamID = Team
        .Draw = False
        .IsBot = False
        .Type = ShipType
        Init_Animation g_ShipSurf(.Type), .Anim, NUM_SHIP_FRAMES
        .WarHeadCnt = 1
        .PlrName = PlrName
        .Frags = 0
        .Deaths = 0
        .StartTime = g_DX.TickCount
        .AccelerationF = 1
        .MaxSpeedF = 1
        .SteerSpeedF = 1
        .WeightF = 1
        .ReloadSpeedF = 1
        .FireDelayF = 1
        .WeaponDestructF = 1
        .Accelerating = False
        
        For n = 1 To NUM_WARHEADS_PER_PLAYER
            .WarHead(n).Draw = False
        Next
    End With

End Function

'entfernt einen Spieler aus dem Spiel
Public Sub Remove_Player(ByRef Plr As TPlayer)

    Dim n As Long
    
    If Plr.ID < g_MyPlrID Then g_MyPlrID = g_MyPlrID - 1
    
    For n = Plr.ID + 1 To g_PlrCnt
        g_Plr(n - 1) = g_Plr(n)
    Next
    
    g_PlrCnt = g_PlrCnt - 1

End Sub

'recovered eine Spieler
Public Sub Recover_Player(ByRef Plr As TPlayer, ByVal SearchRespawnP As Boolean, Optional ByVal X As Long = 0, Optional ByVal Y As Long = 0)
    
    Dim h_RespawnPoint      As Integer
    
    With Plr
        
        .Draw = True
        SetAnimationFrame .Anim, 1
        .MoveX = 0
        .MoveY = 0
        .Shields = g_ShipType(.Type).Shields
        .AccelerationF = 1
        .MaxSpeedF = 1
        .SteerSpeedF = 1
        .WeightF = 1
        .ReloadSpeedF = 1
        .FireDelayF = 1
        .WeaponDestructF = 1
        .ActWeapon = 1
        .WeaponCnt = 1
        .CollStatus = True
        .Accelerating = False
        
        'feste EnergieWaffe
        .Weapon(1).Type = Int(Rnd * 2) + 1
        .Weapon(1).Munition = 100
        .Weapon(1).ItemType = 0
        
        If SearchRespawnP Then      'eventuell RespawnPoint suchen
            Do
                h_RespawnPoint = Int(Rnd * g_Map.NumRespawnPoints) + 1
            Loop Until .TeamID = g_RespawnPoint(h_RespawnPoint).TeamID Or g_RespawnPoint(h_RespawnPoint).TeamID = 0 Or .TeamID = 0
            
            .VX = g_RespawnPoint(h_RespawnPoint).VX
            .VY = g_RespawnPoint(h_RespawnPoint).VY
        Else
            .VX = X
            .VY = Y
        End If
        
        SetEvent .RecoverEvent, -1
        
        .MidX = .VX + .Anim.FrameWidth * 0.5
        .MidY = .VY + g_ShipSurf(.Type).Height * 0.5
        .LastMidX = .MidX
        .LastMidY = .MidY
                        
        If .ID = g_MyPlrID Then
            g_App.PlayerState = PLAYER_STATE_INGAME
            
            With g_Spectator
                SetEvent .ShowMapDescEvent, -1
                .ShowMapDesc = False
                .ShowMode = False
            End With
            
            '.WeightF = 400
            .Shields = 5000
            .Weapon(1).Type = WEAPON_NAME_7
            .Weapon(1).Munition = 100000
            
            If DrawRespawnEffect Then AddRespawnEffect .MidX, .MidY, True
        Else
            Dim HasFocus        As Boolean
            
            HasFocus = (g_App.PlayerState = PLAYER_STATE_SPECTATOR And g_Spectator.CurrentPlayer = .ID)
            If DrawRespawnEffect Then AddRespawnEffect .MidX, .MidY, HasFocus
        End If
                
    End With

End Sub

'zerstört einen Player und setzt Explosion
Public Sub Destroy_Player(ByRef Plr As TPlayer)

    With Plr
        .Draw = False
        
        .MoveX = 0
        .MoveY = 0
        
        If MapIsDestroyable Then DestroyMap CLng(.MidX), CLng(.MidY), VERY_BIG
        AddBigExplosion .MidX, .MidY
        
        Impulse(.ID).InfiniteSpread = False
        
        If .IsBot Then
            SetEvent .RecoverEvent, MIN_BOT_RECOVER_DELAY + Int(Rnd * 2000)
            
            With g_BotWay(.ID)
                .TargType = 0
                .ActWayPoint = 0
                .NumWayPoints = 0
                .TargX = 0
                .TargY = 0
            End With
        End If
        
        If .ID = g_MyPlrID Then
            g_App.PlayerState = PLAYER_STATE_SPECTATOR
            
            With g_Spectator
                .SpectatorMode = SPECTATOR_MODE_FREE
                SetEvent .WaitEvent, 0, SPECTATOR_WAIT_DURATION
                SetEvent .ShowModeEvent, SPECTATOR_WAIT_DURATION, SPECTATOR_SHOWMODE_DURATION
            End With
        End If
    End With

End Sub

'beschleunigt einen Player
Public Sub Accelerate_Player(ByRef Plr As TPlayer)

    Dim h_StepX             As Single
    Dim h_StepY             As Single
    Dim h_RatioFactor       As Single
    Dim h_MaxSpeed          As Single
    Dim h_Move              As Single
    Dim h_NewMove           As Single
    Dim h_Acceleration      As Single

    With Plr
    
        .Accelerating = True
        h_MaxSpeed = .MaxSpeedF * g_ShipType(.Type).MaxSpeed
        h_Acceleration = .AccelerationF * g_ShipType(.Type).Acceleration * g_App.AVFGS
        
        h_StepX = g_ShipFrameCos(.Anim.ActFrameInt) * h_Acceleration
        h_StepY = g_ShipFrameSin(.Anim.ActFrameInt) * h_Acceleration
        h_Move = PythA(.MoveX, .MoveY)
        h_NewMove = PythA(.MoveX + h_StepX, .MoveY + h_StepY)

        If h_NewMove <= h_MaxSpeed Or h_NewMove <= h_Move Then
            .MoveX = .MoveX + h_StepX
            .MoveY = .MoveY + h_StepY
        ElseIf h_MaxSpeed - h_Move > 0 Then
            h_RatioFactor = (h_MaxSpeed - h_Move) / PythA(h_StepX, h_StepY)
            .MoveX = .MoveX + h_StepX * h_RatioFactor
            .MoveY = .MoveY + h_StepY * h_RatioFactor
        End If
            
    End With

End Sub

'berechnet die G-Point-Anziehung
Public Sub Calc_GPointForce(ByRef Plr As TPlayer, ByRef MoveX As Single, ByRef MoveY As Single)

    Dim n           As Long
    Dim h_Dist      As Single
    Dim h_XDist     As Single
    Dim h_YDist     As Single
    Dim h_dmy       As Single
    Dim h_Weight    As Single
    
    For n = 1 To g_Map.NumGravityPoints
        With g_GravPoint(n)
            
            'nur zum Testen
            'g_BackBuf.SetForeColor &HFFFF
            'g_BackBuf.DrawCircle .VX - g_Map.Wnd.Left, .VY - g_Map.Wnd.Top, .OutRadius
            'g_BackBuf.DrawCircle .VX - g_Map.Wnd.Left, .VY - g_Map.Wnd.Top, .InRadius
            
            h_XDist = .VX - Plr.MidX
            h_YDist = .VY - Plr.MidY
            h_Dist = PythA(h_XDist, h_YDist)
            
            If h_Dist < .OutRadius And (.TeamID = 0 Or (.TeamID <> Plr.TeamID And Plr.TeamID > 0)) Then
                If h_Dist < .InRadius Then h_Dist = .InRadius
                h_dmy = .Mass / (h_Dist * h_Dist * 0.25)
                h_Weight = g_ShipType(Plr.Type).Weight * Plr.WeightF / 100
                
                MoveX = MoveX + h_XDist * h_dmy * h_Weight
                MoveY = MoveY + h_YDist * h_dmy * h_Weight
            End If
        End With
    Next

End Sub

'bewegt einen Player und berechnet die Physik
Public Sub Move_Player(ByRef Plr As TPlayer)

    Dim h_Friction      As Single
    Dim h_RatioFactor   As Single
    Dim h_PythMove      As Single
    Dim h_GPMoveX       As Single
    Dim h_GPMoveY       As Single
    
    With Plr
                
        Impulse(.ID).X = .MidX
        Impulse(.ID).Y = .MidY
        Impulse(.ID).SpreadRangeOffset = .Anim.ActFrameSng / 20 * PI + HPI / 1.8
                
        'Gravity
        Calc_GPointForce Plr, h_GPMoveX, h_GPMoveY
        .MoveX = .MoveX + (g_Map.GravX + h_GPMoveX) * g_App.AVFGS
        .MoveY = .MoveY + (g_Map.GravY + h_GPMoveY) * g_App.AVFGS
    
        'Reibung
        h_Friction = GetAVAcc(g_Map.Friction, g_App.AVFGS)
        .MoveX = .MoveX * h_Friction
        .MoveY = .MoveY * h_Friction
            
        'Geschwindigkeit begrenzen
        h_PythMove = PythA(.MoveX, .MoveY)
        
        If h_PythMove > MAX_SHIP_SPEED Then
            h_RatioFactor = MAX_SHIP_SPEED / h_PythMove
            .MoveX = h_RatioFactor * .MoveX
            .MoveY = h_RatioFactor * .MoveY
        End If
                
        'bewegen
        .VX = .VX + .MoveX * g_App.AVFGS
        .VY = .VY + .MoveY * g_App.AVFGS
        
        'Mittelpunkt errechnen
        .LastMidX = .MidX
        .LastMidY = .MidY
        .MidX = .VX + .Anim.FrameWidth * 0.5
        .MidY = .VY + g_ShipSurf(.Type).Height * 0.5
            
        'Levelbegrenzung und Pinballeffekt
        If .VX < 0 Then
            .VX = 0
            .MoveX = -.MoveX * g_Map.PinballFactor
        ElseIf .VX + .Anim.FrameWidth > g_Map.PixelWidth(3) Then
            .VX = g_Map.PixelWidth(3) - .Anim.FrameWidth
            .MoveX = -.MoveX * g_Map.PinballFactor
        End If
        
        If .VY < 0 Then
            .VY = 0
            .MoveY = -.MoveY * g_Map.PinballFactor
        ElseIf .VY + g_ShipSurf(.Type).Height > g_Map.PixelHeight(3) Then
            .VY = g_Map.PixelHeight(3) - g_ShipSurf(.Type).Height
            .MoveY = -.MoveY * g_Map.PinballFactor
        End If
                
    End With

End Sub

'eigenes Schiff steuern
Public Sub Control_UserShip()

    Dim h_SteerSpeed        As Single
    
    With g_Plr(g_MyPlrID)
        
        'lenken
        h_SteerSpeed = .SteerSpeedF * g_ShipType(.Type).SteerSpeed * g_App.AVFGS
        If GetCustomKeyState(g_Key_Left) Then Proceed_Animation .Anim, -h_SteerSpeed
        If GetCustomKeyState(g_Key_Right) Then Proceed_Animation .Anim, h_SteerSpeed
        
        'beschleunigen
        If GetCustomKeyState(g_Key_Accelerate) Then Accelerate_Player g_Plr(g_MyPlrID)
        Move_Player g_Plr(g_MyPlrID)
        
        'schießen
        If GetCustomKeyState(g_Key_Fire) Then Shoot_Weapon g_Plr(g_MyPlrID), True, True
        
        'Waffen aufladen
        Reload_Weapons g_Plr(g_MyPlrID)
        
        'Focus auf Spieler setzen
        SetMapWnd .MidX - g_App.ResX * 0.5, .MidY - g_App.ResY * 0.5
        
        'Radar-Wnd setzen
        SetRadarWnd .MidX, .MidY
        
    End With

    'SternenBewegung
    With g_Map
        If .Wnd.Left > 0 And .Wnd.Right < .PixelWidth(3) Then .StarMoveX = -g_Plr(g_MyPlrID).MoveX * g_App.AVFGS
        If .Wnd.Top > 0 And .Wnd.Bottom < .PixelHeight(3) Then .StarMoveY = -g_Plr(g_MyPlrID).MoveY * g_App.AVFGS
    End With
    
End Sub

'zeichnet Player
Public Sub Draw_Players()

    Dim n       As Long
    Dim RX      As Long
    Dim RY      As Long
    
    For n = 1 To g_PlrCnt
        With g_Plr(n)
            If .Draw Then
                If IsInRectSng(g_Map.Wnd, .VX, .VY, .Anim.FrameWidth, g_ShipSurf(.Type).Height) Then
                    RX = .VX - g_Map.Wnd.Left
                    RY = .VY - g_Map.Wnd.Top
                    Blit_Animation RX, RY, g_ShipSurf(.Type), .Anim
                End If
            End If
        End With
    Next

End Sub
