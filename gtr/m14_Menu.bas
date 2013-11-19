Attribute VB_Name = "mnu_m05_Menu"
Option Explicit

'Menu Initialisieren
Public Sub subInitMenu()

    subInitMenuVariables

    subLoadFonts
    subLoadMenuPictures
    subLoadMenuTextures
    subLoadMenuSounds
        
    subPlayMenuBackSound
    
End Sub

'MenuHauptSchleife
Public Sub subDoMenu()

    '=== CALCULATING ===
    CalcFPS                             'FPS berechnen
       
    subMoveMainMenu
    subMoveSubMenu
    
    subMove3DGTRMenu
    subMoveMainMenuBackStars
    sub3DGTRStarflight
    subRotate3DGTRMenu
    subMoveMouseStars
    '===================
    
    subDraw3DMenu
    
    If MainMenu.CamZ = -30 Then
        subDrawMainMenu
        subDrawSubMenu
        subDrawMenuMouseStars
    
        With MCursor
            .Rectangle.Left = 0
            .Rectangle.Top = 0
            .Rectangle.Right = 27
            .Rectangle.Bottom = 27
                    
            subOverEdge 27, 27, 0, CSng(g_MouseX), CSng(g_MouseY), .Rectangle
            BackBuffer.BltFast g_MouseX, g_MouseY, .Picture, .Rectangle, DDBLTFAST_SRCCOLORKEY
            
        End With
        
    End If
    
    If FadetoCredits < 1 Then
        FadetoCredits = FadetoCredits - 0.01 * ConstSpeed
        If FadetoCredits < 0 Then
            MainMenu.StartCredits = True
        End If
        
        subDrawEffect FadetoCredits, 8, 3
    End If
    
    If DrawFPS Then subDrawHudText 10, 10, "FPS: " & FPS, 2
    
    
    Primary.Flip Nothing, DDFLIP_NOVSYNC
    
    MouseLUp = False
    CurrentKey = 0

End Sub

'HauptMenuSchleife
Public Sub subDrawMainMenu()

    subSetMainButtons
    subSetMainControls
    
    With MainMenu.Choise
    
        subOverEdge .Width, .Height, 0, .X, .Y, .Rectangle
        
        BackBuffer.BltFast .X, .Y, .Picture, .Rectangle, DDBLTFAST_SRCCOLORKEY
        
    End With
    
    With MainMenu.Control
    
        BackBuffer.BltFast .X, .Y, .Picture, .Rectangle, DDBLTFAST_SRCCOLORKEY
        
    End With
    
End Sub
'=========================================================================

Public Sub subDeInitMenu()
    Dim n As Long

    MenuBackSound.Stop
    
    Set Menu3DStarTex = Nothing
    Set MenuMouseStarTex = Nothing

    With TargetGUI
        For n = 1 To 5
            Set .GUI(n) = Nothing
        Next
    End With

    With MainMenu.Choise
        Set .Picture = Nothing
    End With
    
    With MainMenu.Control
        Set .Picture = Nothing
    End With
    
    With CheckBox
        Set .Picture1 = Nothing
        Set .Picture2 = Nothing
        Set .Picture3 = Nothing
        Set .Picture4 = Nothing
    End With
    
    With Scroller
        Set .Picture1 = Nothing
        Set .Picture2 = Nothing
    End With
    
    With FlyerBox
        Set .Picture1 = Nothing
        Set .Picture2 = Nothing
        Set .Flyer.Picture = Nothing
    End With
    
    With ServerListBox
        Set .Picture1 = Nothing
        Set .Picture2 = Nothing
    End With
       
    With MapListBox
        Set .Picture1 = Nothing
        Set .Picture2 = Nothing
    End With
    
    With GameModeList
        Set .Picture1 = Nothing
        Set .Picture2 = Nothing
    End With
    
    With MessageListBox
        Set .Picture1 = Nothing
        Set .Picture2 = Nothing
    End With
    
    Set HUDFont(1).FontPic = Nothing
    Set HUDFont(2).FontPic = Nothing
    Set HUDFont(3).FontPic = Nothing

    Set MenuFadeSound = Nothing
    Set MenuMoveSound = Nothing
    Set MenuBackSound = Nothing
    
End Sub
