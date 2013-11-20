Attribute VB_Name = "m_018_ITEMS_01"
Option Explicit

'lädt die ItemSurfs
Public Sub Load_Items()

    Dim n       As Long
        
    For n = 1 To NUM_ITEM_TYPES
        Load_Surf g_App.Path_Pics & "\item_" & Format(n, "000") & ".bmp", g_ItemSurf(n), KEY_COL_GREEN
    Next

End Sub

'verwaltet das Auftauchen von Items
Public Sub Control_Items()

    Dim n                   As Long
    
    For n = 1 To g_Map.ItemCnt
        If GetEventStatus(g_Item(n).DurationEvent, DEFAULT_GAMESPEED / g_App.GameSpeed) Then
            Remove_Item n
            Exit For
        End If
    Next
    
    With g_Map
        If .NumItemRSPoints = 0 Or .ItemCnt >= MAX_ITEMS Or _
        .ItemCnt >= .NumItemRSPoints Then Exit Sub
    End With
    
    If GetEventStatus(g_Map.CreateItemEvent, DEFAULT_GAMESPEED / g_App.GameSpeed) Then
        If Int(Rnd * ITEM_CREATE_PROBABILITY) + 1 = 1 Then Add_Item
        SetEvent g_Map.CreateItemEvent, ITEM_CREATE_DELAY
    End If
        
End Sub

'erstellt ein Item
Public Sub Add_Item()

    g_Map.ItemCnt = g_Map.ItemCnt + 1
                
    With g_Item(g_Map.ItemCnt)
        Do
            .RSPointID = Int(Rnd * g_Map.NumItemRSPoints) + 1
        Loop Until Not g_ItemRSPoint(.RSPointID).Reserved
        
        .VX = g_ItemRSPoint(.RSPointID).X
        .VY = g_ItemRSPoint(.RSPointID).Y
        .Type = Int(Rnd * NUM_ITEM_TYPES) + 1
        g_ItemRSPoint(.RSPointID).Reserved = True
        Init_Animation g_ItemSurf(.Type), .Anim, NUM_ITEM_FRAMES
        SetEvent .DurationEvent, ITEM_STAY_DURATION + Int(Rnd * 2000)
    End With

End Sub

'entfernt ein Item
Public Sub Remove_Item(ByVal ItemID As Integer)

    Dim n       As Long
    
    g_ItemRSPoint(g_Item(ItemID).RSPointID).Reserved = False
    
    For n = ItemID To g_Map.ItemCnt - 1
        g_Item(n) = g_Item(n + 1)
    Next
    
    g_Map.ItemCnt = g_Map.ItemCnt - 1

End Sub

'wird aufgerufen wenn ein Item eingesammelt wurde
Public Sub Collect_Item(ByRef Plr As TPlayer, ByVal ItemID As EItemEvent, ByVal ItemNumber As Integer)
    
    Dim n                   As Long
    Dim AddMunition         As Boolean
    Dim RndItem             As Integer
    Dim dummy               As ECustomKeys
    Dim h_Remove_Item       As Boolean
    
