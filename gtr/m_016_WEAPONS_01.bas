Attribute VB_Name = "m_016_WEAPONS_01"
Option Explicit

'lädt alle Waffentypen und die passenden Surfaces
Public Sub Load_WeaponTypes()

    Dim n               As Long
    Dim FileNum         As Integer
    
    'Settings laden
    FileNum = FreeFile
    
    Open App.Path & "\weapons.cfg" For Binary As FileNum
    
        For n = 1 To NUM_WEAPON_TYPES
            With g_WeaponType(n)
                Get FileNum, , .TypeName
                Get FileNum, , .Description
                Get FileNum, , .ShootType
                Get FileNum, , .SurfNum
                Get FileNum, , .NumFrames
                Get FileNum, , .SteerSpeed
                Get FileNum, , .Speed
                Get FileNum, , .AddShipSpeed
                Get FileNum, , .Power
                Get FileNum, , .FireDelay
                Get FileNum, , .Reloadable
                Get FileNum, , .ReloadSpeed
                Get FileNum, , .Consumption
                
                Get FileNum, , .LightColor.R
                Get FileNum, , .LightColor.G
                Get FileNum, , .LightColor.b
            End With
        Next
    
    Close FileNum

    'Surfs laden
    For n = 1 To NUM_WEAPON_SURFS
        Load_Surf g_App.Path_Pics & "\weapon_" & Format(n, "000") & ".bmp", g_WeaponSurf(n), KEY_COL_GREEN
    Next
    
End Sub

'übernimmt alle Eigenschaften beim Schießen (Delay, Munition)
Public Sub Shoot_Weapon(ByRef Plr As TPlayer, ByVal FireDelay As Boolean, ByVal ConsumeMunition As Boolean)
    
    Dim ActMunition         As Single
    
    With Plr.Weapon(Plr.ActWeapon)
    
        If .ItemType Then
            Fire_Item Plr, FireDelay, ConsumeMunition
            Exit Sub
        End If
    
        If FireDelay And Not GetEventStatus(.FireEvent, DEFAULT_GAMESPEED / g_App.GameSpeed) _
        Then Exit Sub
                
        SetEvent .FireEvent, g_WeaponType(.Type).FireDelay * Plr.FireDelayF, 0
                
        If ConsumeMunition Then
            ActMunition = .Munition - g_WeaponType(.Type).Consumption
                        
            If ActMunition < 0 Then Exit Sub
            
            .Munition = ActMunition
        End If
                
        If g_App.GameMode = GAME_MODE_MP_DEATHMATCH Then Send_PlayerFire Plr
        Fire_Weapon Plr

    End With

End Sub

