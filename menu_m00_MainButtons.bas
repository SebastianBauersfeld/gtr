Attribute VB_Name = "mnu_m06_MainButtons"
Option Explicit


Public Sub subSetMainButtons()

    With MainMenu
    
       If MainMenu.Choise.Y < (ResolutionY - MainMenu.Choise.Height) / 2 + 1 Then
    
            '=== Single-Button ========================================================================
            If MouseX > 375 And MouseX < 650 And MouseY > 230 And MouseY < 280 Then
            
                If .FadeSingle <= 0 Then subPlayMenuFadeSound
                
                If .FadeSingle < 1 Then .FadeSingle = .FadeSingle + .FadeSpeed * ConstSpeed
                DrawFade 385, 235, 640, 275, .FadeSingle
        
                If MouseLUp Then
                    MainMenu.MoveY = MainMenu.MotionSpeed
                    MainMenu.MenuStatus = SingleM
                    subPlayMenuMoveSound
                    .FadeSingle = 0
                    SubMenu.MenuStatus = S_CreateSingle
                End If
            Else
                If .FadeSingle > 0 Then
                    .FadeSingle = .FadeSingle - .FadeSpeed * ConstSpeed
                    DrawFade 385, 235, 640, 275, .FadeSingle
                End If
            End If
            '==========================================================================================
            
            '=== Multi-Button =========================================================================
            If MouseX > 385 And MouseX < 640 And MouseY > 295 And MouseY < 345 Then
            
                If .FadeMulti <= 0 Then subPlayMenuFadeSound
            
                If .FadeMulti < 1 Then .FadeMulti = .FadeMulti + .FadeSpeed * ConstSpeed
                DrawFade 395, 300, 630, 340, .FadeMulti
        
                If MouseLUp Then
                        MainMenu.MoveY = MainMenu.MotionSpeed
                        MainMenu.MenuStatus = Multi
                        subPlayMenuMoveSound
                        .FadeMulti = 0
                        SubMenu.MenuStatus = S_Default
                        
                        Init_DP GetBroadCast, 0
                End If
            Else
                If .FadeMulti > 0 Then
                    .FadeMulti = .FadeMulti - .FadeSpeed * ConstSpeed
                    DrawFade 395, 300, 630, 340, .FadeMulti
                End If
            End If
            '===========================================================================================
            
            '=== Options-Button ========================================================================
            If MouseX > 395 And MouseX < 630 And MouseY > 360 And MouseY < 410 Then
            
                If .FadeOptions <= 0 Then subPlayMenuFadeSound
            
                If .FadeOptions < 1 Then .FadeOptions = .FadeOptions + .FadeSpeed * ConstSpeed
                DrawFade 425, 365, 600, 405, .FadeOptions
        
                If MouseLUp Then
                        MainMenu.MoveY = MainMenu.MotionSpeed
                        MainMenu.MenuStatus = Options
                        subPlayMenuMoveSound
                        .FadeOptions = 0
                        SubMenu.MenuStatus = S_Misc
                End If
            Else
                If .FadeOptions > 0 Then
                    .FadeOptions = .FadeOptions - .FadeSpeed * ConstSpeed
                    DrawFade 425, 365, 600, 405, .FadeOptions
                End If
            End If
            '===========================================================================================
            
            '=== Credits-Button ========================================================================
            If MouseX > 405 And MouseX < 620 And MouseY > 425 And MouseY < 475 Then
            
                If .FadeCredits <= 0 Then subPlayMenuFadeSound
            
                If .FadeCredits < 1 Then .FadeCredits = .FadeCredits + .FadeSpeed * ConstSpeed
                DrawFade 435, 430, 590, 470, .FadeCredits
                
                If MouseLUp Then
                    MainMenu.MoveY = MainMenu.MotionSpeed
                    subPlayMenuMoveSound
                    .FadeCredits = 0
                    FadetoCredits = 0.999
                End If
            Else
                If .FadeCredits > 0 Then
                    .FadeCredits = .FadeCredits - .FadeSpeed * ConstSpeed
                    DrawFade 435, 430, 590, 470, .FadeCredits
                End If
            End If
            '===========================================================================================
            
            '=== Exit-Button ===========================================================================
            If MouseX > 415 And MouseX < 610 And MouseY > 490 And MouseY < 540 Then
            
                If .FadeExit <= 0 Then subPlayMenuFadeSound
            
                If .FadeExit < 1 Then .FadeExit = .FadeExit + .FadeSpeed * ConstSpeed
                DrawFade 455, 495, 570, 535, .FadeExit
                
                If MouseLUp Then MainMenu.Quit = True
            Else
                If .FadeExit > 0 Then
                    .FadeExit = .FadeExit - .FadeSpeed * ConstSpeed
                    DrawFade 455, 495, 570, 535, .FadeExit
                End If
            End If
            '===========================================================================================
            
        End If
            
    End With

