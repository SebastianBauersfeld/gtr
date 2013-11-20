Attribute VB_Name = "m_017_COLLISION"
Option Explicit

'füllt ein HighDetail-Collision-Set
Public Sub Fill_HDCollisionSet(ByRef Surf As TSurf)

    Dim i                           As Long
    Dim n                           As Long
    Dim m                           As Long
    Dim l                           As Single
    Dim MarginRect                  As RECT
    Dim Anim                        As TAnimation
    Dim CollPix(1 To 50 * 50)       As TCollPoint
    Dim CollPixCnt                  As Long
    Dim Col                         As Long
    
    Init_Animation Surf, Anim, NUM_SHIP_FRAMES
    
    With Surf.Surf
    
        .Lock g_EmptyRect, g_EmptySurfDesc, DDLOCK_READONLY, 0
        
            For i = 1 To NUM_SHIP_FRAMES
            
                SetAnimationFrame Anim, i
                CollPixCnt = 0
                
                With MarginRect
                    .Left = (Anim.ActFrameInt - 1) * Anim.FrameWidth
                    .Top = 0
                    .Right = .Left + Anim.FrameWidth - 1
                    .Bottom = Surf.Height - 1
                End With
                            
                'linker Rand
                For n = MarginRect.Top To MarginRect.Bottom
                    For m = MarginRect.Left To MarginRect.Right
                        Col = .GetLockedPixel(m, n)
                        If Col <> KEY_COL_GREEN Then
                            CollPixCnt = CollPixCnt + 1
                            
                            With CollPix(CollPixCnt)
                                .X = m
                                .Y = n
                                .Col = Col
                            End With
                            
                            Exit For
                        End If
                    Next
                Next
            
                'oberer Rand
                For n = MarginRect.Left To MarginRect.Right
                    For m = MarginRect.Top To MarginRect.Bottom
                        Col = .GetLockedPixel(n, m)
                        If Col <> KEY_COL_GREEN Then
                            CollPixCnt = CollPixCnt + 1
                            
                            With CollPix(CollPixCnt)
                                .X = n
                                .Y = m
                                .Col = Col
                            End With
                            
                            Exit For
                        End If
                    Next
                Next
            
                'rechter Rand
                For n = MarginRect.Top To MarginRect.Bottom
                    For m = MarginRect.Right To MarginRect.Left Step -1
                        Col = .GetLockedPixel(m, n)
                        If Col <> KEY_COL_GREEN Then
                            CollPixCnt = CollPixCnt + 1
                            
                            With CollPix(CollPixCnt)
                                .X = m
                                .Y = n
                                .Col = Col
                            End With
                            
                            Exit For
                        End If
                    Next
                Next
            
                'unterer Rand
                For n = MarginRect.Left To MarginRect.Right
                    For m = MarginRect.Bottom To MarginRect.Top Step -1
                        Col = .GetLockedPixel(n, m)
                        If Col <> KEY_COL_GREEN Then
                            CollPixCnt = CollPixCnt + 1
                            
                            With CollPix(CollPixCnt)
                                .X = n
                                .Y = m
                                .Col = Col
                            End With
                            
                            Exit For
                        End If
                    Next
                Next
                            
                'jeden dritten KollisionsPunkt auswählen
                m = 0
                
                For l = 1 To CollPixCnt Step CollPixCnt / NUM_HD_COLL_POINTS
                    n = Round(l)
                    m = m + 1
                    
                    With g_CollSetHD(i, m)
                        .X = CollPix(n).X - MarginRect.Left
                        .Y = CollPix(n).Y
                        .Col = CollPix(n).Col
                    End With
                Next
                        
            Next
        
        .Unlock g_EmptyRect

    End With

End Sub

'füllt die LowDetail-Collision-Sets
Public Sub Fill_LDCollisionSets()

    Dim n               As Long
    Dim i               As Long
    Dim MarginRect      As RECT
    Dim Anim            As TAnimation
    
    For i = 1 To NUM_SHIP_TYPES
        
        Init_Animation g_ShipSurf(i), Anim, NUM_SHIP_FRAMES
        
        For n = 1 To NUM_SHIP_FRAMES
            
            SetAnimationFrame Anim, n
            
            MarginRect = GetSurfRect(g_ShipSurf(i), Anim)
            
            With MarginRect
                g_CollSetLD(i, n, 1).X = .Left
                g_CollSetLD(i, n, 1).Y = .Top
                g_CollSetLD(i, n, 2).X = .Right
                g_CollSetLD(i, n, 2).Y = .Top
                g_CollSetLD(i, n, 3).X = .Left
                g_CollSetLD(i, n, 3).Y = .Bottom
                g_CollSetLD(i, n, 4).X = .Right
                g_CollSetLD(i, n, 4).Y = .Bottom
            End With
            
        Next
        
    Next

End Sub

