Attribute VB_Name = "m_011_MAP_01"
Option Explicit

'lädt Map
Public Function Load_Map(ByVal FileName As String) As Boolean

    Dim FileNum         As Integer
    Dim n               As Long
    Dim m               As Long
    Dim i               As Long
    Dim NumTileSurfs    As Long
    Dim PicClass        As Byte
    Dim PicType         As Byte
    Dim h_Path          As String
    Dim h_DisplaceF     As Single
    
    'On Error GoTo error:
    
    MapIsDestroyable = GetINIValue(App.Path & "\config.ini", "Server", "MapDestroyable")
    
    With g_Map
                
        FileNum = FreeFile
                                        
        Open g_App.Path_Maps & "\" & FileName For Binary As FileNum
        
            'Eigenschaften
            Get FileNum, , .Author
            Get FileNum, , .Description
            Get FileNum, , .RecPlayerCnt
            Get FileNum, , .BackCol
            Get FileNum, , .DrawStars
            If GetINIValue(App.Path & "\config.ini", "Options", "DrawBackStars") = 0 Then .DrawStars = False
            Get FileNum, , .GravX
            Get FileNum, , .GravY
            Get FileNum, , .PinballFactor
            Get FileNum, , .Friction
            
            'Dimensionen auslesen
            Get FileNum, , .BlockWidth
            Get FileNum, , .BlockHeight
            
            'z-Faktoren auslesen
            Get FileNum, , .Plain_z(1)
            Get FileNum, , .Plain_z(2)
            Get FileNum, , .Plain_z(3)
            Get FileNum, , .Plain_z(4)
                                                
            Get FileNum, , .StarPlain_z(1)
            Get FileNum, , .StarPlain_z(2)
            Get FileNum, , .StarPlain_z(3)
                                                
            'TileBreite errechnen
            For n = 1 To 4
                .TileWidth(n) = DEFAULT_MAPTILE_WIDTH / .Plain_z(n)
            Next
                                                
            'welche Ebenen gebraucht werden
            For n = 1 To NUM_MAP_PLAINS
                Get FileNum, , .PlainNeed(n)
            Next
            
            'TileBilder ermitteln und Surfaces laden
            For n = 1 To NUM_MAP_PLAINS
                If .PlainNeed(n) Then
                    
                    Get FileNum, , NumTileSurfs
                    .SurfCount(n) = NumTileSurfs
                    
                    'Surfaces laden
                    For m = 1 To NumTileSurfs
                        Get FileNum, , PicClass
                        Get FileNum, , PicType
                        
                        h_Path = g_App.Path_Maps & "\" & Format(PicClass, "000") & "\" & Format(PicType, "000") & ".bmp"
                        Load_Surf h_Path, g_MapTileSurf(n, m), KEY_COL_BLACK, .TileWidth(n), .TileWidth(n)
                    Next
                    
                    'TileBilder ermitteln
                    For i = 1 To .BlockHeight
                        For m = 1 To .BlockWidth
                            Get FileNum, , g_MapTile(n, m, i).Type
                        Next
                    Next
                                        
                Else
                    .SurfCount(n) = 0
                End If
            Next
                        
            If MapIsDestroyable Then
                InitMapDestroyTools
                
                For i = 1 To .BlockHeight
                    For m = 1 To .BlockWidth
                        
                        g_DMapTile(m, i).Type = 0
                        
                        If g_MapTile(3, m, i).Type Then
                            Create_Blt_Surf g_MapTileSurf(3, g_MapTile(3, m, i).Type), g_DMapTile(m, i).Pic, KEY_COL_BLACK, .TileWidth(3), .TileWidth(3)
                            g_DMapTile(m, i).VX = (m - 1) * .TileWidth(3)
                            g_DMapTile(m, i).VY = (i - 1) * .TileWidth(3)
                            g_DMapTile(m, i).Type = g_MapTile(3, m, i).Type
                        End If
                    Next m
                Next i
            End If

            'damit die Relation der Koordinaten zur Kollisionsmap gleich bleibt
            h_DisplaceF = .TileWidth(3) / DEFAULT_MAPTILE_WIDTH
            
            'Respawn-Points ermitteln und umrechnen
            Get FileNum, , .NumRespawnPoints
            
            For n = 1 To .NumRespawnPoints
                With g_RespawnPoint(n)
                    Get FileNum, , .VX
                    Get FileNum, , .VY
                    Get FileNum, , .TeamID
                    .VX = .VX * h_DisplaceF
                    .VY = .VY * h_DisplaceF
                End With
            Next
            
            'Gravity-Points ermitteln und umrechnen
            Get FileNum, , .NumGravityPoints
            
            For n = 1 To .NumGravityPoints
                With g_GravPoint(n)
                    Get FileNum, , .VX
                    Get FileNum, , .VY
                    Get FileNum, , .InRadius
                    Get FileNum, , .OutRadius
                    Get FileNum, , .Mass
                    Get FileNum, , .TeamID
                    .VX = .VX * h_DisplaceF
                    .VY = .VY * h_DisplaceF
                    .InRadius = .InRadius * h_DisplaceF
                    .OutRadius = .OutRadius * h_DisplaceF
                End With
            Next
            
            'Items ermitteln
            .ItemCnt = 0
            .ItemTimerCnt = 0
            Get FileNum, , .NumItemRSPoints
            
            For n = 1 To .NumItemRSPoints
                With g_ItemRSPoint(n)
                    Get FileNum, , .X
                    Get FileNum, , .Y
                    .Reserved = False
                End With
            Next
                        
        Close FileNum
                
        'Pixelbreite errechnen
        For n = 1 To NUM_MAP_PLAINS
            .PixelWidth(n) = CLng(.BlockWidth) * .TileWidth(n)
            .PixelHeight(n) = CLng(.BlockHeight) * .TileWidth(n)
        Next
        
        'Tiles positionieren
        For i = 1 To NUM_MAP_PLAINS
            For n = 1 To .BlockWidth
                For m = 1 To .BlockHeight
                    g_MapTile(i, n, m).VX = (n - 1) * .TileWidth(i)
                    g_MapTile(i, n, m).VY = (m - 1) * .TileWidth(i)
                Next
            Next
        Next
                
        'Ebenen-GeschwindigkeitsFaktoren errechnen
        For n = 1 To NUM_MAP_PLAINS
            .PlainFactorX(n) = ((.PixelWidth(3) - CLng(g_App.ResX) * .TileWidth(3) / _
            .TileWidth(n)) / (.PixelWidth(3) - g_App.ResX)) * .TileWidth(n) / .TileWidth(3)
            
            .PlainFactorY(n) = ((.PixelHeight(3) - CLng(g_App.ResY) * .TileWidth(3) / _
            .TileWidth(n)) / (.PixelHeight(3) - g_App.ResY)) * .TileWidth(n) / .TileWidth(3)
        Next
                        
        'ViewRect setzen
        SetMapWnd 0, 0
        
        .GravX = 0
        .GravY = 0 '0.05
        '.Friction = 0.995
                
    End With
    
