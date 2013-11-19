Attribute VB_Name = "m_013_AI_01"
Option Explicit

'initialisiert einen Bot
Public Sub Init_Bot(ByRef Plr As TPlayer)

    With g_BotWay(Plr.ID)
        .ActWayPoint = 0
        .NumWayPoints = 0
        .TargType = 0
        .TargX = 0
        .TargY = 0
        Plr.IsBot = True
        SetEvent Plr.RecoverEvent, MIN_BOT_RECOVER_DELAY + Int(Rnd * 2000)
    End With

End Sub

'steuert die Bots
Public Sub Control_Bots()

    Dim n       As Long

    For n = 1 To g_PlrCnt
        If g_Plr(n).IsBot Then
            If g_Plr(n).Draw Then
                Control_Bot g_Plr(n), BOT_BEHAVIOUR_AGGRESSIVE, True
                Move_Player g_Plr(n)
            Else
                If GetEventStatus(g_Plr(n).RecoverEvent, DEFAULT_GAMESPEED / g_App.GameSpeed) Then _
                Recover_Player g_Plr(n), True
                If g_App.GameMode = GAME_MODE_MP_DEATHMATCH Then Send_Recover g_Plr(n)
            End If
        End If
    Next

End Sub

'steuert einen Bot
Public Sub Control_Bot(ByRef Bot As TPlayer, ByVal Behaviour As EBotBehaviour, ByVal Fire As Boolean)

    Dim n               As Long

    With g_BotWay(Bot.ID)
        
        'Weg abfliegen
        If .TargType = 0 Then
            
            With Bot
        
                'wenn Gegner in der Nähe dann u. U. Ziel neu definieren
                If Behaviour = BOT_BEHAVIOUR_AGGRESSIVE Or Behaviour = BOT_BEHAVIOUR_DEFENSIVE Then
                    For n = 1 To g_PlrCnt
                        If n <> .ID Then
                            If g_Plr(n).Draw Then
                                If .TeamID = 0 Or .TeamID <> g_Plr(n).TeamID Then
                                    If PythA(.MidX - g_Plr(n).MidX, .MidY - g_Plr(n).MidY) < _
                                    MAX_BOT_ENEMY_DIST Then
                                        If Behaviour = BOT_BEHAVIOUR_AGGRESSIVE Or _
                                        Int(Rnd * BOT_ATTACK_PROBABILITY) = 0 Then g_BotWay(.ID).TargType = g_Plr(n).ID
                                        
                                        Exit For
                                    End If
                                End If
                            End If
                        End If
                    Next
                End If
            
            End With
            
            'abfliegen
            If .ActWayPoint > 0 Then
                            
                FlyToTarget Bot, .WayPointX(.ActWayPoint), .WayPointY(.ActWayPoint), False
                                                                                    
                'Wegpunkte abfliegen
                If PythA(Bot.MidX - .WayPointX(.ActWayPoint), _
                Bot.MidY - .WayPointY(.ActWayPoint)) < MAX_BOT_WAYPOINT_DIST Then _
                .ActWayPoint = .ActWayPoint - 1
                
                'falls man dem übernächsten Waypoint näher ist, als dem nächsten
                If .ActWayPoint > 1 Then
                    If PythA(Bot.MidX - .WayPointX(.ActWayPoint - 1), _
                    Bot.MidY - .WayPointY(.ActWayPoint - 1)) < _
                    PythA(Bot.MidX - .WayPointX(.ActWayPoint), _
                    Bot.MidY - .WayPointY(.ActWayPoint)) Then _
                    .ActWayPoint = .ActWayPoint - 2
                End If
                                            
            Else
                
                'neues Ziel suchen
                Do
                Loop Until Search_Way(Bot, Rnd * g_Map.PixelWidth(3), Rnd * g_Map.PixelHeight(3))
                
            End If
                
        'feindlichem Player hinterherfliegen und darauf schießen
        Else
                
            .TargX = g_Plr(.TargType).MidX
            .TargY = g_Plr(.TargType).MidY
            
            FlyToTarget Bot, .TargX, .TargY, Fire
            
            If Not g_Plr(.TargType).Draw Then
                Do
                Loop Until Search_Way(Bot, Rnd * g_Map.PixelWidth(3), Rnd * g_Map.PixelHeight(3))
            End If
            
        End If
                    
        'neues Ziel suchen wenn am alten angekommen
        If .TargType = 0 Then
            If PythA(Bot.MidX - .TargX, Bot.MidY - .TargY) < MAX_BOT_TARGET_DIST Then
                Do
                Loop Until Search_Way(Bot, Rnd * g_Map.PixelWidth(3), Rnd * g_Map.PixelHeight(3))
            End If
        End If
            
    End With
    
    'Waffen aufladen
    Reload_Weapons Bot
        
