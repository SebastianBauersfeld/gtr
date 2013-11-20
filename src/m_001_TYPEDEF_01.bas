Attribute VB_Name = "m_001_TYPEDEF_01"
Option Explicit

'===API===

'für Time-Counter
Public Declare Function QueryPerformanceFrequency Lib "kernel32" _
(ByRef Frequency As Currency) As Long

Public Declare Function QueryPerformanceCounter Lib "kernel32" _
(ByRef Counter As Currency) As Long

'Infos über PC-Settings
Public Declare Function GetLocaleInfo Lib "kernel32" Alias "GetLocaleInfoA" _
(ByVal Locale As Long, ByVal LCType As Long, ByVal lpLCData As String, ByVal cchData As Long) As Long

'Auslesen aus INI-Dateien
Public Declare Function GetPrivateProfileString Lib "kernel32" Alias "GetPrivateProfileStringA" _
(ByVal lpApplicationName As String, ByVal lpKeyName As Any, ByVal lpDefault As String, _
ByVal lpReturnedString As String, ByVal nSize As Long, ByVal lpFileName As String) As Long

'Mauszeiger an / aus
Public Declare Function ShowCursor Lib "user32" (ByVal bShow As Long) As Long

'für Screenshots
Public Declare Function GetDC Lib "user32" (ByVal hWnd As Long) As Long
Public Declare Function ReleaseDC Lib "user32" (ByVal hWnd As Long, ByVal hdc As Long) As Long
Public Declare Function GetDesktopWindow Lib "user32" () As Long

'zum Blitten des Screenshots auf eine PictureBox
Public Declare Function BitBlt Lib "gdi32" (ByVal hDestDC As Long, ByVal X As Long, _
ByVal Y As Long, ByVal nWidth As Long, ByVal nHeight As Long, ByVal hSrcDC As Long, _
ByVal xSrc As Long, ByVal ySrc As Long, ByVal dwRop As Long) As Long


'===Konstanten===

Public Const DEFAULT_GAMESPEED                  As Integer = 85     'Standard-Geschwindigkeit in FPS

Public Const PI                                 As Single = 3.14159
Public Const HPI                                As Single = 1.57079
Public Const TPI                                As Single = 6.28318

Public Const KEY_COL_GREEN                      As Long = 2016      'SchlüsselFarbe Grün
Public Const KEY_COL_RED                        As Long = 63488     'SchlüsselFarbe Rot
Public Const KEY_COL_BLUE                       As Long = 31        'SchlüsselFarbe Blau
Public Const KEY_COL_BLACK                      As Long = 0

Public Const SOUND_DISTANCE_FACTOR              As Single = 2       'wie stark die Lautstärke eines Sounds bei Entfernung abnimmt

Public Const JOY_AXIS_TOLERANCE_X               As Long = 1000
Public Const JOY_AXIS_TOLERANCE_Y               As Long = 1000

Public Const MAX_CONSOLE_LINES                  As Integer = 100
Public Const DEFAULT_CONSOLE_SPEED              As Single = 9
Public Const DEFAULT_CONSOLE_LINEDIST           As Integer = 11
Public Const CONSOLE_LINE_X                     As Integer = 100
Public Const CONSOLE_LINE_Y                     As Integer = 100
Public Const CONSOLE_INPUT_X                    As Integer = 100
Public Const CONSOLE_INPUT_Y                    As Integer = 50
Public Const MAX_CONSOLE_INPUTLINECHARS         As Integer = 130

Public Const MAX_CONSOLE_COMPLETES              As Integer = 100

Public Const MAX_MSGBOARD_INFOS                 As Integer = 6
Public Const DEFAULT_MSGBOARD_X                 As Integer = 2
Public Const DEFAULT_MSGBOARD_Y                 As Integer = 20
Public Const DEFAULT_MSGBOARD_LINEDIST          As Integer = 11
Public Const DEFAULT_MSGBOARD_REFRESH_DELAY     As Long = 1000

