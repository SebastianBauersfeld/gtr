Attribute VB_Name = "m_004_GRAPHIC_01"
Option Explicit

Private XRes                                As Integer
Private YRes                                As Integer
Private ScreenRect                          As RECT
Private MsgQueue()                          As TMsg
Private MsgCount                            As Long

'Initialisiert DirectX
Public Sub Init_DX()

    Set g_DX = New DirectX7
    
End Sub

'fährt DirectX herunter
Public Sub Unload_DX()
    
    Set g_DX = Nothing
    
End Sub

'Initialisiert DirectDraw und gibt zurück ob Vorgang erfolgreich war
Public Function Init_DD(ByVal ResX As Integer, ByVal ResY As Integer, ByVal ColDepth As Byte) As Boolean

    Dim FrontBufDesc        As DDSURFACEDESC2
    Dim Caps                As DDSCAPS2
        
    On Error GoTo error:
    
    XRes = ResX
    YRes = ResY
    ScreenRect = SetRect(0, 0, ResX, ResY)
    
    Set g_DD = g_DX.DirectDrawCreate("")
    
    'Focus auf Form setzen
    frmMain.Show
    
    'Cooperative Level setzen
    g_DD.SetCooperativeLevel frmMain.hWnd, DDSCL_EXCLUSIVE Or DDSCL_FULLSCREEN
    
    'Display mit Auflösung und Farbtiefe setzen
    g_DD.SetDisplayMode ResX, ResY, ColDepth, 0, DDSDM_DEFAULT
        
    'Komplexe Surface erstellen
    With FrontBufDesc
        .lFlags = DDSD_CAPS Or DDSD_BACKBUFFERCOUNT
        .ddsCaps.lCaps = DDSCAPS_PRIMARYSURFACE Or DDSCAPS_3DDEVICE Or DDSCAPS_FLIP Or _
                         DDSCAPS_COMPLEX Or DDSCAPS_VIDEOMEMORY
        .lBackBufferCount = 1
    End With
    
    Set g_FrontBuf = g_DD.CreateSurface(FrontBufDesc)
    
    'BackBuffer mit Frontbuffer verbinden
    Caps.lCaps = DDSCAPS_BACKBUFFER
    Set g_BackBuf = g_FrontBuf.GetAttachedSurface(Caps)

    'Schrifteigenschaften setzen
    g_BackBuf.SetFontTransparency True
    g_BackBuf.SetForeColor vbWhite

    Set g_DDI = g_DD.GetDeviceIdentifier(DDGDI_DEFAULT)

    Init_DD = True
    Exit Function
    
error:
    Init_DD = False
    
End Function

'fährt DirectDraw herunter
Public Sub Unload_DD()

    'Auflösung wiederherstellen
    g_DD.RestoreDisplayMode
    g_DD.SetCooperativeLevel frmMain.hWnd, DDSCL_NORMAL
    
    Set g_BackBuf = Nothing
    Set g_FrontBuf = Nothing
    Set g_DD = Nothing

End Sub

'lädt eine DirectDraw-Surface und gibt zurück ob Vorgang erfolgreich war
Public Function Load_Surf(ByVal Path As String, ByRef Surf As TSurf, Optional ByVal KeyCol As Long = -1, Optional ByVal Width As Integer = -1, Optional ByVal Height As Integer = -1) As Boolean

    Dim SurfDesc        As DDSURFACEDESC2
    Dim ColKey          As DDCOLORKEY
        
    'On Error GoTo error:
    
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
    
    Set Surf.Surf = g_DD.CreateSurfaceFromFile(Path, SurfDesc)     'Bild laden
    
    Surf.Width = SurfDesc.lWidth
    Surf.Height = SurfDesc.lHeight
    
    'ColorKey setzen
    ColKey.low = KeyCol
    ColKey.high = KeyCol
    Surf.Surf.SetColorKey DDCKEY_SRCBLT, ColKey
    
    'Load_Surf = True
    'Exit Function
    
'error:
    'Load_Surf = False
    
End Function

'löscht eine Surface aus dem Speicher
Public Sub Unload_Surf(ByRef Surf As TSurf)

    With Surf
        Set .Surf = Nothing
        .Width = 0
        .Height = 0
    End With

