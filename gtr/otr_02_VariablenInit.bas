Attribute VB_Name = "otr_02_VariablenInit"
Option Explicit

Public Sub subCreditsVarInit()
    Dim n As Long

    QuitCredits = False

    '=====================================================
    '============ weitere EngineEinstellungen ============
    g_D3DDev.SetRenderState D3DRENDERSTATE_CULLMODE, D3DCULL_NONE   'beide Seiten der Polys sollen gezeichnet werden
    g_D3DDev.SetRenderState D3DRENDERSTATE_FILLMODE, 3              'ob Points, Wireframe oder gefüllt

    '====== Materialdeklaration (für Licht) ======
    g_D3DDev.SetRenderState D3DRENDERSTATE_ALPHABLENDENABLE, True
    g_D3DDev.SetRenderState D3DRENDERSTATE_DITHERENABLE, 0
    
    Material.diffuse.R = 1
    Material.diffuse.G = 1
    Material.diffuse.B = 1
    Material.diffuse.a = 1

    Material.Ambient.R = 1
    Material.Ambient.G = 1
    Material.Ambient.B = 1
    Material.Ambient.a = 1

    Material.specular.R = 1
    Material.specular.G = 1
    Material.specular.B = 1
    Material.specular.a = 1
    
    Material.emissive.R = 0
    Material.emissive.G = 0
    Material.emissive.B = 0
    Material.emissive.a = 0
    
    Material.power = 20
    
    g_D3DDev.SetMaterial Material
    '=============================================

    '================ PointLicht ================
    g_D3DDev.SetRenderState D3DRENDERSTATE_AMBIENT, RGB(0, 0, 0)
    
    
    LightColor.R = 1
    LightColor.G = 0.8
    LightColor.B = 0

    Light.diffuse = LightColor
    Light.specular = LightColor
    Light.Ambient = LightColor
    Light.attenuation1 = 0.5    'wie schnell die Lichtstärke abnehmen soll
    Light.dltType = D3DLIGHT_POINT
    Light.position = Vector(200, 0, -401)
    Light.range = 2
   
    Credits3DShipImpLight = Light
    
    LightColor.R = 20
    LightColor.G = 0
    LightColor.B = 0

    Light.diffuse = LightColor
    Light.specular = LightColor
    Light.Ambient = LightColor
    Light.attenuation1 = 0.0001      'wie schnell die Lichtstärke abnehmen soll
    Light.dltType = D3DLIGHT_POINT
    Light.position = Vector(200, 2, -400)
    
    Light.range = 2
    
    g_DX.CreateD3DVertex 200 - 1, 2 + 1, -400, 0, 0, -1, 0, 0, Credits3DShipRedLightVertex(1)
    g_DX.CreateD3DVertex 200 + 1, 2 + 1, -400, 0, 0, -1, 1, 0, Credits3DShipRedLightVertex(2)
    g_DX.CreateD3DVertex 200 - 1, 2 - 1, -400, 0, 0, -1, 0, 1, Credits3DShipRedLightVertex(3)
    g_DX.CreateD3DVertex 200 + 1, 2 - 1, -400, 0, 0, -1, 1, 1, Credits3DShipRedLightVertex(4)
    
    Credits3DShipRedLight = Light
    
    LightColor.R = 1    'Farben von 0 bis 1
    LightColor.G = 1
    LightColor.B = 1

    Light.diffuse = LightColor
    Light.specular = LightColor
    Light.Ambient = LightColor
    Light.attenuation1 = 0.4    'wie schnell die Lichtstärke abnehmen soll
    Light.dltType = D3DLIGHT_POINT
    Light.position = Vector(200, 0, -390)
    Light.range = 5
   
    Credits3DShipLight = Light
    
    Light.attenuation1 = 0.04    'wie schnell die Lichtstärke abnehmen soll
    Light.dltType = D3DLIGHT_POINT
    Light.position = Vector(150, 0, -50)
    Light.range = 150
    g_D3DDev.SetLight 0, Light
    g_D3DDev.LightEnable 0, True
    '============================================
    
    'Vergrößerung:
    Dim TextureMagFilter As CONST_D3DTEXTUREMAGFILTER
    TextureMagFilter = D3DTFG_LINEAR
    g_D3DDev.SetTextureStageState 0, D3DTSS_MAGFILTER, TextureMagFilter
    g_D3DDev.SetTextureStageState 0, D3DTSS_MINFILTER, TextureMagFilter
    
    subInitCamRun
    
    subInitSpaceObjects
    
    '=== Fade ===================================
    FadeFromBlackDull = 0
    FadeToBlackDull = 1
    g_DX.CreateD3DVertex -2, 2, 0.2, 0, 0, -1, 0, 0, FadeVertex(1)
    g_DX.CreateD3DVertex 2, 2, 0.2, 0, 0, -1, 0, 0, FadeVertex(2)
    g_DX.CreateD3DVertex -2, -2, 0.2, 0, 0, -1, 0, 0, FadeVertex(3)
    g_DX.CreateD3DVertex 2, -2, 0.2, 0, 0, -1, 0, 0, FadeVertex(4)
    
    subIntroVarInit
    
    '======================== Warpstars erstellen ======================
    For n = 0 To MAX_INTRO_VERTICES - 3 Step 3
    
        g_DX.CreateD3DVertex 0, 0, 0, 0, 0, -1, 0, 1, WStarVertex(n)
        g_DX.CreateD3DVertex 0, 0, 0, 0, 0, -1, 0, 0, WStarVertex(n + 1)
        g_DX.CreateD3DVertex 0, 0, 0, 0, 0, -1, 1, 0.5, WStarVertex(n + 2)
    
    Next
    
    WStarVertexCount = (MAX_WSTARS + 1) * 3
    '===================================================================
    
    For n = 0 To MAX_WSTARS
        subGenerateCWStar n
    Next

    With Intro
        .Quit = False
        
        .Script = 0
        
        .CAMR = 1
        .CAMRAD = 0
        .CAMRAD2 = 0
        
        .RecoverStars = True
        .WarpStarSpeed = 0.5
        
        .FadeFromBlackDull = 0
    End With

    CreditsRun = 0

