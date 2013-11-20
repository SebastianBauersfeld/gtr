Attribute VB_Name = "mnu_m08_Options"
Option Explicit

Public Sub subDrawOptionsMenu()
    
    With SubMenu
    
        If MouseY > .DDLine(0, 1) + 3 And MouseY < .DDLine(0, 1) + 23 And MouseLUp Then
            Select Case MouseX
                Case 300 To 350: .MenuStatus = S_Misc
                Case 400 To 450: .MenuStatus = S_Video
                Case 500 To 550: .MenuStatus = S_Input
                Case 600 To 650: .MenuStatus = S_Player: FlyerBox.LoadFlyer = True
            End Select
        End If
        
        subDrawHudText 930, .DDLine(0, 1) + 12, "Options", 3
        
        If .MenuStatus <> S_Misc Then subDrawHudText 300, .DDLine(0, 1) + 3, "Misc", 1
        If .MenuStatus <> S_Video Then subDrawHudText 400, .DDLine(0, 1) + 3, "Video", 1
        If .MenuStatus <> S_Input Then subDrawHudText 500, .DDLine(0, 1) + 3, "Input", 1
        If .MenuStatus <> S_Player Then subDrawHudText 600, .DDLine(0, 1) + 3, "Player", 1
        
        BackBuffer.DrawLine .DDLine(0, 0) - 105, .DDLine(0, 1), .DDLine(0, 0) - 105, .DDLine(0, 1) + 50
        BackBuffer.DrawLine .DDLine(0, 0), .DDLine(0, 1) + 50, .DDLine(0, 0) - 105, .DDLine(0, 1) + 50
        
        If .MenuStatus = S_Misc Then subDrawMiscOptions
        If .MenuStatus = S_Video Then subDrawVideoOptions
        If .MenuStatus = S_Input Then subDrawInputOptions
        If .MenuStatus = S_Player Then subDrawPlayerOptions
        
        
        subDrawButton 960, 740, "Cancel", Event_RestoreData
        subDrawButton 900, 740, "Apply", Event_SaveData
        
    End With
    
End Sub

Public Sub subDrawVideoOptions()
    Dim PosX As Integer
    Dim PosY As Integer

    With SubMenu
        BackBuffer.DrawLine .DDLine(1, 0), .DDLine(0, 1) + 22, 390, .DDLine(0, 1) + 22
        BackBuffer.DrawLine .DDLine(1, 0) - 7, .DDLine(0, 1) + 25, 390, .DDLine(0, 1) + 25
        BackBuffer.DrawLine 390, .DDLine(0, 1), 390, .DDLine(0, 1) + 25
        
        BackBuffer.DrawLine 450, .DDLine(0, 1) + 22, .DDLine(0, 0) - 105, .DDLine(0, 1) + 22
        BackBuffer.DrawLine 450, .DDLine(0, 1) + 25, .DDLine(0, 0) - 105, .DDLine(0, 1) + 25
        
        BackBuffer.DrawLine 450, .DDLine(0, 1) + 25, 450, .DDLine(0, 1)
    End With
    
    subDrawHudText 400, SubMenu.DDLine(0, 1) + 3, "Video", 2
    
    subDrawHudText 300, 170, "Graphic Card: " & DDI.GetDescription, 2
    subDrawHudText 300, 190, "Driver:       " & DDI.GetDriver, 2
    
    
    subDrawCheckBox 300, 300, "Show Respawn Effect", DrawRespawnEffect
    subDrawCheckBox 300, 330, "Render Shockwaves", UseShockWaves
    subDrawCheckBox 300, 360, "Render Lights", UseLights
    subDrawCheckBox 300, 390, "Render Impulse", DrawImpulse
    
    PosX = 220
    PosY = 460
    subDrawCheckBox PosX + 15, PosY, "Draw Stars", DrawBackStars
    If DrawBackStars Then
        subDrawOpenBox PosX, PosY + 10, 270, 130, 110
        subDrawScroller PosX + 15, PosY + 30, 100, "Count on Level 1", CMaxBackStars(1), 1, 300
        subDrawScroller PosX + 15, PosY + 60, 100, "Count on Level 2", CMaxBackStars(2), 1, 300
        subDrawScroller PosX + 15, PosY + 90, 100, "Count on Level 3", CMaxBackStars(3), 1, 300
    End If
    
    PosX = 520
    PosY = 460
    subDrawHudText PosX + 15, PosY, "High Detail Explosions", 2
    subDrawOpenBox PosX, PosY + 10, 330, 135, 80
    subDrawScroller PosX + 15, PosY + 30, 150, "Explosion Detail", CMaxExploParts, 30, 500
    subDrawScroller PosX + 15, PosY + 60, 100, "Weapon Explosion Detail", CMaxWExploParts, 5, 50
    
    
    
