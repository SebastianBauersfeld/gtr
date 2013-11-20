Attribute VB_Name = "ntr_02_VarInit"
Option Explicit

Public Sub subIntroVarInit()
    Dim n As Long
    
    '============= 3D-Render-Bereich deklarieren =============
    ViewPort.lX = 0
    ViewPort.lY = 0
    ViewPort.lWidth = ResolutionX
    ViewPort.lHeight = ResolutionY
    g_D3DDev.SetViewport ViewPort
    
    
    With RectViewport(0)
        .X1 = 0
        .Y1 = 0
        .X2 = ResolutionX
        .Y2 = ResolutionY
    End With
    '=========================================================
    
    '============== BildschirmPosition setzen ==============
    g_DX.IdentityMatrix matView
                              ' von wo(X, Y,   Z), wo hingucken   , Lage der 3DWelt, Rotation des Screens um Z-Achse in Rad
    Call g_DX.ViewMatrix(matView, Vector(0, 0, -30), Vector(0, 0, 0), Vector(0, 1, 0), 0)
    
    g_D3DDev.SetTransform D3DTRANSFORMSTATE_VIEW, matView
    '=======================================================
      
    '============= Projektion der 3D-Welt festlegen =============
    g_DX.IdentityMatrix matProj
                                    ' Mindestentfernung
                                       ' Maximumentfernung
                                             ' Blickweite
    Call g_DX.ProjectionMatrix(matProj, 1, 5000, PI / 3)
    g_D3DDev.SetTransform D3DTRANSFORMSTATE_PROJECTION, matProj
    
    g_D3DDev.SetRenderTarget BackBuffer
    '============================================================
    
    '=====================================================
    '============ weitere EngineEinstellungen ============
    g_D3DDev.SetRenderState D3DRENDERSTATE_CULLMODE, D3DCULL_NONE   'beide Seiten der Polys sollen gezeichnet werden
    g_D3DDev.SetRenderState D3DRENDERSTATE_FILLMODE, 3              'ob Points, Wireframe oder gefüllt

    '====== Materialdeklaration (für Licht) ======
    g_D3DDev.SetRenderState D3DRENDERSTATE_ALPHABLENDENABLE, 1
      
    Material.diffuse.R = 1
    Material.diffuse.G = 1
    Material.diffuse.B = 1
    Material.diffuse.a = 1

    Material.Ambient.R = 1
    Material.Ambient.G = 1
    Material.Ambient.B = 1
    Material.Ambient.a = 1

    Material.specular.R = 0
    Material.specular.G = 0
    Material.specular.B = 0
    Material.specular.a = 0
    
    Material.emissive.R = 1
    Material.emissive.G = 1
    Material.emissive.B = 1
    Material.emissive.a = 1
    
    Material.power = 10
    
    g_D3DDev.SetMaterial Material
    '============================================
    
    'Vergrößerung und Verkleinerung:
    Dim TextureMagFilter As CONST_D3DTEXTUREMAGFILTER
    TextureMagFilter = D3DTFG_LINEAR
    g_D3DDev.SetTextureStageState 0, D3DTSS_MAGFILTER, TextureMagFilter
    g_D3DDev.SetTextureStageState 0, D3DTSS_MINFILTER, TextureMagFilter
    '=====================================================
    '=====================================================
    
    
    With Intro
        .Quit = False
        
        .Script = 0
        
        .CAMR = 250
        .CAMRAD = 0
        .CAMRAD2 = 0.4
        
        .RecoverStars = True
        .WarpStarSpeed = 0.5
        
        .FadeFromBlackDull = 0
    End With
        
    subCreateBackGroundSphere
        
    '======================== Polygone erstellen ========================
    GalaxyElementRadius = 2
    
    For n = 1 To MAX_GALAXY_ELEMENTS
        g_DX.CreateD3DVertex 0, 0, 0, 0, 0, -1, 0, 0, Particle(n).Vertex(1)
        g_DX.CreateD3DVertex 0, 0, 0, 0, 0, -1, 1, 0, Particle(n).Vertex(2)
        g_DX.CreateD3DVertex 0, 0, 0, 0, 0, -1, 0, 1, Particle(n).Vertex(3)
        g_DX.CreateD3DVertex 0, 0, 0, 0, 0, -1, 1, 1, Particle(n).Vertex(4)
        
        g_DX.CreateD3DVertex 0, 0, 0, 0, 0, -1, 0, 0, Particle(n).Vertex(5)
        g_DX.CreateD3DVertex 0, 0, 0, 0, 0, -1, 1, 0, Particle(n).Vertex(6)
        g_DX.CreateD3DVertex 0, 0, 0, 0, 0, -1, 0, 1, Particle(n).Vertex(7)
        g_DX.CreateD3DVertex 0, 0, 0, 0, 0, -1, 1, 1, Particle(n).Vertex(8)
       
        subGenerateGalaxyElement n
    Next
    
    Dim RADX As Single
    Dim RADY As Single
    
    RADX = 40
    RADX = 120
    g_DX.CreateD3DVertex -RADX, 0, RADX, 0, 0, -1, 0, 0, GalaxyVertex(1)
    g_DX.CreateD3DVertex RADX, 0, RADX, 0, 0, -1, 1, 0, GalaxyVertex(2)
    g_DX.CreateD3DVertex -RADX, 0, -RADX, 0, 0, -1, 0, 1, GalaxyVertex(3)
    g_DX.CreateD3DVertex RADX, 0, RADX, 0, 0, -1, 1, 0, GalaxyVertex(4)
    g_DX.CreateD3DVertex RADX, 0, -RADX, 0, 0, -1, 1, 1, GalaxyVertex(5)
    g_DX.CreateD3DVertex -RADX, 0, -RADX, 0, 0, -1, 0, 1, GalaxyVertex(6)
    '===================================================================
    
    '=== Fade ===================================
    g_DX.CreateD3DVertex -2, 2, 1, 0, 0, -1, 0, 0, FadeVertex(1)
    g_DX.CreateD3DVertex 2, 2, 1, 0, 0, -1, 0, 0, FadeVertex(2)
    g_DX.CreateD3DVertex -2, -2, 1, 0, 0, -1, 0, 0, FadeVertex(3)
    g_DX.CreateD3DVertex 2, -2, 1, 0, 0, -1, 0, 0, FadeVertex(4)
    
    subInit3DFontProps
        
    '======================== Polygone erstellen ========================
    For n = 0 To MAX_INTRO_VERTICES - 3 Step 3
    
        g_DX.CreateD3DVertex 0, 0, 0, 0, 0, -1, 0, 1, WStarVertex(n)
        g_DX.CreateD3DVertex 0, 0, 0, 0, 0, -1, 0, 0, WStarVertex(n + 1)
        g_DX.CreateD3DVertex 0, 0, 0, 0, 0, -1, 1, 0.5, WStarVertex(n + 2)
    
    Next
    
    WStarVertexCount = (MAX_WSTARS + 1) * 3
    '===================================================================
    
    For n = 0 To MAX_WSTARS
        subGenerateWStar n
    Next
    

    g_DX.CreateD3DVertex -5, -1.5, -15, 0, 0, -1, 0, 1, Sentence.Vertex(0)
    g_DX.CreateD3DVertex -5, 1.5, -15, 0, 0, -1, 0, 0, Sentence.Vertex(1)
    g_DX.CreateD3DVertex 5, -1.5, -15, 0, 0, -1, 1, 1, Sentence.Vertex(2)
    g_DX.CreateD3DVertex -5, 1.5, -15, 0, 0, -1, 0, 0, Sentence.Vertex(3)
    g_DX.CreateD3DVertex 5, -1.5, -15, 0, 0, -1, 1, 1, Sentence.Vertex(4)
    g_DX.CreateD3DVertex 5, 1.5, -15, 0, 0, -1, 1, 0, Sentence.Vertex(5)


    g_DX.CreateD3DVertex -1.5, -1.5, -29, 0, 0, -1, 0, 1, Flash.Vertex(0)
    g_DX.CreateD3DVertex -1.5, 1.5, -29, 0, 0, -1, 0, 0, Flash.Vertex(1)
    g_DX.CreateD3DVertex 1.5, -1.5, -29, 0, 0, -1, 1, 1, Flash.Vertex(2)
    g_DX.CreateD3DVertex -1.5, 1.5, -29, 0, 0, -1, 0, 0, Flash.Vertex(3)
    g_DX.CreateD3DVertex 1.5, -1.5, -29, 0, 0, -1, 1, 1, Flash.Vertex(4)
    g_DX.CreateD3DVertex 1.5, 1.5, -29, 0, 0, -1, 1, 0, Flash.Vertex(5)


    Sentence.Fade = -1
    Sentence.SelectedTex = 1

