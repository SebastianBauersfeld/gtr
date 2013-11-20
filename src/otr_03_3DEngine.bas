Attribute VB_Name = "otr_04_3DEngine"
Option Explicit
 
 Public Sub SubCredits()
   
    CalcFPS                 'FPS berechnen
    
    subResetD3DSettings
          
    subCreditsScript
   
    subDrawCreditsMisc
    
End Sub

Public Sub subResetD3DSettings()

    BackBuffer.BltColorFill EmptyRect, 0
    
    Call g_DX.ProjectionMatrix(matProj, 0.1, 5000, Fishmode)
    g_D3DDev.SetTransform D3DTRANSFORMSTATE_PROJECTION, matProj
    
    g_D3DDev.Clear 1, RectViewport(), D3DCLEAR_ZBUFFER Or D3DCLEAR_TARGET, RGB(0, 0, 0), 1, 0
   
    g_DX.ViewMatrix matView, Vector(CamX, CamY, CamZ), Vector(CamDX, CamDY, CamDZ), Vector(0, 1, 0), 0
    g_D3DDev.SetTransform D3DTRANSFORMSTATE_VIEW, matView
    
End Sub

Public Sub SubDrawCreditsUniverse()
       
    subDrawUniverse
    
    subDrawSun
    
    subDrawEarth
    
    subDrawCreditsShip
    
End Sub


Public Sub subDrawSun()
    Dim n As Long

    '=== Sonne =================================================================================
    g_D3DDev.LightEnable 0, False
    g_D3DDev.SetRenderState D3DRENDERSTATE_ZENABLE, 0
    
    g_D3DDev.BeginScene
           
        g_D3DDev.SetTexture 0, SunElementTex
        
        Material.emissive.R = 0
        Material.emissive.G = 0
        Material.emissive.B = 0
        For n = 1 To MAX_SUN_ELEMENTS
        
            Material.emissive.R = ((100 - SunElement(n).Age) / 100)
            If SunElement(n).Age < 60 Then Material.emissive.G = ((SunElement(n).Age) / 500)
            If SunElement(n).Age > 60 Then Material.emissive.G = ((100 - SunElement(n).Age) / 200)
        
            g_D3DDev.SetMaterial Material
    
            g_D3DDev.DrawPrimitive D3DPT_TRIANGLESTRIP, D3DFVF_VERTEX, SunElement(n).Vertex(1), 4, D3DDP_DEFAULT
        Next
       
        Material.emissive.R = 1
        Material.emissive.G = 1
        Material.emissive.B = 1
        g_D3DDev.SetMaterial Material
        
        g_D3DDev.SetTexture 0, SunTex
         
        g_D3DDev.DrawPrimitive D3DPT_TRIANGLESTRIP, D3DFVF_VERTEX, SunVertex(1), 4, D3DDP_DEFAULT

    g_D3DDev.EndScene
    '===========================================================================================
    
End Sub

Public Sub subDrawEarth()
    g_D3DDev.SetRenderState D3DRENDERSTATE_ZENABLE, 2
    
    g_D3DDev.LightEnable 0, True
    
    Material.emissive.R = 0
    Material.emissive.G = 0
    Material.emissive.B = 0
    g_D3DDev.SetMaterial Material
    
    g_D3DDev.BeginScene
    
        'Erde
        Light.position = Vector(-100, 0, 230)
        Light.Ambient.R = 1
        Light.Ambient.G = 1
        Light.Ambient.B = 1
        Light.attenuation1 = 0.01
        Light.range = 250
        g_D3DDev.SetLight 0, Light
        g_D3DDev.SetRenderState D3DRENDERSTATE_SRCBLEND, 2
        g_D3DDev.SetRenderState D3DRENDERSTATE_DESTBLEND, 1
        g_D3DDev.SetRenderState D3DRENDERSTATE_AMBIENT, RGB(5, 5, 5)
        g_D3DDev.SetTexture 0, EarthTex
        g_D3DDev.DrawPrimitive D3DPT_TRIANGLELIST, D3DFVF_VERTEX, PlanetVertex(1), MAX_SEGMENTS, D3DDP_WAIT
        
        'Wolken
        Light.Ambient.R = 0.5
        Light.Ambient.G = 0.5
        Light.Ambient.B = 0.5
        g_D3DDev.SetLight 0, Light
        g_D3DDev.SetRenderState D3DRENDERSTATE_SRCBLEND, 2
        g_D3DDev.SetRenderState D3DRENDERSTATE_DESTBLEND, 2
        g_D3DDev.SetTexture 0, CloudTex
        g_D3DDev.DrawPrimitive D3DPT_TRIANGLELIST, D3DFVF_VERTEX, CloudVertex(1), MAX_SEGMENTS, D3DDP_WAIT
        
        'Ring
        Light.Ambient.R = 1
        Light.Ambient.G = 1
        Light.Ambient.B = 1
        Light.range = 500
        g_D3DDev.SetLight 0, Light
        g_D3DDev.SetRenderState D3DRENDERSTATE_SRCBLEND, 2
        g_D3DDev.SetRenderState D3DRENDERSTATE_DESTBLEND, 2
        g_D3DDev.SetRenderState D3DRENDERSTATE_AMBIENT, RGB(0, 0, 0)
        g_D3DDev.SetTexture 0, RingTex
        g_D3DDev.DrawPrimitive D3DPT_TRIANGLELIST, D3DFVF_VERTEX, CircleVertex(1), MAX_CIRCLE_SEGMENTS * 6, D3DDP_WAIT
        
    g_D3DDev.EndScene
