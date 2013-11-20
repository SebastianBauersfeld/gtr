Attribute VB_Name = "m_021_DESTMAP_01"
Option Explicit


Public Enum EMapDestroySize
    SMALL = 1
    MEDIUM
    BIG
    VERY_BIG
End Enum

Public MapIsDestroyable                 As Boolean

Public DestroyMapSurf(1 To 4)           As TSurf


Public Type TDMapTile                                        'MapTile
    VX                                  As Single
    VY                                  As Single
    Type                                As Long
    Pic                                 As TSurf
End Type

Public g_DMapTile(1 To MAX_X_MAPTILES, 1 To MAX_Y_MAPTILES) As TDMapTile

Public Sub InitMapDestroyTools()
    Dim h_Path As String
    Dim n As Long

    For n = 1 To 4
        h_Path = g_App.Path_Pics & "\destroy0" & n & ".bmp"
        Load_Surf h_Path, DestroyMapSurf(n), KEY_COL_GREEN
    Next n

End Sub

Public Sub DestroyMap(ByRef X As Long, ByRef Y As Long, ByRef Size As EMapDestroySize)
    Dim n As Long
    Dim m As Long
    Dim bX As Long
    Dim bY As Long
    Dim iX As Long
    Dim iY As Long
    Dim pX As Long
    Dim pY As Long
    Dim fromX As Long
    Dim fromY As Long
    Dim toX As Long
    Dim toY As Long
    
    
    Dim iRect As RECT
    Dim TRect As RECT

    With g_Map
    
        TRect.Left = 0
        TRect.Top = 0
        TRect.Right = .TileWidth(3)
        TRect.Bottom = .TileWidth(3)
    
        bX = X \ .TileWidth(3) + 1
        bY = Y \ .TileWidth(3) + 1
       
        fromX = (X - DestroyMapSurf(Size).Width / 2) \ .TileWidth(3) + 1
        fromY = (Y - DestroyMapSurf(Size).Height / 2) \ .TileWidth(3) + 1
        
        toX = (X + DestroyMapSurf(Size).Width / 2) \ .TileWidth(3) + 1
        toY = (Y + DestroyMapSurf(Size).Height / 2) \ .TileWidth(3) + 1
        
        If fromX < 1 Then fromX = 1
        If toX > g_Map.BlockWidth Then toX = g_Map.BlockWidth
        If fromY < 1 Then fromY = 1
        If toY > g_Map.BlockHeight Then toY = g_Map.BlockHeight
        
        For n = fromX To toX
            For m = fromY To toY
            
                iX = (X - (n - 1) * .TileWidth(3)) - DestroyMapSurf(Size).Width / 2
                iY = (Y - (m - 1) * .TileWidth(3)) - DestroyMapSurf(Size).Height / 2
            
                iRect.Left = 0
                iRect.Top = 0
                iRect.Right = DestroyMapSurf(Size).Width
                iRect.Bottom = DestroyMapSurf(Size).Height
            
                AdaptRect iX, iY, iRect, TRect
                
                If g_DMapTile(n, m).Type Then
                    g_DMapTile(n, m).Pic.Surf.BltFast iX, iY, DestroyMapSurf(Size).Surf, iRect, DDBLTFAST_SRCCOLORKEY
                End If
                
            Next m
        Next n
    End With
End Sub

'clippt das übergebene Rectangle im DestRect
Public Sub AdaptRect(ByRef RX As Long, ByRef RY As Long, ByRef SrcRect As RECT, ByRef DestRect As RECT)

    Dim h_Rect              As RECT
    Dim h_Right             As Integer
    Dim h_Bottom            As Integer

    h_Rect = SrcRect
        
    With h_Rect
        
        'rechter Rand
        h_Right = RX + (.Right - .Left)
        If h_Right > DestRect.Right Then .Right = .Right - (h_Right - DestRect.Right)
    
        'unterer Rand
        h_Bottom = RY + (.Bottom - .Top)
        If h_Bottom > DestRect.Bottom Then .Bottom = .Bottom - (h_Bottom - DestRect.Bottom)
    
        'linker Rand
        If RX < 0 Then
            .Left = .Left - RX
            RX = 0
        End If
    
        'oberer Rand
        If RY < 0 Then
            .Top = .Top - RY
            RY = 0
        End If
        
    End With
    
    SrcRect = h_Rect

End Sub


'lädt eine DirectDraw-Surface und gibt zurück ob Vorgang erfolgreich war
Public Function Create_Blt_Surf(ByRef SrcSurf As TSurf, ByRef DestSurf As TSurf, Optional ByVal KeyCol As Long = -1, Optional ByVal Width As Integer = -1, Optional ByVal Height As Integer = -1) As Boolean

    Dim SurfDesc        As DDSURFACEDESC2
    Dim ColKey          As DDCOLORKEY
           
    'Surface-Description
    With SurfDesc
        .lFlags = DDSD_CAPS
        
        If Width > 0 And Height > 0 Then
            .lFlags = .lFlags Or DDSD_WIDTH Or DDSD_HEIGHT
            .lWidth = Width
            .lHeight = Height
        End If
        
        .ddsCaps.lCaps = DDSCAPS_OFFSCREENPLAIN
    End With
    
    Set DestSurf.Surf = g_DD.CreateSurface(SurfDesc)       'Bild laden
    
    DestSurf.Width = SurfDesc.lWidth
    DestSurf.Height = SurfDesc.lHeight
    
    'ColorKey setzen
    ColKey.low = KeyCol
    ColKey.high = KeyCol
    DestSurf.Surf.SetColorKey DDCKEY_SRCBLT, ColKey
    
    DestSurf.Surf.BltFast 0, 0, SrcSurf.Surf, g_EmptyRect, DDBLTFAST_DONOTWAIT
    
End Function


'zeichnet Ebene
Public Sub Draw_DMap()
    
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
    
        WndLeft = .Wnd.Left * .PlainFactorX(3)
        WndTop = .Wnd.Top * .PlainFactorY(3)
        
        h_FromX = WndLeft \ .TileWidth(3) + 1
        h_ToX = (WndLeft + g_App.ResX - 1) \ .TileWidth(3) + 1
        h_FromY = WndTop \ .TileWidth(3) + 1
        h_ToY = (WndTop + g_App.ResY - 1) \ .TileWidth(3) + 1
        
        For n = h_FromX To h_ToX
            For m = h_FromY To h_ToY
                With g_DMapTile(n, m)
                    If .Type Then
                        h_RX = .VX - WndLeft
                        h_RY = .VY - WndTop
                        Blit_Surf h_RX, h_RY, .Pic
                    End If
                End With
            Next m
        Next n
    
    End With
    
End Sub
