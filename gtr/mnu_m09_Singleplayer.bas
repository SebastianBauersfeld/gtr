Attribute VB_Name = "mnu_m09_Singleplayer"
Option Explicit


Public Sub subDrawSingleplayerMenu()
        
    With SubMenu
    
        subDrawHudText 885, .DDLine(0, 1) + 12, "Singleplayer", 3
        
        BackBuffer.DrawLine .DDLine(1, 0), .DDLine(0, 1) + 22, .DDLine(0, 0) - 150, .DDLine(0, 1) + 22
        BackBuffer.DrawLine .DDLine(1, 0) - 7, .DDLine(0, 1) + 25, .DDLine(0, 0) - 150, .DDLine(0, 1) + 25
        
        BackBuffer.DrawLine .DDLine(0, 0) - 150, .DDLine(0, 1), .DDLine(0, 0) - 150, .DDLine(0, 1) + 50
        BackBuffer.DrawLine .DDLine(0, 0), .DDLine(0, 1) + 50, .DDLine(0, 0) - 150, .DDLine(0, 1) + 50
        
        
        Dim PosX As Integer
        Dim PosY As Integer
        
        PosX = 240
        PosY = 200
        If .MenuStatus = S_CreateSingle Then
        
            subDrawList PosX, PosY, 250, 8, "Map Choice", MapListBox
            
            subDrawList PosX, PosY + 393, 250, 4, "Game Type", GameModeList
            
            subDrawMapProps PosX, PosY
        
            subDrawButton 850, 740, "Start Game", Event_StartSingle
            
            subDrawButton 960, 740, "Back", Event_BackToMenu
            
            subDrawScroller 240, 740, 200, "Number of Bots", BotCount, 0, 99
            
            subDrawCheckBox 650, 740, "Map Destroyable", MapIsDestroyable
            
        End If
        
    End With
    
End Sub


Public Sub subDrawMapProps(X As Integer, Y As Integer)

    Dim n As Long
    Dim m As Long
    Dim TMPX As Long
    Dim PosX As Long
    Dim PosY As Long
    Dim pX As Long
    Dim pY As Long

    With Map

        If .MapName <> MapListBox.List(MapListBox.Selected) & ".gmf" Then
        
            .MapName = MapListBox.List(MapListBox.Selected) & ".gmf"
        
            subLoadMap
            
        End If
    
        BackBuffer.SetForeColor RGB(190, 190, 190)
        BackBuffer.DrawLine X, Y + 8 * 20 + 26, X, Y + 8 * 20 + 339
        BackBuffer.DrawBox X + 250, Y + 500, X + 250 + 500, Y
        
        subDrawHudText X + 3, Y + 8 * 20 + 30, "Author: " & .Author, 2

        TMPX = 0
        m = -1
        Do
            m = m + 1
            n = -1
            Do
                n = n + 1
            Loop Until Mid(.Description, TMPX + 30 - n, 1) = " "
            subDrawHudText X + 3, Y + 160 + 54 + m * 20, Trim(Mid(.Description, TMPX + 1, 30 - n)), 2
            TMPX = TMPX + 30 - n
        Loop Until m > 10
        
        pX = 250 - .BlockWidth
        pY = 250 - .BlockHeight
        
        BackBuffer.DrawBox X + 250 + pX, Y + pY, X + 250 + .BlockWidth * 2 + pX, Y + .BlockHeight * 2 + pY
        
        Dim Surf As DDSURFACEDESC2
        BackBuffer.Lock EmptyRect, Surf, DDLOCK_WRITEONLY, 0
                    
            For n = 1 To .BlockWidth
                For m = 1 To .BlockHeight
                    If MapTile(3, n, m).Type > 0 Then BackBuffer.SetLockedPixel pX + X + n * 2 - 1 + 250, pY + Y + m * 2 - 1, &HFFFFFF
                    If MapTile(3, n, m).Type > 0 Then BackBuffer.SetLockedPixel pX + X + n * 2 - 1 + 250, pY + Y + m * 2, &HFFFFFF
                    If MapTile(3, n, m).Type > 0 Then BackBuffer.SetLockedPixel pX + X + n * 2 + 250, pY + Y + m * 2 - 1, &HFFFFFF
                    If MapTile(3, n, m).Type > 0 Then BackBuffer.SetLockedPixel pX + X + n * 2 + 250, pY + Y + m * 2, &HFFFFFF
                Next m
            Next n
                
        BackBuffer.Unlock EmptyRect
        
        BackBuffer.DrawBox X, Y + 8 * 20 + 339, X + 600, Y + 8 * 20 + 359
        
        subDrawHudText X + 3, Y + 8 * 20 + 341, "Rec. Players: " & .RecPlayerCnt, 2
        BackBuffer.DrawLine X + 147, Y + 8 * 20 + 339, X + 147, Y + 8 * 20 + 359
        subDrawHudText X + 150, Y + 8 * 20 + 341, "WxH: " & .BlockWidth & "x" & .BlockHeight, 2
        BackBuffer.DrawLine X + 267, Y + 8 * 20 + 339, X + 267, Y + 8 * 20 + 359
        
        subDrawHudText X + 270, Y + 8 * 20 + 341, "GravX/GravY: " & .GravX & "/" & .GravY * 20, 2
        
        If MapIsDestroyable Then
            ReqRAM = 32 + MapTileCount * 0.03125
        Else
            ReqRAM = 32 + MapTileCount * 0.03125 * 0.1
        End If
        
        BackBuffer.DrawLine X + 450, Y + 8 * 20 + 339, X + 450, Y + 8 * 20 + 359
        subDrawHudText X + 452, Y + 8 * 20 + 341, "Req. RAM: >" & CLng(ReqRAM), 2
        
    End With
End Sub