End Sub

Public Function SetRectPiece(ByVal Left As Long, ByVal Top As Long, ByVal Width As Long, ByVal Height As Long) As RECT
    
    With SetRectPiece
        .Left = Left
        .Top = Top
        .Right = .Left + Width
        .Bottom = .Top + Height
    End With
    
End Function

'gibt ein Rectangle zurück
Public Function SetRect(ByVal Left As Integer, ByVal Top As Integer, ByVal Right As Integer, ByVal Bottom As Integer) As RECT
    
    With SetRect
        .Left = Left
        .Top = Top
        .Right = Right
        .Bottom = Bottom
    End With
    
End Function

'gibt ein SngRectangle zurück
Public Function SetRectSng(ByVal Left As Single, ByVal Top As Single, ByVal Right As Single, ByVal Bottom As Single) As TRectSng
    
    With SetRectSng
        .Left = Left
        .Top = Top
        .Right = Right
        .Bottom = Bottom
    End With
    
End Function

'clippt das Rectangle und Zeichnet eine Surface
Public Sub Blit_Surf(ByVal RX As Integer, ByVal RY As Integer, ByRef Surf As TSurf)

    Dim h_Rect              As RECT
    Dim h_Right             As Integer
    Dim h_Bottom            As Integer

    With h_Rect
    
        .Left = 0
        .Top = 0
        .Right = Surf.Width
        .Bottom = Surf.Height
            
        'rechter Rand
        h_Right = RX + Surf.Width
        If h_Right > XRes Then .Right = .Right - (h_Right - XRes)
    
        'unterer Rand
        h_Bottom = RY + Surf.Height
        If h_Bottom > YRes Then .Bottom = .Bottom - (h_Bottom - YRes)
    
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
        
    'zeichnen
    g_BackBuf.BltFast RX, RY, Surf.Surf, h_Rect, DDBLTFAST_DONOTWAIT Or DDBLTFAST_SRCCOLORKEY

End Sub

'clippt das Rectangle und Zeichnet eine Surface
Public Sub Blit_ClippedSurf(ByRef ClipRect As RECT, ByVal RX As Integer, ByVal RY As Integer, ByRef Surf As TSurf)

    Dim h_Rect              As RECT
    Dim h_Right             As Integer
    Dim h_Bottom            As Integer
    Dim h_ClipRect          As RECT

    With h_Rect
    
        With h_ClipRect
            h_ClipRect = ClipRect
            
            If .Left < 0 Then .Left = 0
            If .Top < 0 Then .Top = 0
            If .Right > XRes Then .Right = XRes
            If .Bottom > YRes Then .Bottom = YRes
        End With
        
        .Left = 0
        .Top = 0
        .Right = Surf.Width
        .Bottom = Surf.Height
            
        'rechter Rand
        h_Right = RX + Surf.Width
        If h_Right > h_ClipRect.Right Then .Right = .Right - (h_Right - h_ClipRect.Right)
    
        'unterer Rand
        h_Bottom = RY + Surf.Height
        If h_Bottom > h_ClipRect.Bottom Then .Bottom = .Bottom - (h_Bottom - h_ClipRect.Bottom)
    
        'linker Rand
        If RX < h_ClipRect.Left Then
            .Left = .Left + (h_ClipRect.Left - RX)
            RX = h_ClipRect.Left
        End If
    
        'oberer Rand
        If RY < h_ClipRect.Top Then
            .Top = .Top + (h_ClipRect.Top - RY)
            RY = h_ClipRect.Top
        End If
        
    End With
        
    'zeichnen
    g_BackBuf.BltFast RX, RY, Surf.Surf, h_Rect, DDBLTFAST_DONOTWAIT Or DDBLTFAST_SRCCOLORKEY

End Sub

