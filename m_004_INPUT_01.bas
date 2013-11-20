Attribute VB_Name = "m_006_INPUT_01"
Option Explicit

Private DIDev                           As DirectInputDevice
Private JoyState                        As DIJOYSTATE

'Initialisiert DirectInput und gibt zurück ob Vorgang erfolgreich war
Public Function Init_DI() As Boolean

    Dim DIDevEnum           As DirectInputEnumDevices
    Dim JoyCaps             As DIDEVCAPS
    Dim DIProp_Range        As DIPROPRANGE
    Dim DIEnumObjects       As DirectInputEnumDeviceObjects
                
    On Error GoTo error:
    
    Set g_DI = g_DX.DirectInputCreate()
    Set DIDevEnum = g_DI.GetDIEnumDevices(DIDEVTYPE_JOYSTICK, DIEDFL_ATTACHEDONLY)
    
    'Testen ob ein Joypad vorhanden ist, wenn nicht abbrechen
    If DIDevEnum.GetCount = 0 Then GoTo error:
        
    Set DIDev = g_DI.CreateDevice(DIDevEnum.GetItem(1).GetGuidInstance)
    DIDev.SetCommonDataFormat DIFORMAT_JOYSTICK
    DIDev.SetCooperativeLevel frmMain.hWnd, DISCL_BACKGROUND Or DISCL_NONEXCLUSIVE
    
    'Wieviele Tasten das Joypad hat
    DIDev.GetCapabilities JoyCaps
    
    If JoyCaps.lFlags Then
        Set DIEnumObjects = DIDev.GetDeviceObjectsEnum(DIDFT_BUTTON)
        g_App.NumJoyButtons = DIEnumObjects.GetCount
    End If
        
    'Event erstellen
    g_DIEventHdl = g_DX.CreateEvent(frmMain)
    g_DIEventHdl = 0
    DIDev.SetEventNotification g_DIEventHdl
    
    With DIProp_Range
        .lHow = DIPH_DEVICE
        .lSize = Len(DIProp_Range)
        .lMin = -5000
        .lMax = 5000
    End With
    
    DIDev.SetProperty "DIPROP_RANGE", DIProp_Range
    DIDev.Acquire
    
    g_App.UsingJoyPad = True
    Init_DI = True
    Exit Function
    
error:
    g_App.UsingJoyPad = False
    Init_DI = False

End Function

'fährt DirectInput herunter
Public Sub Unload_DI()

    If g_DIEventHdl > 0 Then g_DX.DestroyEvent g_DIEventHdl
    
    Set DIDev = Nothing
    Set g_DI = Nothing

End Sub

'initialisiert die virtuellen Tasten
Public Sub Init_VirtualKeys()

    Dim n   As Long

    For n = 0 To 35
        g_JoyButton(n) = False
    Next
    
    For n = 0 To 255
        g_KeyButton(n) = False
    Next
    
End Sub

'Tastenbelegung aus Ini auslesen
Public Sub Load_KeyConfig()

    g_Key_Left = GetINIValue(App.Path & "\config.ini", "KeyConfig", "LEFT")
    g_Key_Accelerate = GetINIValue(App.Path & "\config.ini", "KeyConfig", "ACCELERATE")
    g_Key_Right = GetINIValue(App.Path & "\config.ini", "KeyConfig", "RIGHT")
    g_Key_Fire = GetINIValue(App.Path & "\config.ini", "KeyConfig", "FIRE")
    g_Key_NextWeapon = GetINIValue(App.Path & "\config.ini", "KeyConfig", "NEXT_WEAPON")
    g_Key_PreviousWeapon = GetINIValue(App.Path & "\config.ini", "KeyConfig", "PREVIOUS_WEAPON")
    g_Key_Weapon1 = GetINIValue(App.Path & "\config.ini", "KeyConfig", "WEAPON1")
    g_Key_Weapon2 = GetINIValue(App.Path & "\config.ini", "KeyConfig", "WEAPON2")
    g_Key_Weapon3 = GetINIValue(App.Path & "\config.ini", "KeyConfig", "WEAPON3")
    g_Key_Recover = GetINIValue(App.Path & "\config.ini", "KeyConfig", "RECOVER")
    g_Key_Chat = GetINIValue(App.Path & "\config.ini", "KeyConfig", "CHAT")
    g_Key_TeamChat = GetINIValue(App.Path & "\config.ini", "KeyConfig", "TEAM_CHAT")
    g_Key_ToggleTarget = GetINIValue(App.Path & "\config.ini", "KeyConfig", "TOGGLE_TARGET")
    g_Key_ScoreBoard = GetINIValue(App.Path & "\config.ini", "KeyConfig", "SCOREBOARD")
    g_Key_Screenshot = GetINIValue(App.Path & "\config.ini", "KeyConfig", "SCREENSHOT")