End Sub

Public Sub subCreateBackGroundSphere()
    Dim n As Long
    Dim m As Long

    Dim RadiusH                     As Long
    Dim RadiusW                     As Long
    
    Dim TextureDensity              As Single
    Dim TextureDensityX             As Single
    Dim TextureDensityY             As Single
    Dim TextureDensitySX            As Single
    Dim TextureDensitySY            As Single
    
    Dim RAD                         As Single
    Dim RAD2                        As Single
    Dim RADStep                     As Single
    Dim RADStep2                    As Single
    
    '======================== Polygone erstellen ========================
    RadiusH = 4000
    RadiusW = 4000
    
    TextureDensity = 15
    TextureDensitySX = (MAX_SEGMENTS_W - 1) / TextureDensity
    TextureDensitySY = (MAX_SEGMENTS_H - 1) / TextureDensity
    
    RADStep = (2 * PI) / MAX_SEGMENTS_W
    RADStep2 = PI / MAX_SEGMENTS_H
    TextureDensityY = 0
    RAD2 = -RADStep2
    For m = 0 To MAX_SEGMENTS_H - 1
        TextureDensityY = TextureDensityY - TextureDensitySY
        RAD = -PI
        RAD2 = RAD2 + RADStep2
        TextureDensityX = 0
        For n = 0 To MAX_SEGMENTS_W - 1
        
            TextureDensityX = TextureDensityX + TextureDensitySX
            
            RAD = RAD + RADStep
            g_DX.CreateD3DVertex _
                Sin(RAD2) * Sin(RAD) * RadiusW, _
                RadiusH * Cos(RAD2), _
                Sin(RAD2) * Cos(RAD) * RadiusW, _
                0, 0, -1, TextureDensityY + TextureDensitySY, TextureDensityX, _
                StarSkyVertex((n * 6 + 1) + (m * 6 * (MAX_SEGMENTS_W)))
                '0 1
                '0 0
            g_DX.CreateD3DVertex _
                Sin(RAD2) * Sin(RAD + RADStep) * RadiusW, _
                RadiusH * Cos(RAD2), _
                Sin(RAD2) * Cos(RAD + RADStep) * RadiusW, _
                0, 0, -1, TextureDensityY + TextureDensitySY, TextureDensityX + TextureDensitySX, _
                StarSkyVertex((n * 6 + 2) + (m * 6 * (MAX_SEGMENTS_W)))
                '0 0
                '0 1
            g_DX.CreateD3DVertex _
                Sin(RAD2 + RADStep2) * Sin(RAD) * RadiusW, _
                RadiusH * Cos(RAD2 + RADStep2), _
                Sin(RAD2 + RADStep2) * Cos(RAD) * RadiusW, _
                0, 0, -1, TextureDensityY, TextureDensityX, _
                StarSkyVertex((n * 6 + 3) + (m * 6 * (MAX_SEGMENTS_W)))
                '1 0
                '0 0
            g_DX.CreateD3DVertex _
                Sin(RAD2 + RADStep2) * Sin(RAD + RADStep) * RadiusW, _
                RadiusH * Cos(RAD2 + RADStep2), _
                Sin(RAD2 + RADStep2) * Cos(RAD + RADStep) * RadiusW, _
                0, 0, -1, TextureDensityY, TextureDensityX + TextureDensitySX, _
                StarSkyVertex((n * 6 + 4) + (m * 6 * (MAX_SEGMENTS_W)))
                '0 0
                '1 0
                StarSkyVertex((n * 6 + 5) + (m * 6 * (MAX_SEGMENTS_W))) = StarSkyVertex((n * 6 + 2) + (m * 6 * (MAX_SEGMENTS_W)))
                '0 0
                '0 1
                StarSkyVertex((n * 6 + 6) + (m * 6 * (MAX_SEGMENTS_W))) = StarSkyVertex((n * 6 + 3) + (m * 6 * (MAX_SEGMENTS_W)))
                '1 0
                '0 0
        Next
    Next