'clippt das übergebene Rectangle und Zeichnet eine Surface
Public Sub Blit_SurfSector(ByVal RX As Integer, ByVal RY As Integer, ByRef Surf As TSurf, ByRef Rectangle As RECT)

    Dim h_Rect              As RECT
    Dim h_Right             As Integer
    Dim h_Bottom            As Integer

    h_Rect = Rectangle
        
    With h_Rect
        
        'rechter Rand
        h_Right = RX + (.Right - .Left)
        If h_Right > XRes Then .Right = .Right - (h_Right - XRes)
    
        'unterer Rand
        h_Bottom = RY + (.Bottom - .Top)
        If h_Bottom > YRes Then .Bottom = .Bottom - (h_Bottom - YRes)
    
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
    
    'zeichnen
    g_BackBuf.BltFast RX, RY, Surf.Surf, h_Rect, DDBLTFAST_DONOTWAIT Or DDBLTFAST_SRCCOLORKEY

End Sub

'Initialisiert die Eigenschaften einer Animation
Public Sub Init_Animation(ByRef Surf As TSurf, ByRef Animation As TAnimation, ByVal NumFrames As Integer)

    With Animation
        .NumFrames = NumFrames
        .FrameWidth = Surf.Width \ NumFrames
        .ActFrameSng = 1
        .ActFrameInt = 1
    End With

End Sub

'setzt ein AnimationsFrame
Public Sub SetAnimationFrame(ByRef Animation As TAnimation, ByVal Frame As Single)
    
    With Animation
        .ActFrameSng = Frame
        
        Do While .ActFrameSng < 1
            .ActFrameSng = .ActFrameSng + .NumFrames
        Loop
        
        Do While .ActFrameSng >= .NumFrames + 1
            .ActFrameSng = .ActFrameSng - .NumFrames
        Loop
                    
        .ActFrameInt = Int(.ActFrameSng)
    End With

End Sub

'animiert eine Animation
Public Sub Proceed_Animation(ByRef Animation As TAnimation, ByVal Speed As Single)

    With Animation
        .ActFrameSng = .ActFrameSng + Speed
                            
        Do While .ActFrameSng < 1
            .ActFrameSng = .ActFrameSng + .NumFrames
        Loop
        
        Do While .ActFrameSng >= .NumFrames + 1
            .ActFrameSng = .ActFrameSng - .NumFrames
        Loop
                        
        .ActFrameInt = Int(.ActFrameSng)
    End With

End Sub

'clippt eine Animation und zeichnet diese
Public Sub Blit_Animation(ByVal RX As Integer, ByVal RY As Integer, ByRef Surf As TSurf, ByRef Animation As TAnimation)

    Dim h_Rect              As RECT
    Dim h_Right             As Integer
    Dim h_Bottom            As Integer

    With h_Rect
        .Left = Animation.FrameWidth * (Animation.ActFrameInt - 1)
        .Top = 0
        .Right = .Left + Animation.FrameWidth
        .Bottom = Surf.Height
        
        'rechter Rand
        h_Right = RX + Animation.FrameWidth
        If h_Right > XRes Then .Right = .Right - (h_Right - XRes)
    
        'unterer Rand
        h_Bottom = RY + Surf.Height
        If h_Bottom > YRes Then .Bottom = .Bottom - (h_Bottom - YRes)

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
    
    'zeichnen
    g_BackBuf.BltFast RX, RY, Surf.Surf, h_Rect, DDBLTFAST_DONOTWAIT Or DDBLTFAST_SRCCOLORKEY

End Sub

'wandelt RGB-Farbe in Long-Farbe um (nur für 16 und 32 Bit)
Public Function CRGB(ByVal r As Byte, ByVal g As Byte, ByVal b As Byte, Optional ByVal ColDepth As Byte = 32, Optional ByVal Reverse As Boolean = True) As Long
    
    If Reverse Then
        
        Select Case ColDepth
                
            Case 32:
                CRGB = b + BitDisp(g, 8) + BitDisp(r, 16)
                
            Case 16:
                CRGB = BitDisp(b, -3) + BitDisp(BitDisp(g, -2), 5) + BitDisp(BitDisp(r, -3), 11)
            
            Case Else:
                CRGB = 0
        
        End Select
        
    Else
    
        Select Case ColDepth
                
            Case 32:
                CRGB = r + BitDisp(g, 8) + BitDisp(b, 16)
                
            Case 16:
                CRGB = BitDisp(r, -3) + BitDisp(BitDisp(g, -2), 5) + BitDisp(BitDisp(b, -3), 11)
            
            Case Else:
                CRGB = 0
        
        End Select
    
    End If
    
End Function