End Sub

'holt alle Eingabeinformationen
Public Sub GetInput()
    
    DoEvents
    
    If g_App.UsingJoyPad Then
        DIDev.Acquire
        DIDev.Poll
    End If
    
End Sub

'verarbeitet die Tastatureingaben
Public Sub ProcessKeyboardInput(ByVal KeyCode As Integer, ByVal KeyState As EKeyState, Optional ByVal repeat As Boolean = True)

    If Not repeat And g_KeyButton(KeyCode) = CBool(KeyState) Then Exit Sub
    
    g_KeyButton(KeyCode) = CBool(KeyState)
    
    'KeyDown-Event auslösen
    If KeyState = KEY_STATE_DOWN Then
        CustomKeyDown KeyCode
    
    'KeyUp-Event auslösen
    ElseIf KeyState = KEY_STATE_UP Then
        CustomKeyUp KeyCode
    End If
            
End Sub

'verarbeitet Joypadeingaben
Public Sub ProcessJoypadInput()
    
    Dim n       As Long
    
    DIDev.GetDeviceStateJoystick JoyState
    
    'Buttons abfragen
    For n = 0 To g_App.NumJoyButtons - 1
        If Not g_JoyButton(n) = CBool(JoyState.buttons(n)) Then
            g_JoyButton(n) = CBool(JoyState.buttons(n))
            
            If g_JoyButton(n) Then
                CustomKeyDown n + 1000
            Else
                CustomKeyUp n + 1000
            End If
        End If
    Next
    
    'X-Achse links
    If Not g_JoyButton(32) = (JoyState.X < -JOY_AXIS_TOLERANCE_X) Then
        g_JoyButton(32) = (JoyState.X < -JOY_AXIS_TOLERANCE_X)
        
        If g_JoyButton(32) Then
            CustomKeyDown 1032
        Else
            CustomKeyUp 1032
        End If
    End If
    
    'Y-Achse oben
    If Not g_JoyButton(33) = (JoyState.Y < -JOY_AXIS_TOLERANCE_Y) Then
        g_JoyButton(33) = (JoyState.Y < -JOY_AXIS_TOLERANCE_Y)
        
        If g_JoyButton(33) Then
            CustomKeyDown 1033
        Else
            CustomKeyUp 1033
        End If
    End If
    
    'X-Achse rechts
    If Not g_JoyButton(34) = (JoyState.X > JOY_AXIS_TOLERANCE_X) Then
        g_JoyButton(34) = (JoyState.X > JOY_AXIS_TOLERANCE_X)
        
        If g_JoyButton(34) Then
            CustomKeyDown 1034
        Else
            CustomKeyUp 1034
        End If
    End If
    
    'Y-Achse unten
    If Not g_JoyButton(35) = (JoyState.Y > JOY_AXIS_TOLERANCE_Y) Then
        g_JoyButton(35) = (JoyState.Y > JOY_AXIS_TOLERANCE_Y)
        
        If g_JoyButton(35) Then
            CustomKeyDown 1035
        Else
            CustomKeyUp 1035
        End If
    End If
    
End Sub

'gibt den Status einer belegbaren Taste zurück
Public Function GetCustomKeyState(ByVal ID As ECustomKeys) As Boolean

    If ID < 1000 Then
        GetCustomKeyState = CBool(g_KeyButton(ID))
    Else
        GetCustomKeyState = CBool(g_JoyButton(ID - 1000))
    End If

End Function

