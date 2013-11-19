Attribute VB_Name = "gme_00_Start"
Option Explicit

Public Sub Main()
  
    INIFile = App.Path & "\config.ini"
    
    gs_Init 0
          
    Init_App
          
    '=== INI-Datei öffnen und auslesen ==================================================
    subLoadVariables
    '====================================================================================
    
    VerifyParams Command$
    
    subMain
         
    End
    
End Sub


Public Sub subMain()
    
    'subShowCursor False

    Randomize
    
    frmMain.Show
            
    ResolutionX = 1024
    ResolutionY = 768

    'Initialisieren von DirectDraw, Direct3D und DirectSound
    Set g_DX = New DirectX7
    InitDDraw
    
    InitD3D
    InitDSound
    InitDirectInput
    
    
                            '################################################
                            MainMenu.StartIntro = True
                            '################################################
    
    If MainMenu.StartIntro Then subLoopIntro
    
    Intro.Quit = True
    
    subInitMenu
    
    Do

        DoEvents

        subLoopMenu

    Loop Until MainMenu.Quit
    
    subDeInitMenu
    
    subRestoreDX
    
    subShowCursor True

End Sub



Public Sub subLoopMenu()
    
    subDoMenu

    If MainMenu.StartGame Then subLoopGame
    
    If MainMenu.StartCredits Then subLoopCredits
    
End Sub

Public Sub subLoopIntro()

    subIntroVarInit
    
    subLoadIntroTextures
    
    subLoadIntroSounds

    Do
    
        subIntro

        DoEvents
        
    Loop Until Intro.Quit
    
    IntroMusic.Stop
    
    subUnloadLoadIntroStuff
    
    '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    TimeQuotient = 5
    '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

    
End Sub

Public Sub subLoopGame()

    subDeInitMenu
    
    '====== allet runtafahn! ============================
    g_DD.SetCooperativeLevel frmMain.hWnd, DDSCL_NORMAL
    g_DD.RestoreDisplayMode
    Set DI = Nothing
    Set g_D3DDev = Nothing
    Set g_D3DDev = Nothing
    Set g_DD = Nothing
    '====================================================
    
    If MainMenu.ItsMulti Then
        
            GameEntry GAME_MODE_MP_DEATHMATCH
        
    Else
        
            GameEntry GAME_MODE_SP_DEATHMATCH
            
    End If
    
    MainMenu.StartGame = False
    
    InitDDraw
    
    InitD3D
    InitDSound
    InitDirectInput
    
    subInitMenu
    
    DoEvents
    
    MainMenu.Quit = False
    
    '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    TimeQuotient = 50
    '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    
End Sub

Public Sub subLoopCredits()

    MainMenu.StartCredits = False
    QuitCredits = False

    subDeInitMenu

    subCreditsVarInit
    subLoadCreditsTextures
    subLoadCreditsSounds
    
    CreditsMusic.Play 0

    Do
    
        SubCredits

        DoEvents
        
    Loop Until QuitCredits
    
    CreditsMusic.Stop
    
    subUnloadLoadCreditsStuff

    '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    TimeQuotient = 5
    '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

    subInitMenu

End Sub
        
Public Sub subRestoreDX()
    ' DirectX Zurücksetzen und Bildschirm herstellen
    g_DD.SetCooperativeLevel frmMain.hWnd, DDSCL_NORMAL
    g_DD.RestoreDisplayMode
    
    '========= alles sauber beenden =========
    Set DI = Nothing
    Set g_D3DDev = Nothing
    Set g_DD = Nothing
    Set g_DX = Nothing
    '========================================
End Sub


Public Sub subShowCursor(ByRef V As Boolean)
    
    If V Then
    
        Do
        Loop Until (ShowCursor(1) > -1)
        
    Else
    
        Do
        Loop Until (ShowCursor(0) < 0)
    
    End If
    
End Sub

Public Sub VerifyParams(Param As String)
    Dim n As Long
    Dim CurParam As String
    
    MainMenu.StartIntro = True
    
    If Param <> vbNullString Then
        
        For n = 1 To Len(Param)
            
            If Mid(Param, n, 4) = "-dev" Then
                MainMenu.StartIntro = False
            End If
            
            If Mid(Param, n, 3) = "map" Then
                MainMenu.StartIntro = False
                
                MainMenu.StartGame = True
                MainMenu.ItsMulti = False
                
                Map.MapName = Trim(Mid(Param, n + 4, 20))
                fctSetIniValue "Server", "Map", Map.MapName
            End If
            
        Next n
        
    End If
    

End Sub