'Bitverschiebung (nur für positive Zahlen)
Public Function BitDisp(ByVal Val As Long, ByVal Disp As Integer) As Long

    Dim Bit(0 To 30)    As Byte
    Dim LngVal          As Long
    Dim n               As Long
    Dim SgnDisp         As Integer
    
    'in BitZahl umrechnen
    For n = 30 To 0 Step -1
        If Val \ (2 ^ n) Then
            Bit(n) = 1
            Val = Val - 2 ^ n
        Else
            Bit(n) = 0
        End If
    Next
    
    'verschieben
    SgnDisp = Sgn(Disp)
    Disp = Abs(Disp)
    
    If SgnDisp = 1 Then         'nach links verschieben
        For n = 30 To Disp Step -1
            Bit(n) = Bit(n - Disp)
        Next
        
        For n = 0 To Disp - 1
            Bit(n) = 0
        Next
    ElseIf SgnDisp = -1 Then    'nach rechts verschieben
        For n = 0 To 30 - Disp
            Bit(n) = Bit(n + Disp)
        Next
        
        For n = 30 - Disp + 1 To 30
            Bit(n) = 0
        Next
    End If
    
    'zurückrechnen
    LngVal = 0
    
    For n = 0 To 30
        LngVal = LngVal + Bit(n) * (2 ^ n)
    Next
    
    BitDisp = LngVal

End Function

'lädt eine Bitmap-Schriftart
Public Function Load_Font(ByVal DescPath As String, ByVal SurfPath As String, ByRef Font As TFont, Optional ByVal KeyCol As Long = -1, Optional ByVal Width As Integer = -1, Optional ByVal Height As Integer = -1) As Boolean
    
    Dim n               As Long
    Dim FileNum         As Integer
    Dim h_Line          As String
    Dim h_Pos(1 To 2)   As Long
        
    On Error GoTo error:
    
    FileNum = FreeFile
        
    Open DescPath For Input As #FileNum         'Description-Datei öffnen
        
        For n = 32 To 255
            
            With Font.Letter(n)
            
                Input #FileNum, h_Line               'gesamte Zeile einlesen
                h_Line = h_Line & " "
                
                'LEFT
                h_Pos(1) = InStr(1, h_Line, "X", vbBinaryCompare) + 2
                h_Pos(2) = InStr(h_Pos(1), h_Line, " ", vbBinaryCompare)
                
                .Left = Mid(h_Line, h_Pos(1), h_Pos(2) - h_Pos(1))
            
                'TOP
                h_Pos(1) = InStr(1, h_Line, "Y", vbBinaryCompare) + 2
                h_Pos(2) = InStr(h_Pos(1), h_Line, " ", vbBinaryCompare)
                
                .Top = Mid(h_Line, h_Pos(1), h_Pos(2) - h_Pos(1))
                    
                'RIGHT
                h_Pos(1) = InStr(1, h_Line, "W", vbBinaryCompare) + 2
                h_Pos(2) = InStr(h_Pos(1), h_Line, " ", vbBinaryCompare)
                
                .Right = .Left + Mid(h_Line, h_Pos(1), h_Pos(2) - h_Pos(1))
            
                'BOTTOM
                h_Pos(1) = InStr(1, h_Line, "H", vbBinaryCompare) + 2
                h_Pos(2) = InStr(h_Pos(1), h_Line, " ", vbBinaryCompare)
                
                .Bottom = .Top + Mid(h_Line, h_Pos(1), h_Pos(2) - h_Pos(1))
                
            End With
            
        Next
        
    Close #FileNum
    
    'Surface laden
    If Load_Surf(SurfPath, Font.Surf, KeyCol, Width, Height) Then
        Load_Font = True
        Exit Function
    Else
        GoTo error:
    End If
    
error:
    Load_Font = False

End Function

'gibt Text aus (Bitmap-Font)
Public Sub Blit_Text(ByVal RX As Integer, ByVal RY As Integer, ByVal Text As String, ByRef Font As TFont)

    Dim n                   As Long
    Dim h_Asc               As Integer
        
    With Font
        For n = 1 To Len(Text)
            h_Asc = Asc(Mid(Text, n, 1))
            
            If h_Asc >= 32 Then                                         'zeichnen
                Blit_SurfSector RX, RY, .Surf, .Letter(h_Asc)
                
                'Position um einen Buchstaben verschieben
                RX = RX + .Letter(h_Asc).Right - .Letter(h_Asc).Left
            End If
        Next
    End With