End Sub

Public Sub subDrawUniverse()

    Material.emissive.R = 0
    Material.emissive.G = 0
    Material.emissive.B = 0.1
    g_D3DDev.SetMaterial Material
    
    g_D3DDev.BeginScene
        
        g_D3DDev.SetRenderState D3DRENDERSTATE_SRCBLEND, 2
        g_D3DDev.SetRenderState D3DRENDERSTATE_DESTBLEND, 1
       
        'Sterne
        g_D3DDev.SetTexture 0, StarsTex
        g_D3DDev.SetRenderState D3DRENDERSTATE_AMBIENT, RGB(255, 255, 255)
        g_D3DDev.DrawPrimitive D3DPT_TRIANGLELIST, D3DFVF_VERTEX, S3CloudVertex(1), MAX_SEGMENTS, D3DDP_WAIT
        
        
        g_D3DDev.SetRenderState D3DRENDERSTATE_SRCBLEND, 2
        g_D3DDev.SetRenderState D3DRENDERSTATE_DESTBLEND, 2
        
        'SternWolken
        g_D3DDev.SetTexture 0, CloudTex
        g_D3DDev.SetRenderState D3DRENDERSTATE_AMBIENT, RGB(0, 0, 20)
        g_D3DDev.DrawPrimitive D3DPT_TRIANGLELIST, D3DFVF_VERTEX, S1CloudVertex(1), MAX_SEGMENTS, D3DDP_WAIT
        g_D3DDev.SetRenderState D3DRENDERSTATE_AMBIENT, RGB(10, 0, 0)
        g_D3DDev.DrawPrimitive D3DPT_TRIANGLELIST, D3DFVF_VERTEX, S2CloudVertex(1), MAX_SEGMENTS, D3DDP_WAIT
                
    g_D3DDev.EndScene

End Sub

Public Sub subCWarpStars()
    With g_D3DDev
        .BeginScene
            .SetRenderState D3DRENDERSTATE_SRCBLEND, 2
            .SetRenderState D3DRENDERSTATE_DESTBLEND, 2
        
            .SetRenderState D3DRENDERSTATE_ZENABLE, 0
            
            Material.emissive.R = 1
            Material.emissive.G = 1
            Material.emissive.B = 1
            .SetMaterial Material
        
            .SetTexture 0, WarpStarTex
            .DrawPrimitive D3DPT_TRIANGLELIST, D3DFVF_VERTEX, WStarVertex(0), WStarVertexCount, D3DDP_DEFAULT
        .EndScene
    End With
End Sub

Public Sub subDrawCreditsMisc()

    
    If FadeFromBlackDull < 1 Then
    
        FadeFromBlackDull = FadeFromBlackDull + 0.01 * ConstSpeed
    
        subDrawEffect FadeFromBlackDull, 8, 3
    
    End If
    
    subDrawCreditsTexts
    
    If Fade > 0 Then
    
        Fade = Fade - 0.01 * ConstSpeed
        
        subDrawEffect Fade, 2, 2

    End If
    
    
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
    
    '==================== DD ====================
    BackBuffer.DrawText 10, 20, "FPS: " & FPS, False
    
    'BackBuffer.DrawText 100, 20, "CamX:  " & CamX, False
    'BackBuffer.DrawText 100, 40, "CamY:  " & CamY, False
    'BackBuffer.DrawText 100, 60, "CamZ:  " & CamZ, False
    'BackBuffer.DrawText 100, 80, "RunCamSrc:  " & RunCamSrc, False
    
    'BackBuffer.DrawText 300, 20, "CamDX:  " & CamDX, False
    'BackBuffer.DrawText 300, 40, "CamDY:  " & CamDY, False
    'BackBuffer.DrawText 300, 60, "CamDZ:  " & CamDZ, False
    'BackBuffer.DrawText 300, 80, "RunCamDir:  " & RunCamDir, False
    
    'BackBuffer.DrawText 500, 30, "CreditsRun:  " & CreditsRun, False
    '============================================

    Primary.Flip Nothing, DDFLIP_NOVSYNC
    
End Sub