repeat:
    
     h_Remove_Item = True
    
    If Plr.IsBot Or Plr.ID = g_MyPlrID Then
                    
        Select Case ItemID
        
            Case ITEM_EVENT_RANDOM:     'ZufallsItem
                ItemID = Int(Rnd * NUM_ITEM_TYPES) + 1
                GoTo repeat:
        
            Case ITEM_EVENT_SHIELDS:    'Schilde aufladen
                Plr.Shields = g_ShipType(Plr.Type).Shields
        
            Case ITEM_EVENT_SPEEDBOMB:
                AddMunition = False
                
                With Plr
                    For n = 1 To .WeaponCnt
                        If .Weapon(n).ItemType = ITEM_EVENT_SPEEDBOMB Then
                            AddMunition = True
                            Exit For
                        End If
                    Next
                    
                    If AddMunition Then
                        .Weapon(n).Munition = .Weapon(n).Munition + 1
                    ElseIf .WeaponCnt < 3 Then
                        .WeaponCnt = .WeaponCnt + 1
                        .Weapon(.WeaponCnt).ItemType = ITEM_EVENT_SPEEDBOMB
                        .Weapon(.WeaponCnt).Munition = 1
                        .Weapon(.WeaponCnt).Type = 0
                    Else
                        h_Remove_Item = False
                    End If
                End With
        
            Case ITEM_EVENT_SLOWMOTIONBOMB:
                AddMunition = False
                
                With Plr
                    For n = 1 To .WeaponCnt
                        If .Weapon(n).ItemType = ITEM_EVENT_SLOWMOTIONBOMB Then
                            AddMunition = True
                            Exit For
                        End If
                    Next
                    
                    If AddMunition Then
                        .Weapon(n).Munition = .Weapon(n).Munition + 1
                    ElseIf .WeaponCnt < 3 Then
                        .WeaponCnt = .WeaponCnt + 1
                        .Weapon(.WeaponCnt).ItemType = ITEM_EVENT_SLOWMOTIONBOMB
                        .Weapon(.WeaponCnt).Munition = 1
                        .Weapon(.WeaponCnt).Type = 0
                    Else
                        h_Remove_Item = False
                    End If
                End With
                
            Case ITEM_EVENT_REVERSE_STEER:
                If Plr.ID = g_MyPlrID Then
                    dummy = g_Key_Left
                    g_Key_Left = g_Key_Right
                    g_Key_Right = dummy
                    Add_ItemTimer ITEM_EVENT_REVERSE_STEER, ITEM_REVERSESTEER_DURATION
                Else
                    ItemID = Int(Rnd * NUM_ITEM_TYPES) + 1
                    GoTo repeat:
                End If
            
            Case ITEM_EVENT_DESTRUCTION:
                Destroy_Player Plr
            
            Case ITEM_EVENT_DISABLE_COLLISION:
                Plr.CollStatus = False
                Add_ItemTimer ITEM_EVENT_DISABLE_COLLISION, ITEM_DISABLECOLLISION_DURATION, Plr.ID
    
            Case ITEM_EVENT_DOUBLESPEED:
                Plr.MaxSpeedF = Plr.MaxSpeedF * 2
                Add_ItemTimer ITEM_EVENT_DOUBLESPEED, ITEM_DOUBLESPEED_DURATION, Plr.ID
            
        End Select
    
    End If
        
    If g_App.IsServer And h_Remove_Item Then Remove_Item ItemNumber
    
End Sub

'schießt SlowMotion-Bombs etc. ab
Public Sub Fire_Item(ByRef Plr As TPlayer, ByVal FireDelay As Boolean, ByVal ConsumeMunition As Boolean)

    Dim ActMunition         As Single
    
    With Plr.Weapon(Plr.ActWeapon)
        
        If FireDelay And Not GetEventStatus(.FireEvent, DEFAULT_GAMESPEED / g_App.GameSpeed) _
        Then Exit Sub
                
        SetEvent .FireEvent, ITEM_FIRE_DELAY, 0
                
        If ConsumeMunition Then
            ActMunition = .Munition - 1
                        
            If ActMunition < 0 Then Exit Sub
            
            .Munition = ActMunition
        End If
        
        If g_App.GameMode = GAME_MODE_MP_DEATHMATCH Then Send_PlayerItemFire Plr
        Activate_Item Plr, .ItemType
        
    End With

End Sub

'Aktiviert ein Item
Public Sub Activate_Item(ByRef Plr As TPlayer, ByVal ItemType As EItemEvent)
    
    Select Case ItemType
        
        Case ITEM_EVENT_SPEEDBOMB:
            g_App.TargetGameSpeed = g_App.TargetGameSpeed * 3
            Add_ItemTimer ITEM_EVENT_SPEEDBOMB, ITEM_SPEEDBOMB_DURATION
            
        Case ITEM_EVENT_SLOWMOTIONBOMB:
            g_App.TargetGameSpeed = g_App.TargetGameSpeed / 4
            Add_ItemTimer ITEM_EVENT_SLOWMOTIONBOMB, ITEM_SLOWMOBOMB_DURATION
            
    End Select

