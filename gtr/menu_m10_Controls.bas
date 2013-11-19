Attribute VB_Name = "mnu_m12_Controls"
Option Explicit


Public Sub subDrawCheckBox(ByRef PosX As Integer, ByRef PosY As Integer, ByRef Text As String, ByRef Var As Boolean)
    Dim Hit As Boolean
    
    With CheckBox
    
        If MouseX >= PosX And MouseX <= PosX + .Width + fctGetTextLen(Text, 2) + 7 And MouseY >= PosY And MouseY <= PosY + .Height And (MouseLUp Or MouseLDown) Then
            Hit = True
        Else
            Hit = False
        End If
        
        If Hit Then
            If Var Then
                BackBuffer.BltFast PosX, PosY, .Picture4, .Rectangle, DDBLTFAST_SRCCOLORKEY
            Else
                BackBuffer.BltFast PosX, PosY, .Picture3, .Rectangle, DDBLTFAST_SRCCOLORKEY
            End If
        Else
            If Var Then
                BackBuffer.BltFast PosX, PosY, .Picture1, .Rectangle, DDBLTFAST_SRCCOLORKEY
            Else
                BackBuffer.BltFast PosX, PosY, .Picture2, .Rectangle, DDBLTFAST_SRCCOLORKEY
            End If
        End If
        
        subDrawHudText PosX + .Width + 5, PosY + 3, Text, 2
        
        'BackBuffer.DrawLine PosX + .Width + fctGetTextLen(Text, 2) + 7, PosY, PosX + .Width + fctGetTextLen(Text, 2) + 7, PosY + .Height
        
        If MouseX >= PosX And MouseX <= PosX + .Width + fctGetTextLen(Text, 2) + 7 And MouseY >= PosY And MouseY <= PosY + .Height And MouseLUp Then
            Var = Not Var
        End If
            
    End With

End Sub