'füllt die Waffen-Kollisionssets
Public Sub Fill_WeaponCollisionSets()

    Dim n       As Long
    
    For n = 1 To NUM_WEAPON_SURFS
        g_WarHeadCollSet(n).X = g_WeaponSurf(n).Height * 0.5
        g_WarHeadCollSet(n).Y = g_WeaponSurf(n).Height * 0.5
    Next

End Sub

'liefert die Tatsächliche quadratische größe einer Surface als Rect
Public Function GetSurfRect(ByRef Surf As TSurf, ByRef Anim As TAnimation) As RECT

    Dim n               As Long
    Dim m               As Long
    Dim MarginRect      As RECT
    Dim h_Ready         As Boolean
    
    With MarginRect
        
        .Left = (Anim.ActFrameInt - 1) * Anim.FrameWidth
        .Top = 0
        .Right = .Left + Anim.FrameWidth - 1
        .Bottom = Surf.Height - 1
            
        Surf.Surf.Lock g_EmptyRect, g_EmptySurfDesc, DDLOCK_READONLY, 0
            
            'linken Rand suchen
            h_Ready = False
            
            For n = .Left To .Right
                For m = .Top To .Bottom
                    If Surf.Surf.GetLockedPixel(n, m) <> KEY_COL_GREEN Then
                        GetSurfRect.Left = n - .Left
                        h_Ready = True
                        Exit For
                    End If
                Next
                
                If h_Ready Then Exit For
            Next
            
            'oberer Rand
            h_Ready = False
            
            For n = .Top To .Bottom
                For m = .Left To .Right
                    If Surf.Surf.GetLockedPixel(m, n) <> KEY_COL_GREEN Then
                        GetSurfRect.Top = n
                        h_Ready = True
                        Exit For
                    End If
                Next
                
                If h_Ready Then Exit For
            Next
            
            'rechten Rand suchen
            h_Ready = False
            
            For n = .Right To .Left Step -1
                For m = .Top To .Bottom
                    If Surf.Surf.GetLockedPixel(n, m) <> KEY_COL_GREEN Then
                        GetSurfRect.Right = n - .Left
                        h_Ready = True
                        Exit For
                    End If
                Next
                
                If h_Ready Then Exit For
            Next
            
            'unteren Rand
            h_Ready = False
            
            For n = .Bottom To .Top Step -1
                For m = .Left To .Right
                    If Surf.Surf.GetLockedPixel(m, n) <> KEY_COL_GREEN Then
                        GetSurfRect.Bottom = n
                        h_Ready = True
                        Exit For
                    End If
                Next
                
                If h_Ready Then Exit For
            Next
            
        Surf.Surf.Unlock g_EmptyRect
        
    End With

End Function

'überprüft die Kollision eines Bots mit der Wand
Public Sub Check_BotCollision(ByRef Bot As TPlayer)

    Dim n                   As Long
    Dim CollX               As Long
    Dim CollY               As Long
    Dim SurfNum             As Integer
    Dim h_Ready             As Boolean
    
    With Bot
        If Not .CollStatus Then Exit Sub

        h_Ready = False
        
        For n = 1 To 4
            CollX = Int(.VX) + g_CollSetLD(.Type, .Anim.ActFrameInt, n).X
            CollY = Int(.VY) + g_CollSetLD(.Type, .Anim.ActFrameInt, n).Y
            SurfNum = g_MapTile(3, CollX \ g_Map.TileWidth(3) + 1, CollY \ g_Map.TileWidth(3) + 1).Type
            
            If SurfNum Then
                If MapIsDestroyable Then
                    With g_DMapTile(CollX \ g_Map.TileWidth(3) + 1, CollY \ g_Map.TileWidth(3) + 1).Pic.Surf
                        .Lock g_EmptyRect, g_EmptySurfDesc, DDLOCK_READONLY, 0
                                                                                                
                        If .GetLockedPixel(CollX Mod g_Map.TileWidth(3), CollY Mod g_Map.TileWidth(3)) <> KEY_COL_BLACK Then
                            .Unlock g_EmptyRect
                            
                            Hit_Ship Bot, HIT_TYPE_WALL
                            GetReBoundAngle Bot, CollX, CollY
                            If g_App.GameMode = GAME_MODE_MP_DEATHMATCH Then Send_WallCollision Bot, CollX, CollY
                            DestroyMap CLng(Bot.MidX), CLng(Bot.MidY), BIG
                            AddWallPuff CollX, CollY
                            h_Ready = True
                        Else
                            .Unlock g_EmptyRect
                        End If
                        
                    End With
                Else
                    With g_MapTileSurf(3, SurfNum).Surf
                        .Lock g_EmptyRect, g_EmptySurfDesc, DDLOCK_READONLY, 0
                                                                                                
                        If .GetLockedPixel(CollX Mod g_Map.TileWidth(3), CollY Mod g_Map.TileWidth(3)) <> KEY_COL_BLACK Then
                            .Unlock g_EmptyRect
                            
                            Hit_Ship Bot, HIT_TYPE_WALL
                            GetReBoundAngle Bot, CollX, CollY
                            h_Ready = True
                        Else
                            .Unlock g_EmptyRect
                        End If
                        
                    End With
                End If
            End If
            
            If h_Ready Then Exit For
        Next
        
    End With