Public Const NUM_MAP_PLAINS                     As Integer = 4
Public Const MAX_X_MAPTILES                     As Integer = 250
Public Const MAX_Y_MAPTILES                     As Integer = 250
Public Const MAX_MAPTILE_SURFS                  As Integer = 200
Public Const DEFAULT_MAPTILE_WIDTH              As Integer = 128
Public Const MAX_RESPAWN_POINTS                 As Integer = 200
Public Const MAX_GRAVITY_POINTS                 As Integer = 100
Public Const NUM_STAR_PLAINS                    As Integer = 3
Public Const MAX_STARS_PER_PLAIN                As Integer = 500
Public Const PLAIN1_STAR_COL                    As Long = 17100
Public Const PLAIN2_STAR_COL                    As Long = 38100
Public Const PLAIN3_STAR_COL                    As Long = 65535

Public Const MAX_ITEMS                          As Integer = 20
Public Const MAX_ITEM_RS_POINTS                 As Integer = 100
Public Const NUM_ITEM_TYPES                     As Integer = 11
Public Const ITEM_ANIM_SPEED                    As Single = 0.2
Public Const NUM_ITEM_FRAMES                    As Integer = 16
Public Const ITEM_STAY_DURATION                 As Long = 3000
Public Const ITEM_CREATE_DELAY                  As Long = 2000
Public Const ITEM_CREATE_PROBABILITY            As Long = 1
Public Const MAX_ITEM_TIMERS                    As Integer = 100
Public Const GAME_SPEED_CHANGE_SPEED            As Single = 1.5
Public Const ITEM_FIRE_DELAY                    As Long = 500
Public Const ITEM_SPEEDBOMB_DURATION            As Long = 4000
Public Const ITEM_SLOWMOBOMB_DURATION           As Long = 4000
Public Const ITEM_REVERSESTEER_DURATION         As Long = 4000
Public Const ITEM_DISABLECOLLISION_DURATION     As Long = 4000
Public Const ITEM_DOUBLESPEED_DURATION          As Long = 4000

Public Const RADAR_TILE_WIDTH                   As Integer = 6
Public Const RADAR_TILE_COL                     As Long = 2016

Public Const MAX_PLAYERS                        As Integer = 200
Public Const NUM_SHIP_TYPES                     As Integer = 6
Public Const NUM_SHIP_FRAMES                    As Integer = 40
Public Const MAX_SHIP_SPEED                     As Single = 200
Public Const DEFAULT_SPECTATOR_SPEED            As Single = 9
Public Const SPECTATOR_MAP_DESC_DURATION        As Long = 10000
Public Const SPECTATOR_SHOWMODE_DURATION        As Long = 2000
Public Const SPECTATOR_WAIT_DURATION            As Long = 2000

Public Const NUM_HD_COLL_POINTS                 As Integer = 20
Public Const NUM_LD_COLL_POINTS                 As Integer = 4
Public Const SHIP_COLL_RADIUS                   As Integer = 40

Public Const MAX_BOT_CREATE_POINTS              As Integer = 1000
Public Const MAX_BOT_WAY_POINTS                 As Integer = 5000
Public Const MAX_BOT_TARGET_DIST                As Single = 120
Public Const MAX_BOT_WAYPOINT_DIST              As Single = 120
Public Const MAX_BOT_ENEMY_DIST                 As Single = 500
Public Const BOT_ATTACK_PROBABILITY             As Integer = 10000
Public Const BOT_ACCELERATION_STEER_DIST        As Single = 1
Public Const MIN_BOT_RECOVER_DELAY              As Long = 2000

Public Const NUM_WEAPON_SURFS                   As Integer = 5
Public Const NUM_WEAPON_TYPES                   As Integer = 7
Public Const NUM_WEAPON_SLOTS                   As Integer = 3
Public Const NUM_WARHEADS_PER_PLAYER            As Integer = 80

