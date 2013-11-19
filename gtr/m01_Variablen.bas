Attribute VB_Name = "gme_01_Variablen"
Option Explicit


'Direct Input (JoyStick)

Public DDI As DirectDrawIdentifier
Public DI As DirectInput
Public DIDev As DirectInputDevice
Public DIDevEnum As DirectInputEnumDevices
Public EventHandle As Long
Public JoyCaps As DIDEVCAPS
Public Joy As DIJOYSTATE
Public DIProp_Range As DIPROPRANGE




Public AscKeyQuit As Integer
Public AscKeyLeft As Integer
Public AscKeyRight As Integer
Public AscKeyUp As Integer
Public AscKeyDown As Integer
Public AscKeyFire As Integer
Public AscKeyWeapon1 As Integer
Public AscKeyWeapon2 As Integer
Public AscKeyWeapon3 As Integer
Public AscKeyNextWeapon As Integer
Public AscKeyPrevWeapon As Integer
Public AscKeyRecover As Integer
Public AscKeyScreenshot As Integer
Public AscKeyToggleHUD As Integer
Public AscKeySay As Integer
Public AscKeySayTeam As Integer
Public AscKeyToggleTarget As Integer
Public AscKeyTakeScreenshot As Integer

Public CMaxExploParts As Integer
Public CMaxWExploParts As Integer
Public CMaxBackStars(1 To 3) As Integer
Public BotCount As Integer
Public MaxPlayers As Integer

Public UseShockWaves As Boolean
Public UseLights As Boolean
Public DrawImpulse As Boolean

Public DrawRespawnEffect As Boolean
Public DrawBackStars As Boolean
Public DrawFPS As Boolean
Public DrawKillBoard As Boolean
Public DrawMsgBoard As Boolean

Public Type TDDPicDesc                                      'Bildbeschreibungs-Typ
    PicNum                      As Integer
    Width                       As Integer
    Height                      As Integer
    AnimWidth                   As Integer
End Type

'----MAP----

Public Const MAX_MAPTILE_KINDS          As Integer = 500
Public Const MAX_MAPTILE_PLAINS         As Integer = 4
Public Const MAX_HORIZONTAL_MAPTILES    As Integer = 250
Public Const MAX_VERTICAL_MAPTILES      As Integer = 250

Public Type TViewRect                               'Bildschirm-Rectangle-Typ
    Left                                As Single
    Top                                 As Single
    Right                               As Single
    Bottom                              As Single
End Type
Public ViewRect                         As TViewRect

Public Map              As TMap

Public Type TMapTilePic                                     'MapTile-Bild-Typ
    Pic                 As DirectDrawSurface7
    Used                As Boolean
End Type

Public MapTilePic(1 To MAX_MAPTILE_PLAINS, 1 To MAX_MAPTILE_KINDS) As TMapTilePic
Public MapTilePicDesc(1 To MAX_MAPTILE_PLAINS) As TDDPicDesc

Public MapTile(1 To MAX_MAPTILE_PLAINS, 1 To MAX_HORIZONTAL_MAPTILES, 1 To MAX_VERTICAL_MAPTILES) As TMapTile


'=========================================================================
'=========================================================================
'=========================================================================
'=========================================================================
'=========================================================================
'=========================================================================
'=========================================================================

'========= Auflösungsvariablen =======================
Public ResolutionX As Long              'für Auflösung
Public ResolutionY As Long              'für Auflösung
Public ColorDepth As Byte               'für Farbtiefe
'=====================================================

'============== FPS Variablen ==============
Public FPSTimer As Long                    'ZeitSpeicher
Public FPSCounter As Integer               'FPS-Counter
Public FPS As Single                       'FPS-Speicher-Variable
Public TimeQuotient             As Long    'Hilfsvariable FramesPerSecond
'===========================================

Public ConstSpeed As Single



Public D3D As Direct3D7

'=== DirectDraw-Variablen =============================================================
Public PrimaryBuffer As DDSURFACEDESC2
Public Primary As DirectDrawSurface7
Public BackBuffer As DirectDrawSurface7
Public Caps As DDSCAPS2
Public EmptyRect As RECT
Public EmptyStr As DDSURFACEDESC2
Public VSynchronisation As Boolean
'======================================================================================


'========== Z-Buffer-Variablen ==========
Public GetZBuffer As Direct3DEnumPixelFormats
Public PrimaryZBuffer As DDSURFACEDESC2
Public PixFMTZBuffer As DDPIXELFORMAT
Public ZBuffer As DirectDrawSurface7
'========================================

Public ViewPort As D3DVIEWPORT7
Public RectViewport(0) As D3DRECT
Public matProj As D3DMATRIX
Public matView  As D3DMATRIX
Public Material As D3DMATERIAL7

Public TextureMagFilter As CONST_D3DTEXTUREMAGFILTER

'=== Pfad-Variablen ====================================================================
Public PicturePath As String
Public SoundPath As String
Public ScreenShotPath As String
Public FontPath As String
Public MapPath As String
'=======================================================================================


'=== Colorkey- und FarbVariablen =======================================================
Public CKeyB As DDCOLORKEY          'ColorKeyVariable wird deklariert (Schwarz)
Public CKeyW As DDCOLORKEY          'ColorKeyVariable wird deklariert (Weiß)
'=======================================================================================



'=== DirectSound-Variablen ============================================================
Public DS7 As DirectSound
Public BufferDesc As DSBUFFERDESC
Public WaveFormat As WAVEFORMATEX
'=====================================================================================


Public D3DDivX As Single
Public D3DDivY As Single
Public D3DSubX As Single
Public D3DSubY As Single