End Sub

'Bot fliegt in Richtung Ziel
Public Sub FlyToTarget(ByRef Bot As TPlayer, ByVal TargX As Single, ByVal TargY As Single, ByVal Fire As Boolean)

    Dim TargSteer       As Single
    Dim LeftSteerDist   As Single
    Dim RightSteerDist  As Single
    
    With Bot
        'entscheiden ob nach links oder rechts gelenkt werden soll
        TargSteer = GetRad(.MidX - TargX, .MidY - TargY) / TPI * 40
        
        LeftSteerDist = (.Anim.NumFrames - TargSteer + .Anim.ActFrameSng) Mod .Anim.NumFrames
        RightSteerDist = (.Anim.NumFrames - .Anim.ActFrameSng + TargSteer) Mod .Anim.NumFrames
                
        If LeftSteerDist < RightSteerDist Then
            Proceed_Animation .Anim, -g_ShipType(.Type).SteerSpeed * .SteerSpeedF * g_App.AVFGS
        Else
            Proceed_Animation .Anim, g_ShipType(.Type).SteerSpeed * .SteerSpeedF * g_App.AVFGS
        End If

        'Beschleunigen
        If LeftSteerDist < BOT_ACCELERATION_STEER_DIST Or RightSteerDist < BOT_ACCELERATION_STEER_DIST Then
            Accelerate_Player Bot
            If Fire Then Shoot_Weapon Bot, True, True
        End If

    End With

End Sub

'löscht die SuchPunkte
Public Sub Delete_SearchPoints()

    Dim n       As Long
    Dim m       As Long
    
    For n = 1 To g_Map.BlockWidth
        For m = 1 To g_Map.BlockHeight
            g_SearchPointX(n, m) = 0
            g_SearchPointY(n, m) = 0
        Next
    Next

End Sub