Public Const SCOREBOARD_X                       As Integer = 212
Public Const SCOREBOARD_Y                       As Integer = 159
Public Const SCOREBOARD_WIDTH                   As Integer = 600
Public Const SCOREBOARD_HEIGHT                  As Integer = 450
Public Const SCOREBOARD_FIRSTLINE_Y             As Integer = 70
Public Const SCOREBOARD_NAME_X                  As Integer = 40
Public Const SCOREBOARD_SKILL_X                 As Integer = 260
Public Const SCOREBOARD_FRAGS_X                 As Integer = 390
Public Const SCOREBOARD_DEATHS_X                As Integer = 526
Public Const SCOREBOARD_LINE_DIST               As Integer = 18
Public Const MAX_SCOREBOARD_LINES               As Integer = 20
Public Const SCOREBOARD_REFRESH_DELAY           As Long = 1000

Public Const KILLBOARD_REFRESH_DELAY            As Long = 2000
Public Const KILLBOARD_LINE_DIST                As Integer = 20
Public Const NUM_KILLBOARD_MSGS                 As Integer = 5
Public Const KILLBOARD_SURF_DIST                As Integer = 10


'===Enums===

Public Enum ETextAlignment                                  'Block-Text-Ausrichtung
    TEXT_ALIGNMENT_LEFT = 1
    TEXT_ALIGNMENT_RIGHT
    TEXT_ALIGNMENT_CENTERED
End Enum

Public Enum EGameState                                      'Spiel-Status
    GAME_STATE_INTRO = 1
    GAME_STATE_MAINMENU
    GAME_STATE_GAME
    GAME_STATE_OUTRO
End Enum

Public Enum EGameMode                                       'SpielModus
    GAME_MODE_SP_DEATHMATCH = 1
    GAME_MODE_MP_DEATHMATCH
End Enum

Public Enum EPlayerState                                    'Spieler-Status
    PLAYER_STATE_INGAME = 1
    PLAYER_STATE_SPECTATOR
End Enum

Public Enum EKeyState                                       'Tastenstatus
    KEY_STATE_UP = 0
    KEY_STATE_DOWN
End Enum