End Sub


Public Sub subGenerateWStar(Count As Long)
Dim RAD As Single

RAD = Rnd * (PI * 2)
WarpStar(Count).Radius = (((MAX_WSTARS + 1) - Count) / (250 / (Count / (MAX_WSTARS + 1) + 1))) + 2

WarpStar(Count).X = Cos(RAD) * WarpStar(Count).Radius
WarpStar(Count).Y = Sin(RAD) * WarpStar(Count).Radius
WarpStar(Count).Z = (Rnd * 100) - 10

WStarVertex(Count * 3).X = WarpStar(Count).X + Cos(RAD)
WStarVertex(Count * 3).Y = WarpStar(Count).Y + Sin(RAD)
WStarVertex(Count * 3).Z = WarpStar(Count).Z
WStarVertex(Count * 3 + 1).X = WarpStar(Count).X + Cos(RAD + 0.3)
WStarVertex(Count * 3 + 1).Y = WarpStar(Count).Y + Sin(RAD + 0.3)
WStarVertex(Count * 3 + 1).Z = WarpStar(Count).Z

WStarVertex(Count * 3 + 2).X = WarpStar(Count).X + Cos(RAD + 0.15)
WStarVertex(Count * 3 + 2).Y = WarpStar(Count).Y + Sin(RAD + 0.15)
WStarVertex(Count * 3 + 2).Z = WarpStar(Count).Z + 10 / WarpStar(Count).Radius