Public Sub subDrawButton(ByRef PosX As Integer, ByRef PosY As Integer, ByRef Text As String, ByRef ClickEvent As EButtonEvent)
    Dim Hit As Boolean

    If MouseX >= PosX And MouseX <= PosX + fctGetTextLen(Text, 2) + 5 And MouseY >= PosY And MouseY <= PosY + 20 And (MouseLUp Or MouseLDown) Then
        Hit = True
    Else
        Hit = False
    End If
    
    
    BackBuffer.SetFillColor RGB(50, 100, 150)
    BackBuffer.SetForeColor RGB(50, 100, 150)
    BackBuffer.DrawBox PosX, PosY, PosX + fctGetTextLen(Text, 2) + 5, PosY + 20
        
    BackBuffer.SetForeColor RGB(255, 255, 255)
    BackBuffer.SetFillStyle 1
    
    If Hit Then
        BackBuffer.DrawLine PosX + fctGetTextLen(Text, 2) + 5, PosY, PosX + fctGetTextLen(Text, 2) + 5, PosY + 20
        BackBuffer.DrawLine PosX, PosY + 20, PosX + fctGetTextLen(Text, 2) + 5, PosY + 20
    Else
        BackBuffer.DrawLine PosX, PosY, PosX, PosY + 20
        BackBuffer.DrawLine PosX, PosY, PosX + fctGetTextLen(Text, 2) + 5, PosY
    End If
    
    subDrawHudText PosX + 3, PosY + 3, Text, 2
    
    If MouseX >= PosX And MouseX <= PosX + fctGetTextLen(Text, 2) + 5 And MouseY >= PosY And MouseY <= PosY + 20 And MouseLUp Then
               
        If ClickEvent = Event_BackToMenu Or ClickEvent = Event_RestoreData Or ClickEvent = Event_SaveData Then      'Zurück zum Hauptmenu
            MainMenu.MoveY = -MainMenu.MotionSpeed
                MainMenu.MenuStatus = MainM
                subPlayMenuMoveSound
                GTR3D.TargetX = 0
                GTR3D.TargetY = -2.5
                GTR3D.TargetZ = 5
                SubMenu.TargetX = 0.7
                
                If ClickEvent = Event_BackToMenu Then
                
                    Unload_DP
                    
                End If
        End If
        
        If ClickEvent = Event_RestoreData Then
            subLoadVariables
        End If
        
        If ClickEvent = Event_SaveData Then
            subSaveVariables
        End If
               
        If ClickEvent = Event_Create Then
            SubMenu.MenuStatus = S_Create
        End If
        
        If ClickEvent = Event_Join Then
            SubMenu.MenuStatus = S_Join
            ServerListBox.ListCount = 0
            IsOnline = OnlineConnection
        End If
        
        If ClickEvent = Event_CreateINet Then
            SubMenu.MenuStatus = S_CreateINet
        End If
        
        If ClickEvent = Event_JoinINet Then
            SubMenu.MenuStatus = S_JoinINet
            ServerListBox.ListCount = 0
        End If

        If ClickEvent = Event_BackToMulti Then
            SubMenu.MenuStatus = S_Default
        End If
        
        If ClickEvent = Event_RefreshMulti Then
            Unload_DP
            Init_DP BroadCastTextBox.Text, 0
            subRefreshLANServers GetAvailableGames
        End If
        
        If ClickEvent = Event_RefreshINet Then
            gs_GetList
        End If
        
        If ClickEvent = Event_StartSingle Then
            MainMenu.StartGame = True
            MainMenu.ItsMulti = False
            
            fctSetIniValue "Server", "BotNumber", CStr(BotCount)
            fctSetIniValue "Server", "MapDestroyable", CStr(CByte(MapIsDestroyable))
            fctSetIniValue "Server", "Map", Map.MapName
            
            CurrentGameMode = GameModeList.Selected
        End If
        
        If ClickEvent = Event_StartMulti Then
            MainMenu.StartGame = True
            MainMenu.ItsMulti = True
            
            ServerName = SNameTextBox.Text
            fctSetIniValue "Server", "Name", ServerName
            fctSetIniValue "Server", "MaxPlayers", CStr(MaxPlayers)
            fctSetIniValue "Server", "MapDestroyable", CStr(CByte(MapIsDestroyable))
            fctSetIniValue "Server", "Map", Map.MapName
            
            g_App.IsServer = True
            Create_Session ServerName, MaxPlayers
            
            CurrentGameMode = GameModeList.Selected
        End If
        
        If ClickEvent = Event_StartINet Then
            Dim s As TServerInfo_PassOn
        
            MainMenu.StartGame = True
            MainMenu.ItsMulti = True
            
            ServerName = SNameTextBox.Text
            fctSetIniValue "Server", "Name", ServerName
            fctSetIniValue "Server", "MaxPlayers", CStr(MaxPlayers)
            fctSetIniValue "Server", "MapDestroyable", CStr(CByte(MapIsDestroyable))
            fctSetIniValue "Server", "Map", Map.MapName
            
            g_App.IsServer = True
            Create_Session ServerName, MaxPlayers
            
            CurrentGameMode = GameModeList.Selected
            
            s.CurrentMap = Map.MapName
            s.Destroyable = MapIsDestroyable
            s.GameType = CurrentGameMode
            s.MaxPlayers = MaxPlayers
            s.PlayerCount = 1
            s.ServerName = ServerName
        
            gs_CreateServer s
            
        End If
        
        If ClickEvent = Event_CutINetCon Then
        
            HangUp
            IsOnline = False
                    
            Set WS = Nothing
            Load frmMain.Winsock1(1)
            gs_Init 1
            
            BroadCastTextBox.Text = GetBroadCast
        
        End If
        
        If ClickEvent = Event_IgnoreINet Then
        
            IsOnline = False
        
        End If
        
        If ClickEvent = Event_JoinServer Then
        
            'fctSetIniValue "Server", "ConnectTo", RunningServer(ServerListBox.Selected - 1).IP
        
            g_App.IsServer = False
            
            
            If IsLANServer(GetAvailableGames) Then
            
                Join_Session ServerListBox.Selected
            
                MainMenu.StartGame = True
                MainMenu.ItsMulti = True
            
            End If
            
            If ClickEvent = Event_JoinINetServer Then
                'fctSetIniValue "Server", "ConnectTo", RunningServer(ServerListBox.Selected - 1).IP
                
                g_App.IsServer = False
                
                Unload_DP
                Init_DP RunningServer(ServerListBox.Selected - 1).IP, 0
                
                If IsInternetServer(GetAvailableGames) Then
                
                    Join_Session 1
                
                    MainMenu.StartGame = True
                    MainMenu.ItsMulti = True
                
                Else
                
                    gs_GetList
                
                End If
                
            End If
        
        
        End If
        
    End If
    