End Sub

Public Sub subSetMainControls()

    With MainMenu.Control
        '=== Down-Button ===========================================================================
        If MouseX > .X And MouseX < .X + 20 And MouseY > .Y - 1 And MouseY < .Y + 20 Then
        
            If MainMenu.FadeDown <= 0 Then subPlayMenuFadeSound
        
            If MainMenu.FadeDown < 1 Then MainMenu.FadeDown = MainMenu.FadeDown + MainMenu.FadeSpeed * ConstSpeed
            DrawFade ResolutionX - .Width, 0, ResolutionX - .Width / 3 * 2, .Height, MainMenu.FadeDown
            
            
            
            If MouseLUp And MainMenu.MenuStatus = MainM Then
                MainMenu.MoveY = MainMenu.MotionSpeed
                subPlayMenuMoveSound
            End If
            If MouseLUp And (MainMenu.MenuStatus = Multi Or MainMenu.MenuStatus = Options Or MainMenu.MenuStatus = SingleM) Then
                MainMenu.MoveY = -MainMenu.MotionSpeed
                MainMenu.MenuStatus = MainM
                subPlayMenuMoveSound
                GTR3D.TargetX = 0
                GTR3D.TargetY = -2.5
                GTR3D.TargetZ = 5
                SubMenu.TargetX = 0.7
                Unload_DP
            End If
        Else
            If MainMenu.FadeDown > 0 Then
                MainMenu.FadeDown = MainMenu.FadeDown - MainMenu.FadeSpeed * ConstSpeed
                DrawFade ResolutionX - .Width, 0, ResolutionX - .Width / 3 * 2, .Height, MainMenu.FadeDown
            End If
        End If
        '===========================================================================================
        
        '=== Up-Button =============================================================================
        If MouseX > .X + 20 And MouseX < .X + 40 And MouseY > .Y - 1 And MouseY < .Y + 20 Then
        
            If MainMenu.FadeUp <= 0 Then subPlayMenuFadeSound
        
            If MainMenu.FadeUp < 1 Then MainMenu.FadeUp = MainMenu.FadeUp + MainMenu.FadeSpeed * ConstSpeed
            DrawFade ResolutionX - .Width / 3 * 2, 0, ResolutionX - .Width / 3, .Height, MainMenu.FadeUp
            
            If MouseLUp And MainMenu.MenuStatus = MainM Then
                MainMenu.MoveY = -MainMenu.MotionSpeed
                MainMenu.MenuStatus = MainM
                subPlayMenuMoveSound
                GTR3D.TargetX = 0
                GTR3D.TargetY = -2.5
                GTR3D.TargetZ = 5
                SubMenu.TargetX = 0.7
            End If
        Else
            If MainMenu.FadeUp > 0 Then
                MainMenu.FadeUp = MainMenu.FadeUp - MainMenu.FadeSpeed * ConstSpeed
                DrawFade ResolutionX - .Width / 3 * 2, 0, ResolutionX - .Width / 3, .Height, MainMenu.FadeUp
            End If
        End If
        '===========================================================================================
        
        '=== X-Button ==============================================================================
        If MouseX > .X + 40 And MouseX < .X + 60 And MouseY > .Y - 1 And MouseY < .Y + 20 Then
        
            If MainMenu.FadeX <= 0 Then subPlayMenuFadeSound
        
            If MainMenu.FadeX < 1 Then MainMenu.FadeX = MainMenu.FadeX + MainMenu.FadeSpeed * ConstSpeed
            DrawFade ResolutionX - .Width / 3, 0, ResolutionX, .Height, MainMenu.FadeX
            
            If MouseLUp Then MainMenu.Quit = True
        Else
            If MainMenu.FadeX > 0 Then
                MainMenu.FadeX = MainMenu.FadeX - MainMenu.FadeSpeed * ConstSpeed
                DrawFade ResolutionX - .Width / 3, 0, ResolutionX, .Height, MainMenu.FadeX
            End If
        End If
        '===========================================================================================
    
    End With

End Sub
