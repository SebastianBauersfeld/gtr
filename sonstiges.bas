Attribute VB_Name = "gme_00_sonstiges"
Option Explicit

'Schriften
Public FontsLoaded                      As Boolean
Public Const MaxFonts                   As Integer = 3

Public Type THUDFont
    Letter(32 To 255)                   As RECT
    FontPic                             As DirectDrawSurface7
End Type
Public HUDFont(1 To MaxFonts)           As THUDFont

Public Const D3D_DIVX           As Single = 29.6
Public Const D3D_DIVY           As Single = 22.1
Public Const D3D_ADDX           As Single = -17.3
Public Const D3D_ADDY           As Single = 17.4

Public Type TVertexRect
    Vertex(1 To 4)              As D3DVERTEX
End Type

'================================================================================
'==== INI DATEI =================================================================
'================================================================================
Public Declare Function GetPrivateProfileString Lib "kernel32" Alias "GetPrivateProfileStringA" (ByVal lpApplicationName As String, ByVal lpKeyName As Any, ByVal lpDefault As String, ByVal lpReturnedString As String, ByVal nSize As Long, ByVal lpFileName As String) As Long
Private Declare Function WritePrivateProfileString Lib "kernel32" Alias "WritePrivateProfileStringA" (ByVal lpApplicationName As String, ByVal lpKeyName As Any, ByVal lpString As Any, ByVal lpFileName As String) As Long
Public INIFile                          As String

Public Declare Function ShowCursor Lib "user32" (ByVal bShow As Long) As Long 'Mauszeiger

'==================== um Vectoren schnell zu definieren ====================
Public Function Vector(ByVal a As Double, ByVal b As Double, ByVal c As Double) As D3DVECTOR
    Dim VecOut As D3DVECTOR
    
    With VecOut
        .X = a
        .Y = b
        .Z = c
    End With
    
    Vector = VecOut
End Function
'===========================================================================


'=== Sub um Surfaces zu laden ========================================================
Public Sub subLoadSurface(ByRef Picture As DirectDrawSurface7, ByRef Width As Integer, ByRef Height As Integer, ByRef File As String)
Dim Desc As DDSURFACEDESC2

Desc.lFlags = DDSD_CAPS
Desc.ddsCaps.lCaps = DDSCAPS_OFFSCREENPLAIN
Desc.lWidth = Width                       'wenn man kein Stretching vornehmen will
Desc.lHeight = Height                     'gibt man einfach die Originalauflösung an (in Pixeln)
Set Picture = g_DD.CreateSurfaceFromFile(File, Desc)
Picture.SetColorKey DDCKEY_SRCBLT, CKeyB

End Sub
'=====================================================================================


Public Sub subLoadFonts()
    Dim n As Long
    Dim m As Long


    'Schriften laden
    subLoadSurface HUDFont(1).FontPic, 256, 256, PicturePath & "font1.bmp"
    subLoadSurface HUDFont(2).FontPic, 170, 228, PicturePath & "font2.bmp"
    subLoadSurface HUDFont(3).FontPic, 266, 357, PicturePath & "font3.bmp"
    FontsLoaded = True
    
    Dim File As Integer
    Dim TMP As String
    Dim Pos As Long
    Dim Pos2 As Long
    
    FontsLoaded = False
    
    For m = 1 To MaxFonts
        File = FreeFile
        
        Open FontPath & m & ".fnt" For Input As #File
            
            For n = 32 To 255
                
                Input #File, TMP
                
                TMP = TMP & " "
                
                'LEFT
                Pos = InStr(1, TMP, "X", vbBinaryCompare)
                
                Pos2 = Pos + 2
                Do While Asc(Mid(TMP, Pos2, 1)) > 32
                    Pos2 = Pos2 + 1
                Loop
                
                HUDFont(m).Letter(n).Left = Mid(TMP, Pos + 2, Pos2 - Pos - 2)
            
                'TOP
                Pos = InStr(1, TMP, "Y", vbBinaryCompare)
                
                Pos2 = Pos + 2
                Do While Asc(Mid(TMP, Pos2, 1)) > 32
                    Pos2 = Pos2 + 1
                Loop
                
                HUDFont(m).Letter(n).Top = Mid(TMP, Pos + 2, Pos2 - Pos - 2)
                    
                'RIGHT
                Pos = InStr(1, TMP, "W", vbBinaryCompare)
                
                Pos2 = Pos + 2
                Do While Asc(Mid(TMP, Pos2, 1)) > 32
                    Pos2 = Pos2 + 1
                Loop
                
                HUDFont(m).Letter(n).Right = Mid(TMP, Pos + 2, Pos2 - Pos - 2) + HUDFont(m).Letter(n).Left
            
                'BOTTOM
                Pos = InStr(1, TMP, "H", vbBinaryCompare)
                
                Pos2 = Pos + 2
                Do While Asc(Mid(TMP, Pos2, 1)) > 32
                    Pos2 = Pos2 + 1
                Loop
                
                HUDFont(m).Letter(n).Bottom = Mid(TMP, Pos + 2, Pos2 - Pos - 2) + HUDFont(m).Letter(n).Top
            
            Next n
        
        Close #File
    Next m