End Sub

'überprüft die Kollision des Users
Public Sub Check_UserCollision()

    Dim n                   As Long
    Dim CollX               As Long
    Dim CollY               As Long
    Dim SurfNum             As Integer
    Dim h_Ready             As Boolean
    
    With g_Plr(g_MyPlrID)
        If Not .CollStatus Then Exit Sub
            
        h_Ready = False
        
        For n = 1 To NUM_HD_COLL_POINTS
            CollX = Int(.VX) + g_CollSetHD(.Anim.ActFrameInt, n).X
            CollY = Int(.VY) + g_CollSetHD(.Anim.ActFrameInt, n).Y
            SurfNum = g_MapTile(3, CollX \ g_Map.TileWidth(3) + 1, CollY \ g_Map.TileWidth(3) + 1).Type
            
            If SurfNum Then
                If MapIsDestroyable Then
                    With g_DMapTile(CollX \ g_Map.TileWidth(3) + 1, CollY \ g_Map.TileWidth(3) + 1).Pic.Surf
                        .Lock g_EmptyRect, g_EmptySurfDesc, DDLOCK_READONLY, 0
                                                                                                
                        If .GetLockedPixel(CollX Mod g_Map.TileWidth(3), CollY Mod g_Map.TileWidth(3)) <> KEY_COL_BLACK Then
                            .Unlock g_EmptyRect
                            
                            Hit_Ship g_Plr(g_MyPlrID), HIT_TYPE_WALL
                            GetReBoundAngle g_Plr(g_MyPlrID), CollX, CollY
                            
                            If g_App.GameMode = GAME_MODE_MP_DEATHMATCH Then Send_WallCollision g_Plr(g_MyPlrID), CollX, CollY
                            
                            DestroyMap CLng(g_Plr(g_MyPlrID).MidX), CLng(g_Plr(g_MyPlrID).MidY), BIG
                            AddWallPuff CollX, CollY
                            h_Ready = True
                        Else
                            .Unlock g_EmptyRect
                        End If
                        
                    End With
                Else
                    With g_MapTileSurf(3, SurfNum).Surf
                        .Lock g_EmptyRect, g_EmptySurfDesc, DDLOCK_READONLY, 0
                                                                                                
                        If .GetLockedPixel(CollX Mod g_Map.TileWidth(3), CollY Mod g_Map.TileWidth(3)) <> KEY_COL_BLACK Then
                            .Unlock g_EmptyRect
                            
                            Hit_Ship g_Plr(g_MyPlrID), HIT_TYPE_WALL
                            GetReBoundAngle g_Plr(g_MyPlrID), CollX, CollY
                            h_Ready = True
                        Else
                            .Unlock g_EmptyRect
                        End If
                        
                    End With
                End If
            End If
            
            If h_Ready Then Exit For
        Next
        
    End With

End Sub

'lässt das Schiff in der richtigen Richtung an der Map abprallen
Public Sub GetReBoundAngle(ByRef Plr As TPlayer, ByVal CollX As Long, ByVal CollY As Long)
    
    Dim n           As Long
    Dim OldX        As Long
    Dim OldY        As Long
    Dim SurfNum     As Long
    Dim XDirect     As Boolean
    Dim YDirect     As Boolean
    
    With Plr
        OldX = CollX + Int(.LastMidX - .MidX)
        OldY = CollY + Int(.LastMidY - .MidY)
        If OldX = CollX Then OldX = CollX + Sgn(.LastMidX - .MidX)
        If OldY = CollY Then OldY = CollY + Sgn(.LastMidY - .MidY)
        If OldX < 0 Then OldX = 0
        If OldY < 0 Then OldY = 0
        If OldX > g_Map.PixelWidth(3) - 1 Then OldX = g_Map.PixelWidth(3) - 1
        If OldY > g_Map.PixelHeight(3) - 1 Then OldY = g_Map.PixelHeight(3) - 1
        
        'überprüfen ob Objekt aus X-Richtung kommen konnte
        SurfNum = g_MapTile(3, OldX \ g_Map.TileWidth(3) + 1, CollY \ g_Map.TileWidth(3) + 1).Type
        
        XDirect = True
        If SurfNum Then
            With g_MapTileSurf(3, SurfNum).Surf
                .Lock g_EmptyRect, g_EmptySurfDesc, DDLOCK_READONLY, 0
                    If .GetLockedPixel(OldX Mod g_Map.TileWidth(3), _
                    CollY Mod g_Map.TileWidth(3)) <> KEY_COL_BLACK Then XDirect = False
                .Unlock g_EmptyRect
            End With
        End If
          
        'überprüfen ob Objekt aus Y-Richtung kommen konnte
        SurfNum = g_MapTile(3, CollX \ g_Map.TileWidth(3) + 1, OldY \ g_Map.TileWidth(3) + 1).Type
        
        YDirect = True
        If SurfNum Then
            With g_MapTileSurf(3, SurfNum).Surf
                .Lock g_EmptyRect, g_EmptySurfDesc, DDLOCK_READONLY, 0
                    If .GetLockedPixel(CollX Mod g_Map.TileWidth(3), _
                    OldY Mod g_Map.TileWidth(3)) <> KEY_COL_BLACK Then YDirect = False
                .Unlock g_EmptyRect
            End With
        End If
        
        'Abstoß-Effekt
        If MapIsDestroyable Then
            XDirect = True
            YDirect = True
        End If
        
        If XDirect Then
            .MoveX = -.MoveX * g_Map.PinballFactor
            .VX = .VX + OldX - CollX
        End If
        
        If YDirect Then
            .MoveY = -.MoveY * g_Map.PinballFactor
            .VY = .VY + OldY - CollY
        End If
    End With