Public Sub subDrawCreditsTexts()


    Select Case CreditsRun
    Case 30 To 140
        
        If CreditsRun < 50 Then FontFade1 = FontFade1 + 0.005 * ConstSpeed
        If CreditsRun > 120 Then FontFade1 = FontFade1 - 0.005 * ConstSpeed
        
        subDraw3DText -360, 550, "Created by", 1, 1, 1, 800, FontFade1
    
    End Select
    Select Case CreditsRun
    Case 45 To 140
        
        If CreditsRun < 65 Then FontFade2 = FontFade2 + 0.005 * ConstSpeed
        If CreditsRun > 120 Then FontFade2 = FontFade2 - 0.005 * ConstSpeed
        
        subDraw3DText -300, 500, "Developer Agents", 1, 1, 1, 800, FontFade2
    
    End Select

    '###################################################################################
    Select Case CreditsRun
    Case 170 To 250
        
        If CreditsRun < 190 Then FontFade1 = FontFade1 + 0.005 * ConstSpeed
        If CreditsRun > 230 Then FontFade1 = FontFade1 - 0.005 * ConstSpeed
        
        subDraw3DText 120, 700, "Lead Programmers", 1, 1, 1, 800, FontFade1
    
    End Select
    Select Case CreditsRun
    Case 185 To 250
        
        If CreditsRun < 205 Then FontFade2 = FontFade2 + 0.005 * ConstSpeed
        If CreditsRun > 230 Then FontFade2 = FontFade2 - 0.005 * ConstSpeed
        
        subDraw3DText 180, 680, "Sebastian Bauersfeld", 1, 1, 1, 1000, FontFade2
        
    End Select
    Select Case CreditsRun
    Case 200 To 250
    
        If CreditsRun < 220 Then FontFade3 = FontFade3 + 0.005 * ConstSpeed
        If CreditsRun > 230 Then FontFade3 = FontFade3 - 0.005 * ConstSpeed
        
        subDraw3DText 180, 630, "Richard Schubert", 1, 1, 1, 1000, FontFade3
    
    End Select
    
    '###################################################################################
    Select Case CreditsRun
    Case 400 To 480
        
        If CreditsRun < 420 Then FontFade1 = FontFade1 + 0.005 * ConstSpeed
        If CreditsRun > 460 Then FontFade1 = FontFade1 - 0.005 * ConstSpeed
        
        subDraw3DText 150, 400, "Additional Programmer", 1, 1, 1, 800, FontFade1
    
    End Select
    Select Case CreditsRun
    Case 415 To 480
        
        If CreditsRun < 435 Then FontFade2 = FontFade2 + 0.005 * ConstSpeed
        If CreditsRun > 460 Then FontFade2 = FontFade2 - 0.005 * ConstSpeed
        
        subDraw3DText 230, 320, "Robert Walter", 1, 1, 1, 1000, FontFade2
        
    End Select
    
    '###################################################################################
    Select Case CreditsRun
    Case 540 To 620
        
        If CreditsRun < 560 Then FontFade1 = FontFade1 + 0.005 * ConstSpeed
        If CreditsRun > 600 Then FontFade1 = FontFade1 - 0.005 * ConstSpeed
        
        subDraw3DText -380, 380, "Design", 1, 1, 1, 800, FontFade1
    
    End Select
    Select Case CreditsRun
    Case 555 To 620
        
        If CreditsRun < 575 Then FontFade2 = FontFade2 + 0.005 * ConstSpeed
        If CreditsRun > 600 Then FontFade2 = FontFade2 - 0.005 * ConstSpeed
        
        subDraw3DText -430, 290, "Paul Arnst", 1, 1, 1, 1000, FontFade2
        
    End Select
    
    '###################################################################################
    Select Case CreditsRun
    Case 740 To 820
        
        If CreditsRun < 760 Then FontFade1 = FontFade1 + 0.005 * ConstSpeed
        If CreditsRun > 800 Then FontFade1 = FontFade1 - 0.005 * ConstSpeed
        
        subDraw3DText 200, 650, "Music & SFX", 1, 1, 1, 800, FontFade1
    
    End Select
    Select Case CreditsRun
    Case 755 To 820
        
        If CreditsRun < 775 Then FontFade2 = FontFade2 + 0.005 * ConstSpeed
        If CreditsRun > 800 Then FontFade2 = FontFade2 - 0.005 * ConstSpeed
        
        subDraw3DText 300, 630, "Keex", 1, 1, 1, 1000, FontFade2
        
    End Select
    
    
    
    

    '###################################################################################
    Select Case CreditsRun
    Case Is > 1200
        
        If CreditsRun < 1220 Then FontFade1 = FontFade1 + 0.005 * ConstSpeed
        
        subDraw3DText 730, 100, "press Esc", 1, 1, 1, 1500, FontFade1
    
    End Select
    
End Sub