End Sub

Public Sub subDrawInputOptions()

    With SubMenu
        BackBuffer.DrawLine .DDLine(1, 0), .DDLine(0, 1) + 22, 490, .DDLine(0, 1) + 22
        BackBuffer.DrawLine .DDLine(1, 0) - 7, .DDLine(0, 1) + 25, 490, .DDLine(0, 1) + 25
        BackBuffer.DrawLine 490, .DDLine(0, 1), 490, .DDLine(0, 1) + 25
        
        BackBuffer.DrawLine 545, .DDLine(0, 1) + 22, .DDLine(0, 0) - 105, .DDLine(0, 1) + 22
        BackBuffer.DrawLine 545, .DDLine(0, 1) + 25, .DDLine(0, 0) - 105, .DDLine(0, 1) + 25
        
        BackBuffer.DrawLine 545, .DDLine(0, 1) + 25, 545, .DDLine(0, 1)
    End With
    
    subDrawHudText 500, SubMenu.DDLine(0, 1) + 3, "Input", 2
    
    subDrawKeyInput 400, 250, 310, 355

End Sub

Public Sub subDrawMiscOptions()

    With SubMenu
        BackBuffer.DrawLine 350, .DDLine(0, 1) + 22, .DDLine(0, 0) - 105, .DDLine(0, 1) + 22
        BackBuffer.DrawLine 350, .DDLine(0, 1) + 25, .DDLine(0, 0) - 105, .DDLine(0, 1) + 25
        
        BackBuffer.DrawLine 350, .DDLine(0, 1) + 25, 350, .DDLine(0, 1)
    End With

    
    subDrawHudText 300, SubMenu.DDLine(0, 1) + 3, "Misc", 2
    
    subDrawHudText 390, 690, "NetSpeed: " & GetNetDevice(AveragePing), 2
    
    subDrawScroller 390, 720, 300, "Average Ping", AveragePing, 0, 300
    
    subDrawHudColor 600, 250
    
    subDrawTargetGUI 390, 250

End Sub


Public Function GetNetDevice(ByRef Ping As Integer) As String

    Select Case Ping
    Case Is < 50
        GetNetDevice = "DSL@FastPath"
    Case 50 To 89
        GetNetDevice = "ISDN Intern"
    Case 90 To 109
        GetNetDevice = "DSL"
    Case 110 To 179
        GetNetDevice = "ISDN Extern"
    Case 180 To 249
        GetNetDevice = "56K@V92"
    Case 250 To 300
        GetNetDevice = "<=56K"
    End Select
    
End Function


