Attribute VB_Name = "m_020_NETWORK_01"
Option Explicit

'===Konstanten===

Private Const GAME_GUID                 As String = "{8EC1E2EC-5266-11D4-811C-AD15B9B82C76}"
Public Const SYS_MSG                    As Long = 0
Public Const CREATE_PLAYER_MSG          As Long = 3
Public Const DESTROY_PLAYER_MSG         As Long = 5
Public Const MIGRATE_HOST_MSG           As Long = 257
Public Const TO_ALL_PLAYERS             As Long = 0

Private Const CHAT_MSG                  As Long = 1
Private Const PACKET_MSG                As Long = 2
Private Const FIRE_MSG                  As Long = 3
Private Const DESTRUCTION_MSG           As Long = 4
Private Const ITEMS_MSG                 As Long = 5
Private Const ITEM_COLLECT_MSG          As Long = 6
Private Const FIRE_ITEM_MSG             As Long = 7
Private Const RECOVER_MSG               As Long = 8
Private Const COLLISION_MSG             As Long = 9


'===Typen===

Private Type TNetWorkGame
    GameName                            As String
    MaxPlayers                          As Long
    CurrentPlayers                      As Long
End Type

Public Type TNetWorkGameList
    Count                               As Long
    Game()                              As TNetWorkGame
End Type

Private Type TNetPlayer
    Friendly                            As String
    Formal                              As String
    ID                                  As Long
End Type

Public Type TNetPlayerList
    Count                               As Long
    Player()                            As TNetPlayer
End Type


'===öffentliche Variablen===

Public g_DP                             As DirectPlay4
Private DPLobby                         As DirectPlayLobby3
Private DPAddress                       As DirectPlayAddress
Private AvailableSessions               As DirectPlayEnumSessions
Private DPPls                           As DirectPlayEnumPlayers

'initialisiert DP
Public Sub Init_DP(ByVal IP As String, ByVal Port As Long)

    Set g_DP = g_DX.DirectPlayCreate("")
    Set DPLobby = g_DX.DirectPlayLobbyCreate()
    
    Set DPAddress = DPLobby.CreateINetAddress(IP, Port)
    g_DP.InitializeConnection DPAddress

End Sub

'fährt DP herunter
Public Sub Unload_DP()
    
    Set DPLobby = Nothing
    Set g_DP = Nothing

End Sub

'Liste mit aktuellen Spielen anzeigen
Public Function GetAvailableGames() As TNetWorkGameList
    
    Dim hSession        As DirectPlaySessionData
    Dim n               As Long
    
    Set hSession = g_DP.CreateSessionData()
    hSession.SetGuidApplication GAME_GUID
    Set AvailableSessions = g_DP.GetDPEnumSessions(hSession, 0, DPENUMSESSIONS_ALL)
    
    With GetAvailableGames
        
        .Count = AvailableSessions.GetCount()
        If .Count > 0 Then ReDim .Game(1 To .Count)
        
        For n = 1 To .Count
            With .Game(n)
                .GameName = AvailableSessions.GetItem(n).GetSessionName
                .MaxPlayers = AvailableSessions.GetItem(n).GetMaxPlayers
                .CurrentPlayers = AvailableSessions.GetItem(n).GetCurrentPlayers
            End With
        Next
        
    End With
    
End Function

'Spiel erstellen
Public Sub Create_Session(ByVal SessionName As String, ByVal NumPlayers As Integer)

    Dim GameSession     As DirectPlaySessionData
    
    Set GameSession = g_DP.CreateSessionData()
    
    With GameSession
        .SetGuidApplication GAME_GUID
        .SetMaxPlayers NumPlayers
        .SetSessionName SessionName
        .SetFlags DPSESSION_DIRECTPLAYPROTOCOL Or DPSESSION_MIGRATEHOST
    End With
    
    'Session erstellen
    g_DP.Open GameSession, DPOPEN_CREATE
    
End Sub

'Einem Spiel beitreten
Public Function Join_Session(ByVal Index As Long) As Boolean
    
    Dim GameSession     As DirectPlaySessionData
    
    'Hier wird bestimmt welcher Session man sich anschließt
    Set GameSession = AvailableSessions.GetItem(Index)
    
    If GameSession.GetMaxPlayers < GameSession.GetCurrentPlayers + 1 Then GoTo error:
    
    GameSession.SetGuidApplication GAME_GUID 'Das Spiel benutzt den erstellten GUID
    
    'Session öffnen und eintreten
    g_DP.Open GameSession, DPOPEN_JOIN
    
    Join_Session = True
    Exit Function

