Attribute VB_Name = "mnu_m15_gravspyLan"
Option Explicit

Public Type TServerList
    IP                              As String * 15
    ServerName                      As String * 20
    CurrentMap                      As String * 20
    PlayerCount                     As Integer
    MaxPlayers                      As Integer
    DateTime                        As String * 20
    GameMode                        As Integer
    MapDestroyable                  As Boolean
End Type
'Public ServerList() As TServerList

'Public ServerCount As Integer


Public Sub subRefreshLANServers(ByRef List As TNetWorkGameList)
    Dim n As Long
    Dim MD As String * 1

    'ServerCount = Rnd * 100

    ServerListBox.Selected = 1
    ServerListBox.Start = 1
    
    ServerCount = List.Count

    If List.Count > 0 Then
        ReDim RunningServer(0 To List.Count - 1)

        For n = 0 To List.Count - 1
            With RunningServer(n)          'nur zum test
                .IP = "?" & GetBroadCast & "?"
                .ServerName = List.Game(n + 1).GameName
                .CurrentMap = "SuperMap"
                .PlayerCount = List.Game(n + 1).CurrentPlayers
                .MaxPlayers = List.Game(n + 1).MaxPlayers
                .DateTime = ""
                .GameType = 1
'                If Rnd * 2 > 1 Then
'                    .MapDestroyable = True
'                    MD = "X"
'                Else
                    .Destroyable = False
                    MD = ""
'                End If

                'ServerListBox.List(n) = .ServerName & " " & .IP & " " & .CurrentMap & " " & .GameMode & " " & MD & " " & .PlayerCount & "/" & .MaxPlayers & " " & .DateTime
                ServerListBox.ListCount = List.Count
            End With
        Next
    Else
        ServerListBox.ListCount = 0
    End If

End Sub




Public Function IsLANServer(ByRef List As TNetWorkGameList)
    Dim n As Long
    Dim MD As String * 1
    
    IsLANServer = False

    'ServerCount = Rnd * 100

    ServerListBox.Selected = 1
    ServerListBox.Start = 1
    
    ServerCount = List.Count

    If List.Count > 0 Then
        ReDim RunningServer(0 To List.Count - 1)

        For n = 0 To List.Count - 1
            With RunningServer(n)          'nur zum test
                .IP = "?" & GetBroadCast & "?"
                .ServerName = List.Game(n + 1).GameName
                .CurrentMap = "SuperMap"
                .PlayerCount = List.Game(n + 1).CurrentPlayers
                .MaxPlayers = List.Game(n + 1).MaxPlayers
                .DateTime = ""
                .GameType = 1
'                If Rnd * 2 > 1 Then
'                    .MapDestroyable = True
'                    MD = "X"
'                Else
                    .Destroyable = False
                    MD = ""
'                End If

                'ServerListBox.List(n) = .ServerName & " " & .IP & " " & .CurrentMap & " " & .GameMode & " " & MD & " " & .PlayerCount & "/" & .MaxPlayers & " " & .DateTime
                ServerListBox.ListCount = List.Count
            End With
        Next
    Else
        ServerListBox.ListCount = 0
    End If
    
    If List.Count > 0 Then
        If List.Count >= ServerListBox.Selected Then IsLANServer = True
    End If
 
End Function