End Sub

Public Sub subInitSpaceObjects()
    Dim n As Long
    Dim m As Long
        
    Dim TextureDensity As Single
    Dim TextureDensityX As Single
    Dim TextureDensityY As Single
    Dim TextureDensitySX As Single
    Dim TextureDensitySY As Single
    
    
    Dim RAD As Single
    Dim RAD2 As Single
    Dim RADStep As Single
    Dim RADStep2 As Single
    
    Dim TMP As Single
    '======================== Polygone erstellen ========================
    Planet.RadiusH = 105
    Planet.RadiusW = 100
    
    TextureDensity = 150
    TextureDensitySX = (MAX_SEGMENTS_W - 1) / TextureDensity
    TextureDensitySY = (MAX_SEGMENTS_H - 1) / TextureDensity
    
    RADStep = (2 * PI) / MAX_SEGMENTS_W
    RADStep2 = PI / MAX_SEGMENTS_H
    TextureDensityY = 0
    With Planet
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
                    Sin(RAD2) * Sin(RAD) * .RadiusW, _
                    .RadiusH * Cos(RAD2), _
                    Sin(RAD2) * Cos(RAD) * .RadiusW, _
                    0, 0, -1, TextureDensityY + TextureDensitySY, TextureDensityX, _
                    PlanetVertex((n * 6 + 1) + (m * 6 * (MAX_SEGMENTS_W)))
                    '0 1
                    '0 0
                g_DX.CreateD3DVertex _
                    Sin(RAD2) * Sin(RAD + RADStep) * .RadiusW, _
                    .RadiusH * Cos(RAD2), _
                    Sin(RAD2) * Cos(RAD + RADStep) * .RadiusW, _
                    0, 0, -1, TextureDensityY + TextureDensitySY, TextureDensityX + TextureDensitySX, _
                    PlanetVertex((n * 6 + 2) + (m * 6 * (MAX_SEGMENTS_W)))
                    '0 0
                    '0 1
                g_DX.CreateD3DVertex _
                    Sin(RAD2 + RADStep2) * Sin(RAD) * .RadiusW, _
                    .RadiusH * Cos(RAD2 + RADStep2), _
                    Sin(RAD2 + RADStep2) * Cos(RAD) * .RadiusW, _
                    0, 0, -1, TextureDensityY, TextureDensityX, _
                    PlanetVertex((n * 6 + 3) + (m * 6 * (MAX_SEGMENTS_W)))
                    '1 0
                    '0 0
                g_DX.CreateD3DVertex _
                    Sin(RAD2 + RADStep2) * Sin(RAD + RADStep) * .RadiusW, _
                    .RadiusH * Cos(RAD2 + RADStep2), _
                    Sin(RAD2 + RADStep2) * Cos(RAD + RADStep) * .RadiusW, _
                    0, 0, -1, TextureDensityY, TextureDensityX + TextureDensitySX, _
                    PlanetVertex((n * 6 + 4) + (m * 6 * (MAX_SEGMENTS_W)))
                    '0 0
                    '1 0
                'g_DX.CreateD3DVertex _
                    'Sin(RAD2) * Sin(RAD + RADStep) * .RadiusW, _
                    '.RadiusH * Cos(RAD2), _
                    'Sin(RAD2) * Cos(RAD + RADStep) * .RadiusW, _
                    '0, 0, -1, TextureDensityY + TextureDensitySY, TextureDensityX + TextureDensitySX,
                    PlanetVertex((n * 6 + 5) + (m * 6 * (MAX_SEGMENTS_W))) = PlanetVertex((n * 6 + 2) + (m * 6 * (MAX_SEGMENTS_W)))
                    '0 0
                    '0 1
                'g_DX.CreateD3DVertex _
                    Sin(RAD2 + RADStep2) * Sin(RAD) * .RadiusW, _
                    .RadiusH * Cos(RAD2 + RADStep2), _
                    Sin(RAD2 + RADStep2) * Cos(RAD) * .RadiusW, _
                    0, 0, -1, TextureDensityY, TextureDensityX,
                    PlanetVertex((n * 6 + 6) + (m * 6 * (MAX_SEGMENTS_W))) = PlanetVertex((n * 6 + 3) + (m * 6 * (MAX_SEGMENTS_W)))
                    '1 0
                    '0 0
    
            Next
        Next
    End With
    
    For n = 1 To MAX_SEGMENTS
        CloudVertex(n).nz = PlanetVertex(n).nz
        CloudVertex(n).X = PlanetVertex(n).X * 1.01
        CloudVertex(n).Y = PlanetVertex(n).Y * 1.01
        CloudVertex(n).Z = PlanetVertex(n).Z * 1.01
        CloudVertex(n).tu = PlanetVertex(n).tu
        CloudVertex(n).tv = PlanetVertex(n).tv
        
        S1CloudVertex(n).nz = PlanetVertex(n).nz
        S1CloudVertex(n).X = PlanetVertex(n).X * 40
        S1CloudVertex(n).Y = PlanetVertex(n).Y * 40
        S1CloudVertex(n).Z = PlanetVertex(n).Z * 40
        S1CloudVertex(n).tu = PlanetVertex(n).tu
        S1CloudVertex(n).tv = PlanetVertex(n).tv
        
        S2CloudVertex(n).nz = PlanetVertex(n).nz
        S2CloudVertex(n).X = PlanetVertex(n).X * 39
        S2CloudVertex(n).Y = PlanetVertex(n).Y * 39
        S2CloudVertex(n).Z = PlanetVertex(n).Z * 39
        S2CloudVertex(n).tu = PlanetVertex(n).tu
        S2CloudVertex(n).tv = PlanetVertex(n).tv + 0.4
        
        S3CloudVertex(n).nz = PlanetVertex(n).nz
        S3CloudVertex(n).X = PlanetVertex(n).X * 41
        S3CloudVertex(n).Y = PlanetVertex(n).Y * 41
        S3CloudVertex(n).Z = PlanetVertex(n).Z * 41
        S3CloudVertex(n).tu = PlanetVertex(n).tu * 10
        S3CloudVertex(n).tv = PlanetVertex(n).tv * 10
    Next
    
    TMP = -100
    
    For n = 1 To MAX_SEGMENTS
        PlanetVertex(n).X = PlanetVertex(n).X + TMP
        PlanetVertex(n).tv = PlanetVertex(n).tv
        'PlanetVertex(n).Y = PlanetVertex(n).Y + 1000
        'PlanetVertex(n).Z = PlanetVertex(n).Z + 1000
        CloudVertex(n).X = CloudVertex(n).X + TMP
    Next
    
    '===================================================================
    Dim RadiusIn As Long
    Dim RadiusOut As Long
    TextureDensity = 1
    RADStep = (2 * PI) / MAX_CIRCLE_SEGMENTS
    RADStep2 = PI / MAX_CIRCLE_SEGMENTS * 2
    RAD = 0
    RAD2 = 0
    RadiusIn = 120
    RadiusOut = 170
    For n = 0 To MAX_CIRCLE_SEGMENTS - 1
        
        RAD = RAD + RADStep
        RAD2 = RAD2 + RADStep
        
        g_DX.CreateD3DVertex _
            Sin(RAD + RADStep) * RadiusIn + TMP, _
            -Sin(RAD + RADStep) * RadiusIn / 2, _
            Cos(RAD + RADStep) * RadiusIn, _
            0, 0, -1, TextureDensity, 0, _
            CircleVertex(n * 6 + 1)
            '0 1
            '0 0
        g_DX.CreateD3DVertex _
            Sin(RAD + RADStep) * RadiusOut + TMP, _
            -Sin(RAD + RADStep) * RadiusOut / 2, _
            Cos(RAD + RADStep) * RadiusOut, _
            0, 0, -1, TextureDensity, TextureDensity, _
            CircleVertex(n * 6 + 2)
            '0 0
            '0 1
        g_DX.CreateD3DVertex _
            Sin(RAD) * RadiusIn + TMP, _
            -Sin(RAD) * RadiusIn / 2, _
            Cos(RAD) * RadiusIn, _
            0, 0, -1, 0, 0, _
            CircleVertex(n * 6 + 3)
            '1 0
            '0 0
        g_DX.CreateD3DVertex _
            Sin(RAD) * RadiusOut + TMP, _
            -Sin(RAD) * RadiusOut / 2, _
            Cos(RAD) * RadiusOut, _
            0, 0, -1, 0, TextureDensity, _
            CircleVertex(n * 6 + 4)
            '0 0
            '1 0
        CircleVertex(n * 6 + 5) = CircleVertex(n * 6 + 2)
            '0 0
            '0 1
        CircleVertex(n * 6 + 6) = CircleVertex(n * 6 + 3)
            '1 0
            '0 0
    Next
    '===================================================================
    
    '======================== Sonne ====================================
    For n = 1 To MAX_SUN_ELEMENTS
        With SunElement(n)
            g_DX.CreateD3DVertex 0, 0, 0, 0, 0, -1, 0, 0, .Vertex(1)
            g_DX.CreateD3DVertex 0, 0, 0, 0, 0, -1, 1, 0, .Vertex(2)
            g_DX.CreateD3DVertex 0, 0, 0, 0, 0, -1, 0, 1, .Vertex(3)
            g_DX.CreateD3DVertex 0, 0, 0, 0, 0, -1, 1, 1, .Vertex(4)
            GenerateSunElement n
            .Age = 200
        End With
    Next
    Dim RADI As Single
    RADI = 300
    g_DX.CreateD3DVertex -1 * RADI, 1 * RADI, 4000, 0, 0, -1, 0, 0, SunVertex(1)
    g_DX.CreateD3DVertex 1.4 * RADI, 1 * RADI, 4000, 0, 0, -1, 1, 0, SunVertex(2)
    g_DX.CreateD3DVertex -1 * RADI, -1.4 * RADI, 4000, 0, 0, -1, 0, 1, SunVertex(3)
    g_DX.CreateD3DVertex 1.4 * RADI, -1.4 * RADI, 4000, 0, 0, -1, 1, 1, SunVertex(4)
    
    SunElementRadius = 100
    SunElementCounter = 1
    '===================================================================
    
    '======================== Sonne ====================================
    For n = 1 To MAX_IMP_ELEMENTS
        With ImpElement(n)
            g_DX.CreateD3DVertex 0, 0, 0, 0, 0, -1, 0, 0, .Vertex(1)
            g_DX.CreateD3DVertex 0, 0, 0, 0, 0, -1, 1, 0, .Vertex(2)
            g_DX.CreateD3DVertex 0, 0, 0, 0, 0, -1, 0, 1, .Vertex(3)
            g_DX.CreateD3DVertex 0, 0, 0, 0, 0, -1, 1, 1, .Vertex(4)
            GenerateImpElement n
            .Age = 200
        End With
    Next
    
    ImpElementRadius = 1
    ImpElementCounter = 1
    '===================================================================
    
    
   