error:
    Join_Session = False
    
End Function

'erstellt einen lokalen Player und gibt seine neue ID zurück
Public Function Create_Lan_Player(ByVal Friendly As String, ByVal Formal As String) As Long
    
    Create_Lan_Player = g_DP.CreatePlayer(Friendly, Formal, 0, 0)

End Function

'entfernt einen lokalen Player
Public Sub Destroy_Lan_Player(ByVal ID As Long)
    
    g_DP.DestroyPlayer ID
    
End Sub

'Nachricht initialisieren
Public Sub Init_Msg(ByRef msg As DirectPlayMessage)
    
    Set msg = g_DP.CreateMessage
    
End Sub

'Nachricht senden
Public Sub Send_Msg(ByVal FromID As Long, ByVal TargetID As Long, ByVal msg As DirectPlayMessage)
    
    On Error Resume Next
    g_DP.Send FromID, TargetID, DPSEND_NOSENDCOMPLETEMSG, msg

End Sub

'liefert eine Liste mit den Mitspielern
Public Function GetPlayerList() As TNetPlayerList

    Dim n As Long
    
    Set DPPls = g_DP.GetDPEnumPlayers(GAME_GUID, DPENUMPLAYERS_GROUP)
    
    With GetPlayerList
        .Count = DPPls.GetCount
        If .Count > 0 Then ReDim .Player(1 To .Count)
        
        For n = 1 To .Count
            With .Player(n)
                .Formal = DPPls.GetLongName(n)
                .Friendly = DPPls.GetShortName(n)
                .ID = DPPls.GetDPID(n)
            End With
        Next
    End With

End Function

'Nachrichten abrufen und eventuell NachrichtenEvents auslösen
Public Sub Receive_Msgs(ByVal PlayerID As Long)
    
    Dim SourceID                As Long
    Dim TargetID                As Long
    Dim msg                     As DirectPlayMessage
    Dim n                       As Long
    
    For n = 1 To g_DP.GetMessageCount(PlayerID)
        
        Set msg = g_DP.Receive(SourceID, PlayerID, DPRECEIVE_TOPLAYER)
        
        'Informationen verarbeiten
        Got_Msg msg, PlayerID, SourceID
        
    Next n
    
End Sub