End Sub


Public Sub subDrawHudText(ByVal X As Single, ByVal Y As Single, ByVal Text As String, ByVal i As Integer)
Dim n As Long
Dim TMPX As Single
Dim TMPY As Single
Dim tmpRect As RECT
Dim TMPRect2 As RECT

TMPX = X

For n = 1 To Len(Text)
    TMPY = Y
    
    If Asc(Mid(Text, n, 1)) >= 32 Then
    
        TMPRect2 = HUDFont(i).Letter(Asc(Mid(Text, n, 1)))
            
        With tmpRect
            
            .Left = 0
            .Top = 0
            .Right = 0
            .Bottom = 0
            
            subOverEdge TMPRect2.Right - TMPRect2.Left, TMPRect2.Bottom - TMPRect2.Top, 0, TMPX, TMPY, tmpRect
            
            .Left = TMPRect2.Left + .Left
            .Top = TMPRect2.Top + .Top
            
            .Right = TMPRect2.Left + .Right
            .Bottom = TMPRect2.Top + .Bottom
                
            BackBuffer.BltFast TMPX, TMPY, HUDFont(i).FontPic, tmpRect, DDBLTFAST_SRCCOLORKEY
        
            TMPX = TMPX + .Right - .Left
        End With
    End If
Next n

End Sub

Public Function fctGetTextLen(ByVal Text As String, ByVal i As Integer) As Long
Dim n As Long
Dim TMPX As Single
Dim tmpRect As RECT

TMPX = 0

For n = 1 To Len(Text)
    If Asc(Mid(Text, n, 1)) >= 32 Then
        tmpRect = HUDFont(i).Letter(Asc(Mid(Text, n, 1)))
            
        TMPX = TMPX + tmpRect.Right - tmpRect.Left
    End If
Next n

fctGetTextLen = TMPX

End Function

Public Function fctGetTextHeight(ByVal i As Integer) As Long
Dim TMPX As Single
Dim tmpRect As RECT
    
tmpRect = HUDFont(i).Letter(32)
TMPX = tmpRect.Bottom - tmpRect.Top

fctGetTextHeight = TMPX

End Function

'=== INI-API zum Auslesen verwenden =================================================
Function fctGetIniValue(ByRef iSect As String, ByRef iKey As String) As String
  Dim iValue As String
  Dim iR As Long
  
  iValue = Space$(50)
  iR = GetPrivateProfileString(iSect, iKey, 0, iValue, Len(iValue), INIFile)
  If iR > 1 Then iValue = Left$(iValue, iR)
  fctGetIniValue = iValue
End Function
'====================================================================================

'=== INI-API zum Schreiben verwenden ================================================
Function fctSetIniValue(ByRef iSect As String, ByRef iKey As String, ByRef iValue As String) As String
  Dim iW As Long
  
  iW = WritePrivateProfileString(iSect, iKey, iValue, INIFile)
End Function
'====================================================================================