Public Sub subDrawPlayerOptions()
    Dim n As Long
    Dim m As Long
    Dim TMPX As Long
    Dim PosX As Integer
    Dim PosY As Integer
    
    With SubMenu
        BackBuffer.DrawLine .DDLine(1, 0), .DDLine(0, 1) + 22, 590, .DDLine(0, 1) + 22
        BackBuffer.DrawLine .DDLine(1, 0) - 7, .DDLine(0, 1) + 25, 590, .DDLine(0, 1) + 25
        BackBuffer.DrawLine 590, .DDLine(0, 1), 590, .DDLine(0, 1) + 25
        
        BackBuffer.DrawLine 655, .DDLine(0, 1) + 22, .DDLine(0, 0) - 105, .DDLine(0, 1) + 22
        BackBuffer.DrawLine 655, .DDLine(0, 1) + 25, .DDLine(0, 0) - 105, .DDLine(0, 1) + 25
        
        BackBuffer.DrawLine 655, .DDLine(0, 1) + 25, 655, .DDLine(0, 1)
    End With
    
    subDrawHudText 600, SubMenu.DDLine(0, 1) + 3, "Player", 2
    
    subDrawHudText 250, 280, "Name:", 2
    With PNameTextBox
        subDrawTextBox 250, 300, 280, .Text, .InUse, .Blink
    End With
    
    subDrawShipChosing 360, 450
    
    PosX = 600
    PosY = 260
    
    subDrawOpenBox PosX, PosY - 5, 300, 245, 350
    subDrawHudText PosX + 15, PosY - 15, "Data", 2
    
    With FlyerProps(PlayerShip)
        TMPX = 0
        m = -1
        Do
            m = m + 1
            n = -1
            Do
                n = n + 1
            Loop Until Mid(.Description, TMPX + 35 - n, 1) = " "
            subDrawHudText PosX + 10, PosY + 10 + m * 20, Trim(Mid(.Description, TMPX + 1, 35 - n)), 2
            TMPX = TMPX + 35 - n
        Loop Until m > 8
        
        BackBuffer.SetForeColor RGB(150, 150, 150)
        BackBuffer.DrawLine PosX + 20, PosY + 180, PosX + 280, PosY + 180
        BackBuffer.SetForeColor RGB(255, 255, 255)
        
        subDrawHudText PosX + 10, PosY + 200, "MaxSpeed:", 2
        subDrawHudText PosX + 10, PosY + 230, "Acceleration:", 2
        subDrawHudText PosX + 10, PosY + 260, "Handling:", 2
        subDrawHudText PosX + 10, PosY + 290, "Mass:", 2
        subDrawHudText PosX + 10, PosY + 320, "Shield:", 2
        
        subDrawHudText PosX + 150, PosY + 200, Round(.MaxSpeed * 85, 2) & " pps", 2
        subDrawHudText PosX + 150, PosY + 230, Round(.Acceleration * 85, 2) & " pps²", 2
        subDrawHudText PosX + 150, PosY + 260, Round((40 / .SteerSpeed) / 85, 3) & " spt", 2
        subDrawHudText PosX + 150, PosY + 290, Round((.Weight)) & " t", 2
        subDrawHudText PosX + 150, PosY + 320, .Shields & " MW", 2
         
    End With
       
End Sub



Public Sub subDrawOpenBox(X As Integer, Y As Integer, W As Integer, W2 As Integer, H As Integer)
With BackBuffer
    .SetForeColor RGB(150, 150, 150)

    .DrawLine X, Y, X, Y + H
    .DrawLine X + W, Y, X + W, Y + H
    .DrawLine X, Y + H, X + W, Y + H
    
    .DrawLine X, Y, X + 10, Y
    .DrawLine X + W, Y, X + W - W2, Y

    .SetForeColor RGB(255, 255, 255)
End With
End Sub