End Sub

'verwaltet die ItemTimer
Public Sub Control_ItemTimers()

    Dim n           As Long
    
    With g_Map
        For n = 1 To g_Map.ItemTimerCnt
            If GetEventStatus(g_ItemTimer(n).DurationEvent) Then
                Remove_ItemTimer n
                Exit For
            End If
        Next
    End With

End Sub

'fügt einen ItemTimer hinzu
Public Sub Add_ItemTimer(ByVal ItemEvent As EItemEvent, ByVal Duration As Long, Optional ByVal PlrID As Long = 1)

    With g_Map
    
        If .ItemTimerCnt < MAX_ITEM_TIMERS Then
            
            .ItemTimerCnt = .ItemTimerCnt + 1
            
            g_ItemTimer(.ItemTimerCnt).Type = ItemEvent
            g_ItemTimer(.ItemTimerCnt).PlrID = PlrID
            SetEvent g_ItemTimer(.ItemTimerCnt).DurationEvent, Duration
            
        End If
        
    End With

End Sub

'entfernt einen ItemTimer
Public Sub Remove_ItemTimer(ByVal TimerID As Integer)

    Dim n           As Long
    Dim dummy       As ECustomKeys

    With g_Map
        
        Select Case g_ItemTimer(TimerID).Type
        
            Case ITEM_EVENT_REVERSE_STEER:
                dummy = g_Key_Left
                g_Key_Left = g_Key_Right
                g_Key_Right = dummy
        
            Case ITEM_EVENT_SPEEDBOMB:
                g_App.TargetGameSpeed = g_App.TargetGameSpeed / 3
                
            Case ITEM_EVENT_SLOWMOTIONBOMB:
                g_App.TargetGameSpeed = g_App.TargetGameSpeed * 4
        
            Case ITEM_EVENT_DISABLE_COLLISION:
                g_Plr(g_ItemTimer(TimerID).PlrID).CollStatus = True
        
            Case ITEM_EVENT_DOUBLESPEED:
                g_Plr(g_ItemTimer(TimerID).PlrID).MaxSpeedF = g_Plr(g_ItemTimer(TimerID).PlrID).MaxSpeedF / 2
        
        End Select
                
        For n = TimerID To .ItemTimerCnt - 1
            g_ItemTimer(n) = g_ItemTimer(n + 1)
        Next
        
        .ItemTimerCnt = .ItemTimerCnt - 1
        
    End With

End Sub

'zeichnet alle Items auf der Karte
Public Sub Draw_Items()

    Dim n           As Long
    Dim h_RX        As Long
    Dim h_RY        As Long

    For n = 1 To g_Map.ItemCnt
        With g_Item(n)
            If IsInRectSng(g_Map.Wnd, .VX, .VY, .Anim.FrameWidth, g_ItemSurf(.Type).Height) Then
                If .Anim.NumFrames = 0 Then Init_Animation g_ItemSurf(.Type), .Anim, NUM_ITEM_FRAMES
                h_RX = .VX - g_Map.Wnd.Left
                h_RY = .VY - g_Map.Wnd.Top
                Proceed_Animation .Anim, ITEM_ANIM_SPEED * g_App.AVFGS
                Blit_Animation h_RX, h_RY, g_ItemSurf(.Type), .Anim
            End If
        End With
    Next

End Sub

'verändert die Spielgeschwindigkeit mit flüssigem Übergang
Public Sub Change_GameSpeed()

    With g_App
        
        If Abs(.GameSpeed - .TargetGameSpeed) > 0.5 Then
            If .GameSpeed < .TargetGameSpeed Then
                .GameSpeed = .GameSpeed + GAME_SPEED_CHANGE_SPEED * .AVF
            Else
                .GameSpeed = .GameSpeed - GAME_SPEED_CHANGE_SPEED * .AVF
            End If
        Else
            .GameSpeed = .TargetGameSpeed
        End If
        
    End With

End Sub