Public Enum ECustomKeys                                     'belegbare Tasten
    CUSTOM_KEY_BACKSPACE = 8
    CUSTOM_KEY_TAB = 9
    CUSTOM_KEY_RETURN = 13
    CUSTOM_KEY_SHIFT = 16
    CUSTOM_KEY_CTRL = 17
    CUSTOM_KEY_ALT = 18
    CUSTOM_KEY_BREAK = 19
    CUSTOM_KEY_SWITCH = 20
    CUSTOM_KEY_ESCAPE = 27
    CUSTOM_KEY_SPACE = 32
    CUSTOM_KEY_PRIOR = 33
    CUSTOM_KEY_NEXT = 34
    CUSTOM_KEY_ENDPOS = 35
    CUSTOM_KEY_STARTPOS = 36
    CUSTOM_KEY_LEFT = 37
    CUSTOM_KEY_UP = 38
    CUSTOM_KEY_RIGHT = 39
    CUSTOM_KEY_DOWN = 40
    CUSTOM_KEY_INSERT = 45
    CUSTOM_KEY_DELETE = 46
    CUSTOM_KEY_0 = 48
    CUSTOM_KEY_1 = 49
    CUSTOM_KEY_2 = 50
    CUSTOM_KEY_3 = 51
    CUSTOM_KEY_4 = 52
    CUSTOM_KEY_5 = 53
    CUSTOM_KEY_6 = 54
    CUSTOM_KEY_7 = 55
    CUSTOM_KEY_8 = 56
    CUSTOM_KEY_9 = 57
    CUSTOM_KEY_A = 65
    CUSTOM_KEY_B = 66
    CUSTOM_KEY_C = 67
    CUSTOM_KEY_D = 68
    CUSTOM_KEY_E = 69
    CUSTOM_KEY_F = 70
    CUSTOM_KEY_G = 71
    CUSTOM_KEY_H = 72
    CUSTOM_KEY_I = 73
    CUSTOM_KEY_J = 74
    CUSTOM_KEY_K = 75
    CUSTOM_KEY_L = 76
    CUSTOM_KEY_M = 77
    CUSTOM_KEY_N = 78
    CUSTOM_KEY_O = 79
    CUSTOM_KEY_P = 80
    CUSTOM_KEY_Q = 81
    CUSTOM_KEY_R = 82
    CUSTOM_KEY_S = 83
    CUSTOM_KEY_T = 84
    CUSTOM_KEY_U = 85
    CUSTOM_KEY_V = 86
    CUSTOM_KEY_W = 87
    CUSTOM_KEY_X = 88
    CUSTOM_KEY_Y = 89
    CUSTOM_KEY_Z = 90
    CUSTOM_KEY_LWINDOW = 91
    CUSTOM_KEY_RWINDOW = 92
    CUSTOM_KEY_MENU = 93
    CUSTOM_KEY_NUM_0 = 96
    CUSTOM_KEY_NUM_1 = 97
    CUSTOM_KEY_NUM_2 = 98
    CUSTOM_KEY_NUM_3 = 99
    CUSTOM_KEY_NUM_4 = 100
    CUSTOM_KEY_NUM_5 = 101
    CUSTOM_KEY_NUM_6 = 102
    CUSTOM_KEY_NUM_7 = 103
    CUSTOM_KEY_NUM_8 = 104
    CUSTOM_KEY_NUM_9 = 105
    CUSTOM_KEY_NUM_MULTIPLY = 106
    CUSTOM_KEY_NUM_ADD = 107
    CUSTOM_KEY_NUM_SUBTRACT = 109
    CUSTOM_KEY_NUM_COMMA = 110
    CUSTOM_KEY_NUM_DIVIDE = 111
    CUSTOM_KEY_F1 = 112
    CUSTOM_KEY_F2 = 113
    CUSTOM_KEY_F3 = 114
    CUSTOM_KEY_F4 = 115
    CUSTOM_KEY_F5 = 116
    CUSTOM_KEY_F6 = 117
    CUSTOM_KEY_F7 = 118
    CUSTOM_KEY_F8 = 119
    CUSTOM_KEY_F9 = 120
    CUSTOM_KEY_F10 = 121
    CUSTOM_KEY_F11 = 122
    CUSTOM_KEY_F12 = 123
    CUSTOM_KEY_NUM_NUMLOCK = 144
    CUSTOM_KEY_SCROLLLOCK = 145
    CUSTOM_KEY_Ü = 168
    CUSTOM_KEY_ADD = 187
    CUSTOM_KEY_COMMA = 188
    CUSTOM_KEY_HYPHEN = 189
    CUSTOM_KEY_POINT = 190
    CUSTOM_KEY_RHOMBUS = 191
    CUSTOM_KEY_Ö = 192
    CUSTOM_KEY_ß = 219
    CUSTOM_KEY_EQUALS = 220
    CUSTOM_KEY_ACCENT = 221
    CUSTOM_KEY_Ä = 222
    CUSTOM_KEY_SIZECOMPARISON = 226
    
    CUSTOM_JOY_1 = 1000
    CUSTOM_JOY_2 = 1001
    CUSTOM_JOY_3 = 1002
    CUSTOM_JOY_4 = 1003
    CUSTOM_JOY_5 = 1004
    CUSTOM_JOY_6 = 1005
    CUSTOM_JOY_7 = 1006
    CUSTOM_JOY_8 = 1007
    CUSTOM_JOY_9 = 1008
    CUSTOM_JOY_10 = 1009
    CUSTOM_JOY_11 = 1010
    CUSTOM_JOY_12 = 1011
    CUSTOM_JOY_13 = 1012
    CUSTOM_JOY_14 = 1013
    CUSTOM_JOY_15 = 1014
    CUSTOM_JOY_16 = 1015
    CUSTOM_JOY_17 = 1016
    CUSTOM_JOY_18 = 1017
    CUSTOM_JOY_19 = 1018
    CUSTOM_JOY_20 = 1019
    CUSTOM_JOY_21 = 1020
    CUSTOM_JOY_22 = 1021
    CUSTOM_JOY_23 = 1022
    CUSTOM_JOY_24 = 1023
    CUSTOM_JOY_25 = 1024
    CUSTOM_JOY_26 = 1025
    CUSTOM_JOY_27 = 1026
    CUSTOM_JOY_28 = 1027
    CUSTOM_JOY_29 = 1028
    CUSTOM_JOY_30 = 1029
    CUSTOM_JOY_31 = 1030
    CUSTOM_JOY_32 = 1031
    CUSTOM_JOY_LEFT = 1032
    CUSTOM_JOY_UP = 1033
    CUSTOM_JOY_RIGHT = 1034
    CUSTOM_JOY_DOWN = 1035