'KeyDown-Event
Public Sub CustomKeyDown(ByVal KeyCode As ECustomKeys)
        
    'Tastaturbelegung für die verschiedenen SpielModi
    Select Case g_App.GameMode

        Case GAME_MODE_SP_DEATHMATCH:
            KeyDown_SPDeathMatch KeyCode
    
        Case GAME_MODE_MP_DEATHMATCH:
            KeyDown_MPDeathMatch KeyCode
    
    End Select
    
End Sub

'KeyUp-Event
Public Sub CustomKeyUp(ByVal KeyCode As ECustomKeys)

    'Tastaturbelegung für die verschiedenen SpielModi
    Select Case g_App.GameMode
    
        Case GAME_MODE_SP_DEATHMATCH:
            KeyUp_SPDeathMatch KeyCode
    
        Case GAME_MODE_MP_DEATHMATCH:
            KeyUp_MPDeathMatch KeyCode
    
    End Select

End Sub

'keydown für SP-Deathmatch
Public Sub KeyDown_SPDeathMatch(ByVal KeyCode As ECustomKeys)

    'feste Tasten
    Select Case KeyCode
        
        Case CUSTOM_KEY_ESCAPE:         'Spiel beenden
            g_App.GameState = 0
        
        Case CUSTOM_KEY_EQUALS:         'Konsole aufrufen
            Call_Console
                                                                 
        Case CUSTOM_KEY_A:
            Add_MsgBoardInfo "testinger blamuh" & Rnd * 1000
                                                                                                                                                            
    End Select
    
    'Konsole steuern
    Select Case KeyCode
        Case CUSTOM_KEY_PRIOR:          'Konsole scrollen
            Scroll_Console -5
            Scroll_ScoreBoard -1

        Case CUSTOM_KEY_NEXT:           'Konsole scrollen
            Scroll_Console 5
            Scroll_ScoreBoard 1
                        
        Case CUSTOM_KEY_LEFT:           'Konsolenvervollständiger scrollen
            Scroll_ConsoleCompleter -1
                                            
        Case CUSTOM_KEY_UP:            'Konsolenvervollständiger scrollen
            Scroll_ConsoleCompleter -1
                                            
        Case CUSTOM_KEY_RIGHT:          'Konsolenvervollständiger scrollen
            Scroll_ConsoleCompleter 1
        
        Case CUSTOM_KEY_DOWN:          'Konsolenvervollständiger scrollen
            Scroll_ConsoleCompleter 1
                    
    End Select
        
    Select Case KeyCode
        
        Case g_Key_Fire:                'Schießen
            Switch_SpectatorMode
        
        Case CUSTOM_KEY_LEFT:
            Scroll_PlayerFocus -1
            
        Case CUSTOM_KEY_RIGHT:
            Scroll_PlayerFocus 1
            
        Case g_Key_Recover:
            If g_App.PlayerState = PLAYER_STATE_SPECTATOR And Not g_Spectator.Wait And Not g_Console.Draw Then Recover_Player g_Plr(g_MyPlrID), True
        
        Case CUSTOM_KEY_D:
            If Not g_Console.Draw Then Destroy_Player g_Plr(g_MyPlrID)
        
        Case CUSTOM_KEY_U:
            Add_KillBoard_Msg KILLBOARD_SUICIDE, "Iche" & Chr(Int(Rnd * 200) + 32), "Er" & Chr(Int(Rnd * 200) + 32), Int(Rnd * NUM_WEAPON_SURFS) + 1
        
    End Select
        
    Select Case KeyCode
        
        Case g_Key_Screenshot:              'ScreenShot
            TakeScreenShot
        
        Case g_Key_ScoreBoard:
            g_ScoreBoard.Draw = Not g_ScoreBoard.Draw
            
        Case g_Key_ToggleTarget:
            g_HUD.DrawTargeting = Not g_HUD.DrawTargeting
            
        Case g_Key_Weapon1:
            Switch_Weapon g_Plr(g_MyPlrID), , 1
    
        Case g_Key_Weapon2:
            Switch_Weapon g_Plr(g_MyPlrID), , 2
        
        Case g_Key_Weapon3:
            Switch_Weapon g_Plr(g_MyPlrID), , 3
    
        Case g_Key_NextWeapon:
            Switch_Weapon g_Plr(g_MyPlrID), 1
        
        Case g_Key_PreviousWeapon:
            Switch_Weapon g_Plr(g_MyPlrID), -1
    
    End Select
    
