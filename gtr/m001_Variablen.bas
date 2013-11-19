Attribute VB_Name = "mnu_m01_Variablen"
'================================================================================
'=== MENU-Variablen =============================================================
'================================================================================

Option Explicit





'=== Textures =====================================
Public Menu3DStarTex                    As DirectDrawSurface7
Public MenuMouseStarTex                 As DirectDrawSurface7
'==================================================

'======== Licht-Variablen ========
Public LightColor                       As D3DCOLORVALUE
'=================================

'=== Sounds =================================================================
Public MenuFadeSound                    As DirectSoundBuffer
Public MenuMoveSound                    As DirectSoundBuffer
Public MenuBackSound                    As DirectSoundBuffer
'============================================================================

Type TMenu3DStar          'umherfliegender Stern
    X                                   As Single
    Y                                   As Single
    Z                                   As Single
    SpeedX                              As Single
    SpeedY                              As Single
    SpeedZ                              As Single
    TargetX                             As Single
    TargetY                             As Single
    TargetZ                             As Single
    Counter                             As Single
    Vertex(5)                           As D3DVERTEX
    Light                               As D3DLIGHT7
End Type
Public Menu3DStar(4)                    As TMenu3DStar

Public Const MAX_3DGTR_Vertices         As Integer = 2010

'=== GTR mit Ring ==============================
Type T3DGTR
    Vertex(MAX_3DGTR_Vertices)          As D3DVERTEX
    VertexCount                         As Integer
    Speed                               As Single
    PosX                                As Single
    PosY                                As Single
    PosZ                                As Single
    MovingX                             As Single
    MovingY                             As Single
    MovingZ                             As Single
    TargetX                             As Single
    TargetY                             As Single
    TargetZ                             As Single
    TempVector                          As D3DVECTOR
    RotationMitte                       As D3DVECTOR
End Type
Public GTR3D                            As T3DGTR
'===============================================

Type TPicture
    Picture                             As DirectDrawSurface7
    Rectangle                           As RECT
    Width                               As Integer
    Height                              As Integer
    X                                   As Single
    Y                                   As Single
End Type

'=== Mainmenu =================================
Enum EMenuStatus
    MainM = 0
    SingleM
    Multi
    Options
End Enum

Type TMainMenu

    Choise                              As TPicture
    Control                             As TPicture
    
    FadeSpeed                           As Single
    FadeExit                            As Single
    FadeCredits                         As Single
    FadeOptions                         As Single
    FadeMulti                           As Single
    FadeSingle                          As Single
    FadeUp                              As Single
    FadeDown                            As Single
    FadeX                               As Single
    
    FadeFromBlack                       As Single
    CamZ                                As Single
    
    MenuStatus                          As EMenuStatus
    MoveY                               As Single
    MotionSpeed                         As Integer
    
    Light                               As D3DLIGHT7
    
    Quit                                As Boolean
    StartGame                           As Boolean
    ItsMulti                            As Boolean
    StartIntro                          As Boolean
    StartCredits                        As Boolean
End Type
Public MainMenu As TMainMenu
'==============================================

'==============================================
'=== SteuerElemente ===========================
'==============================================
Public Enum EButtonEvent
    Event_BackToMenu = 1
    Event_BackToMulti
    Event_RestoreData
    Event_SaveData
    Event_Create
    Event_RefreshMulti
    Event_RefreshINet
    Event_Join
    Event_CreateINet
    Event_JoinINet
    Event_StartSingle
    Event_StartMulti
    Event_StartINet
    Event_JoinServer
    Event_JoinINetServer
    Event_CutINetCon
    Event_IgnoreINet
End Enum

Type TCheckBox
    Picture1                            As DirectDrawSurface7
    Picture2                            As DirectDrawSurface7
    Picture3                            As DirectDrawSurface7
    Picture4                            As DirectDrawSurface7
    Rectangle                           As RECT
    Width                               As Integer
    Height                              As Integer
End Type
Public CheckBox                         As TCheckBox

Type TScroller
    Picture1                            As DirectDrawSurface7
    Picture2                            As DirectDrawSurface7
    Rectangle                           As RECT
    Width                               As Integer
    Height                              As Integer
End Type
Public Scroller                         As TScroller

Type TKeyInput
    Width                               As Integer
    Height                              As Integer
    Key(1 To 20)                        As Integer
    CTRLDisc(1 To 20)                   As String
    ChosenKey                           As Integer
End Type
Public KeyInput                         As TKeyInput
Public GetControlKey                    As Boolean

Public KeyStr(255)                      As String

Type TFlyerBox
    Picture1                            As DirectDrawSurface7
    Picture2                            As DirectDrawSurface7
    Rectangle                           As RECT
    Width                               As Integer
    Height                              As Integer
    Flyer                               As TPicture
    LoadFlyer                           As Boolean
End Type
Public FlyerBox                         As TFlyerBox

Type TTextBox
    InUse                               As Boolean
    Text                                As String
    Blink                               As Boolean
End Type
Public PNameTextBox                     As TTextBox
Public SNameTextBox                     As TTextBox
Public BroadCastTextBox                     As TTextBox

Type TListBox
    ListCount                           As Long
    List()                              As String
    Selected                            As Long
    
    Picture1                            As DirectDrawSurface7
    Picture2                            As DirectDrawSurface7
    Rectangle                           As RECT
    Width                               As Integer
    Height                              As Integer
    Start                               As Integer
End Type
Public ServerListBox                    As TListBox
Public MapListBox                       As TListBox

Public MessageListBox                   As TListBox


Type TTargetGUI
    GUI(1 To 5)                         As DirectDrawSurface7
    Picture1                            As DirectDrawSurface7
    Picture2                            As DirectDrawSurface7
    Rectangle                           As RECT
    Width                               As Integer
    Height                              As Integer
End Type
Public TargetGUI                        As TTargetGUI
'==============================================
'==============================================
'==============================================

'=== StatusVariablen ===================
Public CurrentKeyDI                     As Integer
Public CurrentKey                       As Integer

Public MouseLDown                       As Boolean
Public MouseLUp                         As Boolean

Public MouseX                           As Integer
Public MouseY                           As Integer

Public MCursor                          As TPicture
'=======================================

'================================================================================
'================================================================================
'================================================================================