End Enum

Public Enum EShipType                                       'Typ des Schiffes
    SHIP_TYPE_01 = 1
    SHIP_TYPE_02
    SHIP_TYPE_03
    SHIP_TYPE_04
    SHIP_TYPE_05
    SHIP_TYPE_06
End Enum

Public Enum ESpectatorMode                                  'Art des BeobachterModus
    SPECTATOR_MODE_TIGHT = 1
    SPECTATOR_MODE_FREE
End Enum

Public Enum EBotBehaviour                                   'Verhaltensweise eines Bots
    BOT_BEHAVIOUR_ONLYTARGET = 1
    BOT_BEHAVIOUR_AGGRESSIVE
    BOT_BEHAVIOUR_DEFENSIVE
End Enum

Public Enum EWeaponType                                     'WaffenTyp
    WEAPON_NAME_1 = 1
    WEAPON_NAME_2
    WEAPON_NAME_3
    WEAPON_NAME_4
    WEAPON_NAME_5
    WEAPON_NAME_6
    WEAPON_NAME_7
End Enum

Public Enum EShootType                                      'AbschussArt
    SHOOT_TYPE_STRAIGHT = 1
    SHOOT_TYPE_DOUBLE_STRAIGHT
    SHOOT_TYPE_TRIPLE_SLANT
    SHOOT_TYPE_OCT_SLANT
End Enum

Public Enum EHitType                                        'TrefferArt
    HIT_TYPE_WALL = 1
    HIT_TYPE_PLAYER
    HIT_TYPE_WARHEAD
End Enum

Public Enum EItemEvent                                      'Event der passiert wenn man ein Item einsammelt
    ITEM_EVENT_RANDOM = 1
    ITEM_EVENT_SHIELDS
    ITEM_EVENT_SPEEDBOMB
    ITEM_EVENT_SLOWMOTIONBOMB
    ITEM_EVENT_REVERSE_STEER
    ITEM_EVENT_DISABLE_COLLISION
    ITEM_EVENT_DESTRUCTION
        
    ITEM_EVENT_WEIGHT_DECREASE
    ITEM_EVENT_WEIGHT_INCREASE
    ITEM_EVENT_FIREDELAY_INCREASE
    ITEM_EVENT_DOUBLESPEED
End Enum

Public Enum EKillBoardMsgType
    KILLBOARD_KILL = 1
    KILLBOARD_CRASH
    KILLBOARD_SUICIDE
End Enum

Public Enum EAlphaEffect
    A_OFF = 1
    A_ADD
    A_MULTIPLY
    A_SUBTRACT
    A_INVERT
End Enum

'===Typendefinitionen===

Public Type TTimeEvent                                      'Zeit-Event
    StartTime                           As Long
    StartDelay                          As Long
    TimeOut                             As Long
End Type