End Sub
 
Public Sub subDrawScroller(ByRef X As Integer, ByRef Y As Integer, ByRef W As Integer, ByRef Text As String, ByRef Value As Integer, ByRef Min As Integer, ByRef Max As Integer)
    Dim Hit As Boolean
    
    With Scroller
    
        If MouseX >= X And MouseX <= X + W And MouseY >= Y And MouseY <= Y + .Height And (MouseLUp Or MouseLDown) Then
            Hit = True
        Else
            Hit = False
        End If
        
        
        If Hit Then
            If MouseX <= X + .Width Then
                If Value > Min Then Value = Value - 1
            ElseIf MouseX >= X + W - .Width Then
                If Value < Max Then Value = Value + 1
            Else
                Value = CSng(MouseX - (.Width + X)) / CSng(W - .Width * 2) * CSng(Max - Min) + Min
            End If
        Else
    
        End If
        
        If Value < Min Then Value = Min
        If Value > Max Then Value = Max
        
        subDrawHudText X + (W - fctGetTextLen(Value, 2)) / 2, Y + 3, Value, 2
    
        BackBuffer.SetForeColor &HFFFFFF
        
        BackBuffer.BltFast X, Y, .Picture1, .Rectangle, DDBLTFAST_SRCCOLORKEY
        BackBuffer.BltFast X + W - .Width, Y, .Picture2, .Rectangle, DDBLTFAST_SRCCOLORKEY
        
        BackBuffer.DrawBox X + .Width + CLng(Value - Min) / (Max - Min) * (W - .Width * 2 - 5), Y, X + .Width + CLng(Value - Min) / (Max - Min) * (W - .Width * 2 - 5) + 5, Y + .Height
    
        subDrawHudText X + W + 5, Y + 3, Text, 2
        
    End With

End Sub