'NachrichtenEvent
Private Sub Got_Msg(ByRef msg As DirectPlayMessage, ByVal ToID As Long, ByVal FromID As Long)
    
    Dim FIndex          As Long
    Dim TIndex          As Long
    Dim MsgT            As Long
    Dim hID             As Long
    Dim hIndex          As Long
    Dim n               As Long
    
    FIndex = Get_PlayerIndex(FromID)
    TIndex = Get_PlayerIndex(ToID)
    MsgT = msg.ReadLong
    
    'SystemNachrichten (nur für den Hauptspieler zugängig)
    If FromID = SYS_MSG Then
        If TIndex = g_MyPlrID Then
            Select Case MsgT
                Case CREATE_PLAYER_MSG:     'Spieler tritt Spiel bei
                    msg.ReadLong
                    hID = msg.ReadLong
                    If Get_PlayerIndex(hID) = 0 Then Add_NetPlayer Get_PlayerName(hID), hID, False, 1, 1
                
                Case DESTROY_PLAYER_MSG:    'Spieler verlässt Spiel
                    msg.ReadLong
                    hID = msg.ReadLong
                    If Get_PlayerIndex(hID) > 0 Then Remove_Player g_Plr(Get_PlayerIndex(hID))
                
                Case MIGRATE_HOST_MSG:      'Host verlässt das Spiel und ich übernehme den Host
                    g_App.IsServer = True
            End Select
        End If
    
    ElseIf FIndex = 0 Then
        
        Exit Sub
    
    'Nachrichten von anderen Spielern (nicht von lokalen)
    ElseIf Not ((FIndex = g_MyPlrID) Or g_Plr(FIndex).IsBot) Then
        
        If TIndex = g_MyPlrID Then      'für Hauptspieler
        
            Select Case MsgT
                Case PACKET_MSG:                            'Positionsübermittlung
                    With g_Plr(FIndex)
                        .Draw = CBool(msg.ReadShort)
                        .Type = msg.ReadByte
                        .TeamID = msg.ReadByte
                        .VX = msg.ReadSingle
                        .VY = msg.ReadSingle
                        .MoveX = msg.ReadSingle
                        .MoveY = msg.ReadSingle
                        SetAnimationFrame .Anim, msg.ReadSingle
                        .Shields = msg.ReadSingle
                        .Frags = msg.ReadLong
                        .Deaths = msg.ReadLong
                        .StartTime = g_DX.TickCount() - msg.ReadLong
                        .Accelerating = CBool(msg.ReadByte)
                    End With
                    
                Case CHAT_MSG:                              'ChatNachricht
                
                Case FIRE_MSG:                              'jemand hat geschossen
                    With g_Plr(FIndex)
                        .ActWeapon = msg.ReadShort
                        .Weapon(.ActWeapon).Type = msg.ReadShort
                        .WeaponDestructF = msg.ReadSingle
                        Fire_Weapon g_Plr(FIndex)
                    End With
                    
                Case DESTRUCTION_MSG:                       'jemand ist gestorben
                    Dim Kind As Byte
                    
                    Destroy_Player g_Plr(FIndex)
                    
                    Kind = msg.ReadByte
                    
                    If Kind = KILLBOARD_SUICIDE Then
                        Add_KillBoard_Msg KILLBOARD_SUICIDE, g_Plr(FIndex).PlrName
                    ElseIf Kind = KILLBOARD_KILL Then
                        hIndex = Get_PlayerIndex(msg.ReadLong)
                        g_Plr(hIndex).Frags = g_Plr(hIndex).Frags + 1
                        Add_KillBoard_Msg KILLBOARD_KILL, g_Plr(hIndex).PlrName, g_Plr(FIndex).PlrName, msg.ReadByte
                    End If
                    
                Case ITEMS_MSG:
                    g_Map.ItemCnt = msg.ReadLong
                    
                    For n = 1 To g_Map.ItemCnt
                        With g_Item(n)
                            .Type = msg.ReadByte
                            .VX = msg.ReadLong
                            .VY = msg.ReadLong
                        End With
                    Next
                                                                        
                Case FIRE_ITEM_MSG:
                    With g_Plr(FIndex)
                        .ActWeapon = msg.ReadShort
                        .Weapon(.ActWeapon).ItemType = msg.ReadShort
                        Activate_Item g_Plr(FIndex), .Weapon(.ActWeapon).ItemType
                    End With
                                                                        
                Case ITEM_COLLECT_MSG:
                    Collect_Item g_Plr(TIndex), msg.ReadShort, msg.ReadLong
                
                Case RECOVER_MSG:
                    Recover_Player g_Plr(FIndex), False, msg.ReadSingle, msg.ReadSingle
                    
                Case COLLISION_MSG:
                    DestroyMap CLng(g_Plr(FIndex).MidX), CLng(g_Plr(FIndex).MidY), BIG
                    AddWallPuff msg.ReadLong, msg.ReadLong
                                
            End Select
        
        Else                'für andere Spieler
            
            Select Case MsgT
                        
                Case ITEM_COLLECT_MSG:
                    Collect_Item g_Plr(TIndex), msg.ReadShort, msg.ReadLong
                
            End Select

        End If
        
    End If
    
End Sub

'man übergibt NetID und bekommt Namen
Public Function Get_PlayerName(ByVal NetID As Long) As String
    
    Dim PlayerList          As TNetPlayerList
    Dim n                   As Long
    
    PlayerList = GetPlayerList()
    
    For n = 1 To PlayerList.Count
        If NetID = PlayerList.Player(n).ID Then
            Get_PlayerName = PlayerList.Player(n).Friendly
            Exit Function
        End If
    Next
    
    Get_PlayerName = "NoName"
    
End Function

'man übergibt NetID und bekommt Index im Array
Public Function Get_PlayerIndex(ByVal NetID As Long) As Long
    
    Dim n       As Long
    
    For n = 1 To g_PlrCnt
        If g_Plr(n).NetID = NetID Then
            Get_PlayerIndex = n
            Exit Function
        End If
    Next
    
    Get_PlayerIndex = 0
    