Public Type TApp                                            'Spiel-Controller
    GameState                           As EGameState
    GameMode                            As EGameMode
    PlayerState                         As EPlayerState
    IsServer                            As Boolean
    SendDelay                           As Long
    SendEvent                           As TTimeEvent
    UsingJoyPad                         As Boolean
    NumJoyButtons                       As Long
    ResX                                As Integer
    ResY                                As Integer
    ColDepth                            As Integer
    ScreenRect                          As RECT
    VSync                               As Boolean
    ShowDevInfos                        As Boolean
    ShowFPS                             As Boolean
    GameSpeed                           As Single
    TargetGameSpeed                     As Single
    FPS                                 As Single
    AVF                                 As Single       'Durchschnittsgeschwindigkeitsfaktor
    AVFGS                               As Single       '-"- in Abhängigkeit von der Spielgeschwindigkeit
    AVSlowGS                            As Single       'Verlangsamungsfaktor in Abhängigkeit von der Spielgeschwindigkeit
    Path_Pics                           As String
    Path_Textures                       As String
    Path_Maps                           As String
    Path_TilePics                       As String
    Path_Sounds                         As String
    Path_ScreenShots                    As String
    Path_Data                           As String
    Path_Fonts                          As String
    DecimalSeparator                    As String
    CntScreenShots                      As Long
End Type

Public Type TPoint2D                                        '2D-Punkt
    X                                   As Long
    Y                                   As Long
End Type

Public Type TCollPoint                                      'Kollisions-Punkt
    X                                   As Long
    Y                                   As Long
    Col                                 As Long
End Type

Public Type TSurf                                           'Surface
    Surf                                As DirectDrawSurface7
    Width                               As Integer
    Height                              As Integer
End Type

Public Type TAnimation                                      'Animation
    NumFrames                           As Integer
    FrameWidth                          As Integer
    ActFrameSng                         As Single
    ActFrameInt                         As Integer
End Type

Public Type TFont                                           'Bitmap-Schrift
    Surf                                As TSurf
    Letter(32 To 255)                   As RECT
End Type

Public Type TMsg                                            'Blit-Positions-unabhängige Nachricht
    Text                                As String
    X                                   As Integer
    Y                                   As Integer
End Type

Public Type TRectSng                                        'Rectangle mit Single-Koordinaten
    Left                                As Single
    Top                                 As Single
    Right                               As Single
    Bottom                              As Single
End Type

Public Type TConsoleCompleter                               'merkt sich Eingaben
    Complete(1 To MAX_CONSOLE_COMPLETES)    As String
    ReadPos                                 As Integer
    WritePos                                As Integer
End Type

Public Type TConsole                                        'Spiel-Konsole
    Draw                                As Boolean
    Pos                                 As TRectSng
    TargetY                             As Single
    InfoLine(1 To MAX_CONSOLE_LINES)    As String
    InputLine                           As String
    ReadPos                             As Integer
    WritePos                            As Integer
    FirstLineLeft                       As Integer
    FirstLineTop                        As Integer
    InputLeft                           As Integer
    InputTop                            As Integer
    LineDist                            As Integer
    Speed                               As Single
    Completer                           As TConsoleCompleter
    Vertex(1 To 4)                      As D3DVERTEX
End Type

Public Type TMsgBoard                                       'MessageBoard
    Draw                                As Boolean
    X                                   As Integer
    Y                                   As Integer
    Info(1 To MAX_MSGBOARD_INFOS)       As String
    WritePos                            As Integer
    LineDist                            As Integer
    RefreshDelay                        As Long
    RefreshEvent                        As TTimeEvent
End Type

