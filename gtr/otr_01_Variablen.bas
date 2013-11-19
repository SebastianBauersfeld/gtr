Attribute VB_Name = "otr_01_Variablen"
Option Explicit

'=== Textures =====================================================================
Public EarthTex As DirectDrawSurface7
Public RingTex As DirectDrawSurface7
Public CloudTex As DirectDrawSurface7
Public SunTex As DirectDrawSurface7
Public SunElementTex As DirectDrawSurface7
'Public StarsTex As DirectDrawSurface7
Public LightTex As DirectDrawSurface7
'==================================================================================

Public CreditsMusic                     As DirectSoundBuffer

'=== Kamerafahrt ============================
Public Type TCameraPoint
    X           As Single
    Y           As Single
    Z           As Single
    V           As Single
End Type

Public SPS(60)      As TCameraPoint
Public TPS(120)      As TCameraPoint
Public SPD(60)      As TCameraPoint
Public TPD(120)      As TCameraPoint
Public CSP          As TCameraPoint

Public SplinePointsS As Integer
Public SplinePointsD As Integer

Public CamX         As Single
Public CamY         As Single
Public CamZ         As Single
Public CamDX        As Single
Public CamDY        As Single
Public CamDZ        As Single

Public RunCamSrc    As Single
Public RunCamDir    As Single
'============================================

Public Light As D3DLIGHT7

Public FontFade1                        As Single
Public FontFade2                        As Single
Public FontFade3                        As Single

Public Fade As Single

Public Fishmode As Single

'=== Fade ===================================
Public FadeVertex(1 To 4)   As D3DVERTEX

Public FadeToBlackDull As Single
Public FadeFromBlackDull As Single
'============================================


'Public Const MAX_SEGMENTS_W = 20
'Public Const MAX_SEGMENTS_H = 15
'Public Const MAX_SEGMENTS = MAX_SEGMENTS_W * MAX_SEGMENTS_H * 6

Public PlanetVertex(1 To MAX_SEGMENTS) As D3DVERTEX
Public CloudVertex(1 To MAX_SEGMENTS) As D3DVERTEX
Public S1CloudVertex(1 To MAX_SEGMENTS) As D3DVERTEX
Public S2CloudVertex(1 To MAX_SEGMENTS) As D3DVERTEX
Public S3CloudVertex(1 To MAX_SEGMENTS) As D3DVERTEX
Public Type TSphere
    X As Single
    Y As Single
    Z As Single
    RadiusW As Single
    RadiusH As Single
End Type
Public Planet As TSphere
Public PlanetMatrix As D3DMATRIX

Public SelectedTex As Integer


Public Const MAX_CIRCLE_SEGMENTS = 50
Public CircleVertex(1 To MAX_CIRCLE_SEGMENTS * 6) As D3DVERTEX


'=== Sonne ==================================
Public SunVertex(1 To 4) As D3DVERTEX

Public Const MAX_SUN_ELEMENTS As Long = 2000

Public SunElementCounter As Long
Public Type T3DParticle
    X As Single
    Y As Single
    Z As Single
    MX As Single
    MY As Single
    Age As Single
    Vertex(1 To 4) As D3DVERTEX
End Type
Public SunElement(1 To MAX_SUN_ELEMENTS) As T3DParticle

Public SunElementRadius As Single
'============================================

Public Const MAX_SHIP_VERTICES As Integer = 3000

Public Type T3DShip
    X As Single
    Y As Single
    Z As Single
    Tex(1 To 11) As DirectDrawSurface7
End Type
Public Credits3DShip As T3DShip
Public Credits3DShipVertex(1 To MAX_SHIP_VERTICES) As D3DVERTEX

Public Credits3DShipLight As D3DLIGHT7
Public Credits3DShipImpLight As D3DLIGHT7
Public Credits3DShipRedLight As D3DLIGHT7
Public LightTime As Single

Public Credits3DShipRedLightVertex(1 To 4) As D3DVERTEX

'=== Impulse ==================================
Public Const MAX_IMP_ELEMENTS As Long = 500

Public ImpElementCounter As Long
Public ImpElement(1 To MAX_IMP_ELEMENTS) As T3DParticle

Public ImpElementRadius As Single
'============================================


Public QuitCredits As Boolean

Public CreditsRun As Single