Public Sub subDrawHudColor(PosX As Integer, PosY As Integer)
    Dim TMP As Integer
    Dim TmpRect As RECT
    Dim TMPVertex As TVertexRect

    subDrawHudText PosX + 15, PosY, "HUD", 2
    subDrawOpenBox PosX, PosY + 10, 230, 180, 340
        
    TMP = HUDColor.R * 255
    subDrawScroller PosX + 15, PosY + 30, 150, "Red", TMP, 0, 255
    HUDColor.R = TMP / 255
    TMP = HUDColor.G * 255
    subDrawScroller PosX + 15, PosY + 60, 150, "Green", TMP, 0, 255
    HUDColor.G = TMP / 255
    TMP = HUDColor.B * 255
    subDrawScroller PosX + 15, PosY + 90, 150, "Blue", TMP, 0, 255
    HUDColor.B = TMP / 255
    TMP = (1 - HUDColor.T) * 100
    subDrawScroller PosX + 15, PosY + 120, 100, "Transparence", TMP, 0, 100
    HUDColor.T = 1 - TMP / 100
    
    With TmpRect
        .Left = PosX + 15
        .Top = PosY + 150
        .Right = TmpRect.Left + 100
        .Bottom = TmpRect.Top + 80
        
        BackBuffer.BltColorFill TmpRect, 0
        
        TMPVertex = fctSetVertexRect(.Left, .Top, 200, 80)
    End With
    With HUDColor
        Material.emissive = fctSetEmissive(.R * .T, .G * .T, .B * .T)
        g_D3DDev.SetMaterial Material
    End With
    
    g_D3DDev.LightEnable 5, False
    g_D3DDev.SetTexture 0, Nothing
    g_D3DDev.SetRenderState D3DRENDERSTATE_ALPHABLENDENABLE, 1
    g_D3DDev.SetRenderState D3DRENDERSTATE_SRCBLEND, 2
    g_D3DDev.SetRenderState D3DRENDERSTATE_DESTBLEND, 2
    g_D3DDev.SetRenderState D3DRENDERSTATE_ZENABLE, 0
    g_D3DDev.BeginScene
        g_D3DDev.DrawPrimitive D3DPT_TRIANGLESTRIP, D3DFVF_VERTEX, TMPVertex.Vertex(1), 4, D3DDP_WAIT
    g_D3DDev.EndScene
       
    BackBuffer.SetForeColor RGB(150, 150, 150)
    BackBuffer.DrawLine PosX + 20, PosY + 245, PosX + 210, PosY + 245
    BackBuffer.SetForeColor RGB(255, 255, 255)

    subDrawCheckBox PosX + 15, PosY + 260, "Show FPS", DrawFPS
    subDrawCheckBox PosX + 15, PosY + 290, "Show Kill Board", DrawKillBoard
    subDrawCheckBox PosX + 15, PosY + 320, "Show Message Board", DrawMsgBoard
    
End Sub

Public Sub subDrawTargetGUI(PosX As Integer, PosY As Integer)
    Dim TmpRect As RECT
    Dim TMPVertex As TVertexRect

    subDrawHudText PosX + 15, PosY, "Target Window", 2
    subDrawOpenBox PosX, PosY + 10, 150, 10, 130
    
    With TmpRect
        .Left = PosX + 43
        .Top = PosY + 30
        .Right = TmpRect.Left + 64
        .Bottom = TmpRect.Top + 64
        
        BackBuffer.BltColorFill TmpRect, 0
               
        subDrawChosenFlyer .Left + 8, .Top + 8
        
        TMPVertex = fctSetVertexRect(.Left, .Top, 64, 64)
    End With
    
    With g_D3DDev
        .BeginScene
            .SetTexture 0, TargetGUI.GUI(CTargetGUI)
            .DrawPrimitive D3DPT_TRIANGLESTRIP, D3DFVF_VERTEX, TMPVertex.Vertex(1), 4, D3DDP_WAIT
        .EndScene
    End With
        
    BackBuffer.BltFast PosX + 10, PosY + 110, TargetGUI.Picture1, TargetGUI.Rectangle, DDBLTFAST_SRCCOLORKEY
    BackBuffer.BltFast PosX + 117, PosY + 110, TargetGUI.Picture2, TargetGUI.Rectangle, DDBLTFAST_SRCCOLORKEY
    
    subDrawHudText PosX + 75 - fctGetTextLen("GUI 0" & CTargetGUI, 2) / 2, PosY + 110, "GUI 0" & CTargetGUI, 2
    
    If MouseLUp Then
        If MouseY > PosY + 110 And MouseY < PosY + 110 + 21 Then
            If MouseX > PosX + 10 And MouseX < PosX + 10 + 21 Then
                If CTargetGUI > 1 Then CTargetGUI = CTargetGUI - 1
            End If
            If MouseX > PosX + 117 And MouseX < PosX + 117 + 21 Then
                If CTargetGUI < 5 Then CTargetGUI = CTargetGUI + 1
            End If
        End If
    End If
    
End Sub