'    Load_Map = True
'    Exit Function
    
'error:
'    Load_Map = False

End Function

'setzt ViewRect der Map
Public Sub SetMapWnd(ByVal X As Long, ByVal Y As Long)

    With g_Map
        If X > .PixelWidth(3) - g_App.ResX Then X = .PixelWidth(3) - g_App.ResX
        If X < 0 Then X = 0
        If Y > .PixelHeight(3) - g_App.ResY Then Y = .PixelHeight(3) - g_App.ResY
        If Y < 0 Then Y = 0
        
        With .Wnd
            .Left = X
            .Top = Y
            .Right = .Left + g_App.ResX
            .Bottom = .Top + g_App.ResY
            
            If .Right > g_Map.PixelWidth(3) Then .Right = g_Map.PixelWidth(3)
            If .Bottom > g_Map.PixelHeight(3) Then .Bottom = g_Map.PixelHeight(3)
        End With
    End With

End Sub

'zeichnet Ebene
Public Sub Draw_MapPlain(ByVal i As Integer)
    
    Dim n               As Long
    Dim m               As Long
    Dim h_FromX         As Long
    Dim h_ToX           As Long
    Dim h_FromY         As Long
    Dim h_ToY           As Long
    Dim h_RX            As Long
    Dim h_RY            As Long
    Dim WndLeft         As Long
    Dim WndTop          As Long
    
    With g_Map
    
        WndLeft = .Wnd.Left * .PlainFactorX(i)
        WndTop = .Wnd.Top * .PlainFactorY(i)
        
        h_FromX = WndLeft \ .TileWidth(i) + 1
        h_ToX = (WndLeft + g_App.ResX - 1) \ .TileWidth(i) + 1
        h_FromY = WndTop \ .TileWidth(i) + 1
        h_ToY = (WndTop + g_App.ResY - 1) \ .TileWidth(i) + 1
                
        For n = h_FromX To h_ToX
            For m = h_FromY To h_ToY
                With g_MapTile(i, n, m)
                    If .Type Then
                        h_RX = .VX - WndLeft
                        h_RY = .VY - WndTop
                        Blit_Surf h_RX, h_RY, g_MapTileSurf(i, .Type)
                    End If
                End With
            Next
        Next
    
    End With
    
End Sub