End Sub

'keyup für SP-DeathMatch
Public Sub KeyUp_SPDeathMatch(ByVal KeyCode As ECustomKeys)

End Sub

'keydown für MP-Deathmatch
Public Sub KeyDown_MPDeathMatch(ByVal KeyCode As ECustomKeys)

    'feste Tasten
    Select Case KeyCode
        
        Case CUSTOM_KEY_ESCAPE:         'Spiel beenden
            g_App.GameState = 0
        
        Case CUSTOM_KEY_EQUALS:         'Konsole aufrufen
            Call_Console
                                                                 
        Case CUSTOM_KEY_A:
            Add_MsgBoardInfo "testinger blamuh" & Rnd * 1000
                                                                                                                                                            
    End Select
    
    'Konsole steuern
    Select Case KeyCode
        Case CUSTOM_KEY_PRIOR:          'Konsole scrollen
            Scroll_Console -5
            Scroll_ScoreBoard -1

        Case CUSTOM_KEY_NEXT:           'Konsole scrollen
            Scroll_Console 5
            Scroll_ScoreBoard 1
                        
        Case CUSTOM_KEY_LEFT:           'Konsolenvervollständiger scrollen
            Scroll_ConsoleCompleter -1
                                            
        Case CUSTOM_KEY_UP:            'Konsolenvervollständiger scrollen
            Scroll_ConsoleCompleter -1
                                            
        Case CUSTOM_KEY_RIGHT:          'Konsolenvervollständiger scrollen
            Scroll_ConsoleCompleter 1
        
        Case CUSTOM_KEY_DOWN:          'Konsolenvervollständiger scrollen
            Scroll_ConsoleCompleter 1
                    
    End Select
        
    Select Case KeyCode
        
        Case g_Key_Fire:                'Schießen
            Switch_SpectatorMode
        
        Case CUSTOM_KEY_LEFT:
            Scroll_PlayerFocus -1
            
        Case CUSTOM_KEY_RIGHT:
            Scroll_PlayerFocus 1
            
        Case g_Key_Recover:
            If g_App.PlayerState = PLAYER_STATE_SPECTATOR And Not g_Spectator.Wait And Not g_Console.Draw Then
                Recover_Player g_Plr(g_MyPlrID), True
                Send_Recover g_Plr(g_MyPlrID)
            End If
        
        Case CUSTOM_KEY_D:
            If Not g_Console.Draw Then
                Destroy_Player g_Plr(g_MyPlrID)
                Send_PlayerDestruction KILLBOARD_SUICIDE, g_Plr(g_MyPlrID)
            End If
        
        Case CUSTOM_KEY_U:
            Add_KillBoard_Msg KILLBOARD_SUICIDE, "Iche" & Chr(Int(Rnd * 200) + 32), "Er" & Chr(Int(Rnd * 200) + 32), Int(Rnd * NUM_WEAPON_SURFS) + 1
        
    End Select
        
    Select Case KeyCode
        
        Case g_Key_Screenshot:              'ScreenShot
            TakeScreenShot
        
        Case g_Key_ScoreBoard:
            g_ScoreBoard.Draw = Not g_ScoreBoard.Draw
            
        Case g_Key_ToggleTarget:
            g_HUD.DrawTargeting = Not g_HUD.DrawTargeting
            
        Case g_Key_Weapon1:
            Switch_Weapon g_Plr(g_MyPlrID), , 1
    
        Case g_Key_Weapon2:
            Switch_Weapon g_Plr(g_MyPlrID), , 2
        
        Case g_Key_Weapon3:
            Switch_Weapon g_Plr(g_MyPlrID), , 3
    
        Case g_Key_NextWeapon:
            Switch_Weapon g_Plr(g_MyPlrID), 1
        
        Case g_Key_PreviousWeapon:
            Switch_Weapon g_Plr(g_MyPlrID), -1
    
    End Select

End Sub

'keyup für MP-DeathMatch
Public Sub KeyUp_MPDeathMatch(ByVal KeyCode As ECustomKeys)

End Sub