End Sub

'nach Kollisionen zwischen Playern suchen
Public Sub Check_ShipCollisions()

    Dim n                           As Long
    Dim m                           As Long
    Dim h_DistX                     As Single
    Dim h_DistY                     As Single
    Dim h_OldDistX                  As Single
    Dim h_OldDistY                  As Single
    Dim h_SpeedX                    As Single
    Dim h_SpeedY                    As Single
    Dim QuadCollRadius              As Single
    Dim MyWeight                    As Single
    Dim EnemyWeight                 As Single
    
    QuadCollRadius = SHIP_COLL_RADIUS * SHIP_COLL_RADIUS
    
    For n = 1 To g_PlrCnt
        With g_Plr(n)
            If .Draw Then
                For m = n + 1 To g_PlrCnt
                    If g_Plr(m).Draw Then
                        
                        h_DistX = .MidX - g_Plr(m).MidX
                        h_DistY = .MidY - g_Plr(m).MidY
                                        
                        If h_DistX * h_DistX + h_DistY * h_DistY < QuadCollRadius Then
                            
                            h_OldDistX = .LastMidX - g_Plr(m).LastMidX
                            h_OldDistY = .LastMidY - g_Plr(m).LastMidY
                        
                            If h_OldDistX * h_OldDistX + h_OldDistY * h_OldDistY >= QuadCollRadius Then
                                                                
                                h_SpeedX = .MoveX
                                h_SpeedY = .MoveY
                                
                                MyWeight = .WeightF * g_ShipType(.Type).Weight
                                EnemyWeight = g_Plr(m).WeightF * g_ShipType(g_Plr(m).Type).Weight
                                
                                Hit_Ship g_Plr(n), HIT_TYPE_PLAYER, m
                                
                                'sich selber bewegen
                                If .Draw Then
                                    .MoveX = ((MyWeight - EnemyWeight) * .MoveX + 2 * EnemyWeight * g_Plr(m).MoveX) / (MyWeight + EnemyWeight) * g_Map.PinballFactor
                                    .MoveY = ((MyWeight - EnemyWeight) * .MoveY + 2 * EnemyWeight * g_Plr(m).MoveY) / (MyWeight + EnemyWeight) * g_Map.PinballFactor
                                End If
                                
                                'anderen Player bewegen
                                With g_Plr(m)
                                    If .Draw Then
                                        .MoveX = ((EnemyWeight - MyWeight) * .MoveX + 2 * MyWeight * h_SpeedX) / (MyWeight + EnemyWeight) * g_Map.PinballFactor
                                        .MoveY = ((EnemyWeight - MyWeight) * .MoveY + 2 * MyWeight * h_SpeedY) / (MyWeight + EnemyWeight) * g_Map.PinballFactor
                                    End If
                                End With
                                
                                'Schleife beenden wenn Player zerstört
                                If Not .Draw Then Exit For
                                
                            End If
                        End If
                    End If
                Next
            End If
        End With
    Next

End Sub