'findet einen Weg durch die Map
Public Function Search_Way(ByRef Plr As TPlayer, ByVal TargX As Long, ByVal TargY As Long) As Boolean

    Dim n                   As Long
    Dim m                   As Long
    Dim StartTileX          As Integer
    Dim StartTileY          As Integer
    Dim TargTileX           As Integer
    Dim TargTileY           As Integer
    Dim NumCPoints          As Long
    Dim NumNewCPoints       As Long
    Dim h_PosX              As Long
    Dim h_PosY              As Long
    Dim h_Displace          As Long
    Dim h_HFTileWidth       As Single
    
    'Start-und Ziel- Tiles ermitteln
    With g_Map
        StartTileX = Plr.MidX \ .TileWidth(3) + 1
        StartTileY = Plr.MidY \ .TileWidth(3) + 1
        TargTileX = TargX \ .TileWidth(3) + 1
        TargTileY = TargY \ .TileWidth(3) + 1
    End With
    
    'Abbruch wenn Start und Ziel gleich sind
    If StartTileX = TargTileX And StartTileY = TargTileY Then
        Search_Way = True
        Exit Function
    End If
    
    Delete_SearchPoints
    g_CreatePointX(1) = StartTileX
    g_CreatePointY(1) = StartTileY
    NumCPoints = 1
    NumNewCPoints = 1
    
    Do
    
        For n = 1 To NumCPoints
        
            For m = -1 To 1 Step 2
            
                'linkes und rechtes Tile prüfen und ggf. CPoint setzen
                h_PosX = g_CreatePointX(n) + m
                h_PosY = g_CreatePointY(n)
                
                If h_PosX > 0 And h_PosX <= g_Map.BlockWidth Then
                    'nur setzen wenn noch nicht besetzt und wenn kein MapTile an dieser Position ist
                    If g_SearchPointX(h_PosX, h_PosY) = 0 And g_MapTile(3, h_PosX, h_PosY).Type = 0 Then
                        g_SearchPointX(h_PosX, h_PosY) = g_CreatePointX(n)
                        g_SearchPointY(h_PosX, h_PosY) = g_CreatePointY(n)
                        
                        If h_PosX = TargTileX And h_PosY = TargTileY Then Exit Do
                        
                        NumNewCPoints = NumNewCPoints + 1
                        g_CreatePointX(NumNewCPoints) = h_PosX
                        g_CreatePointY(NumNewCPoints) = h_PosY
                    End If
                End If
                
                'oberes und unteres Tile prüfen und ggf. CPoint setzen
                h_PosX = g_CreatePointX(n)
                h_PosY = g_CreatePointY(n) + m
                
                If h_PosY > 0 And h_PosY <= g_Map.BlockHeight Then
                    'nur setzen wenn noch nicht besetzt und wenn kein MapTile an dieser Position ist
                    If g_SearchPointX(h_PosX, h_PosY) = 0 And g_MapTile(3, h_PosX, h_PosY).Type = 0 Then
                        g_SearchPointX(h_PosX, h_PosY) = g_CreatePointX(n)
                        g_SearchPointY(h_PosX, h_PosY) = g_CreatePointY(n)
                        
                        If h_PosX = TargTileX And h_PosY = TargTileY Then Exit Do
                        
                        NumNewCPoints = NumNewCPoints + 1
                        g_CreatePointX(NumNewCPoints) = h_PosX
                        g_CreatePointY(NumNewCPoints) = h_PosY
                    End If
                End If
            
            Next
            
        Next
        
        NumNewCPoints = NumNewCPoints - NumCPoints
        
        'Abbrechen wenn keine neuen CPoints gefunden wurden
        If NumNewCPoints = 0 Then
            Search_Way = False
            Exit Function
        End If
        
        'abgearbeitete CPoints löschen
        For n = 1 To NumNewCPoints
            h_Displace = n + NumCPoints
            g_CreatePointX(n) = g_CreatePointX(h_Displace)
            g_CreatePointY(n) = g_CreatePointY(h_Displace)
        Next
                                
        NumCPoints = NumNewCPoints
                
    Loop
    
    'Weg zurückverfolgen
    With g_BotWay(Plr.ID)
        
        h_PosX = TargTileX
        h_PosY = TargTileY
        n = h_PosX
        m = h_PosY
        h_HFTileWidth = g_Map.TileWidth(3) * 0.5
        .WayPointX(1) = (TargTileX - 1) * g_Map.TileWidth(3) + h_HFTileWidth
        .WayPointY(1) = (TargTileY - 1) * g_Map.TileWidth(3) + h_HFTileWidth
        .NumWayPoints = 1
        
        Do
            .NumWayPoints = .NumWayPoints + 1
            .WayPointX(.NumWayPoints) = (g_SearchPointX(h_PosX, h_PosY) - 1) * _
            g_Map.TileWidth(3) + h_HFTileWidth
            
            .WayPointY(.NumWayPoints) = (g_SearchPointY(h_PosX, h_PosY) - 1) * _
            g_Map.TileWidth(3) + h_HFTileWidth
                        
            h_PosX = g_SearchPointX(n, m)
            h_PosY = g_SearchPointY(n, m)
            n = h_PosX
            m = h_PosY
        Loop Until (h_PosX = StartTileX And h_PosY = StartTileY)
        
        .ActWayPoint = .NumWayPoints
        .TargType = 0
        .TargX = TargX
        .TargY = TargY
        
        Search_Way = True
        
    End With
    
End Function

Public Sub Draw_Way()
    
    Dim n As Long
    Dim m As Long
    
'    g_BackBuf.SetForeColor &HFFFF
'
'    For m = 2 To 2 'g_PlrCnt
'        With g_BotWay(m)
'            For n = 1 To .NumWayPoints
'                g_BackBuf.DrawCircle .WayPointX(n) - g_Map.Wnd.Left, .WayPointY(n) - g_Map.Wnd.Top, 5
'            next
'        End With
'    next
    
End Sub