Public Sub subDrawKeyInput(ByRef X As Integer, ByRef Y As Integer, ByRef W As Integer, ByRef H As Integer)
    Dim n As Long
    
    
    GetControlKey = False
    
    If HasJoyStick Then subAnalyseButtons
    
    With KeyInput
    
        .Width = W
        .Height = H
        
        subDrawOpenBox X, Y - 5, .Width, .Width - 80, .Height
        subDrawHudText X + 15, Y - 15, "Controls", 2
       
        If .ChosenKey <> 0 Then
            GetControlKey = True
            If .Key(.ChosenKey) = 0 Then
                If CurrentKeyDI <> 0 Then .Key(.ChosenKey) = CurrentKeyDI
                If CurrentJoyBut <> 255 And HasJoyStick Then .Key(.ChosenKey) = CurrentJoyBut + 1000
                            
                If CurrentKeyDI <> 0 Or (CurrentJoyBut <> 255 And HasJoyStick) Then
                    For n = 1 To 15
                        If n <> .ChosenKey And (.Key(n) = CurrentKeyDI Or .Key(n) = CurrentJoyBut + 1000) Then
                            .Key(n) = -1
                            Exit For
                        End If
                    Next n
                    
                    .ChosenKey = 0
                End If
            End If
        End If
        
        For n = 1 To 15
            If MouseX >= X + 160 And MouseX <= X + 300 And MouseY >= Y + (n - 1) * 22 + 10 And MouseY <= Y + 20 + (n - 1) * 22 + 10 And MouseLUp And .ChosenKey = 0 Then
               If .Key(n) <> 0 Then
                    .Key(n) = 0
                    .ChosenKey = n
                End If
            End If
            
    
            If .Key(n) > 0 And .Key(n) < 1000 Then subDrawHudText X + 165, Y + 3 + 10 + (n - 1) * 22, KeyStr(.Key(n)), 2
            If .Key(n) >= 1000 Then subDrawHudText X + 165, Y + 3 + 10 + (n - 1) * 22, JoyButtonStr(.Key(n) - 1000), 2
            
            subDrawHudText X + 10, Y + 3 + 10 + (n - 1) * 22, .CTRLDisc(n), 2
            
            If .Key(n) <> 0 Then BackBuffer.SetForeColor RGB(150, 150, 150)
            BackBuffer.DrawBox X + 160, Y + (n - 1) * 22 + 10, X + 300, Y + 20 + (n - 1) * 22 + 10
            BackBuffer.SetForeColor RGB(255, 255, 255)
        Next n
        
        If HasJoyStick Then
            Dim TMP As String
            TMP = "- " & Trim(JoyName) & " available"
            n = fctGetTextLen(TMP, 2)
            
            If n <= W Then
                BackBuffer.DrawBox X, Y + .Height - 1, X + .Width, Y + .Height + 22
            Else
                BackBuffer.DrawBox X, Y + .Height - 1, X + n + 30, Y + .Height + 22
            End If
            subDrawHudText X + 15, Y + 3 + .Height, TMP, 2
        End If
        
    End With

End Sub

Public Sub subAnalyseButtons()
    Dim n As Long
    
    DIDev.Poll
    
    CurrentJoyBut = 255
    
    For n = 0 To 31
        If Joy.buttons(n) <> 0 Then
            CurrentJoyBut = n
            Exit Sub
        End If
    Next
    If Joy.X < -500 Then
        CurrentJoyBut = 32
    ElseIf Joy.X > 500 Then
        CurrentJoyBut = 33
    End If
    If Joy.Y < -500 Then
        CurrentJoyBut = 34
    ElseIf Joy.Y > 500 Then
        CurrentJoyBut = 35
    End If

    
End Sub

Public Sub subDrawTextBox(ByRef PosX As Integer, ByRef PosY As Integer, ByRef W As Integer, ByRef Text As String, ByRef Typing As Boolean, ByRef Blink As Boolean)

    If MouseX >= PosX And MouseX <= PosX + W And MouseY >= PosY And MouseY <= PosY + 20 And (MouseLUp Or MouseLDown) Then
        Typing = True
    ElseIf MouseLUp Then
        Typing = False
    End If
    
    If Typing Then
        BackBuffer.DrawLine PosX + W, PosY, PosX + W, PosY + 20
        BackBuffer.DrawLine PosX, PosY + 20, PosX + W, PosY + 20
        
        BackBuffer.SetForeColor RGB(150, 150, 150)
        BackBuffer.DrawLine PosX, PosY, PosX, PosY + 20
        BackBuffer.DrawLine PosX, PosY, PosX + W, PosY
        BackBuffer.SetForeColor RGB(255, 255, 255)
        
        If CurrentKey = 13 Or CurrentKey = 27 Then
            Typing = False
            CurrentKey = 0
        End If
        If CurrentKey <> 0 And CurrentKey <> 8 And CurrentKey <> 27 And Len(Text) < 20 Then Text = Text & Chr(CurrentKey)
        If CurrentKey = 8 And Len(Text) > 0 Then Text = Left(Text, Len(Text) - 1)
        
        If Blink Then BackBuffer.DrawLine PosX + fctGetTextLen(Text, 2) + 5, PosY + 15, PosX + fctGetTextLen(Text, 2) + 10, PosY + 15
        
        Blink = Not Blink
        
    Else
        BackBuffer.SetForeColor RGB(150, 150, 150)
        BackBuffer.DrawLine PosX + W, PosY, PosX + W, PosY + 20
        BackBuffer.DrawLine PosX, PosY + 20, PosX + W, PosY + 20
        BackBuffer.SetForeColor RGB(255, 255, 255)
        
        BackBuffer.DrawLine PosX, PosY, PosX, PosY + 20
        BackBuffer.DrawLine PosX, PosY, PosX + W, PosY
        
    End If
    
    subDrawHudText PosX + 3, PosY + 3, Text, 2
    