'nach Kollisionen zwischen Playern suchen (Netzwerk)
Public Sub Check_ShipCollisions_Net()

    Dim n                           As Long
    Dim m                           As Long
    Dim h_DistX                     As Single
    Dim h_DistY                     As Single
    Dim h_OldDistX                  As Single
    Dim h_OldDistY                  As Single
    Dim h_SpeedX                    As Single
    Dim h_SpeedY                    As Single
    Dim QuadCollRadius              As Single
    Dim MyWeight                    As Single
    Dim EnemyWeight                 As Single
    
    QuadCollRadius = SHIP_COLL_RADIUS * SHIP_COLL_RADIUS
    
    For n = 1 To g_PlrCnt
        With g_Plr(n)
            If .Draw Then
                For m = n + 1 To g_PlrCnt
                    If g_Plr(m).Draw Then
                        
                        h_DistX = .MidX - g_Plr(m).MidX
                        h_DistY = .MidY - g_Plr(m).MidY
                                        
                        If h_DistX * h_DistX + h_DistY * h_DistY < QuadCollRadius Then
                            
                            h_OldDistX = .LastMidX - g_Plr(m).LastMidX
                            h_OldDistY = .LastMidY - g_Plr(m).LastMidY
                        
                            If h_OldDistX * h_OldDistX + h_OldDistY * h_OldDistY >= QuadCollRadius Then
                                
                                h_SpeedX = .MoveX
                                h_SpeedY = .MoveY
                                
                                MyWeight = .WeightF * g_ShipType(.Type).Weight
                                EnemyWeight = g_Plr(m).WeightF * g_ShipType(g_Plr(m).Type).Weight
                                
                                Hit_Ship_Net g_Plr(n), HIT_TYPE_PLAYER, m
                                
                                'sich selber bewegen
                                If .Draw And (.IsBot Or .ID = g_MyPlrID) Then
                                    .MoveX = ((MyWeight - EnemyWeight) * .MoveX + 2 * EnemyWeight * g_Plr(m).MoveX) / (MyWeight + EnemyWeight) * g_Map.PinballFactor
                                    .MoveY = ((MyWeight - EnemyWeight) * .MoveY + 2 * EnemyWeight * g_Plr(m).MoveY) / (MyWeight + EnemyWeight) * g_Map.PinballFactor
                                End If
                                
                                'anderen Player bewegen
                                With g_Plr(m)
                                    If .Draw And (.IsBot Or .ID = g_MyPlrID) Then
                                        .MoveX = ((EnemyWeight - MyWeight) * .MoveX + 2 * MyWeight * h_SpeedX) / (MyWeight + EnemyWeight) * g_Map.PinballFactor
                                        .MoveY = ((EnemyWeight - MyWeight) * .MoveY + 2 * MyWeight * h_SpeedY) / (MyWeight + EnemyWeight) * g_Map.PinballFactor
                                    End If
                                End With
                                
                                'Schleife beenden wenn Player zerstört
                                If Not .Draw Then Exit For
                                
                            End If
                        End If
                    End If
                Next
            End If
        End With
    Next

End Sub

'überprüft ob ein Sprengkopf ein Schiff trifft
Public Sub Check_WeaponCollisions()

    Dim n                                   As Long
    Dim m                                   As Long
    Dim k                                   As Long
    Dim h_DistX                             As Single
    Dim h_DistY                             As Single
    Dim h_Radius(1 To NUM_WEAPON_SURFS)     As Single
    Dim SurfNum                             As Long
    Dim MidX                                As Long
    Dim MidY                                As Long
    
    'Radien vorberechnen
    For n = 1 To NUM_WEAPON_SURFS
        h_Radius(n) = g_WarHeadCollSet(n).X + SHIP_COLL_RADIUS * 0.4
        h_Radius(n) = h_Radius(n) * h_Radius(n)
    Next
        
    For n = 1 To g_PlrCnt
        For m = 1 To NUM_WARHEADS_PER_PLAYER
            With g_Plr(n).WarHead(m)
                
                If .Draw Then
                    
                    'nur wenn innerhalb von Level dann Kollisionsabfrage
                    If .VX >= 0 And .VY >= 0 And .VX + .Anim.FrameWidth < g_Map.PixelWidth(3) And .VY + g_WeaponSurf(.SurfNum).Height < g_Map.PixelHeight(3) Then
                                                    
                        'Kollision mit Playern
                        MidX = .VX + g_WarHeadCollSet(.SurfNum).X
                        MidY = .VY + g_WarHeadCollSet(.SurfNum).Y
                        
                        For k = 1 To n - 1
                            If g_Plr(k).Draw Then
                                h_DistX = MidX - g_Plr(k).MidX
                                h_DistY = MidY - g_Plr(k).MidY
                                
                                If h_DistX * h_DistX + h_DistY * h_DistY <= h_Radius(.SurfNum) Then
                                    Hit_Ship g_Plr(k), HIT_TYPE_WARHEAD, n, m
                                    .Draw = False
                                    AddSmallExplosion MidX, MidY
                                    Exit For
                                End If
                            End If
                        Next
                        
                        For k = n + 1 To g_PlrCnt
                            If g_Plr(k).Draw Then
                                h_DistX = MidX - g_Plr(k).MidX
                                h_DistY = MidY - g_Plr(k).MidY
                                
                                If h_DistX * h_DistX + h_DistY * h_DistY <= h_Radius(.SurfNum) Then
                                    Hit_Ship g_Plr(k), HIT_TYPE_WARHEAD, n, m
                                    .Draw = False
                                    AddSmallExplosion MidX, MidY
                                    Exit For
                                End If
                            End If
                        Next
                        
                        'Kollision mit Map
                        Dim Flag As Boolean
                        Flag = False
                        
                        SurfNum = g_MapTile(3, MidX \ g_Map.TileWidth(3) + 1, MidY \ g_Map.TileWidth(3) + 1).Type
                        
                        If SurfNum Then
                            If MapIsDestroyable Then
                                With g_DMapTile(MidX \ g_Map.TileWidth(3) + 1, MidY \ g_Map.TileWidth(3) + 1).Pic.Surf
                                    .Lock g_EmptyRect, g_EmptySurfDesc, DDLOCK_READONLY, 0
                                        If .GetLockedPixel(MidX Mod g_Map.TileWidth(3), MidY Mod g_Map.TileWidth(3)) <> KEY_COL_BLACK Then
                                            g_Plr(n).WarHead(m).Draw = False
                                            Flag = True
                                        End If
                                    .Unlock g_EmptyRect
                                End With
                            Else
                                With g_MapTileSurf(3, SurfNum).Surf
                                    .Lock g_EmptyRect, g_EmptySurfDesc, DDLOCK_READONLY, 0
                                        If .GetLockedPixel(MidX Mod g_Map.TileWidth(3), MidY Mod g_Map.TileWidth(3)) <> KEY_COL_BLACK Then
                                            g_Plr(n).WarHead(m).Draw = False
                                            Flag = True
                                        End If
                                    .Unlock g_EmptyRect
                                End With
                            End If
                            
                        End If

                        
                        If Flag Then
                            If MapIsDestroyable Then DestroyMap MidX, MidY, 2
                            AddSmallExplosion MidX, MidY
                        End If
                        
                    Else   'ausserhalb der Map wird Sprengkopf zerstört
                    
                        .Draw = False
                        If MapIsDestroyable Then DestroyMap .VX + g_WarHeadCollSet(.SurfNum).X, .VY + g_WarHeadCollSet(.SurfNum).Y, 2
                        AddSmallExplosion .VX + g_WarHeadCollSet(.SurfNum).X, .VY + g_WarHeadCollSet(.SurfNum).Y
                        
                    End If
                    
                End If
                
            End With
        Next
    Next
        