End Function

'fügt Netzwerkspieler hinzu
Public Function Add_NetPlayer(ByVal Name As String, ByVal NetID As Long, ByVal Bot As Boolean, ByVal ShipType As Byte, ByVal TeamID As Byte) As Boolean
    
    If Add_Player(ShipType, Name, TeamID) Then
        g_Plr(g_PlrCnt).NetID = NetID
        If Bot Then Init_Bot g_Plr(g_PlrCnt)
        Add_NetPlayer = True
    Else
        Add_NetPlayer = False
    End If
    
End Function

'entfernt einen NetzwerkBot
Public Sub Remove_NetBot(ByVal Index As Long)
    
    Destroy_Lan_Player g_Plr(Index).NetID
    Remove_Player g_Plr(Index)
    
End Sub

'fügt alle Netzwerkspieler hinzu
Public Sub Add_NetPlayers()
    
    Dim PlayerList          As TNetPlayerList
    Dim n                   As Long
    
    g_PlrCnt = 0
    
    If g_App.IsServer Then
        g_MyPlrID = 1
        Add_NetPlayer Trim(GetINIValue(App.Path & "\config.ini", "Player", "Name")), Create_Lan_Player(Trim(GetINIValue(App.Path & "\config.ini", "Player", "Name")), Trim(GetINIValue(App.Path & "\config.ini", "Player", "Name")) & "1"), False, GetINIValue(App.Path & "\config.ini", "Player", "Ship"), GetINIValue(App.Path & "\config.ini", "Player", "Team")
                
    Else
        PlayerList = GetPlayerList()
        
        For n = 1 To PlayerList.Count
            Add_NetPlayer PlayerList.Player(n).Friendly, PlayerList.Player(n).ID, False, 1, 1
        Next
        
        g_MyPlrID = PlayerList.Count + 1
        Add_NetPlayer Trim(GetINIValue(App.Path & "\config.ini", "Player", "Name")), Create_Lan_Player(Trim(GetINIValue(App.Path & "\config.ini", "Player", "Name")), Trim(GetINIValue(App.Path & "\config.ini", "Player", "Name")) & "1"), False, GetINIValue(App.Path & "\config.ini", "Player", "Ship"), GetINIValue(App.Path & "\config.ini", "Player", "Team")
    End If
    
End Sub

'Spielepakete senden
Public Sub Send_GameData()

    Dim n           As Long
    Dim msg         As DirectPlayMessage
    
    If GetEventStatus(g_App.SendEvent) Then
        
        If g_App.IsServer Then
            For n = 1 To g_PlrCnt
                If n = g_MyPlrID Or g_Plr(n).IsBot Then
                    Send_PlayerData g_Plr(n)
                End If
            Next
            
            Send_ItemInfos
        Else
            Send_PlayerData g_Plr(g_MyPlrID)
        End If
        
        SetEvent g_App.SendEvent, g_App.SendDelay
    End If
    
End Sub

'andere Spieler interpolieren
Public Sub Interpolate_Players()
    
    Dim n       As Long
    
    For n = 1 To g_PlrCnt
        If Not (n = g_MyPlrID) And Not g_Plr(n).IsBot Then Move_Player g_Plr(n)
    Next
    
End Sub

'sendet Spielerpos etc.
Public Sub Send_PlayerData(ByRef Plr As TPlayer)
    
    Dim msg         As DirectPlayMessage
    
    Init_Msg msg
    
    With msg
        .WriteLong PACKET_MSG
        
        .WriteShort CInt(Plr.Draw)
        .WriteByte Plr.Type
        .WriteByte Plr.TeamID
        .WriteSingle Plr.VX
        .WriteSingle Plr.VY
        .WriteSingle Plr.MoveX
        .WriteSingle Plr.MoveY
        .WriteSingle Plr.Anim.ActFrameSng
        .WriteSingle Plr.Shields
        .WriteLong Plr.Frags
        .WriteLong Plr.Deaths
        .WriteLong g_DX.TickCount() - Plr.StartTime
        .WriteByte CByte(Plr.Accelerating)
    End With
    
    Send_Msg Plr.NetID, TO_ALL_PLAYERS, msg
    