'schießt eine Waffe von einem Player ab
Public Sub Fire_Weapon(ByRef Plr As TPlayer)

    Dim n               As Long
    Dim ShFrm           As Integer
    Dim h_Frm           As Single
    Dim m               As Integer
    Dim ShootType       As EShootType
    Dim WeaponType      As EWeaponType
    Dim SurfNum         As Integer

    With Plr
        ShFrm = .Anim.ActFrameInt
        ShootType = g_WeaponType(.Weapon(.ActWeapon).Type).ShootType
        WeaponType = .Weapon(.ActWeapon).Type
        SurfNum = g_WeaponType(.Weapon(.ActWeapon).Type).SurfNum
    End With
    
    Select Case ShootType
        
        'gerader Doppelschuss
        Case SHOOT_TYPE_DOUBLE_STRAIGHT:
            For n = 1 To 2
                With Plr.WarHead(Plr.WarHeadCnt)
                    .Draw = True
                    .Type = WeaponType
                    .SurfNum = SurfNum
                    Init_Animation g_WeaponSurf(SurfNum), .Anim, g_WeaponType(WeaponType).NumFrames
                    
                    If g_WeaponType(WeaponType).Reloadable Then _
                    SetAnimationFrame .Anim, ShFrm Mod g_WeaponType(WeaponType).NumFrames
                    
                    If n = 1 Then
                        .VX = Plr.MidX - .Anim.FrameWidth * 0.5 + g_ShipFrameSin(ShFrm) * g_ShipType(Plr.Type).CannonGap
                        .VY = Plr.MidY - g_WeaponSurf(SurfNum).Height * 0.5 - g_ShipFrameCos(ShFrm) * g_ShipType(Plr.Type).CannonGap
                    Else
                        .VX = Plr.MidX - .Anim.FrameWidth * 0.5 - g_ShipFrameSin(ShFrm) * g_ShipType(Plr.Type).CannonGap
                        .VY = Plr.MidY - g_WeaponSurf(SurfNum).Height * 0.5 + g_ShipFrameCos(ShFrm) * g_ShipType(Plr.Type).CannonGap
                    End If
                    
                    .MovX = g_ShipFrameCos(ShFrm) * g_WeaponType(WeaponType).Speed
                    .MovY = g_ShipFrameSin(ShFrm) * g_WeaponType(WeaponType).Speed
                    
                    If g_WeaponType(WeaponType).AddShipSpeed Then
                        .MovX = .MovX + Plr.MoveX
                        .MovY = .MovY + Plr.MoveY
                    End If
                    
                    Plr.WarHeadCnt = Plr.WarHeadCnt + 1
                    If Plr.WarHeadCnt > NUM_WARHEADS_PER_PLAYER Then Plr.WarHeadCnt = 1
                End With
            Next
        
        'gerader Einfachschuss
        Case SHOOT_TYPE_STRAIGHT:
            With Plr.WarHead(Plr.WarHeadCnt)
                .Draw = True
                .Type = WeaponType
                .SurfNum = SurfNum
                Init_Animation g_WeaponSurf(SurfNum), .Anim, g_WeaponType(WeaponType).NumFrames
                
                If g_WeaponType(WeaponType).Reloadable Then _
                SetAnimationFrame .Anim, ShFrm Mod g_WeaponType(WeaponType).NumFrames
                
                .VX = Plr.MidX - .Anim.FrameWidth * 0.5
                .VY = Plr.MidY - g_WeaponSurf(SurfNum).Height * 0.5
                .MovX = g_ShipFrameCos(ShFrm) * g_WeaponType(WeaponType).Speed
                .MovY = g_ShipFrameSin(ShFrm) * g_WeaponType(WeaponType).Speed
                
                If g_WeaponType(WeaponType).AddShipSpeed Then
                    .MovX = .MovX + Plr.MoveX
                    .MovY = .MovY + Plr.MoveY
                End If
                
                Plr.WarHeadCnt = Plr.WarHeadCnt + 1
                If Plr.WarHeadCnt > NUM_WARHEADS_PER_PLAYER Then Plr.WarHeadCnt = 1
            End With
        
        'ungerader Dreifachschuss
        Case SHOOT_TYPE_TRIPLE_SLANT:
            For n = 1 To 3
                With Plr.WarHead(Plr.WarHeadCnt)
                    .Draw = True
                    .Type = WeaponType
                    .SurfNum = SurfNum
                    Init_Animation g_WeaponSurf(SurfNum), .Anim, g_WeaponType(WeaponType).NumFrames
                                                        
                    If n = 1 Then
                        'Frame setzen
                        If g_WeaponType(WeaponType).Reloadable Then _
                        SetAnimationFrame .Anim, ShFrm Mod g_WeaponType(WeaponType).NumFrames
                        
                        .VX = Plr.MidX - .Anim.FrameWidth * 0.5
                        .VY = Plr.MidY - g_WeaponSurf(SurfNum).Height * 0.5
                        .MovX = g_ShipFrameCos(ShFrm) * g_WeaponType(WeaponType).Speed
                        .MovY = g_ShipFrameSin(ShFrm) * g_WeaponType(WeaponType).Speed
                    ElseIf n = 2 Then
                        'Frame setzen
                        If g_WeaponType(WeaponType).Reloadable Then
                            h_Frm = ShFrm - NUM_SHIP_FRAMES / 20
                            If h_Frm < 1 Then h_Frm = h_Frm + NUM_SHIP_FRAMES
                            SetAnimationFrame .Anim, h_Frm Mod g_WeaponType(WeaponType).NumFrames
                        End If
                        
                        .VX = Plr.MidX - .Anim.FrameWidth * 0.5 + g_ShipFrameSin(ShFrm) * g_ShipType(Plr.Type).CannonGap
                        .VY = Plr.MidY - g_WeaponSurf(SurfNum).Height * 0.5 - g_ShipFrameCos(ShFrm) * g_ShipType(Plr.Type).CannonGap
                        .MovX = (GetShipCos(ShFrm - NUM_SHIP_FRAMES / 20)) * g_WeaponType(WeaponType).Speed
                        .MovY = (GetShipSin(ShFrm - NUM_SHIP_FRAMES / 20)) * g_WeaponType(WeaponType).Speed
                    Else
                        'Frame setzen
                        If g_WeaponType(WeaponType).Reloadable Then
                            h_Frm = ShFrm + NUM_SHIP_FRAMES / 20
                            If h_Frm >= NUM_SHIP_FRAMES + 1 Then h_Frm = h_Frm - NUM_SHIP_FRAMES
                            SetAnimationFrame .Anim, h_Frm Mod g_WeaponType(WeaponType).NumFrames
                        End If
                        
                        .VX = Plr.MidX - .Anim.FrameWidth * 0.5 - g_ShipFrameSin(ShFrm) * g_ShipType(Plr.Type).CannonGap
                        .VY = Plr.MidY - g_WeaponSurf(SurfNum).Height * 0.5 + g_ShipFrameCos(ShFrm) * g_ShipType(Plr.Type).CannonGap
                        .MovX = (GetShipCos(ShFrm + NUM_SHIP_FRAMES / 20)) * g_WeaponType(WeaponType).Speed
                        .MovY = (GetShipSin(ShFrm + NUM_SHIP_FRAMES / 20)) * g_WeaponType(WeaponType).Speed
                    End If
                    
                    If g_WeaponType(WeaponType).AddShipSpeed Then
                        .MovX = .MovX + Plr.MoveX
                        .MovY = .MovY + Plr.MoveY
                    End If
                                                            
                    Plr.WarHeadCnt = Plr.WarHeadCnt + 1
                    If Plr.WarHeadCnt > NUM_WARHEADS_PER_PLAYER Then Plr.WarHeadCnt = 1
                End With
            Next
        
        'ungerader Achtfachschuss
        Case SHOOT_TYPE_OCT_SLANT:
            For n = 1 To 8
                With Plr.WarHead(Plr.WarHeadCnt)
                    .Draw = True
                    .Type = WeaponType
                    .SurfNum = SurfNum
                    Init_Animation g_WeaponSurf(SurfNum), .Anim, g_WeaponType(WeaponType).NumFrames
                                                                            
                    .VX = Plr.MidX - .Anim.FrameWidth * 0.5
                    .VY = Plr.MidY - g_WeaponSurf(SurfNum).Height * 0.5
                    
                    If n <= 4 Then
                        m = n - 1
                    
                        'Frame setzen
                        If g_WeaponType(WeaponType).Reloadable Then
                            h_Frm = ShFrm - NUM_SHIP_FRAMES / 8 * m
                            If h_Frm < 1 Then h_Frm = h_Frm + NUM_SHIP_FRAMES
                            SetAnimationFrame .Anim, h_Frm Mod g_WeaponType(WeaponType).NumFrames
                        End If
                        
                        .MovX = (GetShipCos(ShFrm - NUM_SHIP_FRAMES / 8 * m)) * g_WeaponType(WeaponType).Speed
                        .MovY = (GetShipSin(ShFrm - NUM_SHIP_FRAMES / 8 * m)) * g_WeaponType(WeaponType).Speed
                    Else
                        m = n - 4
                    
                        'Frame setzen
                        If g_WeaponType(WeaponType).Reloadable Then
                            h_Frm = ShFrm + NUM_SHIP_FRAMES / 8 * m
                            If h_Frm >= NUM_SHIP_FRAMES + 1 Then h_Frm = h_Frm - NUM_SHIP_FRAMES
                            SetAnimationFrame .Anim, h_Frm Mod g_WeaponType(WeaponType).NumFrames
                        End If
                        
                        .MovX = (GetShipCos(ShFrm + NUM_SHIP_FRAMES / 8 * m)) * g_WeaponType(WeaponType).Speed
                        .MovY = (GetShipSin(ShFrm + NUM_SHIP_FRAMES / 8 * m)) * g_WeaponType(WeaponType).Speed
                    End If
                    
                    If g_WeaponType(WeaponType).AddShipSpeed Then
                        .MovX = .MovX + Plr.MoveX
                        .MovY = .MovY + Plr.MoveY
                    End If
                                                            
                    Plr.WarHeadCnt = Plr.WarHeadCnt + 1
                    If Plr.WarHeadCnt > NUM_WARHEADS_PER_PLAYER Then Plr.WarHeadCnt = 1
                End With
            Next
                
    End Select