End Sub

'überprüft ob ein Sprengkopf ein Schiff trifft (Netzwerk)
Public Sub Check_WeaponCollisions_Net()

    Dim n                                   As Long
    Dim m                                   As Long
    Dim k                                   As Long
    Dim h_DistX                             As Single
    Dim h_DistY                             As Single
    Dim h_Radius(1 To NUM_WEAPON_SURFS)     As Single
    Dim SurfNum                             As Long
    Dim MidX                                As Long
    Dim MidY                                As Long
    
    'Radien vorberechnen
    For n = 1 To NUM_WEAPON_SURFS
        h_Radius(n) = g_WarHeadCollSet(n).X + SHIP_COLL_RADIUS * 0.4
        h_Radius(n) = h_Radius(n) * h_Radius(n)
    Next
        
    For n = 1 To g_PlrCnt
        For m = 1 To NUM_WARHEADS_PER_PLAYER
            With g_Plr(n).WarHead(m)
                
                If .Draw Then
                    
                    'nur wenn innerhalb von Level dann Kollisionsabfrage
                    If .VX >= 0 And .VY >= 0 And .VX + .Anim.FrameWidth < g_Map.PixelWidth(3) And .VY + g_WeaponSurf(.SurfNum).Height < g_Map.PixelHeight(3) Then
                                                    
                        'Kollision mit Playern
                        MidX = .VX + g_WarHeadCollSet(.SurfNum).X
                        MidY = .VY + g_WarHeadCollSet(.SurfNum).Y
                        
                        For k = 1 To n - 1
                            If g_Plr(k).Draw Then
                                h_DistX = MidX - g_Plr(k).MidX
                                h_DistY = MidY - g_Plr(k).MidY
                                
                                If h_DistX * h_DistX + h_DistY * h_DistY <= h_Radius(.SurfNum) Then
                                    If g_Plr(k).IsBot Or g_Plr(k).ID = g_MyPlrID Then Hit_Ship_Net g_Plr(k), HIT_TYPE_WARHEAD, n, m
                                    .Draw = False
                                    AddSmallExplosion MidX, MidY
                                    Exit For
                                End If
                            End If
                        Next
                        
                        For k = n + 1 To g_PlrCnt
                            If g_Plr(k).Draw Then
                                h_DistX = MidX - g_Plr(k).MidX
                                h_DistY = MidY - g_Plr(k).MidY
                                
                                If h_DistX * h_DistX + h_DistY * h_DistY <= h_Radius(.SurfNum) Then
                                    If g_Plr(k).IsBot Or g_Plr(k).ID = g_MyPlrID Then Hit_Ship_Net g_Plr(k), HIT_TYPE_WARHEAD, n, m
                                    .Draw = False
                                    AddSmallExplosion MidX, MidY
                                    Exit For
                                End If
                            End If
                        Next
                        
                        'Kollision mit Map
                        Dim Flag As Boolean
                        Flag = False
                        
                        SurfNum = g_MapTile(3, MidX \ g_Map.TileWidth(3) + 1, MidY \ g_Map.TileWidth(3) + 1).Type
                        
                        If SurfNum Then
                            If MapIsDestroyable Then
                                With g_DMapTile(MidX \ g_Map.TileWidth(3) + 1, MidY \ g_Map.TileWidth(3) + 1).Pic.Surf
                                    .Lock g_EmptyRect, g_EmptySurfDesc, DDLOCK_READONLY, 0
                                        If .GetLockedPixel(MidX Mod g_Map.TileWidth(3), MidY Mod g_Map.TileWidth(3)) <> KEY_COL_BLACK Then
                                            g_Plr(n).WarHead(m).Draw = False
                                            Flag = True
                                        End If
                                    .Unlock g_EmptyRect
                                End With
                            Else
                                With g_MapTileSurf(3, SurfNum).Surf
                                    .Lock g_EmptyRect, g_EmptySurfDesc, DDLOCK_READONLY, 0
                                        If .GetLockedPixel(MidX Mod g_Map.TileWidth(3), MidY Mod g_Map.TileWidth(3)) <> KEY_COL_BLACK Then
                                            g_Plr(n).WarHead(m).Draw = False
                                            Flag = True
                                        End If
                                    .Unlock g_EmptyRect
                                End With
                            End If
                            
                        End If
                        
                        If Flag Then
                            If MapIsDestroyable Then DestroyMap MidX, MidY, 2
                            AddSmallExplosion MidX, MidY
                        End If
                        
                    Else   'ausserhalb der Map wird Sprengkopf zerstört
                    
                        .Draw = False
                        If MapIsDestroyable Then DestroyMap .VX + g_WarHeadCollSet(.SurfNum).X, .VY + g_WarHeadCollSet(.SurfNum).Y, 2
                        AddSmallExplosion .VX + g_WarHeadCollSet(.SurfNum).X, .VY + g_WarHeadCollSet(.SurfNum).Y
                        
                    End If
                    
                End If
                
            End With
        Next
    Next
        