End Sub

'Gibt die Pixel-Breite eines Textes zurück
Public Function GetTextWidth(ByVal Text As String, ByRef Font As TFont) As Integer
    
    Dim n               As Long
    Dim h_Asc           As Integer
    Dim h_Width         As Integer
    
    h_Width = 0
    
    For n = 1 To Len(Text)
        h_Asc = Asc(Mid(Text, n, 1))
            
        With Font.Letter(h_Asc)
            If h_Asc >= 32 Then h_Width = h_Width + .Right - .Left
        End With
    Next

    GetTextWidth = h_Width
    
End Function

'Gibt die Pixel-Höhe eines Textes zurück
Public Function GetTextHeight(ByRef Font As TFont) As Integer

    With Font.Letter(32)
        GetTextHeight = .Bottom - .Top
    End With

End Function

'Gibt einen TextBlock aus
Public Sub Draw_TextBlock(ByVal Text As String, ByVal X As Integer, ByVal Y As Integer, ByVal Width As Integer, ByRef Font As TFont, Optional ByVal Alignment As ETextAlignment = TEXT_ALIGNMENT_LEFT)

    Dim h_Pos(1 To 2)   As Long
    Dim m               As Long
    Dim h_WidthCnt      As Integer
    Dim h_HeightCnt     As Integer
    Dim h_TextWidth     As Integer
    Dim h_TextX         As Integer
    Dim h_OutputString  As String
    
    h_WidthCnt = 0
    h_HeightCnt = 0
    h_Pos(1) = 0
    h_Pos(2) = 0
    
    Do While h_Pos(2) < Len(Text)
        h_Pos(2) = h_Pos(2) + 1
        h_WidthCnt = h_WidthCnt + GetTextWidth(Mid(Text, h_Pos(2), 1), Font)
        
        If h_WidthCnt > Width Then
            
            'Breite zu gering für einen Buchstaben
            If h_Pos(2) - h_Pos(1) = 1 Then Exit Sub
            
            'nach dem nächsten Leerzeichen suchen
            For m = h_Pos(2) To h_Pos(1) Step -1
                If m > h_Pos(1) Then
                    If Mid(Text, m, 1) = " " Then Exit For
                End If
            Next
        
            If m > h_Pos(1) Then
                h_Pos(2) = m
            Else
                h_Pos(2) = h_Pos(2) - 1
            End If
            
            'Text-Ausrichtung
            h_OutputString = Trim(Mid(Text, h_Pos(1) + 1, h_Pos(2) - h_Pos(1)))
            
            Select Case Alignment
                Case TEXT_ALIGNMENT_LEFT:
                    h_TextX = X
                Case TEXT_ALIGNMENT_RIGHT:
                    h_TextX = X + Width - GetTextWidth(h_OutputString, Font)
                Case TEXT_ALIGNMENT_CENTERED:
                    h_TextX = X + (Width - GetTextWidth(h_OutputString, Font)) * 0.5
            End Select
            
            'Ausgabe
            Blit_Text h_TextX, Y + h_HeightCnt, h_OutputString, Font
            
            h_WidthCnt = 0
            h_HeightCnt = h_HeightCnt + GetTextHeight(Font)
            h_Pos(1) = h_Pos(2)
        End If
    Loop
    
    'Text-Ausrichtung
    h_OutputString = Trim(Mid(Text, h_Pos(1) + 1, h_Pos(2) - h_Pos(1)))
    
    Select Case Alignment
        Case TEXT_ALIGNMENT_LEFT:
            h_TextX = X
        Case TEXT_ALIGNMENT_RIGHT:
            h_TextX = X + Width - GetTextWidth(h_OutputString, Font)
        Case TEXT_ALIGNMENT_CENTERED:
            h_TextX = X + (Width - GetTextWidth(h_OutputString, Font)) * 0.5
    End Select
    
    'Ausgabe
    Blit_Text h_TextX, Y + h_HeightCnt, h_OutputString, Font
    
End Sub