End Sub

'sendet das ein Spieler schießt
Public Sub Send_PlayerFire(ByRef Plr As TPlayer)
    
    Dim msg         As DirectPlayMessage
    
    Init_Msg msg
    
    With msg
        .WriteLong FIRE_MSG
        
        .WriteShort Plr.ActWeapon
        .WriteShort Plr.Weapon(Plr.ActWeapon).Type
        .WriteSingle Plr.WeaponDestructF
    End With
    
    Send_Msg Plr.NetID, TO_ALL_PLAYERS, msg
    
End Sub

'sendet an jemanden, dass er ein Item eingesammelt hat
Public Sub Send_ItemCollect(ByRef Plr As TPlayer, ByVal ItemID As Integer, ByVal ItemNumber As Long)
    
    Dim msg             As DirectPlayMessage
    
    Init_Msg msg
    
    With msg
        .WriteLong ITEM_COLLECT_MSG
        .WriteShort ItemID
        .WriteLong ItemNumber
    End With
    
    Send_Msg g_Plr(g_MyPlrID).NetID, Plr.NetID, msg
    
End Sub

'sendet das ein Spieler Item schießt
Public Sub Send_PlayerItemFire(ByRef Plr As TPlayer)
    
    Dim msg         As DirectPlayMessage
    
    Init_Msg msg
    
    With msg
        .WriteLong FIRE_ITEM_MSG
        
        .WriteShort Plr.ActWeapon
        .WriteShort Plr.Weapon(Plr.ActWeapon).ItemType
    End With
    
    Send_Msg Plr.NetID, TO_ALL_PLAYERS, msg
    
End Sub

'ItemInfos senden
Public Sub Send_ItemInfos()
    
    Dim n               As Long
    Dim msg             As DirectPlayMessage
    
    Init_Msg msg
    
    With msg
        .WriteLong ITEMS_MSG
        
        .WriteLong g_Map.ItemCnt
        
        For n = 1 To g_Map.ItemCnt
            .WriteByte g_Item(n).Type
            .WriteLong g_Item(n).VX
            .WriteLong g_Item(n).VY
        Next n
    End With
    
    Send_Msg g_Plr(g_MyPlrID).NetID, TO_ALL_PLAYERS, msg
    
End Sub

'sendet das ein Spieler zerstört wurde
Public Sub Send_PlayerDestruction(ByVal Kind As EKillBoardMsgType, ByRef Plr1 As TPlayer, Optional ByVal Plr2ID As Long, Optional ByVal WeaponType As Byte)

    Dim msg         As DirectPlayMessage
    
    Init_Msg msg
    
    With msg
        .WriteLong DESTRUCTION_MSG
        
        .WriteByte Kind
        
        If Kind = KILLBOARD_KILL Then
            .WriteLong g_Plr(Plr2ID).NetID
            .WriteByte WeaponType
        End If
    End With
    
    Send_Msg Plr1.NetID, TO_ALL_PLAYERS, msg

End Sub

'sendet das sich jemand recovered hat
Public Sub Send_Recover(ByRef Plr As TPlayer)
    
    Dim msg         As DirectPlayMessage
    
    Init_Msg msg
    
    msg.WriteLong RECOVER_MSG
    msg.WriteSingle Plr.VX
    msg.WriteSingle Plr.VY
        
    Send_Msg Plr.NetID, TO_ALL_PLAYERS, msg
    
End Sub

'sendet das Mauerkollision stattfand
Public Sub Send_WallCollision(ByRef Plr As TPlayer, ByVal X As Long, ByVal Y As Long)

    Dim msg         As DirectPlayMessage
    
    Init_Msg msg
    
    With msg
        .WriteLong COLLISION_MSG
        .WriteLong X
        .WriteLong Y
    End With
        
    Send_Msg Plr.NetID, TO_ALL_PLAYERS, msg

End Sub

'Alle spieler löschen
Public Sub Destroy_NetPlayers()
    
    Dim n       As Long
    
    For n = 1 To g_PlrCnt
        If g_Plr(n).ID = g_MyPlrID Or g_Plr(n).IsBot Then Destroy_Lan_Player g_Plr(n).NetID
    Next
    
End Sub