End Sub
Public Sub subInitCamRun()
    Dim n As Long
    
    LoadCamPath

    RunCamSrc = 0
    RunCamDir = 0

    subLoadCreditsShipFromFile
    
    Fishmode = PI / 3
    
    CamX = 200
    CamY = 10
    CamZ = -450
    
    CamDX = 199
    CamDY = 9
    CamDZ = -440
    
End Sub

Public Sub LoadCamPath()
    Dim n As Long

    Open FontPath & "campoints.pth" For Input As #1
        Input #1, SplinePointsD
        For n = 0 To SplinePointsD - 1
            Input #1, SPS(n).X
            Input #1, SPS(n).Y
            Input #1, SPS(n).Z
            Input #1, SPS(n).V
                    
            Input #1, SPD(n).X
            Input #1, SPD(n).Y
            Input #1, SPD(n).Z
            Input #1, SPD(n).V
        Next n
    Close #1
    
    SplinePointsS = SplinePointsD
    
    '=== Tangentenberechnung ===
    TPS(0).X = SPS(0).X
    TPS(0).Y = SPS(0).Y
    TPS(0).Z = SPS(0).Z
    For n = 1 To SplinePointsS - 2
           
            TPS(n * 2 - 1).X = SPS(n).X + (SPS(n - 1).X - SPS(n + 1).X) / 5
            TPS(n * 2 - 1).Y = SPS(n).Y + (SPS(n - 1).Y - SPS(n + 1).Y) / 5
            TPS(n * 2 - 1).Z = SPS(n).Z + (SPS(n - 1).Z - SPS(n + 1).Z) / 5
            
            TPS(n * 2).X = SPS(n).X - (SPS(n - 1).X - SPS(n + 1).X) / 5
            TPS(n * 2).Y = SPS(n).Y - (SPS(n - 1).Y - SPS(n + 1).Y) / 5
            TPS(n * 2).Z = SPS(n).Z - (SPS(n - 1).Z - SPS(n + 1).Z) / 5
    Next
    TPS(n * 2 - 1).X = SPS(SplinePointsS - 1).X
    TPS(n * 2 - 1).Y = SPS(SplinePointsS - 1).Y
    TPS(n * 2 - 1).Z = SPS(SplinePointsS - 1).Z
    '===========================
   
    '=== Tangentenberechnung ===
    TPD(0).X = SPD(0).X
    TPD(0).Y = SPD(0).Y
    TPD(0).Z = SPD(0).Z
    For n = 1 To SplinePointsD - 2
            TPD(n * 2 - 1).X = SPD(n).X + (SPD(n - 1).X - SPD(n + 1).X) / 5
            TPD(n * 2 - 1).Y = SPD(n).Y + (SPD(n - 1).Y - SPD(n + 1).Y) / 5
            TPD(n * 2 - 1).Z = SPD(n).Z + (SPD(n - 1).Z - SPD(n + 1).Z) / 5
            
            TPD(n * 2).X = SPD(n).X - (SPD(n - 1).X - SPD(n + 1).X) / 5
            TPD(n * 2).Y = SPD(n).Y - (SPD(n - 1).Y - SPD(n + 1).Y) / 5
            TPD(n * 2).Z = SPD(n).Z - (SPD(n - 1).Z - SPD(n + 1).Z) / 5
    Next
    TPD(n * 2 - 1).X = SPD(SplinePointsD - 1).X
    TPD(n * 2 - 1).Y = SPD(SplinePointsD - 1).Y
    TPD(n * 2 - 1).Z = SPD(SplinePointsD - 1).Z
    '===========================