End Sub

'Schildabzug wenn Schiff getroffen wurde
Public Sub Hit_Ship(ByRef Plr1 As TPlayer, ByVal HitType As EHitType, Optional ByVal Plr2ID As Integer, Optional ByVal WarHeadID As Integer)

    With Plr1
                
        Select Case HitType
            
            Case HIT_TYPE_WALL:
                .Shields = .Shields - PythA(.MoveX, .MoveY) * 3
            
                If .Shields < 0 Then
                    Destroy_Player Plr1
                    .Deaths = .Deaths + 1
                    Add_KillBoard_Msg KILLBOARD_SUICIDE, .PlrName
                End If
            
            Case HIT_TYPE_PLAYER:
                .Shields = .Shields - PythA(.MoveX - g_Plr(Plr2ID).MoveX, .MoveY - g_Plr(Plr2ID).MoveY)
                
                If .Shields < 0 Then
                    Destroy_Player Plr1
                    .Deaths = .Deaths + 1
                End If
                
                g_Plr(Plr2ID).Shields = g_Plr(Plr2ID).Shields - PythA(.MoveX - g_Plr(Plr2ID).MoveX, .MoveY - g_Plr(Plr2ID).MoveY)
                
                If g_Plr(Plr2ID).Shields < 0 Then
                    Destroy_Player g_Plr(Plr2ID)
                    g_Plr(Plr2ID).Deaths = g_Plr(Plr2ID).Deaths + 1
                End If
                
                If .Shields < 0 And g_Plr(Plr2ID).Shields < 0 Then
                    Add_KillBoard_Msg KILLBOARD_CRASH, .PlrName, g_Plr(Plr2ID).PlrName
                ElseIf .Shields < 0 Then
                    Add_KillBoard_Msg KILLBOARD_SUICIDE, .PlrName
                ElseIf g_Plr(Plr2ID).Shields < 0 Then
                    Add_KillBoard_Msg KILLBOARD_SUICIDE, g_Plr(Plr2ID).PlrName
                End If
                        
            Case HIT_TYPE_WARHEAD:
                If .TeamID = 0 Or .TeamID <> g_Plr(Plr2ID).TeamID Then _
                .Shields = .Shields - g_WeaponType(g_Plr(Plr2ID).WarHead(WarHeadID).Type).Power * g_Plr(Plr2ID).WeaponDestructF
                
                If .Shields < 0 Then
                    Destroy_Player Plr1
                    Add_KillBoard_Msg KILLBOARD_KILL, g_Plr(Plr2ID).PlrName, .PlrName, g_Plr(Plr2ID).WarHead(WarHeadID).SurfNum
                    .Deaths = .Deaths + 1
                    g_Plr(Plr2ID).Frags = g_Plr(Plr2ID).Frags + 1
                End If
                
        End Select
                                
    End With

End Sub

