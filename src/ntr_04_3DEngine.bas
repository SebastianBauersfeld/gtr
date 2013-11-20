Attribute VB_Name = "ntr_04_3DEngine"
Option Explicit


Public Sub subIntro()

    'subCalcFPS                 'FPS berechnen
    CalcFPS

    subDrawIntro

    '==================== DD ====================
    BackBuffer.DrawText 10, 10, "FPS: " & FPS, False
    'BackBuffer.DrawText 10, 30, "Intro.Script: " & Intro.Script, False
    'BackBuffer.DrawText 10, 30, "FontFade: " & FontFade, False
    '============================================
    
    'Primary.Flip Nothing, DDFLIP_NOVSYNC
    Primary.Flip Nothing, DDFLIP_WAIT

End Sub


'==================== D3D ====================
Public Sub subDrawIntro()

    BackBuffer.BltColorFill EmptyRect, 0
    
    'Löschen des       "3DBuffers"   , WICHTIG für Zbuffer ,alles löschen , Farbe mit der gelöscht werden soll
    g_D3DDev.Clear 1, RectViewport(), D3DCLEAR_ZBUFFER Or D3DCLEAR_TARGET, RGB(0, 0, 0), 1, 0
    
    subIntroScript
       
End Sub
'=============================================

Public Sub subDrawGalaxy()
    Dim n As Long

    With g_D3DDev
        .BeginScene
            .SetRenderState D3DRENDERSTATE_SRCBLEND, 2
            .SetRenderState D3DRENDERSTATE_DESTBLEND, 2
            
            'Galaxy
            Material.emissive.R = 1
            Material.emissive.G = 1
            Material.emissive.B = 1
            .SetMaterial Material
            
            .SetTexture 0, GalaxyTex
             
            .DrawPrimitive D3DPT_TRIANGLELIST, D3DFVF_VERTEX, GalaxyVertex(1), 6, D3DDP_DEFAULT
            
            'Sterne
            .SetTexture 0, StarTex
            
            Material.emissive.R = 1
            Material.emissive.G = 1
            Material.emissive.B = 1
            .SetMaterial Material
            
            For n = 1 To MAX_GALAXY_ELEMENTS
                .DrawPrimitive D3DPT_TRIANGLESTRIP, D3DFVF_VERTEX, Particle(n).Vertex(1), 4, D3DDP_DEFAULT
                .DrawPrimitive D3DPT_TRIANGLESTRIP, D3DFVF_VERTEX, Particle(n).Vertex(5), 4, D3DDP_DEFAULT
            Next
        .EndScene
    End With
End Sub

Public Sub subDrawGalaxyBack()
    With g_D3DDev
        .BeginScene
        
            .SetRenderState D3DRENDERSTATE_SRCBLEND, 2
            .SetRenderState D3DRENDERSTATE_DESTBLEND, 2
        
            .SetRenderState D3DRENDERSTATE_ZENABLE, 0
            
            Material.emissive.R = 1
            Material.emissive.G = 1
            Material.emissive.B = 1
            .SetMaterial Material
            
            'Sternenhimmel
            .SetTexture 0, StarsTex
            .DrawPrimitive D3DPT_TRIANGLELIST, D3DFVF_VERTEX, StarSkyVertex(1), MAX_SEGMENTS, D3DDP_WAIT
    
        .EndScene
    End With
End Sub

Public Sub subWarpStars()
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
  

Public Sub subDrawSentence()
    With g_D3DDev
        .BeginScene
        
            .SetRenderState D3DRENDERSTATE_SRCBLEND, 2
            .SetRenderState D3DRENDERSTATE_DESTBLEND, 2
            
            Material.emissive.R = Sentence.Fade
            Material.emissive.G = Sentence.Fade
            Material.emissive.B = Sentence.Fade
            Material.emissive.a = Sentence.Fade
            
            .SetMaterial Material
            
            .SetTexture 0, Sentence.Tex(Sentence.SelectedTex)
            .DrawPrimitive D3DPT_TRIANGLELIST, D3DFVF_VERTEX, Sentence.Vertex(0), 6, D3DDP_DEFAULT
        
            Material.emissive.R = 1
            Material.emissive.G = 1
            Material.emissive.B = 1
            Material.emissive.a = 1
            
            .SetMaterial Material
        .EndScene
    End With
   
End Sub

   
Public Sub subDrawFlash()
        
    With g_D3DDev
        .BeginScene
            Material.emissive.R = Flash.Fade
            Material.emissive.G = Flash.Fade
            Material.emissive.B = Flash.Fade
            Material.emissive.a = 1
            
            .SetRenderState D3DRENDERSTATE_SRCBLEND, 2
            .SetRenderState D3DRENDERSTATE_DESTBLEND, 2
            
            .SetMaterial Material
            
            .SetTexture 0, Nothing
            .DrawPrimitive D3DPT_TRIANGLELIST, D3DFVF_VERTEX, Flash.Vertex(0), 6, D3DDP_DEFAULT
            
            Material.emissive.R = 1
            Material.emissive.G = 1
            Material.emissive.B = 1
            Material.emissive.a = 1
            
            .SetMaterial Material
            
            Flash.Fade = Flash.Fade - 0.05 * ConstSpeed
        .EndScene
    End With
End Sub