Public Type TMap                                            'Map
    MapName                             As String
    TileWidth(1 To NUM_MAP_PLAINS)      As Integer
    BlockWidth                          As Byte
    BlockHeight                         As Byte
    PixelWidth(1 To NUM_MAP_PLAINS)     As Long
    PixelHeight(1 To NUM_MAP_PLAINS)    As Long
    PlainNeed(1 To NUM_MAP_PLAINS)      As Boolean
    Plain_z(1 To NUM_MAP_PLAINS)        As Single
    SurfCount(1 To NUM_MAP_PLAINS)      As Long
    PlainFactorX(1 To NUM_MAP_PLAINS)   As Single
    PlainFactorY(1 To NUM_MAP_PLAINS)   As Single
    Wnd                                 As TRectSng
    Author                              As String * 20
    Description                         As String * 255
    RecPlayerCnt                        As String * 3
    BackCol                             As Long
    DrawStars                           As Boolean
    PinballFactor                       As Single
    GravX                               As Single
    GravY                               As Single
    Friction                            As Single
    NumRespawnPoints                    As Integer
    NumGravityPoints                    As Integer
    StarMoveX                           As Single
    StarMoveY                           As Single
    StarSpeedFactor(1 To NUM_STAR_PLAINS)   As Single
    NumStars(1 To NUM_STAR_PLAINS)      As Integer
    StarCol(1 To NUM_STAR_PLAINS)       As Long
    StarPlain_z(1 To NUM_STAR_PLAINS)   As Single
    ItemCnt                             As Integer
    NumItemRSPoints                     As Integer
    CreateItemEvent                     As TTimeEvent
    ItemTimerCnt                        As Integer
End Type

Public Type TMapTile                                        'MapTile
    VX                                  As Single
    VY                                  As Single
    Type                                As Long
End Type

Public Type TRespawnPoint                                   'Respawn-Point
    VX                                  As Long
    VY                                  As Long
    TeamID                              As Long
End Type

Public Type TGravityPoint                                   'Gravitations-Punkt
    VX                                  As Long
    VY                                  As Long
    InRadius                            As Long
    OutRadius                           As Long
    Mass                                As Single
    TeamID                              As Long
End Type

Public Type TBackStar                                       'HintergrundStern
    X                                   As Single
    Y                                   As Single
    Color                               As Long
    Speed                               As Single
End Type

Public Type TWeaponType                                     'Waffentyp mit Eigenschaften
    TypeName                            As String * 20
    Description                         As String * 255
    ShootType                           As EShootType
    SurfNum                             As Integer
    NumFrames                           As Integer
    SteerSpeed                          As Single
    Speed                               As Single
    AddShipSpeed                        As Boolean
    Power                               As Single
    FireDelay                           As Single
    Reloadable                          As Boolean
    ReloadSpeed                         As Single
    Consumption                         As Single
    LightColor                          As D3DCOLORVALUE
End Type

Public Type TWeapon                                         'Waffe
    Type                                As EWeaponType
    Munition                            As Single
    FireEvent                           As TTimeEvent
    ItemType                            As EItemEvent
End Type

Public Type TWarHead                                        'abgefeuerte Waffe
    Anim                                As TAnimation
    Draw                                As Boolean
    VX                                  As Single
    VY                                  As Single
    MovX                                As Single
    MovY                                As Single
    Type                                As EWeaponType
    SurfNum                             As Long
End Type

Public Type TShipType                                       'Schiffstyp mit Eigenschaften
    TypeName                            As String * 20
    Description                         As String * 255
    Acceleration                        As Single
    MaxSpeed                            As Single
    Weight                              As Single
    Shields                             As Single
    SteerSpeed                          As Single
    CannonGap                           As Single
End Type

Public Type TPlayer                                         'Spieler
    ID                                  As Long
    NetID                               As Long
    TeamID                              As Long
    IsBot                               As Boolean
    Anim                                As TAnimation
    Draw                                As Boolean
    Type                                As EShipType
    VX                                  As Single
    VY                                  As Single
    MidX                                As Single
    MidY                                As Single
    LastMidX                            As Single
    LastMidY                            As Single
    MoveX                               As Single
    MoveY                               As Single
    MaxSpeedF                           As Single
    AccelerationF                       As Single
    WeightF                             As Single
    SteerSpeedF                         As Single
    FireDelayF                          As Single
    ReloadSpeedF                        As Single
    WeaponDestructF                     As Single
    Shields                             As Single
    ActWeapon                           As Integer
    WeaponCnt                           As Integer
    Weapon(1 To NUM_WEAPON_SLOTS)       As TWeapon
    WarHeadCnt                          As Long
    WarHead(1 To NUM_WARHEADS_PER_PLAYER)   As TWarHead
    PlrName                             As String
    Frags                               As Long
    Deaths                              As Long
    StartTime                           As Long
    RecoverEvent                        As TTimeEvent
    CollStatus                          As Boolean
    Accelerating                        As Boolean