End Sub

Public Sub subDrawChosenFlyer(ByRef PosX As Integer, ByRef PosY As Integer)
    Static Steer As Single
    
    With FlyerBox.Flyer
    
        If FlyerBox.LoadFlyer Then
            Set .Picture = Nothing
            If Len(CStr(PlayerShip)) = 1 Then
                subLoadSurface .Picture, 1920, 48, PicturePath & "player0" & PlayerShip & ".bmp"
            Else
                subLoadSurface .Picture, 1920, 48, PicturePath & "player" & PlayerShip & ".bmp"
            End If
            FlyerBox.LoadFlyer = False
        End If
        
        Steer = Steer + ConstSpeed * 0.3
        
        If Steer >= 40 Then
            Steer = 0
        End If
        
        .Rectangle.Left = Int(Steer) * 48
        .Rectangle.Right = Int(Steer) * 48 + 48
        
        BackBuffer.BltFast PosX, PosY, .Picture, .Rectangle, DDBLTFAST_SRCCOLORKEY
        
    End With
    
End Sub

Public Sub subDrawShipChosing(ByRef PosX As Integer, ByRef PosY As Integer)
    Dim n As Long
    
    subDrawChosenFlyer PosX, PosY

    With FlyerBox
        If MouseLUp And MouseX >= PosX - 55 And MouseX <= PosX - 55 + .Width _
            And MouseY >= PosY + 10 And MouseY <= PosY + 10 + .Height Then
            
            If PlayerShip > 1 Then
                PlayerShip = PlayerShip - 1
            
                .LoadFlyer = True
            End If
        
        ElseIf MouseLUp And MouseX >= PosX + 82 And MouseX <= PosX + 82 + .Width _
            And MouseY >= PosY + 10 And MouseY <= PosY + 10 + .Height Then
            
            If PlayerShip < Flyers.Count Then
                PlayerShip = PlayerShip + 1
            
                .LoadFlyer = True
            End If
        
        End If

        BackBuffer.DrawBox PosX - 55, PosY + 100, PosX - 5, PosY + 120
        
        subDrawHudText PosX - 50, PosY + 101, PlayerShip & "/" & Flyers.Count, 2
        
        subDrawHudText PosX + 10, PosY + 101, FlyerProps(PlayerShip).TypeName, 2
        
        BackBuffer.BltFast PosX - 55, PosY + 10, .Picture1, .Rectangle, DDBLTFAST_SRCCOLORKEY
        BackBuffer.BltFast PosX + 82, PosY + 10, .Picture2, .Rectangle, DDBLTFAST_SRCCOLORKEY
        
        BackBuffer.setDrawWidth 3
        BackBuffer.SetFillColor 0
        BackBuffer.SetFillStyle 1
        BackBuffer.DrawCircle PosX + 24, PosY + 24, 50
        BackBuffer.SetFillStyle 1
        BackBuffer.setDrawWidth 1
    
    End With
End Sub