End Sub



Public Sub subGenerateCWStar(Count As Long)
Dim RAD As Single

RAD = Rnd * (PI * 2)
WarpStar(Count).Radius = (((MAX_WSTARS + 1) - Count) / (250 / (Count / (MAX_WSTARS + 1) + 1))) + 2

WarpStar(Count).X = Cos(RAD) * WarpStar(Count).Radius
WarpStar(Count).Y = Sin(RAD) * WarpStar(Count).Radius
WarpStar(Count).Z = (Rnd * 100) - 35

WStarVertex(Count * 3).X = WarpStar(Count).X + Cos(RAD)
WStarVertex(Count * 3).Y = WarpStar(Count).Y + Sin(RAD)
WStarVertex(Count * 3).Z = WarpStar(Count).Z
WStarVertex(Count * 3 + 1).X = WarpStar(Count).X + Cos(RAD + 0.3)
WStarVertex(Count * 3 + 1).Y = WarpStar(Count).Y + Sin(RAD + 0.3)
WStarVertex(Count * 3 + 1).Z = WarpStar(Count).Z

WStarVertex(Count * 3 + 2).X = WarpStar(Count).X + Cos(RAD + 0.15)
WStarVertex(Count * 3 + 2).Y = WarpStar(Count).Y + Sin(RAD + 0.15)
WStarVertex(Count * 3 + 2).Z = WarpStar(Count).Z - 10 / WarpStar(Count).Radius


End Sub