'lädt und initialisiert eine Map
Public Sub subLoadMap()
    Dim FreeFileNum As Integer
    Dim ReadX       As Long
    Dim Ready       As Long
    Dim n           As Long
    Dim m           As Long
    Dim k           As Long
  
  
            Dim dmybol As Boolean
            Dim dmybyt As Byte
            Dim dmyint As Integer
            Dim dmyLng As Long
            Dim dmysng As Single
            
            
    ReqRAM = 32
    MapTileCount = 0
        
    'Map öffnen und auslesen
    With Map
        '.MapName = "test.gmf"
                    
        FreeFileNum = FreeFile 'Freie Dateinummer für Map-Datei holen
        
        Open MapPath & "\" & Map.MapName For Binary As FreeFileNum
                       
            Get FreeFileNum, , .Author
            Get FreeFileNum, , .Description
            Get FreeFileNum, , .RecPlayerCnt
            
            Get FreeFileNum, , .BackCol              'MapBackColor
    
            Get FreeFileNum, , dmybol
            
            Get FreeFileNum, , .GravX
            Get FreeFileNum, , .GravY
            Get FreeFileNum, , .PinballFactor
            Get FreeFileNum, , dmysng
            
            .RecPlayerCnt = Trim(.RecPlayerCnt)
            .Author = Trim(.Author)
            .Description = Trim(.Description)
                    
           'Kartendimensionen ermitteln
            Get FreeFileNum, , .BlockWidth
            Get FreeFileNum, , .BlockHeight

            Get #1, , dmysng
            Get #1, , dmysng
            Get #1, , dmysng
            Get #1, , dmysng
        
            Get #1, , dmysng
            Get #1, , dmysng
            Get #1, , dmysng
                        
            'Ob die Ebenen gebraucht werden
            For n = 1 To MAX_MAPTILE_PLAINS
                Get FreeFileNum, , .PlainNeed(n)
            Next n
            
            'MapTiles und zugehörige Bilder
            For k = 1 To MAX_MAPTILE_PLAINS
                
                If Map.PlainNeed(k) Then
                    
                    Get #1, , dmyLng
                    
                    For n = 1 To dmyLng
                        Get #1, , dmybyt
                        Get #1, , dmybyt
                    Next n
                    
                    'gebrauchte Bilder ermitteln und den MapTiles Bilder zuweisen
                    For n = 1 To MAX_MAPTILE_KINDS
                        MapTilePic(k, n).Used = False
                    Next n
                    
                    For n = 0 To CLng(.BlockWidth) * CLng(.BlockHeight) - 1
                        ReadX = n Mod CLng(.BlockWidth) + 1
                        Ready = n \ CLng(.BlockWidth) + 1
                        
                        With MapTile(k, ReadX, Ready)
                            Get FreeFileNum, , dmyLng
                        
                            .Type = 0
                            If dmyLng > 0 Then
                                MapTileCount = MapTileCount + 1
                            
                                MapTilePic(k, dmyLng).Used = True
                                .Type = 1
                            End If
                        End With
                    Next n
                    
                    
                End If
                
            Next k
            
        Close FreeFileNum
    End With
    
                            '###################################
                            GameModeList.ListCount = 1
                            GameModeList.Selected = 1
                            '###################################

    Map.BackCol = 0
    
End Sub




'gibt ein definiertes Emissive zurück
Public Function fctSetEmissive(ByVal r As Single, ByVal g As Single, ByVal b As Single, Optional a As Single = 0.5) As D3DCOLORVALUE
    
    With fctSetEmissive
        .a = a
        .r = r
        .g = g
        .b = b
    End With
    
End Function


'gibt ein definiertes VertexRectangle zurück
Public Function fctSetVertexRect(ByVal Left As Long, ByVal Top As Long, ByVal Width As Long, ByVal Height As Long) As TVertexRect
    Dim n As Long

    '1 2      'Das is die Reihenfolge der Ecken
    '3 4
    With fctSetVertexRect
        .Vertex(1).X = Left / D3D_DIVX + D3D_ADDX
        .Vertex(2).X = (Left + Width) / D3D_DIVX + D3D_ADDX
        .Vertex(3).X = Left / D3D_DIVX + D3D_ADDX
        .Vertex(4).X = (Left + Width) / D3D_DIVX + D3D_ADDX
        
        .Vertex(1).Y = -Top / D3D_DIVY + D3D_ADDY
        .Vertex(2).Y = -Top / D3D_DIVY + D3D_ADDY
        .Vertex(3).Y = -(Top + Height) / D3D_DIVY + D3D_ADDY
        .Vertex(4).Y = -(Top + Height) / D3D_DIVY + D3D_ADDY
        
        For n = 1 To 4
            .Vertex(n).Z = 0
        Next n
        
        .Vertex(1).tu = 0
        .Vertex(2).tu = 1
        .Vertex(3).tu = 0
        .Vertex(4).tu = 1
        
        .Vertex(1).tv = 0
        .Vertex(2).tv = 0
        .Vertex(3).tv = 1
        .Vertex(4).tv = 1
        
    End With

End Function

