Attribute VB_Name = "mnu_m02_Variablen"
Option Explicit

Public IsOnline                         As Boolean
Public BroadCastAddr                    As String

Public ReqRAM                           As Single
Public MapTileCount                     As Single

Public PlayerName                       As String
Public PlayerShip                       As Integer
Public ServerName                       As String

Public CTargetGUI                       As Integer

Public AveragePing                      As Integer


Public Const MaxShips As Long = 6
Type TFlyersProps
    TypeName                            As String * 20
    Description                         As String * 255
    Weight                              As Single
    Acceleration                        As Single
    MaxSpeed                            As Single
    SteerSpeed                          As Single
    Shields                             As Single
    CannonGap                           As Single
End Type
Public FlyerProps(1 To MaxShips)        As TFlyersProps

Type TFlyers
    Count                               As Integer
End Type
Public Flyers                           As TFlyers

Public GameModeList                     As TListBox
Public GameMode(0 To 10)                As String
Public CurrentGameMode                  As Long

Public FadetoCredits                    As Single

Type THUDColor
    R           As Single
    G           As Single
    B           As Single
    T           As Single
End Type
Public HUDColor As THUDColor

Enum ESubMenuStatus
    S_Default = 0
    S_Video
    S_Input
    S_Misc
    S_Player
    S_Create
    S_Join
    S_CreateINet
    S_JoinINet
    S_CreateSingle
End Enum

'=== UnterMenu ========================================================================
Type TSubMenu
    Picture                             As DirectDrawSurface7
    Rectangle                           As RECT
    str                                 As DDSURFACEDESC2
    Width                               As Integer
    Height                              As Integer
    X                                   As Single
    Y                                   As Single
    
    PosX                                As Single
    MovingX                             As Single
    TargetX                             As Single
   
    Vertex(8)                           As D3DVERTEX
    DDLine(3, 1)                        As Integer
    
    MenuStatus                          As ESubMenuStatus
End Type
Public SubMenu                          As TSubMenu
'=====================================================================================

Public Const MAX_MENU_BACKSTARS         As Integer = 200      'gibt an wieviele Sterne von jeder Sorte vorhanden sind

'=== Sterne ==========================================================================
Type TMainMenuBackStars
    RX(2, MAX_MENU_BACKSTARS)           As Single
    RY(2, MAX_MENU_BACKSTARS)           As Single
    Color(2)                            As Long
    SpeedX(2)                           As Single
    SpeedY(2)                           As Single
    RAD(2)                              As Single
End Type
Public MainMenuBackStars                As TMainMenuBackStars
'=====================================================================================

Public Const MAX_MENU_MOUSEPARTICLES    As Long = 100

'=== Maus-Partikel ===================================
Public Type T3DParticle
    X                                   As Single
    Y                                   As Single
    MX                                  As Single
    MY                                  As Single
    Age                                 As Single
    Vertex(1 To 4)                      As D3DVERTEX
End Type
Public MenuMouseParticle(1 To MAX_MENU_MOUSEPARTICLES) As T3DParticle

Public MenuMouseParticleCounter         As Integer
Public MenuMousePartTimeCounter         As Single
Public MenuMouseParticleRadius          As Single
'=====================================================

'GamePad
Public JoyName                          As String
Public JoyButton(0 To 35)               As Byte
Public JoyButtonStr(0 To 35)            As String
Public CurrentJoyBut                    As Byte

Public JoyLeft                          As Byte
Public JoyRight                         As Byte
Public JoyUp                            As Byte
Public JoyDown                          As Byte
Public JoyFire                          As Byte
Public JoyWeapon1                       As Byte
Public JoyWeapon2                       As Byte
Public JoyWeapon3                       As Byte
Public JoySelfDestr                     As Byte
Public JoyRecover                       As Byte
Public JoyReload                        As Byte
Public JoyScreenshot                    As Byte

Public HasJoyStick                      As Boolean