End Sub

'lädt die Waffen eines Schiffes auf
Public Sub Reload_Weapons(ByRef Plr As TPlayer)
    
    Dim n           As Long
    
    For n = 1 To Plr.WeaponCnt
        With Plr.Weapon(n)
            If .Type Then
                If g_WeaponType(.Type).Reloadable Then
                    If .Munition < 100 Then .Munition = .Munition + _
                    g_WeaponType(.Type).ReloadSpeed * Plr.ReloadSpeedF * g_App.AVFGS
                End If
            End If
        End With
    Next

End Sub

'wechselt die Waffe eines Players
Public Sub Switch_Weapon(ByRef Plr As TPlayer, Optional ByVal Step As Integer = 0, Optional ByVal ID As Integer = -1)
    
    With Plr
        If Not .Draw Then Exit Sub
        
        .ActWeapon = .ActWeapon + Step
        
        If ID > 0 Then .ActWeapon = ID
        
        If .ActWeapon > .WeaponCnt Then .ActWeapon = 1
        If .ActWeapon < 1 Then .ActWeapon = .WeaponCnt
    End With
    
End Sub

'zeichnet alle Waffen
Public Sub Draw_Weapons()

    Dim n       As Long
    Dim m       As Long
    Dim RX      As Long
    Dim RY      As Long
    
    For n = 1 To g_PlrCnt
        For m = 1 To NUM_WARHEADS_PER_PLAYER
            With g_Plr(n).WarHead(m)
                If .Draw Then
                    .VX = .VX + .MovX * g_App.AVFGS
                    .VY = .VY + .MovY * g_App.AVFGS
                    
                    If IsInRectSng(g_Map.Wnd, .VX, .VY, .Anim.FrameWidth, g_WeaponSurf(.SurfNum).Height) Then
                        Proceed_Animation .Anim, g_WeaponType(.Type).SteerSpeed * g_App.AVFGS
                        RX = .VX - g_Map.Wnd.Left
                        RY = .VY - g_Map.Wnd.Top
                        Blit_Animation .VX - g_Map.Wnd.Left, .VY - g_Map.Wnd.Top, g_WeaponSurf(.SurfNum), .Anim
                    End If
                End If
            End With
        Next
    Next

End Sub

'Kollision mit Waffen überprüfen
Public Sub Check_WeaponCollision()

End Sub
