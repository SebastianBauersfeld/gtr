Attribute VB_Name = "mnu_m10_Multiplayer"
Option Explicit

Const RAS_MAXENTRYNAME = 256
Const RAS_MAXDEVICETYPE = 16
Const RAS_MAXDEVICENAME = 128
Const RAS_RASCONNSIZE = 412
Private Type RasConn
    dwSize As Long
    hRasConn As Long
    szEntryName(RAS_MAXENTRYNAME) As Byte
    szDeviceType(RAS_MAXDEVICETYPE) As Byte
    szDeviceName(RAS_MAXDEVICENAME) As Byte
End Type

Public lpRasConn(255) As RasConn

Private Declare Function RasEnumConnections Lib "rasapi32.dll" Alias "RasEnumConnectionsA" (lpRasConn As Any, lpcb As Long, lpcConnections As Long) As Long
Private Declare Function RasHangUp Lib "rasapi32.dll" Alias "RasHangUpA" (ByVal hRasConn As Long) As Long

Public Sub subDrawMultiplayerMenu()
    Dim PosX As Integer
    Dim PosY As Integer

    With SubMenu
    
        subDrawHudText 900, .DDLine(0, 1) + 12, "Multiplayer", 3
              
        BackBuffer.DrawLine .DDLine(0, 0) - 137, .DDLine(0, 1), .DDLine(0, 0) - 137, .DDLine(0, 1) + 50
        BackBuffer.DrawLine .DDLine(0, 0), .DDLine(0, 1) + 50, .DDLine(0, 0) - 137, .DDLine(0, 1) + 50
        
        
        If .MenuStatus = S_Default Then
        
            BackBuffer.DrawLine .DDLine(1, 0), .DDLine(0, 1) + 22, .DDLine(0, 0) - 137, .DDLine(0, 1) + 22
            BackBuffer.DrawLine .DDLine(1, 0) - 7, .DDLine(0, 1) + 25, .DDLine(0, 0) - 137, .DDLine(0, 1) + 25
        
            PosX = -100
            PosY = -40
        
            BackBuffer.DrawBox PosX + 540, PosY + 385, PosX + 810, PosY + 580
            
            subDrawHudText PosX + 600, PosY + 400, "LAN", 2
                
            subDrawButton PosX + 600, PosY + 430, "Join", Event_Join
            
            subDrawButton PosX + 670, PosY + 430, "Create", Event_Create
            
            
            BackBuffer.DrawLine PosX + 550, PosY + 480, PosX + 800, PosY + 480
            BackBuffer.DrawLine PosX + 550, PosY + 482, PosX + 800, PosY + 482
                    
            
            subDrawHudText PosX + 600, PosY + 500, "NET", 2
            
            subDrawButton PosX + 600, PosY + 530, "Join", Event_JoinINet
           
            subDrawButton PosX + 670, PosY + 530, "Create", Event_CreateINet
            
            
            subDrawButton 960, 740, "Back", Event_BackToMenu
            
        ElseIf .MenuStatus = S_Join Then
        
            BackBuffer.DrawLine .DDLine(1, 0), .DDLine(0, 1) + 22, 340, .DDLine(0, 1) + 22
            BackBuffer.DrawLine .DDLine(1, 0) - 7, .DDLine(0, 1) + 25, 340, .DDLine(0, 1) + 25
            BackBuffer.DrawLine 488, .DDLine(0, 1) + 22, .DDLine(0, 0) - 137, .DDLine(0, 1) + 22
            BackBuffer.DrawLine 488, .DDLine(0, 1) + 25, .DDLine(0, 0) - 137, .DDLine(0, 1) + 25
            BackBuffer.DrawLine 340, .DDLine(0, 1), 340, .DDLine(0, 1) + 25
            BackBuffer.DrawLine 488, .DDLine(0, 1), 488, .DDLine(0, 1) + 25
        
            
            subDrawHudText 300, 190, "Your IP: " & WS.LocalIP, 2
            
            subDrawHudText 300, 210, "BroadCast:", 2
            
            With BroadCastTextBox
                subDrawTextBox 300, 230, 280, .Text, .InUse, .Blink
            End With
            
            If IsOnline Then
                
                BackBuffer.SetForeColor &HFF
                BackBuffer.DrawBox 200, 260, 770, 325
            
                subDrawHudText 210, 265, "CAUTION! You are attempting to join a LAN-Game and simultaneously", 2
                subDrawHudText 210, 285, "runs an internet connection.", 2
                subDrawHudText 210, 305, "This may cause that you can't find any Sessions.", 2
            
                subDrawButton 630, 295, "Ignore", Event_IgnoreINet
                subDrawButton 690, 295, "Hang up", Event_CutINetCon
            
            End If
            
            subDrawServerList 110, 360, 15, "Server Choice", ServerListBox
    
            If Not IsOnline Then
                subDrawButton 300, 740, "Refresh List", Event_RefreshMulti
            End If
            
            '###############################################################################
            If ServerListBox.ListCount > 0 Then subDrawButton 450, 740, "Join Server", Event_JoinServer
            '###############################################################################
    
            subDrawButton 960, 740, "Back", Event_BackToMulti
            
            subDrawHudText 350, .DDLine(0, 1) + 3, "Join LAN Server", 2
            
        ElseIf .MenuStatus = S_Create Then
        
            BackBuffer.DrawLine .DDLine(1, 0), .DDLine(0, 1) + 22, 340, .DDLine(0, 1) + 22
            BackBuffer.DrawLine .DDLine(1, 0) - 7, .DDLine(0, 1) + 25, 340, .DDLine(0, 1) + 25
            BackBuffer.DrawLine 498, .DDLine(0, 1) + 22, .DDLine(0, 0) - 137, .DDLine(0, 1) + 22
            BackBuffer.DrawLine 498, .DDLine(0, 1) + 25, .DDLine(0, 0) - 137, .DDLine(0, 1) + 25
            BackBuffer.DrawLine 340, .DDLine(0, 1), 340, .DDLine(0, 1) + 25
            BackBuffer.DrawLine 498, .DDLine(0, 1), 498, .DDLine(0, 1) + 25
            
            PosX = 240
            PosY = 200
            
            subDrawList PosX, PosY, 250, 8, "Map Choice", MapListBox
            
            subDrawList PosX, PosY + 393, 250, 4, "Game Type", GameModeList
            
            subDrawMapProps PosX, PosY
            
            subDrawButton 960, 740, "Back", Event_BackToMulti
            
            subDrawScroller 240, 740, 200, "Max Players", MaxPlayers, 1, 100
            
            subDrawCheckBox 650, 740, "Map Destroyable", MapIsDestroyable
            
            subDrawHudText 350, .DDLine(0, 1) + 3, "Create LAN Game", 2
                        
            subDrawHudText 300, 150, "Server Name:", 2
            With SNameTextBox
                subDrawTextBox 300, 170, 280, .Text, .InUse, .Blink
            End With
            
            subDrawButton 850, 740, "Start Game", Event_StartMulti

        ElseIf .MenuStatus = S_JoinINet Then
        
            BackBuffer.DrawLine .DDLine(1, 0), .DDLine(0, 1) + 22, 340, .DDLine(0, 1) + 22
            BackBuffer.DrawLine .DDLine(1, 0) - 7, .DDLine(0, 1) + 25, 340, .DDLine(0, 1) + 25
            BackBuffer.DrawLine 513, .DDLine(0, 1) + 22, .DDLine(0, 0) - 137, .DDLine(0, 1) + 22
            BackBuffer.DrawLine 513, .DDLine(0, 1) + 25, .DDLine(0, 0) - 137, .DDLine(0, 1) + 25
            BackBuffer.DrawLine 340, .DDLine(0, 1), 340, .DDLine(0, 1) + 25
            BackBuffer.DrawLine 513, .DDLine(0, 1), 513, .DDLine(0, 1) + 25
            
            subDrawServerList 110, 360, 15, "Server Choice", ServerListBox
    
            subDrawButton 300, 740, "Refresh List", Event_RefreshINet
            
            subDrawList 260, 200, 500, 5, "Messages", MessageListBox
            
            '###############################################################################
            If ServerListBox.ListCount > 0 Then subDrawButton 450, 740, "Join Server", Event_JoinINetServer
            '###############################################################################
            
            subDrawButton 960, 740, "Back", Event_BackToMulti
            
            subDrawHudText 350, .DDLine(0, 1) + 3, "Join Internet Server", 2
            
        ElseIf .MenuStatus = S_CreateINet Then
                       
            BackBuffer.DrawLine .DDLine(1, 0), .DDLine(0, 1) + 22, 340, .DDLine(0, 1) + 22
            BackBuffer.DrawLine .DDLine(1, 0) - 7, .DDLine(0, 1) + 25, 340, .DDLine(0, 1) + 25
            BackBuffer.DrawLine 523, .DDLine(0, 1) + 22, .DDLine(0, 0) - 137, .DDLine(0, 1) + 22
            BackBuffer.DrawLine 523, .DDLine(0, 1) + 25, .DDLine(0, 0) - 137, .DDLine(0, 1) + 25
            BackBuffer.DrawLine 340, .DDLine(0, 1), 340, .DDLine(0, 1) + 25
            BackBuffer.DrawLine 523, .DDLine(0, 1), 523, .DDLine(0, 1) + 25
                       
            PosX = 240
            PosY = 200
            
            subDrawList PosX, PosY, 250, 8, "Map Choice", MapListBox
            
            subDrawList PosX, PosY + 393, 250, 4, "Game Type", GameModeList
            
            subDrawMapProps PosX, PosY
            
            subDrawScroller 240, 740, 200, "Max Players", MaxPlayers, 1, 100
            
            subDrawCheckBox 650, 740, "Map Destroyable", MapIsDestroyable
            
            
            subDrawButton 960, 740, "Back", Event_BackToMulti
            
            subDrawHudText 350, .DDLine(0, 1) + 3, "Create Internet Game", 2
           
            subDrawHudText 300, 150, "Server Name:", 2
            With SNameTextBox
                subDrawTextBox 300, 170, 280, .Text, .InUse, .Blink
            End With
           
            subDrawButton 850, 740, "Start Game", Event_StartINet
        End If
        
    End With

End Sub

Public Function OnlineConnection(Optional Connections As Long) As Boolean
  Dim lpcb As Long
  'Dim lpcConnections As Long
  Dim returncode As Long
    
    'Set the structure's size
    lpRasConn(0).dwSize = RAS_RASCONNSIZE
    lpcb = RAS_MAXENTRYNAME * lpRasConn(0).dwSize
    Connections = 0
    
    RasEnumConnections lpRasConn(0), lpcb, Connections
    
    If Connections <> 0 Then OnlineConnection = True
End Function

Public Sub HangUp()
  Dim n As Integer
  Dim lpcConnections As Long
  Dim hRasConn As Long
  
    ' Get number of running connections
    OnlineConnection lpcConnections
    
    ' Hang up
    For n = 0 To lpcConnections - 1
        hRasConn = lpRasConn(n).hRasConn
        RasHangUp hRasConn
    Next n
End Sub