End Type

Public Type TBotWay                                         'Weg für Bot
    TargType                            As Long
    TargX                               As Single
    TargY                               As Single
    ActWayPoint                         As Long
    NumWayPoints                        As Long
    WayPointX(1 To MAX_BOT_WAY_POINTS)  As Single
    WayPointY(1 To MAX_BOT_WAY_POINTS)  As Single
End Type

Public Type TSpectator                                      'Beobachter
    SpectatorMode                       As ESpectatorMode
    Speed                               As Single
    CurrentPlayer                       As Long
    Wait                                As Boolean
    ShowMapDesc                         As Boolean
    ShowMode                            As Boolean
    WaitEvent                           As TTimeEvent
    ShowMapDescEvent                    As TTimeEvent
    ShowModeEvent                       As TTimeEvent
End Type

Public Type TRadar                                          'Radar
    Draw                                As Boolean
    PosRect                             As RECT
    X                                   As Integer
    Y                                   As Integer
    CameraX                             As Single
    CameraY                             As Single
    Width                               As Integer
    Height                              As Integer
    Wnd                                 As TRectSng
    BlockWidth                          As Integer
    BlockHeight                         As Integer
    PixWidth                            As Long
    PixHeight                           As Long
    StretchFX                           As Single
    StretchFY                           As Single
    Vertex(1 To 4)                      As D3DVERTEX
End Type

Public Type TItemRSPoint                                    'ItemPunkt
    X                                   As Long
    Y                                   As Long
    Reserved                            As Boolean
End Type

Public Type TItem                                           'Item
    Anim                                As TAnimation
    VX                                  As Long
    VY                                  As Long
    Type                                As EItemEvent
    DurationEvent                       As TTimeEvent
    RSPointID                           As Long
End Type

Public Type TItemTimer                                      'ItemTimer
    DurationEvent                       As TTimeEvent
    Type                                As EItemEvent
    PlrID                               As Long
End Type

Public Type TScoreBoardEntry                                'ScoreBoard-Eintrag
    PlrName                             As String
    Skill                               As Single
    Frags                               As Long
    Deaths                              As Long
End Type

Public Type TScoreBoard                                     'ScoreBoard
    Draw                                As Boolean
    PosRect                             As RECT
    ReadPos                             As Integer
    Entry(1 To MAX_PLAYERS)             As TScoreBoardEntry
    RefreshEvent                        As TTimeEvent
    Vertex(1 To 4)                      As D3DVERTEX
End Type

Public Type TKillBoardMsg
    Info(1 To 2)                        As String
    Type                                As EKillBoardMsgType
    WeaponSurfID                        As Integer
End Type

Public Type TKillBoard                                      'KillBoard
    Draw                                As Boolean
    Top                                 As Integer
    Right                               As Integer
    WritePos                            As Integer
    Info(1 To NUM_KILLBOARD_MSGS)       As TKillBoardMsg
    RefreshEvent                        As TTimeEvent
End Type

Public Type TTeam
    Color                               As D3DCOLORVALUE
End Type

Public Type TD3DPicture
    Width                               As Long
    Height                              As Long
    X                                   As Long
    Y                                   As Long
    Vertex(1 To 4)                      As D3DVERTEX
    Tex                                 As DirectDrawSurface7
End Type

Public Type THUDDisp
    Pic                                 As TSurf
    X                                   As Long
    Y                                   As Long
    iRect                               As RECT
End Type

Public Type THUD
    Color                               As D3DCOLORVALUE
    Draw                                As Boolean
    
    Pic(1 To 7)                         As TD3DPicture
    SpeedDisp                           As THUDDisp
    ShieldDisp                          As THUDDisp
    DrawTargeting                       As Boolean
End Type