Public Sub subDrawList(ByRef PosX As Integer, ByRef PosY As Integer, ByRef W As Integer, ByRef H As Integer, ByRef Text As String, List As TListBox)

    Dim n As Long
    
    With List
    
        If MouseX >= PosX And MouseX <= PosX + W And MouseY >= PosY + 26 And MouseY <= PosY + H * 20 + 26 And (MouseLDown) Then
            If .ListCount > H Then
                If (MouseY - PosY - 7) \ 20 <= .ListCount And (MouseY - PosY - 7) \ 20 > 0 And MouseX < PosX + W - 21 Then
                    .Selected = (MouseY - PosY - 7) \ 20 + .Start - 1
                End If
                If MouseX > PosX + W - 21 Then
                    If .Start + H - 1 <= .ListCount And .Start >= 1 Then
                        If MouseY > PosY + 23 And MouseY < PosY + 23 + .Height Then
                            .Start = .Start - 1
                        ElseIf MouseY > PosY + H * 20 + 6 And MouseY < PosY + H * 20 + 6 + .Height Then
                            .Start = .Start + 1
                        Else
                            .Start = (MouseY - (PosY + .Height + 25)) / (H * 20 - .Height * 2) * (.ListCount - H) + 1
                        End If
                    End If
               End If
            Else
                If (MouseY - PosY - 7) \ 20 <= .ListCount And (MouseY - PosY - 7) \ 20 > 0 Then
                    .Selected = (MouseY - PosY - 7) \ 20
                End If
            End If
        End If
        
        
        If .Start < 1 Then .Start = 1
        If .Start > .ListCount - H + 1 And .ListCount > H Then .Start = .ListCount - H + 1
        
        
        BackBuffer.SetFillColor RGB(50, 100, 150)
        BackBuffer.SetForeColor RGB(50, 100, 150)
        BackBuffer.DrawBox PosX, PosY, PosX + W, PosY + 23

        BackBuffer.SetForeColor RGB(255, 255, 255)
        BackBuffer.SetFillStyle 1
        BackBuffer.DrawLine PosX, PosY, PosX + W, PosY
        BackBuffer.DrawLine PosX, PosY, PosX, PosY + H * 20 + 26
        subDrawHudText PosX + 3, PosY + 3, Text, 2
        BackBuffer.DrawLine PosX, PosY + 23, PosX + W, PosY + 23
        
        BackBuffer.SetForeColor RGB(150, 150, 150)
        BackBuffer.DrawLine PosX, PosY + H * 20 + 26, PosX + W, PosY + H * 20 + 26
        BackBuffer.DrawLine PosX + W, PosY, PosX + W, PosY + H * 20 + 26
        BackBuffer.SetForeColor RGB(255, 255, 255)
        
        BackBuffer.SetFillColor RGB(70, 120, 150)
        If .ListCount > H Then
            If .Selected >= .Start And .Selected <= .Start - 1 + H Then BackBuffer.DrawBox PosX + 2, PosY + 5 + (.Selected - .Start + 1) * 20, PosX + W - 2 - 21, PosY + 5 + (.Selected - .Start + 1) * 20 + 19
            BackBuffer.BltFast PosX + W - .Width, PosY + 23, .Picture1, .Rectangle, DDBLTFAST_SRCCOLORKEY
            BackBuffer.BltFast PosX + W - .Width, PosY + H * 20 + 6, .Picture2, .Rectangle, DDBLTFAST_SRCCOLORKEY
            BackBuffer.DrawBox PosX + W - .Width, PosY + 23 + .Height + Int((.Start - 1) * ((H * 20 - .Height * 2 - 1)) / (.ListCount - H)), PosX + W, PosY + 23 + .Height + Int((.Start - 1) * ((H * 20 - .Height * 2 - 1)) / (.ListCount - H)) + 5
        Else
            BackBuffer.DrawBox PosX + 2, PosY + 5 + .Selected * 20, PosX + W - 2, PosY + 5 + .Selected * 20 + 19
        End If
        BackBuffer.SetFillStyle 1
        
        For n = .Start To .Start + H - 1
            If n > .ListCount Then Exit For
            subDrawHudText PosX + 3, PosY + 6 + (n - .Start + 1) * 20, .List(n), 2
        Next
    
    End With
End Sub