'Schildabzug wenn Schiff getroffen wurde (Netzwerk)
Public Sub Hit_Ship_Net(ByRef Plr1 As TPlayer, ByVal HitType As EHitType, Optional ByVal Plr2ID As Integer, Optional ByVal WarHeadID As Integer)

    With Plr1
                
        Select Case HitType
            
            Case HIT_TYPE_WALL:
                .Shields = .Shields - PythA(.MoveX, .MoveY) * 3
            
                If .Shields < 0 Then
                    Destroy_Player Plr1
                    Send_PlayerDestruction KILLBOARD_SUICIDE, Plr1
                    .Deaths = .Deaths + 1
                    Add_KillBoard_Msg KILLBOARD_SUICIDE, .PlrName
                End If
                            
            Case HIT_TYPE_PLAYER:
                .Shields = .Shields - PythA(.MoveX - g_Plr(Plr2ID).MoveX, .MoveY - g_Plr(Plr2ID).MoveY)
                
                If .Shields < 0 And (.IsBot Or .ID = g_MyPlrID) Then
                    Destroy_Player Plr1
                    .Deaths = .Deaths + 1
                    Send_PlayerDestruction KILLBOARD_SUICIDE, Plr1
                    Add_KillBoard_Msg KILLBOARD_SUICIDE, .PlrName
                End If
                
                g_Plr(Plr2ID).Shields = g_Plr(Plr2ID).Shields - PythA(.MoveX - g_Plr(Plr2ID).MoveX, .MoveY - g_Plr(Plr2ID).MoveY)
                
                If g_Plr(Plr2ID).Shields < 0 And (.IsBot Or .ID = g_MyPlrID) Then
                    Destroy_Player g_Plr(Plr2ID)
                    g_Plr(Plr2ID).Deaths = g_Plr(Plr2ID).Deaths + 1
                    Send_PlayerDestruction KILLBOARD_SUICIDE, g_Plr(Plr2ID)
                    Add_KillBoard_Msg KILLBOARD_SUICIDE, g_Plr(Plr2ID).PlrName
                End If
                                                
            Case HIT_TYPE_WARHEAD:
                If .TeamID = 0 Or .TeamID <> g_Plr(Plr2ID).TeamID Then _
                .Shields = .Shields - g_WeaponType(g_Plr(Plr2ID).WarHead(WarHeadID).Type).Power * g_Plr(Plr2ID).WeaponDestructF
                
                If .Shields < 0 Then
                    Destroy_Player Plr1
                    .Deaths = .Deaths + 1
                    Send_PlayerDestruction KILLBOARD_KILL, Plr1, Plr2ID, g_Plr(Plr2ID).WarHead(WarHeadID).SurfNum
                    Add_KillBoard_Msg KILLBOARD_KILL, g_Plr(Plr2ID).PlrName, .PlrName, g_Plr(Plr2ID).WarHead(WarHeadID).SurfNum
                    g_Plr(Plr2ID).Frags = g_Plr(Plr2ID).Frags + 1
                End If
                
        End Select
        
    End With

End Sub

Public Sub DrawCollPoints()

    Dim n As Long
    Dim RX As Long
    Dim RY As Long

'    g_BackBuf.SetForeColor &HFFFF
'
'    With g_Plr(g_MyPlrID)
'        For n = 1 To NUM_HD_COLL_POINTS
'            RX = g_CollSetHD(.Anim.ActFrameInt, n).X + .VX - g_Map.Wnd.Left
'            RY = g_CollSetHD(.Anim.ActFrameInt, n).Y + .VY - g_Map.Wnd.Top
'            g_BackBuf.DrawCircle RX, RY, 1
'        next
'    End With
'    g_BackBuf.Lock g_EmptyRect, g_EmptySurfDesc, DDLOCK_WRITEONLY, 0
'    With g_Plr(g_MyPlrID)
'        For n = 1 To NUM_HD_COLL_POINTS
'            RX = g_CollSetHD(.Anim.ActFrameInt, n).X + .VX - g_Map.Wnd.Left
'            RY = g_CollSetHD(.Anim.ActFrameInt, n).Y + .VY - g_Map.Wnd.Top
'            g_BackBuf.SetLockedPixel RX, RY, &HFF00
'            Blit_Text RX, RY, n, g_textfont(1)
'        next
'    End With
'    g_BackBuf.Unlock g_EmptyRect
    
End Sub

'prüft ob ein Player ein Item eingesammelt hat
Public Sub Check_ItemCollision()

    Dim n       As Long
    Dim m       As Long
    
    For m = 1 To g_PlrCnt
        If g_Plr(m).Draw Then
            For n = 1 To g_Map.ItemCnt
                With g_Item(n)
                    If RectCollision(g_Plr(m).VX, g_Plr(m).VY, g_Plr(m).Anim.FrameWidth, _
                    g_ShipSurf(g_Plr(m).Type).Height, .VX, .VY, .Anim.FrameWidth, _
                    g_ItemSurf(.Type).Height) Then
                        If g_App.GameMode = GAME_MODE_MP_DEATHMATCH And (Not g_Plr(m).IsBot And Not g_Plr(m).ID = g_MyPlrID) Then Send_ItemCollect g_Plr(m), g_Item(n).Type, n
                        Collect_Item g_Plr(m), g_Item(n).Type, n
                        Exit For
                    End If
                End With
            Next
        End If
    Next
    
End Sub
