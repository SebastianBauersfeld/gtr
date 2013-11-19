Attribute VB_Name = "m_002_VAR_01"
Option Explicit

'===Anwendung===

Public g_App                            As TApp                 'SpielController


'===DX===

Public g_DX                             As DirectX7             'DirectX-Objekt


'===DD===

Public g_DD                             As DirectDraw7          'DirectDraw-Objekt
Public g_FrontBuf                       As DirectDrawSurface7   'FrontBuffer
Public g_BackBuf                        As DirectDrawSurface7   'BackBuffer
Public g_EmptyRect                      As RECT                 'leeres Rectangle
Public g_EmptySurfDesc                  As DDSURFACEDESC2       'leere Surface-Description
Public g_DDI                            As DirectDrawIdentifier


'===D3D===

Public g_D3D                            As Direct3D7            'D3D-Objekt
Public g_D3DDev                         As Direct3DDevice7      'D3D-Device
Public g_RectViewport(0)                As D3DRECT              'Viewport
Public g_matProj                        As D3DMATRIX            'Projektionsmatrix
Public g_matView                        As D3DMATRIX            'ViewMatrix
Public g_ZBuf                           As DirectDrawSurface7   'Z-Buffer
Public g_Material                       As D3DMATERIAL7         'Materialeffekte
Public g_D3DDivX                        As Single
Public g_D3DDivY                        As Single
Public g_D3DSubX                        As Single
Public g_D3DSubY                        As Single


'===Input===

Public g_DI                             As DirectInput          'DirectInput-Objekt
Public g_DIEventHdl                     As Long

Public g_MouseX                         As Integer
Public g_MouseY                         As Integer
Public g_JoyButton(0 To 35)             As Boolean              'Joypad
Public g_KeyButton(0 To 255)            As Boolean              'Tastatur

Public g_Key_Left                       As ECustomKeys
Public g_Key_Accelerate                 As ECustomKeys
Public g_Key_Right                      As ECustomKeys
Public g_Key_Fire                       As ECustomKeys
Public g_Key_NextWeapon                 As ECustomKeys
Public g_Key_PreviousWeapon             As ECustomKeys
Public g_Key_Weapon1                    As ECustomKeys
Public g_Key_Weapon2                    As ECustomKeys
Public g_Key_Weapon3                    As ECustomKeys
Public g_Key_Recover                    As ECustomKeys
Public g_Key_Chat                       As ECustomKeys
Public g_Key_TeamChat                   As ECustomKeys
Public g_Key_ToggleTarget               As ECustomKeys
Public g_Key_ScoreBoard                 As ECustomKeys
Public g_Key_Screenshot                 As ECustomKeys


'===DS===

Public g_DS                             As DirectSound          'DirectSound-Objekt


'===Konsole===

Public g_Console                        As TConsole             'Konsole
Public g_MsgBoard                       As TMsgBoard            'MessageBoard


'===ScoreBoard

Public g_ScoreBoard                     As TScoreBoard          'ScoreBoard


'===Fonts===

Public g_TextFont(1 To 3)               As TFont                'Schriftart für normale Textausgabe


'===Map===

Public g_Map                                                                    As TMap
Public g_MapTileSurf(1 To NUM_MAP_PLAINS, 1 To MAX_MAPTILE_SURFS)               As TSurf
Public g_MapTile(1 To NUM_MAP_PLAINS, 1 To MAX_X_MAPTILES, 1 To MAX_Y_MAPTILES) As TMapTile
Public g_RespawnPoint(1 To MAX_RESPAWN_POINTS)                                  As TRespawnPoint
Public g_GravPoint(1 To MAX_GRAVITY_POINTS)                                     As TGravityPoint
Public g_BackStar(1 To NUM_STAR_PLAINS, 1 To MAX_STARS_PER_PLAIN)               As TBackStar
Public g_Item(1 To MAX_ITEMS)                                                   As TItem
Public g_ItemRSPoint(1 To MAX_ITEM_RS_POINTS)                                   As TItemRSPoint
Public g_ItemSurf(1 To NUM_ITEM_TYPES)                                          As TSurf
Public g_ItemTimer(1 To MAX_ITEM_TIMERS)                                        As TItemTimer


'===Player===

Public g_Spectator                          As TSpectator
Public g_ShipSurf(1 To NUM_SHIP_TYPES)      As TSurf
Public g_ShipType(1 To NUM_SHIP_TYPES)      As TShipType
Public g_Plr(1 To MAX_PLAYERS)              As TPlayer
Public g_PlrCnt                             As Long             'aktuelle SpielerZahl
Public g_MyPlrID                            As Long             'eigene Spieler-ID
Public g_ShipFrameSin(1 To NUM_SHIP_FRAMES) As Single
Public g_ShipFrameCos(1 To NUM_SHIP_FRAMES) As Single

Public g_BotWay(1 To MAX_PLAYERS)                               As TBotWay
Public g_CreatePointX(1 To MAX_BOT_CREATE_POINTS)               As Long
Public g_CreatePointY(1 To MAX_BOT_CREATE_POINTS)               As Long
Public g_SearchPointX(1 To MAX_X_MAPTILES, 1 To MAX_Y_MAPTILES) As Long
Public g_SearchPointY(1 To MAX_X_MAPTILES, 1 To MAX_Y_MAPTILES) As Long
Public g_Team(0 To 4)                                           As TTeam


'===KollisionsAbfrage===

Public g_CollSetHD(1 To NUM_SHIP_FRAMES, 1 To NUM_HD_COLL_POINTS)                       As TCollPoint
Public g_CollSetLD(1 To NUM_SHIP_TYPES, 1 To NUM_SHIP_FRAMES, 1 To NUM_LD_COLL_POINTS)  As TPoint2D
Public g_WarHeadCollSet(1 To NUM_WEAPON_SURFS)                                          As TPoint2D


'===Waffen===

Public g_WeaponSurf(1 To NUM_WEAPON_SURFS)  As TSurf
Public g_WeaponType(1 To NUM_WEAPON_TYPES)  As TWeaponType


'===HUD===

Public g_Radar                                                      As TRadar
Public g_RadarCameraSurf                                            As TSurf
Public g_RadarEnemySurf                                             As TSurf
Public g_RadarFriendSurf                                            As TSurf
Public g_RadarItemSurf                                              As TSurf
Public g_RadarMapTileSurf(1 To MAX_MAPTILE_SURFS)                   As TSurf
Public g_RadarMapTile(1 To MAX_X_MAPTILES, 1 To MAX_Y_MAPTILES)     As TMapTile
Public g_KillBoard                                                  As TKillBoard
Public g_KillBoardWeaponSurf(1 To NUM_WEAPON_SURFS)                 As TSurf
Public g_KillBoardSkullSurf                                         As TSurf
Public g_KillBoardCrashSurf                                         As TSurf
Public g_HUD                                                        As THUD