Public Sub subDrawServerList(ByRef PosX As Integer, ByRef PosY As Integer, ByRef H As Integer, ByRef Text As String, List As TListBox)
    Dim W As Integer
    Dim TMP As String * 1
    Dim n As Long
    
    W = 880
    
    With List
    
        .ListCount = ServerCount
    
        If MouseX >= PosX And MouseX <= PosX + W And MouseY >= PosY + 26 And MouseY <= PosY + H * 20 + 26 And (MouseLDown) Then
            If .ListCount > H Then
                If (MouseY - PosY - 7) \ 20 <= .ListCount And (MouseY - PosY - 7) \ 20 > 0 And MouseX < PosX + W - 21 Then
                    .Selected = (MouseY - PosY - 7) \ 20 + .Start - 1
                End If
                If MouseX > PosX + W - 21 Then
                    If .Start + H - 1 <= .ListCount And .Start >= 1 Then
                        If MouseY > PosY + 23 And MouseY < PosY + 23 + .Height Then
                            .Start = .Start - 1
                        ElseIf MouseY > PosY + H * 20 + 6 And MouseY < PosY + H * 20 + 6 + .Height Then
                            .Start = .Start + 1
                        Else
                            .Start = (MouseY - (PosY + .Height + 25)) / (H * 20 - .Height * 2) * (.ListCount - H) + 1
                        End If
                    End If
               End If
            Else
                If (MouseY - PosY - 7) \ 20 <= .ListCount And (MouseY - PosY - 7) \ 20 > 0 Then
                    .Selected = (MouseY - PosY - 7) \ 20
                End If
            End If
            
            If ServerCount > 0 Then RunningServer(.Selected - 1).Latency = gs_ping(RunningServer(.Selected - 1).IP)
            
        End If
        
        
        If .Start < 1 Then .Start = 1
        If .Start > .ListCount - H + 1 And .ListCount > H Then .Start = .ListCount - H + 1
        
        
        BackBuffer.SetFillColor RGB(50, 100, 150)
        BackBuffer.SetForeColor RGB(50, 100, 150)
        BackBuffer.DrawBox PosX, PosY, PosX + W, PosY - 20

        BackBuffer.SetForeColor RGB(255, 255, 255)
        BackBuffer.SetFillStyle 1
        BackBuffer.DrawBox PosX, PosY + 1, PosX + W + 1, PosY - 20
        BackBuffer.DrawLine PosX, PosY, PosX + W, PosY
        BackBuffer.DrawLine PosX, PosY, PosX, PosY + H * 20 + 26
        subDrawHudText PosX + 3, PosY - 17, Text, 2
        
        BackBuffer.SetForeColor RGB(150, 150, 150)
        BackBuffer.DrawLine PosX, PosY + 23, PosX + W, PosY + 23
        BackBuffer.DrawLine PosX, PosY + H * 20 + 26, PosX + W, PosY + H * 20 + 26
        BackBuffer.DrawLine PosX + W, PosY, PosX + W, PosY + H * 20 + 26
        BackBuffer.SetForeColor RGB(255, 255, 255)
        
        BackBuffer.SetFillColor RGB(70, 120, 150)
        If .ListCount > H Then
            If .Selected >= .Start And .Selected <= .Start - 1 + H Then BackBuffer.DrawBox PosX + 2, PosY + 5 + (.Selected - .Start + 1) * 20, PosX + W - 2 - 21, PosY + 5 + (.Selected - .Start + 1) * 20 + 19
            BackBuffer.BltFast PosX + W - .Width, PosY + 23, .Picture1, .Rectangle, DDBLTFAST_SRCCOLORKEY
            BackBuffer.BltFast PosX + W - .Width, PosY + H * 20 + 6, .Picture2, .Rectangle, DDBLTFAST_SRCCOLORKEY
            BackBuffer.DrawBox PosX + W - .Width, PosY + 23 + .Height + Int((.Start - 1) * ((H * 20 - .Height * 2 - 1)) / (.ListCount - H)), PosX + W, PosY + 23 + .Height + Int((.Start - 1) * ((H * 20 - .Height * 2 - 1)) / (.ListCount - H)) + 5
        Else
            BackBuffer.DrawBox PosX + 2, PosY + 5 + .Selected * 20, PosX + W - 2, PosY + 5 + .Selected * 20 + 19
        End If
        BackBuffer.SetFillStyle 1
        
        subDrawHudText PosX + 3, PosY + 3, "Server Name", 2
        subDrawHudText PosX + 200, PosY + 3, "Server IP", 2
        subDrawHudText PosX + 340, PosY + 3, "Current Map", 2
        subDrawHudText PosX + 530, PosY + 3, "MD", 2
        subDrawHudText PosX + 560, PosY + 3, "GM", 2
        subDrawHudText PosX + 610, PosY + 3, "Players", 2
        subDrawHudText PosX + 680, PosY + 3, "Date - Time", 2
        subDrawHudText PosX + 830, PosY + 3, "Ping", 2
        
        For n = .Start To .Start + H - 1
            If n > ServerCount Then Exit For
            subDrawHudText PosX + 3, PosY + 6 + (n - .Start + 1) * 20, RunningServer(n - 1).ServerName, 2
            subDrawHudText PosX + 200, PosY + 6 + (n - .Start + 1) * 20, RunningServer(n - 1).IP, 2
            subDrawHudText PosX + 340, PosY + 6 + (n - .Start + 1) * 20, RunningServer(n - 1).CurrentMap, 2
            If RunningServer(n - 1).Destroyable Then
                TMP = "X"
            Else
                TMP = ""
            End If
            subDrawHudText PosX + 535, PosY + 6 + (n - .Start + 1) * 20, TMP, 2
            subDrawHudText PosX + 560, PosY + 6 + (n - .Start + 1) * 20, GameMode(RunningServer(n - 1).GameType), 2
            subDrawHudText PosX + 610, PosY + 6 + (n - .Start + 1) * 20, Format(RunningServer(n - 1).PlayerCount, "00") & "/" & RunningServer(n - 1).MaxPlayers, 2
            subDrawHudText PosX + 680, PosY + 6 + (n - .Start + 1) * 20, RunningServer(n - 1).DateTime, 2
            If RunningServer(n - 1).Latency > Timeout_Ping Then
                subDrawHudText PosX + 830, PosY + 6 + (n - .Start + 1) * 20, ">" & Timeout_Ping, 2
            ElseIf RunningServer(n - 1).Latency = Timeout_Ping Then
                subDrawHudText PosX + 830, PosY + 6 + (n - .Start + 1) * 20, "-", 2
            Else
                subDrawHudText PosX + 830, PosY + 6 + (n - .Start + 1) * 20, RunningServer(n - 1).Latency, 2
            End If
        Next
    
    End With
    
    
    ' Legende =========================================================
    subDrawOpenBox PosX + 670, PosY - 160, 210, 135, 125
    subDrawHudText PosX + 690, PosY - 169, "Legend", 2
    
    subDrawHudText PosX + 680, PosY - 150, "Click on a server to", 2
    subDrawHudText PosX + 680, PosY - 130, "receive the latency.", 2
    
    subDrawHudText PosX + 680, PosY - 60, "GM = Game Mode", 2
    subDrawHudText PosX + 680, PosY - 80, "MD = Map Destroyable", 2
    ' =================================================================
    
    
    Select Case ServerListBox.ListCount
    Case 0:
        subDrawHudText PosX + W - fctGetTextLen("No Servers available", 2), PosY - 17, "No Servers available", 2
    Case 1:
        subDrawHudText PosX + W - fctGetTextLen("1 Server available", 2), PosY - 17, "1 Server available", 2
    Case Else:
        subDrawHudText PosX + W - fctGetTextLen(ServerListBox.ListCount & " Servers available", 2), PosY - 17, ServerListBox.ListCount & " Servers available", 2
    End Select
    
End Sub