End Sub


Public Sub subGenerateGalaxyElement(Count As Long)
    Dim RAD                     As Single
    Dim RAD2                    As Single
    Dim TMP                     As Single
    Dim TMP2                    As Single
    
    With Particle(Count)
    
        If Count Mod 2 = 0 Then
            RAD = Rnd * PI * 3
            
            TMP = (Rnd * 20 - 10) * RAD / 3
            TMP2 = (Rnd * 20 - 10) * RAD / 3
        
            .X = Cos(RAD + 0.4) * RAD * 10 + TMP
            .Z = Sin(RAD + 0.4) * RAD * 10 + TMP2
        Else
            RAD = Rnd * PI * 3
            
            TMP = (Rnd * 20 - 10) * RAD / 3
            TMP2 = (Rnd * 20 - 10) * RAD / 3
        
            .X = Cos(RAD + PI + 0.6) * RAD * 10 + TMP
            .Z = Sin(RAD + PI + 0.6) * RAD * 10 + TMP2
        End If
        
        TMP = Sgn(Rnd - 0.5)
        TMP2 = ((.Z ^ 2 + .X ^ 2) ^ 0.5) / 50
        
        .Y = TMP * (((TMP2 - 1) / (TMP2 ^ 3 - TMP2 ^ 2 + TMP2 - 1)) * 20 - 4)
        
        .Vertex(1).X = .X - GalaxyElementRadius
        .Vertex(1).Y = .Y + GalaxyElementRadius
        .Vertex(1).Z = .Z
        
        .Vertex(2).X = .X + GalaxyElementRadius
        .Vertex(2).Y = .Y + GalaxyElementRadius
        .Vertex(2).Z = .Z
        
        .Vertex(3).X = .X - GalaxyElementRadius
        .Vertex(3).Y = .Y - GalaxyElementRadius
        .Vertex(3).Z = .Z
               
        .Vertex(4).X = .X + GalaxyElementRadius
        .Vertex(4).Y = .Y - GalaxyElementRadius
        .Vertex(4).Z = .Z
        
        
        
        .Vertex(5).X = .X
        .Vertex(5).Y = .Y + GalaxyElementRadius
        .Vertex(5).Z = .Z - GalaxyElementRadius
        
        .Vertex(6).X = .X
        .Vertex(6).Y = .Y + GalaxyElementRadius
        .Vertex(6).Z = .Z + GalaxyElementRadius
        
        .Vertex(7).X = .X
        .Vertex(7).Y = .Y - GalaxyElementRadius
        .Vertex(7).Z = .Z - GalaxyElementRadius
               
        .Vertex(8).X = .X
        .Vertex(8).Y = .Y - GalaxyElementRadius
        .Vertex(8).Z = .Z + GalaxyElementRadius
    
    End With

End Sub