'initialisiert die Msg-Schlange
Public Sub Init_MsgQueue()
    
    MsgCount = 0

End Sub

'fügt eine Msg zur Msg-Schlange dazu
Public Sub Add_Msg(ByVal X As Integer, ByVal Y As Integer, ByVal Text As String)
        
    MsgCount = MsgCount + 1
    
    ReDim Preserve MsgQueue(1 To MsgCount)
    
    With MsgQueue(MsgCount)
        .X = X
        .Y = Y
        .Text = Text
    End With
    
End Sub

'zeichnet alle Msgs
Public Sub Blit_Msgs()

    Dim n           As Long
    
    For n = 1 To MsgCount
        With MsgQueue(n)
            g_BackBuf.DrawText .X, .Y, .Text, False
        End With
    Next
    
    MsgCount = 0
    
End Sub

'Initialisiert Direct3D und gibt zurück ob Vorgang erfolgreich war
Public Function Init_D3D(ByVal ResX As Integer, ByVal ResY As Integer) As Boolean
    
    Dim n                   As Long
    Dim ViewPort            As D3DVIEWPORT7
    Dim GetZBuf             As Direct3DEnumPixelFormats
    Dim PrimaryZBuf         As DDSURFACEDESC2
    Dim PixFMTZBuf          As DDPIXELFORMAT
    
    On Error GoTo error:
    
    Set g_D3D = g_DD.GetDirect3D
    Set g_D3DDev = g_D3D.CreateDevice("IID_IDirect3DHALDevice", g_BackBuf)
        
    'Z-Buffer
    Set GetZBuf = g_D3D.GetEnumZBufferFormats("IID_IDirect3DHALDevice")
     
    For n = 1 To GetZBuf.GetCount()
        GetZBuf.GetItem n, PixFMTZBuf
        If PixFMTZBuf.lFlags = DDPF_ZBUFFER Then Exit For
    Next
    
    With PrimaryZBuf
        .lFlags = DDSD_CAPS Or DDSD_WIDTH Or DDSD_HEIGHT Or DDSD_PIXELFORMAT
        .ddsCaps.lCaps = DDSCAPS_ZBUFFER
        .lWidth = ResX
        .lHeight = ResY
        .ddpfPixelFormat = PixFMTZBuf
    End With
    
    Set g_ZBuf = g_DD.CreateSurface(PrimaryZBuf)
    g_BackBuf.AddAttachedSurface g_ZBuf
    
    g_D3DDev.SetRenderState D3DRENDERSTATE_ZENABLE, 0
    
    '3D-Render-Bereich deklarieren
    With ViewPort
        .lX = 0
        .lY = 0
        .lWidth = ResX
        .lHeight = ResY
    End With
    
    g_D3DDev.SetViewport ViewPort
    
    With g_RectViewport(0)
        .X1 = 0
        .Y1 = 0
        .X2 = ResX
        .Y2 = ResY
    End With
    
    'BildschirmPosition setzen
    g_DX.IdentityMatrix g_matView
                              
    g_DX.ViewMatrix g_matView, SetVector(0, 0, -30), SetVector(0, 0, 0), SetVector(0, 1, 0), 0
    
    g_D3DDev.SetTransform D3DTRANSFORMSTATE_VIEW, g_matView
      
    'Projektion der 3D-Welt festlegen
    g_DX.IdentityMatrix g_matProj
        
    g_DX.ProjectionMatrix g_matProj, 1, 5000, PI / 3
    g_D3DDev.SetTransform D3DTRANSFORMSTATE_PROJECTION, g_matProj
    
    g_D3DDev.SetRenderTarget g_BackBuf
    
    g_D3DDev.SetRenderState D3DRENDERSTATE_CULLMODE, D3DCULL_NONE
    
    'Vergrößerung und Verkleinerung:
    g_D3DDev.SetTextureStageState 0, D3DTSS_MAGFILTER, D3DTFG_LINEAR
    g_D3DDev.SetTextureStageState 0, D3DTSS_MINFILTER, D3DTFG_LINEAR

    g_D3DDivX = 29.5615
    g_D3DDivY = 22.171
    g_D3DSubX = -17.3198
    g_D3DSubY = 17.3199

    Init_D3D = True
    Exit Function
    
