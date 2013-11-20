Attribute VB_Name = "ntr_01_Variablen"
Option Explicit

'=== Textures =====================================================================
Public StarTex                          As DirectDrawSurface7
Public GalaxyTex                        As DirectDrawSurface7
Public FontTex                          As DirectDrawSurface7
Public StarsTex                         As DirectDrawSurface7
Public WarpStarTex                      As DirectDrawSurface7
'==================================================================================

Public IntroMusic                       As DirectSoundBuffer
Public curs                             As DSCURSORS

Public Type TIntro
    'Kameradrehung
    CAMRAD                              As Single
    CAMRAD2                             As Single
    CAMR                                As Single
    
    Quit                                As Boolean
    
    Script                              As Single
    
    FadeFromBlackDull                   As Single
    
    RecoverStars                        As Boolean
    WarpStarSpeed                       As Single
End Type
Public Intro                            As TIntro

'=== Galaxy ==============================================

Public Const MAX_GALAXY_ELEMENTS        As Long = 5000

Public Type T3DParticle
    X                                   As Single
    Y                                   As Single
    Z                                   As Single
    Vertex(1 To 8)                     As D3DVERTEX
End Type
Public Particle(1 To MAX_GALAXY_ELEMENTS) As T3DParticle

Public GalaxyVertex(1 To 6)             As D3DVERTEX

Public GalaxyElementRadius              As Single
'=========================================================

'Schriften
Public Type T3DFont
    Letter(32 To 255)                   As RECT
    FontPic                             As DirectDrawSurface7
End Type
Public D3DFont                          As T3DFont

Public FontFade                         As Single

Public Const MAX_SEGMENTS_W             As Long = 20
Public Const MAX_SEGMENTS_H             As Long = 15
Public Const MAX_SEGMENTS               As Long = MAX_SEGMENTS_W * MAX_SEGMENTS_H * 6

Public Const MAX_WSTARS                 As Long = 4999
Public Const MAX_INTRO_VERTICES         As Long = (MAX_WSTARS + 1) * 3

Public StarSkyVertex(1 To MAX_SEGMENTS) As D3DVERTEX

'=== WarpStarIntro ==========================
Public WStarVertex(MAX_INTRO_VERTICES)  As D3DVERTEX
Public WStarVertexCount                 As Long

Public Type TWarpStar
    X                                   As Single
    Y                                   As Single
    Z                                   As Single
    Radius                              As Single
End Type
Public WarpStar(MAX_WSTARS)             As TWarpStar

Public Type TFlash
    Vertex(5)                           As D3DVERTEX
    Time                                As Long
    StartTime                           As Long
    Fade                                As Single
End Type
Public Flash                            As TFlash

Public Type TSentence
    Vertex(5)                           As D3DVERTEX
    Fade                                As Single
    SelectedTex                         As Byte
    Tex(1 To 3)                         As DirectDrawSurface7
End Type
Public Sentence                         As TSentence
'============================================





