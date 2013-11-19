Attribute VB_Name = "ntr_05_Script"
Option Explicit


Public Sub subGCameraScript()
    With Intro
    
        .CAMRAD = .CAMRAD - 0.0001 * ConstSpeed
        
        Call g_DX.ViewMatrix(matView, Vector(Sin(.CAMRAD) * -.CAMR, .CAMR * Sin(.CAMRAD2), Cos(.CAMRAD) * -.CAMR), Vector(0, 0, 0), Vector(0, 1, 0), 0)
        g_D3DDev.SetTransform D3DTRANSFORMSTATE_VIEW, matView
    
    End With
End Sub

Public Sub subIntroScript()

    With Intro
    
        .Script = .Script + 0.001 * ConstSpeed
        
        If .Script < 2.5 Then
            subGCameraScript
               
            subDrawGalaxyBack
                
            subDrawGalaxy
            
        End If
        
        If .Script > 2.55 And .Script < 2.65 Then
            If IntroMusic.GetStatus <> DSBSTATUS_PLAYING Then
                IntroMusic.Play DSBPLAY_DEFAULT                      'abspielen!
            End If
        End If
    
    
        Select Case .Script
        Case 0 To 0.5:
        
            .FadeFromBlackDull = .FadeFromBlackDull + 0.003 * ConstSpeed
        
            subDrawEffect .FadeFromBlackDull, 8, 3
        
        Case 0.5 To 1:
        
            If .Script < 0.75 Then
                FontFade = FontFade + 0.01 * ConstSpeed
            Else
                FontFade = FontFade - 0.01 * ConstSpeed
            End If
        
            subDraw3DText 100, 650, "DevAgents.de presents", 1, 1, 1, 800, FontFade
                
        Case 1.1 To 1.6:
       
            If .Script < 1.35 Then
                FontFade = FontFade + 0.01 * ConstSpeed
            Else
                FontFade = FontFade - 0.01 * ConstSpeed
            End If
        
            subDraw3DText -400, 320, "a Developer Agents Production", 1, 1, 1, 800, FontFade
        Case 1.6 To 2.1:
       
            If .Script < 1.85 Then
                FontFade = FontFade + 0.01 * ConstSpeed
            Else
                FontFade = FontFade - 0.01 * ConstSpeed
            End If
        
            subDraw3DText -130, 660, "Gravity The Revolution", 1, 1, 1, 800, FontFade
            
        Case 2.1 To 2.6:
        
                .CAMR = .CAMR - ConstSpeed * (.Script - 2.11) * 2
                
                '.CAMRAD = .CAMRAD - ConstSpeed * (.Script - 2.1) * 2 * 0.01
                
                .CAMRAD2 = .CAMRAD2 - ConstSpeed * (2.6 - .Script) * 2 * 0.001
        
                subDrawEffect (.Script - 2.4) * 10, 2, 2
            
        Case 2.6 To 3:
        
                subMoveWStars
                
                subScriptWarpStarIntro
                
                subWarpStars
                
                subDrawSentence

                subDrawEffect (2.65 - .Script) * 20, 0, 2
                
                
                ViewPort.lX = 0
                ViewPort.lY = ResolutionY / 4
                ViewPort.lWidth = ResolutionX
                ViewPort.lHeight = ResolutionY / 2
                g_D3DDev.SetViewport ViewPort
                
                Call g_DX.ViewMatrix(matView, Vector(0, 0, -30), Vector(0, 0, 0), Vector(0, 1, 0), 0)
                g_D3DDev.SetTransform D3DTRANSFORMSTATE_VIEW, matView
                
        Case Is > 3:
                
                subMoveWStars
                
                subScriptWarpStarIntro
                
                subWarpStars
                
                subDrawSentence
                
                If .Script > 4 Then
                    .RecoverStars = False
                    If .Script > 4.2 Then .Quit = True
                End If

        End Select
        
        
        If .Script < 2.7 Then
            Dim TmpRect As RECT

            TmpRect.Left = 0
            TmpRect.Top = 0
            TmpRect.Right = ResolutionX
            TmpRect.Bottom = ResolutionY / 4

            BackBuffer.BltColorFill TmpRect, 0

            TmpRect.Left = 0
            TmpRect.Top = ResolutionY / 4 * 3
            TmpRect.Right = ResolutionX
            TmpRect.Bottom = ResolutionY

            BackBuffer.BltColorFill TmpRect, 0
        End If
        
    End With
    
End Sub



Public Sub subScriptWarpStarIntro()
    
   IntroMusic.GetCurrentPosition curs

    
    subCalcSentences
    
    If curs.lPlay > 60000 And curs.lPlay < 90000 Then
        Sentence.SelectedTex = 1
        subRumble
    End If
    
    If curs.lPlay > 165000 And curs.lPlay < 185000 Then
        Sentence.SelectedTex = 2
        subRumble
    End If

    If curs.lPlay > 280000 And curs.lPlay < 300000 Then
        Sentence.SelectedTex = 3
        subRumble
    End If
    
    If curs.lPlay > 500000 And curs.lPlay < 520000 Then subRumble
    
    If curs.lPlay > 610000 And curs.lPlay < 630000 Then subRumble
    
    If curs.lPlay > 720000 And curs.lPlay < 740000 Then subRumble

    If curs.lPlay > 950000 And curs.lPlay < 970000 Then subRumble

'952579
'1047909
'1174657
'1390158
'1513113
'1621149
'1838150
'1956132
'2065966
    
       

End Sub



Public Sub subRumble()
Dim Factor1 As Single
Dim Factor2 As Single

    Factor1 = (Rnd * 0.2) - 0.1
    Factor2 = (Rnd * 0.3) - 0.1
    
    Call g_DX.ViewMatrix(matView, Vector(Factor1, Factor2, -30), Vector(Factor1, Factor2, 0), Vector(0, 1, 0), 0)
    g_D3DDev.SetTransform D3DTRANSFORMSTATE_VIEW, matView
    
End Sub