error:
    Init_D3D = False

End Function

'fährt Direct3D herunter
Public Sub Unload_D3D()

    Set g_ZBuf = Nothing
    Set g_D3DDev = Nothing
    Set g_D3D = Nothing

End Sub

'definiert einen D3D-Vector
Public Function SetVector(ByVal a As Single, ByVal b As Single, ByVal c As Single) As D3DVECTOR
    
    With SetVector
        .X = a
        .Y = b
        .Z = c
    End With
    
End Function

'macht einen ScreenShot
Public Function ScreenShot(ByVal Path As String, ByRef PicBox As PictureBox) As Boolean

    Dim h_ScreenSurf        As DDSURFACEDESC2
    Dim DeskhWnd            As Long
    Dim DeskDC              As Long
      
    On Error GoTo error:
      
    'Breite des Bildes
    g_DD.GetDisplayMode h_ScreenSurf
    PicBox.Width = h_ScreenSurf.lWidth
    PicBox.Height = h_ScreenSurf.lHeight
        
    DeskhWnd = GetDesktopWindow()
    DeskDC = GetDC(DeskhWnd)
    
    'Auf Bild zeichnen
    BitBlt PicBox.hdc, 0, 0, PicBox.Width, PicBox.Height, DeskDC, 0, 0, vbSrcCopy
    ReleaseDC DeskhWnd, DeskDC
        
    'Bild speichern
    SavePicture PicBox.Image, Path
    PicBox.Cls
    
    ScreenShot = True
    Exit Function
    
error:
    ScreenShot = False
        
End Function

'aktiviert / deaktiviert den Cursor
Public Sub DisplayCursor(ByVal Visible As Boolean)
        
    If Visible Then
        Do Until ShowCursor(True) = 0
        Loop
    Else
        Do While ShowCursor(False) = -1
        Loop
    End If
        
End Sub

Public Sub subSetAlpha(ByRef Alpha As Long, ByRef Effect As EAlphaEffect, ByRef Textured As Boolean)
    
    Dim Src As Long
    Dim Dest As Long
    
    g_D3DDev.SetRenderState D3DRENDERSTATE_ALPHABLENDENABLE, Alpha
        
    If InStr(1, g_DDI.GetDescription, "Voodoo", vbBinaryCompare) > 0 Then
        Select Case Effect
        Case A_OFF
            Src = 1
            Dest = 1
        Case A_ADD
            Src = 2
            Dest = 2
        Case A_MULTIPLY
            Src = 3
            Dest = 5
        Case A_SUBTRACT
            Src = 3
            Dest = 7
        Case A_INVERT
            Src = 10
            Dest = 4
        End Select
    Else
        If Textured Then
            Select Case Effect
            Case A_OFF
                Src = 1
                Dest = 1
            Case A_ADD
                Src = 2
                Dest = 2
            Case A_MULTIPLY
                Src = 9
                Dest = 5
            Case A_SUBTRACT
                Src = 6
                Dest = 3
            Case A_INVERT
                Src = 10
                Dest = 4
            End Select
        Else
            Select Case Effect
            Case A_OFF
                Src = 1
                Dest = 1
            Case A_ADD
                Src = 2
                Dest = 2
            Case A_MULTIPLY
                Src = 9
                Dest = 7
            Case A_SUBTRACT
                Src = 8
                Dest = 3
            Case A_INVERT
                Src = 10
                Dest = 4
            End Select
        End If
    End If
    
    g_D3DDev.SetRenderState D3DRENDERSTATE_SRCBLEND, Src
    g_D3DDev.SetRenderState D3DRENDERSTATE_DESTBLEND, Dest

End Sub

Public Sub Load_Texture(ByRef Path As String, ByRef Tex As DirectDrawSurface7)
    
    Dim ddsd3 As DDSURFACEDESC2
    Dim TextureEnum As Direct3DEnumPixelFormats
    
    Set TextureEnum = g_D3DDev.GetTextureFormatsEnum()
    TextureEnum.GetItem 1, ddsd3.ddpfPixelFormat
    ddsd3.ddsCaps.lCaps = DDSCAPS_TEXTURE
    Set Tex = g_DD.CreateSurfaceFromFile(Path, ddsd3)

End Sub
